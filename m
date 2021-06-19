Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE9BC48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84818610A3
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhFSChH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:37:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58000 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFSChG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:37:06 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2Vq1w017228;
        Sat, 19 Jun 2021 02:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/dQPt1lHGvW4GWHi1IrXKTd/fdfOr2AguScZMjSMZqw=;
 b=TKstqMqWzfmySemsT4/3msYZ3ydSQTitrcvuDls3Al6JNlBig+nvyJ650cRWrsKsvhe1
 T4vwX25n8xqJGV5upPJAGsT01zAD7t0qK3sLq5vLmjqtj+t8rdTNygxC27JLCqRyEjBZ
 EMFhiYY1c1obT5BLdx9fqdwmTAA/uy+q7xPDDJfokKsor5ktzTaB3qM3vnOp0vDI7bf/
 h9JPTR3AmSQ4J51JLweG3ImqgVKYMOiwjiKeoGKGve29/Qxt92wkBZBRHw3iYS5hZpgC
 uY6uZT06iRn4vZqCsnjlCp8ZqbuusVCiplVOg2dqnExz/nGTmeYI64+JYLLlY5gw4uDR BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3990488hbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:34:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2XqwW105603;
        Sat, 19 Jun 2021 02:34:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3997wk00tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+5w6kiXoCTcrimMpOoyFG0Mi1fXSrN/HwfNlx1rSwDNqtkIsvTIzvCLfbtxR3UahG3hqzPHk/f7jTWLOsFWE7MZGwJIoxcTRKkh1Jgu7ro2k/iPdzhkws+XHYL/mNCXSAoABUZwmIxMPt/z+Ljl5WWDgtvTKAfUMquAbt/IuquzlQUUyVpgZtPN5tNO1VCNhq++3C0F7Xouc2xTVf2X3pIwRIU/ceH5NirCotYXKoJZJ+nT+oAXxRKMVB7KaepECSt+FC9jA+3piyhCbimeKANSvCUcHKRXr2HQ4kaOWi5hFKRYs8tPtd+xFSpK/jLYME0axvwZ75y335nkBcRDvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dQPt1lHGvW4GWHi1IrXKTd/fdfOr2AguScZMjSMZqw=;
 b=IgBcy4Vn33njGLi+LXi4TWEXp7N95k7Dc30YpQBSx0fjohY9W4ucmRuGUDL5VGS6WoHtH3hhE+Ka2EKI1TfNfLN7cVsRr7NLUJrW/65c6e3T5WGJqJYdGKaE7Md0IUnPJ5/p5Tpa+JQWOVa/axLXa5/U5nirKY1Y6rFdm1bJzyg1rCzFlNdFkC3vJ7++qX/qn7kyFvRR4fE36ADmdsNBUOjOyFMLlUhbSfb2SXKl0rao41l4JLnnVrC5X0LiDhd9QmwvzB8nelm344EgDW7jNo8AOi6BO+a3fr2h/+p1+34VHpijmWxSEBSOlsuncEkGACT92Fvup1GQYRF5YJVm4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dQPt1lHGvW4GWHi1IrXKTd/fdfOr2AguScZMjSMZqw=;
 b=yBjj9pPIPXJtrjj2tg33H8HRnhRbSxj7HvaFKO8a/dvbPAGieZVHr4IhEVBGilIUswjiBZcPFnqf7khHocqt0rLXUmEnKzsG3EnAOzW11+PVYO2PlaBXGHQJIwpdF7drzOqLeY7+ycTMSv9hs+ojjsKcWrLqCsVlEZNg6Inniu4=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4533.namprd10.prod.outlook.com (2603:10b6:510:39::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Sat, 19 Jun
 2021 02:34:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:34:50 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target/iscsi: remove redundant continue statement
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf76y43k.fsf@ca-mkp.ca.oracle.com>
References: <20210617114347.10247-1-colin.king@canonical.com>
Date:   Fri, 18 Jun 2021 22:34:47 -0400
In-Reply-To: <20210617114347.10247-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 17 Jun 2021 12:43:47 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN1PR12CA0049.namprd12.prod.outlook.com
 (2603:10b6:802:20::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0049.namprd12.prod.outlook.com (2603:10b6:802:20::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Sat, 19 Jun 2021 02:34:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db496843-8e28-43d4-9a0d-08d932cad012
X-MS-TrafficTypeDiagnostic: PH0PR10MB4533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4533D612D89318769C5245CA8E0C9@PH0PR10MB4533.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WfnxyaVBkL0/jAuZ4HvcuMP/jFnrW5afQKLgJIcPMin8fTpOpt3obOOPM8FsuJ1UbhoeNGl6Ojql2+jOE+A6xrgewD5ThgAHx6zlK1GRhOGDr8pUAW0WFJmEWBNSFjm/H5JJ4nCBOiCgIs7Bq6bCtfEZwiIERruLbQON98N2yE8oWNgmmG0HnfXqSbiuu7DPhEDbDdCDKNqp/HY1JUHeq12G2LA3zYCx5XNkRZfGq9SXqPyzBbHvlF7EcZA17s4TzABe7FYCewl+ISP4MEDrWs3OtYt969deX6lWwbbnbzkVUSCEbgrQyujN3ZVzo0TikQ9jHOHZhMc7snP65ghGMJ5egsYZIs4Mf7C9chP0K8JAxGdE2B4x00KdeUKEUgse+B3zPa4pVtORwPzifhp0P19zfyYKw3ct66hedu0sYmZI9twWzPXCjyKwIqrcfhlQMMUAibeFePJHg61pOfu6I+RieVYJyo6fodtuRTCsfe8PKjy0VIKu4H9IiPhFtj9tRFbl7evJL02V80PxAy+w/w2y/Jin0Tawo9Tqy53Zo3hv2c7naUQzqmHDt3jiqKNJayToR+CVVh9FSEVPDde/zHCQoCWimnV2o1XCIrXfUI3LBcn0/VGTLNspeVh/Pe205SP9LgX+V8rxgdWBsIU/MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(396003)(366004)(6916009)(8936002)(86362001)(478600001)(5660300002)(8676002)(558084003)(52116002)(6666004)(36916002)(38100700002)(55016002)(26005)(38350700002)(4326008)(2906002)(316002)(956004)(186003)(66556008)(7696005)(66946007)(16526019)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Jskzx36iOfXtv4ozkSYfsMFJNtip6A1apu7ANqd/6asxLWygXJI9lJxXRIx?=
 =?us-ascii?Q?sof6BuVuiv3VRbQ4+B/eD6IzfarGb4y/rLeBP/dS1pit9Uh46dECk3aYE+4g?=
 =?us-ascii?Q?U1XTS2euVXQ1uQvU3W1O/CiC2qaKe+42k1OFemCH52dyA3pNVU3nTu4Qv4ml?=
 =?us-ascii?Q?VpM+qlxP8LIO21WyIO3BF08dV/uHq8HQQNGJIiATKjrHLMFonSiD+NQ1hGZn?=
 =?us-ascii?Q?oqA2VEIKPbdVJbFVL+jOegSPywdPaOhHjhbqZ2Ynb45altB/sXTsw4WYl11H?=
 =?us-ascii?Q?jxKENbY6iZ9pKxQ4dDcI37iPjRu+xOFpdFdsuQWiFT0knKQHh+sQJJgNmpu+?=
 =?us-ascii?Q?I3NcsDSIfsQ2kSxLL0YKdRXify1zb4Ksj92QWsNw+AcRXppcskLLbUoOrr8a?=
 =?us-ascii?Q?wawUmfOcY1gfwAVIUd97Qc5lUQKZihwdkDjee+OAH/IX1tN+2CBuN9Qf4dbj?=
 =?us-ascii?Q?uonQDAa3O3WriXCd03KLVsnCHtA6xO8l+f3N+4C1ebG4qAGSFe/nDhGTv7an?=
 =?us-ascii?Q?y8H6VNzDCNSo67j8ueVHgMGNYfU+De6AkpBHyPC/BjppAPMwb+OFVb4HEDW3?=
 =?us-ascii?Q?TTa7d60zk9aCAWNpRLVm2kn070S1kjHhxPgqeOio4U6xBj+6rl9HtHCax1ij?=
 =?us-ascii?Q?fvNSniqaM12DWkxt3/Ndg53uz4qbWwWfjB992D/drtGBSBlH2m+iHXMVmFfa?=
 =?us-ascii?Q?tYv3DXsTArt1W8oGooTAEeO6epNIxUYrSfKIvXCUeq8hrgctuZwywpfW+van?=
 =?us-ascii?Q?4kB+0/PSj8inyvdLJFqawgBom+cYJc0gGucK1kOybqZQHSUR2U2ujJvJVoBa?=
 =?us-ascii?Q?XOtlqqw8yi3LNdAvrdufnh1E1OhsAEE0AUpcwhrJmBYuW8ZZUv5ELii6wKf+?=
 =?us-ascii?Q?i0nH31TRev5TeYRnfKSkIxzZrPAa4UP5vzT6IsivoPIiUIsjj6OtJp8lm4fN?=
 =?us-ascii?Q?az5/tdoN2Wfhh0LoUqCPzzCJHG7uAyuco/9gLKgQSzMAxerw5HRUjui7vg7m?=
 =?us-ascii?Q?8bXHrCPE6A5L2Lx+IozA2OHQrzQ8ni+qdzTY65DZ/rSY9fL6EHKgzOyXZr8/?=
 =?us-ascii?Q?Q0K/PX0aFE9prVydayS/8umJNCWJyqYrS6IELXy/QFUacdxaEwDGAslVngTH?=
 =?us-ascii?Q?6uGqhiWG2FSWfUwSjy2iaRinkwsGrUEaPp1tkXZQRK0sxzQbyMjJzmPGQewa?=
 =?us-ascii?Q?rQgwHguMTgKsUXXWzZYuX/F1A9QSUzOFfvdzvydhTuJRuFPuisUzqhsXJgY2?=
 =?us-ascii?Q?7tEVOE+Z5wcRYZopAuzf8+rC5iLqI95lP5SH7XreZpa4sWuspfVXXpxVcjCx?=
 =?us-ascii?Q?+e0PLjyl8TTX7eHGhlla166K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db496843-8e28-43d4-9a0d-08d932cad012
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:34:50.6861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+VRkNosOKFfUrN/fqVNeoR0Tsv+ylsWMTfo+Pr4L+ghbPH2WGIhyLb263DAAsaX1HCMS27FGgssSS6eK+de472WixjV1i2OACt3zGkc+RQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4533
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190010
X-Proofpoint-ORIG-GUID: bGEmAtfhhI_UrJ2zOj53_IbuGjXJ6QhC
X-Proofpoint-GUID: bGEmAtfhhI_UrJ2zOj53_IbuGjXJ6QhC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The continue statement at the end of a loop has no effect, remove it.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
