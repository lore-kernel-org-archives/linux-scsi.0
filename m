Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC91C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 10:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AEA6613A8
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 10:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhJDKk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 06:40:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33266 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhJDKk6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 06:40:58 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1949j8Dr009316;
        Mon, 4 Oct 2021 10:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=gLBygyd2JajriYtpgSuTFQQeG4Uw2+wMSUy/UljS+4w=;
 b=Z7P0Av+u9+fA6FfnLs5JyfILJWrqQ/Ge4ufti+KR6yeSMNLTkg5B0txase0RsV2IMyxc
 d4OBIRiqJ0edT5ELLHpi2RrHz8gCQiwiGpiQTIbjwK21MYdUy5Vbbbcm+tV+GYDTsVbm
 7ppmuHd9cPeCX21BJvZD8shu622RXkL21T++JbuNk23M447VpLipieIC3NkoZ3/RlUpR
 xEsZ1uw9OZ3/yWAPacwKnQhXIWBfNUXI1LaERJRZGHj8P0iUAjviv5yxrbskDPOm/R34
 PxiZCPrhKhTpjNA1J0+U5SCTGUr2LOlbyxDIUCWuJvFJOJWwCeEWO4lUedcog8fnpjgR kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bfbatu4dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Oct 2021 10:39:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 194ATrvV183162;
        Mon, 4 Oct 2021 10:39:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3030.oracle.com with ESMTP id 3bev7rfybd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Oct 2021 10:39:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdUzcP80PK/RXU51yKIVE8ZTqa3FIVG0osFLi9om5GAZ/15Ol+9Qj8Af0MlHcSFtb+iUj+hX8a5Mk/XD1pfzGsfBCbYqSWDWq3Z39t3UkyjC3u9oos6gdE5pmAKz/kVl2arysYXCI/rjajbw2xAJz8qhUpVacktErctCg5pPibfbMcnTC5w5w+Hfbbrz0qyXuj6a9hyF0Q+xg8wh16mqt0L0pxZJlZYrY5YgRqBaHPu0PyZPCobOf3zzwmEBVPiEe5svWKNRIGl63TXD5088IuaBJtD96npxazNoiKuu+TF/kBMgdS4w91pQ+dwLyPnz7JQ4twmCDuZbfX5HXg1aTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLBygyd2JajriYtpgSuTFQQeG4Uw2+wMSUy/UljS+4w=;
 b=N7GoqkT5viTR1LzgDIqkLZC03O7HQu+hy8skV/Qgjs0x835kNbJlDcS6pjplFPIunHaIT4w28a2YbduzvyToMh4hFwM88CY3H7PnMc7i1Djgg1OLQuvsD1DuiuPvhgppNauQ0ZoA11IJZnPe+t/hnxASz6zmekQyL6MVumSLhbCmbq1HzN/jBveZjX0JVFB3ksnjxhV9BQuL4UAdqa/oGlY09ZMDtCbzE8hXRCcQ1TgXqm2NPMnaPmLq7D0Y/bWAahiVCpFq5zXC8jngHuP5vjm2Y4EQ68qGD8asWFtc7fNmFNGROw1c14PbwXiFZn3Hr3UqMVaanX59hg8FqaGtsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLBygyd2JajriYtpgSuTFQQeG4Uw2+wMSUy/UljS+4w=;
 b=MRWgAvH4rWh36pvEjKaXU7rE5X72d9owu490EB22cD7c/5aFVn176fl8vPaIYk+fjc/a6KWn70OMCCoUU4+DvQENPgbcL1i8N7DV02GSGfwGl1r/313zFnHyE1vdEdREqyGMGFsPizF7IYTMFyuojdTwpLt4OkCXs8CC1ylg1CI=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4484.namprd10.prod.outlook.com
 (2603:10b6:303:90::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Mon, 4 Oct
 2021 10:39:03 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 10:39:03 +0000
Date:   Mon, 4 Oct 2021 13:38:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: efct: Delete stray unlock statement
Message-ID: <20211004103851.GE25015@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::10) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Mon, 4 Oct 2021 10:38:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c21e9c99-7346-48aa-737a-08d987232efa
X-MS-TrafficTypeDiagnostic: CO1PR10MB4484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB44840B1DFACCA2B308B25AD18EAE9@CO1PR10MB4484.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pG6xU2djtMuVfLJ5e6XlSXGlSL8lu01oC4GSUVSylKa31bT28IQHJ5VISr9dC829pGjkMOsvsS5eCQBDsCp0gaRmRIDSVHtdhXp67rtFA1KGld0CV6UNh2V1AlQFILd7WbqjDpnwL2cZ9jvsALDjSCJ0DIGuID4WxNZ8usBsKKDqa1Z/+88wDBdFfApcy1c8LrsvnIu7HG8xpe4l3PDo/VmNZ17E3gU3F13YiWZQVPHtLauFJ1OtFfcvRP2+ZpTVqUwrVzhnIy7OQiSuH4dBofWyesdSkATI7Z/+T8VkdlZ4ozFJYPoDovzw/qJrWZaE/l3JVwFpuSr9nJ3/ymmQUA7nG0ATSBEVLSpbskc9cq7NfqI/Cr/gLKXE4EGDcGIxas3kXW54CBIJSAD3733YEoNIvKuONyMAjkgIN/xtp9TTj0GbqzRHYBqbm+2ENPMyu2zF59CPOABqPJZoGGfVolbA+TrYkzUcnEwkBliMgGTtuH00Uz88EqBqRlS/no2TiM5m49NM1is09Ax5EbDMi5P14GAVUH+zaW/r07KSDDoBoGRHjxfLrWEQyePz8fKJ5S2TI5HogZeya/j1EhfgFuJ6sxZbsJu3Xq2XWVsNfy8+i52WUNhknDcWkiMtou4fpiyppc0paRdCfyz+OdBI8ILXk69fEAqm5tbfS6TTeL2L0zBgi1QQu4j2cs1ncrsJVd8eQ15gbNqgHfBM2pmSqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(956004)(6916009)(26005)(9576002)(1076003)(66476007)(44832011)(33656002)(66946007)(2906002)(33716001)(86362001)(54906003)(316002)(8936002)(6496006)(4326008)(508600001)(52116002)(38100700002)(83380400001)(5660300002)(186003)(8676002)(9686003)(55016002)(38350700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EGf9jf4p23dprwfLMG2fd/aKTCUpNrxA6hfQpy+lh6j0Hk6EGFs1rMWh16xF?=
 =?us-ascii?Q?z2medSN2NYspvdMxvWUb3LVVY44B7nl1NcSQbveVkBaIYqOQE9plArmELGEy?=
 =?us-ascii?Q?ViPNxhV25NFegjtfmIi2/5eQmRSTCkxtmq9JsHVAf5J0S2uBA1UuOfRtkCqK?=
 =?us-ascii?Q?e/iY8eleFWe61RjqWxCVNqxjbQnzv/lYgjs6x4aDYfXwU8WbSk3vKe1F1JBV?=
 =?us-ascii?Q?Beaoi6z9Q1bCYJNOjxhG6nOxkm/PHZko13oVJqFYZAtPWy3b03p4dGECUdqn?=
 =?us-ascii?Q?kf2pn0+0LSxf+OGPD+q+jDxDyuSGgxKXSXRgO5BsvhUbnDJHhzTKM38JswEZ?=
 =?us-ascii?Q?1x13TodikW4CP56n17xkn4vE9r9bdpGcK2Pb26nTrH3rEh09+IKxsNm1OgR2?=
 =?us-ascii?Q?Fx7YfMdGZVr/wr+ziLC3IYYrQ52YSNVstqJXIYw9uNl438IY7mokB2A8Q07u?=
 =?us-ascii?Q?0IP+SBKdVyOcpWeDl+tpxJAdQBY9OdIH0QnTwloehJWFKyVjnDQnLrx/6guK?=
 =?us-ascii?Q?XLjLh/gTYIZw5U+A87iGfmiWv317/zkTnNChx4I8bjk9JQhGn+HNNPP/GfiF?=
 =?us-ascii?Q?bdmHo7xBZjybAX49aVw5ZVjzofaKzL4j68KfG2m+zsUiqiVlbrRH4Y20MAun?=
 =?us-ascii?Q?Ud+i1TxjSsnfxMBcAvdiWfDSecc87LortqTr55//Y4zGRoihLNKiDU7WbbVE?=
 =?us-ascii?Q?6WFP8RiQsnVEu8DzLNTB1ft+D5YlvzLpuuWrUniCQ12SNrwYekKCxyocAE3r?=
 =?us-ascii?Q?k7ftw6t2Yh3CD8/NIjcBlQ6v6rpNO8AyFaSLK9t0tPAzFOIWAt6rfB0xvwt2?=
 =?us-ascii?Q?VYPI3xpjkWtVm2ocnNgJ+g+y9RYYMtwXxldHHEwuXxYQYJ5KqcV+B7fyrH4v?=
 =?us-ascii?Q?Vy6QqxHTRx2B+pEYo2uk90jBb43rwT5tOd1Gx96ZBh8P4EYZs8Ds4/kBjw9S?=
 =?us-ascii?Q?tk4NdK6gogqe2SrU/tBqMRkeZqVmuOwTAIi+WWu4mhg+f02yJqQ682ihXQRs?=
 =?us-ascii?Q?N2pzStlWwtPvo5OeWgtS/mi3/JGXdVOwPFMTm/mpbjYXuZNb5kLeBK0WHA7X?=
 =?us-ascii?Q?PxT26sWrTD8/zg6dA0f0I0Eo4NfiNhN/bK0Ks1curkJjD6NYjlPDZ49Uq8S+?=
 =?us-ascii?Q?cWXU3WU9yLV1QqCiHEFELlXXN2ZXa+M5c2rmlK64db8uBtYjgjgo1ygqVV2M?=
 =?us-ascii?Q?WOYKIf0Nd6ufya5CcVrwrK/L+wOZIxOwU7u8dkRhfN3wsppTduUoWhbbzDz5?=
 =?us-ascii?Q?7jd+X6n0JSDXq0Y809NUFSnk984QrUsKIYOfXgmsXyxu7qh/TX8db+QiXHOa?=
 =?us-ascii?Q?nRYnJylcNDbLsigMDUSVgMYx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c21e9c99-7346-48aa-737a-08d987232efa
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 10:39:03.2525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g9gxW4cEzPE5phM8OE+0TRLpwhlAKW86OegRTZLhgnr7nGSA7lw/Nl+/AtNKxqX9PxjV7UUQVnkmDVLSJPOvkpX076JYVCobuvTgMp6pE9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10126 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110040072
X-Proofpoint-ORIG-GUID: cHBiC4Y53mxfZfdEzN7XDtGoq279OXyy
X-Proofpoint-GUID: cHBiC4Y53mxfZfdEzN7XDtGoq279OXyy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's not holding the lock at this stage and the IRQ "flags" are not
correct so it would restore something bogus.  Delete the unlock
statement.

Fixes: 3e6414003bf9 ("scsi: elx: efct: SCSI I/O handling routines")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/elx/efct/efct_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_scsi.c b/drivers/scsi/elx/efct/efct_scsi.c
index 8535bb7eabd8..afb154992053 100644
--- a/drivers/scsi/elx/efct/efct_scsi.c
+++ b/drivers/scsi/elx/efct/efct_scsi.c
@@ -32,7 +32,7 @@ efct_scsi_io_alloc(struct efct_node *node)
 	struct efct *efct;
 	struct efct_xport *xport;
 	struct efct_io *io;
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	efct = node->efct;
 
@@ -42,7 +42,6 @@ efct_scsi_io_alloc(struct efct_node *node)
 	if (!io) {
 		efc_log_err(efct, "IO alloc Failed\n");
 		atomic_add_return(1, &xport->io_alloc_failed_count);
-		spin_unlock_irqrestore(&node->active_ios_lock, flags);
 		return NULL;
 	}
 
-- 
2.20.1

