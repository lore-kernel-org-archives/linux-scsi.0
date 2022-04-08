Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A243AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiDHAPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiDHAPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98BD139CF4
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:39 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237LnPHt024458;
        Fri, 8 Apr 2022 00:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=z+lctUVErpsTecQfCfrfieXbpW1F2dOzinioKIa/hU0=;
 b=SLQAzCYvpqcsZtlwNn4aygi94Q1kZm3gtu3NLqpkeI/6ErCticedNyAwWoZ8I1y/1BeO
 kSy/Xr06TwCP8hg6Gp6O0x6E74uOV396uuLVe4Xztl0FLtAX8xLQF2DiB6zxox75MmL9
 MNQxr8OSxKZEKOctXZvEs5ZcvwKbUFcdiK6v3No/Jm5hSxT0ftPGB3XgxveVOu7jIZ72
 Z3JbCWB26QW2AzwUWNsn2V+0FqCYUgkumUcb+Bzbnb/m4iiBUhZzDmyDn3gGBaNTekZx
 x4OqIFIHLEat+JK14nBOFh66NZwB8aPU0vXBz4KOSaXIWaa2LiufgxptdKXlSknEBia7 wA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tdnhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237NFHE3013838;
        Fri, 8 Apr 2022 00:13:27 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tu11q5-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEl9gX4veC1/g/5uHMVABvWVkY/vsfSOK/LaJ13y3sv+FyDB2+CqU3zchS4nK2vbWxeq+3gTuNuyM6+ZOEDHcsEDXLidYzDvtk0N//gqRpfP/E3rrg3Ru3O9W0UNRkA6cxYM70hhkNStuxJ01XcW/uWvYdzj3xQhS45gJbtalXrxqaPh7/oty9axr0NvG2Anl8ygj6kCaagC6EEZp3vb9EzdNfuzqtXNB7Ln8bbjyMxjapDunCWTTeDpugzMIw18bUn/BuHSLE84OhGYwo6xS3Nzk8Aay/Nn2Vbx/ESVxVJ6/vNVAh2P3PeIjBdwMSx98cvPLP2U9GJePqtLa81EoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+lctUVErpsTecQfCfrfieXbpW1F2dOzinioKIa/hU0=;
 b=H5RSfaIdSkhWKl1h+XmG6pmWNgcfGOj/iWejKNJCi9E9zevJcs2VMBNgOK7XlnO6uiOz4vXXNt6iinncm1MiCowJiLrQcv8TjSlB+OiGS6k4HEUZkCo0k/xJoK39DdTjZ+e4OhZTChfoy3nZk02/onIaTwYRmRlwjrVbK/QDx6aPLsTSehTBcrvzVAFgLagydp/yvBqmyUlap8mFm/NdiDeynvTfo0JAQYGnwUjQhvdSVzMCGnb9gUbiB24Onqsz6J+TO/r5xj4Fe2qByGr7XNE06+0efw5qbn+YNASYFz3BrpRk2FcylbdSHnvZpAuTecHGTerSpmsXiNW5GebEVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+lctUVErpsTecQfCfrfieXbpW1F2dOzinioKIa/hU0=;
 b=FWtaHhmF+Jl/C2k8zlPiZsxW8euE1IB1a7FUQwnDtAlhSBHih8HQmB9EcrmPMOg2rEvYMW6/5UYvl6+3w7xzJlVAL/MPI016rf7Pz5vOQxIIH4FRQaFS3GA+yJVEDb3gej29HMqD06to+fuP0um7982RsWtna4fVC/5pZuqSM04=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 00:13:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/10] scsi: iscsi: Fix endpoint reuse regression
