Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1134C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244504AbiCTAqB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244490AbiCTApo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CAD241A0A
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JFC5UT018301;
        Sun, 20 Mar 2022 00:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=HzykA2JxtqDjqwULMFqIBXDcg3ZCrU7V5QSj7RW1+EU=;
 b=WKfaK+JqMkuFl+Ocs6Cf+uwo2jp9Epihyc4UjfFTnj3DDoRjt91pV2CLgYEq7V9xPneE
 pZFVy2jtdaDG0jV4fBj1/MacZvFGZBRUkks114PIFcemt7exefmMo4twdXeZ2vHIKSZI
 WK/R3+nZUVTW8y4vriKWUOJm5uvjgj2CB0udpvT7ixME7L0UTuXBEwVaLSq4Q8sJlxBl
 100MkJgR2odfcNi1HRiGTPWnnMzM0FHb/obBQ6Vi4PKpB9Gks7CoPAkluz+/uCik+H3b
 7MJFVI2aYSGOzXLKAOxOUGWCyl4uiGivGyXj296GqU22i+KHhKGi1BBP+xOjSn4mLGMf wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0gx7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffal137063;
        Sun, 20 Mar 2022 00:44:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGwYK/wTn013cKJ/DZeu8RHN2yjj1g1at9VU8bfBNPuwmTtUPWLcFxKkpaOQGniszoRxMRKfUdSjjomdPfn6quffMKnaqvnu+XQQQLUHrAJaUfPutftdAw/i3FRmPUi7TtutkhD3OVwGpgw8+GNvj9nilMWfSxjEUYAQStTf9UFUiHybx85AI52aaF7aXQzlbvUTEm3YkMYglVVlLQhxyxk4v+uXJN1RxgQTt/ACIjM27r8DGaSkBqIzXfea29M6aagsMbnhFNULVa1Z4VgLtYhN30uAiKflknxlzBBqLItpSi3zXxMapjHEOi5Bg0VS4FDCO92pHTYl0sE6uw/lXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzykA2JxtqDjqwULMFqIBXDcg3ZCrU7V5QSj7RW1+EU=;
 b=SGA0THXkM+jplBtq3I28ifP8nIiYJPSQn8351HX8HbWq6KNBH/Lm1DYGGYXioS35MJYnT2gvgD9AGNJqRi5QE4FJr28pmWprJP5wR0k8u/BGIFKFNwckeimsVOpF0nhsqD28ngWY3onLdMhIX/oMTteTz5/D7QocrYh7wGBPY74gii5xwJYTvUvQSxXKEopslCeTL4jx3rLcKKBJ8UOBVKs+R8fhDfN4heT0HKnJBydnCXecwVY1tA73YqboyCM/ATIkyzJUsl94+NcGabOmYLIxkI10MyFUMwLOfqz3QFkG9TiAJE7Bdtyln3FgxtVz0HODWa8vaORdIU3ekBPEJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzykA2JxtqDjqwULMFqIBXDcg3ZCrU7V5QSj7RW1+EU=;
 b=Ocj2FI3gpgxmd8Q/pavWiHWiwZbsEEkFJblxHABG6X4pllua0ErQRWuYvgU2lp0uYtDy7QTAO2DdJjPtN+zxGkzz/M78OfP4CuFId8fChuLu9Z6gwETqBrfs9MWyk1++sbW+LLBb6F1y3bn3+ji587tos23PTlY7+ALrpnltcSg=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:15 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 06/12] scsi: iscsi_tcp: Tell net when there's more data
