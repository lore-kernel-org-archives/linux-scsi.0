Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C6AC43216
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57BD604AC
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhHJFVW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:21:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14838 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237021AbhHJFVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:21:17 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5C62H019330;
        Tue, 10 Aug 2021 05:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uVLi1ydr6WL9XQhCKPmdTWVGpGqmlPMKeQVu3zeLYok=;
 b=fx2CotOdvJQBsDBuagI3eMnx94iaKYqHFSGTwnfDdBf5Rm543FuEQDsYcIsONXiPAb1p
 qAK5nlY6kR6WC9+xTXS70qQAk5xhFj7PMtFLjssMc4d5VjByYQoybG0NoRqKwKghpiNE
 C66RTkzSSN98WvsexIQDVpmRlAB2wKNAFBipLwY5XXwEZ6krlQSRp3wHiA8kANlZkBde
 SyfbHcFRsyTO3uxohiUwsICGmeX7PcyzBxiZBcPvhYOfmj9wtXNxh5ItWf8FkhwZsGkC
 TqGgxP9y/Srq2newPrzDKBrIzmi7GrDFrMsRfOpfpHHpLD0s+cZn823JPA6CFYHoNTVD 0w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uVLi1ydr6WL9XQhCKPmdTWVGpGqmlPMKeQVu3zeLYok=;
 b=U4AW/k72kJsz/zUuurYXBGKbPIQTWu/7RpcPN6yJs9cp+a7Dh/3MpCzUIt2sTh41FB7F
 ZHRmHsEtaWuGlDT6AFIyQrR9qQiL9uwMWnKSX91WImaOSW8CeunhFIUEXEnu+3n0oICL
 DL8Sj0aSZVrvAY0REdpCYbdUSawz7NZ8B0l7WKzIr1PN3oTT5cG+290IY5845tj5835N
 RGfdXKQ0skaWEneQUeOnS2ClLOEFSm50ST+v9RzpgnNqfIB56hA3vfaOtpClgDiep3Gi
 V8WOzwJwt8viDcefNPKnoSz/Q0emM9zSlW22+YOzdGzjs9PxZodferh6axbvo/cV0Llf lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aay0ftnf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5A3xA149341;
        Tue, 10 Aug 2021 05:20:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 3abjw3rsqh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAbs5dRyCplKTrDrJaHGtHsw6cyBsEkuemWd2aZ9OiNnhRMY9xkPwc9VwqV29raj0zZYF9YzK83ekCrEiPXnYoE/pQGg6WBG3oSqnuTZsb+IcCjKDJ1QMjkAuU0v1xK8QpdCEzWguO0C7WfOldug+ubp9+ax2rlnBK7kWPwcONAfcpSwkTTth072rOYK6VnJjDd0vrj987V/iawxBBy+7b2hLvCvPljvAxS7Oa3FA4S9trHkFWydUkirQxbFc4o4BlWox9qX7S6o8z10ANAMRzZ1mlQCGa+NX4mMuvmcK8vciiAf+qlAGTnZ5unYo6V9ggIlY3NSNyBNv3MZYJyChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVLi1ydr6WL9XQhCKPmdTWVGpGqmlPMKeQVu3zeLYok=;
 b=l40F5+0HDId0rbpPrsDUgeWlgfxCxiIfCZGNoY58DdvxaimXhz3HyYOWekSPjcIYM3ouGkd3EPySjLaSK6gQdwS3m0FuNKGRLCufiUlMbPOdnAtpkR1n49uCss1PCX00YCIxWZML2wsFeDMRZalfMcl81d8A8nqUbHHmtRsU6epJKvokFsLJ2MKClQrQx96fZobEpZBywrjT9arTEx2h6HOuT5TUGzZ23+Czs+Z/tuQZA4mbZ4zRkkvXPdIK8h15UxghPOf0CB7YtGouokUoryZaP/qLmHcXU0I99O6vEVtzaVEEgt5hcKxRj/HcoTfaKRRyaHIOuJeK8YH3ZS+fzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVLi1ydr6WL9XQhCKPmdTWVGpGqmlPMKeQVu3zeLYok=;
 b=sQFENhCCW3dH+sHuTmtHz4rwcoivZOtNVH+xkP7TnT05G0l5iYnxY9waq1sPae/gvhK8TD5ep5GcOC1MnDVntU2YnlY8vAKX1UGg8/z0qeNZH4VK98+cOJHwU3HalgXicMDCOLxutz4O5Xf/K2ZOAFbYWN05t8YcWQo5QjSRE1A=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:20:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:20:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next[next]] scsi: qla2xxx: Remove redundant initialization of variable num_cnt
