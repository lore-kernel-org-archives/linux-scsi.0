Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23DCC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0EB61360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbhDCXYP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44904 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236935AbhDCXYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJGSb096803;
        Sat, 3 Apr 2021 23:23:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=HeoEFlt/87SiPD0/W3MJqIkj+3iiN5tWWFaeyfP/AFk=;
 b=fJ2/Qh/JsUFf9VJ5B9BbB0q3W8PWkfNVxcn5+pF7V0+HdspVL+m2RoD3KmTZfJEsnl3h
 q3JWjjvgGPCvi3Zf1eF4PPIBcDWyIAWzzXIUJ47yTZmHq3nYD0a4t8QF7Z8diIKri9QB
 rd2MTc54jkx1o2vQUArf+EQOS/uqnmhwiEHaEfSfvDu6xi0hOab0U1AfbPFRGvDAmyXh
 PsTycyVaU0Ps2sb7aWHrYuTKSFG0VV2oVLeiW36AjWgeDTZh4dNgL1Apm99MFwKH64li
 iWUgHZ+sFELrzJLlYGYj8wxXyLYaifJ+lrgn4SAqo80I82S9Gc3TKKrybI91841AiB25 PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL7ld130247;
        Sat, 3 Apr 2021 23:23:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 37pg61hu6n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=at3hAHJr1X0m0FgMgyZWckfMzV9sEchsvNFONFuYMDPTW34PdSS7vIyYWl27GssVahaywFW8ul6sgKPOKHAzv71E1220HKxEtd9CttPvxcjk6N4ZZOwyhfg4a0QDxiS02er//3eu9OhG8RsKBZ9S2iizs2db3qKR1gkrQBTKK9GHCgyBYgeAi5VbXUSI8BwF96QLCcjlbrWW7O8nObg9/HUYiFroD8xpFh22pSbfzEg90sTgcQuT81ap6zz3/1ftAuRPo/sEMlQTa/k1icHwqD/9V+9NRSHf8cYEBayxnpmV6CMsau2O5dgYJEE8iuQBtBLcMCEvzoWbzi4OEBdWkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeoEFlt/87SiPD0/W3MJqIkj+3iiN5tWWFaeyfP/AFk=;
 b=LeYzzXXv18QkjhxIovxLGKKz9qfyBqfjxGDHWLMs5DiHKW9M43h2tE8IGohifgyPdEHWCW3dqOb9CEwDzNgrnQiiN0LX06JyF4+IqdJv0MFsKi19SGYdC1ngRm5iWrV9EfvZ5PlAjKSHjIU6xvO1pZNGJ3Znq+Id7bNkfVWsPj4dHeFcGppdtaVEkgIM8nSk2ZTbskpw0yC25R3HOyUpDxGKThclZEzYIDSN+aExG1xHM7xWkKpohqQUQ/ND6qdHt3Wf1FVRSYiqdOKE+A41Y1cbkRpFSkZa7vKIOhs1pxbcZgl0wEvooQm+22GmOYgh7XN6oLVW/62M/8FFB1LljA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeoEFlt/87SiPD0/W3MJqIkj+3iiN5tWWFaeyfP/AFk=;
 b=b5E2nTCIRfjr/9VCVW84pbp3KNPlaH7MvOc10XWj3kRsC/yAouKAXFNwZxP0Xh8FSiPSwh3wg5QttXmyKMvGieK0m6tQjwQ9j/Hix2OueZ57ermlOO9mOcQYQ1YAurZ8/9G7Rzw0FTyj6VSqIxYzdh+aZIbit9O8h01Bn9lBM54=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3368.namprd10.prod.outlook.com (2603:10b6:a03:150::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Sat, 3 Apr
 2021 23:23:45 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/40] scsi: iscsi: fix shost->max_id use
