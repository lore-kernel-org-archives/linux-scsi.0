Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529CDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbiGGV3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiGGV3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:29:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D560A15FC1
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 14:29:08 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCGUw013695;
        Thu, 7 Jul 2022 21:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kj8Dj4qxVPlVYI0BRsL+WXwD639qJs63vugr68hgYPE=;
 b=Cs1vfhAocObUy1+d6VlTIuQHBJN3G+lyWlqU+KiewBy1/4sf3KPVmaBm+S3UV6aLQCTR
 Ala4Jo+R1G2rYGCnLqylnwCtdNYGXWewlIdG+g/Vc+I3bHKs3cTfvUIIUnQAjmtv2WzA
 S2f0/KO37u6RLQiwJ5YuWvuBTobtRnOumTbTpDjjJAMeedAL26wbFShe/6ZsmShuKTKP
 g8GXZne5YNt4hPHvLswRngNzNKm++vnfzh+A1P0W7woXNrkxo4QY87aFf40LdLjrC+qe
 H8gTKwvowehwS7+mCDjJn6QfdWiqm0ekiiQf0H4qauXA0IIAcbCyhRb4BAi+yz7u9bIl jw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyegkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:29:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LB4cD014468;
        Thu, 7 Jul 2022 21:29:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud225h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:29:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDOc14wuHnSJRgiIYz9qWmefmmrnpiP7IFHZRa0R7b+R3usKN9cIxdF6/OOuC0pc/DtqbylUUuuUoY00QHT/aGgQaPEFq18WCWkpDGjYtqAO51Cu1xz8eVXtrR+EyDBYUNdHy0Wq+NVhfXxGd/4/GX0lW4DjhcEuCLUrk0gcr4Dcd5xmwIEjKMRmdgmKR99xRILHuvGApHmFnQ4TBLRLqaRqpa/cKawRbEV+yE8t2+sM3SvSnb1fgxS4tKboIWP7891MyMN6X9zMntXzeos4Yym9ll3wv0lWcfrsI7e5ku4VuTX1VJHdeFVMLjWETTgkVpDVl7eXVxXwp0xvBvDqHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kj8Dj4qxVPlVYI0BRsL+WXwD639qJs63vugr68hgYPE=;
 b=MfZv2X9d20DX89bkDz8Tn0CSKUNgMaqW9DMjzQgoB1JE5NBq66g24TCroXXajhENTyiIGepR1s2PwjeQ6BTYNUaofy9Zv4MNvhyYg0XRULQvX/eS180QwShIgw4To1BH6jsMtxT2frS40du75CXECQ/uuoSxGSnrwR9Ja8BUJKkLceTAkwTOAOIzPBhJ3/5VpUksDIT/Rl2MvB0IKK4Fp0YlLdvwYOuq8xGiaX5/r2P6THb6HlDR2OER73UswK3wvHMHZQghIAB2b7PLxRRR59GPVCqTz9jQHDVNz59TtA/O+ycqVcY5Qg6NythAsZwmKCKx11JWLzarpbgJnEba2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kj8Dj4qxVPlVYI0BRsL+WXwD639qJs63vugr68hgYPE=;
 b=O6Na0X/xWX7ziM+VKydPSsqVVpP2wyaGYxRgn+yRzHWDXzoQedS3BeSj6Po/7JFCufCA+1ZKfJMAZJBTc/GbwrpVXSEjL1Ob/yIj7dCEAZ5WPSbYwWtyhs3QmJR7lcirVWS2qx/SYtmFc1E2922T7NZFp5nEx8sdKN/gJPiFQ8M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB2553.namprd10.prod.outlook.com (2603:10b6:5:b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Thu, 7 Jul
 2022 21:29:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 21:29:02 +0000
To:     Seunghui Lee <sh043.lee@samsung.com>
Cc:     linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        Junwoo Lee <junwoo80.lee@samsung.com>
Subject: Re: [PATCH v2] scsi: ufs: skip last hci reset to get valid register
 values
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czeg6296.fsf@ca-mkp.ca.oracle.com>
References: <CGME20220705080318epcas1p18896b13b2f7ad16509d7047584f1fe86@epcas1p1.samsung.com>
        <20220705083538.15143-1-sh043.lee@samsung.com>
Date:   Thu, 07 Jul 2022 17:28:59 -0400
In-Reply-To: <20220705083538.15143-1-sh043.lee@samsung.com> (Seunghui Lee's
        message of "Tue, 5 Jul 2022 17:35:38 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0045.namprd02.prod.outlook.com
 (2603:10b6:803:2e::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbf4cac9-c1ad-498d-2144-08da605fb64f
X-MS-TrafficTypeDiagnostic: DM6PR10MB2553:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LGnvTL55q1+nMSk7oWMkD8AWQ9RQ51YFN5UTspXVtFKv41biKVeEIcV4jwVhWYUo2IiBWpaAuyenQNd0/EpXARuMCGAVuJHmembs65IS8su59fSD/y/ure+N+Kwr5HRyG5GGr/icN9dBPYC+fyINqTxSGeRPDPNb4UsYV8PXyxevvEN8Z028FNcfjBPRmPjJ3MbccAxpyf5VdAItTrOhOiTM2NrZS4jWkVJestN16vZ40hkVtCAA2Ap84OGcATiDgJJmEsQcdAfyTqjF9lRmUTbdNrKQLeCmPJFB2wyG1B0aR57w8B1Nvr+KBHvY+8o/eJXrvaHUtCIoWA1BCcwn8L4R+95PvOxVST7N1FuXEZgQ1/QUQ9tUbjSvbZ616BqJsawB+HZpOi8yBxATVb1hZnGEZ7+gCp6NSHdCCHPNwYyZzfPvlNi2it57LrP9J6vDW1RL9h24jrdm0jWyGRlPVWgyYc8+zkmrcoo/wapFVFxnuqeU6G9lwXAvKYjklcwGGtJCXMPbSFS8WhM7saYI+vdzx9fojx71A9ta9Yp+78hi+eBWhu4GmU4G9fr1BRtwWe+owWErEw33seEcJkCzfuQ15Ikqf/TW56p/MW0Ib4u8bIByw2v0E+bSbfx00byFGk58qJHOkZdrsCnNYxXoD507KqU1O+RKZwDb344bXMZgq2zgJhKlrEkCNypse562i0xCiwmq+Zs8elLQGKyDhopac3GCvYDQV44Y2m9SxhlovxX/f72Uv+zjJVO7uPTdzqakdMPsSYgEKLLX93tz+r2k9BD/MHFx6A6mQbRPpqEb3oeFbJ19ieQ1rtx1eDVf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(396003)(346002)(39860400002)(376002)(5660300002)(8936002)(86362001)(36916002)(8676002)(316002)(41300700001)(558084003)(66946007)(6916009)(66556008)(66476007)(4326008)(6666004)(6506007)(26005)(6486002)(6512007)(2906002)(52116002)(38100700002)(186003)(478600001)(83380400001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Orsj3q1CyQc4ULrL1MdVfwQTdBYepd+cXWXx54JKYFAczqsri6QsxP1aX0qe?=
 =?us-ascii?Q?IuISxBFmv41FyZqaeJr5tro9HXoJ26E5Yvgp9vFlzPVJ7x8ZCJA/Ebn6u2me?=
 =?us-ascii?Q?XjDKklur/v9DzPg+cetGqsNI9fWLiihDp4hGzOKQ3ezSOEPOTBqNKB+sZVPj?=
 =?us-ascii?Q?YJPl6SODbCwbYate0cgx7W8DJ89jw4zzDXZNIJEkjS4l94a1nyKPYXgJuJoh?=
 =?us-ascii?Q?8ppPR1CVV9vKYWjPi5w3x05k8nLxjZz0ofIUWMibTZc+2ifKs3ER3cYd73XS?=
 =?us-ascii?Q?B66SpwpcM9SdrKlEng9FmeuHB6UeXLqxeHv2vfxsgBZCecXuKA86vwSgnVka?=
 =?us-ascii?Q?ERDCD/oRXXc6q5tUsIWg22l92yht8gyjj+z4cQ8Rp5mc0QYItHjxFcdpl+dH?=
 =?us-ascii?Q?9GPI9Cg0SooBmjAbIdseIlZ4IzCx8cS8tqpH0cMiJwKrCi+L6RoCxPgG4qf+?=
 =?us-ascii?Q?qP4dShFah8VupIadp7x7AFksr1ZML4d+EslzVjfXDdvjBqVJrnXMwH+2fl5Q?=
 =?us-ascii?Q?hytH1Vb00kRwaHsKBdN65SNo6yuKy56wxZL93/bvE8L4TuLZEr2h0AwyS1KA?=
 =?us-ascii?Q?y9sfP/zhtk9kub2p6rT0iJHiq2+rAVISoVhVSOhHz68pvUv9MWY+ClgDp9C8?=
 =?us-ascii?Q?AeCco5CyAYfPL2BQJBFv1LKMEqU0kvDYJ2xkb5M80gX5r/+df5uknctT/AfX?=
 =?us-ascii?Q?Km/GFM2n49GaTHJbk5b+bi3TD9ywyQCbfmmLqpsg7LJZ3MHFwfjRts6ZVEvi?=
 =?us-ascii?Q?slZNUTGy3y7hWLjLC1vMYIzuXh7kh79XN5maSJucZqVGIUp48QvnJBzSrh6h?=
 =?us-ascii?Q?R5ACSwhlEvWv1ultpeGwuXVnoD3bz26MfhW7Fg+Hi2aY8Q4BcCHine9N+QuC?=
 =?us-ascii?Q?/No8331FRng/++nEkz3VSMD5Opb0INPjBzmRlaL5EJNJrWXhzNi6c0rY70HN?=
 =?us-ascii?Q?ofKm+BXbr3bZxy5bPAJ373sPmv+CgBui0Otm+ikZqztAh5fEt9ywf0sfSahT?=
 =?us-ascii?Q?yi/PXR3eZj8JMa1anPmT/0xjRhtEsAlh9fB1v7iARSGrkeqsupWbdWrcCngQ?=
 =?us-ascii?Q?afDUVVgTI6LqDHTlmQt5mjgdNyTxRaPjSz2d3SrSd+ukqe1rKaKiqgg3uUAB?=
 =?us-ascii?Q?eGyTprBOXpiUCUtvEO7PfO/WUPn4CEiui1jFiXbDZuHX92DLFsv6HCHve8EG?=
 =?us-ascii?Q?gR7gwYEv97A6p14/BLBC2F7zVcOfY4/ROMBj7qboaA1Xp0EQlF4JgAGbn8Kj?=
 =?us-ascii?Q?Q0iNWIXCzwJ2MnIh3qw9p69Z3H6VaTE34Lsq5TVxtR8Xz/plwhnQla5fiHNK?=
 =?us-ascii?Q?QOSYFoMzU7PtQPgJuU5A8bV4m7PXJTNcrfTUmcQ+jef8aHkNjDoYIDkjQt3g?=
 =?us-ascii?Q?PgQQwvH6pyjVkKm+NFyoDVAwd4BNpCAXRcCjU97QXwH3Nxw+uMXX3V2H+3Ow?=
 =?us-ascii?Q?ucoYew7ZO6ztqFD7CDTnkwP4fs//67WsIrtaTQs62YHKVa04aispKUSJotQm?=
 =?us-ascii?Q?dTt8GYGtCDh2EZeCEOfseWE5AvTqXTNAGrIcnhPshoCzZY8LgfHPlkY+ekPf?=
 =?us-ascii?Q?vHpWrPlT2V0pJ7Naf1XUtKIkvQ18Yanu/8zmMoeAgF5zAFRwQOgWj5ChI9K1?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf4cac9-c1ad-498d-2144-08da605fb64f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:29:02.4877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRZpieYif4m0WtXh7kbjJ0OPQ+jeiyUM213xC0NkRdM8dJLeIki51xH+k17LXFJoHNewd13/Q1q3EI0EhpGcJiwaQMLbZdm5VrFswCkM6XU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2553
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=871 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070084
X-Proofpoint-ORIG-GUID: zHw4Rz1CGihZWmHmcQrQ1RzCR76kAaTA
X-Proofpoint-GUID: zHw4Rz1CGihZWmHmcQrQ1RzCR76kAaTA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Seunghui,

> Once the host fails to link startup 3 times, all host registers are
> reset value except ufshcd_hba_enable after linkstartup failure.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
