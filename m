From: "jack wang" <jack_wang@usish.com>
Subject: Re: [PATCH 6/7]MVSAS: Enhanced hot plug handling
Date: Tue, 10 Nov 2009 09:38:35 +0800
Message-ID: <27D4B599214A4AE693D4D01B2AD74FF7@usish.com.cn>
References: <20091109122713.GE32336@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:34727 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbZKJBig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 20:38:36 -0500
In-Reply-To: <20091109122713.GE32336@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com, james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org
Cc: qswang@marvell.com, jfeng@marvell.com

@@ -914,13 +911,22 @@ static int mvs_task_exec(struct sas_task *task, const
int num, gfp_t gfp_flags,
 			tei.port = &mvi->port[dev->port->id -
mvi->chip->n_phy];
 		else
 			tei.port = &mvi->port[dev->port->id];
-
-		if (!tei.port->port_attached) {
+		if (tei.port && !tei.port->port_attached) {
 			if (sas_protocol_ata(t->task_proto)) {
-				mv_dprintk("port %d does not"
-					"attached device.\n",
dev->port->id);
-				rc = SAS_PHY_DOWN;
-				goto out_done;
+				struct task_status_struct *ts =
&t->task_status;
+				ts->stat = SAS_PROTO_RESPONSE;
+				ts->stat = SAS_PHY_DOWN;


[Jack] Here ts->stat was double set. Maybe the first one is unnessary.

