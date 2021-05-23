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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17598C47081
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EED3D6117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhEWR7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35778 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhEWR7f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHueR4120974;
        Sun, 23 May 2021 17:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=58VixA2KhGBI4+wjiKN+w4Drvj+2oKWAZL6V0tidLns=;
 b=SLXHt/qIUq51Kh/z+ag20/8UwGg3HHqon29gp6Ztc+SPoh39F38wR5J49EaTk3vX89j7
 rH1qxl95C9KE7owZi6PxqMJsoSbi5aMwF7RJ0k3daf1/WL71WUoj5akpBLRZkFaTtTcj
 LjL2jYQsNvI6FSvd4JG7pF7L/FWyNm37ZaqB07GsnNr7aDCsZdvFyfhP/7BjPwBlMx5K
 DizayfD3o5Il5IkeO9e8ahIEhO8LpV4dTxqulEnzWs6kfzP87LtaxcpIp7VUgvqElVbB
 oysWNky+cY3AJyeywtoT+mFhWsaAExonj8YlBTJjxiYtj7FzsLrDlki7c5aWnG83zjzH xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp1ern-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHucLT161902;
        Sun, 23 May 2021 17:58:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 38pss3qbd3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mj/iBo8yvVYM3+5c9Vzgi8VycIabs2lcHGIgQCluOAXzhJEyYs+SWPGPoTIlfC3oTIPa6rdFe8LepyNFrTHjK0D1EQdh7d72rmDA1YrOATkEEwuNYXKy0cKajzbbU1CGN+B9jvq1UQRp/Ki5qyLQJ26BmiKIIc/F8YcJMWS8fompzKEFkRaRM2GtWcqobzWKXvkblqZ7jWfS7d7w6Xjo1znjtvhjAkoJmuzqXDBIWJJdY+oVtq1PEaLcWWj3D6INUNk7/WFmC8yNhJ3Nsj7TwNAGR4Xg6DxfKrnpHQgwQhX3C4y5Bv5X9RzGIuFEJQFUhJXAu8m/yRKod+kTLaK2Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58VixA2KhGBI4+wjiKN+w4Drvj+2oKWAZL6V0tidLns=;
 b=mtUKpKjupASOy06TXd/ZyEHFXNtqWcLd0UmlgDgU4a98g4iwkE+27hP/2M7ylsj4dx65OxfAmKG1k5vVmnfSdDkiUZ9K3Xf2B5KQAvCyUmgsS9weWs8d/nIoQaKbT+WHylzxYW3tSYdDWF8ADXcqGW4fuVRXPmlbQnONa05z0+n2BWWvj+n1mmCu8cJJN3LlNPQDjQxDemQEerat2CSVMXHA4wdXq659HjegosHYnAkQ63lyUaK79mkVIObABAFLNqo1yrQw/0B7/x63ILw3B3QzT+x2EufvLDGrWVG5fllEKElFybo+ttx4vtMPDxDFfJLupiuO4lXu6KSDaMhOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58VixA2KhGBI4+wjiKN+w4Drvj+2oKWAZL6V0tidLns=;
 b=SwUIdaFKIvkUAlbNOuzUzcteiiufJaWbFCAyx6f+Cbc12ss3xJkIPGOqTlWTcchgERL0Olc7mfEz49SeVE0IwePDpY6yPKE7LbUeRYkW4C84eU9rkAECKrZ3OIQzRzRosYkZ5gSccDwmeA5IqMT/ZaD346t11x0v6A5TtpJlulo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/28] scsi: iscsi_tcp: Start socket shutdown during conn stop
