From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Mon, 1 Dec 2003 15:21:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:4479 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S264155AbTLAXVi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 18:21:38 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Wednesday, November 26, 2003 5:20 PM, Jeremy Higdon wrote:

> I've found a problem with the driver on our SN2 system.  There needs
> to be a register read after updating the Request Queue In index,
> prior to releasing the host spin lock.
> 
> The calls to sn_mmiob() will need to be replaced by reading an
> appropriate register on the chip.  sn_mmiob() is a lightweight way
> of doing the same thing without having to go to the chip, but only
> on SGI SN platforms. 
> 

I'm curious, what types of symptoms were exibited without the
sn_mmiob() call?  Did I/O stall?

BTW: The CACHE_FLUSH() call:

	/* Set chip new ring index. */
	reg_flushed = CACHE_FLUSH(ISP_REQ_Q_IN(reg));

preceeding the WRT_REG_WORD() has been removed from my working tree
(remnants of an ancient motherboard problem with an on-board ISP while
using PIO).

Regards,
Andrew Vasquez
