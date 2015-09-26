From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Sat, 26 Sep 2015 15:57:03 +0930
Message-ID: <56063AB7.9030309@internode.on.net>
References: <20150916134211.GA21535@infradead.org> <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com> <5601D550.5000801@internode.on.net> <1442961929.15264.4.camel@HansenPartnership.com> <5601E5FE.7020706@internode.on.net> <56023771.5010006@linux.intel.com> <5602829C.5090500@internode.on.net> <1443019207.2240.27.camel@HansenPartnership.com> <56037C09.5050201@linux.intel.com> <560390A1.5060503@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <560390A1.5060503@internode.on.net>
Sender: linux-pci-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org



Arthur Marsh wrote on 24/09/15 15:26:
>
>
> Jiang Liu wrote on 24/09/15 13:58:
>
>> Hi James,
>>     Thanks for review. How about the attached patch which addresses
>> the three suggestions from you?
>> Thanks!
>> Gerry
>
> I've applied the patch, rebuilt the kernel and verified that it allows
> unloading of the eata module and reloading it, as well as a successful
> kexec.
>
> Regards,
>
> Arthur.

After some more thorough testing I've encountered an ongoing problem 
trying to use kexec with filesystems mounted with the eata driver.

If I boot up and have the eata driver loaded but no filesystem check or 
mounting of filesystems on the disk attached to the DPT2044W controller, 
then attempt a kexec reboot I get the reboot pausing after the 
"synchronizing scsi cache" messages and getting the errors that I have 
included as pictures in my previous reports.

If I do a normal boot which includes eata being loaded, the disk 
attached to the DPT2044W controller having its filesystems checked and 
mounted, then attempt a kexec reboot, I get the reboot pausing after the 
"synchronizing SCSI cache" messages as before.

If I un-mount the filesystems on the disk attached to the DPT2044W 
controller after start-up and try a reboot I get the same problem.

If I do modprobe -r eata after un-mounting the filesystems on the disk 
attached to the DPT2044W controller after a start-up kexec *works fine*.

If I do:

start-up
un-mount filesystems on disk attached to DPT2044W controller
modprobe -r eata
modprobe eata
fsck -a of filesystems on disk attached to DPT2044W controller
mount filesystems

then a kexec reboot works fine.

I did some more experimenting and found a workaround:

I was unable to blacklist the eata module but if I did:

modprobe -r eata
modprobe eata

in a cron job before the fsck and mount commands then
I could then perform a kexec reboot successfully.

I also verified that if I did:

modprobe -r eata

after eata was loaded on boot-up without any fsck or mounting of 
filesystems on the disk attached to the DPT2044W controller using the 
eata the kexec reboot worked fine.

In summary:

if eata is loaded kexec reboot will fail unless a modprobe -r eata is 
done either manually or by a cron job.

if a modprobe -r eata has been done, then even if I modprobe eata and 
fsck and mount filesystems, kexec reboot works.

Any suggestions for further tests or checks welcome.

Arthur.
