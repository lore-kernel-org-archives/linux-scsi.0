Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC94C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 08:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbiA0IsU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 03:48:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5152 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232313AbiA0IsT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Jan 2022 03:48:19 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20R6l0lX012678;
        Thu, 27 Jan 2022 08:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=lQibO7If6q8cs7FYfri606SmdSMNcNRWJX4kd8V5QIg=;
 b=P3Jc7P3pD23GBwYNcHqO+CDESRQiF1iqotO+hrGpi4BbfV5fk3MhkNJHkOR4WUkr7khj
 iLtJZo8TfL75mUje7RymDA36DVKAS4nF6zXFmRZlu9cb+VS1G/kKJPPdK8ZPTRjcsMrj
 ZycutSZThLWgh/DEqUuap83Pe2aZeYT0BOn36lx9VvJM+A90+3+8oCsBx7vBESG9PW5P
 QGzRpJ77BWHqgcQaBeZJqvEowPJkia09MEX5PiL2d/q3Qc4tR4ifNP8ktlzZFtsaREp2
 dJ2ngi6g+ph+wWA6+EeGSgrWMpI1CWV0bHb244D14+i07zjVZbjbR1wI8ACAjK5Ocsmw FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsvmjh46b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 08:48:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20R8jN6p106155;
        Thu, 27 Jan 2022 08:48:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by aserp3030.oracle.com with ESMTP id 3dr7yk9jq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 08:48:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTW4AnEUJ8ZXOkAdnM4bTIjg+MTCE2rQEfPobw5S2xxwo5vRyaG4AP3UnGRi+CKSBm0DzVIUagIxCLd6LvlH1RiJQqUVrIt8iPjyB+M7L6fIYa4bJuA2LscN4qHB60vDaLRdIMrwUDTEMMeBFKiBs6NGirbKrl4jMzEWHeqkuT5zW7Mrs5fRY0RDbE7uEUQwbZo/FHJA231Co+bbASjdb6bknsKS62ET/mEnCoXpW+BHvM2TCRCapvjggJa9wOROIjw4tlRmEwPo7Sd3oW3VOOywjynABXsFfWsuxN2ghIjHComs2dNRU387otKIvn8EolQ7j4AoutOPqe4mmTOTsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQibO7If6q8cs7FYfri606SmdSMNcNRWJX4kd8V5QIg=;
 b=G/Gc5hxAJHIRjEvW10SvfMZCl3xsR5JjeHXA/+ugkt3JCh7V2KD/8+nMpyodx/2b5IOJKA7QwF8I2bqGovUIdxkDXhK6BNgWX25W24nIh25jF5uPYXPnapU8hQzeIw8JqbYsuh1PaRGl6Uw1E/kq8kkDconO8ZYn9KLKih5U4KRwO2Y3PZn4cDMQbHLXnutdK3F+4l7+euz6OOlTCQ45vNNbMthyajP5dB7pNCxKgdPosWVg+NdBXJkEbIbj6BxrxWtoEjQuewx4C3GzTawzQjDQfb3vqRJ/kKGEHPedItjoiz4SSkV+VXh18N3A/4AYxq/g4tG7eU3lX5yEF+hhgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQibO7If6q8cs7FYfri606SmdSMNcNRWJX4kd8V5QIg=;
 b=uJ6oHO7Ny73ll916ZsREFTCbkoQB3JMsOSdRwosYN5r6Y/Jtd7WYS7BTaoeMND2xxTPrLg08L1mOWjs1uuLPixFkxd4gq90z8/PNjLqTCxXsP2NO4R5xYOQ73PN1ZiR2yA1KfAlaHviNiQzdy3VlfkFNDX0uvbDzeSuipKsATNQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BY5PR10MB3889.namprd10.prod.outlook.com
 (2603:10b6:a03:1b1::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Thu, 27 Jan
 2022 08:48:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96%6]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 08:48:15 +0000
