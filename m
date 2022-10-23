Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1725C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJWDHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiJWDGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFA668CEC
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tKAc007345;
        Sun, 23 Oct 2022 03:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=kLJzDMIheghDztzPuQqlOZxdcTHO/ksXnr7h4TVhj2MnoRUlhhcoiwQz3kCBsSxi0bed
 Jl9qgsS7on4q+cj/N0QM9CnwOX+t0GXXwqjhXO1oh2Rk8L79vFknQGXe3bMBVeMcOWCs
 i7z47yr3EQH5WGw6zAzC3SCY7U4PlQkOw0EzMB9kjhiBAk9LrLxJfztda9tJsMK7zfXk
 njt8shLURJ2bJWGGQn7ia1kdAUCZhVDETYQaplXjqBhawx9FXrNx5PMpdpTmp7N6Cxah
 RGWJ8x2XKSF+JoUzU2SdB/FRiD2iYtz91WULfu2k1He1e6cPYVrNRNedZnwscdubsIC7 Cw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xds4v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKrRhn015467;
        Sun, 23 Oct 2022 03:04:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2g7qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MO6pTiXWQvgFhdLcMW2xU6Q/TrDiNMPPOlpCdxzZglxPOHHgUSTFFY7h1BrVdbKOwScjTukrpEHj7h/sTQ/El2bq+hGN6b2VFJ66YVfG8nCkao7F3jRAkreiHUwqKpI3XwkZpnkM9LiMaQZqC5VVWsgkl4n9XG9jhGiKYI+OstGVGMfIMFp4eNiOEjzzvm7qaW1Qawoyg7VLMKqH7ruBIH6VW68u0MS2KDeeQFl1H+C0EJDl4rN4q3LOgrlV4uQ0cgcT/85oHbUTMpnqD0JdaX15/F+PCFZSkJyNMsoKUGtxsVKHqK+SHdtCZ6wuMSNoORfPSdq/n8Y2KVbxhQZ8wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=Cq/DVjyA0pNHioPRDicQPt801mJzNZW1Pn2ejf9c01SgtGOOR0U859O/WHmWNKj+Vg+XWIKQiV742Khk30Nl5wJbVKc7r81bPXTGFnXnbiZ3Ba09zAJO54VzMk/qNRpKEhF/dFiaye+9PLL7k7HL5zHOFwR1oX+07UQc31k4ipuzatsiWrk04dAvvd0q9EYeb5pbgDet7aJbyiWkZUROQT9SnEXwm5D9jFTy5T8gZaoCM7wy46ItQCZZxMFKaiLJU75QBhOuz91EdskaJD/pq0s9bpttMEoj+8MrFasmhw3Clx536//qTa15WGdJ5tSEnEADjK7iYvIWv21sprjkYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=pywFswAfEK6LTM1kq11T96BEoIVuen9aaRWKakFDAOkJxo2CG7dzqOxY9lrLf6yOhyGi3f1iQVbaM+SRqNBWhkdeU42iWdhm+lnjYqRyK2TXgSjdPWx/amBmwy+EhR9FwRngtyzezGqW3QGLeeamf3qhQE795Xp0LUNDWV8HRxk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 16/35] scsi: target_core_pscsi: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:44 -0500
