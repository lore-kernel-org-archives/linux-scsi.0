Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AC4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 23:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B132074F
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 23:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xUpwuKrO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgFZXxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 19:53:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34020 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgFZXxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 19:53:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05QNmX80180188;
        Fri, 26 Jun 2020 23:53:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=TsAo6MsFl/ln9Ttu9ohq5+yEC2UDivwgyxdEEiAPbvU=;
 b=xUpwuKrOJCSIvy80glVCcUDUoe11aLuG4BsKXBK22yxUGZwyX/5rivMDhC6v24BuZwvY
 2eDPSYmFSt3OHwY7Ea1fR1FKgXIt/mLCbB3lGpHwlsU5QIFTX+o4zNY0aW3IdB0O25cn
 TRTcp1UNFKyRh2Rt0opTeImcqd7L52aCrkzmHtaPilo3G2xfUvYhquTE8QvOKmWAlT4E
 uTBhiUEyKs61GVJmUlduM6UrK0uWIP1Hs6Vj+H9xMh32KkaKbdbIp6M8Z1sjVUtIPYYE
 wRNowfwiVdv7JTuqynN90j+brfN10wL5vORI/LQlM9l3tjU2FVODXlS/nGmx7ABiiiwH hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wg3bk3xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 23:53:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05QNmNom125218;
        Fri, 26 Jun 2020 23:53:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uurdkekx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jun 2020 23:53:10 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05QNr9Ib018105;
        Fri, 26 Jun 2020 23:53:09 GMT
Received: from localhost.localdomain (/10.159.129.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Jun 2020 23:53:09 +0000
To:     martin.petersen@oracle.com
Cc:     jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org,
        Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
From:   Anjali Kulkarni <Anjali.K.Kulkarni@oracle.com>
Subject: [PATCH] scsi: Avoid unnecessary iterations on __scsi_scan_target
Message-ID: <38cee464-7320-87a9-f55c-f0db4679fc0a@oracle.com>
Date:   Fri, 26 Jun 2020 16:53:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1 phishscore=0
 malwarescore=0 cotscore=-2147483648 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006260168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a loop in scsi_scan_channel(), which calls
__scsi_scan_target() 255 times, even when it has found a target/device on a
lun in the first iteration; this ends up adding a 2 secs delay to the boot
time. The for loop in scsi_scan_channel() adding 2 secs to boot time is as
follows:

for (id = 0; id < shost->max_id; ++id) {
     ...
     __scsi_scan_target(&shost->shost_gendev, channel,
                               order_id, lun, rescan);
}

__scsi_scan_target() calls scsi_probe_and_add_lun() which calls
scsi_probe_lun(), hence scsi_probe_lun() ends up getting called 255 times.
Each call of scsi_probe_lun() takes 0.007865 secs.
0.007865 multiplied by 255 = 2.00557 secs.
By adding a break in above for loop when a valid device on lun is found,
we can avoid this 2 secs delay improving boot time by 2 secs.

The flow of code is depicted in the following sequence of events:

do_scan_async() ->
     do_scsi_scan_host()->
         scsi_scan_host_selected() ->
             scsi_scan_channel()
                 __scsi_scan_target() -> this is called shost->max_id times
                                         (255 times)
                     scsi_probe_and_add_lun-> this is called 255 times
                         scsi_probe_lun : called 255 times, each call
                                          takes 0.007865 secs.

The with break and without break boot time differences can be seen with
systemd-analyze:

With break:

[root@vm-sec root]# systemd-analyze
Startup finished in 2.038s (kernel) + 1.210s (initrd) + 14.198s 
(userspace) = 17.446s

Without break:

[root@vm-sec root]# systemd-analyze
Startup finished in 2.036s (kernel) + 3.342s (initrd) + 14.255s 
(userspace) = 19.634s

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
  drivers/scsi/scsi_scan.c | 17 +++++++++++------
  1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..a519b944b512 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1527,23 +1527,23 @@ void scsi_rescan_device(struct device *dev)
  }
  EXPORT_SYMBOL(scsi_rescan_device);

-static void __scsi_scan_target(struct device *parent, unsigned int channel,
+static int __scsi_scan_target(struct device *parent, unsigned int channel,
          unsigned int id, u64 lun, enum scsi_scan_mode rescan)
  {
      struct Scsi_Host *shost = dev_to_shost(parent);
      blist_flags_t bflags = 0;
-    int res;
+    int res = SCSI_SCAN_NO_RESPONSE;
      struct scsi_target *starget;

      if (shost->this_id == id)
          /*
           * Don't scan the host adapter
           */
-        return;
+        return res;

      starget = scsi_alloc_target(parent, channel, id);
      if (!starget)
-        return;
+        return res;
      scsi_autopm_get_target(starget);

      if (lun != SCAN_WILD_CARD) {
@@ -1551,6 +1551,9 @@ static void __scsi_scan_target(struct device 
*parent, unsigned int channel,
           * Scan for a specific host/chan/id/lun.
           */
          scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL);
+        res = scsi_probe_and_add_lun(starget, lun, NULL, NULL,
+                rescan, NULL);
+
          goto out_reap;
      }

@@ -1578,6 +1581,7 @@ static void __scsi_scan_target(struct device 
*parent, unsigned int channel,
      scsi_target_reap(starget);

      put_device(&starget->dev);
+    return res;
  }

  /**
@@ -1646,8 +1650,9 @@ static void scsi_scan_channel(struct Scsi_Host 
*shost, unsigned int channel,
                  order_id = shost->max_id - id - 1;
              else
                  order_id = id;
-            __scsi_scan_target(&shost->shost_gendev, channel,
-                    order_id, lun, rescan);
+            if (__scsi_scan_target(&shost->shost_gendev, channel,
+                order_id, lun, rescan) != SCSI_SCAN_NO_RESPONSE)
+                break;
          }
      else
          __scsi_scan_target(&shost->shost_gendev, channel,
-- 
2.26.2

