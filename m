Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C139FC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 996E964E6B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBLH2W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:28:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37214 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhBLH1w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7R3Sl143266;
        Fri, 12 Feb 2021 07:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yirfLel8afeEiDUxMQrMnDE/UbNIEYIy+RRSd7s9DC8=;
 b=hiY8cdxVJRQzKa2zHsRjgP3PE6wqIrX8a2G1mwmuvaOjvf/qWzlvbiNcWXNi2Uw6VTn9
 gUr4sPrUNi3ucR0+tS403AM+5tRfhwfllIRP/9DWindCvA/ic5VJJ5J99CK8Kr8QfoMp
 ScKItoIrLejBho1jjwYza6u6VilfJkmr8TPiEqLhg0WubC5RhfjH1lhcU4pZniHvuJJv
 BFgtpXGimdEb11RjOFVJ7d1shJq8iuENne/+vDISVKgyt/Fsuy77zzDfcyuUQqsR8a1o
 C6XujXeWvsM2ofn353j8/6lUzdP3PGeB/OsjUxDSpe+XDjMxX65PYgoZvniORvnCeazf Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36m4uq0qmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7OnuR012963;
        Fri, 12 Feb 2021 07:27:02 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3020.oracle.com with ESMTP id 36j4vvcbub-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcus7bVlUnA+IleGG9IPgQwJsOwg/oiP5aHIogAVGlEU4r6zoyokVLjXdztUKfpCtkNLmjsULyRNYoOa9wD9RRLRDNb2KFFN86iGl6NXsJRvGPYfqu2via9XJo3Y2lWO82DPq2eN51NZqy5fOrnnRjB0Ekuh4DoKGDnslrTMISLHjY3C75EkZsHHfLRj4dEfSV1pPFMCjlyN9Jof06CGb833BzVa7UhcLLHfn3dMJVaccTSHwroaQDzzFr815JY66rDyd/Kf0M35vkrsNg/yCBhgX3pN1CWULpFc0U6fxuSF8+jLveLUrbA4I4otZfcLDQ90kKcV7G90sBkCvKM70A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yirfLel8afeEiDUxMQrMnDE/UbNIEYIy+RRSd7s9DC8=;
 b=clhxuleQkk3NWje5p59emzAMMxBbE+QWlZhSoKY8sDQ7W22U8twwAU9t/1zEcAT+6SguzrVaBxPze4rct7SsNiVmWEpD0HG97aNK5zhHAwhsCJ0DoiGqUgE1R5xlSWhXrGjWzf7CSmvi047trY7wd6sFjyjktTZw0Dl9gbYtg7ZdZ+8nZIkfVw64zi+UUMGA38Hy01d+WPru+1+NjLl/uSa05HzDsekIsuMXqYxG75maPwBbSu1xREYiaOW4ZteIEF47AP0fwfWP19MsoG81ICzhBqrrkPxuYQE25m9jCQ31YBahrV0Qg+bEIeKh0+uf6inczGbtXSh/p6+9IP6TJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yirfLel8afeEiDUxMQrMnDE/UbNIEYIy+RRSd7s9DC8=;
 b=ePxsnsq3NjpWim66/LGrEeVa5Jy1dJJ4EFyXfKzjD1JNVnB0wW5CTnCf1ZAd8YjqILwHThuwavh315PGmZlgcnzWqhBoUmfxGRSGLSaaaENF1SgWEXcPtKxeFi87A/zxH4rMCz2Wyld/WvRcDMUbowis8h73g0ccgZk5pLDQGjs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:01 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/25] tcm_loop: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:25 -0600
