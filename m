Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FCCC4321E
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 21:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiKOV3A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbiKOV2u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 16:28:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8195B261C;
        Tue, 15 Nov 2022 13:28:49 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFJMuBg003946;
        Tue, 15 Nov 2022 21:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=g0kR0Ufgfs4eSOdzlHFJFSMREOuMal8PMZZc412X9RE=;
 b=UJkyfzcSNY0+vI7NZaX9n75V/ecv+tC/xi8M1zvtbZalV55g89Ly/JIiYp+2TuuTtvhQ
 kXqC3Ym6qjQyOMJD1B6JjcCthnUqFbipldz1m0wncxh4HykQ0Pu6WOM7uWJO0E2YxAG0
 IVm1tvzhshUI1PJ4uSEztGECQTGi5gP0oEruX9vPY8LCI51DF04Y2GHUwxdsON5hIMun
 GaHaIoJRC/niLrO/unAGigT/MKhH5b9Zda9+5VT7BoX+EYvsb11g2e8H4Y3Bj1cAjCYo
 fXqfJOY7DCxWwQJv3Pya5aXCxqNVfye63FS5NRGX4NJ3I+XpxqqR0V1aSgU+xjveJG/f ug== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3n132gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AFK5VW0004724;
        Tue, 15 Nov 2022 21:28:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ku3k78736-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpMYSoBkbdPI0sZ+PLVmtwKDAfdOgPqtLmkAUc2W1A1Z04Oh7Yx9IrxRWtZtY4+siPri9QQ+1adGV7mle7tO0lqof09/BzKjpdHCbNYk89bNpjnZKcn4I5slGGQHZbHgP6ZAfoLiO96BrRke92PYax7qLxYLRUSaruY+LCRp7UUw9CcesD7W/jX1+iJjF7ZdHe8/sOg3OGdcKorg/u3Qq1Il8/0Zdd2Y6imd3FCSLxvW3DH8+80mAQq1GLHAO58eNNbt9YonfUH3g1UpZJmCvXhsDMXq5qsgbOCpB1PRs2Nn4dSo5PykpNfk6jbfteVibqWbEwSro95Sg0QJw1fEbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0kR0Ufgfs4eSOdzlHFJFSMREOuMal8PMZZc412X9RE=;
 b=QXnE5WxPF64p7ZtZOCte5vTFYn5ZWiLq7Cu0+2aUt89QUfuz2gM1Ub8d5iZose88bRq/OrfcV5CQ3tW9UJufGBRSTwIwyZA1kTugpQivdt44ofAn5of09qUtP9TyouvjC8fqRLt6XYRg6qy/Mn2eJKWSYzXIKWuME6pRICLlxJtLCVbcB351ilU6Vy/NX5XnM/urD5zsHcNMqcmAR5tvfkg7vxSPDWzzza0sgLLLPxdvb25Pi6+i7/+Cxei6r1ZuOzeVtH1Fi5RBvN+9XYSjx4wZAExlYyBiZ6LfcfusbhRQtjyNRifeNE/gahp7OiaNQYUlZNeAEBLdkcwq9zyGeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0kR0Ufgfs4eSOdzlHFJFSMREOuMal8PMZZc412X9RE=;
 b=OpOUDcwf7AReBPJNng5DU/WTGTK7HiqFJNYFc6p6BRq5e52bPqQK06m7nvzY6Ba449LmRkKmNwsSz8TpHquwsumskgVDy+SDyxENYzA+DxTqj9NW9Eb612/ImbJh8yM8+UYvmH+TmNuPl3amWITtreKsUPt9vxYldzmLqQsfmmc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5368.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 21:28:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 21:28:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 3/4] scsi: Convert SCSI errors to PR errors