Date:   Sun, 23 May 2021 12:57:20 -0500
Message-Id: <20210523175739.360324-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79e97ae3-86bc-4cfb-c357-08d91e144ccb
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB40040A95CE7E192C13C19083F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acKyvZMbH4BUfxo2tq6UUAjVIcXrz96zwmUIdg+9FHAZGK5nOm62xLA0ko8sbnHpRmCtCVjEtw1JpcAX1JG0x1GHueSRcjpN6wNNFSqgh8lHri/wtwhYxeIzavLVkUEBz4IWT4vDJxNOwH/xDAeDKci6bw6crjxli9LA90aWMskO7yBYgMYxE9RtZeigT9J6WXZHZjzEn5DhbxxlktvDpk1RIihfXOVQy7AFPjBVvTfyOewNUDLgo/EKhNXKgAUp5wSG24u2UZDWR9wSz6p5AcegafCCuaHOd2WfzV8d0lMF12heKGNkyRfgWNlSQDL+xA68fELkV/Kj1L8DN2exu4zbV8oextVvNmgT6Be7Ijdr4//oGt+KclFebX8/KVUBxgg5+cnUcu0mhO4+0hZNOiZATnOcDODtxO6+/wWGb2rZBGTKcepICNBlPpeSvqHqsTvTHFYpoo9onF5+e8CfP3ySgSREG2JAe+jgmw9pz66QNO68Q6I4kKahm/YUzPlu22i6pZlgDjg7Nl3sjtaSk4DPzE/s/NCResIzrKjZHmm3p3O6uxUePb+gcGZZsV48hM1aI0MOx3+hirs90f/eBVNT6Nal58FqN7UigdEIRfoQVoWCpVT4vQBogodcEZ9feIKrhE+n5mEBYNsLOFLFannJIWjuQYJKzh9FdNCr70u6chBKflboUNNInxNq2hn+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(4744005)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/4RfjN2LTB/tZV9s1YEqB34JijheO9XWUOQssrUV4gFWv7AuBIVejWAyVyiM?=
 =?us-ascii?Q?ttPRQL10rwYBkizsbHqG9KdVpYJ1kLHbgLAnjXXcvv0tX/Z7vIgkVEqa0xXW?=
 =?us-ascii?Q?8xH9MX0e2gaVm7qTZ1IXtaj0Qf6SHLSRjyzO38Eb5wLyTEUc+5mtFQjXDpZf?=
 =?us-ascii?Q?Qmy46zU2G4o4D/rxdCmD5Z2dvYvw7bN8M5gswY5n1WVzfiDHfmzjGW84+lcg?=
 =?us-ascii?Q?jknconicIhZLu73vUBU3QdH0YidRq1sg8OlWJeOAtTY6Ap/LmMDrGeUiYM9n?=
 =?us-ascii?Q?xYr0KtiISBE8DhIn864NbvhDv1XEpqP2IaQSifkhOzbJLY7yxdChsG2YQVL1?=
 =?us-ascii?Q?vZFOKeqaj7ywL1h7tP5Ey5Rm8hFHZoZXYw7BkVNdTRf6j9VO3vTf8mOsGRlt?=
 =?us-ascii?Q?Y1yL9xkOhRyGbrdmApgxK/luS9JeMFMVnHHKq2mRrWVw5Jzy7HobNRkhQmaQ?=
 =?us-ascii?Q?QuQ1vM8Rb3N/4sOnbZ7BTm+kR1mOuojXU9BwmoKNgaRt5Hv8/8b8MUe804r4?=
 =?us-ascii?Q?iO2iAkeMKXycN4FwA1Iuv7UO8cqXqYmhKMvgZq8c6E7Ny9yANIuR9LZHqZGu?=
 =?us-ascii?Q?h309lBIXHB3rPxD07dilEJWD6ZnillzlAZXfp/FvQQrkaMrlqtigK5fq9O+v?=
 =?us-ascii?Q?ThUcxYdwyec+DcYmJN/XZ8p/ub687kywSp6UaThLRAf0BBBgNwZRCmSpjFkM?=
 =?us-ascii?Q?LVEwp5hGGWhQy3pg/3dv+qtqOqWwL4CV5W3hRWaWpSyNy60N7DODzR/uz1qv?=
 =?us-ascii?Q?F79ZJWxyqUkIC0jas9s3S0FPzFJNlz9I8JtADFu+YBYc1XTYTwE/gzDaH/Q4?=
 =?us-ascii?Q?aWHdcEBWrl8eE66VXQ3JjgX7weJLK2ZU6rkNMzS8KgrkgjMfvGjO5nqYvPZa?=
 =?us-ascii?Q?H8OdPiPXCpxgVF885PS1AngE+bPT6/U6hVc+3rGm4GHBSU3IyfLoWfPuKXn6?=
 =?us-ascii?Q?6RuO8zfo85GW+M+PRKpmV9xFxqUn53JiHwvf04BgrHve86jsDo/nOA74CpP+?=
 =?us-ascii?Q?/UdFFewPIujInsrf/beQ9xAklVCo6Dzusj7QLePZshDqEZkCU/t1u6mHGofd?=
 =?us-ascii?Q?uNPieIOG8hrtwGEkXYWIm8P6qNnHIMLBu0q2HhjArJesKR/oin4UA8kQeogo?=
 =?us-ascii?Q?U2nqPAVC7hpKXdqj9L3C/XEj5VwbsurHjWDiJvxa+Pssyu0qwmVNjxrZe2QW?=
 =?us-ascii?Q?j+ke6uowEKRAh8DEUOMfbMalDPHwsh5e05xLZ8FQ109UGry+LMeLFsjr3P90?=
 =?us-ascii?Q?a9pvk+rAjLhdlYHHa5ufy9HRawITszcF3ibHDnNAppfHhGCHhB9qNn+7FaDm?=
 =?us-ascii?Q?3K/VVa4hiJsqg4qY2/X7vRLp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e97ae3-86bc-4cfb-c357-08d91e144ccb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:58.8206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: geQiAdd+jdGxC2cc5lV57FErsol6mfOmyvS1PILKyJOGFF864Rt7Q5eeRH5R+FyvgSkX8/pAc8lsZkCH1nVtryhgZpNutAFFdgSXP20Jq5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: URG4f_2yNiQfOH4YS1hWIinDdcLH6-1Q
X-Proofpoint-ORIG-GUID: URG4f_2yNiQfOH4YS1hWIinDdcLH6-1Q
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure the conn socket shutdown starts before we start the timer to fail
commands to upper layers.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 553e95ad6197..1bc37593c88f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -600,6 +600,12 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	if (!sock)
 		return;
 
+	/*
+	 * Make sure we start socket shutdown now in case userspace is up
+	 * but delayed in releasing the socket.
+	 */
+	kernel_sock_shutdown(sock, SHUT_RDWR);
+
 	sock_hold(sock->sk);
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
-- 
2.25.1

