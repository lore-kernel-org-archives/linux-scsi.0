Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479AEC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1465A611CE
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhDKH4e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:56:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60014 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbhDKH4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 03:56:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7pVSa180160;
        Sun, 11 Apr 2021 07:56:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=05pUn6y81TJ+Z5O1EOahcdiXgWzFShidFYYhkG6fB1U=;
 b=fKNFZh2Fs5xZjPpP8PDKHOWQw96zL14sLLMQosf6IsGMVAZZCkVowjvCU+pKYcEZo/zf
 pvT+p0HJIovzc4BDXpbtJUh/tCdA3Wd1On0ZF23Ccf0WBwUeGMflbvNTQqX1gb2imdPL
 dwm89CnzcC6/ZHKir29s1h0O5vQSQ75zCiXwwqiW0/r47mWPhvwAULdlyGDCcWzxUkXq
 59YIIpQbBFkDyDlq/nXXqMDXA/fn/Kt/SpxNkLYAEWz/BiRZ9Z+hARiM4oAEwvhWGkoz
 o0luu3crtooaRAIZ9UsSoYjB5UsJV/75baT1coQwiOvi3TPkvqxmndBWL8IX3We5x4a/ oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3er9aky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:56:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7tXbQ017877;
        Sun, 11 Apr 2021 07:55:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3020.oracle.com with ESMTP id 37unww7qm8-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3YbjqwB4WhCTVkwiGOWUrDm2X3Ihh3KAWkV5ee8g6Esc1NAVU9RaIG/oWu6c/MnidizGGUIiGW9BagzZ5/Hjn8jzC2GfLJOGuL/PCXm7ZgC62jEwNt9H3RcmF2lON9j8hweAMwPBJH9qPGuj2E3hz5AgwWdYzKk2X2dMs5uGgkwHYDOLRFtIrED5v+BYh87nyEURb7n5SiCmXhdLwmOZ+lflHqiBRxqrZ1ORtef0RZFTi19mFuyiSGh8ubf9vTjn1wfzx2nlPtDL6N1CtWoJSw51zRyhSBKUsX4/GqKQegB1stZpQWxcC2XY1TFjATIeHEuGWu8L82X13PrCBIAHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05pUn6y81TJ+Z5O1EOahcdiXgWzFShidFYYhkG6fB1U=;
 b=ZMrCQPDU8opOIzdJai7U5+VDWycN1bZD01W9j/Kg18qGyDjFobe6seRX9a+004v9ylqyMI1SfePZ73uIYWLZq/Z7ty2gwZJn+IhHoYgFcTslSrexMsDUAfZGN0oR7/JER0PvHVkLdnjpVEAwoJvZpp5ECN72tlB4rj32Az5swD6O9kQSAxCHoPd97HeTQg8UwoyqP8OuvMClovHV5c1Dp9GUTdGs3bYARiSEr7UgKD3nZq/ZMn8IEwQoAksMPMYiI8qN5RdsWQmRK/d3d2mKdsl2JJT6EY5mw6hzospz92unzHXvHByNUkd28boEtI7MVx2geGwPVlpSl6cobJD7YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05pUn6y81TJ+Z5O1EOahcdiXgWzFShidFYYhkG6fB1U=;
 b=axL7UXjNxMQs0GJb+3mgveWWqR/GiUtx3GQ6PVGoe37YDQ54K8mfJdWoRPQiFlhCjzgZdJDDbJBQxVGDu84Mm42GWBSROdKxCtkiKbufUd/c2j9MspNSkcOWMuOd8kbXvLMJa0vTKsGGuG4+CDll50YqBFdRQX13XOlC8oJfeP8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3842.namprd10.prod.outlook.com (2603:10b6:a03:1f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 07:55:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 07:55:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC 4/7] scsi: iscsi: have callers do the put on  iscsi_lookup_endpoint
