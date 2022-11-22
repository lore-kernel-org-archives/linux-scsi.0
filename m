Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C56AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiKVDnG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiKVDm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:42:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D7E29376
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:42:54 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM2x7wV027289;
        Tue, 22 Nov 2022 03:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=e4/vqbZpBcy1QdnRG1cuObCABYNrd0+t6/j6bN1Zx7A=;
 b=J4s6Lh9o5fOLlsPjq5lHUt6OpgtiBEQyJVzGbWEsjhN2jFQhggYj+QPlXn4uuQMX5IKy
 +dKYI5P3InqJz8gwHjUoL2Kgg3Qo0hQigoHbI8hOecO7u+gfYhNCQGYWhXlCTQMtLdeK
 28wly9j4bc7jbtMe4NGZGif3Nd8jffmWJHBJN0yj60MpM8/HLRNhho7zD0ujS4X2Hzu0
 a5dHC6MyeMXxVDDDVVyIc7Ky85mwD/rWs2Cdrd73RbpfT3/LvHNusSjxJt0GIFBxUfZp
 0+ammw5CztqqVFLk3pUWH4ZKDb96nv2nTCtFbjttS5Pj64MPwpwCyhyjZ7wmfdjVKekL lQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxrd7xjbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM3RJeW028973;
        Tue, 22 Nov 2022 03:40:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkagjyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLoAViyePN0c0PuSdXq+eVyujUrKtc+rblkOga6H1bpGK98vrPVO/QpiOrgDU3462bKMgUohqvaA0hW7TCXfLWvQIesN83noQDDmU1yABcZP9o9HatN1pzh27TYSR28ZR/rN2ihr7ajcBB2Cr3VXX2FPiz8QmCrNUfOWMI1MVMkz82D/F6QmRS74+wOt+NUXeKTqgpmBlQ5HVJk/hCsh6qimy4qNh4DK2olNdXSmslW+8f+6PCIWvu208RsCU5EHgQxWqslPI2gqhykM5STQaTu2zfGJeEkC5X7fTVu/cPEEtkfElXzIqvbI8OPJXqQ2h+RYoH2TDclf4/8hNA8ThQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4/vqbZpBcy1QdnRG1cuObCABYNrd0+t6/j6bN1Zx7A=;
 b=h9MPKdu876JU8NdPVyft7bOpi4rlO3MYe1TR8xHhUvp9msNQvsHGND2KL25nrHa5VzEU8rTB/N90VGYjzguD5rMbK0lFZEwupGOnSKfthC3ys3WaB8dHOOukkfU28rP4iOWFN7mLHprNBIdHqkYwkR79qTj+hY2VdbC4ubIVJeZqRMqn4qeR6nt4OsKu6Yfdo5IiLi+axxd0+5SIyppaKhGQxJvawpmgF2g2L4ipccmsxEUDA46+A66+XIjfhJzMYjhW29pixI/HheDVxgy00qYY39dxrGNVygs+SFTsfHGOWqE8I3mZe42zXCdLaptCHsRqWF40xq12DiaVzSj6ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4/vqbZpBcy1QdnRG1cuObCABYNrd0+t6/j6bN1Zx7A=;
 b=ct5EjqL9hwJfVa3O812VpUCYXLpg2JIa1MAfqH0EIaW/Sad8qHj7Av0PxYIiZnBu9QcuIms2xBOHra334donYlLlqg3ZLY60/DT/jnMSCyEyb9P+rS+tHZbAULzEON0AntJD6iRr/19nlTlf2P3mAjrLIZ+xkooE4gb7/OPEuss=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:31 -0600