Date:   Thu,  7 Apr 2022 19:13:08 -0500
Message-Id: <20220408001314.5014-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f4bd855-06ff-4e6d-5ef7-08da18f498f9
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55502F0E2ACAD46E6AA420BEF1E99@SJ0PR10MB5550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3vGZgqmpWTrnyGnEz4fsQWv9cx4HbHBYfFMNPzEotXJHr38IMSmpLrXHKnb2GgfW7C0Vj5irGLRWV2f/mI4hWqyiWqG49aX+QfUDdN7R8e6QH23tbf4SmwCjaAQ+5ufBPvcltUQGfQqvNadH9oZjHh0aAaS1YEzuw1RyRfuuayumxUIceF7+gd+AXR+fFklw1icWZLhvNKAKY1rRKwTJ++E7FcNTvB+VaPHscsjbcJ6kG/t02xN/O9BSO9w0XnBlSuf7HE83WHLCG2mhOlNiCFJ/VGi7JGtew0Q6RQY0BekP1p3Yd9f1/VJHcPI0OVPI9rHE3YIyy8MN+Iwslm/DhtXZh2C8SFa3ESW1pbbnT8iLPq2PiSe1zaYcCaYd4PMXsVtf0LDlrtIHxjv9NytqQuJfAgreV+7f2mtoc3uJz+mDyd5wOTF5DKCpA7eTk66XU5XJ8+hpCEhuVcc8BnORA+1o7/vuNWLXczNPHK8cf4xePJgdX9O6qyGRJUPKWx1nGqu8RZZEFpv5m+uEZ4Z/bK+vGldirIRlhQ3N8yTc8P5iTCGfYFkrMdXk3EincTlJ572aPQPf4G9NxbCC++xmczzwNJ4Dx/+RNzHTN9m4AwqoO3oEGbMHMefgfFPr622tYbN1Ps4OAzw9ZYwzRze/IN5DKquqUMyE020DMVlGAbXk5LASdge6pzl90F56IpxM36EWDI2qKNaEM0EDmbK7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(83380400001)(6486002)(86362001)(316002)(2616005)(6512007)(5660300002)(6666004)(107886003)(36756003)(38350700002)(508600001)(38100700002)(4326008)(52116002)(66556008)(2906002)(66946007)(26005)(66476007)(1076003)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pB/WUTdqHyil3f7497quVj0DRLkG+jNggymxBVXrT6AosKmlIh2MixWuI2ea?=
 =?us-ascii?Q?hcd2WnfTu4zCg3m/04CGqpiZ6wNaxGtGeNmImZUzzGNJ8rOL+oTacLbEcxsE?=
 =?us-ascii?Q?OtlH+XTHKqhqaMXbfoxi3v9iSe5C97HeXXmNahbccQtcNfui0WLrygzqjENU?=
 =?us-ascii?Q?anJBsRMEOGvx1T0QPKPU0zWKUvQ71u/mf2N4IzFmSxQHdMZqCxtgqhBWU917?=
 =?us-ascii?Q?1HyukkKz3CtNn3VtTK0vKBe1gMBH4GfLUImZg7TxhZLr9SxnU6YKlW/Xuq22?=
 =?us-ascii?Q?j2l/4fgqxn0BZLzbBfGne+ml9nLziKsOSWWF7u3CtHovs47g+ab/VopwYXlt?=
 =?us-ascii?Q?1TvrlWU/kVYF8hMVKUKGUtz19oCdfzaouXr+ECFyA/Z/joA6yE29eRDqwCSK?=
 =?us-ascii?Q?FoCH2v5AEi66jY5cVKCohquX6hm1uqdjQg2Ss6ZBWz3i0PMfNne5FCXAJ71s?=
 =?us-ascii?Q?ivnUvkM+9Kqzhh70jJac+X40qNpf6iNwQV7Q+V6nuLjWWIWmGwMd7Ubx6CwS?=
 =?us-ascii?Q?jvJYJ6s+tB18JF3P9vHBUJr17m4COoa4I/vgV0GkdAGsQJJwM8mouEX7j5an?=
 =?us-ascii?Q?lEqfZ6/YQ9fyKumRC3Y6gFm0u41WRw067XK5CwcX3edx+XsmUoQtAPPdOWIh?=
 =?us-ascii?Q?QE94Jlo0e8SjKQrFGJWjCiy/3QEQnbjDFYAGw1PKihBTsGxbsB4fSCCAUBqV?=
 =?us-ascii?Q?qIymRXPi+/qfSUaMQo/qjId+GK5Jwp4/b/CW+feb2daJggxD8XHl65eCT/qP?=
 =?us-ascii?Q?1GcOrkw7YIqrlUBlCUPleyiQnnhrDIahmIcyv/Mh+n6sKutcd9EVVru+nuEr?=
 =?us-ascii?Q?gt2ZxB9ZYVh5+1vv2kt9G1xQTLYdxss0lGgm89g0tgkD6s/1vdL+2FrmBtjF?=
 =?us-ascii?Q?ne0rbzrOoZrIm+D3CUuK6z7B29OvRmQG9kJbKIqUV93xfKQXqculZZRehSAq?=
 =?us-ascii?Q?O4SxrGiKI43L419CbMANhex8ZO/WDwXSwS8TrsaOuhYHp4R4b0OoYD1umKFP?=
 =?us-ascii?Q?phCCe4RCf1rnofhNXluv4i658JyVFni18SQBypgdCCeU7wFYgKPf591M+rDB?=
 =?us-ascii?Q?Apmyhu/qxkRTclu/GBTogoYw8rvCLUT4cMbH7EhtspIyDSRb25DLVAazv+A9?=
 =?us-ascii?Q?vqofXt1K6aiQIZsVAZaAoFl7OQd/dApKSVF807TK7OpQCbgLa+48kENWQBlx?=
 =?us-ascii?Q?pLV4Ke+DT64m5NZlKeBKY6N8ZIGJMSdNzy2HG0RKHJJX/IBrHduxCXJgyJxS?=
 =?us-ascii?Q?7S9KWVgnYuhiLnW0IzvIZOYWuiClY9lLVCYVKosGHrIoiAMue8IlfqMGNhVg?=
 =?us-ascii?Q?Am3eB9mxnfI/IMsKUJCmzwwsOvriFhV0k0BKCMVUhROBFWVTQvELwzpVMJDK?=
 =?us-ascii?Q?tccMsOK1XDyal7hT2dcr4YVgiAkBWRJrwelsWGVeKcovm7sNc0XDJ1zgK06t?=
 =?us-ascii?Q?oGmsLWDaYtKg5gy+hhOFh78ZeMtgQZZL6u+8zCu0EhHQ8lOAefE0hBQJGfaa?=
 =?us-ascii?Q?dJhWkdIFeFYCGOpmKx615sYG4HghTQS3UOcxI9H73/iX5ml5915S1URkV1aU?=
 =?us-ascii?Q?UBuA0RTIKa4n1hoCln9pMdee404KZTiqu75qNTEzIKox6p1PLACFJk8CECtA?=
 =?us-ascii?Q?leqwI7ZRyjIsX9tWWzAi+l64AFvN6+pnnHEs1TUl2OViyPPPJbaQZEY4iZ48?=
 =?us-ascii?Q?UzbPOkrtfhivn8LzELS4StEmA+zE428EiBxcNR0p0pDEYE7G6iWS9NxezkUK?=
 =?us-ascii?Q?z5LRxsV7jFZ5VZq0dM955kzzOW/n240=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4bd855-06ff-4e6d-5ef7-08da18f498f9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:24.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUl3UlGVeQvBXypA1rfpPC9GTvWDIzSz4UfAE75+eIZrQaWX0xpxc87qgGet4o1AqwQMi7gAAadUr9BLPPbAIkZ3Xkbg2+lWJ3V31v96d/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-ORIG-GUID: 8lzfut8MROhrJOxTguynvVCathBbcnlX