Date:   Tue, 15 Nov 2022 15:28:24 -0600
Message-Id: <20221115212825.7945-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221115212825.7945-1-michael.christie@oracle.com>
References: <20221115212825.7945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:610:57::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c3cba00-6886-4e61-abc8-08dac7505851
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9Vyu1DHNb5bvIIcJP7jjzlI9AqfBIa3BR1vs8Lwa5O+6zqEs5Ou3lEG818EqwS5FW82pjLjhxG9aayVWNfgdkAZJCfok//18htP2twTQB9RPLlzSeBNQeKlwoxaJL8eVS4HbSP6/35MgDD3TMQQq/PYl3aXu/CvqQTvqB2z6iiRzE8Nt2ecJqz8sfvW9Aif3hLN01Hbc4NxSrk4nSnRqDg7nZ/UAbi5kot+fCYVF1q9bDqmlBchEPlNZ3IPnL3xiIn/Iuoia5FWxS9NGSUSB2tendt//s87Vy/P2eBrgpFeYF94k69SRECkJHUhNUu6fhXKhSXauN93mD8xqvFtKYyt50Dajv7ydQRutUPlF6+i64hLU/LhnMwOuXpsUqSE4I/VoUeKastoFYVHA7+QvuigwDoSfcI6P2rjd0pPRjcypKGMQ1VA9vgQ2fljfzOnY1EECLeB5vY3rpX7nDaMAGwfyh/t4Y97DaN+FarzX300R7NNCkZ5szZQ+xHrJ1TaTi3u1w5wf2ys/jksmbrmPayY9F+dmqiO01fUf+LLEBbizFVubZCNakpZhud2hw9q1uvcjugExWMt/bPdJVACVvxOTcJ9tWwfOHCYit7vMcGhcyXh1NQM8U6lwFAg2X2akbShFScj9YCcCi+OkjLlCEmCX9eVBGuVDTKPmDw+6SlDD7NIB6qQKdeKydbpriR7kAyJT4h0MqqvxvdajF3S3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(1076003)(36756003)(83380400001)(6486002)(478600001)(6512007)(6666004)(2616005)(107886003)(6506007)(86362001)(26005)(186003)(38100700002)(8936002)(41300700001)(2906002)(5660300002)(316002)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ORkozTjY4oyGrmQSSC2EVEUm6JejVYvhaZ74u/TBLnqUzDMyj9HlqiziJCTq?=
 =?us-ascii?Q?cWeFA56vg6ttRK83dqXaniydWV1aAnRxJAM+/eoxdJIahGPLgUHZVye95OJP?=
 =?us-ascii?Q?5U92g1b0flUrkrxsCqHPXxZCPZVM4Sl7gfEiF0IsiEsW3nkLs6z3MsRZLcOq?=
 =?us-ascii?Q?dIl4IGlSe+WVbhXEzid/y1f8QimjZ7eEbjhU1qmgfdeOBns6CdD6ifkdLCuh?=
 =?us-ascii?Q?BRID6Qz6UBWpgxi6IKUFiGCSvTp/pKEyhQEDuWNyI9a2smODz0kpomlMJ8Yq?=
 =?us-ascii?Q?RqtE8L5r6LGX+mb9miwsJ7LQGmhdRblU/B84mVCX/Vc9rq2xwaAlObsZstwa?=
 =?us-ascii?Q?FMbflBJpjRT6RcINY0Tw2BM/yXYldZZYGqwz3perjJotebym1r427mNBYhm+?=
 =?us-ascii?Q?T3tZxqeUp1TPTp5UMT0cewGuUnasW55KVhQXnrOwu3G7WsC8S4zt8CXwq6ui?=
 =?us-ascii?Q?dLvM20/OiU3her5zRAoPL13QpQYNA4qS52ynGf6qk5aGtQp08rYDTiwdSbE8?=
 =?us-ascii?Q?wKKIZiDxkilIkDEODDTLWoDfJ40vy3Nrs6rqWH9Hjy5DXJOWjS7OGJtqfDP9?=
 =?us-ascii?Q?t/si4rNbTT8MpmeUJiAfkKq3sLP24hraPQvqQpdgBu2/rt52LT0e3gh2ZGq2?=
 =?us-ascii?Q?EgQ3sE0YpeAe4bRLMP/QvAb7wF0fUKt9ds2zhkdPEbHvenaiGWhqn/1KdRkk?=
 =?us-ascii?Q?yHarzZTJK6KSlymf+W0MfpO+0QBZJZhl70l40u8d4koZqe41QK2FloY4UQ2J?=
 =?us-ascii?Q?FQlW1Wczs6WBv0q2xHshi40kk4Qg2NXozQISIBjUCm4vS5OVhcj9lE5G+wxb?=
 =?us-ascii?Q?36t0nBmMocyJT9DLAB22CWXsV67mfmPVByUVyf/qvbf+M4Ucs/vMTJSVslpM?=
 =?us-ascii?Q?Ev6Q5Bo4AFDStITLSj6Hu6uGdImcg3p0TF8rYTcmSBpSC1bHcbTru3nztsMA?=
 =?us-ascii?Q?2l0Thxr+UDRLZsfcn/XosJ50z7zyihCfTietxVxorzDB+iQ7H2H3hb5EByjT?=
 =?us-ascii?Q?t7s9RRCD2RpEkmUXsQjfEih3fwfEhjflP8mes+IdBhmGHn+VxKoPpaYOxcyn?=
 =?us-ascii?Q?EGmgsdyzHVbz/xsACw+2eHJ/NVcFxGyf1edsMvP6dIFCYoHy1sDSmQ4xf7gf?=
 =?us-ascii?Q?n0zMCr2W2ssnbf6jmDG4conQ3QZ2JImHfFdtsOW2LC0T7ltbGvYeMdZOQkrB?=
 =?us-ascii?Q?TrTqCbrK+fyWp2UUCR66ZsuHzaz7wh1JIKmKPiayNuNcsA9Tdd6/v9K+430c?=
 =?us-ascii?Q?F6uH1HKId88weg3PD6AT2TYJWrftU6HEzn9BYhnB8VZdUNwimDIVMPsA9fIu?=
 =?us-ascii?Q?zCvIW5jBpLG1jE9bRxlzyFwvIsrSSp61U3mksgM3X/9lvqFy+6hK6k1sFenH?=
 =?us-ascii?Q?8Cc/6IVSllC1cCu6LrZjpydXfqlH/+xebfsoI+Bbsxig0hIWpJn+9VcNErXk?=
 =?us-ascii?Q?RQNEkRNfkEz9UXzzCFhiL772yvls1o3Pp0rbqF6sU+3trugaMFBohuHpD08F?=
 =?us-ascii?Q?QcfreRBo0gRge8v5WI1soreHuxvTg1+I0nUHbV8c1odtxBKl6zq26WiSHOCj?=
 =?us-ascii?Q?CfknA5Dk7LfDjgtKO//Fs2lNjAizuCxEfR5ddFaV9A4gd9K9k7cKqMI0L7Iz?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?mJ3HvMo4UJIb8zTvvZb934N8ukQNoVoLNemav/iHcVcmah4ZzRbpSTywWgnb?=
 =?us-ascii?Q?IjD+eDxp68KCWpzhfwl+hSVrNHx9gu7FV8p6T0EggUSodIjMi9Ax7rclxPLk?=
 =?us-ascii?Q?0jVCqYKQlqvyffVzOkR7f2tAELcCgwZJHg7q8XmopAFoZP2mYBr+tfvZgN5K?=
 =?us-ascii?Q?BanwC6H4+o9N+5JZh/5XXyc2u/NnjegmTcsPBOxXJ78wwJAHnxB3um3bW5/5?=
 =?us-ascii?Q?knKmvmSdmV2nw0LXVL0hLwKwt/tXbxSvnJZCHRqNun69GQQNihoIWZjykmHx?=
 =?us-ascii?Q?4Kcs3ve2Kl1bNnpVeecEeol2mxGkXCg7jbJhLHbUgr0ac0+Qw5ArhKSSJ4dM?=
 =?us-ascii?Q?6Dx4KOlXcYJXBOQkk7E6Fri79rUfFu/gPw0kmcGU6h25mCfLZeEi5SOgc6y/?=
 =?us-ascii?Q?WvwcZMuUIZzsxSPAkRuIcRgJE8MKQ8SP5J59wer0WGijXse+FfoseNFjGikE?=
 =?us-ascii?Q?XILzfFhtNGWtIB9SHNXhzRnzKHTEkMYbHNWOWkzoYCOcBmFUA8iQGcOxsYv6?=
 =?us-ascii?Q?UPg+88+kgICzR1mg0c3ps2wfh13mPMFsu8Otw8dHkDsVzxh49umgkNquxw8q?=
 =?us-ascii?Q?NOtOqvVJ4eUF/bsGA1SyJmjV7eBRbtkKjQISdtQ2JiE+4/C27esgL8G1lQTx?=
 =?us-ascii?Q?h16UftPJ+oUraiHRwxQ3PmxiXNHkLDil64Tgi85GGf6XsulUOqQWOqu2LYnc?=
 =?us-ascii?Q?cwV5k4+QCM/3f9ldxbfrOLrPYvXoA7PQQSa1XlCe4kUtRGL9D83KNd0+wNj+?=
 =?us-ascii?Q?szCm78XbaMhLVuK2umSC280oE0/aUJJmBpxFET2JOldjgNbHuuZM/xXTCGAV?=
 =?us-ascii?Q?rhdTKEzvhBCNH/hbnD093WOnmf0bFet9y+7DTyS7ItPyZqAa+meu9UwhldGv?=
 =?us-ascii?Q?38wxIRAug4Ua3JiDDD3CS4T6I0zU6parwzZw30rgY1TaXyARRMFa4J4ZR0Kv?=
 =?us-ascii?Q?meD+51G8K1cN179lC8jOyxulH4NYOtvzHzpG6PE341Pc1tNxfrcHN/IUT4y4?=
 =?us-ascii?Q?e1gD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3cba00-6886-4e61-abc8-08dac7505851
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 21:28:32.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8yAhq5wyDQ2lbgkuOc0zto9ztAI+5Vg7Oefg7bjFVOW8hlXaiRKaR3TleAtdc/qCrlTtdRrzlcdAQlaURNODl67EpmxRkIsFx+AHBgkRUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211150146
X-Proofpoint-GUID: pnUl4Dz09b955ulfrHdYM289aH_pSYtN
X-Proofpoint-ORIG-GUID: pnUl4Dz09b955ulfrHdYM289aH_pSYtN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This converts the SCSI errors we commonly see during PR handling to PR_STS
errors or -Exyz errors. pr_ops callers can then handle scsi and nvme errors
without knowing the device types.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c   | 42 +++++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi.h |  1 +
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba055021..00cc17fe769b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1701,6 +1701,43 @@ static char sd_pr_type(enum pr_type type)
 	}
 };
 