Message-Id: <20221122033934.33797-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:610:cc::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: ac0f0756-2256-446f-1d5a-08dacc3b552c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAQfF9bKv5ZMhcuPOvLac4zLTYYFGaqtaOM32oE4uu7klvrb75W/JlQbj79rIlLaiYf2zdQ3nLZpZQcrOSQji67svKmTZsav/ymElx6Bd5UfRL1FCvoA6wtk6+tV8pX7EQduv9JBe6DSEGlmekGXt7UYr6PQ9+YSBtB9KQKfydstY3sXbhhiTAYFoBZk57p3DrDNb20/JgiFwolQddr+SVfhPyJpza9py9TjtiQihO0R/GIQG6bZZnuOP2BmudKgj9QpzTP0PqE7pPmG4KvMzsax3ixsQAt774IaXfKpUtfEHFPPPmEPkpw5dMjiDrUemUoTEdf8iUhx2T1RVwai1aCE8raHV59/AxdVLwmOLoD2O8gC729lVzYRGKO/u7D0GhbTTvRwN9bGoF5m6wMl82g7ug/KIzLgm5dk5r/kMsTKNOJ9f+63SDUsWobOMAcLtzEHdf3eAuWrzxfFXs+dluH/WshrtsFd5ucoUT/npxEjFnAOtHyyXoTvJShJ6HSSTiEShhOSDdEVh9fo7bysV4DmvmqegWzBmR0MtNPQOECQSr72S/P9dRTXR58h4LpyLIRsf67T+xDsvDvQo80Mv8FtE9DTlv77qBKH0G+AeZ8/74cUjDuKWK91WPL09iWY6us6whgi7D/zomW87dS1fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(4744005)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wsD1KMmSVa0k9mz5F1hizaMG3A/8M0Nc6b7D0gJBTJlg+AfBvviq+rvUocux?=
 =?us-ascii?Q?RsLB7x5AVxAcKI1dZLkHpRfObBAQBHjQwWCDDHXhQ+5lveTeFl6RN6BwEFBp?=
 =?us-ascii?Q?iGGqkiEaWYdfknzJBPdhs1qHzUyzYpI4kG+3pNnfQDS29sQylkRMAk3m8OHk?=
 =?us-ascii?Q?JZbiDU3v/aU1aterl6q8mLHQ51+FG5SB06/BzVC2snH1kGiGTifWe5jaUiyC?=
 =?us-ascii?Q?pLyDNVZOdMZKHZXI/juTnO6RlqqRp+XVX/cGOZl+U0uG5uPfyMPjY8E7q/Z/?=
 =?us-ascii?Q?giKYS3AoEOLRXfBe5pwZDgkyBMRcHREUy0jlWTdXnKHUNu/dcTBQpEpSV697?=
 =?us-ascii?Q?pZ1W92pxlMQ9M4Gr0ixB+52JMLspzmW4UcOwTTg6Zpiu8q2b1soZcRHQ7fMa?=
 =?us-ascii?Q?9omelige6/A7dJ7q2X8GWweTpXROJJ4WUDM1u2TjUYDm3B78QOHgNO+5Lq2k?=
 =?us-ascii?Q?ekatkjTUhWwJMLhVrJ6AFu+jiCqJMr4KK2XGlhem5i4/Hm8dwqTWGGOzMEAm?=
 =?us-ascii?Q?1etCNsS+8GgWmhxVWKiZhHIFX6U2Wvjr9j6MljhDP+zKnH5YM9m+xf1pThDw?=
 =?us-ascii?Q?r7A622VanflzQdUTzZYcMguayQmfvVNCZwSxSGyoKby2pLB/xWJrx0AlOfdi?=
 =?us-ascii?Q?SSS7Cv/6zcrseCBS26NTCrrYcxUHcm5pyHcwq7Ls1j9f5fKMk5C3DxshP2Jp?=
 =?us-ascii?Q?laixT0SleMIlvrGvporCI+R5O+e6M7or0fsjOTYXZUnXeQw9c7iNbS7ApNrf?=
 =?us-ascii?Q?aPTCijjHaEcSrKwD9S/bzwzehaGs54ZO+Pzrb6kRfN17lkaALURbXJIecQWC?=
 =?us-ascii?Q?3JlkXM1TYFf4P4M6zz8VTEncOLnFfjbRfqBMDlTdpyi6CBzJD2qG3kQr/a0t?=
 =?us-ascii?Q?6Z+AR7z3bqg1g75X8mU3i6euAMQxVE+Tc0jhxWKBysIguFDB83SfgIQ6yC5w?=
 =?us-ascii?Q?aCYJLj3ppTpZNpmG9CesOI5DKUN7JiL2XCpoWNUwhv2GqCSm9nUGsOMCYUM/?=
 =?us-ascii?Q?WYeLJ82j81U0I64u4DnIVuB2eASbySWO1kJKu4sRMVfLwnpqqFIGedBb64cK?=
 =?us-ascii?Q?A/oc/W2HYm6LKRxjTm7KBamXSYAEI1DmwJqBuyMcalv4LkP938QZYZn1xAR+?=
 =?us-ascii?Q?3tlRx35RlYOw+bgN5ufRvPyXB55BKyDRO13c7l/5GgX8gq9EL9bb5/vqGHLP?=
 =?us-ascii?Q?zKW1BbBwuwNYRBbj9fl4b7j+R7baNpw7+qYsuROTcFjiYQ4NT5SnmCQikvZt?=
 =?us-ascii?Q?/D3ZgLQOM/V8h1nFYAdAkd3moiXVg28ZUcVm5sjYVl4TMSbJgcGgek63VyZB?=
 =?us-ascii?Q?h7SdOFB+r+ibasQB51shf23+3bRIDTXaROH07mdrJsCmq/5BbYnfl4wdu7Fk?=
 =?us-ascii?Q?MQKlS3crSR/69V1VB76KNhJu/DasTWl1EeqOFYMo+lQI+gNqYG3NorDEi1fM?=
 =?us-ascii?Q?yOuLl8PGN081+vn5rzByftdIO+jL0lj3HE1PIB88rdgsIVt8MSYace+BcXpa?=
 =?us-ascii?Q?wA/HxkSj2CHvjpS8D5r+A7UmfSoLAoIbDHFMLIOGfCdPW0KmmBCPscPvliDU?=
 =?us-ascii?Q?xUN16RyRhKI248VR9SzkfKAH6fF5TI6/3jmPGqyOiAW9lX8OPz6n9ujv8a3S?=
 =?us-ascii?Q?iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SPudxWMU/jX1AzHCri/dNfy+T6GP3/rO6gLXYuQ6M0ufX4724Ys1Cxx3cKXIbfuuy2uLkMsTR1PzeQ6ijG8IKx9OlOlBKw1ONaSxUKLYWwVf82vm9jW3pDmQe/MvyxQet8tLpazRApr/p+oO0X/VCquTomcA5M9UcQ+7DxQNCMB3wDbYhT4pi0Uq0gaGGszHNLnuL5O1AsLcC4itaiQZLhyj8sfVjCoo3vIC7/pNXhlwgxkggDY2+Blg+b1ZXlm9Wl8J7jgtuNkFYzmix1G7cbHl12Iuoo1QzuPbL10UzG8TfWNqfrgSrj2bWhdugB80TO532d/dxPnb2K+5XX5RzaPdVpnUL7cClL3//UPzYzMRwgYR+9GGydZToiVUI44kHnoIN/VIYLYQfsIld1BKyazA3e5J2VJVUtg8QSIQwlCcLOrEBAz76IPF2InsD+3UkIoHaPVS5PFn8RHYL26JteKxBQAR8y7p5jpPzkSRab6tLdYVthc5DCOOg+7zMJlgxj8X4eOQk4xU7V+mO2evfi/IRPy44g8mWew7wMwRj/JFF0gQIoc9l7HDXBgxHmbEeLeJuQ3CAFSFiNwQRAndact3HMouDvGAfIjF2vADfIa+Zu9HN9+neXR/IDcIDcULUGcUuQngUmoWeefWuihn1KU0tdZir2l1w56PNDUTeju5oomaEKiCe6dc239omtW+cPIQKlB6OtZGKWoiTw2juBLpkLWZDYUB1BO/6+9s+Re89ncAs5rrqFj/z2UIAZDkAs9BeqZk1zJ0pQJm0f42qXqoiY9fQKhpTpTOHILdv1dLqF7zxgFZv+bIKkYts7whaxGs+GfxySH73QlVgVjGtt0iotM8fqbaDwo5cBMdYgpUFus9O/sqxoQRBqwgteHi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0f0756-2256-446f-1d5a-08dacc3b552c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:43.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qy+qs3vJCjClG7MwWJExKjLyodjK+UOfeNVcVLYkGtj4gmCwL9ZejxzVZyS8/xNOtsD/WxGw6EMeS1v2NgaRQKaWwZ1/qmn0Wcw84rahkjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
X-Proofpoint-GUID: moN1mb39dCxxXW78FYyHbvQ6-qz5Rirp
X-Proofpoint-ORIG-GUID: moN1mb39dCxxXW78FYyHbvQ6-qz5Rirp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert virtio_scsi to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d07d24c06b54..87751287d506 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,9 +347,9 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+		result = __scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
+					    inq_result, inquiry_len,
+					    SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
-- 
2.25.1

