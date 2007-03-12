From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc_transport: update potential link speeds
Date: Mon, 12 Mar 2007 14:16:35 -0500
Message-ID: <1173726995.4861.4.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50938 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbXCLTQT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 15:16:19 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l2CJGIv0016769
	for <linux-scsi@vger.kernel.org>; Mon, 12 Mar 2007 12:16:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch updates the FC transport for all speeds identified in SM-HBA.
Note: it does not sync the "bit" definitions, as that is actually insulated
from user-space via the sysfs text string. (I could do it, but it does introduce
a potential binary-incompatibility).

-- james s

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2007-03-12 14:11:20.000000000 -0500
@@ -200,6 +200,8 @@ static const struct {
 	{ FC_PORTSPEED_2GBIT,		"2 Gbit" },
 	{ FC_PORTSPEED_4GBIT,		"4 Gbit" },
 	{ FC_PORTSPEED_10GBIT,		"10 Gbit" },
+	{ FC_PORTSPEED_8GBIT,		"8 Gbit" },
+	{ FC_PORTSPEED_16GBIT,		"16 Gbit" },
 	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
 };
 fc_bitfield_name_search(port_speed, fc_port_speed_names)
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2007-03-12 13:56:23.000000000 -0500
+++ b/include/scsi/scsi_transport_fc.h	2007-03-12 14:10:28.000000000 -0500
@@ -108,6 +108,8 @@ enum fc_port_state {
 #define FC_PORTSPEED_2GBIT		2
 #define FC_PORTSPEED_4GBIT		4
 #define FC_PORTSPEED_10GBIT		8
+#define FC_PORTSPEED_8GBIT		0x10
+#define FC_PORTSPEED_16GBIT		0x20
 #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */
 
 /*


