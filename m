Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56201C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291FC64E83
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhB0RIX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:08:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47982 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhB0RCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGwf3Z165579;
        Sat, 27 Feb 2021 17:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=wEzbYzfKix+PmW79toGO7JSjYwGZC/E8Ru7vqxwNZUc=;
 b=mBEBWaOvsa6IcGWUeBX2zo/2rv0/8MtGrue44Fp4bTSf1cr/pDPtb4YvJSwAg2YSCMlc
 t45SLdZ7xHUCN5tBFI4aLYJ0fDrX22WMt+Jz2mPBkt7TvviXC9utISZtroqLlZaZYzAc
 u2MO9MsfztUgXHMlOlt5mxGqfgnz+wDoqD8ealo4NR7iL4+boXydS8dTR45AQdhrTgnC
 lX46KJABvp3hlU9qA8dtEmd5b2HD8snpRdey4gJJHoEG/MKCKhlqoiEXOc75mMIUexT2
 EpMcifk8uq9j65ucKuvYHu8FvFHnu/A1ux8NyDeR/ortZTB3ZaR+O1neyZDUu4Kc49u3 LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36yeqmrpsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslme115709;
        Sat, 27 Feb 2021 17:00:25 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjksFnBSb+UxBbGUV98/Z5LSaPI0rekkK0GfIN/kHTHqGhmuswG4tk9N2M9tBcFMAL6v/pyjzCr614sVQAY35HuXC3f/c8kVTQNpQALFoaIZqcv0hjUFfnTsFH4ZctnpcSeb7dfTP99hYfEdszwyHfMj3DO+fFtWuh9Ahum+TRd/d7seuqtJ94VNC/WJBV+H/F2HyUmTrDHtzb+QNZCz0w8yzZ/dOZyFBfMEvvTIShXiVlkPRj0pbyz5tYY5wOGBoQRh+M28TispOgTxS0nyKlX90/NGri0z/MiSh7ndsmCI5+go/25TTk5uO6/u/3LVsvKaPwCR/YDW6mYghBRLww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEzbYzfKix+PmW79toGO7JSjYwGZC/E8Ru7vqxwNZUc=;
 b=YXAOHjUc91HaJ6TriJ9rXBFWtDDImByVI19oRjKp0qXSKh8/eerYGw4IBSpVWj/DPdOzOKg4SCfGP8dAVVzxdfPqweAmuRWWQUwg0yvwDHqJ5hTFpde03HlSuXWiu7twZCAQm5OUrva3NoOqmsuOKn6H12ZFMji0d8M70btzio249x1t/gHgi6oy53u2TzEyZfKOOY6nJlp8uxC8hmS+Q/HWzt0iyHdyA2N//ENi/xLl1pBxnzILTKPtv19xB/3Dvsv4M53HBEioJIZlWdbaDirleoXPmtGwM6HoN+OkrifhS/Yo54vLw7bydo0/Xxdi83qBbQLtzRlzJkA2qS385g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEzbYzfKix+PmW79toGO7JSjYwGZC/E8Ru7vqxwNZUc=;
 b=VV6+e8OrJUEv7C338VUU5SdCe4Hnv1ht7Bk64QdVvBppFF8NyZdOP9D7HtJS5MOU9tVUhvCU8Gm80Hdu01wlLGou1bSX6C1zb1OOEKNyPeTDu3YG+2kqnn19iDnGAnVuWw7DZXDlCJoVrmFwDu6+lpulGKStNiTvHDZtjygB4F0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:22 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/25] tcm_loop: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:49 -0600
