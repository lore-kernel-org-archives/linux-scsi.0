From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Wed, 26 Nov 2003 17:20:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031127012025.GA150144@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0598D39@AVEXCH02.qlogic.org> <20031125233103.GA146781@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:26848 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S264418AbTK0BVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 20:21:19 -0500
Content-Disposition: inline
In-Reply-To: <20031125233103.GA146781@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

I've found a problem with the driver on our SN2 system.  There
needs to be a register read after updating the Request Queue In
index, prior to releasing the host spin lock.

The calls to sn_mmiob() will need to be replaced by reading an
appropriate register on the chip.  sn_mmiob() is a lightweight
way of doing the same thing without having to go to the chip,
but only on SGI SN platforms.



--- drivers/scsi/qla2xxx/qla_iocb.c	Wed Nov 26 17:28:26 2003
+++ ../qla2xxx/qla_iocb.c	Tue Nov	 4 15:48:29 2003
@@ -506,7 +506,6 @@
	/* Set chip new ring index. */
	reg_flushed = CACHE_FLUSH(ISP_REQ_Q_IN(reg));
	WRT_REG_WORD(ISP_REQ_Q_IN(reg), ha->req_ring_index);
-	sn_mmiob();
 
	spin_unlock_irqrestore(&ha->hardware_lock, flags);
	return (QLA_SUCCESS);
@@ -778,7 +777,6 @@
 
	/* Set chip new ring index. */
	WRT_REG_WORD(ISP_REQ_Q_IN(reg), ha->req_ring_index);
-	sn_mmiob();
 
	LEAVE(__func__);
 }