Date:   Sat, 19 Mar 2022 19:43:56 -0500
Message-Id: <20220320004402.6707-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88a19c46-6e96-4931-fcba-08da0a0ac20f
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB399241A0EC63EDAB63744D61F1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BczHYO72D95FsFHYlza2giJYIEd6pWcDX4am1JPb4/qcS0AOnWQqXAg2gtf8hyamcACvhVStFFwCtLklp+Wz46jsiub37TQkKv4YlVS9Zk33NQEafBUhBJq/GmQVjvWEuy2ptHNtIOz6N7FeAQFi+zfdU+dCLB+v8EyWPE934Pa5bZZvvEZy8Zt2Gt8e5UFUhMJxqhoPM6xjRPKN14qpE0Q6mnDzaYd8NMnmqoiB9rXGdHs/SIpe6VV+GtUb2p8mF/vu0D/SLFZ5MgH/KADL23mUA4JfzW85FwfqhEk4hF+z3qUSQ+AnpDDUL+VizQS4ZVC+++wKuDb/sFFfL2wFpTnlHLguXY/qpVQ0W7Wz3F1MdJX/I19A25xb4WwWazuhvJLNoGkjoMSFVe55QL08LM7LlJwrEy9ouxZNklTN4AdIfZIgVzclRvLJHZNVB36kQ9Ttzi+wegJN+xUObhaoAWl2jCzLdZDM7Di/KbYS8CHz8GCLoakE5g3aQb1Zq9q6OFethXkC24pcbIT/Mzg7TMRf3UqkUgaHwUTkdCHzhOtCHhxIymYAZ9UDs7MB22SrP4W2JenRlx7MkPMexr1lV49dxYl4h5eb8NeGS51I8BnqOn9tSyZ2OCoOr/1TDv7mG6hV9PRlqgCt+cwmG1A/1YCB+WNdYydsTpbrYz4ridZ9RGG6l92X+IZcWaYdhpx1AzxSsIXWjh2kkIYr8xpROg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(4744005)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JNiDF/n4UM/eHduzIFZL6GQyCE5jvC8/8Zag5m8H4Uhpr4WwAw1qrQaBF7Hz?=
 =?us-ascii?Q?31dgVlEWf8XFQNr1oaCrBf2J19uXVxpWDVlyudIKtyY5kuQPYtoqRJaYKnd/?=
 =?us-ascii?Q?rXobZpsjVyU8j4LabdkwAJo0YBFy9NjeqR7TAnfJ36ajyxu8FgZijxwQjy7B?=
 =?us-ascii?Q?KH+uuqWRFrmOPRyVmO8Nwm4SRaCCwDjbVCgaJgxS03ZNtkWbjuGTf8KfqEVL?=
 =?us-ascii?Q?XXQ9KuSYmxf+bLyUcWMKR4le15d2QV0OFJuLoSnb6lvXFEo1ZHBzLDZog0Ee?=
 =?us-ascii?Q?9o48U8asrXqxTCt2xpVLdsZBgcVo3PmrGUJRfu3W76XkEd6yopPuF30fWO5T?=
 =?us-ascii?Q?3twKhsRecX08NP1jMIESsZHXPh+RgtU6uhMSJ3GKv6Fe1Z0IjCrZ0WZW0TbM?=
 =?us-ascii?Q?JVFS1KwVoogpxvrPlJB7UUJdKx0kZppIuwbL2aMYIVZ6/1n+/SE/uaMlcnyE?=
 =?us-ascii?Q?19mVb++iRFiJYF6RJ4H8op6Fv34iYfp0ZcuPNBQZ4buCORQqaRbDIOMNs5od?=
 =?us-ascii?Q?Pv9AWKx2hiSV1L7ojUeIDTgLubMZVIFfI2ymV5MkuJOJjYQubDbrr3tk/2g/?=
 =?us-ascii?Q?dJj6nce2DhCm8xGEZ4EbxdtOcjBB3ujkeJ/X3gXWXTew6ciRcvx1ym/E8LEZ?=
 =?us-ascii?Q?PMR9XUDWHcRemYN1YrTB+IX8tEopXrQ2x7snyHaYP8V2RC3Bfq/rgBKQsHac?=
 =?us-ascii?Q?WsdltD3K9UBUaApH06iHnRStVkWO31K971CEZsdFEXH8RZSqCC7AEjnwNLbu?=
 =?us-ascii?Q?aZELXEgne6x4Nk/azWc31kbgYHXG+sfHnMbqAjZ8axQf+QE9O0aKg7FFxYqb?=
 =?us-ascii?Q?BbptVIAtauMZ8eJC1lnjQW7sBwPL9WG/jOg/S/oPOV0k2yTQuZkvjgS5CNXn?=
 =?us-ascii?Q?vrHtzhow5rdvYFaxFjfwKMjPbgZ6lnjWOn5EI6vMEDLaZEatpS0LrHImGHSP?=
 =?us-ascii?Q?cHUpWBmBY36U/FxS6bQnvXXZtVaY9Uu0FZgOKtg/kaH2lLcAAI/YL+qRur4L?=
 =?us-ascii?Q?Xo3hdpgXm+Zxgj1DhL5TqxRDvlgAlj1p8mLyqnM/bNWRNrDMHM3ANzWEsyoz?=
 =?us-ascii?Q?A0LhoOVImXMHwqtd7vQ/nVaGREN6nFh42g5x14HNKUz+MdBlnu2ZZwYpCv2C?=
 =?us-ascii?Q?8aij6DMy9O6V6AY6hBmkCna8lasX+AknDglbmn5u0uE5BMOG5VyEfrza/KEi?=
 =?us-ascii?Q?b31FHkN/FQ/UTB8Zt1Db9zDbulQBcyLv7NpqhaI6uZPi64CHcIMyyFgxroZH?=
 =?us-ascii?Q?TjFSDRUAfb1iUOBWhzBGVItHUyf9XlsLafccmw5GyLQx6j+4JrZ7KOhoD7Gq?=
 =?us-ascii?Q?sUu4QuwTg2lAOeH/j0lcEI0HldyXlDiDvkC1shGdiseiNv6AIqAW/FVFpb4A?=
 =?us-ascii?Q?AJegG+ujBGBYwTy1kSlvHUQfzJJd5zyfa4LhYOwkRKkfkfiVdaZYDI69jPwh?=
 =?us-ascii?Q?x4Lk5SmBMAePagIdqm7Y+1ewqMchX9mBgxFRjuSzo9QMeNAgjZyXWw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a19c46-6e96-4931-fcba-08da0a0ac20f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:14.9687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8jx6F8n5pVVt4OkFBB42Lgr3E8l2n/AMdrqeYqT2mm8nSyKFVc5/47ZE+zu/N6LHIlxuhKHQIT5xGAmjQLTTGeAt7AE/FC/veZcUuaAMAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: qW0f2gF_aOTnxbRLlEmIGO3rb_0gqjyp
X-Proofpoint-ORIG-GUID: qW0f2gF_aOTnxbRLlEmIGO3rb_0gqjyp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we have more data set the MSG_SENDPAGE_NOTLAST in case we go down the
sendpage path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4e467918f4e2..067f71a418c3 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -306,7 +306,7 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		copy = segment->size - offset;
 
 		if (segment->total_copied + segment->size < segment->total_size)
-			flags |= MSG_MORE;
+			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
 		/* Use sendpage if we can; else fall back to sendmsg */
 		if (!segment->data) {
-- 
2.25.1

