From: Eric Kerin <eric@bootseg.com>
Subject: Re: Kernel oops in 2.6.1 when loading aha152x_cs.ko
Date: Sat, 10 Jan 2004 14:11:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073761884.6434.12.camel@opiate>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
	 <1073698638.2026.3.camel@opiate>
	 <6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com>
	 <1073716698.2026.18.camel@opiate>  <1073747000.1945.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf26.cluster1.charter.net ([209.225.28.226]:44818 "EHLO
	mxsf26.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S265331AbUAJTWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 14:22:41 -0500
In-Reply-To: <1073747000.1945.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Larry W. Finger" <Larry.Finger@lwfinger.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Yes, I agree the best place to put that block of code would have been
aha152x_stub.c, but I couldn't find an existing way to reference the
driver template from that file. The "s" struct is a aha152x_setup, not a
aha152x_driver_template. That's why I put it in aha152x.c with an ifdef

I could setup aha152x_driver_template as an extern, but since I'm still
somewhat new around here, wasn't sure if that was a good way to handle
it.  If an extern is fine with you, I'll code it up that way. Although
in that case, it would be best to put the INIT_LIST_HEAD in module_init.
That's where it would normally be done, and we would have a reference at
that point.

Eric


On Sat, 2004-01-10 at 10:03, James Bottomley wrote:
> On Sat, 2004-01-10 at 01:38, Eric Kerin wrote:
> > Let's try this again, with the proper check. This one even compiles!
> 
> Actually, you're still on slightly the wrong track.  The quick fix, as I
> told Russell on this list is in aha152x_stub.c.
> 
> If you want to code that up as a patch and test it, I'll apply it.
> 
> James
> 
> 
> ______________________________________________________________________
> From: James Bottomley <James.Bottomley@steeleye.com>
> To: Russell King <rmk@arm.linux.org.uk>
> Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>
> Subject: Re: Fwd: Kernel Oops with Adaptec 1460D (PCMCIA SCSI-Controller) and Kernel 2.6.0
> Date: Thu, 08 Jan 2004 13:05:40 -0500
> 
> On Thu, 2004-01-08 at 06:29, Russell King wrote:
> > Could someone look into this - it seems that it's more of a scsi
> > bug than a pcmcia bug.
> 
> The problem seems to be this code in aha152x.c:
> 
> #ifndef PCMCIA
> #define driver_template aha152x_driver_template
> #include "scsi_module.c"
> #endif
> 
> Since it's still behaving as a legacy driver (by calling
> register_scsi()), it needs the aha152x_driver_template.legacy_hosts list
> initialised (which is done in scsi_module.c).
> 
> The true fix would be to convert aha152x to the new API.  However, a
> quick fix is probably to add
> 
> 	INIT_LIST_HEAD(&s.legacy_hosts);
> 
> just before the call to aha152x_probe_one() in aha152x_stub.c
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

