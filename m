Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41E0C61DA4
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbjA2Xp2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbjA2XpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265831D934;
        Sun, 29 Jan 2023 15:45:21 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TNQdlM026353;
        Sun, 29 Jan 2023 23:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=UAOM3vcZf58l5wnwQL20hV8PvS3Q0Og+t3+1eeOawxw=;
 b=ZAe4KVbYaFiO5arFcDXEb0xykt9Bw/wY0w5owr66KRypBAOkK+3I3RFmaiuX/W09hVbN
 WPOpjk7gMxhbocHGxHnLzfqSEOjcQ5hPJMl68SQVRzJsZSjEoEDSP5639Zt3ZPI1sHY2
 vyEKlUoOQzk3Xd/J6tv2DTpniUaQqWSwtH69/T2jeCuNtoFGeTg3ecO1gYen+vnCOhds
 IvJXNj77lEuK2kp4i28/k/pUq5mS44EumYpiB/05pR/N5DEoL7fl6y3gbbSu1dcqPZGt
 jQUNm0VNCFghCUiwc4Nd6cRZE2K1gvvw2DIpbvQR30gQSETRql6a9gzpYHGC1c+lQ5r7 nw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvmhhrt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TIZL1N019074;
        Sun, 29 Jan 2023 23:44:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53n3c9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDXjVyqObAmxtmBISNd4TDfbo+nMqu6T7XFy5vIXWNvY4fGHQVg4o4tJQfd0EhmaonjsEXQO85Vqw4KvxN/uUujRSQ4b6z6CItyJrDR6bjlYiYBlbrEGBIFOWlwW8ZaHFanOUKFZ7SYzbq/bY4ZytvjmXGiIJ8nhWbqQgQHIJM2JMFRqZ4j9Qj4I7OcjJ8AvtmH6IcRuHITehehwN/gVavkqNFqdMXfxlfRgWji+XXyditclpzRtv8N4ulCPoGEC9n4hjYsraoBuFowX9IQX8BpPvoTxRZZ8dOy5qvw70U/vs7lLk5ahKz0PoMjv/bNDPO5wsJtzVOLh7/INE3xtsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAOM3vcZf58l5wnwQL20hV8PvS3Q0Og+t3+1eeOawxw=;
 b=PiBb4UG0VhmXOSmTk1oLg4XoqknI5b+2gfgA182+sPmm5nU76P8n0gRzwqewhzZhNF9YnNIByqJ2lxVyVhRfOCeYmyo+/mgkgLE5gxDFRunf9cO4FkgJ3QGlFNFA5NiIXEEgjrn/efeAZtqRS1ilzkJQWTgsxqxML97418SOcwuR79ne+MT8TE13ryDKA3ehpeYQTG23zy0aa4g6yDUuDNPDqew8nnfxCBl/2Ies5poTVuds9jziqhyyWHLsvYDZGibqo5xwuN1UqTRL24iaYk3nqKzNUFd5Q5KOgJ3WyL1WNBgt85U3MEMpsz1NZ/QXFqKgEKh3Q7Gqi8WGNsR53Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAOM3vcZf58l5wnwQL20hV8PvS3Q0Og+t3+1eeOawxw=;
 b=PEzXfcX8cm9yNsybobpWT08t3/I1tNwR8Aobt/KipBLL+tDcOqbuAAuYtKG0vzVjktsHiQB/BhwLWUthyfPmW+NuQrpb7uadcK3wat0PKoc0cai/VaIJj6yotOxe49XIohPU652BZNBC5iR/eSiAq/TURrtZB1qLC8/AJ6A5C3U=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:44:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:44:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 01/14] scsi: target: Move sess cmd counter to new struct
