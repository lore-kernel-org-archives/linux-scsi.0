From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 23:12:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824221258.GD16196@parcelfarce.linux.theplanet.co.uk>
References: <20040824205039.GC16196@parcelfarce.linux.theplanet.co.uk> <200408242139.i7OLd1jE003353@bach.leonora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41391 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268526AbUHXWNB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 18:13:01 -0400
Content-Disposition: inline
In-Reply-To: <200408242139.i7OLd1jE003353@bach.leonora.org>
List-Id: linux-scsi@vger.kernel.org
To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Cc: Matthew Wilcox <willy@debian.org>, Mike Anderson <andmike@us.ibm.com>, Olaf Hering <olh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

On Tue, Aug 24, 2004 at 02:39:01PM -0700, Vladimir G. Ivanovic wrote:
> Sorry. The words "mismatch" and "reset" suggest (to me) that a problem
> exists

sym2 has always displayed these messages at boot:

   kernel: sym0: handling phase mismatch from SCRIPTS.
   kernel: sym0: SCSI BUS has been reset.

The first one means "If there is a phase mismatch, we'll handle it in
the SCRIPTS rather than in the driver".  The second one is a normal part
of bringup.  Now, I'm all in favour of reducing driver verbosity at boot,
but I'm not sure I can delete either of those messages at this stage.
It's certainly something I want to look at doing.

> , and I'm extra sensitive to SCSI problems because of unresolved
> problems like this (at boot):
> 
>    smartd[1831]: Opened configuration file /etc/smartd.conf 
>    smartd[1831]: Configuration file /etc/smartd.conf parsed. 
>    smartd[1831]: Device: /dev/hdc, opened 
>    smartd[1831]: Device: /dev/hdc, not found in smartd database. 
>    smartd[1831]: Device: /dev/hdc, is SMART capable. Adding to "monitor" list. 
>    smartd[1831]: Device: /dev/hdg, opened 
>    smartd[1831]: Device: /dev/hdg, not found in smartd database. 
>    smartd[1831]: Device: /dev/hdg, is SMART capable. Adding to "monitor" list. 
>    smartd[1831]: Device: /dev/sda, opened 
>    smartd[1831]: Device: /dev/sda, is SMART capable. Adding to "monitor" list. 
>    kernel: sym0:6:0:ODD transfer in DATA IN phase.
>    kernel: sym0:6:0:COMMAND FAILED (87 0 10).
>    kernel: sym0:6:0:ODD transfer in DATA IN phase.
>    kernel: sym0:6:0:COMMAND FAILED (87 0 10).
>    kernel: sym0:6:0:ODD transfer in DATA IN phase.
>    kernel: sym0:6:0:COMMAND FAILED (87 0 10).
>    kernel: sym0:6:0:ODD transfer in DATA IN phase.
>    kernel: sym0:6:0:COMMAND FAILED (87 0 10).
>    kernel: sym0:6:0:ODD transfer in DATA IN phase.
>    kernel: sym0:6:0:COMMAND FAILED (87 0 10).
>    smartd[1831]: Monitoring 2 ATA and 1 SCSI devices 
>    smartd[1831]: Device: /dev/sda, initial Temperature is 33 degrees 
>    smartd[1833]: smartd has fork()ed into background mode. New PID=1833. 
>    smartd: smartd startup succeeded
> 
> or this (at seemingly random times after booting):
> 
>    kernel: sym0:6:0:ordered tag forced.
>    last message repeated 4 times
>    kernel: sym0:6:0:ordered tag forced.
>    last message repeated 3 times
>    last message repeated 29 times
>    last message repeated 5 times
> 
> or this (which causes my system to hang):
> 
>    kernel: sym0:6: ERROR (81:0) (8-0-0) (3e/18/80) @ (scripta 38:f31c0004).
>    kernel: sym0: script cmd = e21c0004
>    kernel: sym0: regdump: da 00 00 18 47 3e 06 0f 04 08 86 00 80 00 0f 0a 72 cf 0c 00 02 00 00 00.
>    kernel: sym0: SCSI BUS reset detected.
>    kernel: sym0: enabling clock multiplier
>    kernel: sym0: Downloading SCSI SCRIPTS.
>    kernel: sym0: SCSI BUS has been reset.
>    kernel: sym0: command processing suspended for 3 seconds
>    kernel: sym0: command processing resumed

umm.  The first and second ones don't seem too bad.  The third one looks
like it needs some investigation though.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
