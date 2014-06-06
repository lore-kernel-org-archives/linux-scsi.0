From: Pai <vpai@akamai.com>
Subject: [RFC Patch]: scsi: sysfs file cache_type not in sync with mode page
Date: Fri, 06 Jun 2014 17:14:16 -0400
Message-ID: <E1Wt1Sq-0000LA-Ez@bos-lpci1.kendall.corp.akamai.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:61269 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbaFFVUD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 17:20:03 -0400
Received: from prod-mail-xrelay07.akamai.com (localhost.localdomain [127.0.0.1])
	by postfix.imss70 (Postfix) with ESMTP id 9FF2547592
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2014 21:14:16 +0000 (GMT)
Received: from prod-mail-relay06.akamai.com (prod-mail-relay06.akamai.com [172.17.120.126])
	by prod-mail-xrelay07.akamai.com (Postfix) with ESMTP id 8D4E14753D
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2014 21:14:16 +0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ~t@akamai.com, linux-scsi@vger.kernel.org, ~c@akamai.com, vpai@akamai.com

Hi All,

I noticed that the sysfs file cache_type is not is sync with the information in the mode page. If we change the WCE attribute in the mode page (sdparm --set=WCE /dev/sda  and sdparm --clear=WCE /dev/sda) it does not reflect this in the sysfs file.

$ cat /sys/block/sda/device/scsi_disk/6\:0\:0\:0/cache_type 
write back

$ sdparm --clear=WCE /dev/sda
    /dev/sda: TOSHIBA   AL13SEB600        0101

$ cat /sys/block/sda/device/scsi_disk/6\:0\:0\:0/cache_type 
write back

Ideally cache_type should have changed to 'write through' or 'none'. I have a small one line change that can fix this one. This patch applies against the latest branch "linux-3.15-rc8". 

Few things to note:
1. revalidate_disk() also reads a whole bunch of other things from the mode page and I don't know if this will have any side effects. This call is made on store_cache_type as well, so I think it should be OK.
2. This is extra work which is not needed in most cases (mode pages hardly change). Is there an event that we can subscribe to when the modpages change?

Please review.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index efcbcd1..5b65ccc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -256,6 +256,7 @@ static ssize_t
 cache_type_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	revalidate_disk(sdkp->disk);
 	int ct = sdkp->RCD + 2*sdkp->WCE;
 
 	return snprintf(buf, 40, "%s\n", sd_cache_types[ct]);

Thanks,
Vishwanath


