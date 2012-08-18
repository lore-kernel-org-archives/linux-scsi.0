From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Sun, 19 Aug 2012 02:52:47 +0300
Message-ID: <20120818235247.GO19851@reaktio.net>
References: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:42584 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751134Ab2HSAlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Aug 2012 20:41:31 -0400
Received: from smtp.tele.fi (smtp.tele.fi [192.89.123.25])
	by vulpes-int.media.sonera.net (Postfix) with ESMTP id 2B8DC2583
	for <linux-scsi@vger.kernel.org>; Sun, 19 Aug 2012 02:53:10 +0300 (EEST)
Content-Disposition: inline
In-Reply-To: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rich <rercola@pha.jhu.edu>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 03, 2012 at 09:54:58PM -0400, Rich wrote:
> [My apologies if this is the wrong mailing list for this, but it
> seemed to be the most relevant. Please direct me elsewhere and discard
> if this is OT.]
> 

This is a perfectly fine list, hopefully :)

> Hi all,
>

Hello,

> I've been beating my head against SGPIO for a bit now, and I can't
> tell if I'm just misreading SFF-8485, or this backplane is just not
> doing something sane.
> 

I've been struggling with SGPIO LED control aswell! 

> I have here a Supermicro X8DAH-F+ with a backplane of model
> BPN-SAS-836A - which means it has 3 MG9072 controller chips on it.
> Supports speaking in-band or out-of-band to read data, control lights,
> &c.
> 
> With two LSI 9201-16i HBA attached, manipulating it via
> /dev/bsg/sas_hostN and smp_utils 0.97, SFF-8485 section 8.4.4 seems to
> think that changing this:
>  00     41 02 00 00 a0 a0 a0 a0  a0 a0 a0 a0 a0 a0 a0 a0
>  10     a0 a0 a0 a0 00 00 00 00  00 00 00 00 00 00 00 00
>  20     00 00 00 00
> 
> By doing this:
> # smp_write_gpio -d a1,a0,a0,a0 -t 3 -i 0 -c /dev/bsg/sas_hostN
> 
> Resulting in:
>  00     41 02 00 00 a1 a0 a0 a0  a0 a0 a0 a0 a0 a0 a0 a0
>  10     a0 a0 a0 a0 00 00 00 00  00 00 00 00 00 00 00 00
>  20     00 00 00 00
> 
> Should enable a single drive's fault LED (drive m+3, by spec above).
> 

Wow, I've been trying to figure out how to control SGPIO from Linux,
and for some reason I didn't find anything about smp_write_gpio earlier.

I need to try that. Thanks a lot for this information! :)

(earlier I tried getting LSI sas2ircu to do something clever 
with the LEDS but that didn't work at all - I guess LSI only supports 
SGPIO LED control in IR mode - not IT mode).


> In practice, I am in possession of ~90 identical machines, and on
> every single one, this controls the fault LED on 3 drives - I have 3
> SAS ports wired to the backplane (via iPASS cable) per HBA, so I would
> suspect the HBA of setting bit m+3 on each SAS port [and having each
> of its three ports running to an input controlled by a different SGPIO
> controller on the backplane]. No permutation of the register bits
> beyond the 4 bytes at index 0 changes the behavior of the LEDs that I
> can see, and the output in the beginning [a0 a0 ... 00 00 00 00] is
> what is returned on clean cold boot of the machine.
> 
> In contrast, when I have an LSI 9240-8i attached, I can control
> per-drive LEDs, though the mechanism it uses for this is opaque to me
> (the megaraid_sas driver doesn't expose a virtual SAS host port like
> mpt2sas, so I am manipulating this using LSI's closed-source MegaCli
> blob); so I know it is possible, through some method, to control
> per-drive LEDs.
> 
> I cannot tell, however, whether I am using smp_write_gpio incorrectly
> (either by misreading the spec or somehow abusing the virtual SAS
> port), or it's a bug somewhere (be it in smp_write_gpio, the kernel,
> the HBA firmware, or the upstream MG9072's firmware, that is somehow
> magically avoided by the 9240-8i), and there is almost no public
> documentation of people using smp_write_gpio.
> 
> I've tried this with kernel 2.6.32-220.7.1.el6, 3.4.4, and 3.5.0-rc5
> (the last because it includes mpt2sas 13.XX.XX.XX, while 3.4.4 has
> 12.XX.XX.XX, and I was curious if anything had changed), and smp_utils
> 0.97.
> 
> I wanted to see what the register state was when the 9240-8i was in
> use, but I couldn't coax the megaraid_sas driver into disgorging this
> information, and upon unplugging the iPASS cable from the backplane to
> connect it to the HBA, the backplane appears to reset its internal
> state; the LEDs cease blinking in any pattern, and consequent querying
> with the HBA returns expected default initial state.
> 
> Am I insane, or is this backplane crazy? Does anyone have any
> experience with cajoling such things into submission?
> 

Hmm, I have some servers with LSI 9211-8i SAS2 HBAs (mpt2sas driver) 
and Supermicro BPN-SAS-846A backplanes, which have 3x MG9072 chips in them.

I'll let you know how that stuff works for me!

Thanks,

-- Pasi

