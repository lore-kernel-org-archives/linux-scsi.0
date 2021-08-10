Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556EEC4320E
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3294560C3E
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbhHJDmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:42:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19882 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236700AbhHJDmC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:42:02 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3awmp028163;
        Tue, 10 Aug 2021 03:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fWCP/Q5vMjOW8+eqC1DtmHdTRYrCpgTINdMU5puINjM=;
 b=a9Gk/vK32fldVpT4HOn3d9lnm+zN6o1O9ZXFhyRzILZW27xZGA/Ziyt8GuGVQ7880tc4
 XkbH6X/NGLPq8/zW4MQRzcOk+WtkF5W5Sf5yFJ3lSp87AbVFazLmpLaJgwMZkLYcTsUZ
 Ycg/w6U87lkXUWrKoJJVlH8s+i7WAysCQCYZl66NOiFhC4LmwoLiNgI+T8kCBAaEwMdm
 fSAhhZzr0mvkLlFQpf+q673E8I2SKrrRLy1culrw8aU5/BymFSE5IUe066Bq4tTuyf03
 gJEoJz1z87SWkXk0ehrF8cfoVztWVio9r1HzIftJVjeUjC1x5UnqKb8xxZdduoXCt8l2 rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=fWCP/Q5vMjOW8+eqC1DtmHdTRYrCpgTINdMU5puINjM=;
 b=iZI4eJXDgFi3DvLwniN9o+5GhyIiJ/UrDY2ZmerjFHlEbog2sUNMVKqtF2Q2ot9HInCk
 RsLkd5Zcy24KWtbudpHvxyLI8aoKyh+O1gtkmrQLXLCgqiSHQfM63yAo+1+UoqNKzakx
 VXDK/AJpU+AIaZs4e1AEbF90JGNkuEUmTHluMBft4DlUZL5y41f95W+o86/xYXImxIcX
 SHGfbLPo6Hj5zs47irjd+Qt0YJ8WI1JnS71Hllp0Clfrbw8T5kCKcWF0Tn+73+WitzsM
 lYHNAzcw24tcTydHD9ZDcXEW/Qx0g0SgaXxOU6hXL+rhZNy/xs8VebxYDAYnSvJwCUxH pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab01racdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:41:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3eLFw084948;
        Tue, 10 Aug 2021 03:41:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3a9vv3yn15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:41:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EW506ngmGj4vaFjJ/4Y43YL+XO4oyODosfui9X+UJ2f4xU4zuHm86e1YoQXrq7YKtHxFwj8xqxYa+TQiZUHgSe+tQBjhSpRtj+o+X+tqXW/8EOU1dCUwMjBUvEpZoQV9JYbf5YDHX5VsQFqHq76FsIEtITvJsfJD0vD9wr5rBZWGhqCHcw/AgvFiFH+ofS5XFbkdKcoF0dPSdSPmfQhgcKXHRlfL2CYqXgilqSLq1F5fmmw9wdvgW6bOuEuJ4F4Rj9fUe8sPte465prIQOYqjeDvJ+rVoeSf7quRm49s5myg5GvPd0LfZPV+yse6VzNpwqth9KG55yq/f175onLvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWCP/Q5vMjOW8+eqC1DtmHdTRYrCpgTINdMU5puINjM=;
 b=fJEH9mykHpPvSq27/ATEFUq8yshKr07ZKLqmBF8D/UhtPPoZu8Rhx3cCehMZ461O/eJe7o1rP/oNP+UJhrSLmyNHYRlxBIxE30QGQFsESkrBygct+w/RDsJnAjRx1GduymeNFf4teIt7d4AS2Jpk5um0mhAvb7i4JertAb+1DWzaC0FsO2c82RSVGx+drd8XCly+7Fjumfs4JtZcZ2/0dcrwFgBPfdkmX38lI0pKTDLPoUbYNp1hpwQvNFQeuGMbBE5fXFUwO7E9oF3LJgF0ihJPwW0Obil+lSFx0aQHb05aK2/u17VddZjOk3bmV1cVqJrqRIY/whCQSz1M5G02Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWCP/Q5vMjOW8+eqC1DtmHdTRYrCpgTINdMU5puINjM=;
 b=J/pjfwVutHQIaTzDGtuyQqgS4jSNZlQEtY872qV92EacWPavZfwGNgGl77xqr/UIjcy8AtwFkIEN6o0Z8i65wxESIozJ9dnI9N+VudZV5Q9L3d3M0wQ+XsgHYzCLJiuZhAThpMwE9VNjFzP6l91RayRNyZLuYaGGVWBXFraP7fg=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5641.namprd10.prod.outlook.com (2603:10b6:510:f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 03:41:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:41:34 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: Remove redundant initialization of
 variable ret
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135rivue5.fsf@ca-mkp.ca.oracle.com>
References: <20210804132451.113086-1-colin.king@canonical.com>
Date:   Mon, 09 Aug 2021 23:41:30 -0400
In-Reply-To: <20210804132451.113086-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 4 Aug 2021 14:24:51 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:806:21::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0028.namprd13.prod.outlook.com (2603:10b6:806:21::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Tue, 10 Aug 2021 03:41:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2908a7a0-8162-467c-8d1b-08d95bb0c02e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5641:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB56417D2948607F282B3598A68EF79@PH0PR10MB5641.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LD2Mv6EAGBRAf2lkRM/8h0RFE3D+CAhesv0UxKn2jh5PBH9Te6bBryThnMRCmBCQhZG60hSZ7qOCUh5kAiIeDLYCEo3TgVc7G2E2Vm91I1qKc4agal3oMFJUEcxDLEwv/wsSRp4Y2ktdfyFqgtUvLUzxbibK8wZ5P1LGo2EXopq8X1hS5I02Z59WYOWTU57eVdK8sQ8j9+PWt1t97e4wHNdK+EHp9/1tDoDRyQzJvVm6ryDBtpfBd8PduiZsw3CHgU/MpDx1pfcQUKGT/89/pqv99YH+a4x9rWP3Y3bw1NeAIM0yz2gXtgkC+DTSxpME+d1OhIcRTDZ5UC65vSlBur83CRFlxhOHbdcx3wBvC+Ysgg1EtYMwXoRhaDPIPxr5sQ1btwVkLloENpPwDus/0MOjiC+Lb1n3KjzEMInSRVhuclPQ2qcuiwH18rM9A/0THJqrkcTJuj41nKpHSP0hW3aEeFiJhiJZx+Fzq1eMcu/Cs/IF+dMvBUbTOcQn6RsIxf4vQONbztNWjQrb5F1tJo92kDvM5v4r5FI5PL9TC3ITqRvTXw04bYh3kgv93e1GWnRoChYoFR1Y2aBw/i4QIZOJSk4CSrGDGgstGWo5z/lmK/U1Pfsu1YP6VOMxpZO/n6RcIdvcJ5kUkbo5MhduseyREUfJMfojvkDijrZyBOnwMVAnSDe9NVtjN4fV97XKdjosWMaV5vtWEGMc08QD4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(396003)(39860400002)(83380400001)(6916009)(956004)(5660300002)(38100700002)(316002)(86362001)(55016002)(8936002)(38350700002)(186003)(8676002)(36916002)(2906002)(66556008)(558084003)(66946007)(478600001)(4326008)(66476007)(7696005)(52116002)(54906003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9kW3nVAVsuVIADBkIrAKQwXxh82PW8n19eOUvZJR/Uo68guPzSD9m0bgBUtb?=
 =?us-ascii?Q?ywi8Le5AQR/ZLKtDGXazN0GK0NdKGGRzToWdc9xoOowaKIZG7fG/5sTQVx3i?=
 =?us-ascii?Q?TR48MGpwVjGVXs0iMvouRduhnQMjMahgd52T3CcMGEfKufnDfwpbtZIVczh0?=
 =?us-ascii?Q?KQHcjALb/0iRNIe1CjpCIObT2aLq32B/qUvvaIg952qMtkwFy4gY3TyECYfv?=
 =?us-ascii?Q?MALuNSIVgYiL2At+SnfL+ZIRRi0AjvLGttOilOWLw38j0eMwhZ80gbGUlJNm?=
 =?us-ascii?Q?VuAhUofqKkasc4bgIRZHlF86O31836oEoFiIf5tQRBBTAWpmyMzCEj7a4xga?=
 =?us-ascii?Q?p1FaXxlbxMiiS/37UKLbgj+kR5rYPUYDVRrd6xVo5Wem3BCqK/fZuwLVnwvn?=
 =?us-ascii?Q?Heb3+RSGiXMJSImK5hE/K/fCJYFxl9243mfZyjAjNN1UxEhMAV0Fc2al1JAj?=
 =?us-ascii?Q?Vw6ZWD8aeSlCtKnXUhnyfoWChrEgNgGla9Hfd2qd3WMpODuJwq7XQsMCcQeE?=
 =?us-ascii?Q?MAnX2z7qih7XeEKpQzHCSuOSsUJjS6P0a37uY+tZJI7rG9hKp60txhlMvB44?=
 =?us-ascii?Q?EDaVYS07Pb35DhE5kcUUUksdqBjf7DDRSiyPQUwkZQD7IwC/za2zxShW4OgD?=
 =?us-ascii?Q?iQog0k81hHbQXqxWg/khuexU2EepYUuEi6y6rt1hx81xC9mrFqeVu2m1GvyR?=
 =?us-ascii?Q?6rpqZvN6wkRlyF8riPOC5fCCgtYKBvSgczEa3rJEkCTGRjrSqpLY+oGoShD6?=
 =?us-ascii?Q?5XCMcrATywE2IkbNp/k5lthF6YPpu3xrC5kQ6wvqR0TMhf3sSiDYpxYVasUU?=
 =?us-ascii?Q?0RmnJPBPP11SyeFCGOjfFxxg930Bkce+2/dsQNHFHnND5PE4OYvWsT1+CW2T?=
 =?us-ascii?Q?rWTGYitqW5Fu8whu1ycGkoTRLpLoywkzVJJC0/4slHR3Jgq7nWR60PTYt65p?=
 =?us-ascii?Q?XwbVAtVMeI0cvSgaMZcv6uOkCWpujNxEGijJCGyzbO5PNGlBrUIoU7v2iCuO?=
 =?us-ascii?Q?+qcuUkyrcyayBm85YKrvTzigXNjTYltFpy0DhXHjX4v9aO3Bb7hNNURJDg4M?=
 =?us-ascii?Q?/PG4IzL4p7P5b5QaXWwTY673hM7juHC61BKS7T/SP3fzcjFAkZh8EOW+TpeW?=
 =?us-ascii?Q?oZzKY5zi7zfl/SYsF0Qo6QZEEM5HfmVqn8uq2+1lLknKjK0sDl6ZKU3Vbhbp?=
 =?us-ascii?Q?28fgPEQNOgMdvYcBadv0/SQRMGoZnpw12FI7Hs4Wku6Z4IkM3h46xQ9w0lY7?=
 =?us-ascii?Q?DgjYnzps3JGbjKVCY4RpOg/1fKdQqk/KclKzxrER9YqVeA5QLlcfqi4Gv45M?=
 =?us-ascii?Q?jvPDp2sy2k4qdEld/WSdgdda?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2908a7a0-8162-467c-8d1b-08d95bb0c02e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:41:34.7110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/RpJ41Zkfk6+GkkcwT8NY5nqbtd0qrhYWP3+curcAiZjKbLeiV9SlsRZoC8sjeC6Ae0yEBzJ0cL5tztumkWQmnO0msYFNOXBINFn9nCpys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5641
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100022
X-Proofpoint-ORIG-GUID: YYhSem357j-o4-RXLIkhS8_6XKXPa_IX
X-Proofpoint-GUID: YYhSem357j-o4-RXLIkhS8_6XKXPa_IX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The variable ret is being initialized with a value that is never read,
> it is being updated later on. The assignment is redundant and can be
> removed.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
