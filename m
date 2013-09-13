From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 2/4] scsi: add scsi device flag to request READ CAPACITY (16)
 be preferred
Date: Fri, 13 Sep 2013 13:58:27 +0100
Message-ID: <1379077109-29606-3-git-send-email-apw@canonical.com>
References: <1379077109-29606-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1379077109-29606-1-git-send-email-apw@canonical.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Cc: Andy Whitcroft <apw@canonical.com>, devel@linuxdriverproject.org, Ben Howard <ben.howard@canonical.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1223499
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/scsi/sd.c          | 2 ++
 include/scsi/scsi_device.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5a8a04d..eba4d6c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2104,6 +2104,8 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 		return 1;
 	if (scsi_device_protection(sdp))
 		return 1;
+	if (sdp->try_rc_16_first)
+		return 1;
 	return 0;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9b7fdb6..df3ed43 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -165,6 +165,7 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
+	unsigned try_rc_16_first:1;	/* Try READ_CAPACACITY_16 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
-- 
1.8.1.2
