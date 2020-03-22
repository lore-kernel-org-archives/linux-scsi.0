Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF09DC1975A
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 22:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A444320637
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 22:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zlViYKo0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCVWpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 18:45:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCVWpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 18:45:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02MMjUeP143686;
        Sun, 22 Mar 2020 22:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hoMmtGSwISBl/dzfTm4L0KoTETz2x8YJhZSz5ifl59g=;
 b=zlViYKo04ze7YaTuzuaau3ukE6XaPaQhgRr4Djfy7qKiRe/wVR8tVteJ+pqNUkAmiHGq
 7IcuXbNfElfpp6eGBI2Et8hMbDfYvK0AoiFAoiMBZC5A8QBcFYGJ9Hwn0mEQYkVa5eoz
 KBrBnDysEJehPG7FS8Tye7EdPkSBviSwhgzZmuVBGc/YtOdVndVPqkUrNE9goDG4w+4D
 +NwLiJeT0fHsIcaHAuDmYoI986P7Rq9Uk43l8vGI1KDM+Z0h5sJBBv5w2j8a9aXIyA+6
 1e7LJV1gLtWnD6BfvICO28BXBTr4szS+GZ7/9XE5ofF14UtFg0KYxZk1w1bVgEq2RHHY og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yx8abrspc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 22:45:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02MMgvjE195029;
        Sun, 22 Mar 2020 22:45:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ywvmuuyk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 22:45:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02MMjTpV020247;
        Sun, 22 Mar 2020 22:45:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Mar 2020 15:45:29 -0700
To:     Bernhard Sulzer <micraft.b@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: Invalid optimal transfer size 33553920 accepted when physical_block_size 512
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
        <yq1o8sowfzn.fsf@oracle.com>
        <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
        <yq1pnd4tbxm.fsf@oracle.com>
        <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
        <yq1eetkrtf6.fsf@oracle.com>
        <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
        <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com>
Date:   Sun, 22 Mar 2020 18:45:27 -0400
In-Reply-To: <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com> (Bernhard
        Sulzer's message of "Sun, 22 Mar 2020 22:53:11 +0100")
Message-ID: <yq14kugrou0.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003220139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003220139
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bernhard,

> [=C2=A0 105.197403] sd 6:0:0:0: [sdc] Preferred minimum I/O size 512 bytes

In the sg_vpd -p bl output you sent this field was set to 8 blocks
(i.e. 4096 bytes). And in the sg_readcap -l output the physical block
size exponent was reported as 3 (i.e. also 4096 bytes).

But when we inspect these values during device discovery they appear to
be either 0 or 1. What is weird is that if the device somehow updated
them on the fly, I would also expect the optimal transfer length value
to be 0 as well. But it is consistently reported as 0xffff.

Do the reported values change if you do the following a while after you
plugged the drive in?

# lsblk -t
# echo 1 > /sys/block/sdc/device/rescan
# sleep 10
# lsblk -t

The only way I can replicate your results is by making scsi_debug return
zeroes during discovery and then switch to reporting the correct values
after a while. I did a quick hack where I returned zeroes for the
optimal transfer length granularity and the physical block size exponent
the first few times they were requested. That produces results similar
to yours.

I also attached a quick debug patch for capturing some more info.

--=20
Martin K. Petersen	Oracle Linux Engineering


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e41f8eb00787..e1e3213ab155 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2333,6 +2333,11 @@ static int read_capacity_16(struct scsi_disk *sdkp, =
struct scsi_device *sdp,
 	/* Logical blocks per physical block exponent */
 	sdkp->physical_block_size =3D (1 << (buffer[13] & 0xf)) * sector_size;
=20
+	sd_printk(KERN_ERR, sdkp, "%s: result %d, retries %u\n", __func__,
+		  the_result, retries);
+	sd_printk(KERN_ERR, sdkp, "%s: lbs %u, pbs %u, last LBA %llx\n", __func__,
+		  sector_size, sdkp->physical_block_size, lba);
+
 	/* RC basis */
 	sdkp->rc_basis =3D (buffer[12] >> 4) & 0x3;
=20
@@ -2402,6 +2407,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, =
struct scsi_device *sdp,
 	sector_size =3D get_unaligned_be32(&buffer[4]);
 	lba =3D get_unaligned_be32(&buffer[0]);
=20
+	sd_printk(KERN_ERR, sdkp, "%s: result %d, retries %u\n", __func__,
+		  the_result, retries);
+	sd_printk(KERN_ERR, sdkp, "%s: lbs %u, last LBA %llx\n", __func__,
+		  sector_size, lba);
+
 	if (sdp->no_read_capacity_16 && (lba =3D=3D 0xffffffff)) {
 		/* Some buggy (usb cardreader) devices return an lba of
 		   0xffffffff when the want to report a size of 0 (with
@@ -2438,6 +2448,9 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned cha=
r *buffer)
 	int sector_size;
 	struct scsi_device *sdp =3D sdkp->device;
=20
+	sd_printk(KERN_ERR, sdkp, "%s: rc10_first %u, rc16_first: %u\n",
+		  __func__, sdp->try_rc_10_first, sd_try_rc16_first(sdp));
+
 	if (sd_try_rc16_first(sdp)) {
 		sector_size =3D read_capacity_16(sdkp, sdp, buffer);
 		if (sector_size =3D=3D -EOVERFLOW)
@@ -2457,7 +2470,7 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned cha=
r *buffer)
 		if ((sizeof(sdkp->capacity) > 4) &&
 		    (sdkp->capacity > 0xffffffffULL)) {
 			int old_sector_size =3D sector_size;
-			sd_printk(KERN_NOTICE, sdkp, "Very big device. "
+			sd_printk(KERN_ERR, sdkp, "Very big device. "
 					"Trying to use READ CAPACITY(16).\n");
 			sector_size =3D read_capacity_16(sdkp, sdp, buffer);
 			if (sector_size < 0) {