Date:   Sun, 29 Jan 2023 17:44:28 -0600
Message-Id: <20230129234441.116310-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0147.namprd02.prod.outlook.com
 (2603:10b6:5:332::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: ce05efab-0a52-40ac-1289-08db0252cd2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oO4yrTEByia1cVvaDhjsBFVsA1zOE+XhMZA0oenzFNKWgKwObf14ynUSmJvWQ6VpDRI4ijyqvg59g41Ncx7CWdX7HysZspqClwJFJnDKz2EYX1FrPpXN5VbPMFPOHGWye0L81dPpm0BAiUrayPMQMxHfW2OoxsmcwkyNsrUvkBVIkpVjTZy78rSoDBXAYUTS0SE6HuLjiydbAMMlvQokf9cATC+qDa+iYeMJ46zbJpZ+yW+mrzMQhTiTlMg0avDjbIss7uMAuBv5LcA62cyKrVNlIqZvrDjntDNHOyQLXAT+xalRfz/xIJQqlDTJlC3WLkzV5wlUYPao6qHlraUfOVL77Sc8N0EPeNfzKQ0w6hw4QbWQJK4SsxsMsnt9HI+de1TfJveuJJ5DyRBjWqrHxlV4qzceYMdjp2RmoNE0VxmIOJyF2a5l8LdupOUxnfD9nOs5nYQcU1VELw58jE/kws6GeCHTMC/UdOKhhPELS5LmUJas/WTU23Arhi6q3CngyqA+W6zFYkwU0kbVGpCNMwkex/t7ggb3lW33BzCXUrQMS+0J5uF00u63mwDwahmmEBfCHPKcO8PR+khO08UcsxLyD3OimnPOZv/UQ1sAiVEgqRSGfyw+lYfILqan0fDjzd0FbXY/4dBlaDbSEnY72w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/rpbL6EroER01T25LUPoRtqmCcYQ4Adru3Pv3N9SWOb3YxEMIYhxe0NsLzGm?=
 =?us-ascii?Q?oUnmFa3DXWhGHRfuF+RUXflAiK0CxxGHDqnnhk2mRVxtTOGDB8RU8QUhtPUP?=
 =?us-ascii?Q?Zkq3632G5ANYeYAmWTOJotwJoBr7Xiv+DM8A+tL8feq2nd0v2akOIv+lTy38?=
 =?us-ascii?Q?IvCZgq9EIpzJTMjCnjxcZj/yqRasvVnC8lKlGN6gDzu4J0T1/Zn4QjDHMSgm?=
 =?us-ascii?Q?kdIaM5Qv7/++RKZyG9Gl6LP3u0Q6hMlJ+i/wsoT/UwNd2yKOsPKNvOabab+v?=
 =?us-ascii?Q?P5/Jh0dRJ26K9txpGbxFg1RfAn39qSyzANyJZ0HgrXzqWBTj2ofBiDIt2ckA?=
 =?us-ascii?Q?OnEtiMrknVDRJzDmQv3i/f2BMfeJTx0J7YtLJo5dZOdfqCo3W9xqO2PfSm/y?=
 =?us-ascii?Q?/MWTJcBGnNmHJEjtexyZlwsJWMmCd//plBg+eojCXQt4uIioQ8baJbp9Ft/S?=
 =?us-ascii?Q?9Lg75yAJtsGCEjKhHNRX5jdymCMVBfzn3OOXlvsaJEKcCAObYpIbeSNSUZNw?=
 =?us-ascii?Q?AwEPlXN9DZDRjwQwW4ZHaCchwtKguBrHdcYqRXzQXakksT1yUKHeYcjJ/0n1?=
 =?us-ascii?Q?xm7ajLUrNjQa/+PHFltfLYZ6I3avgxcCP+xF5i76qyzkOPdEURMyQi4wKTNG?=
 =?us-ascii?Q?IiMDlxGkkvLC3LX5YmY3XzD5GCNTkohaxdNYqlG0JJiuTWgU5s2fKBTkXY8s?=
 =?us-ascii?Q?BrIMLLYlKwfJ+bHrA7krs0mN/xj4GGzOiUEx2B4KDBXadtPffJg6he5Sr8tn?=
 =?us-ascii?Q?nvZwvZeb3zWvbdhFdLhpcJ0Iox9kPaG1T/7pVoPlkZOWpZIWRc0KdFnVMVlo?=
 =?us-ascii?Q?qm9uJQ6xO2jaKAwns1jeLQLc89Ke13meFIF0rg3dJY8yCwERyuvSKySIPAx8?=
 =?us-ascii?Q?WepGOb309lIxz6NczGGofb8FrsVvuMuPti/y09xvvKUnmE73apwMHDLkUdAr?=
 =?us-ascii?Q?XuD7AjTqPQkWGCn0UzbNKI3mm+KWzYytmCe+ebmMbxk2VpGTnpDtAlnp3ps9?=
 =?us-ascii?Q?FP8CPNuj/kLkZnhdb6tOHICXXYaB7aMgxdJ/H4kWxcLNzFygAcEvNpn8RwJu?=
 =?us-ascii?Q?e0CIdZg7BmSckAmaRT4AzA9ZXTefEOFF/+4zg+Cj7l1zw3yUpAARcXShPVqy?=
 =?us-ascii?Q?y0P7DxQRO/c7/IMKQVUxlAFTegM1BX9ZyD48FrXU09ha3h8XrwxOY1tkX38P?=
 =?us-ascii?Q?ySEC8b9VquX6bmNEBXaNACaonv333hJMNveNPQ8chZzhp0Xe/Ix75qqYtext?=
 =?us-ascii?Q?2WzXn7rGhhY+aw/DlZcfLHeEHWqp1C7dF/+sYZ8ckBREPRdvIBrde70eGZOe?=
 =?us-ascii?Q?r3QN+KKFzHkIFtMHupoaKKR3h08/o1wZNyjpzqDShrZccEdsNLB7FQaAJsIS?=
 =?us-ascii?Q?5NOrVuf1dd+yp+qAphLCTZEt8OnbChmk+0jkdTT6ZjDC2WLIO5hsXVE5AIUe?=
 =?us-ascii?Q?hU2xtrR4fWFhujq8ijvoebhBojeBtt0iIUg7hCFZ7sIUuzeuqJQ68Y2bCq1R?=
 =?us-ascii?Q?y2CMVhxJltROFFY0S0vMz6MmAAyER9uPkPdA6gSl3ouNTuGumuNrop+U2OXf?=
 =?us-ascii?Q?HVDBZjsZyf5k4wC/kXJ3VPVeLNbJzY9EbFNtYn6FZbBkBVYnoK+xEoX61Yeo?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VeJFykSKsAN/9aQ3wr4GBqAWfEMmIJtfc5VsMajSkSALSzFzSFUJKAIkYVxSaNgP89C+h0ysqjwdKRIdfpsrpb7btdFDCZUZEXgstORQNMfFmoREcVIKLORrtg5u9EhPMkisqWVP7kUw10s/3+dNQ9pzSCnZ87RLM/CQIOA8ilixWpG4o/JidUNgx6VIerqfItHo3RDgQbLpytEydUlfREPKIvzUKUTiRVzttI05VbX4ImYZrbFHnNoSfU0kcmSrv2R0NGc0KvhdbPoE7kFVzkK3jke456mZlgSL4+/SVQrCIRgBatxNVsWAgQWggrLnn8A8PUiv8yFfi4Kro9T2N7BXP6/gx0OZTWZpAn6WdAvbq/rKxMCY3gDC9wjmFqZ7W9vRReAcAihmj9uLq3bWfQtfVSjKd05d9ABH5UfcTLsgVy40ejGvARdKygZ0qJCuBN3JIhlsTliLXzvhHG6SspFraDfPuS/ms1w6wYVsu30kRrkLdXLv+bz7pkvhyfztYyaBCQMU4qvEEB2iNpXXc2lREyeagyPtq92Q59YsYmgW0Fm5DIchCtYZk1vkx6l8u1BdMDHV8Ok5V8xIjLuxr3gHwmlrerM2iJgzNSEZ9gc10I8d83bMHVbNOlFDgvxy/2l0bTbbS5g09v4VcuyOc92H1S7OVd33JUiDd30o4KY9WXnOW7G/U5LfjrRxjH6FrGdugI1ARnCX7mayylAzg5gvyizd/ZUSg4109u8xObRQWtKB3rEs05cOrliBo+KZser6DduoT5tpSrIZdwMoIQYWewK5jo/quoGuS5IaJGMquS2GOlqiI/oXWiZH2n8QUz8vyuzd6cmOQHPCXfT0e2KNA+I/5WLQqhGq2uf+WiimvIuuUe4Q2yquw+Vb2AOq
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce05efab-0a52-40ac-1289-08db0252cd2f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:44:45.7607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djdwosTCXEEw3PvLmJH/ZDkIVWuJ4K/Xh/OYWmy40FwIA6h+9MwoVT01qwt2LjMsP08NqTCUyafiDvwVmsyOHG3V2CcC18slTe9bVHPDRHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-ORIG-GUID: bsclvWwFCK0tRRHDU18WLDH_uS8o35dv
X-Proofpoint-GUID: bsclvWwFCK0tRRHDU18WLDH_uS8o35dv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to wait on outstanding commands like how srp and the FC/fcoe
drivers do. It can't use target_stop_session because for MCS support we
can't stop the entire session during recovery because if other connections
are ok then we want to be able to continue to execute IO on them.

This patch moves the per session cmd counters to a new struct, so iSCSI
can allocate it per connection. The xcopy code can also just not allocate
it in the future since it doesn't need to track commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_tpg.c         |   2 +-
 drivers/target/target_core_transport.c   | 135 ++++++++++++++++-------
 include/target/iscsi/iscsi_target_core.h |   1 +
 include/target/target_core_base.h        |  13 ++-
 4 files changed, 107 insertions(+), 44 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..8ebccdbd94f0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -328,7 +328,7 @@ static void target_shutdown_sessions(struct se_node_acl *acl)
 restart:
 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
 	list_for_each_entry(sess, &acl->acl_sess_list, sess_acl_list) {
-		if (atomic_read(&sess->stopped))
+		if (sess->cmd_cnt && atomic_read(&sess->cmd_cnt->stopped))
 			continue;
 
 		list_del_init(&sess->sess_acl_list);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5926316252eb..3d6034f00dcd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -220,11 +220,49 @@ void transport_subsystem_check_init(void)
 	sub_api_initialized = 1;
 }
 
-static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
+static void target_release_cmd_refcnt(struct percpu_ref *ref)
 {
-	struct se_session *sess = container_of(ref, typeof(*sess), cmd_count);
+	struct target_cmd_counter *cmd_cnt  = container_of(ref,
+							   typeof(*cmd_cnt),
+							   refcnt);
+	wake_up(&cmd_cnt->refcnt_wq);
+}
+
+static struct target_cmd_counter *target_alloc_cmd_counter(void)
+{
+	struct target_cmd_counter *cmd_cnt;
+	int rc;
+
+	cmd_cnt = kzalloc(sizeof(*cmd_cnt), GFP_KERNEL);
+	if (!cmd_cnt)
+		return NULL;
 
-	wake_up(&sess->cmd_count_wq);
+	init_completion(&cmd_cnt->stop_done);
+	init_waitqueue_head(&cmd_cnt->refcnt_wq);
+	atomic_set(&cmd_cnt->stopped, 0);
+
+	rc = percpu_ref_init(&cmd_cnt->refcnt, target_release_cmd_refcnt, 0,
+			     GFP_KERNEL);
+	if (rc)
+		goto free_cmd_cnt;
+
+	return cmd_cnt;
+
+free_cmd_cnt:
+	kfree(cmd_cnt);
+	return NULL;
+}
+
+static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+{
+	/*
+	 * Drivers like loop do not call target_stop_session during session
+	 * shutdown so we have to drop the ref taken at init time here.
+	 */
+	if (!atomic_read(&cmd_cnt->stopped))
+		percpu_ref_put(&cmd_cnt->refcnt);
+
+	percpu_ref_exit(&cmd_cnt->refcnt);
 }
 
 /**
@@ -238,25 +276,17 @@ int transport_init_session(struct se_session *se_sess)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	init_waitqueue_head(&se_sess->cmd_count_wq);
-	init_completion(&se_sess->stop_done);
-	atomic_set(&se_sess->stopped, 0);
-	return percpu_ref_init(&se_sess->cmd_count,
-			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
+	se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!se_sess->cmd_cnt)
+		return -ENOMEM;
+
+	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
-	/*
-	 * Drivers like iscsi and loop do not call target_stop_session
-	 * during session shutdown so we have to drop the ref taken at init
-	 * time here.
-	 */
-	if (!atomic_read(&se_sess->stopped))
-		percpu_ref_put(&se_sess->cmd_count);
-
-	percpu_ref_exit(&se_sess->cmd_count);
+	target_free_cmd_counter(se_sess->cmd_cnt);
 }
 
 /**
@@ -2970,9 +3000,16 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
 	}
 
-	if (!percpu_ref_tryget_live(&se_sess->cmd_count))
-		ret = -ESHUTDOWN;
-
+	/*
+	 * Users like xcopy do not use counters since they never do a stop
+	 * and wait.
+	 */
+	if (se_sess->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+			ret = -ESHUTDOWN;
+		else
+			se_cmd->cmd_cnt = se_sess->cmd_cnt;
+	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
 
@@ -2993,7 +3030,7 @@ static void target_free_cmd_mem(struct se_cmd *cmd)
 static void target_release_cmd_kref(struct kref *kref)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
-	struct se_session *se_sess = se_cmd->se_sess;
+	struct target_cmd_counter *cmd_cnt = se_cmd->cmd_cnt;
 	struct completion *free_compl = se_cmd->free_compl;
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 
@@ -3004,7 +3041,8 @@ static void target_release_cmd_kref(struct kref *kref)
 	if (abrt_compl)
 		complete(abrt_compl);
 
-	percpu_ref_put(&se_sess->cmd_count);
+	if (cmd_cnt)
+		percpu_ref_put(&cmd_cnt->refcnt);
 }
 
 /**
@@ -3123,46 +3161,65 @@ void target_show_cmd(const char *pfx, struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(target_show_cmd);
 
-static void target_stop_session_confirm(struct percpu_ref *ref)
+static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
+{
+	struct target_cmd_counter *cmd_cnt = container_of(ref,
+						struct target_cmd_counter,
+						refcnt);
+	complete_all(&cmd_cnt->stop_done);
+}
+
+/**
+ * target_stop_cmd_counter - Stop new IO from being added to the counter.
+ * @cmd_cnt: counter to stop
+ */
+static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
-	struct se_session *se_sess = container_of(ref, struct se_session,
-						  cmd_count);
-	complete_all(&se_sess->stop_done);
+	pr_debug("Stopping command counter.\n");
+	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
+		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
+					    target_stop_cmd_counter_confirm);
 }
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
- * @se_sess:    session to stop
+ * @se_sess: session to stop
  */
 void target_stop_session(struct se_session *se_sess)
 {
-	pr_debug("Stopping session queue.\n");
-	if (atomic_cmpxchg(&se_sess->stopped, 0, 1) == 0)
-		percpu_ref_kill_and_confirm(&se_sess->cmd_count,
-					    target_stop_session_confirm);
+	target_stop_cmd_counter(se_sess->cmd_cnt);
 }
 EXPORT_SYMBOL(target_stop_session);
 
 /**
- * target_wait_for_sess_cmds - Wait for outstanding commands
- * @se_sess:    session to wait for active I/O
+ * target_wait_for_cmds - Wait for outstanding cmds.
+ * @cmd_cnt: counter to wait for active I/O for.
  */