Date:   Thu, 27 Jan 2022 11:47:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: Use strcmp() instead of strncmp()
Message-ID: <20220127084754.GA25644@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: JNAP275CA0057.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::9)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17adc6be-b005-45dc-022f-08d9e171c1d0
X-MS-TrafficTypeDiagnostic: BY5PR10MB3889:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB38897C9FCE590A27B97C9DAD8E219@BY5PR10MB3889.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +M/BwU5reoh2b4SKvreqPdl02UjVdlc1pUkF2hPKlJ82ZPdw8ohtWcH+7kcXPwKN3RDvVK4iuqc0S4ve/OHticAfHRIyutvWuXwb5HbcawS3LcNoXiBXt7doLlO4dzRmD53t1ga45IkCnNKq2id4rkVCRaqMZD9nUsjfb8MIo9/qAI5Fq6AE6Tv+QyVwGLd0FgTVaA7Fpuf7qneZzFnJYz75J9Py6Dn9gBpLLd6uSeqMUqqzwtH6J71im21lafT94LvZZL8czrbtcAkDlB2XLPvUnvRCOQjAPoiDpN1kaidozWth2vg//ppxZQozHTxJSUUFbugVySdgeIPWLoIGcd3R9mzWBEirOnc/bq0jvjaZV9fOJ+i9DfnvsdYq2LXP8VaQzoVc7wAdv18oBXWeMgW6B7mtIZ5kyYcimVwVixzqJOW1TEo9EV+ilhDEQrQw8Hw0veL0JQzRnWKpkgiBJfQWpSamtn4UVGQVAtQaLzJp7qQymqFVCYkurQotzHP7ta1IqEVPoXkoNEfSczg3p/dcAEvLBgIHZq64nLSC76lB504NScMWKLJetxf5BEVzX3oDyPcb63hfhcFE+jKQhi/lhbud7YcNJ0cwRA5v9+AkNLcqEtN2KwJjDiHtOgbz3Zvjv8+dH+k/GzRyVY2kKFYbVm5A4uoqb5ddyAgjscSCEiAD85GEzciFdUPhZv39eu4uUXI+v0zma8zezHMdaWLLkzwN+Fw/Yy0X4CGEQII=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(4326008)(6666004)(38350700002)(8676002)(52116002)(44832011)(508600001)(6486002)(5660300002)(66946007)(38100700002)(186003)(33716001)(2906002)(316002)(6506007)(33656002)(4744005)(6636002)(8936002)(86362001)(1076003)(6512007)(66476007)(54906003)(9686003)(66556008)(83380400001)(6862004)(26005)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WatMf3GznevOeh9wzoexlywZGZtqeQ+QKi0zy9yaBV9qkOvbFISHf0lCy42R?=
 =?us-ascii?Q?8B9JJlM3HKbYVLmfcK0sCrzYQeWpzaz4INtpUJiF/FefG8csqspPKAMhVdYY?=
 =?us-ascii?Q?wcLV78NkOIXNJuh/241rdPnfdzIkFvMkGWGaI5J1f76cucRTDx21AL9y9z1S?=
 =?us-ascii?Q?0fmZcphND2usBR7lT8HUEfNRHqI3q8FxQJXvbjGmUMLMjNJaX23NRSvGS6QQ?=
 =?us-ascii?Q?wdr5YgqO91SMFwBxTSkK6+FGLOwP74akzOyXEfpZbpSEstZDsGF21EuPQFTr?=
 =?us-ascii?Q?xW0zSPfB3AyMqYYKUg5payhAr1deeJOQGcjNF15J/IdbN/b5znTm+VMV9sZh?=
 =?us-ascii?Q?bmcF1b8cx5BUBs6gXQp2UltgQXigzCaJ7fFjZ4NsqUvmM7LT43RHNSkIGRHU?=
 =?us-ascii?Q?Tj6gdFbCejm/R/adwhN+OPGyFOfF8kzuDnFNEOTckVWt1XH32KhadakbLnXy?=
 =?us-ascii?Q?XddoNRucfjCyUrErtt444pD43JWDSZQOHW3FKCpwqmV4tVLMQHC3SGta9ZXB?=
 =?us-ascii?Q?UUGy3I6cd+O0oJeO2ssHSVhCdV9tiWTF9SMVhjn65OW2/PGsLJTjWAOURkjR?=
 =?us-ascii?Q?McUZNMi3Sj385v3dQAjoc1fErj/jFMN8tgfqQiFSGLbP3YF90TQgcDe29Ot5?=
 =?us-ascii?Q?JF5MoIliVTP+LfLUcb3yiExfoiEfNAAwMyyrMYrZb1/3iR/boxstNpmABOuU?=
 =?us-ascii?Q?KhfPNZI4BgLG2K5i2FYBJGAc7DKzeqVzr9zgESzQ9RtSZKwegkh+BnqGHj5e?=
 =?us-ascii?Q?+32DGH50iK3vB/Y1E8T4m9oVheIhOwsTWpd6lbVsUAGCLpoSZ7A6vICD/OUj?=
 =?us-ascii?Q?iZrLX8yFqvXFGb9HLHDvTOOJu9fFRHm7hROks15chNIqDyi6tyPn2h+NYH0M?=
 =?us-ascii?Q?2TcD3zOM7cH0e1dwpkxE0ToWNVGKbr1auC8Gw2M9AoKpLrcC6scGQjdeKDul?=
 =?us-ascii?Q?yT/R+jQFx4DUw/604ftms1gsJ52nQCIECObbaOEOIHydzQcu0pUUwXvA8JCp?=
 =?us-ascii?Q?TvyTVletJi4vEr//5vi9EcVs9j4oFmRzsUsAWYIuRiSHlO8x2yUhJeofRA0m?=
 =?us-ascii?Q?M4GLPHa3SiG8zqYx9xkk9SJcmNXqYhE0u8ZEsLbfvE9pXAYIBLenbeimoM5j?=
 =?us-ascii?Q?ANzcUZVR+AIa9rm9v/G+i8g6vkpr5f2WwfhsZyn+vxc70AUnY4gsNaMx/38y?=
 =?us-ascii?Q?XgM2cXfo3pxRXNLPrAvb52vpWaJFr/l5zXhU5sY7RCl+Ty3Mums/9820PkW2?=
 =?us-ascii?Q?zDunRQYj45yYTkgJ2AfVInYjKrAsNc/OaeupIxf+0vutqyjYPXu/sI22jOTL?=
 =?us-ascii?Q?QZwTEoQPBlw1L1BB/sPVSIYoD2Yt/zcZ+oiLCBSIT0Xm8JD/yAvQbnikNftK?=
 =?us-ascii?Q?70+skCTx9uUaSOgJFtXfmnQgRTutkrZju2lxbhmNBPIBuQdko6B6iVIfegrI?=
 =?us-ascii?Q?6CMXINFqcSoUXkxhwgJQ9vrZs6Bd7eN4v73eCNANtuFiHMJqPUB70Sypw3UK?=
 =?us-ascii?Q?cYVSJwOXPKELWbued/w2L00sHCAQIVR+Ll8vsaY+jYkpVLJWNA4EbuG3n0Pq?=
 =?us-ascii?Q?G6dKacVMvCCKMXDO/dEwhp7dFt1Av0ZuC4nrKzVy1XXPWh7TwubUFdKbeOhM?=
 =?us-ascii?Q?zbOww0CxxacuNs0mAdC3BnAnwjauWdknD8VyqYGCiInP48JDI9HrBw06ksQx?=
 =?us-ascii?Q?0ugiJQwSZDTZowPzEAs4s7+rXC8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17adc6be-b005-45dc-022f-08d9e171c1d0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 08:48:15.3355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIUhfYIrCQILm32rpKYY/lMUrVD/8g3etMkUNUxErsNe16maF3iA5GnKVxLlY1auffUVT1i/u9q0XYPbWW0KF/dJwLJl8Z8us1UBTimUtQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3889
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270051
X-Proofpoint-GUID: EIOEl0OG898_7X0FX8LPFkpXXUjHrIQ7
X-Proofpoint-ORIG-GUID: EIOEl0OG898_7X0FX8LPFkpXXUjHrIQ7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We want to match the whole string "=All" and this code does that, but
strncmp() is normally used for a partial match and it's more readable
to use strcmp().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2c54c5d8412d..4534101a7376 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2213,7 +2213,7 @@ iscsit_process_text_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	/* '=' confirmed in strncmp */
 	text_ptr = strchr(text_in, '=');
 	BUG_ON(!text_ptr);
-	if (!strncmp("=All", text_ptr, 5)) {
+	if (!strcmp("=All", text_ptr)) {
 		cmd->cmd_flags |= ICF_SENDTARGETS_ALL;
 	} else if (!strncmp("=iqn.", text_ptr, 5) ||
 		   !strncmp("=eui.", text_ptr, 5)) {
-- 
2.20.1