Date:   Sun, 11 Apr 2021 02:55:42 -0500
Message-Id: <20210411075545.27866-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411075545.27866-1-michael.christie@oracle.com>
References: <20210411075545.27866-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:5:15b::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sun, 11 Apr 2021 07:55:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae58b3ad-207b-4718-5cc7-08d8fcbf3d94
X-MS-TrafficTypeDiagnostic: BY5PR10MB3842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3842886A5A8F7854ADA72422F1719@BY5PR10MB3842.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2gNDGw0lVmvzZ2tvljF1Ug6J9PFVxSpyWzUn1qc1JSjx0z+2uLMHnc/Li44LnFIgDsY63Cw6B1NxhPAnWM9BbTTBitnj3n7nPgyLC1p62V0bymX2Xm/77Xx89JdYrwdYwWWYpVj7dei4ysELPXSX++M3Na/tCJbtozJEqdZYWwEaINJKpM5UeOCOHfn6XVGjhiP9L47pnVfBoxWLj65Pu5oKMrl1zqH1UFBqgu0pcE77LwJ3EuYKuxhOGtcMK4wXYzRklxxKXlTv6miWA3K6RWr8aaKhmdiDi3p9MzuzfR2d8NMU0cGI7SWWQ1PNnDBHB56MPGiMWGnQAIImvR+o7Hi/INrCMHjkziGqH0/bTWGM0ragnViaot4JN67WN2dkTTvygTvjnxlKmb+U9EtWtEQc8V2vFpXPl92ysf4E5KKCz6DYF0IZV1Tc2INxNg1sbwO/IPuHf4a5n2PkXWgC9+uTctHVV5SE5Ht2LTMiXuC4zfZ/fM1D2ol0N1GP0EZML4cbYKtuK+mTJDfR23X8FkZqiHNgqovyhddsW2p0NI4rDlzCZX5Lz2eGV/RRmmT8WX23OoizYMBo2POSgEAtbuc16nLOYtrTGgMrXEYTI8We3PeHyMZbB/Sq63u4No8AOUtpcq9H30JYots6V0Y83qKFBH9jizrvQvn8otMCICdnVpwu20uXWe7kWtYYAFB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(16526019)(6486002)(316002)(66476007)(6506007)(956004)(2906002)(8676002)(2616005)(26005)(5660300002)(6666004)(86362001)(38350700002)(52116002)(38100700002)(69590400012)(186003)(66946007)(1076003)(83380400001)(36756003)(6512007)(107886003)(478600001)(4326008)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wxADpJHdqhRUJdXzGAOSZldJrufcUIlu7yemRGAzd4nEsaZDUfg3Z1ysvjKF?=
 =?us-ascii?Q?JOpQwuwli/99FyoYofA32aTr992Na7sP3JYAfFV0W38+4BGhrXXxJ3l2cmhx?=
 =?us-ascii?Q?hIXDPHczav696CKJz0kqybzI1Wr3vid9bSpCFmkyhJS7+bTyf6LNj2y+p4ne?=
 =?us-ascii?Q?CnMruzNkVEjxBjSdckrvNEehk/lwQgLhqLDjNVoHuHmNup4g6m2D2px1aLS1?=
 =?us-ascii?Q?HN+hCHqiEVNBzptfoUa+YQHblJ0Zdtkikqm7mgFO4ww28Ta9i7+H4oN8ch79?=
 =?us-ascii?Q?JfW2dACJlG4ZjumwWpqZlCwEZTweLmIaJWEBt9R+y0/6czRpUiavIE4TJSpV?=
 =?us-ascii?Q?YvHDBDJTwvv11TyoSLf0ooq8LC8YEZ3ntztQZ8PNqzk6vDHH0gdK6vKUOPQW?=
 =?us-ascii?Q?nCvkmld4uYCMhK2v76l/YYo3RTubaykJStJMl8or3n1H33V3lW+RjOGd5/nC?=
 =?us-ascii?Q?WRqyZo11gT6HqYAuGSnMq94XE+jpOpOCCahCkIOqbc6NAi5QF1IoecPQ1gCz?=
 =?us-ascii?Q?eVFTEverJ1DiWaAwDgaR97tgjtmz6s4efMkb0ymuMZAT/6cUENAfndj0tAlv?=
 =?us-ascii?Q?+/wvrN0wSnykxETUGo10v4nOGJxexAAyoPpXl9jYXcKXpCXfTZ0FgPHA0Bqt?=
 =?us-ascii?Q?7I7cvrS1+H9Y0sOgGMEjUmbw8ds6CTT/MR0oLSR8v9xSq5LMw3dW7zo3B216?=
 =?us-ascii?Q?4DQ7pY30eKAE5ogG6OGQhfPvSZbHhWuDy8REXlDS27Un2DHAh/M96O9WcVck?=
 =?us-ascii?Q?SA8tvXB1rr70LD+O5px379En2D5LXiolD9xaMOTIJ2z9ufRUJsa2FlR/HJTN?=
 =?us-ascii?Q?KmRJNAyeZOfvI0w56siVrDIGoh6xeELu4A77eaHoVvmw4unsqSHkzaT5XCqX?=
 =?us-ascii?Q?XJYz04CwS/S6hmYoyKWLDjvWt2Vjj9UUP+baJJQga2qS070KknjkA6hrrqNy?=
 =?us-ascii?Q?C0S19ADXdx6QNDBfkNlCDyR5nYuoNnAWCNWVxo7bLHfSH5HXKGJVsk6EKQO+?=
 =?us-ascii?Q?iLQmDfFYT+gkD8isY0TtPxlUlW4xMCGTUxpZ5jjTc1TbmRyrti4Q/xVwS5Cz?=
 =?us-ascii?Q?svjVisAbnC+U2MGSuTxN9GHlkWDLy4R/ZQYbcrDBlaER1ZL5uIvALjl000Pi?=
 =?us-ascii?Q?52AKHG/OJzg4Z+Npu9BDFq5Yqtdh2OPG4szsnDv14nS6uFRLTlvyFB5UFgS5?=
 =?us-ascii?Q?7+tV+JyljLdBF4jeUKU2IXpn4XB+iEhSEwBwXG7uVIC9HdjYxNheg17Z0WPW?=
 =?us-ascii?Q?SNbZzhnE4WpnW8Rv54G1WpnTYznZadK3+cCqKjE6bf9R2F1yvY02W7ZWE90n?=
 =?us-ascii?Q?OJOUXeaZhZRI50EJHwmw6e8e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae58b3ad-207b-4718-5cc7-08d8fcbf3d94
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 07:55:57.6650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cuWoC2OyXSAbf+gUEJ1lGbOMKB0rC0Ew1448psJlsJh+F7uA+mnfnEuRBLPEzV9VGlkuTqMRFEu+kODoCR8N2+f4AididJ1ZIhcsgTNcaKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3842
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110060
X-Proofpoint-ORIG-GUID: KLqAuTADJxvGgpzIMlt-f66v6BTp3Nln
X-Proofpoint-GUID: KLqAuTADJxvGgpzIMlt-f66v6BTp3Nln
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110059
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches allow the kernel to do ep_disconnect. In that case we
will have to get a proper refcount on the ep so one thread does not
delete it from under another.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_iscsi.c         | 19 ++++++++++++------
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 23 +++++++++++++++-------
 drivers/scsi/cxgbi/libcxgbi.c            | 12 ++++++++----
 drivers/scsi/qedi/qedi_iscsi.c           | 25 +++++++++++++++++-------
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 25 ++++++++++++++++--------
 include/scsi/scsi_transport_iscsi.h      |  1 +
 8 files changed, 75 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8fcaa1136f2c..54d756e5c033 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -506,6 +506,7 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	iser_conn->iscsi_conn = conn;
 
 out:
+	iscsi_put_endpoint(ep);
 	mutex_unlock(&iser_conn->state_mutex);
 	return error;
 }
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a13c203ef7a9..c4881657a807 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -182,6 +182,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
 	uint16_t cri_index;
+	int rc = 0;
 
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
@@ -189,15 +190,17 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	beiscsi_ep = ep->dd_data;
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
 
 	if (beiscsi_ep->phba != phba) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : beiscsi_ep->hba=%p not equal to phba=%p\n",
 			    beiscsi_ep->phba, phba);
-
-		return -EEXIST;
+		rc = -EEXIST;
+		goto put_ep;
 	}
 	cri_index = BE_GET_CRI_FROM_CID(beiscsi_ep->ep_cid);
 	if (phba->conn_table[cri_index]) {
@@ -209,7 +212,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 				      beiscsi_ep->ep_cid,
 				      beiscsi_conn,
 				      phba->conn_table[cri_index]);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto put_ep;
 		}
 	}
 
@@ -226,7 +230,10 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		    "BS_%d : cid %d phba->conn_table[%u]=%p\n",
 		    beiscsi_ep->ep_cid, cri_index, beiscsi_conn);
 	phba->conn_table[cri_index] = beiscsi_conn;
-	return 0;
+
+put_ep:
+	iscsi_put_endpoint(ep);
+	return rc;
 }
 
 static int beiscsi_iface_create_ipv4(struct beiscsi_hba *phba)
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1e6d8f62ea3c..b119285cfa8d 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1420,17 +1420,23 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 	 * Forcefully terminate all in progress connection recovery at the
 	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
 	 */
