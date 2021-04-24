Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5F5C43460
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDAF261264
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhDXWHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhDXWHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6Kf8151674;
        Sat, 24 Apr 2021 22:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=I6CF8I92jPfN97R5RE0SYx0dKqw/3jQxjWrvMpYGEGw=;
 b=fkvkffQOwCvITC3oPe/YaJMVvfBcZsGxkIGMm3EYGwel8WxW/OVcChZCvJ7Jw1W4yWAr
 yEBcvF+88QPKVBTFaRz0HlBKyWehmz5goIld7ZuA+nOAM5jtpWZayQFv/93LClwEVGci
 R+LlQtWVfax1GdcCsEvXL94KBX5Utcy5QF4YIVvKHPUZABtf1JPjoQc+j5v5vq/NI27i
 /Bjc65fmwUS3Cz/YtlleRPqmWQy+y0Po9zes8w/1u2qGvAF+zLsSeL92ygsYGor119ku
 I3nUjlG/CN+4GGhq/vL061VS62h8T+yEZCf3zkAbNZzXwS1+kKWtg2jEeyBurAN1hkDz 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 384ars0t10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6Cag045579;
        Sat, 24 Apr 2021 22:06:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 384anj7ut9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwX9VyhSgWj2hbPGqi2cnIyrwksJgBj+CDyDk2gkuNBfGr232HHhC6J4JVh+gDrCVSEzeYnVSwnYsBe7JkmkyddlhigA4w0NlX8UXh5w+NRsTENKWrOVmKNLPblBT0LC4oEWQ+Q/4Fqd+2pSab8kKNRDC1/J4Je9xL3Y8IcKJqSp25L8YnQRWUJyZULZyv8nyI942r1+TPV7qp1u0cJIiCbuJzy46CuFKayOLF3Ghb6mO80s18bMJT+r3HJvDng3qdVAvWYfVXUcgz7npHY/pWzgS08ZlH2IDas4QPeWOyMaxVZiB2OE+Bw8T1Mne+F8dd33CSQz22gEKG0t2j+Y+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6CF8I92jPfN97R5RE0SYx0dKqw/3jQxjWrvMpYGEGw=;
 b=WVJtnCMd8Oo3dFD0zC9hV/VXv1o34dsxEItZ1fhqGcyrh0PcP2QBjyzGeF1FnYxaxrdUy9rbajXyTxCCwoopr34unqOLjQpBiAbkpCeJoAl8SFBArxzlS1SqLgvpgiZLTjlKPDN3Au7agj6Eh4E8aSrRXNeXSmC4Byx+yD6dy4fiHr+EGLwXZwm6MsiESb/HIqQoZOp0o3sGOi7cOB/Uqr9G7MNbW85Zu4afuawJfkOxN7vURxWnTRJWXYQ5h1DwQapRiERqBR2YSnbnAIPAODDCZwGwFluzHx5eyCb7vy313RyGnVnsSO6AjkWxr/15EGBGuyrzME76s9PZXuMTEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6CF8I92jPfN97R5RE0SYx0dKqw/3jQxjWrvMpYGEGw=;
 b=AWj/FMhaMX2btzGsXQNBmOGIRbWtt9tobIDDZsTm716oVZVjSB9SiXV1dHIeCvW5wr1J6iGoE7LAJhCw2C920VjSHAGR5Z+IK0IJdLllmGW97tsCxFrW6XkgIuHk1TaooAp9q65UVrrdgnkd0I/szuwfQNbviVR8cejwm057vkE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:17 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 05/17] scsi: iscsi: wait on cmds before freeing conn
