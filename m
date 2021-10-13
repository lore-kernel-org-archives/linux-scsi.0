Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44F3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCC6610CE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbhJMIcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:32:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36588 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232155AbhJMIcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 04:32:36 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D8ECwj028314;
        Wed, 13 Oct 2021 08:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=LP8iCuAyEErRjsajdcxQcLtTEWy4GNGk2vlKoHgHXp8=;
 b=x4iWMHJz4CT0YjYywG1jDeoi2TOO9ajZLAxZa8UWTQK/ygGNDU0FtRU54Z2A5MPqVFSK
 Sf0czU+TnjOPzythYq7k2ragvFfDSuellSOB1g8w62AWC0fNPebY9IRjn0CNZQzuVhAY
 O4a4tO+aOOZNo9F8eQgYfwReYqPpxDyawwRgn+iGsvXCdF1zbIOCb1ZQ2PjyuU/x3EgA
 AX1R9VgVtGC9W1bP5gHv/XuZyIT6Tub6LUPurtphzwqsZur0nyoDg4vKUoAlwqNcmj4C
 J+OLW7oNMP/o8P6ht/q1PYvfMgR+Qmfy3IOv7Rvice90c6myfjbV0GkIV6rgWir04/gF Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbjadhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 08:30:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D8USAg108197;
        Wed, 13 Oct 2021 08:30:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3030.oracle.com with ESMTP id 3bkyxt37s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 08:30:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7FX/CUR6efzDRI/+pzjeDQ40X/bt7eqrvuybKryGdm3MR/mFgzQjlxpAXif4thuhSajJreQCn+U9SbDTfpy8Br0CKIKamziWg7mCXxaI0UtWB/eAX/svaOX0pZcVMAQC1ajpFtkZk39L9uFW6iICejBDouwgBBmIBG5J9UmflWOjjUF84AMflFMi25qXhvxDfc1fe30x8Us4bQVLz8o264l9YjnNR3dh41agVAT84Abdpz8mCWi7PGeEAUW/Ys+5MzWRNFM8/nEy274j2xJJoTd3zrIjEwwy9qIIUEYjrn2wGZpJYL9GN6EmY9Oi89UIBILT6UrYvJhAzrLGQTonQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LP8iCuAyEErRjsajdcxQcLtTEWy4GNGk2vlKoHgHXp8=;
 b=cfWs0UxwY2XAobWIO28+ICCXhCVk3BDfNtCEGwF926i9C53m8LHRNcu7nKO0AvpbWvoooUuX3Tb5biJ1X3cY8HGhxazb4mRAEGDa9L4im7YGqfZ+3Gpeqpw2cwcU21PtCwaQHFoxIKiNPLJnpPmycT9FCaE4QVB3B/5SHottVm6ndY+OdZ/CM4g1KVGYVu6+J/fdV9zDkQXu9xCRn/25WcgLUgBCNfigs2QRsCGCUrF8oCBsogVKrkDTxoGae43X5hYaOB/EWc+JxlYcxL3CS4ut6X/m4ybwMXtAUQnjSjFPMDCelSWKCorNpXpkxvYGGEDqmXQk09jXSA//p+Tntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LP8iCuAyEErRjsajdcxQcLtTEWy4GNGk2vlKoHgHXp8=;
 b=Gwz1jamlVpKIjj4N826JIunUQzekVlhI9Wsm8jXZ/JSTpsXezxwSipjj//KimulS9C3+nrw54DGiScr9Gw9cX+8GC8AwptOkJPeXmdGMS7iImEMDmi0AL+JimoTgy7Hwp1ZMes8HQDaQRBCZAHXDEXoYH6P/qmn9PQrp5ehIF4Y=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2094.namprd10.prod.outlook.com
 (2603:10b6:301:2b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 08:30:17 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4587.027; Wed, 13 Oct 2021
 08:30:17 +0000
Date:   Wed, 13 Oct 2021 11:30:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: use scnprintf() instead of snprintf()
Message-ID: <20211013083005.GA8592@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 08:30:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9b7e63c-ca96-4fbb-360e-08d98e23af75
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2094F9FE9B78CA4124C506C78EB79@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8c34GMg6Mxd8FiIQDShl3sx0+sX/jA1impMrKycOgr61U04loTZJU994cvwvjP+8o9wzOwZE3ZaeQYiJo+kFB9vUOMPv6bSWXn8uMEB6CdwRnd78e+uaSNNtHu8bTS/kJpp5yjnA+NhQ1zSpwbMn5prtMzGMLfibs4MXCLCK369nGR3sKHFwUbxs2wvtW/74BFqLWw68lSOZ700nWwPTn6vllEhAvSnCMWJ4yRl04SY8HelmpC+0I68IPeyDrQ69Xce6oiT1MrIHuhR53/dc8aaG92Rv9JqmZwPfuBxXQTpNCmt9pR0kxN/sEmf0ERbgYVNA4mbV7+d5SbnctGmx1eiAlr2MugTPeQvSPNW75eqZB85b1SbNidtn5wFshjpb156TCA3hU3Z/7eUC5GheXrPhfSzrez7fUImsNjOI4MT9CfNXsLno9aXxNWxlkgY7dRfAAtujR4w/CThNkskj2GgW8Bo3TR+g0LXf5DRXpCozilRsGWt+NT0D10IOfvHA1Hxu3+4q7MuaxR7u3zBV/z7vskgqPqmxXSscTQzw/V4e061dl/lNat6iCfsB+ej1CxkDl1hgPwRHiqzWv7vmqOeyWx9Fv/oXwrrsQoGPDpakCL7FS1dEzse6furf8t0zenunphutgKOsu7V6SO/aPUNkwmOttfGPkjbG0G0E4thPNaRCapJSfFsdlFhZ7CM2YDA6PIxZUayhAoafccVy0NE7kdCi7KNgTuSKzpCv6g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(26005)(33716001)(6666004)(55016002)(66476007)(2906002)(66556008)(5660300002)(38100700002)(38350700002)(8676002)(66946007)(8936002)(316002)(508600001)(186003)(33656002)(86362001)(6916009)(956004)(54906003)(83380400001)(9576002)(52116002)(1076003)(6496006)(4326008)(44832011)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3O7YblysJc0TtbuKAAg1AXBB3aKInhqLxhsWJGhs1cZKcS9qxq09qf5YL9Se?=
 =?us-ascii?Q?e3KYfQo84sNQhcCEocD+KTsFsVMbBtTuZ23VXmGbwLgfjlHNcJo9BtezDeuI?=
 =?us-ascii?Q?Z6fL0LZMpjRcyRj6KPphX+C81eflUptKKGi/lX34+w4ztY3UTTBhZRzqKba5?=
 =?us-ascii?Q?pYZBclNdExFqOCcfcAaN8aUlVXtX2LsApJ14wEuYZhObAhN7exj/6yiMsIwR?=
 =?us-ascii?Q?L9ciGHInmRjoKvvOgyhsHAXY2BOnZKEiTR8uxldmXFZampGx773b/2ab+ZkP?=
 =?us-ascii?Q?LG3pCJjz366kE8pgZRFLCi3iOgdAvCeCfKcbwYp+YNw1IgUA9EeAHu2K0vUN?=
 =?us-ascii?Q?b5j34IKK4gANJq1Xsdl6dozxlsq6/0OXZXsNm03h/TH+USzAgmcj9ceE/EcM?=
 =?us-ascii?Q?9+xa8AWvTFeP/K3hD9veoxEY7C9GsRtNy8U+Q21lmZ4dGD2lLxMHu9ZoFTOm?=
 =?us-ascii?Q?XAvUJ6tKIVXEmCC9rRbbEgSWat/12eCM2cTSrCTEUWbHfvqiSNoSIeZEHV8Q?=
 =?us-ascii?Q?bHF+lRNe6IGsqJN3dT44Ye7S+wamWJ1SZIbeF3Wk9AOf+8PMM5jx57igyAmB?=
 =?us-ascii?Q?KlFi8W/Aql9/yC3mLFg1AX+Xq1rYtNMntfZDbZkMCCJdgn8fwxkNn+ok8tCi?=
 =?us-ascii?Q?ek9mBMA9YTiV04D2fPClBSzSDQY8nT3kd6MSDUeydDmqhkSmAxt2mdq/GHBt?=
 =?us-ascii?Q?YKNH1Ff4UuhRnZK9ooipEKj4UPENCI0nTp4IyrSSoHSFVhXjOB/CP1ADusBE?=
 =?us-ascii?Q?Qt23BqDVTLYK7peCeQLMBflgCt/TbweOOEModPcGm7+xANNfVyC5V3HtkskA?=
 =?us-ascii?Q?SvFkNHkxzMLdS099WEMWcVh4xonRUKseqwim3KyCpCUszm/M2lga6GMCR4Ol?=
 =?us-ascii?Q?7I2pHchKaromsDV1J2o00b8me1WrLYf71i0v0o9sbLNd/LRZ2YCEi2o4+ivh?=
 =?us-ascii?Q?0WcnfxFaVf+eTX+sY9HlVxi8gxr8p1Gmaq0c5I669SObFZsz8SvM+bQk5EOO?=
 =?us-ascii?Q?eQ8fwyd3xTv/8fVuFtrEVXr45lf7UAr6x9561RSKwqvI+lnw05T1NSekK6Go?=
 =?us-ascii?Q?NjqXLc0h17PknWH77DkwDDocmEk4uwBTrJKbw9BPOO7k0QAOjOyUcGWdnygR?=
 =?us-ascii?Q?v3DaEdoxPcG/DARbXBpmm6DJvbI9B72bgPjB/V+LgyPtdGbFklD80TI3uM2P?=
 =?us-ascii?Q?lAJ5+wesoXjyMmEdfEg4jH+4enmNBT8XSu7vOx2GuzRwwcJem1IPdZGqHur5?=
 =?us-ascii?Q?R3hoMRCQc9PB5p69uC92QrNDnKRAdF+jnTRcfQolTVcDf8Kwv3/t0rjiyo0+?=
 =?us-ascii?Q?tC9ZDf3lwYqJ2DJaSw1B44Rt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b7e63c-ca96-4fbb-360e-08d98e23af75
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 08:30:17.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LuMCHRbdH1fAS9I/cx84iFS6dWXQev40Avv6lG19LWAaeGm1itPpL4nQrB7v76d5oVUmjZPkjWetrLM0MviciEA5cZ1QrPYkY1T9Y8NHhU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=862 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130057
X-Proofpoint-GUID: eyfV9Ll4RMdnoqL7sRREdJCnl0WVLJxf
X-Proofpoint-ORIG-GUID: eyfV9Ll4RMdnoqL7sRREdJCnl0WVLJxf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I intended to move from snprintf() to scnprintf() in the previous
patch but I messed up and did not do that.  The result of my bug is
that it this function could trigger a WARN() if the buffer is too
large.

Fixes: 76a4f7cc5973 ("scsi: mpi3mr: Clean up mpi3mr_print_ioc_info()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index e34417a2429a..aa5d877df6f8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3045,7 +3045,7 @@ mpi3mr_print_ioc_info(struct mpi3mr_ioc *mrioc)
 	for (i = 0; i < ARRAY_SIZE(mpi3mr_protocols); i++) {
 		if (mrioc->facts.protocol_flags &
 		    mpi3mr_protocols[i].protocol) {
-			bytes_written += snprintf(protocol + bytes_written,
+			bytes_written += scnprintf(protocol + bytes_written,
 				    sizeof(protocol) - bytes_written, "%s%s",
 				    bytes_written ? "," : "",
 				    mpi3mr_protocols[i].name);
@@ -3056,7 +3056,7 @@ mpi3mr_print_ioc_info(struct mpi3mr_ioc *mrioc)
 	for (i = 0; i < ARRAY_SIZE(mpi3mr_capabilities); i++) {
 		if (mrioc->facts.protocol_flags &
 		    mpi3mr_capabilities[i].capability) {
-			bytes_written += snprintf(capabilities + bytes_written,
+			bytes_written += scnprintf(capabilities + bytes_written,
 				    sizeof(capabilities) - bytes_written, "%s%s",
 				    bytes_written ? "," : "",
 				    mpi3mr_capabilities[i].name);
-- 
2.20.1

