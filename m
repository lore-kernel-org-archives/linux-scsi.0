Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC574EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbjFNHTQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjFNHS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:18:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E81026AA
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:18:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jpRN021304;
        Wed, 14 Jun 2023 07:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=3uyodE3R3q3yhZoSXvEGv2FAyi2ghfpYkwumj1XPy7I=;
 b=CVlyoq4NTrHqsN4Yw1i6Z5L1C3Ci/kMcXm32IaeHpwy+xXLQ8upK8EDTmkH/XptDgsLR
 mpFLb0/TJMeK281gAdQXxplUydzWXfx14wGHyV/MMy/4BqTo2NbcClRDvWPE4Ncd3ipW
 84gSgsmdk1y9OCsHuBpeOUaiQRGRfTsfiBNXik8JaQUTaM4tPCO2tuTpGKZZVHTVDpun
 1vHawldJtVesMIRoitrMv+Ql6vj7Iuj4BKHPDDAiIOtjZw+Wpxeq6KUUL+NugbhQshR+
 AIIuf22jpveV/KP2KmW6ap0dLxp40xUlQnBNPEK+V7mittmLnmT555Pv/E7mYzspl02J DA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3evq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5fLol021717;
        Wed, 14 Jun 2023 07:17:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56c3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4IQEBx84Hm+VYj6u3HHJYAC75BzAO7xzA/gfHmJxXU2NU56yvu9ywgWy4VUQ4ZICNVQt9f4yU+/SiwGnpWV/yZXt0vxfuwplpvbZanFbDcUq2dcWAYfajsc9U8Axb4xubU2K5QdVxvljDzF0U1dU+uDLicbwg/kcXwr59tLf+CoF684e8nLkQDUfSUsCmI3qN5SAkFLALUUyvbMkeeDxgWnUq+JLbWOVGP0/VPL47Mrg2GGRBpoMxFhUmas+wAu50ikmei5w9Saafj9Wf7scGmLDRx1vzLCc6oD31c+XrjtWV1pgX/1lVndlScd2cwoUN3F2o/F7LeVom9+tmAdAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uyodE3R3q3yhZoSXvEGv2FAyi2ghfpYkwumj1XPy7I=;
 b=Kec8cMaDh5fPDAxppWPOQfz47ovJCdOUajHB0e/yRs5g+K0q7W9D3HwAnf52SV4l8sckWQHMVCnMVYYpOkviDyghX33YXMtLoUHtxLX/JQ0eilVeWqeJqzgzcJqjicNMvn8u443elQ0cGuXh2p3T0Uss4FK18sOy9bfuIt/9bSkTbYZWDfA5G+xfx4MIWqtOSdlGVtltsF50Y0qvoJ1MxT6v6jlT8pkPvgF2g5kZ+VgFdxtm6RWouvdC4zOBfJ4tfCeNv6T/ZxrOM/3qw4x7hP4XwxrUaTDG2r/UkeI8Mhvs2/vnNX1jwRfeuQoXlrGw2l5nagQmu8X2DYjIz3HeNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uyodE3R3q3yhZoSXvEGv2FAyi2ghfpYkwumj1XPy7I=;
 b=uRPfdEIpsDNfdsVNmzfo6MmqQyX63IC67iq9jzCuT4P607fhh9/FhoTzg9aX+v0giM0BTi2hnnWiX5hkqsn29gNRDLKzbwZfCHY7eEmHmeXrLHTfPK5jI4JcQtWZnXyGS0xexc42JK9DMOgJZQGnFp24PnCsc7mgLiyuHXDXMis=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:33 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 06/33] scsi: sd: Fix sshdr use in read_capacity_16