Message-Id: <20210212072642.17520-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 223e022e-e910-47e0-d094-08d8cf279679
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254C51386872FF841B623ACF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mct6zitxjeSnb06h0sZkvXmC4ZEtW9xl/rtXZoXDp6Dyw4RIdBWJaiV5u0AAGh20a4GNizRglYl/CCfthsSvtnl0fbs8gHAjUhXKbNFe5pJwBEe1QkB/CT3MljX1TSMeK4mJm4mlFD7GWVddfIcOmX/Z/63uK0ZLp//va/Rs2JxOjs8Nn55Jh44eL+ZDyKjgqiEBxkm5xfLkp2PoMT6Zl6A0t1hyaMBk+VwG0ufeqDJvniaN9Sg4wlTrage8wRgvUef5P062YSwS0v0Swt80gplnK0LEnx8KXm9X74KEH2liHdYjR+UmXz7vm4Dh1kkCQKfoK4PQBIU83KIY+xIGkXLyz8ippFtmk3Z39tX7+FnwyNQTfbCi9uMT8hc9QPS5QLDfkcwA+UoGMDUS8MWul5064iOlJqXSmXU9ERNAmv1P6mrful+ebx0BAuAAQRkLqWLykUDu3vqVng2SQnxv4qRdTgmjA097jAwGgdtLnSEpd4GjD+uRBgBeKcRAGjJMLK5k8sfMA8kq5QZbAEWWrzpLZ8efeWrR7p2w27LC15JrlhptAMaQmCpBTzaQR2jpJV6ICXpfR+aICqTDN0uGnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PG3IGTkO13Q743j1C1DPgNP2zy80lk437T+vWVyxgdoz7doU/wL86n5n1Pgv?=
 =?us-ascii?Q?5gZOjacJ0TBqgE30Z7XAo0JAOxqaP1JwfeiXdsrvltV7HBysoa1XCNHgtwSE?=
 =?us-ascii?Q?AhThL3To/tlEVG7OnVD6A710XLJdYws/1IjU9YWyOMRzAfrgfEvpgnvN5MJj?=
 =?us-ascii?Q?9IWJFDl/OWc8J6r9YK4Qw4RL288T7EiJTvdLe+dEtQRanLGeqauIy4FDAtdD?=
 =?us-ascii?Q?rNQ7SUVlMFaygtcL+EGXm49fT8yaZdtVS+1ofRd5OO97ogUyA6QvkXI2JDhQ?=
 =?us-ascii?Q?ULtRQ7TNDQvoviTX7VyZwyA/EwNoHj45nampxbC2z0qklaHONFk/SYMNhpSC?=
 =?us-ascii?Q?lg0Sh47NcvLlkNfglsM/dpReToDKdp2DmpGW//Gf7nd6VN1I5vBLhqRxTXdm?=
 =?us-ascii?Q?CVbkwC3cLo52V/aGfrK4Qsi+9w1mmPxFIdvrdnRAGkUFWVROolItcOlgtsvJ?=
 =?us-ascii?Q?Lr9/XjagWbEKOcPFHO29BUBx4wT5tUai4LmUPEwi+Mv95EpUT0HUeCISSg/N?=
 =?us-ascii?Q?eWR0GhKmcsMTJziey3FfvKeYa1XqC6DDlX/rSa5UQO5/1a97bcqOF7oKDpNL?=
 =?us-ascii?Q?WrBLgSRZnoEJz1DwMPrTevL7yTql8PiM+DuGv7zwF+onkyIIKT2HPm3Y5mVT?=
 =?us-ascii?Q?9JnybH2vDBUOlE9twA29PjbSJsyIPF0u+wuX+OWdqoBe7LvYRaRh4AAsgIXz?=
 =?us-ascii?Q?n7Wdu38bdLxXj8HKwhwwJwMqTkL5qQ5tDvqgWNbH23FDjgDFLaSxbGC8AZDF?=
 =?us-ascii?Q?8i5sAcWWzhzdYpAY9RsfXdi5L5AZ9n1FHg5XKzazu020OGCyepfQ8tc7oWOB?=
 =?us-ascii?Q?305x8Wn/etD6JibShDMgNxvLYJRmTaM1d9b7tn3kjDE3L4prZcNJW7iHKpFZ?=
 =?us-ascii?Q?rrspdVaxfUM9YQNig88PNERQ+htcQ39ylSo2xyOADCmqAtUUWVzY0a/PNqLP?=
 =?us-ascii?Q?PxPM3poIgBnqsRrLUsDZ9LGrLpuuFgfCBoSOG5o2/6XEOLsBc0QdDj/nYQA5?=
 =?us-ascii?Q?RrppLsumprHa+t7dsbKYiLTytXWi0g3l6duxubOR75uzNu9tqGojU8WtVVkC?=
 =?us-ascii?Q?EUHDsPR89Q7aq2qno381a8iX7lJ7zIjODPc1bww2BXtOf0PRqIDQBclz/7+O?=
 =?us-ascii?Q?jqwpQGvHPAL8iWXGtB7VvzFlX0k0lILs9hGmmA+kdKDUQv2ZraIXtnXpebor?=
 =?us-ascii?Q?EMxkcsadVqmD1ayPB/0vZx+N5J4MOS6DRstv1q+bmBniuMGM4/75MsXEA2fQ?=
 =?us-ascii?Q?ey8iQTpAZzgi8JoGz/1h/MprWL+kBm4ElfmF036CKh/YW6upkLEUfL36glJQ?=
 =?us-ascii?Q?PizujbD/+CKj/82wpu8WKsIg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223e022e-e910-47e0-d094-08d8cf279679
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:01.0673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27Vji8ppTCy40j7eReYr2Dlw8RSICByOvFxfw3DPxt4a7xVPNHUWnlxE9DH2Ew3zHg1yOUVuyT6b/CNs3mg/QSiEaVhcL+7fY16wZSixvoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert loop to
the new submission API.

Even though loop does its own shutdown sync, this has loop use
target_init_cmd/target_submit_prep/target_submit since it
needed to map sgls and in the next patches it will use the
API to use LIO's workqueue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/loopback/tcm_loop.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index badba437e5f9..461f4125fcab 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -113,7 +113,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	struct tcm_loop_tpg *tl_tpg;
 	struct scatterlist *sgl_bidi = NULL;
 	u32 sgl_bidi_count = 0, transfer_length;
-	int rc;
 
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
@@ -151,17 +150,16 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	}
 
 	se_cmd->tag = tl_cmd->sc_cmd_tag;
-	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
-			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			transfer_length, TCM_SIMPLE_TAG,
-			sc->sc_data_direction, 0,
-			scsi_sglist(sc), scsi_sg_count(sc),
-			sgl_bidi, sgl_bidi_count,
-			scsi_prot_sglist(sc), scsi_prot_sg_count(sc));
-	if (rc < 0) {
-		set_host_byte(sc, DID_NO_CONNECT);
-		goto out_done;
-	}
+	target_init_cmd(se_cmd, tl_nexus->se_sess, &tl_cmd->tl_sense_buf[0],
+			tl_cmd->sc->device->lun, transfer_length,
+			TCM_SIMPLE_TAG, sc->sc_data_direction, 0);
+
+	if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
+			       scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
+			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc)))
+		return;
+
+	target_submit(se_cmd);
 	return;
 
 out_done:
-- 
2.25.1

