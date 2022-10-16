Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA10C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJPUHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiJPUHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:07:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E7532A87
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:07:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GILn1l004100;
        Sun, 16 Oct 2022 20:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=RnUSxlfrGNp0lyeCND4UoerUmbY2JmgLXL2pZhEzIR+dKdmE8eJ3oc/TEeUNBWgJpG4d
 DJK69PdYwnD+jYxlxmvD4SRjSfbk++PpnohtK1tidlJxI7f9xujY1hgIjM8SEyU863kR
 ncZFCKKZQ2XaJajfp7MJcMolv06KhEdHdW6GPVjicTKT3ZouwtXmdb2YJAcStIMgYmp3
 iV8gPFNDYEIsVLJK+4BvPtQwIDbDqFl1x0wwgPGnN4yAJHeCgt+ki/q3xvMXsEGfTyd6
 lvIaX0f3rGMWyGV3ms74OXa0C2iHuoZSf38p88WbDhwmWLXXLx98QD+WvgBgV1GfRoOi Vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k85mfs61r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:07:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCBVvL029453;
        Sun, 16 Oct 2022 20:00:16 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr84jdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRJyfDdfjigO2c2YSmVmQJ9ltRWMHuutSwfXNzYLvYXURcgKAkAfscXMRo+hlPVjoQGid3jj8yLys5YNukD6Cyr0Ekryk1Yo+GDKgXbEmdXoCK3FzcYio7alGyGQWfM3+D1AKv+PpEQV/BEcYNiRl2rOqCcNtzYM+W4CLpADlCI5tGXWLlXw6F36hNVWZKCHVTC5uDmMksQ2kVbFK2Rv8rO2xkJh/F6RTNqhSxyQ0P+/HDEVfHyz2lhO3dt6JmmPSs9N1UdKjzXEj2WEFBPMG+mX/xtd6elxjhWav3PXfdkIZbdu6TnlxHHxAbCeu2V6exmnNoqLem1hjOppVqc2lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=Kj6Gd+OSSG5qeNDH8r0x9ZbbKAQzdLfI7awfrYjcZZqqxdyXkTyqK7BhquMgBlknFSwXbi1faMCCVrLdA1LNk7uob2iU5ZBZinDOWwuFe2jlM19+oDTA8YpWvHFXaZt5oysX/Y/ltB9ulZ6mmutuvxl3zp5fUQcLP3h3JHJSrriJTas46zCTOhvKB55fCDs6UGpWOmtEFMg9Kr13GCQuBClRe9roaC3JjOZPBjYlgwxOehKEHHs6cLnzzupE6f7WWdQ+ZduauW3gMrQ6HgJYRFpZTN9OYH+yufOKT0/oy6m62tTIZyOzx+hXRFkcTiNiXg0mKZY28CIChE0CFxINQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=SrxhaJJ6yZkDXmZGmsKUp9UN1DZdnExyo2aE7+2QiqCXdKy4vM8xICdjgAXMrRH+rm8I9fdPnJbO2JuRCZ1fi8xtPBfjff29pF2XKHb0whGeGIEq3rErMx5AWEJCsKqLC+ogPXpP9D60F+8PE2N8hPLwhYXC0TmGtpwYjURTcxg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 16/36] scsi: target_core_pscsi: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:26 -0500