Date:   Sat, 24 Apr 2021 17:05:51 -0500
Message-Id: <20210424220603.123703-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ac8a55a-e675-485c-0cfd-08d9076d2f53
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3317EFA4AA7F5F23F19DD58EF1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 90XXghiiGX3iPDKKVLmyrjfp4LK7e6eMUeqzZJL6Z+UBC6G55qqkbpyLsDQgJGp3btKURJOYXdRuGzgycOoeKZZ/8HHnv7sdPbeXfWvn5fVZz2EhQSZ9lBVr3lxjUYdeJlgLojaKmQb2qXDeRXsgy6OntCmdbg/yJuQXEHoFWdZzurM5MCo3wVyqpHWYZyiKc/MPSyIS/trBNJw3rozJP0o1mmhDdJnL0aYaqeeuUPl/bshH+l6mr8zOKFdhsLjBui7/WAmS/aJ/Ewcqsfzv7G8+udQzxMNkfra+N3iL4gyLtkLy3sOrKB/peQ7Nu9vDQk38rmuMpDP5O5FDCdRSVul6QEzksTf033+Nrzsx2jIDtqxigqS5EQqy9W8c+NeQAFgomeSvo5bGVRyP8xpMHqvCZlY8W+O1L/1b/VzoXrzlSHQLsRejwAJ0I7kRxCrcDyypb6Suk9JG2A2g0PFe8UPBT8UlNtkYAmNuKfDOBCm3cIDuJmNUD+yVaBbcpOoURYNk472oMnBVCUPDfyYpDnEAv9rkynDNO0IGG012GlVba1wXTRmMeVxbNI0xm6WuMA52NPeyX0n/rrG8mocPKM/DcQiiQ93T4lg1x6AHjYrF8JNz37fAVChexmGK+9AAJ3TYYfv9Em8xeUvJTJk+dFgKKG1QoK3Th+ta7MYmArN+zddC5xm0PQ7cydEkUzqj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6YOlU4KgeFMM/As+niTzmSmLToiTN3Q70KXqja+b/gSOSsArTJqT/+MHAfsh?=
 =?us-ascii?Q?K42yFP1LFNBqrFaBD913NtDUgNFpHLmbw8fMEqwNM84l52yu0XY6D9nlnk5m?=
 =?us-ascii?Q?L9+rrGVWJfBQdo419Bou42YQdAPkMlU5m+vq5FvykRjZg2CDKzANl9ZvlSSt?=
 =?us-ascii?Q?yQd7ILZ1lmnRG/sbsiGhms+ySEEKlgdRPoMEw1gLjyLrMcx0bHAiqxSPgRvb?=
 =?us-ascii?Q?PUY8b8e+sW6El2G2Ty2xE0lkUiJ0bLKUp5oqJmH7oQlLMLjz1Yrl3I4g+DXp?=
 =?us-ascii?Q?BK7+GdBqMzK8ulUTNLOgZPNhRkAcgeVYhzdgVzt8t2a4kHY8ZvTtWXrNR3cS?=
 =?us-ascii?Q?Uul9TyN32G+U4tcLbtH0MYSUqOruVZK5qfupdk8uwbtfE//mxHhy19dwuW7Q?=
 =?us-ascii?Q?Zmbmt5rkx5tYf+sHNoRUNg+5FpA7lxqdQsEDZZVaky0eWonqoGpJ4ulyVxOb?=
 =?us-ascii?Q?apNdQ9nBXHMTMaW4n3Ab8HzsbGgZFMzolHF6a9oIcO/ARxBeWKLaOoTbOqeW?=
 =?us-ascii?Q?xAzINhyHp/j7tsS39mLS6uqa5zCT+RBOOhVEBEIdr+XzXVEi7FqhTHyEpIZd?=
 =?us-ascii?Q?V1XFrP3mJMjoasCzGs7pVxU6D1BrrwFQiNKvUc09wA5gQvysM8au4lBRxksY?=
 =?us-ascii?Q?22Fcg7Ql89Nr7N6yuqnIfABU28VBAl8U2MWY0Q0uSsl2POzdHFG7/IiQGUSD?=
 =?us-ascii?Q?9v0eJxlph3J02vmzcFekf3s/SC5rTH7VYsHJtNRzw0SphM/LrAAN3H2oj8X4?=
 =?us-ascii?Q?CQTBP6jrnSWr2wERgFNAiMWKCs1708AphDpDxePGY4X+T2agVNKKXo2jjC2b?=
 =?us-ascii?Q?9BN2K0XXhL3CcU5xDv/898lIQaHyaKIucPSRsxySPUy2bIG5D8bYUA/6yJzM?=
 =?us-ascii?Q?0r7zJjkdzAJi7oavZELrOtz00nuy+tyKEbE3NYSkdRsJ8ml3nknkNiqU3JGw?=
 =?us-ascii?Q?VyrKeRhBiwPp4mRPUGacRC83J8s1tdvoWG8FOHUEOkgp3tA2/UY2mmIIsY40?=
 =?us-ascii?Q?nomLO021xZECyxOXBQ+UilR1P48u4wbF2OkC7c2Ck9s1CwoU7k5p+5pl2u/a?=
 =?us-ascii?Q?F7zZY4FpoeuuGq2c59gBM8rHWzLS6lVfKJUiz3NlWTLg4rMoT07rLegVDXQf?=
 =?us-ascii?Q?xERP3OsKeLpBA0UkLRQKc+2enpYdLsEdOSRRFMm2kdukA1rc2vGjqEk8QMS2?=
 =?us-ascii?Q?K6xmgjhFWzkB4D3ddO1pX7l5oEOlNg/wuRuO/fjpBEpWXULUA5m0SzE2ilIl?=
 =?us-ascii?Q?j/iGl8C8nJMXhqvAaoEDfPXEjh/5ZrizxlnX8wgGjn/V4mfHvdtPIn7JsZGB?=
 =?us-ascii?Q?jfsAsbCKREQidv1Uqsa5WTXv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac8a55a-e675-485c-0cfd-08d9076d2f53
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:17.8196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Zy+K6N4+WBzZrEWp7LwAAZJ0x2QlG0hkrMFn8MVYdQoU6PXFWxpp9Htnwp8ic3lPYFpdDrb67bd+oWF9NzwwRJu2f8/s/DH7/WgZ0TxzfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: IIeo5mZFcf-QVRyDzxhKy_PAP7yyx3US
X-Proofpoint-GUID: IIeo5mZFcf-QVRyDzxhKy_PAP7yyx3US
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we haven't done an unbind target call, we can race during conn
destruction where iscsi_conn_teardown wakes up the eh/abort thread and its
still accessing a task while iscsi_conn_teardown is freeing the conn. This
patch has us wait for all threads to drop their refs to outstanding tasks
during conn destruction.