Date:   Sat,  3 Apr 2021 18:22:54 -0500
Message-Id: <20210403232333.212927-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95b383db-f3f5-4f7d-e37e-08d8f6f786c8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3368738E47D7007732A98118F1799@BYAPR10MB3368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCkESXYw1JLX07gkp1KFhez1MwAJONDtLvxr3aBXYhMGGDXdkhngUoCJcWGK5DS4JNn7Y+rk+jg5Us9NZH4gpoiDK/mnGtDRdwxp3vBw4kFLKzNR8jrAMmKm0u/SUSYeCjoldjIhUJau9TwGFhGmqDMPMTXhFmhtZH1I5kIWFjkMUIC3Y/tZR7nvfUTnZbOLRHK1Zu6rmUVBe/li21sxb5CoyXeZ0jSAGy1bmQkfUWKotLSnhTvL+hqWbxiXCEcTqJOfPniV6Wtk7Kpk9YwrXASgkQ0ZXIUIMH2zUHwBaaGZw3QT3yW1vhOh2GOpnkMrC72+lkgOirBvOTieGuW7q3y1PGlAQrWV+fdn3JchF884qFLKZ39+Sm2CAFbPjM0/QIHdu0Wr3rv9go1TC8W309GDHdSgrzvhJpRApA+3RvZqDtSYrwfJ4nqZefaGZF6PK+1AJcs3zcOXzvhYlsLmk9ZQJPmsGBZ+jfSZdgKlrYK4LZ9AAL21RWL0IlAzyDqIRQeDso7iHgC1hIDjMFOwkUJc42PFNMlAZ+tiHmVpO48aCMSD8C+TvvExMskt7ce+5aUnxbmfbWx5C9a5xVvAatwcQDMveTGWOa4EQQKbUMHO6QjHQpHW0eSNxUXUSBY0O03MIEK706UzqRkKoQQb7MnxY6TB0Eh64QT/A/6s6vFvc3+7+fhIIivoYfK4o+aoxpTJaSNc7rhmlbg2zQeP3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(956004)(478600001)(6666004)(921005)(4326008)(66946007)(2616005)(83380400001)(107886003)(8676002)(26005)(52116002)(8936002)(86362001)(38100700001)(16526019)(316002)(5660300002)(36756003)(186003)(66476007)(6506007)(6512007)(2906002)(6486002)(1076003)(7416002)(69590400012)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VBEs3i/jqXDguz9osuoKyD+LlXteM5gfHmjcQN+IqC8RsaNaMUC9cWkDkghy?=
 =?us-ascii?Q?0u4qjLZvVtkdHzjTu8Kv+PS1yQdxMLv/AYa9ueo/UHCTbBIK+vvvW3ln29Zl?=
 =?us-ascii?Q?FbRV+ZzzWxrQFx7Hf0QaDo3ZATg2aioB5KavCkQyu8Eu1ivTEe9cbTNKETs/?=
 =?us-ascii?Q?XthSsh3a+FkGqLvHSU+qDW19KTVjd4+Oy/GjBu3qEHelDAmdQNJgSN26p0Kw?=
 =?us-ascii?Q?3Nyc08PRKGStc9nbu8AJuTrwPDd7ZEBiEqvgwqMwHrytMHwV4OuqeVYIDLsz?=
 =?us-ascii?Q?IVrmMbgnwEeHHp9t3M43uAYq2N23DuerXYlIP04BUbSPc8DJ2jzywjuknVta?=
 =?us-ascii?Q?4vpDz+6ejOf1OnuQH7iaFdd3grj/1dTSQyT1ib+mVrYf9fVe4NeWRQde9DNk?=
 =?us-ascii?Q?kLw3ohZ/rKPhtCCm1/tsMXgwoKNNXqAN3tDox0YRGdSWV/wHj/lHytRHUma1?=
 =?us-ascii?Q?OodzlfkufWNjrLlkPhn3XsfEm5yAKthyvRqW1Y3h5XAIJyziwWPMNdNrh7co?=
 =?us-ascii?Q?z0NG1eY6qHzURc3B86byR370bKfZzb+1NeEBqiKvpgflKsId1MswrZEhDdZ/?=
 =?us-ascii?Q?oiDd1w9DDW2BL1+8j+rLsaKnKpdGSls2/oNaEvINKMoqmCVoVOqbdo8Alisv?=
 =?us-ascii?Q?FHlZE8XcFDnw0xBHjz53qOSHFdIV79xQOtvK8Umtrl9FpzJoWCyCNoGVvBZ4?=
 =?us-ascii?Q?xFV0Tip2mquH71GFSIITNQ4ZK759P2kYSdSPyN8Z8DTYHEYMN+n74ihm1CEJ?=
 =?us-ascii?Q?J4q3497Y14IIgnMd5yTjVTU0GQjfs76bqQ++5ElPZ074NCRUtRamIYWFjlsj?=
 =?us-ascii?Q?tUTYq6BxFXvo7da8SSojg+jIcpMbJx1Rf7BWqJV8dze2p+18CE2kPsefN0u4?=
 =?us-ascii?Q?fqGb0DbsioJm35foBqE4u6yX1iLI9G+iWUR3m+2cenCxPrNGun638SWADkub?=
 =?us-ascii?Q?8hGPxvBeYkdV/ILWXeY1Lq/XxABn5wi1tiy+UQX9+VyZGUwh2rRobvq6pXAq?=
 =?us-ascii?Q?GM7Gwfmj2AhQXoYUtEVwUdVG1icXgalAGgrcAzdJNWWmLvJD/WyfYvPlDPdG?=
 =?us-ascii?Q?vH/ArYoLHvAOZ8Jb6XRZQ9caclDDR6M+pW+QE6s3ygXS0hlhfXapN93lhYzF?=
 =?us-ascii?Q?COb2Fvz+Wb2fUHX3iAXDRH4d/FkNw+j7WFbigKoeHIEH5Dxv5+wwtTWtalop?=
 =?us-ascii?Q?bbfFPFXEfQzSQhN4QTZ82UOL5BaSMCMnFCR+ZmvQOdi2rOnyVx/DUSvoPuCL?=
 =?us-ascii?Q?r3QQGzf2D+7Rn+s9xFu9xqFyKDphXlfNgm6erRJXogTUrobGGTK6nDjONY/g?=
 =?us-ascii?Q?ChajhjoS88m1AiQeXpYYTWlU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b383db-f3f5-4f7d-e37e-08d8f6f786c8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:45.6110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +GUwg7VIZxuawHFjiGPNCrJmOztLtGWTiZwqmPQVvis4fjxfnTLnC/c7vWWzaxzjJuy7kx9Hk6RsP0aMLN0HlhzztbzjuqXL2SBKRbGPMWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3368
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: triwN_M6naVX0FJSk5l6Lcctw2wghGfg
X-Proofpoint-ORIG-GUID: triwN_M6naVX0FJSk5l6Lcctw2wghGfg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsi offload drivers are setting the shost->max_id to the max number
of sessions they support. The problem is that max_id is not the max number
of targets but the highest identifier the targets can have. To use it to
limit the number of targets we need to set it to max sessions - 1, or we
can end up with a session we might not have preallocated resources for.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c  | 4 ++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c    | 4 ++--
 drivers/scsi/qedi/qedi_main.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 90fcddb76f46..56bd4441a789 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -416,7 +416,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 			"beiscsi_hba_alloc - iscsi_host_alloc failed\n");
 		return NULL;
 	}