Message-Id: <20221016195946.7613-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:610:5b::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: feb32b83-8425-4d90-5701-08daafb10a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A0GkUiejuNKspuS2JICY8wDnb6jHS+9fpKCtxHqGTv5FHtQr8Mm/oqSUSuEDF6Q9dEBfvKVGzGRj3EGV5Q5030ETIuqTjFWDPzwyk9zG8tFXJNl8oCLMScnDCl3SnSFL/uqTrma4jNHm7SRyPJU/ZFwSyBG7xH5jdyBxUs1WTwsAiGZFTo87qtXG2dhVHkfkVKtGHTXM+w1WvgDsl3zsfPKw82AIc8XgL+OjtLQg7EMORxkH1iuGB6/5ViDMQbxSfdt0kN1MuubEzY+eLHl/co+MJBC2pQh62JYTmDauNMELIB5Ao/DiT+ukGO4Eo0mvfmLLzTv1dMPCdYlJ9BL0NjiyYvkvPj8NUPsMSRRJvV5i/YF4zp/XzROtUi5Pn9vNlJ4P5OdRCNceN117nOvs407RO9I4mPohpzhzTXd1/kW0uce5TpExLmethsxMDj9m4jP0U8Bn8LjBmRq5kA5WdhwXvs4aVlJGhkJ/jR3eVqQF1Z+6SzbUkObjPEMc5nAKX0Z1Uup90cWj+oLCD0YUiF+Yj+cqLVjY3X/+WKAZ3eEAIcjNSwfmMBIO77VRNHf8GLsLN+GO0qv1FJqOGyaz326YmfE8rszQRmwlDHWATxL/FMyjKIvhEoBzLgh8DYjg2Sx+68ICpkvIxP60jJg4wBs9veyJWGOoEiZ+d76D0YbR1XYbSTcPA/XuuDhwfLtlmEi4OP4OmvSdnRubZpaVcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n61H/gTsZR+TOg3aJ4pR1/NQqDeFVxnoeWP/PFI6FgakzyqcITlF+zefitHE?=
 =?us-ascii?Q?hVMviuzgNPuN3FwiP49j2XZS+Ia3ZbzzRV1r1b11qkFmkUAgAlNXMhIRQ4Y0?=
 =?us-ascii?Q?Np99ptYxBQkQb2z1Kn9gaJTA72fWivHanBcxJfIZtZNdZQlyvq66R+UC4Urn?=
 =?us-ascii?Q?j6e7bX1wXUHZgdQnehPOcuOw7jn3ul1MxGYS6FaRDBdEUxP8QD9fEujbp7XO?=
 =?us-ascii?Q?Gcy/VyY8hyJD/xmuEvoU7H1HG+j4doKgida13AU7IMZ7JfruQZKoRIZeBQzo?=
 =?us-ascii?Q?58iV07RnVCwKRgQPyCcOQid8AKBbYOUHRYN7VqcI0mwfDJ+kOr0CXY1oxN0h?=
 =?us-ascii?Q?8InQ5BXoeh77V4Ya7e6vWqRijgqGZjNMXpkEtA27MBxjIGjiUBGj9eA+P8JD?=
 =?us-ascii?Q?0xzv9jyDAryKdz4qaTUGkHqtJRGrK57+PfVJIYkM5QzKCnTsX8iuW1nsL7KF?=
 =?us-ascii?Q?3YCjd1LXTyOpvsOgUfKU6rXxxXxCXZmSH8dmifeqN7zDZooG8nrMNNLetb3k?=
 =?us-ascii?Q?hZBjCfor25lm0/jfNPKsQ+vCGQPjUuFxRA4xSPG6Pkk2wlN2rOJioHIj94Ny?=
 =?us-ascii?Q?Lf9Actudspnkr0ZP7jc4fj5wwj3GZr3UZsV/xowaReuB0ZaX0wSQ6cPqPYxC?=
 =?us-ascii?Q?7lltSP/xjOzhysBW2l7IN+EOfQ4k/JyVkGsmNLdZqZAgJBN2h3z7bvfAuqtx?=
 =?us-ascii?Q?Ke2MHWSN8U1tIWP9Bx1e5btFYTa0oZOLh9pvZWH/yFygiyEZC70kYN14sdxx?=
 =?us-ascii?Q?QJmNblm6UuM7fxvafNOgZyApIgkDET6HiYlLxbjslKsXskKBRY6SHGssTsOF?=
 =?us-ascii?Q?aJai45+Vb2IQp6JTewrDuY1dDKkszp7LLjYFyVQRfCe9a5k8TiHiHrJoDU4l?=
 =?us-ascii?Q?TBZsBgw1Qfzzcuukq8zqo8KiVSGdkw3CtpuaFs1BNtRGsb/0u2OjzxGZns4b?=
 =?us-ascii?Q?aW7imoA9cImF50BzSkSJeDRhoZYL/R/MHfp/elb6HzLlmY7lM1l5J8pcNl2R?=
 =?us-ascii?Q?mPWMKTH5Lf1T7zjMqW5YMBQ4rhBn/Oeqxg0Nt0tK4TxqXNFZv+pcDXj18ZKG?=
 =?us-ascii?Q?X5ey9F1mz42QVSJ7HqdRHMg2dQswwnjKF3k1RkRLC9regdcWxInHaoIi5Sp3?=
 =?us-ascii?Q?Q5n3BZMMkhCNuET6mQypTbBHleqga+agRZn4OjGCf+0te+R4Ta2MHjwlxo/L?=
 =?us-ascii?Q?DPTKRQ7HG59IhmQJQNTOTBNUkzUCuKAehNc3T+i3hlORBOH1Gc4DQ5i4JH9r?=
 =?us-ascii?Q?cyJrQKcd8neiBi2TOlD90p3a6M2BaE96umXtN7b/XbCAnmjYigJH4PDJI6Sl?=
 =?us-ascii?Q?LnUu7MI4H7HZFZU5zTyz+3kXCQF8Q3lcK6t+o6x1Utkz5c0kKZPSKfnJAjpT?=
 =?us-ascii?Q?pIG6PvfbpjVllkxL01lte/U1RB2mFn2FNDAoBvkQfw0dwKZbbjdppgnly6Sg?=
 =?us-ascii?Q?4xF7tRR3HoRxHXYdEn0U3VaxPsSpJmNb04DUt1kxQwHFpzYtzdlTQb3K09/z?=
 =?us-ascii?Q?qenO1NOffx/yAVJ+NCOOMjfzOLKoAbX5YDrEMAx135c6ekdBHqTfinH8K3bs?=
 =?us-ascii?Q?VFmZFdUhttxePi0SU2ubwRGEvN1N89wsw+c/jXPumzW5UBdsawlYogc0SSEM?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb32b83-8425-4d90-5701-08daafb10a5c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:14.5648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fuwmQv1A9avW+TjC6BOJHcuU65a0j+MzMpZI0516TBZrDgCZSoOoXsSn74nlQWgLTKc4ni1CeUPve3xdw7q5PU2WGPYmJSkQ2CUBUvzR6a0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: IZOgqXYNOsyyW8kkqAFdvL4Ojt5-hQUY
X-Proofpoint-GUID: IZOgqXYNOsyyW8kkqAFdvL4Ojt5-hQUY
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

