Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70D6C48BE0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D24E61426
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhFJDQZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:16:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46172 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229963AbhFJDQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:16:17 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A3DQ84012935;
        Thu, 10 Jun 2021 03:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/4LVdSuthfsWKE1wSpPA4IZbSqC+2at9LnEb/ciC61M=;
 b=OE0OHoW4KXbkkU1pZuYaKexIpMsINTcYnSlJYxPuGv9/p9GF/rkDAO7q1euikQFZbWpp
 DGpALhiUaTmk+TpscrIYg/FWMOFMxdgj96DhJLmlV+kNFt0DPqkEz+NIl9Xa6SiakSoE
 PxFBGJGaO8qOmzYIfDWwVjqhlkqGvEJiiVM+w9VkwPmgCCqyuXakLlhFdzM2r7qvbIfb
 KkMkdhslq5saQcER5zda/xfnrAbuS5N1RfvfhvdAON4ouYV/JFJMMA64Ds6D53aB9Fzo
 aYXgARxOPJHu+/gLSUPugw/+yOX8bBA8hlhPlcnrsNzmUqR8nQSqwixWTpswFdWlrSFO 1Q== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3926dh8rjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:13:26 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15A3DPlV029921;
        Thu, 10 Jun 2021 03:13:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 390k1sg4s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:13:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHug2xts+TY/LGs/TYm454JV/htPDa8Ena1IRJXGbmzu3APV5ANg79yp5sJKe/2U8Be7ttfkNPlI43lDZhI0Sz6lOBzcK4I0EjICtXRk95/gVDNfh4gRRXZRLz2hRLhFmWj4rOLw/PzflmkZAnBmfTEYqd4l8vCqqpdcP+Qx1Xg1qPtdx1mFtbxthOLQRkDs3oILFFERapJakHUqdDAIGNg9wcYzgP4j2DT8rzHpxI2EcS8JvgVbDhR/TUgsaFW1IhaniwVbv/HJdmPlWzZvFWOCLZSV+gn4szgt/B94V57+lQmxQ1Q0IGurW58Mhy+ZJ55Q0m1pfNRVLMsrbcu2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4LVdSuthfsWKE1wSpPA4IZbSqC+2at9LnEb/ciC61M=;
 b=MPz86wq6GkUCRfC6pYK4+eZlJEXQchC9v/cVJ1wwXfFQ3plZcG80f/mOT5NRzlZvSxd8gh/wycSdA5+FDC9JLaaoPHfr6K36C+xNgK31Ltdmn5nwKh8NCJNE3tl13AxHy1bXll8VywpcS0d6/tehq5cREKTNh5Ct7xIYslHWnlcoxfdHCCCeBtllakTwp6iaBiv1EQlmKjoUFet5Z2Aai8fw0OvPXEPTxFcM1e9CPRvOlBURjtDnGna0JdQmDH7wAGURI461WANGdcatmKMuyBtzeJ3QaybaW6p/JhuIi3tuqXrEx7hb4jSRXHLwnJC9jqoFFda6CeZKPve29FQm3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4LVdSuthfsWKE1wSpPA4IZbSqC+2at9LnEb/ciC61M=;
 b=dgp4q8Fr04I5Tgz+BjK8ASxkJYKaZeQTfC12JV9/oKZJEoYj5tTqiPV3mE0AvjlX8ppgRzfacA6iZmYDx7vGvqxDQHXC8VtcT48fHLjAS2egEaRvnAqYBwsygpge+PBu1FsPnwKlxUpj3rmnSVAORZLmO5HDOmLrc+Mg48fzhH0=
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5483.namprd10.prod.outlook.com (2603:10b6:510:ee::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 03:13:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 03:13:18 +0000
To:     lijian_8010a29@163.com
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: deleted these repeated words
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tum6fm6n.fsf@ca-mkp.ca.oracle.com>
References: <20210609022221.306132-1-lijian_8010a29@163.com>
Date:   Wed, 09 Jun 2021 23:13:14 -0400
In-Reply-To: <20210609022221.306132-1-lijian_8010a29@163.com> (lijian's
        message of "Wed, 9 Jun 2021 10:22:21 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR08CA0018.namprd08.prod.outlook.com (2603:10b6:a03:100::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 03:13:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53580f4a-3b1b-48bc-675e-08d92bbdb193
X-MS-TrafficTypeDiagnostic: PH0PR10MB5483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5483EC81F27B2F5B98CF7B2F8E359@PH0PR10MB5483.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9H6WIB0p7LbrvSNoTT933lgS4jTrH73JBlw/dh+5XzPAAIP3lYvJUhXGU6TFcsCXw4U2eSeqZivW15dlxRjdkp8aQyG+ft8GXCbOsSIS8Q52PsdbRJu/Q2WqsNH2xdCe0UuqaaF50I8831nQB8Ds9REFuG6KEmcwYHMGV9+I2F1Yaq0fKEn7NLggBRHqBMeZt2Kr24bTrzj+g0jA9hCAlWqXKFaenYSNTlgCxME2DDVnKaGa4yLI5pQ/jKrasJi2Gw8MK3MNqstklVTVuiMIrgpvCJNUb5t6SLPpD8Pztj6BGRwAStN4Ou6RXCTy0Ic9CnWvWkfqKx63fZwPZD0NLxyuXa4w2iRw80FfEAOyemlYDpqZPEbxtoQNGj20Vgp6lxh68piVRHyvIOvAYewqz5nMLSKLaoSU5GmbNTny4zEZ6/TqUZnF46pjwD144uQFabNbyebG1MER8/BIjK9QUHUhEIIy4xKQXKdMDaH0AM2Cg1SnSFbdCn/lYdTzjjJxxen9ifEVduN1bWtLjHE6q6Ga7XhApyuse79U1a8BT/Bdsr4yrbF0pHpSQnyAGfHtqFTffog/AJ+rxoAEJwFBTnVgOdMRoNC59sfwe0w48ne18p5kWXXBTTovgQAVbiXkYaky27lSbYVmxBQc8jtKVCNwuwQyC7HsBWV4GfZqsAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(396003)(136003)(4744005)(4326008)(6916009)(83380400001)(956004)(316002)(86362001)(478600001)(8676002)(6666004)(2906002)(36916002)(26005)(7696005)(52116002)(55016002)(38100700002)(8936002)(38350700002)(66946007)(186003)(16526019)(66476007)(66556008)(5660300002)(1491003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A3XMV3HaD4N3hs+kyM3Uzk/PDcEFPXzVX4H5pdi7dVAGFuOXqXAt8AtzrFFN?=
 =?us-ascii?Q?yEyY25tI9ORBujYvynLR51FD8NfGLOeAXIMI+vnMZ0TF5uUAP/DOvI/sgWVB?=
 =?us-ascii?Q?TbNnM3kplMDTB+jZR31QHYEuG2ecVf28BKnqmzLsAnSo3ghJLlKQJNcYZC69?=
 =?us-ascii?Q?fjXz6i/aeeRW0pMcx//OJBE3G2NMna1kpI9dprzxhKrXLM9I81WB3y14yJCK?=
 =?us-ascii?Q?2Z58lvsCNh3tkJxFxzPNS0amg3Lb6et96vtynW5QN6hx6AHXIkkGZJdtCEDK?=
 =?us-ascii?Q?H8aEQiSp0JGe/G6hnSgttBab449RgkG4hmIsZv6wPTgd1YuvCK5uMvVp56Gi?=
 =?us-ascii?Q?BsGYrcZgFoCT7w8yytt/SFjHQ8DUzfpnHmFaRKDO+ggzxSrf7DI9R4CQFdcY?=
 =?us-ascii?Q?50yTgpB2zJ2qrWLLCg+ZiQoVzRy4o3adh9O/70GhemGnkNjVuLVGp4BQg6fh?=
 =?us-ascii?Q?wFLavR1C+U1UnIAayCBrIP6fwyNtcipz5Iy++VR+XpbblZmmBAbY6R1Al+R0?=
 =?us-ascii?Q?VffOV0L1tvVonX6L1DqjAK1OalAmYtWjyORHrjbRF4YL/NzY4/VMlE4a89/b?=
 =?us-ascii?Q?jn0a/6lWhC1U3yLTr9NNpGU0H2Vm42hh2gNwv/58y7ohezWrt8pA/ULzFTji?=
 =?us-ascii?Q?rcUnF7/j4htkRyi7W/lEZ0cQn5eLNtmv8ovmG+8GB1sJGFngUDuHYdqFHDVO?=
 =?us-ascii?Q?pp0i8OeR138L5i08LRI6UND2tEcaPmLdcDfoR5OJOgavtLqV69AYMTRW++gD?=
 =?us-ascii?Q?UzH0AXnCPPaeBE84/CTos0TvkhQYdw5M/mKZlZwtRsrAlgXHtseSI7x5UJK7?=
 =?us-ascii?Q?hYHRoOROgYPsv2aZRfv8i2wjm+BCT4+dRieuvGdJKNcrquGSRn/f1iAoBfu7?=
 =?us-ascii?Q?K0VHzGAXZElG/yKpvttju2Z0tGDXg0DTFNdtfzRzMfSmYaJiasnfO7/w49w2?=
 =?us-ascii?Q?Fm2iYI1CGt5bBT+SjE6BZ2r2aYYy81Dj16bl+TtIUCS4S4bBFfHEOMtGrHK/?=
 =?us-ascii?Q?W6Z5GvsYC2TA61fJDxl4k80OSoSPEkUacT96HWnK5jVi92uyYPiaH3/HI0wd?=
 =?us-ascii?Q?IuJJDJyuT5CAyLN1PzpQDOVsJl1RY+++rimjeG1zAK84YiYkYC/skaBZHW24?=
 =?us-ascii?Q?wK7H/wy2jRghQVqD/goTlu1BhL/mTsdZuPprzzbwrERu4kJa40apN6/XfY//?=
 =?us-ascii?Q?esn8VK+weUd2AADnkjA5inHKuWyvOtyiLSvOvwOvtTNizoCIhVCQUhjk3o7i?=
 =?us-ascii?Q?6VcVW6tQcyQaFNfCQhTCdGexyvXbuXBh3Qm2rBcKjEYfyXiqYQy6QHWor/sh?=
 =?us-ascii?Q?Jhf+favgMYGthbGhZzMhvIzc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53580f4a-3b1b-48bc-675e-08d92bbdb193
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 03:13:17.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kSndOCjzRiJEMObyfmbJJHakrSGVkwiF6oIirLNzYcT8CrkPR+K1etAwC0vF3aPwNgdpKCiHF8QIuUWOPocrVD671HMy2JGKw64OabMhF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5483
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100019
X-Proofpoint-ORIG-GUID: NxXvZXVYOmm0ZuhrtePJq3TA9GdcdykO
X-Proofpoint-GUID: NxXvZXVYOmm0ZuhrtePJq3TA9GdcdykO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


lijian_8010a29@163.com,

> -	/* Fake the the following irrelvant fields */
> +	/* Fake the following irrelvant fields */

Please also fix the typo.

>  	bf_set(lpfc_mbx_read_top_topology, la, LPFC_TOPOLOGY_PT_PT);
>  	bf_set(lpfc_mbx_read_top_alpa_granted, la, 0);
>  	bf_set(lpfc_mbx_read_top_il, la, 0);
> @@ -5905,7 +5905,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
>  				phba->fcf.fcf_flag &= ~FCF_ACVL_DISC;
>  				spin_unlock_irq(&phba->hbalock);
>  				/*
> -				 * Last resort will be re-try on the
> +				 * Last resort will be re-try on

Please also fix the typo.

-- 
Martin K. Petersen	Oracle Linux Engineering
