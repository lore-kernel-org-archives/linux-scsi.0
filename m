From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: [PATCH] hptiop: avoid buffer overflow when returning sense data
Date: Mon, 15 Oct 2007 14:42:52 +0800
Message-ID: <200710151442.52230.linux@highpoint-tech.com>
References: <200605101704.27491.linux@highpoint-tech.com> <200605161438.09717.linux@highpoint-tech.com> <200708291510.53793.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.biz.mail.re2.yahoo.com ([206.190.53.9]:21987 "HELO
	smtp110.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754241AbXJOGlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 02:41:07 -0400
In-Reply-To: <200708291510.53793.linux@highpoint-tech.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com


avoid buffer overflow when returning sense data.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
---

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 8b384fa..d32a4a9 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -375,8 +375,9 @@ static void hptiop_host_request_callback
 		scp->result = SAM_STAT_CHECK_CONDITION;
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
-		memcpy(&scp->sense_buffer,
-			&req->sg_list, le32_to_cpu(req->dataxfer_length));
+		memcpy(&scp->sense_buffer, &req->sg_list,
+				min(sizeof(scp->sense_buffer),
+					le32_to_cpu(req->dataxfer_length)));
 		break;
 
 	default:

