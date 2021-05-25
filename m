Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0ED4C47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E2C61417
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhEYSUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbhEYSUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFOLU121981;
        Tue, 25 May 2021 18:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=iA6uNZnaiKkDglyIdBApqOkWpWD0i1ZY/hgDyC5w8j4=;
 b=NISloknX4CYlMLRipH5tzczRDVZVn4mFE/3J/4HuTmV/tToXucXTcz3PE6RAuCzUb1nV
 qJMf4v8vhOAbdVtRYjFnUqr/Ik/C1HsYA2KyX9PPMxPIDx5BbgDcL/ZjUSLPS91ImOA2
 uZE92I/57d8RWWw7m/DloriC09BwittQRbjfp0eqRwskywo98dnBACfyBlM62O8ahE+N
 YZHSfw4lO+2n0TOoqethFCrOtfpDcSUDirEHoeeVx++pG8d+5iTUXXRNsJS/z51DV7vU
 OdxKGJCAmCtC1HqD/oLIGRkDSiE7FIe6lt2BS4YfmFBSbsz4K5hMd0HcVPNfndpC5VfJ dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8xcus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtmG166080;
        Tue, 25 May 2021 18:18:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 38rehaq4vh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZHNQKPmABeT9sTPSOGTSOvDbi0xBNaC3TLh2Dz+RKySyeR6gVrzb8x4C2ifhcDTBp4h3+C++jMZvr6Q0lzdSDIQgeG6LH1M5k+7iP3CkhYQXdECBk8VUj4+MNiZAy3nIVz+by6UOOB+DGLcYkU20FQteLCYXsgCAMGP1vXM2gS9SeAGyPrgCrWosGJkTRYFdFD8rqcg+T0N4cTu4x1vK7JS7pnH2vHtPBkz5RKuOoqKIp7wYGnWrARUNq7X5HEvUOouNToXMT/CFmQkqSsSRyl/aUcFqjMn8JXQkafh+BGItDEcwVugF0KaiQuzqWG3P/RakJuYLBhg/fp6BLMeGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA6uNZnaiKkDglyIdBApqOkWpWD0i1ZY/hgDyC5w8j4=;
 b=QgK5Rxxf6cxQnHHk/b6irZILHFPC1Wt9H0shKGw2lflRJQhTu/XxtFRdQlLRGgC4Sq2lLbD/FeQHQM3LrpD6aLtYJAYKwUhDqFyB8ddHoA4Iex9HNk8hOhg6g+yOrZmKHRCaSPiMe3V1bNX+R2AJsy0JdahKotY4rz9mU2y5Sa5Ht5wgFt97vRHTGi8MxU7aE89oz7kSCBQRTKSXuvNJPYWRiHgphzvsi6ErYkORqzW1pg6AXcvz8BeLBRfDIsVjuNu5CjKeriX1lkLSHRHQ+LMGPogBaqOxUcDqvjQdWWSG3CVaKJwUcIzPl1rxHfKYpOLcaNFE16HIa/3qdS2szw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA6uNZnaiKkDglyIdBApqOkWpWD0i1ZY/hgDyC5w8j4=;
 b=zMW+vDEwMZRw7Pa+HbaieGYcFnSDUIbNlwsDr3kZp1snJcpANIhexOf92EvtVdjKAH8JdweUq92Os4SAJUKHjMR25/7SXsR4hMRCAg/wR8u/UUuhe/T/Y6iM4ubhrFill9Sgrtkzo53yyRVQDRTXoF6rapOfWhWaOJuuWyQIxsc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:31 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 02/28] scsi: iscsi: Stop queueing during ep_disconnect
Date:   Tue, 25 May 2021 13:17:55 -0500
Message-Id: <20210525181821.7617-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9f5b53f-3b9a-4e3b-3b5b-08d91fa98048
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47675C404B740AB1B84AEFC9F1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lySf4yFLS8iRO88decIzcc0TBgbgfJ5vydZpYaue2mjfwgamxYS9jfQYhTOu+zflktGunTnywG1M5hEzRWzApQTwuTu035l3j6UgEO5x8snotco3/SmZblxg0wBzJ8uQFxUC/6wzokEuPSaihYD5TRWoiuLiCoNLuOnr4pHV7BknMSBK7AYYehplnzkFspQ8D+C8hyJJx6R7qWwB41542Xosazruew8ku5jTVsvaRd6r4oCSy7tqZ6pTwyNCedV3WnvUrHjaO7J22izr8xaPgcBupF4eH/TeTvPkVh2V8cywE9Pw+b50IC/eRGdGmnyJkxij6TiblIUYpAOCzOZJgDiLEJ/UcRZWtcq8zmPg3w4C7nNHDz/k4d6GEMd1AwQJAyLdZ02VMAd3K13xUQyZetgoYQ4Y4Vp4RaOjSYrG90KWrZunleU/3tVz/95UyVoCZ/ZUP/CcavlJzwsyq3ri9UMWDbgQRlaHEBEVVFlZGH/UlAYqZOqykMV+g2BnXndU00aVnyX0vuC2C30aBbnfp5pFQnevIx5FN6tRgzPxg3jmlV0bKIDNtacFzlg7nEZfvH7u+8gmHp/hQ827vS1xIAvZbLXShu4eSuEAyF/71Gkv0kPsXKGjn6qSALX6bvHNikzs6/GpdFhkX4TQnRuGnqSFFAf9NsRA1TITkTVlHDh0cbTWk+FnYundhjTx1LdN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(30864003)(38350700002)(86362001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Em6SlL6lBYkOwhBiXdpEk1oFPd/6lgQ4eOZkai1Thw9qpdMYmbpxxL/zXVmK?=
 =?us-ascii?Q?j0879uwOrcxA1X74GptCkzIRb8NPB6YVTwsuk8m/7/2JCaN3i0PyRJ+EHb0V?=
 =?us-ascii?Q?c0pK+aEY9lRYmF+poHiWTqvfVj0WVh/yfnLFVVztsr8cM/cqzQm/8nCU6JSq?=
 =?us-ascii?Q?3PiOsWi2nqhZ9jXBFw9iTLq41mf8jwSQA31IDs2b/qDhT8n2N2Hf83ttpF86?=
 =?us-ascii?Q?MEjhsIDph3zAGEff/PCGUGqWgg59H5mLSog4P90JW7fMyg3AeILEm9s4E2zW?=
 =?us-ascii?Q?Z7wM1Z+Atj177cAEPCKvTyaoRHQLI9u+odu8bTQi+E8Sc8adWiBYE8UWwWj9?=
 =?us-ascii?Q?b13ujBHB1C/+/qd28to50XJPok/h5Or/X3+DfUfqQ69exKit56I808JQMbQA?=
 =?us-ascii?Q?B9S3q8a2dWmQiLQYId7wKonU58IDRon7QwkdGyY+NbHjWzyf/ByYs/ZNl0/8?=
 =?us-ascii?Q?svy0IjkE6jj8KF2COvNQBmFDrqP0IkXGRXce25xRLDste8uVPuVGWmX7zRfp?=
 =?us-ascii?Q?nXo6Hasf4hre/2D0vK/1RD1gdidaD/ypdyEJgbr7TOms9+WM+uxpyTaCGyGz?=
 =?us-ascii?Q?syXsmS6U987Sgqvjaay1yJNcJrGofT43Z9LQF1VbH7OeV5vEsJPyfvifwCxx?=
 =?us-ascii?Q?haaW7bkYsFtlM1mxjQD6ogUyLc+2JdSGBqFT5eJVU+/THYmNxI1nGLJ2MZkx?=
 =?us-ascii?Q?DO4ZSRruGolJSILEwAVR9pk381lyWly/czl17KzLEWVMzpSj2oVMv98osxk0?=
 =?us-ascii?Q?HzZOQHVhiLOyswhs7HOF1+r+D2Wxz9Gwc3TEdI3Lh2+c9qu0SlSxtnpDJUC+?=
 =?us-ascii?Q?9E0a61wQ24VuFq6HXh+5pvuTHEDlS2AdFbpdyHGGqOtTHLh/yWBrevyBN5K7?=
 =?us-ascii?Q?cAd72Fq+at/4oUVP7VFFxeoTnDmxEEuiTfehRFey8NKUGMQMAbUDw1vW2MG6?=
 =?us-ascii?Q?8+T9s83+IhyXkZF+Fox/Q56CPiPVaOe2BTieNxmBa1SVc/oHmhx+5HyQwFlU?=
 =?us-ascii?Q?4CLPTHBImIlwbUodgfbharuU7Njzo0z6SU4VTi4KhaV/i5PuoVwXWAk0J4zj?=
 =?us-ascii?Q?WK3B+L+WaQX/9lIhP3uf/lyC6WG6qi31kFsJqFbbtMLnm6SRrO7lCYSpEHOp?=
 =?us-ascii?Q?d2llJ/xm4hjCDw1vCup+feBJiztNDWSXUAzDroiYjh1FA+sTOoiPctO4/qmR?=
 =?us-ascii?Q?6sAnbGnGhEtGqMh20pz4Zp9bW4aavqR0R9IU+Nl+i3f8tRAbc+TPSzuZk/Nw?=
 =?us-ascii?Q?I2IZqOCZycq3dWAoVTJSKVFMCGlSU5W26ng0AApyE9IqcgH5LwsapatgQ9Pb?=
 =?us-ascii?Q?Q3ajUfZrlf4Zaan9C5Y0jUTF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f5b53f-3b9a-4e3b-3b5b-08d91fa98048
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:31.3666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzA7xmq4R9yZtWAalM2tBkBZmVYiVouxog7Mh5EXHwAJFvSMojZe8D6fSro6Zbb3g6yloonHPtN5hp0Qbk1Rh0J/caKDJpU33mIzn3YkIAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: Sf4KDY9RD90_Y1ODzHvcDX6tDuaYT05R
X-Proofpoint-ORIG-GUID: Sf4KDY9RD90_Y1ODzHvcDX6tDuaYT05R
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ep_disconnect we have been doing iscsi_suspend_tx/queue to block
new IO but every driver except cxgbi and iscsi_tcp can still get IO from
__iscsi_conn_send_pdu if we haven't called iscsi_conn_failure before
ep_disconnect. This could happen if we were terminating the session, and
the logout timed out before it was even sent to libiscsi.

This patch fixes the issue by adding a helper which reverses the bind_conn
call that allows new IO to be queued. Drivers implementing ep_disconnect
can use this to make sure new IO is not queued to them when handling the
disconnect.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_main.c          |  1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
 drivers/scsi/libiscsi.c                  | 70 +++++++++++++++++++++---
 drivers/scsi/qedi/qedi_iscsi.c           |  1 +
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 10 +++-
 include/scsi/libiscsi.h                  |  1 +
 include/scsi/scsi_transport_iscsi.h      |  1 +
 11 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8fcaa1136f2c..6baebcb6d14d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -1002,6 +1002,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	/* connection management */
 	.create_conn            = iscsi_iser_conn_create,
 	.bind_conn              = iscsi_iser_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn           = iscsi_conn_teardown,
 	.attr_is_visible	= iser_attr_is_visible,
 	.set_param              = iscsi_iser_set_param,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 22cf7f4b8d8c..27c4f1598f76 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5809,6 +5809,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.destroy_session = beiscsi_session_destroy,
 	.create_conn = beiscsi_conn_create,
 	.bind_conn = beiscsi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.destroy_conn = iscsi_conn_teardown,
 	.attr_is_visible = beiscsi_attr_is_visible,
 	.set_iface_param = beiscsi_iface_set_param,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1e6d8f62ea3c..b6c1da46d582 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2276,6 +2276,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.destroy_session	= bnx2i_session_destroy,
 	.create_conn		= bnx2i_conn_create,
 	.bind_conn		= bnx2i_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn		= bnx2i_conn_destroy,
 	.attr_is_visible	= bnx2i_attr_is_visible,
 	.set_param		= iscsi_set_param,
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 203f938fca7e..f949a4e00783 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -117,6 +117,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	/* connection management */
 	.create_conn	= cxgbi_create_conn,
 	.bind_conn	= cxgbi_bind_conn,
+	.unbind_conn	= iscsi_conn_unbind,
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn	= iscsi_conn_start,
 	.stop_conn	= iscsi_conn_stop,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 2c3491528d42..efb3e2b3398e 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -134,6 +134,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
 	/* connection management */
 	.create_conn	= cxgbi_create_conn,
 	.bind_conn		= cxgbi_bind_conn,
+	.unbind_conn	= iscsi_conn_unbind,
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4834219497ee..2aaf83678654 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1387,23 +1387,32 @@ void iscsi_session_failure(struct iscsi_session *session,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
-void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
 {
 	struct iscsi_session *session = conn->session;
 
-	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_FAILED) {
-		spin_unlock_bh(&session->frwd_lock);
-		return;
-	}
+	if (session->state == ISCSI_STATE_FAILED)
+		return false;
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-	spin_unlock_bh(&session->frwd_lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	iscsi_conn_error_event(conn->cls_conn, err);
+	return true;
+}
+
+void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+{
+	struct iscsi_session *session = conn->session;
+	bool needs_evt;
+
+	spin_lock_bh(&session->frwd_lock);
+	needs_evt = iscsi_set_conn_failed(conn);
+	spin_unlock_bh(&session->frwd_lock);
+
+	if (needs_evt)
+		iscsi_conn_error_event(conn->cls_conn, err);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
@@ -2180,6 +2189,51 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
 	spin_unlock(&session->frwd_lock);
 }
 
+/**
+ * iscsi_conn_unbind - prevent queueing to conn.
+ * @cls_conn: iscsi conn ep is bound to.
+ * @is_active: is the conn in use for boot or is this for EH/termination
+ *
+ * This must be called by drivers implementing the ep_disconnect callout.
+ * It disables queueing to the connection from libiscsi in preparation for
+ * an ep_disconnect call.
+ */
+void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
+{
+	struct iscsi_session *session;
+	struct iscsi_conn *conn;
+
+	if (!cls_conn)
+		return;
+
+	conn = cls_conn->dd_data;
+	session = conn->session;
+	/*
+	 * Wait for iscsi_eh calls to exit. We don't wait for the tmf to
+	 * complete or timeout. The caller just wants to know what's running
+	 * is everything that needs to be cleaned up, and no cmds will be
+	 * queued.
+	 */
+	mutex_lock(&session->eh_mutex);
+
+	iscsi_suspend_queue(conn);
+	iscsi_suspend_tx(conn);
+
+	spin_lock_bh(&session->frwd_lock);
+	if (!is_active) {
+		/*
+		 * if logout timed out before userspace could even send a PDU
+		 * the state might still be in ISCSI_STATE_LOGGED_IN and
+		 * allowing new cmds and TMFs.
+		 */
+		if (session->state == ISCSI_STATE_LOGGED_IN)
+			iscsi_set_conn_failed(conn);
+	}
+	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&session->eh_mutex);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_unbind);
+
 static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
 				      struct iscsi_tm *hdr)
 {
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c05403cd72..ef16537c523c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1401,6 +1401,7 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.destroy_session = qedi_session_destroy,
 	.create_conn = qedi_conn_create,
 	.bind_conn = qedi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.start_conn = qedi_conn_start,
 	.stop_conn = iscsi_conn_stop,
 	.destroy_conn = qedi_conn_destroy,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ad3afe30f617..74d0d1bc208d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -259,6 +259,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.start_conn             = qla4xxx_conn_start,
 	.create_conn            = qla4xxx_conn_create,
 	.bind_conn              = qla4xxx_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.stop_conn              = iscsi_conn_stop,
 	.destroy_conn           = qla4xxx_conn_destroy,
 	.set_param              = iscsi_set_param,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 441f0152193f..82491343e94a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2964,7 +2964,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 }
 
 static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