-	shost->max_id = BE2_MAX_SESSIONS;
+	shost->max_id = BE2_MAX_SESSIONS - 1;
 	shost->max_channel = 0;
 	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
 	shost->max_lun = BEISCSI_NUM_MAX_LUN;
@@ -5318,7 +5318,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 	/* Re-enable UER. If different TPE occurs then it is recoverable. */
 	beiscsi_set_uer_feature(phba);
 
-	phba->shost->max_id = phba->params.cxns_per_ctrl;
+	phba->shost->max_id = phba->params.cxns_per_ctrl - 1;
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1e6d8f62ea3c..37f5b719050e 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -791,7 +791,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 		return NULL;
 	shost->dma_boundary = cnic->pcidev->dma_mask;
 	shost->transportt = bnx2i_scsi_xport_template;
-	shost->max_id = ISCSI_MAX_CONNS_PER_HBA;
+	shost->max_id = ISCSI_MAX_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = 512;
 	shost->max_cmd_len = 16;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..ecb134b4699f 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -337,7 +337,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
 
 int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
-		unsigned int max_id, struct scsi_host_template *sht,
+		unsigned int max_conns, struct scsi_host_template *sht,
 		struct scsi_transport_template *stt)
 {
 	struct cxgbi_hba *chba;
@@ -357,7 +357,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
 
 		shost->transportt = stt;
 		shost->max_lun = max_lun;
-		shost->max_id = max_id;
+		shost->max_id = max_conns - 1;
 		shost->max_channel = 0;
 		shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 47ad64b06623..0aa0061dad40 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -642,7 +642,7 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
 		goto exit_setup_shost;
 	}
 
-	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA;
+	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = ~0;
 	shost->max_cmd_len = 16;
-- 
2.25.1

