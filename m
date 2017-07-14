From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 4/4] scsi: scsi_transport_spi: constify attribute_group structures.
Date: Fri, 14 Jul 2017 13:53:30 +0530
Message-ID: <1500020610-15973-5-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/attribute_container.h>
and <linux/sysfs.h> work with const attribute_group. So mark the non-const
structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  15444	   1616	      0	  17060	   42a4	drivers/scsi/scsi_transport_spi.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  15572	   1488	      0	  17060	   42a4	drivers/scsi/scsi_transport_spi.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index d0219e3..ec723b2 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1426,7 +1426,7 @@ static DECLARE_ANON_TRANSPORT_CLASS(spi_device_class,
 	NULL
 };
 
-static struct attribute_group host_attribute_group = {
+static const struct attribute_group host_attribute_group = {
 	.attrs = host_attributes,
 };
 
@@ -1536,7 +1536,7 @@ static umode_t target_attribute_is_visible(struct kobject *kobj,
 	NULL
 };
 
-static struct attribute_group target_attribute_group = {
+static const struct attribute_group target_attribute_group = {
 	.attrs = target_attributes,
 	.is_visible = target_attribute_is_visible,
 };
-- 
1.9.1
