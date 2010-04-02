From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 02 Apr 2010 12:21:09 -0400
Message-ID: <4BB61975.1070406@interlog.com>
References: <Pine.LNX.4.44L0.1004021114160.1615-100000@iolanthe.rowland.org> <4BB61237.5030000@ru.mvista.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BB61237.5030000@ru.mvista.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@suse.de>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, mlord@pobox.com
List-Id: linux-scsi@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Alan Stern wrote:
> 
>>>> Best guess (and it's a guess only) would be that the USB bridge SAT
>>>> layer doesn't implement ATA_16 and so fails in interesting ways when it
>>>> comes in.  Does the ATA_12 version of IDENTIFY DEVICE succeed?
>>>>       
>>> It does.  And in between the two is an ATA_16 SET FEATURES command
>>> which also (apparently) succeeds.  That is, there is no error
>>> indication from the device -- but goodness knows if it actually carries
>>> out the command.
>>>     
>>
>> Incidentally, there's a discussion of this problem with input from an
>> engineer at the company that makes the bridge chip here:
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux-fsl-imx51/+bug/431963
>>
>> See comment #25 and later.  He claims that the ATA pass-through command
>> contains a SECTOR COUNT field of 0 even though it asks for 512 bytes of
>> IDENTIFY data.  This invalid parameter combination causes the bridge
>> chip to get confused, and instead of failing gracefully, it messes up
>> the USB protocol.
>>   
> 
>   IDENTIFY DEVICE command always returns 512 bytes of data, regardless 
> of any value in the sector count register.
> 
>> Does anybody know where to find out why hdparm is sending an IDENTIFY 
>> command with invalid parameters?
>>   
> 
>   IDENTIFY DEVICE command has *no* parameters.

Confirming that, what is put in the ATA_16 sector
count field is what the ATA command (IDENTIFY DEVICE)
expects in its count field. And according to ACS-2 (rev 2)
for IDENTIFY DEVICE that is "N/A" which I would
interpret as zero.

Mark Lord is the author of hdparm and I have added
him to the cc list.

Using SAT that IDENTIFY DEVICE response can be obtained
in one of three ways:
   - the SCSI ATA PASS-THROUGH(12) command
   - the SCSI ATA PASS-THROUGH(16) command
   - SCSI ATA Information VPD page (89h)

The latter can be fetched via a SCSI INQUIRY command.
Now vendors can screw up on any or all of the above
ways. I would like to suggest to Mark to have some
way of using the VPD page technique with hdparm.

The idea of SAT is to use the SCSI equivalent command
and then, as a last resort, use the ATA PASS-THROUGH
commands. A really good SAT implementation might
block the pass-through commands (they are optional).

Doug Gilbert