There is also an issue where we could be accessing the conn directly via
fields like conn->ehwait in the eh callbacks. The next patch will fix
those.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0f2b5f8718ca..e340a67c6764 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3124,6 +3124,24 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_setup);
 
+static bool iscsi_session_has_tasks(struct iscsi_session *session)
+{
+	struct iscsi_task *task;
+	int i;
+
+	spin_lock_bh(&session->back_lock);
+	for (i = 0; i < session->cmds_max; i++) {
+		task = session->cmds[i];
+
+		if (task->sc) {
+			spin_unlock_bh(&session->back_lock);
+			return true;
+		}
+	}
+	spin_unlock_bh(&session->back_lock);
+	return false;
+}
+
 /**
  * iscsi_conn_teardown - teardown iscsi connection
  * @cls_conn: iscsi class connection
@@ -3148,7 +3166,17 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		session->state = ISCSI_STATE_TERMINATE;
 		wake_up(&conn->ehwait);
 	}
+
 	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&session->eh_mutex);
+	/*
+	 * If the caller didn't do a target unbind we could be exiting a
+	 * scsi-ml entry point that had a task ref. Wait on them here.
+	 */
+	while (iscsi_session_has_tasks(session))
+		msleep(50);
+
+	mutex_lock(&session->eh_mutex);
 
 	/* flush queued up work because we free the connection below */
 	iscsi_suspend_tx(conn);
-- 
2.25.1