Message-Id: <20221023030403.33845-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:610:76::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e50c1dd-1caa-4aab-4852-08dab4a34e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E64VIMDP1IruD9h/LL0qABizXfKRliiDaEwBUFKNe3bxDlNgtdMtHodTiwWnpuqR5nRBlvR/oloAVSDb8yGBwOw344Z2R//cUHk67yD5KgH4ZdPyUl7F0pPdz6gDiKaPcmnWLxHv8fkJRNckm76XiyBUloQjMnWMEzMMlcB5q43RKvnP4OUVseoitCI5b/cCe63CBGXj66y0GVxRvD+1Qg+on9oFGxopNlSDkEc0U1ZFVceo/t8HhhZ1ZjWbw1GP9cw2pVVxJSMpeqOwptGP7zsIDmkrWf2i3H9DtIEIZ3T2OHWHRQx6Fu+wv0D5u9FewKy2zg6D8zwt7JnOO5hWydWID3cFJ51h8c493VsJclBaBZe4zfOPUmCFt9XN2dVr1ht6prBcp4ntQaA4ZIENr4FSWuJlJDgOP2KpE/RXT9fvwLZtJTvdzTMct3L8jRAiQ6n8gDXIqzImbgKlOZxBJ8f4Gz3yvReGe0xQ+SGEs8shpHeYK+iMuKlaWHwCSZqv7r6YfShRM2r+MuiYvP+OfbtF3FXhbi85z/l5Pt6e7rgjReKj/R4EfFrupyw95rOr23hZyqbHWbeENuRcqX5iMp6GFRddwMIYsqA8CbIp68IEtF3o93xBNQY5huDPylQuGuOooCjzoeJJ2nwf7iaqeFYjJ3ICXmfYm5mghRiIiOwbpgNayBIbWpg6DYMvgFkKddSP7xBLA3o9or6MHeimxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cJ5C10faX1sgcPf1WB18mSpEtjGvEc/pjw9ULeZ6aYgyvEImyvPOApthaOko?=
 =?us-ascii?Q?P6OBYeBGJF/VarVJTalX1lL9EbHuVPf86Pi+pXyKtHRQ2JrrTriZdCNOKrW2?=
 =?us-ascii?Q?i3NpNgIRkRF6nSTGn0R0W9ehTxhBxW5EmMv/XMFQv2dEgkSmo4oKrQuvbnVJ?=
 =?us-ascii?Q?p0jz8fqdwaryp9jhnJby3n2W7IkOC8G7CD/QYFnrVU1eKisrk3JQliRifScR?=
 =?us-ascii?Q?5XChF8dXsqguVEZn3hnAY7omUGB8i1/bZqPqFjavo9ZhClt3lNfV/ux+rn9+?=
 =?us-ascii?Q?t/o6e4SW3zclVFsjrWomwOuuW/oK0Bcj/sPuwkeXFwKPPlgvtmTESqXToI+h?=
 =?us-ascii?Q?2HjYQM19niTlbGOZGYFzSEZHdz4H5RPGW6/PzZdO9Zxjdt0YIF3lgDTwVARw?=
 =?us-ascii?Q?68rRCBx1HgI3jgRKcCqS3rM7yzvN7OcEAcFSbrLPWggCSaDLzeLjG97lixTx?=
 =?us-ascii?Q?rc0Ct7nA6pogYMNICfFuG1tuAMuntVw/S+uDstux/3qWGCCphdcjKG2DVzku?=
 =?us-ascii?Q?EUsqfR1x+az4kswi0g2OgAxNu9HJdfJZZGXbA9StMBOt1N+YtWxfKJBDw1C8?=
 =?us-ascii?Q?fRCmLP17GIk66zlLbHbJ8Zw2ylgkv9nGIIyXLJfJ+9w76QtUpPod5/bh1j91?=
 =?us-ascii?Q?Lg5oS8xz9CUa8PIdrwOI1yqGasOXeHbtKmGqfOi78mJ9VugczUPg0JqtK3c3?=
 =?us-ascii?Q?V0mnW3tUm0ycEyeVP5gw7r0AKzzPjbmWhJsaNoaEd8aA4EOJN1qoxT68/607?=
 =?us-ascii?Q?zGIaYCY/nz0RSb3Q/UMO67wNeQixevqZie8oaXJE2wzMdpSbeliL/8fKu0zq?=
 =?us-ascii?Q?JAgugR+jZG34NGuLMwvxxQvOgzv7ot/ZBbXW/l/41MdEb0+Xrsf0IVR4iaOC?=
 =?us-ascii?Q?pzLGMFY7HuwiA5RFaPT71ZaqFi3SBprdU30UwRIeH9yN5GGplEynFqRDOwHx?=
 =?us-ascii?Q?WvTpDDxf/kYTuf40O4p9YMWQ30MLzU5+V83sLuslozZVvyVy7lfqQs/szjDF?=
 =?us-ascii?Q?3f0xMUMq/jxdzQW2x7ceVuPHnt0+sTzZl12W+x04rGy6iqIrDcVGcsP/xDR9?=
 =?us-ascii?Q?th6QJI113HzhuIGzyqDgmhwXDIFy0Db9yn2ZtTyPY3nTl5mQr6GY2/3PKV70?=
 =?us-ascii?Q?XPd4opJfRa/wvyAQJorWiFWaDs3GgdrG3eXYJxyuKfu2cQ9cZ0ZPoQn0ALn+?=
 =?us-ascii?Q?omoekg6V/Z6cvIHLmDda8AfHHX2fPzOYHkqqR5I2OjmIBcxl1c2HH94Sw+Db?=
 =?us-ascii?Q?9ndoNd1ev7f3DFlwyEja1sYUiIlJJ4r1fYN8VCGz4iO6ItlVjI6JvzqWVUac?=
 =?us-ascii?Q?tLk1jrslAssRf0j/+lFmFz85UgJmpImOx3FXZ8rH8Y+0hqxxMpYlaPXxBtxL?=
 =?us-ascii?Q?R0HN/qyWFL/YVMu4TRBZaiCDl81/Wma0IzchFAuvsEzqS6jJV1AB69g0/R9I?=
 =?us-ascii?Q?zRMcVlOGTH12axcvj1elvDc7+c+Z7LNZwMJZ3jYFRtaLBkxwA001XyKx0E6M?=
 =?us-ascii?Q?oRatmGR+8m1L3PildT8grISRjZBq8bnhIDOmR1H6hK861ZwZPod4lnbLyOoV?=
 =?us-ascii?Q?XB2tkTLnGv0gXuvkkNZGPKCCCafGRqZuvDj7y59x+eH5dj2j+7CaIAtpF0pb?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e50c1dd-1caa-4aab-4852-08dab4a34e1a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:31.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LkvzlsX+XZOJKWSen7blCQuTiePZLzqMrkUxbjq9m9ebxPd7umURcV3FYe79aBq+2ygHNRk+gWymZyonYvB776ETJZBsm7dN1L8/HXxx12g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: FEW0BGuriwQc7aDtCGUtVHty56Wn3sFJ
X-Proofpoint-ORIG-GUID: FEW0BGuriwQc7aDtCGUtVHty56Wn3sFJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_pscsi.c | 31 +++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 69a4c9581e80..f2f4ff0b53e1 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -144,8 +144,14 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
 	cdb[0] = MODE_SENSE;
 	cdb[4] = 0x0c; /* 12 bytes */
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-			HZ, 1, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = 12,
+				.timeout = HZ,
+				.retries = 1 }));
 	if (ret)
 		goto out_free;
 
@@ -195,8 +201,14 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 	cdb[2] = 0x80; /* Unit Serial Number */
 	put_unaligned_be16(INQUIRY_VPD_SERIAL_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = INQUIRY_VPD_SERIAL_LEN,
+				.timeout = HZ,
+				.retries = 1 }));
 	if (ret)
 		goto out_free;
 
@@ -230,9 +242,14 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 	cdb[2] = 0x83; /* Device Identifier */
 	put_unaligned_be16(INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			      NULL, HZ, 1, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
+				.timeout = HZ,
+				.retries = 1 }));
 	if (ret)
 		goto out;
 
-- 
2.25.1