Date:   Tue, 10 Aug 2021 01:20:41 -0400
Message-Id: <162857263915.15955.5074328940085534215.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210804131344.112635-1-colin.king@canonical.com>
References: <20210804131344.112635-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0001.namprd06.prod.outlook.com
 (2603:10b6:803:2f::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0001.namprd06.prod.outlook.com (2603:10b6:803:2f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 05:20:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2bd7808-f606-4ad6-cadd-08d95bbe9d7f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597EED77C741647E57201EE8EF79@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H/oZnGbY/uKg3MYW0hj3QMsDstji4UNr+Yfk5pNbWU7bEUyqD0XJwvpZf3GJIft7xqBGJ9KGjRnn5XKwTOfUTDkCmymSeX1uRNP25ziVSW7e9UP999w0MgizMloySEDu0BdhEBrBJwznUloi6wDsUucFUQOxRJOfUU5q8WwbV875d/PuUNkU8/Z+rAvZxNHHINn0R5Xx58XyNSeTm/H+UIuphLdUoxCeXsWpCr0/4XJHUqKPCcgNbDpC533ez/ukvu/IhIGmzRpifcjgC6ojPo+nL59C8NVECt5PSzlLzVZXnh0DjE7IbhOTeIpvv9VI06EIqqJ1y3gdIKA1PDrVaUBSyMVDmNduGFlVwXCJs5qgBhwLd/NDOwGE9DAbw2OntAaomruULlqa9uPTDiLyG4Ypb+ITPo/lyfWrpR58yfBoHwFAO0HCv2CUN1WyndkHTvCVBmqOY8dmnz9+Kdh0lFtGrm0LJarAswqQSe8Xp1JIIy+57Ie/loWnpaApUPHsyVS56EGGbsuhuhDvCMb6HX9WWl7ZMgrpkGXtR//6DZrEb/+M+OOsdvyA21y94foJLyiiivO39dG8mrH9ow13HEgPrCG8+uQJ9kt1jcLFMvB2aOY6pIWiZgJt1Mu3v5WQebio905nOV7vEAdFJxakEgEKIuXjUqTsU/pWniax/gdVsU6QBvYNoTP6+L3hWH/Y6z+jfYhd7zrpb86NMqLPJrylWC11rcJ+x9s+fL7DmziouLXOQoCRW+n1XJZYbOqOmmdqiBqFLMzFy+VNMtiypkgIl5tNgzEWtTs6oeiDDNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38350700002)(38100700002)(103116003)(110136005)(316002)(966005)(508600001)(52116002)(7696005)(8936002)(6666004)(6486002)(8676002)(5660300002)(956004)(66556008)(26005)(66476007)(186003)(2906002)(86362001)(36756003)(4326008)(66946007)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjBTdW5JdExlSmZWSUR3WmFvamFZNlRmK216SktHUWYwdVlDZkwxSnBZUnlh?=
 =?utf-8?B?ODlHN0IrVzY1K09uWFhBaEE5bEdhajVFenJ6YXc0U1Bac2YweW9zTVdsS1lQ?=
 =?utf-8?B?NGdrWGhTWHBydDgvbmxRSEdpYWEwV3F1WDVSSEhTYWQ2NmNEVStBcGRPY0dO?=
 =?utf-8?B?bkJwYlFxZUhUQ09CQzR1M2tERUR4TkFmaC8xWlU3MHpDQ0xzbCtOLzdKNHJT?=
 =?utf-8?B?MGtmL3R1c2p0U3d1YTM3czNRU2R6cVlPSEExUStqYXg0Mkl3MVNtRXBOVGJq?=
 =?utf-8?B?Rlp6STFFRWxwYkxOdlNWTUdXNVhvcDJQZENHYnlzNTlsWHdkUEwzQlNuNDNU?=
 =?utf-8?B?bmUrZFhReG92Ny96dVBWcTVKdHR5QithZ3JHeHJGOVJnUTcyR3NLYXdCMDVF?=
 =?utf-8?B?ZnordW9jemUvUHJYRENiZG1TR0tDSHJoMzZZaVQ3bEdUZFBVczkveVB6T0hm?=
 =?utf-8?B?bkx0QVNHTy9WWnlYVzRrUWIxenlRUkliRURBZEhVVTl1RzNlVDZNUnhmWEJs?=
 =?utf-8?B?OEFDTGNDSlk4NXpMOHFVb2FIclJUTFdpbDdkZkYyZWdTQmpGR2M0Y1FEY1Vp?=
 =?utf-8?B?WUowS3E5MnNOM0pETmdNeFNXa01IRkVSR2xJRmJEclRHZVlYWW10N21TZjhT?=
 =?utf-8?B?NEEyazltZkpkcm9ZSEt5endNY05LbWhrWGtld3FRSXdmR3VhamZaRlFYeDJ0?=
 =?utf-8?B?ZmhCVDF1UFRMaDlQK1o1NEVXY1VySjRjQ3NxKytzdHBuNnBpT016VWNmeFdp?=
 =?utf-8?B?Tk1xVURxVGExWXYwT3daYW95eG00OE50TldiTkF6eXZnRjdQSTVQb1JzZnh5?=
 =?utf-8?B?b0lwVllCeE1UTi9tYnFkcnMzbkRmVzJWVGJ5L2lFcng3UjJBSTNhcVUxUlZ1?=
 =?utf-8?B?U2xLSXVzSDlNa3dsbkpZeWZialRHdSt1bVFJaERYai8zb3IwTENPbFdXYnZ3?=
 =?utf-8?B?a3NDdE01T25CYTdlN3ZqWVpZSEx6YS9ieGhWbDl5azdWaUJDVDZBaE4wU0t6?=
 =?utf-8?B?dDBUR0cyT2RaM0pwYlQ5azJJWHBOeTZQakdLUXpzaVkvSHJrQkt0M0Nock00?=
 =?utf-8?B?YTU3aDhGcUMwNUlLSDdEM3NCZjZ3aDhsbGpZNm45ZWUxK256ZzFIdmFSQlpZ?=
 =?utf-8?B?enI5TWxDcy92YUtzVFJ5MVdaR2ZjTzUxcmdmWk96V0FiMjhaZERCZkNWQWNF?=
 =?utf-8?B?TWoyT2RsR3lEN0h4VGNvczFYdVlsbFpWSlFvTC9WekR1RGlHUi9hM0VBb2kx?=
 =?utf-8?B?emtQSG5aeVl0djFVKzlETGVTUndHTEFxb2t5T2NySGthOExzMEhzcWFNL2wx?=
 =?utf-8?B?R2E2YVBVK0JDUHM2bkw3cUtkaDJTR3BBVWRYUTgyQkRKdncyeWxUa2RvSm9S?=
 =?utf-8?B?enZwTmlBN242WjZQZ0NXbWxkbnFTeC8vbTNMM01LU2xUZzZKL2xrQ1dNbFlB?=
 =?utf-8?B?aklmeGl2T3RMSXlGcjJtd2xkbllnMjZ1Z0pMUVg5QjllN3lyNWkwdjluc0I0?=
 =?utf-8?B?M2drNzYzVVRCWGRYUmxhWUJCenEzNndzakVDT3cyUDQzS2RXTVFZcUE5dXBM?=
 =?utf-8?B?MGxmTkUwbnNhTFpaTW5oakdESy9yV0dVR1pEOWVPN2lyQ1BoY1o3eFJRTXRG?=
 =?utf-8?B?a055OW5YVzNWcCtHRDlSbWVhV2JRYVVhWEJaMFQ1SFh0Y2oyZWRqRExvaFpl?=
 =?utf-8?B?Q1NIbjZXZHFuVllkTjU4MEhwQm1EeStRTFpad1dYNVFra2lBNnFJYTJLdFpF?=
 =?utf-8?Q?iZNfC478roc0zNKIEIsS4HsFlfaBn4RqSF4K6fw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bd7808-f606-4ad6-cadd-08d95bbe9d7f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:20:49.5889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+mMGpE2K5OK1NFGZEKWkiYYygkash1hWaD55JNmHZnczntGiIUZ8/Jn+hlWxxi8wcHZxt9pPMzooGT8loPoZPyv5Zt3mNw3cLDW8Z8qrhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100033
X-Proofpoint-ORIG-GUID: 26CvZCt8DqIzCgwlfFN2qZCnZTFw1fse
X-Proofpoint-GUID: 26CvZCt8DqIzCgwlfFN2qZCnZTFw1fse
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 4 Aug 2021 14:13:44 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable num_cnt is being initialized with a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Remove redundant initialization of variable num_cnt
      https://git.kernel.org/mkp/scsi/c/77d0f07abada

-- 
Martin K. Petersen	Oracle Linux Engineering
