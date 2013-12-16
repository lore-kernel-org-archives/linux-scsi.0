From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 23/24] qla4xxx: Fix sparse warnings
Date: Mon, 16 Dec 2013 06:49:53 -0500
Message-ID: <1387194594-29817-24-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:61083 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332Ab3LPMXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:39 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Fix following sparse warnings:-
 drivers/scsi/qla4xxx/ql4_os.c:2109:33: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)
 drivers/scsi/qla4xxx/ql4_os.c:2306:33: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e8a8a7d..3c2240c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2109,7 +2109,8 @@ static void qla4xxx_set_ipv6(struct scsi_qla_host *ha,
 				cpu_to_le16(IPV6_TCPOPT_DELAYED_ACK_DISABLE);
 		else
 			init_fw_cb->ipv6_tcp_opts &=
-				cpu_to_le16(~IPV6_TCPOPT_DELAYED_ACK_DISABLE);
+				cpu_to_le16(~IPV6_TCPOPT_DELAYED_ACK_DISABLE &
+					    0xFFFF);
 		break;
 	case ISCSI_NET_PARAM_TCP_NAGLE_DISABLE:
 		if (iface_param->iface_num & 0x1)
@@ -2306,7 +2307,8 @@ static void qla4xxx_set_ipv4(struct scsi_qla_host *ha,
 				cpu_to_le16(TCPOPT_DELAYED_ACK_DISABLE);
 		else
 			init_fw_cb->ipv4_tcp_opts &=
-				cpu_to_le16(~TCPOPT_DELAYED_ACK_DISABLE);
+				cpu_to_le16(~TCPOPT_DELAYED_ACK_DISABLE &
+					    0xFFFF);
 		break;
 	case ISCSI_NET_PARAM_TCP_NAGLE_DISABLE:
 		if (iface_param->iface_num & 0x1)
-- 
1.8.2.GIT

