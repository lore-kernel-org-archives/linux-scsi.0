From: Vaibhav Jain <vaibhav@linux.vnet.ibm.com>
Subject: [PATCH v2] lsscsi: Fix truncation of 128-bit wwn
Date: Fri, 17 Mar 2017 17:31:40 +0530
Message-ID: <20170317120140.22580-1-vaibhav@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37840 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751170AbdCQMDE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Mar 2017 08:03:04 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2HBwqbO127423
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 08:02:57 -0400
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
        by mx0b-001b2d01.pphosted.com with ESMTP id 298dm4w3ve-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 08:02:57 -0400
Received: from localhost
        by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <vaibhav@linux.vnet.ibm.com>;
        Fri, 17 Mar 2017 22:02:54 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2HC2ibj27459804
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 23:02:52 +1100
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v2HC2Hcp008101
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 23:02:17 +1100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Vaibhav Jain <vaibhav@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jon Grimm <jon.grimm@canonical.com>, Vipin K Parashar <vipin@linux.vnet.ibm.com>, Ping Tian Han <pthan@cn.ibm.com>, Gris Ge <fge@redhat.com>

Currently with '--wwn' flag, 128-bit wwns gets truncated and their
last 3 hex-digits missing. Below is a comparison of wwn reported by
lsscsi compared to wwn info at /dev/disk/by-id directory.

% lsscsi -w 0:0:5:0
[0:0:5:0]    disk    0x60050764008181941000000000000  /dev/sdad

% ls -l /dev/disk/by-id/wwn-*
lrwxrwxrwx. 1 root root 10 Oct 19 01:08 /dev/disk/by-id/wwn-0x600507640081819410000000000001b1 -> ../../sdad

To fix this, the patch increases the size of member wwn of struct
disk_wwn_node_entry to 35 chars to accommodate the extra '0x' prefix and
null terminator. Also the size of the buffer wwn_str thats used to
output wwn to the std-out is increased to match the corresponding
member of disk_wwn_node_entry.

Link: https://bugs.launchpad.net/ubuntu/+source/lsscsi/+bug/1636467
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1387263

Cc: Jon Grimm <jon.grimm@canonical.com>
Cc: Vipin K Parashar <vipin@linux.vnet.ibm.com>
Cc: Ping Tian Han <pthan@cn.ibm.com>
Cc: Gris Ge <fge@redhat.com>
Reported-by: Ping Tian Han <pthan@cn.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.vnet.ibm.com>
---
Change-log:

v2..v1
- Introduces macro DISK_WWN_MAX_LEN that defines the maximum length of
  wwn read from devfs. (Gris Ge)
- Fix the indentation using space instead of '\t' (Gris Ge)
---
 src/lsscsi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/src/lsscsi.c b/src/lsscsi.c
index 974b3f1..5d3c602 100644
--- a/src/lsscsi.c
+++ b/src/lsscsi.c
@@ -209,8 +209,17 @@ struct dev_node_list {
 };
 static struct dev_node_list* dev_node_listhead = NULL;
 
+/* WWN here is extracted from /dev/disk/by-id/wwn-<WWN> which is
+ * created by udev 60-persistent-storage.rules using ID_WWN_WITH_EXTENSION.
+ * The udev ID_WWN_WITH_EXTENSION is the combination of char wwn[17] and
+ * char wwn_vendor_extension[17] from struct scsi_id_device. This macro
+ * defines the maximum length of char-array needed to store this wwn including
+ * the null-terminator.
+ */
+#define DISK_WWN_MAX_LEN 35
+
 struct disk_wwn_node_entry {
-       char wwn[32];
+       char wwn[DISK_WWN_MAX_LEN]; /* '0x' + wwn<128-bit> + <null-terminator> */
        char disk_bname[12];
 };
 
@@ -2939,14 +2948,15 @@ one_sdev_entry(const char * dir_name, const char * devname,
                 }
                 if (wd[0]) {
                         char dev_node[LMAX_NAME] = "";
-                        char wwn_str[34];
+                        char wwn_str[DISK_WWN_MAX_LEN];
                         enum dev_type typ;
 
                         typ = (FT_BLOCK == non_sg.ft) ? BLK_DEV : CHR_DEV;
                         if (get_wwn) {
                                 if ((BLK_DEV == typ) &&
                                     get_disk_wwn(wd, wwn_str, sizeof(wwn_str)))
-                                        printf("%-30s  ", wwn_str);
+                                        printf("%-*s  ", DISK_WWN_MAX_LEN - 1,
+                                               wwn_str);
                                 else
                                         printf("                          "
                                                "      ");
-- 
2.9.3
