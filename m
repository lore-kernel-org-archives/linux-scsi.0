From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx panic on module insertion
Date: Mon, 10 Jul 2006 16:07:31 -0500
Message-ID: <1152565651.4027.11.camel@mulgrave.il.steeleye.com>
References: <1152541373.7275.11.camel@mulgrave.il.steeleye.com>
	 <20060710172950.GE30179@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54189 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965308AbWGJWvI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 18:51:08 -0400
In-Reply-To: <20060710172950.GE30179@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-07-10 at 10:29 -0700, Mike Anderson wrote:
> Yes, since we have not formed a port yet on phy1 it would appear that we
> could just drop this event if port is null as we are going to do discovery
> post port forming the port anyway.

OK, so this is the fix?

James

diff --git a/drivers/scsi/sas/sas_port.c b/drivers/scsi/sas/sas_port.c
index 07415e9..d931478 100644
--- a/drivers/scsi/sas/sas_port.c
+++ b/drivers/scsi/sas/sas_port.c
@@ -199,6 +199,12 @@ void sas_porte_broadcast_rcvd(void *data
 	u32 prim;
 	struct asd_sas_phy *phy = data;
 
+	/* Broadcast received before port forms.  This is fine, since
+	 * port formation will trigger a domain discovery (rather than
+	 * revalidation) */
+	if (!sas->port)
+		return;
+
 	sas_begin_event(PORTE_BROADCAST_RCVD, &phy->ha->event_lock,
 			&phy->port_events_pending);
 


