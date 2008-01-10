From: Jeff Garzik <jeff@garzik.org>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 09 Jan 2008 23:47:50 -0500
Message-ID: <4785A376.5050408@garzik.org>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de> <4785304A.60109@gmail.com> <20080109205850.GU16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60008 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519AbYAJEsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jan 2008 23:48:08 -0500
In-Reply-To: <20080109205850.GU16309@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jon Watte <jwatte@gmail.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Jan 09, 2008 at 12:36:26PM -0800, Jon Watte wrote:
>> Stefan Richter wrote:
>>>> Those systems (servers) typically have enough memory to tolerate a few
>>>> extra KB of code without problems.  In fact most PCs these days have.
>>>>    
>>> It would be a stupid solution nevertheless.
>>>
>>> (We also don't "select EXT3".)
>>>  
>> Not selecting EXT3 is a little more understandable, because there are 
>> many options -- cramfs, xfs, reiserfs, etc, depending on target. 
>> However, the number of people who DO want SATA support but DO NOT want 
>> SD block device support is... uh.. anyone?
>>
>> Solving the problem bigger and better, by factoring "SD" into a 
>> mid-level menu, and maybe calling it something non-SCSI, would probably 
>> be even better. And even more work.
> 
> OK, how about this?
> 
> config BLK_DEV_ATA_SD
> 	tristate "ATA disc support"
> 	select BLK_DEV_SD
> 
> config BLK_DEV_ATA_SR
> 	tristate "ATA CDROM support"
> 	select BLK_DEV_SR
> 
> Help text left as an exercise for the reader.

Speaking as one who strongly objects to CONFIG_ATA unconditionally 
selecting SD or SR...

I think you are on the right track.  IMO a more clean and future-proof 
solution would be

	config ATA_PROT_ATA
		select SD

	config ATA_PROT_ATAPI (or ATAPI_PROT)
		select SR

But that's just an example.  Maybe the choices could be ATA_DISK and 
ATA_EVERYTHING_ELSE.  :)  The main points are

* its not just CDROM support, but floppy/tape/etc. too for ATAPI

* do not include "sd" or "sr" in the config name, it should be more 
generic, because SCSI will eventually be an optional module for libata. 
  When libata talks to straight blkdev, we don't want this same problem 
to resurface!

	Jeff (very tired, so pardon any incoherence)






