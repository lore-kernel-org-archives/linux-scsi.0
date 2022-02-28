Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A648C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 03:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiB1DRk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiB1DRk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 22:17:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D3351E51
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 19:17:01 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RMWjKm008194;
        Mon, 28 Feb 2022 03:17:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tKYNuRQJCk55vkuClLZt0WX7Wg93YPVqmf+vQVyOzb0=;
 b=deX8klSu9stS5igUzCTn6fD96iDZkn2LCAmNOiIgVUgMqebHRWri9XwgwCqJkIVZXML3
 CTqEsKpHwk6kBvsfTa6Wm+XNarD50W7V3eBfY9jY1YpXioE6P2KHF24vNf95L/NVXSkv
 WAb0RAypUm2YYk46bUoG7rxQENBHbBcvfAUd0gWR1fYgsGQcd1sr92qEYmY/gRkD/Wht
 ut7FA2+/FbjYkh3531rKxtcFFZcZJbB3yhkggapdOj+EEYLZ+uwVg1YOv9qwDCkdf+6B
 Vi834C43y4o4yraCGQqF2sZAsfedNgxE/JGWt7/vuBz18s+xmVnrbmzDcH6+MzzO7WdJ GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02k0pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:17:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3FqX6099828;
        Mon, 28 Feb 2022 03:16:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 3ef9aus6py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:16:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnBgM8aOt2rLX0SrCEgE+DLYXqw6qKKlPNeQXdEq2UC4IsAZ5O7XDcchMIceBk5kYvW68dzpbpKaXgoFmBx8wg83/q6GNhhVbBi6+tucuzskealJm12mpnsCYQJ28PltYhWpRiyy99fWfrIaU/gmOpRhrdKt+ntyO+xGRY9/gEuTdykkM0Is83RRuoLtX7Kh9OGY6sSjDLIAfGSaephF75mjR0eh/DieI7wxLkuWWun7OsUjXLBrxszVik0qo8dJ0WSasHoN3VqAmZOKfwngbzRlxRt3BcWT3rVO19oPBAKPGTmh//3BtZAHnWXjDAhRLOHf0OblRu51aauKcrjUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKYNuRQJCk55vkuClLZt0WX7Wg93YPVqmf+vQVyOzb0=;
 b=S3mVWUNfaKi8cIpPEXp+6BC7Q+09d/VUnViEZeRRNJMjaq2oCIKkXYxvgRGcZ1EPIof3XCap/+A9RR4olGhyp3oUDVhkz+MK7l8gi1soUhHUS0VReaVtRcieN/Hz8PCE45Aa6tUWvVtWuAmTlKmVAtgFZp5k71Lpz07CvF4AuLkWJ8ebSViWtd5WV1QkFMmHHzDinLrn6gSE8yg2sOXVNoBdQeVSbhhonPtz5fmHfv0YtUhBydSSjNZsIxd2YVvjQvNbHow2O23P+SOlZwDL62iNm9oH26oB6nv+krTbn456X/0L1CCb1I3eBdQiXFojyVCAWg8FtyURH9CgGVx1vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKYNuRQJCk55vkuClLZt0WX7Wg93YPVqmf+vQVyOzb0=;
 b=yRXbObAnuOtOIPY2ISJ7juOtRWANB0Ew0fzBsZlZWROHgbMv/pXkLg14s0GEfT//a2B0NF/G80VwF08eJ0owAtPiaP7P4ywn77mHgCnzDMArCaJzfYJVXHvzjZkCPl13ndIEdQf7QRtc6iBTdaZeWJzrLo/vUBeVEynDssr7ZH4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB2493.namprd10.prod.outlook.com (2603:10b6:805:41::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 03:16:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%6]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:16:57 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/17] lpfc: Update lpfc to revision 14.2.0.0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgmb65pe.fsf@ca-mkp.ca.oracle.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
