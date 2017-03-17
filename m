From: Vaibhav Jain <vaibhav@linux.vnet.ibm.com>
Subject: [PATCH] lsscsi: Fix truncation of 128-bit wwn
Date: Fri, 17 Mar 2017 10:08:40 +0530
Message-ID: <20170317043840.26560-1-vaibhav@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751035AbdCQHK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Mar 2017 03:10:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2H4YPxv027381
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 00:40:08 -0400
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2980w6sa2a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 00:40:08 -0400
Received: from localhost
        by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <vaibhav@linux.vnet.ibm.com>;
        Fri, 17 Mar 2017 14:40:06 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
        by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2H4duo137290104
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 15:40:04 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
        by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v2H4dUKA002600
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 15:39:31 +1100
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
Reviewed-by: Gris Ge <fge@redhat.com>
---
 src/lsscsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/lsscsi.c b/src/lsscsi.c
index 974b3f1..f20adcf 100644
--- a/src/lsscsi.c
+++ b/src/lsscsi.c
@@ -210,8 +210,8 @@ struct dev_node_list {
 static struct dev_node_list* dev_node_listhead = NULL;
 
 struct disk_wwn_node_entry {
-       char wwn[32];
-       char disk_bname[12];
+	char wwn[35]; /* '0x' + wwn<128-bit> + <null-terminator> */
+	char disk_bname[12];
 };
 
 #define DISK_WWN_NODE_LIST_ENTRIES 16
@@ -2939,14 +2939,14 @@ one_sdev_entry(const char * dir_name, const char * devname,
                 }
                 if (wd[0]) {
                         char dev_node[LMAX_NAME] = "";
-                        char wwn_str[34];
+			char wwn_str[35];
                         enum dev_type typ;
 
                         typ = (FT_BLOCK == non_sg.ft) ? BLK_DEV : CHR_DEV;
                         if (get_wwn) {
                                 if ((BLK_DEV == typ) &&
                                     get_disk_wwn(wd, wwn_str, sizeof(wwn_str)))
-                                        printf("%-30s  ", wwn_str);
+					printf("%-34s  ", wwn_str);
                                 else
                                         printf("                          "
                                                "      ");
-- 
2.9.3
