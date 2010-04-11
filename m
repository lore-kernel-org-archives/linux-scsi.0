From: David Miller <davem@davemloft.net>
Subject: [PATCH 1/2] scsi: Add lockdep annotations to SAS sysfs attributes.
Date: Sat, 10 Apr 2010 21:40:17 -0700 (PDT)
Message-ID: <20100410.214017.165974351.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ebiederm@xmission.com
Cc: gregkh@suse.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


They are allocated dynamically, and thus need sysfs_attr_init()
treatment.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 927e99c..f9c61b9 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1679,15 +1679,17 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
  */
 
 #define SETUP_TEMPLATE(attrb, field, perm, test)			\
-	i->private_##attrb[count] = dev_attr_##field;		\
+	i->private_##attrb[count] = dev_attr_##field;			\
 	i->private_##attrb[count].attr.mode = perm;			\
+	sysfs_attr_init(&i->private_##attrb[count].attr);		\
 	i->attrb[count] = &i->private_##attrb[count];			\
 	if (test)							\
 		count++
 
 #define SETUP_TEMPLATE_RW(attrb, field, perm, test, ro_test, ro_perm)	\
-	i->private_##attrb[count] = dev_attr_##field;		\
+	i->private_##attrb[count] = dev_attr_##field;			\
 	i->private_##attrb[count].attr.mode = perm;			\
+	sysfs_attr_init(&i->private_##attrb[count].attr);		\
 	if (ro_test) {							\
 		i->private_##attrb[count].attr.mode = ro_perm;		\
 		i->private_##attrb[count].store = NULL;			\