Date:   Sun, 27 Feb 2022 22:16:54 -0500
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 24 Feb 2022 18:22:51 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2319684a-7c66-46b4-340e-08d9fa68c6d1
X-MS-TrafficTypeDiagnostic: SN6PR10MB2493:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB249305D20DEEF448EF1772EB8E019@SN6PR10MB2493.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCTEoEKgvb5X7pqaqJifyBzsB0WwobYTqKb+XUlSfX5/2VYISDMBaXFh1zas9pnIl+yA6VY61wrzJDlGjQLTwDh8H1ezsHO9cJVU+QP84/gBo9hNcQHkd9Olecd1JCzmm5KC9TiB5BNCI2J8RbEt3S6OxRelA/pdLwN5We03pBrOwkoEGVztT9Bkx/zWuOGl0PTk8okno9jTq7Dcyrpmf99CeE81W0T2NkdDGE81vZ0jfO90FVo0ariTYgH0pouTROyFc5eUI5DqjSrwRcnGaL87/TAxbvHIiyMwnAL8arrACKjly9+dz/xMfVnLVELV6uXE8IeUsXVbjPrnKHXwIW+70nNW8KrX0K6HO+3pR7K2f3X0PFAKmuDipf5zG460IOqNjH2L8YtwMkXvqacrzBVDT0X7jKAzn7U+HJ9KdHAJ6iGU1LaeM3lLrS+yLY/oGtBJ8JuJugOFqfvwYrhTfRz6WFhCfBYQJow0plZ4xEoQhmBBCfmvNeOI7GsZuwjyx3ACZKvqY+/FaYlDPyKlRfKffhyLKyjcwqjWix47d7B+Cf7vDG6qI9cB0ZZauD8cdSGF2z+TVqLwdlpE4f4wZbnjGK/2XhZy4xAzmbpirjYo+ho6VUsIQJiqcW1+uCVVkg4fvANFW8goH3wypsJLcVOKLlcAfzzxBG5NkntgFlotLcQjPxjSSt7gNfDBW6oWtk2OhgHW9ZmhkkWQbEh8sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(186003)(2906002)(15650500001)(6512007)(26005)(38100700002)(36916002)(6506007)(6666004)(52116002)(86362001)(6916009)(508600001)(6486002)(316002)(8676002)(4326008)(66556008)(66946007)(8936002)(83380400001)(558084003)(38350700002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PNC/TbTyvhuAw3JyFIxRCtrawZsdxy7/cQBzHCJRzHE/hl7wP9n5drlVzsWE?=
 =?us-ascii?Q?cCJhGHPoc/yvbvPV5N6mjQB1xYyqmUzI4Qk2VEhUOfZz/s2dRjSWDV6tvzOf?=
 =?us-ascii?Q?Z47EXhY2+jk8Zu89FjNTWCtrVUkxbkM3f0PdcD4yGiP6gY8PwUuyTODot3c5?=
 =?us-ascii?Q?kIkB05P7NYdHq8Eow3a6MYR/ZN2gxZPLlwDoAEBdrtIvkMxA8Y8+gpPEHUu+?=
 =?us-ascii?Q?IyVn3noorRSiRdSWcDX0z1HboINyfZLb/fThd8VtoQ+xts0K9KlrG+mgE9Pt?=
 =?us-ascii?Q?ZOEEYC5OSNRrzHMLHpL0ePkkvEkAOD8n9sKM33EneKKwVkDqeFweecPXF9/q?=
 =?us-ascii?Q?JDB28G8WJt4ZdXAHHE14PwYXf1GjnggDZ+PS3M5LRai2zsQ/sTiLagqTv5nc?=
 =?us-ascii?Q?CUG3lhRE7yR2jjB1TZOjtp64J9SmqnDrpFlOv3YNZrPp/rXGfagrHhozzev4?=
 =?us-ascii?Q?IZvyX8MUkqrhW9Bu19xcSf7yX1ObUPHvRIHtJacklaavXZH1bl7uQkVGgz2W?=
 =?us-ascii?Q?h02kikfrhwNqLb65i6hiWOplv3ptPTp6ks3dIrUzuRv4aWGGZpjLYT+IbtMW?=
 =?us-ascii?Q?5ZPoqjVDenkVUbr0WY6R3P9LvdWdw4Nsus07eiiNw146Tpfun7Yg7BqG+4hp?=
 =?us-ascii?Q?fwqWrrM7xAdl+bnwVuxq5RTj7bi76C8euHPGfmTh0sQ1231nZ+CRWxZgWNIW?=
 =?us-ascii?Q?h2oTt85t74Axf29DjWs5omJ6uhUR9U1DHl/a0rtDUNvkbehUEIVyi6zXF5hA?=
 =?us-ascii?Q?F1a+5S/MdsgeZuRFR2hR7OJo93U5izGR8MB3OqCsEAnE91uvmF/BdrGoLKWK?=
 =?us-ascii?Q?zJc3OkIGhcdWWV9zeNt5mALBGNX25VqnFxnUX1due6AnjKoAG/mzgqQFgSbL?=
 =?us-ascii?Q?A/E/oFVwylDTkAqcKg6rd1LqYmo45pc6KBoPPmh/7qNAItokI2TI5VUK2j8/?=
 =?us-ascii?Q?vC0SEg/ieSBzszZienwoNjUpjppznXDSZ1e6OfhrQtoepaMpnmvnhiIfch0f?=
 =?us-ascii?Q?/ThXmEycvPTUhs+B+0oYlkCxCGohuO6u+i6q5NNO89kk7/KUS6AIpTLE3voT?=
 =?us-ascii?Q?GjDMxcU8lAk9XwSi2kVDRmO5Zt0cQL82A3loGkjpyrI7nDVcShLNhXmmsxOS?=
 =?us-ascii?Q?MkQfjxVv7PIbKyROOxADTx0E7ScWFLFPANAG/3LaTBdHECTjx1eCeupg17SW?=
 =?us-ascii?Q?bchSOB0e6r6+hWHhPP2sY4/RRFX58dd0gB07F+OFxijaky+7MLUR2T/TmkTK?=
 =?us-ascii?Q?owoG0jRqxbX04px5Jc7w3LHguv8DgKwHvTkkZBK0oEQh/rphY6HrR5DSxJbG?=
 =?us-ascii?Q?tVxThYsrspw3uX9bjOiWhR4HZnEnGT3EmzeLwq+8s6eUsj6nuCycgJm2iM5N?=
 =?us-ascii?Q?NU0Hllbo+lXFfg9dFzZjIQhWDLbaPAjxEABpoIYx7D/ugVEy8Af3oZ+HlY86?=
 =?us-ascii?Q?va0AKk+8+VPanShzBN8+kbTkv36gdKQ6RlEYU3tO7YXo6TYtn+I6J6p3hi3x?=
 =?us-ascii?Q?Q2i1kPcS7u2x6VGQL3yd/BjTwDG9pP9a+W+SBNES9lrR1HbN3y0ROWvdGkfo?=
 =?us-ascii?Q?e7yFY+RasZl7WUJZERkro0/9HNeVyE/JVdF23x3CPJ28dMrrp7bVx+NTgBOx?=
 =?us-ascii?Q?b4GVTSRjlrtHmDE6F7dM62Q4mj4nW9kSeYJeTZv5Hp0zQaexFiWoZhIwkYAA?=
 =?us-ascii?Q?OpNZXA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2319684a-7c66-46b4-340e-08d9fa68c6d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:16:56.9870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vvrwy+ptQyMtcRsXOklQewKoC0nwPsYaaaonULWgDhsz54qvyCeNQHDUkvJz5HeDFExUQO8iZiyqBbMa3/WfGqnd0bczAlWCl62TUS2Zx84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2493
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=812
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280019
X-Proofpoint-GUID: huaxRY_ZuH7g8sSlctm2NbWvSqdqPJp7
X-Proofpoint-ORIG-GUID: huaxRY_ZuH7g8sSlctm2NbWvSqdqPJp7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.2.0.0

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