-	if (bnx2i_adapter_ready(hba))
-		return -EIO;
+	if (bnx2i_adapter_ready(hba)) {
+		ret_code = -EIO;
+		goto put_ep;
+	}
 
 	bnx2i_ep = ep->dd_data;
 	if ((bnx2i_ep->state == EP_STATE_TCP_FIN_RCVD) ||
-	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD))
+	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD)) {
 		/* Peer disconnect via' FIN or RST */
-		return -EINVAL;
+		ret_code = -EINVAL;
+		goto put_ep;
+	}
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		ret_code = -EINVAL;
+		goto put_ep;
+	}
 
 	if (bnx2i_ep->hba != hba) {
 		/* Error - TCP connection does not belong to this device
@@ -1441,7 +1447,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		iscsi_conn_printk(KERN_ALERT, cls_conn->dd_data,
 				  "belong to hba (%s)\n",
 				  hba->netdev->name);
-		return -EEXIST;
+		ret_code = -EEXIST;
+		goto put_ep;
 	}
 	bnx2i_ep->conn = bnx2i_conn;
 	bnx2i_conn->ep = bnx2i_ep;
@@ -1458,6 +1465,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		bnx2i_put_rq_buf(bnx2i_conn, 0);
 
 	bnx2i_arm_cq_event_coalescing(bnx2i_conn->ep, CNIC_ARM_CQE);
+put_ep:
+	iscsi_put_endpoint(ep);
 	return ret_code;
 }
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..f6bcae829c29 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2690,11 +2690,13 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	err = csk->cdev->csk_ddp_setup_pgidx(csk, csk->tid,
 					     ppm->tformat.pgsz_idx_dflt);
 	if (err < 0)
-		return err;
+		goto put_ep;
 
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
-	if (err)
-		return -EINVAL;
+	if (err) {
+		err = -EINVAL;
+		goto put_ep;
+	}
 
 	/*  calculate the tag idx bits needed for this conn based on cmds_max */
 	cconn->task_idx_bits = (__ilog2_u32(conn->session->cmds_max - 1)) + 1;
@@ -2715,7 +2717,9 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	/*  init recv engine */
 	iscsi_tcp_hdr_recv_prep(tcp_conn);
 
-	return 0;
+put_ep:
+	iscsi_put_endpoint(ep);
+	return err;
 }
 EXPORT_SYMBOL_GPL(cxgbi_bind_conn);
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c05403cd72..76d40c79e6ef 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -377,6 +377,7 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct qedi_ctx *qedi = iscsi_host_priv(shost);
 	struct qedi_endpoint *qedi_ep;
 	struct iscsi_endpoint *ep;
+	int rc = 0;
 
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
@@ -384,11 +385,16 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	qedi_ep = ep->dd_data;
 	if ((qedi_ep->state == EP_STATE_TCP_FIN_RCVD) ||
-	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD))
-		return -EINVAL;
+	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
+
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
 
 	qedi_ep->conn = qedi_conn;
 	qedi_conn->ep = qedi_ep;
@@ -398,13 +404,18 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	qedi_conn->cmd_cleanup_req = 0;
 	qedi_conn->cmd_cleanup_cmpl = 0;
 
-	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn))
-		return -EINVAL;
+	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
+
 
 	spin_lock_init(&qedi_conn->tmf_work_lock);
 	INIT_LIST_HEAD(&qedi_conn->tmf_work_list);
 	init_waitqueue_head(&qedi_conn->wait_queue);
-	return 0;
+put_ep:
+	iscsi_put_endpoint(ep);
+	return rc;
 }
 
 static int qedi_iscsi_update_conn(struct qedi_ctx *qedi,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 7bd9a4a04ad5..18d63a0af14c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3234,6 +3234,7 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
+	iscsi_put_endpoint(ep);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0ea8ed288f54..036486310260 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -268,9 +268,20 @@ void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
 
+void iscsi_put_endpoint(struct iscsi_endpoint *ep)
+{
+	put_device(&ep->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
+
+/**
+ * iscsi_lookup_endpoint - get ep from handle
+ * @handle: endpoint handle
+ *
+ * Caller must do a iscsi_put_endpoint.
+ */
 struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 {
-	struct iscsi_endpoint *ep;
 	struct device *dev;
 
 	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
@@ -278,13 +289,7 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 	if (!dev)
 		return NULL;
 
-	ep = iscsi_dev_to_endpoint(dev);
-	/*
-	 * we can drop this now because the interface will prevent
-	 * removals and lookups from racing.
-	 */
-	put_device(dev);
-	return ep;
+	return iscsi_dev_to_endpoint(dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
@@ -2984,6 +2989,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	}
 
 	transport->ep_disconnect(ep);
+	iscsi_put_endpoint(ep);
 	return 0;
 }
 
@@ -3009,6 +3015,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 
 		ev->r.retcode = transport->ep_poll(ep,
 						   ev->u.ep_poll.timeout_ms);
+		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
@@ -3691,6 +3698,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);
+		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
@@ -3762,6 +3770,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			mutex_lock(&conn->ep_mutex);
 			conn->ep = ep;
 			mutex_unlock(&conn->ep_mutex);
+			iscsi_put_endpoint(ep);
 		} else
 			iscsi_cls_conn_printk(KERN_ERR, conn,
 					      "Could not set ep conn "
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fc5a39839b4b..165e629fba02 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -441,6 +441,7 @@ extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
+extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
 extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
 extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
 					      struct iscsi_transport *t,
-- 
2.25.1