Date:   Wed, 14 Jun 2023 02:16:52 -0500
Message-Id: <20230614071719.6372-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:5:14c::38) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d9b21ba-ed2c-48e2-4173-08db6ca76c12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vcjP8VGWw11FCSbyJZzQKJ05yJczQCwziHq/7k31uYjCOiAFy8KY2FhcT8H6zQA7pmyUZ4yfH7Yfh6wDHJNpLZlpRP0cENgg82FR605wSs5Qa8ISpdQjGPZTc2RkJC7iCnsSYMbdImvk52CB6/r3r7WbnWL7DFGtMz29/ruRDGNY/OJ8FREY7U05aug5Y23OO4XHRa+S1LpdGzSyUQLhuj8wV6NGVGLWs1VqoZQ4wdLH55X4KF+RxoRl2dvsulZejgPQ+iA7p47U4MCU4TVk6/H30cDdS20Wv9/il5kb011o0/5n7f+OCHicYaYXZiL+LZFj4Ok+WzJLq77NIL6qt6EhOeCLQp9PeN9d8zS8CKCTbRpUJCFKrVe1Xz6cikjojHPWdPWzN2FxbcMZB+lvYMX+aH3qFMGPMsRv+j5Atvv/3ruWlMzPf+Pfr2kz6iKLPw7WmcKEjSc9hr6/B3IF7FH3QjDAB+aECF6G6V7/JFuSziVLmjCmL9hJDO2T6H/SSrYTIjiiIzDRwdXU5Y71zJb0FMWBXOvY0D2dXajIxK+0dGueFOyFMQaZcLyQLRtl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WN8fqIiDwbxW++gYBn4jIo2r09Y+qG9/7oWUtUFceRmDSmApUS9pbgzLGh+3?=
 =?us-ascii?Q?AMyP3xrzUHZGw+AOanN+f5nog2kAekphu657KeBVThXvoN/T6YRumLBcLzyt?=
 =?us-ascii?Q?zmArsusHi7uidu6lA7iwn04cR1uCn1jVOnLJ8qXbGHQL9HavIc74beNQ/CMS?=
 =?us-ascii?Q?L/E8L3qphYI+RZLEhvvE3AJ4equ/UmYyeHCHfpE48B62NaEfKQB1ziomEB/X?=
 =?us-ascii?Q?2CnKGWyvH2zy7Xo+rOOLhEOz11NYlWlqR2cXK9vXdWDuVsnxuZeO8k6hemgk?=
 =?us-ascii?Q?TRYdxMQPlIuCriv/I4w6wMJP18H3+GIl6561PL2mFjeuAa+2UMYkEkahBy91?=
 =?us-ascii?Q?L2O5lueRIGmR4jf5RIwMP1jWIGj88ulOuNN03X8oMMeRMQmwEv/uJPpUxtUR?=
 =?us-ascii?Q?n3Z2IvBKojiuH1Pho8vBNhfxdSXnTHGRBJRhAoW5md5zhp2uDQU7R8MeHt0j?=
 =?us-ascii?Q?qOGV1wt36WZuu6SN/nx67Awt/iLFwa+bzTA2xhr37RAeCALl6pNB1Z2c0phC?=
 =?us-ascii?Q?q78xQeAb1vZjZtltdjhkX3d8j4Dn1CeaM0m+QypomSvn1aQ/t8P9ehgLlAPg?=
 =?us-ascii?Q?SnIlVcBD2AO+KBTOIGGqUWvWYHBWY1tetn3xlfaJMEqldL3E0dIdoX4+raEm?=
 =?us-ascii?Q?dhuMxqzG9Go1HbR98As7wKOowmQgiOwjL8gBdNmx9aoT1KINmkbfU4KNz9mw?=
 =?us-ascii?Q?btozkPJ059cIIoLReXNUmSMB5YARh3AUoFU1DyAR4XcF1nsoCCsjNL33yinj?=
 =?us-ascii?Q?gowKowJpmK4/Q2X3yurbeQY/GdFgHM6TVM1sBYM98uY87LRW/zr1PuM5N91k?=
 =?us-ascii?Q?ugkb0GfZXGD6bCClV/qGsFg9C+wqh1mjqnUnR7Oqr3c9t6oG3x4KSox+mslt?=
 =?us-ascii?Q?JLX7lPfIInXXJ9nSg0gm0SRgbrgPj5Li82hFdq5pUXNcguRJns5grApA17tp?=
 =?us-ascii?Q?+Z28rMsClxjHBnEZGLYXoPqA5ALKfzrDwUBOCEQ8+mMFAinPEayKjz/RtBsh?=
 =?us-ascii?Q?Z0TkPGbiTKxyoqegNozG2EwGfT3pCBmDVXqPl6hctVgTRAFrchUIFaVkienM?=
 =?us-ascii?Q?KMkM+dO02NAUUvHGG351zJv7dZlMzC9a87zTfFGYfRfbUsEz8S2U6e8hSQII?=
 =?us-ascii?Q?o9gWe/g8bU3jmIDUHTzIfCqbaMP+oe74uCWV5cFcQpKF8Z4SYZB1+lKSXcLw?=
 =?us-ascii?Q?d9JV4gHrgXdx5pzDI7KSPqgzXD8sRbVAiB7myo8OtsfOvsVtixMZS+USvEQM?=
 =?us-ascii?Q?5LlKIxPILYEZyQfDFp2owN+fm3odJOf1rXMD5cQDRE13szgIvjJ/uQoAgwUv?=
 =?us-ascii?Q?/xtgq6J7bEZME+ixdvGQNzmB9DYVGKruDuPw6iraR8iRr7UG0yQmJEvjDApE?=
 =?us-ascii?Q?hQe/dp6gtZLKjoi6ToOKKzFZv5khafUsUtD5Vb9OI0MEP7Gqwy/Rd6apcv/z?=
 =?us-ascii?Q?iYlgThCLnq1zUp/zaKTi7jCMCG8Gno3bBkbe3HLUthXaEO9EmxRjeXEADwHC?=
 =?us-ascii?Q?of6MonYK1W2WhxDaNb7OfTeGFslFwI3LkmmA1ZWBJejy+KP7oFWoEVhQnHJk?=
 =?us-ascii?Q?6IV7ItDmPIQLlJdEyoHbrb3tsv8o65MtQFxJ485AfkZMRjRYyDlhEv7kFm2W?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9uzy1EAxuyO1KMHYM5bgI3WVV//XZ+lM/CLImh+fmyMhaZ324Itx/prDksvQgPjSnKfmMFyHxFEUbzUHc2710nBb2xHElJV1h5hZMXxlknChK5heEiEV+Ec/s/rKolXU2zeuPbjKTpXTfzRMlU2mJ3iAfg90qZHTza5ha4jyM1bOFoQ5wrvY3SCeKe2Yb7nxzLX97v1Mo1b2r0TZsjRUg6A/mDWvHPkQV6b7SGJJF6zO3Dv6bxVQsrCn/f9xSsDch6EfjEiUTluDrRdMbFbzdVonEVRMCAr3XK80dpEg7IMFjgNKo8vwC/kcsESwjil218q7gGyrfZ1Lp2eL61TYO73rQuYl50n7O3SHVW9q7l/LAy33t/LlePZNll52rwgEIqnFuMoODCW5zv8pVMvwSaDSvxHUSycz8Xuzik3atKHvLy1av4Y7+jluFN6oFb8nnChl5z32okJ8CGliIK4bxc8BzmVOdYGOoJmEWMcwTLy7hCEHH9q3JNL2whXrYFOcA+Zp+MDk28G7SoEMhFejjyzPrMgcd1vWekqYQ0/ukmvZXdXlYIOmQgHgoDlrapfpKCUgVVhZKyA/VoxN68Rv60igFHFQZ3kXUFhUaGdWE7LUuC3iRgJmAEvdzm2KWkXeMoFL1IKJePK2b3p693ugRihukh+hC04Sd6pjzwtcvuSZ+crXFNfO9PLz6UZ/NEIgAkYhNOVDO42zI8iUGozOuSJD8PM5yvUpmW8qmfRPJ6F/pOvm9GxuDKpS9nWZFM2y2+Ae9894cpRiTq1RuycGGajOtHQre7qCAML1bSQahqPD318sUUY6S84cmug3fXy5zZNIMMrfN9AVfcYJvGxXRFv+oYKWLbEcso8x8FjSuFKoSRX/parptGQIxfbVf1eX
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9b21ba-ed2c-48e2-4173-08db6ca76c12
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:33.2834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lb2lSlIKDU558zw1r1P97nTL+wA9K7HsSd6l8RxDBnTlckq/oaqG6PSPrudej8jqiiLDtWPf5bTlgt0S7vkAoMDL0Ysd2ooujsSgRxtEf9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-GUID: D5GcqrBbDWfws6nqdOyZE4I7sGLuL0Sk
X-Proofpoint-ORIG-GUID: D5GcqrBbDWfws6nqdOyZE4I7sGLuL0Sk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the_reset is < 0, scsi_execute_cmd will not have set the sshdr, so we
can't access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 84edbc0a5747..a2daa96e5c87 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2428,11 +2428,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
 					      buffer, RC16_LEN, SD_TIMEOUT,
 					      sdkp->max_retries, &exec_args);
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
-
 		if (the_result > 0) {
+			if (media_not_present(sdkp, &sshdr))
+				return -ENODEV;
+
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
-- 
2.25.1

