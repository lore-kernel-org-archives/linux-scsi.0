Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C08C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D4C760FF4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhG0C3N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:29:13 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6438 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234422AbhG0C3N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 22:29:13 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R30htE001910;
        Tue, 27 Jul 2021 03:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aoSIQiBjJr6Qoqq5TcAx9HLnZUaHMZ+jxwmkKG6oG18=;
 b=L8477zeciQ2tA1xJ0ZyxxbAH6SlgdyqqrTUKJpsolUIjfLgJ9f/9TXnRM7TQE0+WmVT6
 MRy1A6YRiJ1i3iiItmqLKjaxo4F6jAzslXs7fvOtFxFl/KXbsX6nBVCG1my5zWGpujEV
 SucQwvyeUKCO3gWRiDgvLD4XqHzr4GJjoC7/ZNwV8r8O0JEbddArzPyqewh12YEDJvO1
 XA52+oLhnQm9D/8h678yZ0CdVqDBu23q5/C4BMyRmxcqTPDb2N4vNlybDHsV8rbTrD0I
 +wxsl2Cd1J0q5Q6MgRx18bUbiff1c0OmYIreAuvN1EWhn7JYcSM8ziKSBFZ+lnAaHZSc Kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aoSIQiBjJr6Qoqq5TcAx9HLnZUaHMZ+jxwmkKG6oG18=;
 b=ru75VYi2+jUNWdU5ee2e3q7w3LqdmgEmapqItgklaxFr34tcRSiivEKFswlY5BlYs2wp
 6O9CKP5rpeP4TUHCjWlkMZto+nnugTD/IaJ8InwOtZna1ANYE5MBqs3TjRmPRSWi4Fo0
 jOu5T5lMnhy3D051mxQV3vWdRuT1/QcPMm/GAi9gtspSPJ89aSsLlEMhQBJTiHxFmr7K
 A0L/qgDb2oEDsuv+6UVaYbGJE3LuA2bI3i4qgNUM02uMpMAPfguUkrBgAGBVfkNjuBs2
 XIR+T6YWkCbeDmFf3XOBzKypAvMxPISF92KkXhEkIARzDO7GIPNRlg/o9+4fqGg5W7IS lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0ktn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:09:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R30hrZ110371;
        Tue, 27 Jul 2021 03:09:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by userp3020.oracle.com with ESMTP id 3a234um88t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:09:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R68izS6mYB8RVMRW2qv0mNPnDBzKx0W8EFyVvxSr8QRkQnRBTUUELhL9inuqaQE0Xuknm96Frd4kcnguSImjj4mPB7wL4Gu1IcSyG8d2hquGgHcI87xNo2/y8Pp6MVkP4w7ZBoiK5Rm+tp74owUECyG67au55Q+aThtV10kBQ96moHMHcbJ3ycwya5idO182kCecJKIizHApVMyLSvJYOinQgFu1f5f1iK6iHkc1faS/KM9WK4yuQE8zBh3IBhH7ujjo34zms/LgBvKuUHAgma4Fhd6d+t9cGWeoXQ4WtXfVgqYtwWCd+Gbwh2vPxGKQOr0O+494ybx4xcHB0Ri8hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoSIQiBjJr6Qoqq5TcAx9HLnZUaHMZ+jxwmkKG6oG18=;
 b=LLlbJI2UTmXwWuCK1VG9p9n3wDd84K4vZ4xl6SapFqaR73BeYFTMaCbsDqI14bbi+ZBhmZ9Oef0dQ9MPuXyQgVjIVUUw4rnpYoUqRw6ub8WB8rpC3EZQbTL6+hZd/AvN5l9BT6EnTsOty0WMH6DMhd1At52e3hjOl4vUuy+Qmc4f43GjhguFGKWLRPFLB7zzIAM/Epk288rX3pcpiHfQm89JYuThBjOl7QspOGxuTIZcD1nqrN/BaQ1xLUy9EGiP1jyzCIQec4ujCNydQBbXji36/EMbjNIRPGjl56klh3XagteJ+aPL8E5rXonwWj+B7qdOZmyzSmenw3uLYi6a9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoSIQiBjJr6Qoqq5TcAx9HLnZUaHMZ+jxwmkKG6oG18=;
 b=E+i7ptXQXPhpMkt1Jizql5rrwnE5wXQ2uF455i2j96h2xQuv/MsXVI4W2NVNzOIGlusrkrtzwyv0zKNy3clrjIxO97YvD34JtDXzQv8LAEVOwrVd0JU+e9MLZN3DH0LhUmtyZAfLLvD7XYTax8AXlYpo1zZ8nxgKRZ6j376dXVo=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5516.namprd10.prod.outlook.com (2603:10b6:510:10c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 03:09:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 03:09:34 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Varun Prakash <varun@chelsio.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: remove redundant assignment to variable ret
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r7ksba9.fsf@ca-mkp.ca.oracle.com>
References: <20210721101519.42299-1-colin.king@canonical.com>
Date:   Mon, 26 Jul 2021 23:09:31 -0400
In-Reply-To: <20210721101519.42299-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 21 Jul 2021 11:15:19 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:a03:255::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR10CA0030.namprd10.prod.outlook.com (2603:10b6:a03:255::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 03:09:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cc99f60-23ab-4463-4226-08d950abf588
X-MS-TrafficTypeDiagnostic: PH0PR10MB5516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55165F2C5AEB548959F5C2758EE99@PH0PR10MB5516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMU7ahvSH4dnDiVl3nx6QDKtRRGt47uLeqbJiCL2t4TYVGXwl0f7peZg20b7KEmb6F+HFwJiBLZO6vBJXAaexdtv3+LHuk6//113GZ9vgLjVPFrBs7yOXVhdgJoMG24LSn+Z2DshVfCeyJfbJhz0Sw0p02QQqWs2o7LehIes3F/M+5EtTlCSnEBF/GKVRnFAYfdgdCHncvELb+qkiG9fKvU01MCbIqKGHclskxCBHIF6/wyRGFUf97aJVpeUUq7fiH4v/kLfN8KC334aZ9hPmo3IQui6rrj3ejbuRcjWmoMnYPKnUtMz5aKV/Y2hck4KlfUDldh9QtxAkud12/gT8fYfSVnKNZxTncMpKLkNcrcTg+DTLPwLFUuCze7Pa0Whzw5CbhMsUXFN3qjy3s7dCvlcwE7spDlyMgtHg/y6Z8JceOL5n7fD4egw9AaB71A9nTO1MMoYhWY54wZlj7zA+AeMnxSEacIZf+CwDdFqr7uAg/x59HUhDyZNyXPGi8vTMO4rfYM7/lMMkk9sflsEKqBxTFD3RMa2ntct6cZSF36pbP6n4VKp5wuUzsbKJQFTvkCqN3YYFf8NVdlxO8DqBXXSpSG/9llsiY9QRFKbuYudvEEBtCuujwbdYsW9ZBKUujVX7wpTJxwAO4y+THekJpQ8mg5y28IsKMP5h5pJUulwgkzW+nQoeSwpmWs51CVddphMQoQelhDUqjk16594KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(52116002)(8936002)(7696005)(8676002)(508600001)(26005)(36916002)(316002)(2906002)(66946007)(86362001)(558084003)(6916009)(54906003)(5660300002)(4326008)(38100700002)(38350700002)(956004)(66556008)(66476007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7lx11uwo1XegUJZufqNiRobHcCgj0VViMjIiAVGv1WxTsaDy6cKchSyskSd1?=
 =?us-ascii?Q?BCHMt58f0qTJ+6DSQtyKYtgCrpXTpkGFmbr0yFiMHVMlMsgU8r3tNX5VpgIQ?=
 =?us-ascii?Q?jwfvKqpmTnvGBd3guqpZy86FHSQAQS7U/dL2XUSsC92h9F8NhmkTI3yS0Ouv?=
 =?us-ascii?Q?buv8ZfP2+f6JlqmAeewAmLTyH2xmbwMT4cv/bvRZDqT/Uwo2Gg1YRbumsP2d?=
 =?us-ascii?Q?bqPEhNTJ2Behkuel39bdpQCAeDi4XvZvLOrTHSaA0wzbuZ0+CzTZKUaC2vI4?=
 =?us-ascii?Q?J2+a2BEyF7ICPZplGeYoiMAlSMT91krB4LbSReC/r/60jnZ5HHygzBZWaV1z?=
 =?us-ascii?Q?HUVRD2SPt9hdrLCF8QI2SeQafyFgcsm2mRX8+/sUcXAjs7wDZRFGN/oqSUbK?=
 =?us-ascii?Q?gGKixbvgKjcR0cPFRetgXhLZyVAjFRbVNKWPiHLbVtLo3U3u27F99dhFCj7+?=
 =?us-ascii?Q?k81pQl/G9UaTFMz5OWDVEIkMOLvsWfiqTQxfDX5RJxd0MdysigNcEpE6ccq9?=
 =?us-ascii?Q?0kdJQVyx6DoW5ZWlL0du3VwYO1/h8gxTHw/82EUPNbp71UUX2hLF2YYi/YlS?=
 =?us-ascii?Q?QpEuRXUKyM7Jpd2OycW6FeLsGwRaonWBlj/IElcy+FDsJc5Bf66odIhMAgdZ?=
 =?us-ascii?Q?UqdDSIoF5ktRKb0FaqIjkruPmmN6AIfzDOygBaZdXzMN5LE6a+xdoe6mfY6q?=
 =?us-ascii?Q?5Ua4cNveYzG09f5Jahq/F8jcQOJwI6jOp78GYYrzM98BxLYHXN/E6G22FfSh?=
 =?us-ascii?Q?+UWY09aOJU4VRx/fcfwpgDQwuz3bTgpfzBbb9RLxY/+MLYz/jWZ0uLf8k9C/?=
 =?us-ascii?Q?xqBWpqVgMhvmwH7q0Kj6N1ARs/W6cyf0rwKD50ARVwmABvWfBJFd+m2Frn4U?=
 =?us-ascii?Q?23KZ/3wlK4TXDMY+I+15WEz/m3RhDvnRZUwNOWOnCZpYQzyyr8qakkFOtfnT?=
 =?us-ascii?Q?pLl/zuU5V9B87pL1+WGSt+vaANrdxrNXthME1OAgBF5PRtsZlP/Xsnr6Bw4R?=
 =?us-ascii?Q?V4N1/GsGhR31Uvs5NtMMRD7CQGULlTfnkgtb4X6n/gkEql0c4MQ5eeNWOeGy?=
 =?us-ascii?Q?95oPfdgMUbHTK0oetsvUBCXnbHdMLs04iYLggOuUuIWLCFvMEnKUhmlH0Ob5?=
 =?us-ascii?Q?d2lm7UBAeqNTmub5zOJXLK8qCYyzeYt0QitvGxpF6KFlNkDVjHw1RSEGHy/g?=
 =?us-ascii?Q?SFpdWwDAZk6Q/zkQ1n4/EDMKgRUPOlKhB5fjHFL7qO2WbJpCEJQUtHMYqDf3?=
 =?us-ascii?Q?RU5x5kK6u2ji+oNCBd5VZaFjL4Jkpj7H3n8Vod/pH0YE9Mi/A62jFuATB+JN?=
 =?us-ascii?Q?nrVIhNTW2J9vS9DeXD4DEVyR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc99f60-23ab-4463-4226-08d950abf588
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 03:09:33.9778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 81XGnR/5tlOU1dRQKs1WPPYNZcz8RpXwGKSnyVXkKKjT+s00pTxxH8dYPQSkIn5gq2A0kV2ptcvfvfJEJxi+pNx50oJNNmhZgPnf2DUs3w4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5516
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270016
X-Proofpoint-ORIG-GUID: CcnlrLqsy-n_EF_zEyx5SLQZXQqMskKV
X-Proofpoint-GUID: CcnlrLqsy-n_EF_zEyx5SLQZXQqMskKV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The variable ret is being initialized with a value that is never read,
> the assignment is redundant and can be removed.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