+static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
+{
+	int err = PR_STS_IOERR;
+
+	switch host_byte(result) {
+	case DID_TRANSPORT_MARGINAL:
+	case DID_TRANSPORT_DISRUPTED:
+	case DID_BUS_BUSY:
+		err = PR_STS_RETRY_PATH_FAILURE;
+		goto done;
+	case DID_NO_CONNECT:
+		err = PR_STS_PATH_FAILED;
+		goto done;
+	case DID_TRANSPORT_FAILFAST:
+		err = PR_STS_PATH_FAST_FAILED;
+		goto done;
+	}
+
+	switch (status_byte(result)) {
+	case SAM_STAT_RESERVATION_CONFLICT:
+		err = PR_STS_RESERVATION_CONFLICT;
+		goto done;
+	case SAM_STAT_CHECK_CONDITION:
+		if (!scsi_sense_valid(sshdr))
+			goto done;
+
+		if (sshdr->sense_key == ILLEGAL_REQUEST &&
+		    (sshdr->asc == 0x26 || sshdr->asc == 0x24)) {
+			err = -EINVAL;
+			goto done;
+		}
+	}
+
+done:
+	return err;
+}
+
 static int sd_pr_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1729,7 +1766,10 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
-	return result;
+	if (result <= 0)
+		return result;
+
+	return sd_scsi_to_pr_err(&sshdr, result);
 }
 
 static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 3e46859774c8..ec093594ba53 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -121,6 +121,7 @@ enum scsi_disposition {
  *      msg_byte    (unused)
  *      host_byte   = set by low-level driver to indicate status.
  */
+#define status_byte(result) (result & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
-- 
2.25.1

