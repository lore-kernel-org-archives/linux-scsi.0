From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic94xx panic on module insertion
Date: Mon, 10 Jul 2006 12:25:24 -0400
Message-ID: <44B27F74.9000806@torque.net>
References: <1152541373.7275.11.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:16589 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422682AbWGJQZx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 12:25:53 -0400
Received: from toronto-hse-ppp4083475.sympatico.ca ([70.50.95.111] helo=[192.168.1.100])
	by pentafluge.infradead.org with esmtpsa (Exim 4.62 #1 (Red Hat Linux))
	id 1Fzya0-0002oG-BH
	for linux-scsi@vger.kernel.org; Mon, 10 Jul 2006 17:25:52 +0100
In-Reply-To: <1152541373.7275.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> I got this one again over the weekend:
> 
> aic94xx: max_scbs:512, max_ddbs:128
> aic94xx: setting phy0 addr to 50000d100001cae0
> aic94xx: setting phy1 addr to 50000d100001cae0
> aic94xx: setting phy2 addr to 50000d100001cae0
> aic94xx: setting phy3 addr to 50000d100001cae0
> aic94xx: setting phy4 addr to 50000d100001cae0
> aic94xx: setting phy5 addr to 50000d100001cae0
> aic94xx: setting phy6 addr to 50000d100001cae0
> aic94xx: setting phy7 addr to 50000d100001cae0
> aic94xx: num_edbs:21
> aic94xx: num_escbs:3
> aic94xx: using sequencer Razor_10a1

These comments have no direct bearing on the panic that
James is reporting, but ... that sequencer version:
"Razor_10a1" is old and should be updated.

With a 48300 adapter I needed to do two things:
  [a] update the board's BIOS firmware from build 1618
      to 1705 (20060421) [See adaptec's site]
  [b] update the linux driver's copy of the sequencer
      code (in my case from Razor_10c2 to Razor_10c5b)

My card needed [a] to stabilize the POST and device scan
that the 48300 does prior to the OS loading. Once the
aic94xx driver is loaded, it replaces the running version
of the sequencer code with its own copy. If the reader
sees numerous "tmf timeout" messages in their log then
there is a good chance old sequencer code is the cause.

Doug Gilbert