Message-Id: <20210227170006.5077-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 296c87d6-6e28-4dea-4b29-08d8db412ba5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499B8B842AFC5D64E2E0BDEF19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TCgI0Lj5fllRNGVy3J/p+f6EO8IjR2CoWbOd1TAxpHKirsuLuCkAjAbsq+FO5POWouy86Fnz/XZIppuYjNih4gVpApdwlzBLmlnPTcTblPKgF9vF4q42Uow2b1FtE6I84ax0u2dj/l9JJX3mqtSIAqGgozD1SFOImzOtWtCclZ++Jcr3mUzSj8wAf7Kp15PT4nbQyrJt/zm/rBH5fof6U9TO99CC81ylRzHqvdFfJsOlulZVHX9SObpcOuRUuv8FTVdhqTsRm/P0q/9CSySm/I1X76bXAePsjO+sNkajwSt8o2eFoEceO2hJGfmZR/jxRMdsUCi8dfjt33IjC2s4i6khPlIOePpdXpZ2Uwg0q2bHdkXXyGpNBlbzhmfAcABCyRO8YOAOCccV7PAlXji28Nko7lorr48Ip8vTp7Y5c2KZUwDFTrV0REs+0CHAPdexu7qLc/OSWpm6VpUeQtr72elQJu1maVlp7P/+3jmWUFEI/J9zf5Eh3xz2Ab1GbgpEXQmniUkbJdH4FFRg4a4DGKjNX3rAiArcPGvJJDRRgB1X3INJhLRKhfovKBOtKoDmjD7Cg0oqoldA71Wd3fW3iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OMtY3mNfT4qR3OjkYW4AZew1IRnOWaU98RK04mcJAwATEYmPTGyPH1ASMbpb?=
 =?us-ascii?Q?7GoV6vN8VdOHiT8Yatk+R7gxdjBYitkKOAmB7tHaKpvFgJR+G6fzOWZzRyYS?=
 =?us-ascii?Q?JjX/iJRNhaR4KkjuAsmgIspHdD4Wohby9fkgOHrc9hbec3sxYYe75335Lw82?=
 =?us-ascii?Q?jhJi8X8kTPt8YvS9U7N15Ll6o3Asew78f0rrAwBzBgh3y6VM/Es7Peep0c9D?=
 =?us-ascii?Q?xl3+S/cIuC8Jfwar5Dm2T43f79GV7Xip9EcRDJ5ouZLafqfBp5t9ZwpyI2C6?=
 =?us-ascii?Q?q+GVfoHOkeGQYpBPgv1vl0Zhc+xUrlAzt9CCMR0g/+0kguuAPZGxo28ihXmt?=
 =?us-ascii?Q?pTLSbCts58IsMz4JnY6n7mvlls0uGjX04eDQVuE/JeR+4ypLY6yJY7hw/9cg?=
 =?us-ascii?Q?VlA088ubBmDCPl5Cuz6H5JtgJNbS9IZjikKUue4tXmg8pKlKZ60lOYYZcvZi?=
 =?us-ascii?Q?REdWQMEFv18htLnYoGVivM2zKMxMfXebA4GWe/JpWYuH4dFS9tjBD615fpPM?=
 =?us-ascii?Q?/XPDnePitrEj9eN48O8JWNKfhrPmhTCg3v0/7un5WhFfOOIwlxaBt1rGVKk1?=
 =?us-ascii?Q?fkWsYhej+WayNMYVRNAcQwc4oZgYdPDhQ1LiYpOZtvEkhoCZF/ir5DIstCGw?=
 =?us-ascii?Q?5VVMkcSnYHoMNVb3+t6prYd4duZIjP29HiW10Jx90NNOMP9eO1ch7AmZtXV0?=
 =?us-ascii?Q?mTd52MASNXRo/LyJiGE6fC7Y0AL53xKDydvxRjNjMMwuDOev/87sQWejsH4b?=
 =?us-ascii?Q?xNGElaeszjkK6FgK4QP7npm11rQnufrPBJaqxaaMbiMAkCihZP5TzgCMf7l1?=
 =?us-ascii?Q?D6qMdmv/ZyNbSDRVjq8lsT1mily81bmgFCZ0MaQMgKXSX6nc1ZLQLZunxypz?=
 =?us-ascii?Q?VBVtY6x4RFWxcWby91m7QMpFqMd8Bhu3hByMV2iSiPSac55+AzZyJd5UJnMI?=
 =?us-ascii?Q?hVwFQajDduzr/daJpxVtekS4WjxC2BSsgmdZ45F1EQn9w/2pbAWu0U3wYNMr?=
 =?us-ascii?Q?TiBNFLmbMJ3lNxmf+sWiT9S2+JzUusHcZG2zuQ0kpChsSAvWQBpHr3Kt2Ui9?=
 =?us-ascii?Q?E68j+2/cMupWXlqEYjOEHRiYlWCt3Sc2jUYFdwbhNYFDhBD0uHwtYb3b+BUF?=
 =?us-ascii?Q?OTUG9CIIT7dEj6x+sQyfC/gbsxT9TXVchV2YkqwGZolq/gGOgG09X9sITvcP?=
 =?us-ascii?Q?Op95jgTKrCREU/zU/exOLqi1GbMZ9TPlcJhgSccuvfgr3ZZpwpykgFwrzNnt?=
 =?us-ascii?Q?Cc1/GUXvLfsluklCR2UCBcM73JM5jKyH2BSXr5maLy0OBF/pmN/03uk1m6Rw?=
 =?us-ascii?Q?Ar8Vrpkq/CaJ/RhX9DyVaG6V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 296c87d6-6e28-4dea-4b29-08d8db412ba5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:22.6484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1ZPydIdsOYgDFlMGKoOYVR+heVFg4rsb8JfsTOKzD/O2V/JUVwiSplkiPvUMJE8sZrQRyEU2w+1QdCnza4Pxjyi8WjBakElvS8nIY0bsHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert loop to
the new submission API.

Even though loop does its own shutdown sync, this has loop use
target_init_cmd/target_submit_prep/target_submit since it
needed to map sgls and in the next patches it will use the
API to use LIO's workqueue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/loopback/tcm_loop.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index badba437e5f9..461f4125fcab 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -113,7 +113,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	struct tcm_loop_tpg *tl_tpg;
 	struct scatterlist *sgl_bidi = NULL;
 	u32 sgl_bidi_count = 0, transfer_length;
-	int rc;
 
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
@@ -151,17 +150,16 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	}
 
 	se_cmd->tag = tl_cmd->sc_cmd_tag;
-	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
-			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			transfer_length, TCM_SIMPLE_TAG,
-			sc->sc_data_direction, 0,
-			scsi_sglist(sc), scsi_sg_count(sc),
-			sgl_bidi, sgl_bidi_count,
-			scsi_prot_sglist(sc), scsi_prot_sg_count(sc));
-	if (rc < 0) {
-		set_host_byte(sc, DID_NO_CONNECT);
-		goto out_done;
-	}
+	target_init_cmd(se_cmd, tl_nexus->se_sess, &tl_cmd->tl_sense_buf[0],
+			tl_cmd->sc->device->lun, transfer_length,
+			TCM_SIMPLE_TAG, sc->sc_data_direction, 0);
+
+	if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
+			       scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
+			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc)))
+		return;
+
+	target_submit(se_cmd);
 	return;
 
 out_done:
-- 
2.25.1

