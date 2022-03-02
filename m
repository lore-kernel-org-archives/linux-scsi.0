Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A78AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238651AbiCBFhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiCBFhK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD16B16D3
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:28 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222bNBY010964
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=AoNsceScdBbrHeMyEnBiCDVDCT8xxhmZq/2iKfdXRGI=;
 b=fb8baVd2bTe/PawxwDRCtRepgT1hysQ2Y75OmCKhJZ8EKQFUrZgflNcEu6bnuL7NyuFi
 ysTsKpkfc2mEdTmxATZ0bj/cq/UInU+ARJFIUlS97/8dWvyqrgBsG+5gy3ydIei+Ebra
 Yi8lSxnJ7gNAqHADYD4Gwq0SfrzK1+QF+27uymDrdaolMeMGOFeXfne8B46K2/C1AGhk
 3Y0tLcnucZaUCu2DF0kMde96q7j/e3eLv4JxCp4d9HB8Zsi+Sth+CUSin1Z9C6heNr+g
 ZNToKJg7tZaMomin/kYOnmPWU/K7ClpsB+fd+sWK7PgktnhMKGuZTxh8dT6IXpCzRoGX YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bvwcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225Iud0175918
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Subject: SCSI discovery update
Date:   Wed,  2 Mar 2022 00:35:45 -0500
Message-Id: <20220302053559.32147-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=46 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=713
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020024
X-Proofpoint-GUID: 11Vp6U4Ied-hr2bjYwdpY-xr2_YzbXiN
X-Proofpoint-ORIG-GUID: 11Vp6U4Ied-hr2bjYwdpY-xr2_YzbXiN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series addresses several issues in the SCSI device discovery
code:

 - Fetch the VPD header before getting the full VPD page. This removes
   the guesswork from sizing the VPD buffer and fixes problems with
   RAID controllers that wedge when we try to fetch the IDENTIFY
   DEVICE information trailing the ATA Information VPD page.

 - Cache the VPD pages we need instead of fetching them every
   revalidate iteration.

 - Avoid truncating the INQUIRY length for modern devices. This allows
   us to query the version descriptors reported by most contemporary
   drives. These version descriptors are used as an extra heuristic
   for querying protocol features.

 - Additional sanity checking for the reported minimum and optimal I/O
   sizes.

 - Fix reported discard failures by making the configuration a
   two-stage process. Completing full VPD/RSOC discovery before we
   configure discard prevents a small window of error where the wrong
   command and/or wrong limit would briefly be applied.

 - Make the zeroing configuration a two-stage process as well.

 - Implement support for the NDOB flag for both discards and
   zeroing. The "No Data Out Buffer" flag removes the need for a
   zeroed payload to be included with a WRITE SAME(16) command.

 - Remove the superfluous revalidate operation historically required
   by the integrity profile registration. This further reduces the
   commands we send during device discovery.

 - Add additional heuristics for enabling discards on modern devices.
   Specifically, if a device reports that it supports logical block
   provisioning, attempt to query the LBP VPD page.

 - Also query the device VPD pages if a device reports conformance to
   a recent version of the SCSI Block Commands specification.

Thanks to several bug reporters and volunteers this series has been
extensively tested with a much wider variety of USB/UAS devices than I
have access to.

-- 
Martin K. Petersen	Oracle Linux Engineering