-				  u64 ep_handle)
+				  u64 ep_handle, bool is_active)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep;
@@ -2981,6 +2981,8 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
 		conn->state = ISCSI_CONN_FAILED;
+
+		transport->unbind_conn(conn, is_active);
 	}
 
 	transport->ep_disconnect(ep);
@@ -3012,7 +3014,8 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
-					    ev->u.ep_disconnect.ep_handle);
+					    ev->u.ep_disconnect.ep_handle,
+					    false);
 		break;
 	}
 	return rc;
@@ -3737,7 +3740,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
 
 		if (conn && conn->ep)
-			iscsi_if_ep_disconnect(transport, conn->ep->id);
+			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
 
 		if (!session || !conn) {
 			err = -EINVAL;
@@ -4656,6 +4659,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	int err;
 
 	BUG_ON(!tt);
+	WARN_ON(tt->ep_disconnect && !tt->unbind_conn);
 
 	priv = iscsi_if_transport_lookup(tt);
 	if (priv)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8c6d358a8abc..13d413a0b8b6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -431,6 +431,7 @@ extern int iscsi_conn_start(struct iscsi_cls_conn *);
 extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
+extern void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
 extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fc5a39839b4b..8874016b3c9a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -82,6 +82,7 @@ struct iscsi_transport {
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
+	void (*unbind_conn) (struct iscsi_cls_conn *conn, bool is_active);
 	int (*bind_conn) (struct iscsi_cls_session *session,
 			  struct iscsi_cls_conn *cls_conn,
 			  uint64_t transport_eph, int is_leading);
-- 
2.25.1

