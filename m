Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CC2C33C9E
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 01:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 187D520848
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 01:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AylLWoXP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgAHBaX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 20:30:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgAHBaW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 20:30:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0081TKXe134517;
        Wed, 8 Jan 2020 01:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8789pjZRMhEt10VXzIey5jziJkLcr1FXiO0MyGZcbHU=;
 b=AylLWoXPy4Oj5QevoFSTbo05w+Poh/wgJTwQOPO8UU38vgufdiTZyue/bgC2IDH+tA+Y
 ffHDZSg4DppIOA1ohdF7+JSl96h41jqdCpeHVIoBprXSiWI8ET2gJQIZh8s6i8BTGOBl
 vzRe6gLiTqLAUVl7IR9dN95ZeV0jp2lYOwx9cwQJW90CcURAeUnRK+nK3Nsk3sQt4R1C
 vSeWR5XjDd+SM4To1KslVnWV1X9mN6J6yu964GNuG78qgsQ97Dm69xBjPMC1q43Qdx31
 mPFpRpLhBrd/V8urAKuJUYo5Ik5wTpNZgsbL5iytcG1I4Sg4pjZkLp4mUDwruFYFz9i0 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xaj4u14h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 01:29:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0081SNlr151251;
        Wed, 8 Jan 2020 01:29:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xcqbj178y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 01:29:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0081TqNx008054;
        Wed, 8 Jan 2020 01:29:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 17:29:43 -0800
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191215174509.1847-1-linux@roeck-us.net>
        <20191215174509.1847-2-linux@roeck-us.net>
        <yq1r211dvck.fsf@oracle.com> <20191219003256.GA28144@roeck-us.net>
        <yq17e233o0o.fsf@oracle.com>
        <d42990af-78e4-e6c4-37ae-8043d27e565a@roeck-us.net>
Date:   Tue, 07 Jan 2020 20:29:40 -0500
In-Reply-To: <d42990af-78e4-e6c4-37ae-8043d27e565a@roeck-us.net> (Guenter
        Roeck's message of "Tue, 7 Jan 2020 05:00:39 -0800")
Message-ID: <yq1o8ve20sb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080012
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> "scsi-8-140" is created by libsensors, so any change in that would
> have to be made there, not in the kernel driver.

Yes. Something like the patch below which will produce actual SCSI
device instance names:

	drivetemp-scsi-7:0:29:0
	drivetemp-scsi-8:0:30:0
	drivetemp-scsi-8:0:15:0
	drivetemp-scsi-7:0:24:0

Instead of the current:

	drivetemp-scsi-7-1d0
	drivetemp-scsi-8-1e0
	drivetemp-scsi-8-f0
	drivetemp-scsi-7-180

Other question: Does hwmon have any notion of sensor topology? As I
mentioned earlier, SCSI installations typically rely on SAF-TE or SES
instead of the physical drive sensors. SES also includes monitoring of
fans, power supplies, etc. And more importantly, it provides a
representation of the location of a given component. E.g.: Tray number
#4, disk drive bay #5.

So it would be helpful if libsensors had a way to represent sensors in a
way that mimics the physical device layout reported by SES.

-- 
Martin K. Petersen	Oracle Linux Engineering


diff --git a/lib/data.c b/lib/data.c
index c5aea42967a6..06cfa86f353b 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -202,8 +202,9 @@ int sensors_snprintf_chip_name(char *str, size_t size,
 		return snprintf(str, size, "%s-mdio-%x", chip->prefix,
 				chip->addr);
 	case SENSORS_BUS_TYPE_SCSI:
-		return snprintf(str, size, "%s-scsi-%hd-%x", chip->prefix,
-				chip->bus.nr, chip->addr);
+		return snprintf(str, size, "%s-scsi-%u:%u:%u:%lu", chip->prefix,
+				chip->bus.nr, chip->addr, chip->sub_addr,
+				chip->sub_sub_addr);
 	}
 
 	return -SENSORS_ERR_CHIP_NAME;
diff --git a/lib/sensors.h b/lib/sensors.h
index 94f6f23051d2..f468cccabc72 100644
--- a/lib/sensors.h
+++ b/lib/sensors.h
@@ -65,6 +65,8 @@ typedef struct sensors_chip_name {
 	char *prefix;
 	sensors_bus_id bus;
 	int addr;
+	unsigned int sub_addr;
+	unsigned long sub_sub_addr;
 	char *path;
 } sensors_chip_name;
 
diff --git a/lib/sysfs.c b/lib/sysfs.c
index e63688b72aba..f76b4a99aa7d 100644
--- a/lib/sysfs.c
+++ b/lib/sysfs.c
@@ -620,6 +620,7 @@ static int classify_device(const char *dev_name,
                            sensors_chip_features *entry)
 {
 	int domain, bus, slot, fn, vendor, product, id;
+	unsigned long lun;
 	char bus_path[NAME_MAX];
 	char *bus_attr;
 	int ret = 1;
@@ -687,11 +688,13 @@ static int classify_device(const char *dev_name,
 		entry->chip.bus.nr = 0;
 	} else
 	if (subsys && !strcmp(subsys, "scsi") &&
-	    sscanf(dev_name, "%d:%d:%d:%x", &domain, &bus, &slot, &fn) == 4) {
+	    sscanf(dev_name, "%u:%u:%u:%lu", &domain, &bus, &id, &lun) == 4) {
 		/* adapter(host), channel(bus), id(target), lun */
-		entry->chip.addr = (bus << 8) + (slot << 4) + fn;
-		entry->chip.bus.type = SENSORS_BUS_TYPE_SCSI;
 		entry->chip.bus.nr = domain;
+		entry->chip.addr = bus;
+		entry->chip.sub_addr = id;
+		entry->chip.sub_sub_addr = lun;
+		entry->chip.bus.type = SENSORS_BUS_TYPE_SCSI;
 	} else {
 		/* Unknown device */
 		ret = 0;
