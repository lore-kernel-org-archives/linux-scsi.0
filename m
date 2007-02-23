From: Ric Wheeler <ric@emc.com>
Subject: end to end error recovery musings
Date: Fri, 23 Feb 2007 09:15:11 -0500
Message-ID: <45DEF6EF.3020509@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>Mark Lord <mlord@pobox.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

In the IO/FS workshop, one idea we kicked around is the need to provide 
better and more specific error messages between the IO stack and the 
file system layer.

My group has been working to stabilize a relatively up to date libata + 
MD based box, so I can try to lay out at least one "appliance like" 
typical configuration to help frame the issue. We are working on a 
relatively large appliance, but you can buy similar home appliance (or 
build them) that use linux to provide a NAS in a box for end users.

The use case that we have is on an ICH6R/AHCI box with 4 large (500+ GB) 
drives, with some of the small system partitions on a 4-way RAID1 
device. The libata version we have is back port of 2.6.18 onto SLES10, 
so the error handling at the libata level is a huge improvement over 
what we had before.

Each box has a watchdog timer that can be set to fire after at most 2 
minutes.

(We have a second flavor of this box with an ICH5 and P-ATA drives using 
the non-libata drivers that has a similar use case).

Using the patches that Mark sent around recently for error injection, we 
inject media errors into one or more drives and try to see how smoothly 
error handling runs and, importantly, whether or not the error handling 
will complete before the watchdog fires and reboots the box.  If you 
want to be especially mean, inject errors into the RAID superblocks on 3 
out of the 4 drives.

We still have the following challenges:

    (1) read-ahead often means that we will  retry every bad sector at 
least twice from the file system level. The first time, the fs read 
ahead request triggers a speculative read that includes the bad sector 
(triggering the error handling mechanisms) right before the real 
application triggers a read does the same thing.  Not sure what the 
answer is here since read-ahead is obviously a huge win in the normal case.

    (2) the patches that were floating around on how to make sure that 
we effectively handle single sector errors in a large IO request are 
critical. On one hand, we want to combine adjacent IO requests into 
larger IO's whenever possible. On the other hand, when the combined IO 
fails, we need to isolate the error to the correct range, avoid 
reissuing a request that touches that sector again and communicate up 
the stack to file system/MD what really failed.  All of this needs to 
complete in tens of seconds, not multiple minutes.

    (3) The timeout values on the failed IO's need to be tuned well (as 
was discussed in an earlier linux-ide thread). We cannot afford to hang 
for 30 seconds, especially in the MD case, since you might need to fail 
more than one device for a single IO.  Prompt error prorogation (say 
that 4 times quickly!) can allow MD to mask the underlying errors as you 
would hope, hanging on too long will almost certainly cause a watchdog 
reboot...

    (4) The newish libata+SCSI stack is pretty good at handling disk 
errors, but adding in MD actually can reduce the reliability of your 
system unless you tune the error handling correctly.

We will follow up with specific issues as they arise, but I wanted to 
lay out a use case that can help frame part of the discussion.  I also 
want to encourage people to inject real disk errors with the Mark 
patches so we can share the pain ;-)

ric



