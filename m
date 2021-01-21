Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02A4C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 07:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F7623975
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 07:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbhAUHjm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:39:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41658 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbhAUHXU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2021 02:23:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L2uvOv151414;
        Thu, 21 Jan 2021 02:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gEYw7vUo8IupBKm3Ogy0xUm4kOlK6qqbCNoGnK/vPQk=;
 b=JPZwcjog3QjJJmHglzHNn2NZRQ35IZCdVQWg7BSe50ihTBuXSZ9vXC1tqojXobSBMiqg
 Uq1Ut7oovKV491FOjoTOqdA1L8nA0B5j7zCkL4D4qvgz5XKnu/g8Ru9KTBMRHv15StGB
 gJrQr7Um9kYiDgF8K+b2kJp8O8MgsS7tFBsDr1iJYlVE/+s//fkDjm1Lo2GZr4yTnUby
 PBwFxfp0q+0AclLVlqb0oYf4Emxcj069o9MRdviULI4LqwgYf93oXh1J+IiDCko/jn1+
 6osGftUldhMlISn0FwBcGgBo11n4ZvAt+zXESj+QtrYmSnHAuJDkURdJ+Y3waPRSYjVX nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3668qada7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 02:57:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L2th7O062646;
        Thu, 21 Jan 2021 02:55:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 3668re6ucp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 02:55:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0Yv7PuzNEXAbH1DnceZPVmKv/jGlZbrzQN7FPZ4qCEWY3GatrRRIgNCRPOqem5sFJix3Z6lvlcJBDmC0Vyjro/GcewNnWJoUPHo1QpRe8qS5jbmShsWiK1daKtWNEkQr3ZMpluULBZjIqyhmJyCz5pTzvc5PwZbbSt3Am/FRQxSCInOPMvKFHYs7j+Y+nKQUQHDU7skYd5Wtj11ZBt4n+kublfsSYJkUXyV/xn0HyJVKznmIYLyy8vgC733uv/HQ9r+a9Pnr/7glUO0FXtaqgmKghHk8aKhwm7hYK4tw1fmRgl17UwA9p5bBWLbnjezX9+ztoE1xuQpQ4H0A7qVqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEYw7vUo8IupBKm3Ogy0xUm4kOlK6qqbCNoGnK/vPQk=;
 b=ljKj1DlIpsn8VBwqriMuvRrN4TlOcaL10cscBFukqEkOJDsnW6M7Kx5B8KZ8lwj6ic+/13dAwtRE1FBsrkccflJp2x9OVh9Oc7Fk36mWWbsoEFvR7Bfxkvb5QKws+fJM1BPEmK0d1RrJ6lkSJjbnYY34VTZcvNi8hS+fx8B8D1AQucyf2vi5vpReSuPHgOqi1gPk6/WQnYfsi2U/Az5bGjeyAUcl5yJhYwWQOAOZhfC5JYsg0gZMI1IYGYjOWC60Y0hdhYqBrmWtyS0fCHhKoBb1Zf4u6EW/3y9dicdHKZWATP9k1E4bVqChXGPjXlzOKqwaVfjvqybxdmqsnl0qPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEYw7vUo8IupBKm3Ogy0xUm4kOlK6qqbCNoGnK/vPQk=;
 b=bekTXJ/I+GScWh+FXdcwpFjFBm1/QO3Gy2n7GABfg7xGvfRtmlpI35zolw1GQirZyopirK9ZBI6CwlQgTO0xblTwr8lBgCkEijvSCChMme00ensa7YGa10fTN5eaco1zeh+8p16FInKV5QzauzI3KZuI7CBarYRMjAoQJ/PQ/Ms=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4504.namprd10.prod.outlook.com (2603:10b6:510:42::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 21 Jan
 2021 02:55:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 02:55:31 +0000
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Subject: Re: [RESEND PATCH v6 0/2] introduce a quirk to allow only
 page-aligned sg entries
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6t3gfs9.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210119034502epcas2p1b78378690bcbdc6453f657a3379ab90a@epcas2p1.samsung.com>
        <cover.1611026909.git.kwmad.kim@samsung.com>
Date:   Wed, 20 Jan 2021 21:55:29 -0500
In-Reply-To: <cover.1611026909.git.kwmad.kim@samsung.com> (Kiwoong Kim's
        message of "Tue, 19 Jan 2021 12:33:40 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0068.namprd05.prod.outlook.com
 (2603:10b6:a03:332::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0068.namprd05.prod.outlook.com (2603:10b6:a03:332::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Thu, 21 Jan 2021 02:55:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 993c5114-e687-43b8-635a-08d8bdb8040c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4504:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450472653202890ED8003E108EA19@PH0PR10MB4504.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Gjs1Ry6EZAA+wH6DoNIAjg1s2qBpmVf/TjTvN8Hq6exUlKq1Eqp8+26V7+Xp0Sa6rYIKOl9Pf2uQd6pBG9ieDmL1Flzrw6dDZ/BvUjqJ+B+JnOUu7NNq7iHnaYopst8sBVAhIHCBxTmKf9M6l9tx9/2Lp1JigavGLX/g5CS1I4UsvyLMFcERPSmXokp+PxEVm4w9Mi4Xg6akCNhqzGvBJn8nJkyHzpFan3rgVxuxkrPAYlDkaxNzWAEZYLxS5FhtH9uV1v2gGD+WSmJP2GmvXALG5MmRkqvbewRbZB0ji3zp02jDA+wTyStIWFK2gGRlHrARUfpUvNsitHk9Uho5KOQB0wNRWliTv2zH3HaIEVquenI3c/1iI7lLU5KZQLQDZBNAvkwNo/K7uyQC723MA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(956004)(7416002)(52116002)(7696005)(186003)(558084003)(4326008)(16526019)(66476007)(6916009)(36916002)(66556008)(498600001)(2906002)(26005)(8676002)(55016002)(86362001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JGtCGpAfiWgDl3WkuKBdl4tWo2QyJv6w1UCp/GCl/w+pmmxRCn/9jsyuM5Q8?=
 =?us-ascii?Q?fAkRvzg/EBgwEE70HNt6V3zIAjaZZB7ptT3iA1WLGhMp+dR3XAZ4aWHHtKSn?=
 =?us-ascii?Q?FJ/ecZxLTYm41coR9sivTxw54qorV0T2XAesfh/ODQckbj0IIbssgVDAD3MA?=
 =?us-ascii?Q?kqDEpZPHw608uePqr7aLaxutRJK5Y+q9nmXeNX2x0kRNZpxEqpBeu7htI97p?=
 =?us-ascii?Q?U4FflZShJJYUw6aoNx/rYuJb1RSrvHphCqcgw7ZFBtj7hHj74aUK2I2g10oU?=
 =?us-ascii?Q?HAIlJPr0b+nDDUGem3GeuJiL2Qp8faqZKYiXWNeYkAU/VbEOe11M1lMsrReR?=
 =?us-ascii?Q?X6P2fIjxty2CjJSPJMKnB7Lp4ctRNA9kkYZt4zbsCu0ofsRxaFftTsU0mTxI?=
 =?us-ascii?Q?FH5ka+zuWml0zfYvKPDW5j4NeuSRTttUXlBegn+N3oa002YyLrFLoRfwGJm2?=
 =?us-ascii?Q?826YWqodIi2A/gt1dQBTbJ69DWf4Iiv50SK1WLwtaI3x/EySK2K8caMxyl/p?=
 =?us-ascii?Q?45aoViFMnKcrxVGZ43vTNoEkg2ZAvhgpmuNW48G+Ez7L9TfJPKprJ/QT+DM4?=
 =?us-ascii?Q?EI7J348hemDl/lY7Gjkm2Qqy28GF1gHzqRmwjIgvwVGXluBUJdM61a1xBYa/?=
 =?us-ascii?Q?b/OQeVy0AIdaFUNhCk4XSUq8UKJ36eiYekhwdiaczUneWldjXmOxf8wNmNiD?=
 =?us-ascii?Q?QyiviBD/5BKVmR5bKiyV6PBhPxoH1TLLe3xA3kabt2T0hPZqW/tvhteGgu8T?=
 =?us-ascii?Q?ebgjAwVCIE4hF7zjoYFcJ0WDc4WDtTbhhc8YTnZGjZ1hI7s2MHWX3i0NPQ/i?=
 =?us-ascii?Q?jOl0kZRHA/P3+mFROBpxeQZHtfWbUMfGFzYKW2Iv1i2ch5kYl8eo6v/tiZ5b?=
 =?us-ascii?Q?yqQ88HKL7UpItdjDOUhdIINpPawPCoBJYE7U3+2CnvHEj5T8v/T9jgJPsZE+?=
 =?us-ascii?Q?ivHwfo/ysy01M2r0uxu/Z8UWcu2xXg+MlVXTzCcyxUY385u1s5ruMDziPZph?=
 =?us-ascii?Q?E6wB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993c5114-e687-43b8-635a-08d8bdb8040c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 02:55:31.3364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sr81mONUsn26KsnssrDN3wjYzyVy455IAlrgZBSUmS1QmIy6lww9P9iI37zOlBIw2zx43xcDlFRER9oV0YYPQQ+o+MtdM+gsP1W8WZAr3lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4504
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kiwoong,

> Kiwoong Kim (2):
>   ufs: introduce a quirk to allow only page-aligned sg entries
>   ufs: ufs-exynos: use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