-void target_wait_for_sess_cmds(struct se_session *se_sess)
+static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
-	WARN_ON_ONCE(!atomic_read(&se_sess->stopped));
+	WARN_ON_ONCE(!atomic_read(&cmd_cnt->stopped));
 
 	do {
 		pr_debug("Waiting for running cmds to complete.\n");
-		ret = wait_event_timeout(se_sess->cmd_count_wq,
-				percpu_ref_is_zero(&se_sess->cmd_count),
-				180 * HZ);
+		ret = wait_event_timeout(cmd_cnt->refcnt_wq,
+					 percpu_ref_is_zero(&cmd_cnt->refcnt),
+					 180 * HZ);
 	} while (ret <= 0);
 
-	wait_for_completion(&se_sess->stop_done);
+	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+
+/**
+ * target_wait_for_sess_cmds - Wait for outstanding commands
+ * @se_sess: session to wait for active I/O
+ */
+void target_wait_for_sess_cmds(struct se_session *se_sess)
+{
+	target_wait_for_cmds(se_sess->cmd_cnt);
+}
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
 /*
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 94d06ddfd80a..229118156a1f 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -600,6 +600,7 @@ struct iscsit_conn {
 	struct iscsi_tpg_np	*tpg_np;
 	/* Pointer to parent session */
 	struct iscsit_session	*sess;
+	struct target_cmd_counter *cmd_cnt;
 	int			bitmap_id;
 	int			rx_thread_active;
 	struct task_struct	*rx_thread;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..bd299790e99c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -494,6 +494,7 @@ struct se_cmd {
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
+	struct target_cmd_counter *cmd_cnt;
 	struct se_tmr_req	*se_tmr_req;
 	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
@@ -619,22 +620,26 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 			acl_fabric_stat_group);
 }
 
-struct se_session {
+struct target_cmd_counter {
+	struct percpu_ref	refcnt;
+	wait_queue_head_t	refcnt_wq;
+	struct completion	stop_done;
 	atomic_t		stopped;
+};
+
+struct se_session {
 	u64			sess_bin_isid;
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
-	struct percpu_ref	cmd_count;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	spinlock_t		sess_cmd_lock;
-	wait_queue_head_t	cmd_count_wq;
-	struct completion	stop_done;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	struct target_cmd_counter *cmd_cnt;
 };
 
 struct se_device;
-- 
2.25.1

