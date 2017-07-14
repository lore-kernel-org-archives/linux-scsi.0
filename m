From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 3/4] scsi: scsi_transport_fc: constify attribute_group structures.
Date: Fri, 14 Jul 2017 13:53:29 +0530
Message-ID: <1500020610-15973-4-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/transport_class.h>
work with const attribute_group. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  34122	   1932	      4	  36058	   8cda	drivers/scsi/scsi_transport_fc.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  34186	   1868	      4	  36058	   8cda	drivers/scsi/scsi_transport_fc.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 7e24aa3..eda39cc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1808,7 +1808,7 @@ static FC_DEVICE_ATTR(host, reset_statistics, S_IWUSR, NULL,
 	NULL
 };
 
-static struct attribute_group fc_statistics_group = {
+static const struct attribute_group fc_statistics_group = {
 	.name = "statistics",
 	.attrs = fc_statistics_attrs,
 };
-- 
1.9.1