X-Proofpoint-GUID: 8lzfut8MROhrJOxTguynvVCathBbcnlX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes a bug where when using iscsi offload we can free a
endpoint while userspace still thinks it's active. That then causes the
endpoint ID to be reused for a new connection's endpoint while userspace
still thinks the ID is for the original connection. Userspace will then
end up disconnecting a running connection's endpoint or trying to bind
to another connection's endpoint.

This bug is a regression added in:

Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")

where we added a in kernel ep_disconnect call to fix a bug in:

Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")

where we would call stop_conn without having done ep_disconnect. This
early ep_disconnect call will then free the endpoint and it's ID while
userspace still thinks the ID is valid.

This patch fixes the early release of the ID by having the in kernel
recovery code keep a reference to the endpoint until userspace has called
into the kernel to finish cleaning up the endpoint/connection. It requires
the previous patch "scsi: iscsi: Release endpoint ID when its freed."
which moved the freeing of the ID until when the endpoint is released.

Fixes: 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 1fc7c6bfbd67..f200da049f3b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2247,7 +2247,11 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 		mutex_unlock(&conn->ep_mutex);
 
 		flush_work(&conn->cleanup_work);
-
+		/*
+		 * Userspace is now done with the EP so we can release the ref
+		 * iscsi_cleanup_conn_work_fn took.
+		 */
+		iscsi_put_endpoint(ep);
 		mutex_lock(&conn->ep_mutex);
 	}
 }
@@ -2322,6 +2326,12 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 		return;
 	}
 
+	/*
+	 * Get a ref to the ep, so we don't release its ID until after
+	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
+	 */
+	if (conn->ep)
+		get_device(&conn->ep->dev);
 	iscsi_ep_disconnect(conn, false);
 
 	if (system_state != SYSTEM_RUNNING) {
-- 
2.25.1

