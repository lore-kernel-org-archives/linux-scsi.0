From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Thu, 2 Dec 2010 18:41:17 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1012021823420.9213@kai.makisara.local>
References: <1290971729.2814.13.camel@larosa>  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>  <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>  <alpine.LNX.2.00.1011301813460.9731@kai.makisara.local> <1291223211.2814.72.camel@larosa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs12.mail.saunalahti.fi ([195.197.172.107]:58797 "EHLO
	vs12.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab0LBQlW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 11:41:22 -0500
In-Reply-To: <1291223211.2814.72.camel@larosa>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@lsi.com>

On Wed, 1 Dec 2010, Lukas Kolbe wrote:

> Am Dienstag, den 30.11.2010, 18:20 +0200 schrieb Kai Makisara:
> 
...
> > If you see error with 64 kB block size, I would like to see any messages 
> > associated with these errors.
> 
> I have now hit this bug again. Trying to read and write a label from the
> tape drive in question results in this (via bacula's btape command):
> 
> *readlabel
> 01-Dec 17:47 btape JobId 0: Error: block.c:1002 Read error on fd=3 at
> file:blk 0:0 on device "drv1" (/dev/nst1). ERR=Value too large for
> defined data type.
> btape: btape.c:525 Volume has no label.
> 
> Volume Label:
> Id                : **error**VerNo             : 0
> VolName           :
> PrevVolName       :
> VolFile           : 0
> LabelType         : Unknown 0
> LabelSize         : 0
> PoolName          :
> MediaType         :
> PoolType          :
> HostName          :
> Date label written: -4712-01-01 at 00:00
> *label
> Enter Volume Name: AAA543
> 01-Dec 17:47 btape JobId 0: Error: block.c:577 Write error at 0:0 on
> device "drv1" (/dev/nst1). ERR=Input/output error.
> 01-Dec 17:48 btape JobId 0: Error: Backspace record at EOT failed.
> ERR=Input/output error
> Wrote Volume label for volume "AAA543".
> 
> dmesg says (as expected): 
> 
> [158529.011206] st1: Can't allocate 2097152 byte tape buffer.
> [158544.348411] st: append_to_buffer offset overflow.
> [158544.348416] st: append_to_buffer offset overflow.
> [158544.348418] st: append_to_buffer offset overflow.
> [158544.348419] st: append_to_buffer offset overflow.
> 
The messages except the first one are something that should never happen. 
I think that there is something wrong with returning from enlarge_buffer() 
when it fails. I will look at this when I have time.

...
> Trying to write to the tape looks like below, which seems to match your
> earlier description; ie 64/65k works, 128k blocksize works, 256k
> blocksize and above don't work anymore. I wasn't able to reproduce not
> being able to write with a 64k blocksize at the moment.
> 
Assuming that the MPT driver is configured for 128 segments, you should 
always be able to read and write 512 kB blocks.

...
> I hope this somehow helps,
> Lukas
> 
These messages are helpful.

Thanks,
Kai

