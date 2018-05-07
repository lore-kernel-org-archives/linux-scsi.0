From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/3] scsi: arcmsr: Add driver parameter cmd_timeout,
 default value is ARCMSR_DEFAULT_TIMEOUT
Date: Mon, 07 May 2018 14:53:39 +0800
Message-ID: <1525676019.8876.15.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Add driver parameter cmd_timeout, default value is ARCMSR_DEFAULT_TIMEOUT

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 2e51ccc..62eeef5 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -82,6 +82,7 @@ struct device_attribute;
 #endif
 #define	ARCMSR_HOURS			(1000 * 60 * 60 * 4)
 #define	ARCMSR_MINUTES			(1000 * 60 * 60)
+#define ARCMSR_DEFAULT_TIMEOUT		90
 /*
 **********************************************************************************
 **
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 732b5d9..f6ddaec 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -95,6 +95,10 @@ static int set_date_time = 0;
 module_param(set_date_time, int, S_IRUGO);
 MODULE_PARM_DESC(set_date_time, " send date, time to iop(0 ~ 1), set_date_time=1(enable), default(=0) is disable");
 
+static int cmd_timeout = ARCMSR_DEFAULT_TIMEOUT;
+module_param(cmd_timeout, int, S_IRUGO);
+MODULE_PARM_DESC(cmd_timeout, " scsi cmd timeout(0 ~ 120 sec.), default is 90");
+
 #define	ARCMSR_SLEEPTIME	10
 #define	ARCMSR_RETRYCOUNT	12
 
