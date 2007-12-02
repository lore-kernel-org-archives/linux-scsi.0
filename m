From: Michael Cree <mcree@orcon.net.nz>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Mon, 3 Dec 2007 09:53:53 +1300
Message-ID: <6A73BEE8-9D45-4B75-8756-3008A4B1FDF4@orcon.net.nz>
References: <20071126134819.8FE56DBA2@gherkin.frus.com> <47508EE9.9030304@orcon.net.nz> <20071130144250.e89335f3.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756804AbXLBUyu@vger.kernel.org>
In-Reply-To: <20071130144250.e89335f3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rct@gherkin.frus.com, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

On 1/12/2007, at 11:42 AM, Andrew Morton wrote:
> On Sat, 01 Dec 2007 11:30:01 +1300
> Michael Cree <mcree@orcon.net.nz> wrote:
>
>> Bob Tracy wrote:
>>> Andrew Morton wrote:
>>>> Could be something change in sysfs.  Please double-check the config
>>>> options, make sure that something important didn't get disabled.
>>>>
>>>  Here's
>>> hoping someone else is seeing this or can replicate it in the  
>>> meantime.
>>
>> Snap.
>>
>> 2.6.24-rc2 works fine.   2.6.24-rc3 boots on Alpha but once /dev is
>> populated no partitions of the scsi sub-system are seen.  Looks  
>> like ide
>> sub-system similarly affected.

[snip]

>> eth0: Digital DS21142/43 Tulip rev 65 at Port 0x200009400,
>> 08:00:2b:87:4c:b0, IRQ 45.
>> Linux video capture interface: v2.00
>> scsi_id[402]: scsi_id: unable to access '/block'
>
> I guess this is where things go bad.

Yes, that is what I thought too.

> scsi_id is part of udev.  Perhaps some sysfs nodes aren't being  
> created
> correctly.
>
> Random guess: what is your setting of CONFIG_SCSI_SCAN_ASYNC and what
> happens if you invert it?

Is set to Y.  Changed it to N and recompiled kernel and restarted.   
No change.  Same problems remain.

I now realise that not only SCSI drive device nodes are not appearing  
in /dev, but all disc nodes are not appearing.

In my case all of fd0, hde (IDE disc), hdf (CD/DVD), sda (SCSI disc),  
sdb (SATA disc), sdc (memory card reader), and their accompanying  
partition nodes, do not get made in /dev.

I'm not familiar with sysfs so don't know what what I should be  
looking for in particular, but I did have a quick noisy around /sys  
and noted that the above mentioned devices are all appearing at /sys/ 
block with what appeared to be sensible information in the  
subdirectories thereof.

Sorry, but it is unlikely that I'll be able to look further into this  
problem at the moment as I am running a conference this week and the  
storm is about to hit...

Cheers
Michael.

