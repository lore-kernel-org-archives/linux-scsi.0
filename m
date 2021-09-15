Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F868C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4861C61211
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhIODTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:19:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6324 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhIODTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:19:00 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F2lmQC032066;
        Wed, 15 Sep 2021 03:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/3VKPwM1FU+BOjaGiZ0JcQF7cB0fG/fNYsQiYWYg4oY=;
 b=b0UtPnqducrGup6s87aioreWdPqrHH7tpRNMVVAXUWcfBKzG5Z8X+HUripqED/Fkx8Aa
 igtOxp1aVfy1mrtILnnugZdEt+YSW/M+am/8Oxzj3go3CKe19pL/pfDDj8WSUfG9p8r3
 M993tWMlMcg95rzc017nkN43NJK6UhnVsJ0d9IiDe3+qGIGgjgozxWW6LdHeS3CU0H10
 DDID3WL+LhMdzAAuCxA34ia9Co3dxPN/rUZT9GzPy5mTqOtQjjOCwDHZy6cVJ43/DBeM
 nmqIjKjyoY/Y009N7akvvi06O/jTacO+CIbHOeJr6AOxXl25o2t1rW72kZMQrTt9ASid QQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/3VKPwM1FU+BOjaGiZ0JcQF7cB0fG/fNYsQiYWYg4oY=;
 b=zNMKUqbooIyBiVI2XBMdnZhoz3mt6DkCh42yzx3gbKH2PppRjCCXaIC1YlVd89SlEtre
 ILp1Af/+dzAxUmV9qjmTA/1OaLfjuxDJ6+okWlNvMw5kUNUyhHaUOZgz+aXHceBeSUwT
 ZyBZvkqCy7yCyhbBWS0EJpVuAeVyV5fVWrcallX/kTcofeAgNMxDiwHtq7qTucO5Ifyp
 PkyAPDg1Y34Ex6ruOOaXNcW8P8INH2rXceSoMjHGwxP2F7s4uJGIr+xPjm8QZSLKf8sN
 1YuTYh3Drg64TeEfdcvUfa2A/TqwaNjyfwquMZyzB+oyzUqixsojgV2giBx/S1ob6UFT xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p3mkh8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:17:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F3FXal119748;
        Wed, 15 Sep 2021 03:17:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 3b167sysfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:17:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRXPycLB0vc/XP7IZwu77vAQXSE/0VQ/xoPp/H3JmyedH5Yh/3+o/Au3WcZdPNH576NlMcgRUkD1Ud8BSpQxUp55hBEnKydFQFTZD+0b50FCL1ZT9xruAnrXBc+ghJbFMlsuaSFX2CGV9G2gXxCiO1yZLpt9JFzJl3njaqkc1vopiJaFIiFSNXXF+yKdwf8hHEfZcFCUwMK7x7z1hpoKaBoDPLyuhoJoKLWhC+ME9k00NT07rYQ2wIZq+OY7Hi884E7qJFBoyBNkVkmPvxdohfbmCISsi47qFfT8IluOos8mA7/kbacvqa+QJ+VT58h3b/vzrkcznVMAoD+fNlsavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/3VKPwM1FU+BOjaGiZ0JcQF7cB0fG/fNYsQiYWYg4oY=;
 b=oSsgyQHjKZ9Sjq3v8hq7htFhVY6Isf28WdgLUscCjQGBWVsmdEYXLvWVBmwfvlmykm0xjTqy8hF8zbu5kxR805R//ce91w746pwB4+z4Aab5a3nv10Z+NGiQw1UGeY1isMIhQq4bC7jG+t+BjQKdzh1qkyoQAg034V4xurr1Zf4dJopa0bIdvOVjywswj7g5KUgK6QXxFhHnd3T+HBmTZmJJXh0S+0WtUe8LolPJl7pDPvBV3wHC1VxVNpHci7oLzHIQj4Y2+shpwM+N3atLYRLWv8WDGf8K3pulkP/1JSvGenpMkn6xX3SCuRjefKLPT5/BDCqrq4KLj7MnqbK9tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3VKPwM1FU+BOjaGiZ0JcQF7cB0fG/fNYsQiYWYg4oY=;
 b=X53Ur5itkjWF78kbTsMC3DJvv69ui+lhNKhFt9H+PAo5wIiQMJV7DFRtfxueZnYwbtkRkQq15N1/lFwQhqe9ZD1sxapqL+HjWzdXJLEBvShP54ITr/bfeDlfUJOvaI+kN6+0mFfkzQYzT+BrrCYIDI3uKMkHEsr8F0B0lzcrdFY=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 03:17:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 03:17:34 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove redundant initialization of
 pointer req
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czpawmrg.fsf@ca-mkp.ca.oracle.com>
References: <20210910114610.44752-1-colin.king@canonical.com>
Date:   Tue, 14 Sep 2021 23:17:32 -0400
In-Reply-To: <20210910114610.44752-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 10 Sep 2021 12:46:10 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0030.namprd07.prod.outlook.com
 (2603:10b6:803:2d::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SN4PR0701CA0030.namprd07.prod.outlook.com (2603:10b6:803:2d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 03:17:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c49c365-053e-4828-a8fb-08d977f75c9f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54172744B5D048E1CB657A188EDB9@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P24Tmy4eTC+/Nr1d09AK84Hmx5tzAcIrlD5s3NmiJFgfWNc36QD8fSIwYm+tA2WRt9NqSu2A0zAJD/hTNRXmvKFSgoj6WgTOPtvF7fomMRGZAX9pPH1hC5rs6oKgi51YLdtu7H24dQFXcOqpNvnVdiMYn7B2LTPTn8RH87++M+wwcXixdjZuxllHExd0BfzrotKnQciSrxw4cx4U4R1dXY4yyBvAcohd3yWtSzLXjruZNdUL71vOIxbanppgm1n8gs+8pywvPR7/X6HttzfFZbD/nJfnP+R9i90NYN09kBlkGqM2acG+9Pa2vt5HQWNh+zkRj45GLrnYln4ZQrBqU6oYCG3n20HtxAQJpYfBFsHaiDlS0bNFhqCvwTR7V8ReLJFnsGUzZv/KYwoEjC2DMR1dJnqjJklad++EzM9ryZcl5HSl8R+dBY+WpfgIOAjf7rjAbIxQV/39/KXAY9YBhCXiS1J1iA9by/QrmQBH+rXLUqqqbnFa/dqQl6MR+EtbIS5iyB3/RIQkOW09jtw/FXttINJzHnhZXiG+CLnIlSdbhoA/FMyY8vQV1V8ODdh5TS3t3E7ifaRW7v43REPMMrAqR7gGEdwrvfqrpz1XeGJXbGU01I9l8DxUmlMx0V3382SIC5qlMbR01xtW+K1MNo0fOhoS5KCo3KFJ9P75gA+HvEExykDjssiwH4Kb39QkXj7CuFegQfy4niMrOnHXFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(558084003)(508600001)(8676002)(52116002)(83380400001)(5660300002)(4326008)(54906003)(186003)(66476007)(66946007)(956004)(8936002)(26005)(38100700002)(66556008)(38350700002)(86362001)(2906002)(6916009)(316002)(55016002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ttaHHn8nE5svy4D/2CG7QRjg9M1fXoRdB5a8lKOlnjRNO2Di3cpDzFBkekKi?=
 =?us-ascii?Q?d3FqPVhq36ZxGKA+Mspe/LcO6IP6x1cEDhT7vCi/P0V+XFQgiKvblbNbbCy9?=
 =?us-ascii?Q?8wyRpKozD9EqX5y2jMmU01vLXU9l8nKseBzUkrqbcE+273awWeLJtIL/50+1?=
 =?us-ascii?Q?Frisa7OhpfooQlvPH5R9W4oZ2Eu70K84hTI8XvJypernbSPr2P1ahQ0lPR+V?=
 =?us-ascii?Q?yRtB+gK72DDacT541DEaIM+VMzm1P+FNP5XYIzJoLuLdeFkYyodmhLPm0/1w?=
 =?us-ascii?Q?L60no6uBMCZSU14ZwEbUaB+umWLBxC4TMMcFV089vcPwI7wlP3H8NjWjEAuD?=
 =?us-ascii?Q?SEZzwm2AZrJ14pSQ3MqlbCAUL0GJI7Kxme/anvFfVOCNkMoLH9zT8bTRVDdB?=
 =?us-ascii?Q?K7ZmJ7YQeUEFVXbEUq3zTRUAwS0XkdJhEZoFqBxXGNSJtkcJMecsLsTnKjzn?=
 =?us-ascii?Q?GZxd1KwRrtMWsfNNthdaHlsryNzLbzzBaPVzunmmt/+l6SbtLeEvlNe0/+YD?=
 =?us-ascii?Q?pLMq4XMwIqBONoe8mQUX7AXj8yUOmwU4aB3VAzV0IZNUGvZBkFiLtlwcV4P0?=
 =?us-ascii?Q?b4Pb63woic+HdeMXGlt4/wN4av2OXKfLog1+GBJIlhJRLTjSfGIVF0Tp64kP?=
 =?us-ascii?Q?QU94yB+0u4s0/IWsv4gb4h6u1MfjZeexAcMZBU4aE4T7Jucd4G/WbpfQ/NRu?=
 =?us-ascii?Q?VTOdiA+NUVRX7/J6XlSIM0sX7PDfB43+Ge3547c6i67lkOq40Tc6eg8lRBgY?=
 =?us-ascii?Q?D5VCfcjgFbnY4et+D+Udw1J/yJVLGJH0COfGjNc5+gNrBHdplmcJQ+KcVLkq?=
 =?us-ascii?Q?zrXGzCvQiqA7W0WSVTqf9ezKDym63fX3FVDCKJmIA06m+G+NuEuyVpFgnO9k?=
 =?us-ascii?Q?wBbR/b3BCS0YOGMaz2CtCTzMeehnDRhz+HWNKLxCyNkI2g4avbJQMUonYIxV?=
 =?us-ascii?Q?1TH+8eTTNo5ZQ6x9J9qudYWMAfpgYKhVqQ9JaXWvf1Gmzuwysfknv2JES3eH?=
 =?us-ascii?Q?xEp+Iw91VrDcgQWfBJ6GZ0yMY5+YouLjSlEoCV38MOdH5iUHfXvhoC5xKYOf?=
 =?us-ascii?Q?dxj/MLmXwWmhVnG3SnlOhFpc69Zq91n3iYvwC8b/FqFNodulqer1v+L8h2O6?=
 =?us-ascii?Q?2S2G7dTXmNBBj7gdBCc0OQBtOLXSZJ8Z91I6qO5q0VgR7TrFQt7cY92t5OjC?=
 =?us-ascii?Q?E4VykViB7YLbVOmqBw5RhvRS7kl6x2Y+p8qg0I7IyLB1RGSBjtXMOX0mb5mc?=
 =?us-ascii?Q?E4qYVTTI64Ts2N6Ahd5AR8VAHUiUVW5sXx8j7ZH6uoyJv4oo4+B6pCtgc33P?=
 =?us-ascii?Q?O6pdOb2CkgAfDntWiuZbEaYu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c49c365-053e-4828-a8fb-08d977f75c9f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 03:17:34.5037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 81fKAP3CoWR//PPgnfb0ec81kNCK4zHK+6ob9kKFaaXS/RPF7UEuPU35U84KHXNmBP41J3kaYMARYjBrCqh4EPGcJhOmBkihbJBuKIKtaMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109150019
X-Proofpoint-GUID: cTN-5gWG79pT-Hzm4DddOiXX7Wh65EFF
X-Proofpoint-ORIG-GUID: cTN-5gWG79pT-Hzm4DddOiXX7Wh65EFF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The pointer req is being initialized with a value that is never read,
> it is being updated later on. The assignment is redundant and can be
> removed.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
