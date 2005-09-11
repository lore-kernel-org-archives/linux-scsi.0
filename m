From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2.6.13 2/14] sas-class: README
Date: Sun, 11 Sep 2005 11:44:54 +1000
Message-ID: <43238C16.4010709@torque.net>
References: <4321E4DD.7070405@adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:12681 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932742AbVIKBoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 21:44:34 -0400
In-Reply-To: <4321E4DD.7070405@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

<snip>

An interesting document. I have a small quibble here (and a larger
one about the SMP user space access that I will elaborate on
in a day or so).

> +Port events, passed on a _phy_:
> +	PORTE_BYTES_DMAED,      (M)
> +	PORTE_BROADCAST_RCVD,   (E)
> +	PORTE_LINK_RESET_ERR,   (C)
> +	PORTE_TIMER_EVENT,      (C)
> +	PORTE_HARD_RESET.

Link layer broadcasts don't only come from expanders
(i.e. BROADCAST(CHANGE) ); SAS 1.1 (sas1r09e.pdf) defines
BROADCAST(SES) coming from a target port associated with
an enclosure device (SES peripheral type). It is not
clear to me how the associated primitive is conveyed back
with the broadcast.

If it is not conveyed back then perhaps that broadcast define
could be expanded to:
     PORTE_BROADCAST_CHANGE   (E)
     PORTE_BROADCAST_SES      (Target)

and a note inserted that BROADCAST(RESERVED CHANGE 0) and
BROADCAST(RESERVED CHANGE 1) be mapped to PORTE_BROADCAST_CHANGE
by the LLDD as per table 79 of sas1r09e.pdf .

BTW table 70 indicates an initiator can originate a BROADCAST(CHANGE),
not just an expander.

Doug Gilbert
