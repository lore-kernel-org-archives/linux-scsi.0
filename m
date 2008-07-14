From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] advansys: use request_firmware
Date: Mon, 14 Jul 2008 08:50:34 -0600
Message-ID: <20080714145033.GD14894@parisc-linux.org>
References: <1215770322.2733.12.camel@jaswinder.satnam> <20080712162921.GZ14894@parisc-linux.org> <1215882548.19076.57.camel@jaswinder.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60773 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbYGNOuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2008 10:50:50 -0400
Content-Disposition: inline
In-Reply-To: <1215882548.19076.57.camel@jaswinder.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, kernel-janitors <kernel-janitors@vger.kernel.org>, kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org, hch@infradead.org

On Sat, Jul 12, 2008 at 10:39:08PM +0530, Jaswinder Singh wrote:
> Sorry, It should be :-
> +       if (AscLoadMicroCode(iop_base, 0, &fw->data[4],
> +                            fw->size - 4) != chksum) {
>                 asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
> +               release_firmware(fw);
>                 return warn_code;
>         }
> +       release_firmware(fw);
>         warn_code |= AscInitMicroCodeVar(asc_dvc);

OK, makes sense.

> > You're calling release_firmware() here.  I don't know if that actually
> > frees the firmware when it's built-in, but if it does, then freeing the
> > firmware could cause the chip to stop working if it gets reset before
> > userspace is up.
> 
> Normally release_firmware will be called after loading microcode.
> 
> Even it gets reset then It will again call request_firmware and load
> firmware and then frees after loading microcode.
> 
> Logically it will work same as microcode_buffer say _adv_asc3550_buf[]
> when you need to load microcode you just read from ???_adv_asc3550_buf[]
> and load it. And if reset occurs you again read from ???_adv_asc3550_buf[]
> and then load microcode, but you keep ???_adv_asc3550_buf[] all the time
> in memory.
> In our case we just request_firmware when need to load microcode and
> release_firmware after loading. So we frees the memory after loading
> microcode.
> 
> So it will not stop the chip from working.

I'm not quite sure whether my question was answered ...

When firmware is built in, does
1) request_firmware() make a copy of it and then release_firmware free
   that copy?
2) request_firmware() return a pointer to the built-in firmware with
   release_firmware() being a no-op?
3) request_firmware() return a pointer to the built-in firmware with
   release_firmware() freeing the original?

Cases 1 and 2 are fine, case 3 is a problem.

By the way:

+Driver: SCSI_ADVANSYS - AdvanSys SCSI
+
+File: advansys/mcode.bin 
+File: advansys/3550.bin 
+File: advansys/38C0800.bin 
+File: advansys/38C1600.bin 
+
+Licence: Allegedly GPLv2+, but no source visible.
+
+Found in hex form in kernel source.

I haven't modified the firmware at all (how could I?  ;-) since the
version in, say, 2.6.20 which was licensed under GPL or BSD.  You could
take the firmware from there under the BSD license without any legal
trouble from me.  IANAL, but this seems correct to me.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
