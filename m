From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: drivers/scsi/st.c:2967: warning: suggest parentheses around operand
	of '!' or change '|' to '||' or '!' to '~'
Date: Tue, 5 May 2009 10:38:10 +0200
Message-ID: <18943.64242.208899.90833@pilspetsen.it.uu.se>
References: <10f740e80905050051q37524c4dv5d33b501b704b3b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aun.it.uu.se ([130.238.12.36]:51030 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758520AbZEEIiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 May 2009 04:38:21 -0400
In-Reply-To: <10f740e80905050051q37524c4dv5d33b501b704b3b0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Geert Uytterhoeven writes:
 > drivers/scsi/st.c:2967: warning: suggest parentheses around operand of
 > '!' or change '|' to '||' or '!' to '~'
 > 
 >         if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
 >             !(STp->use_pf & PF_TESTED)) {
 >                 /* Try the other possible state of Page Format if not
 >                    already tried */
 >                 STp->use_pf = !STp->use_pf | PF_TESTED;
 >                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 >                 st_release_request(SRpnt);
 >                 SRpnt = NULL;
 >                 return st_int_ioctl(STp, cmd_in, arg);
 >         }
 > 
 > Looks indeed incorrect to me...

I noticed that too yesterday. I believe the intention is

	STp->use_pf = (!STp->use_pf) | PF_TESTED;

which in this case (PF_TESTED is clear) is the same as

	STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;

which matches the comment, or

	STp->use_pf ^= (USE_PF | PF_TESTED);

if you want to micro-optimize.
