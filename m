From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: [Patch] Fix regression in 3.18 caused by e05fe29248 qla2xxx: Honor
 FCP_RSP retry delay timer field.
Date: Fri, 19 Dec 2014 10:29:16 +0100
Message-ID: <20141219102916.6fcae21a@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.restena.lu ([158.64.1.62]:49388 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaLSJho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2014 04:37:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com

Commit e05fe29248 (qla2xxx: Honor FCP_RSP retry delay timer field.)
causes systems to busy-wait for about 3 minutes after boot prior to
detecting SAN disks.

During this wait period one kworker is running full-time
(though /proc/<pid>/stack has no useful data). Another kworker is
waiting for IO to complete during that whole time period.


Looking at drivers/scsi/qla2xxx/qla_os.c, fcport->retry_delay_timestamp
has a special value of 0 though that 0 value forces system to wait when
jiffies is very large value (e.g. 4294952605 - "negative" value when
signed on 32bit systems).

Signed-off-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
---
This fix probably still misses the special case when retry delay wants
jiffies to wrap around to 0...

 drivers/scsi/qla2xxx/qla_os.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_o=
s.c
index db3dbd9..1df4c66 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -735,7 +735,9 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct=
 scsi_cmnd *cmd)
 	 * Return target busy if we've received a non-zero retry_delay_timer
 	 * in a FCP_RSP.
 	 */
-	if (time_after(jiffies, fcport->retry_delay_timestamp))
+	if (fcport->retry_delay_timestamp =3D=3D 0) {
+		/* retry delay not set */
+	} else if (time_after(jiffies, fcport->retry_delay_timestamp))
 		fcport->retry_delay_timestamp =3D 0;
 	else
 		goto qc24_target_busy;
--
2.0.4
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
