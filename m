From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Sat, 11 Feb 2006 22:06:54 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
References: <20060211011457.GA1839@igloo.df.lth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:19654 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932354AbWBKVGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Feb 2006 16:06:44 -0500
In-Reply-To: <20060211011457.GA1839@igloo.df.lth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

On Sat, 11 Feb 2006, Fredrik Roubert wrote:

> Hi!
> 
> I just connected my old HP ScanJet 4c to my new DC315U SCSI adapter
> (connected to an ASRock 939Dual-SATA2 motherboard with AMD Athlon 64 X2)
> and tried using the dc395x kernel module with Linux 2.6.15 and scan an
> image using xscanimage.
> 
> Sometimes it works, but sometimes xscanimage hangs for a long time and
> then aborts with a message about I/O error. When that happends, the
> following is printed in the dmesg output:
> 
> drivers/scsi/dc395x.c: Please, contact <linux-scsi@vger.kernel.org> to help improve support for your system.
> dc395x: reselect: w/o disconnected cmds <02-0>
> dc395x: disconnect: Unexpected reselection <02-0>

Wow! Youppy-yey! It worked!!:-)) Oh, how I waited for this email!:-)

Ok, making a long story short - you run into a VERY (I think) rare 
situation when you controller doesn't transfer all the data per DMA and 
the driver tries to transfer the rest in PIO mode. And this mode is 
currently broken. We know that, but because noone could reproduce such a 
situation, we couldn't test any fixes. So, I just suggested to put this 
request in the driver and hope that the person with such a setup will 
indeed notice it and write to the list and will also help debug possible 
fixes for this situation.

...and your 64-bit dual-core CPU makes it even more fun. On the other 
hand, it means we won't be able to test it on highmem... Unless you agree 
to swap it to a 32-bit machine for a test:-)

Now, I hada patch for this. I just have to dig it out, re-diff it against 
2.6.15 and send to you. One warning - while debugging we might crash your 
machine a couple of times, perhaps corrupt some data... Do you have, 
maybe, a test machine without important data on it for first tests, or at 
least, backup all your valuables. You've been warned:-)

> So, what can I do to help you resolve this? (I'm familiar with kernel
> programming, in case you need me to check something "complicated".)

Unless you want to dig out my patch from list-archives and start testing 
it yourself, please wait until I send you an updated patch. Don't worry, 
it will be "complicated" enough:-)

Thanks
Guennadi
---
Guennadi Liakhovetski
