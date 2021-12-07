Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FB5C43217
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhLGCzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54186 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231868AbhLGCzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:09 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5GdV012529;
        Tue, 7 Dec 2021 02:51:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=WpJwM0XnAzdcT1gIhNOmvdnESVRp0Jp8i83DqV1c8g8=;
 b=n/lpzALwbk2BfhvMEbXkl4Jf59pDlOTiXj4/B9s4fS6g6Wktf7e1FeyLgbMg60mbmsKr
 cZ9Njaegk01HO7j+XV2Cde8FhPZSXxcennT5lZIAXjP+auFsS7hj87IIHGS/XA6nbXYc
 YiI4575VSDhUC301/LxwSwvqB4XGTHkYo9KadLGy6exZFpIi08QANIPibMa5YfFyCAPG
 IgTAlXWC/Q4oqIC9DugKd2u5xi08WrTtbvLb8G44H2bDO+47G4QU5tkuNxbL8uDcSJra
 73+OFDi5wfetni4hHp56lO4zlB5so5QW/FV0qeb4BXKfqV301yxCCXwecIDChhDPiFTv ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csc72c35d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kh33153049;
        Tue, 7 Dec 2021 02:51:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w80-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFqnET4kqrrYFMUWvXqFdWgqdVjjf9pd1bIuW8q3oyLktnxwUJ7Y3092uxXlNol2Bv4ZvAgMrwvWJJGcOQCWDh9YyI48kCdUioxSZ+FfYeL92xpZy4acn4KPFa/IEi9Pp4c8omC1cHsi4TmbpZ15tkjKnjhrQGKEsuo6ipQkxyBwUfjJmOHKUgEmTdLH9I6X4sT/e5xd+UNq0GGIfp+S688047rXMscYnwOYYO7z+bjDfmwP9c2GcTlOZUaLe52GaAdq5zodeUaes8x0WnU4pSedDTjPIVWtyalkPF7qE9zk9lAsvLqErW+ihaQOeyPLpcXyg88iiWoagor7k41FqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpJwM0XnAzdcT1gIhNOmvdnESVRp0Jp8i83DqV1c8g8=;
 b=OuQc4fyrSYkhkev+qAfuM5xvGueEts/8ehy5TO2iG+YSlrvOvVF7YVpC5ibFYeQ5n2nPkta/4IPYPuPm9wiYUvtUToeVLBAkxGqbNzuVQKsr/wTqht0SlvaTq9rCedM/XmUiVOaM6kw1AB+DznQtozKXJ4V3DeBkLP9jVwP32vMuynq9M1bRLL4fXTS6y2jQ/xnc1bq9TJT2bECxhhqK8r8cVWvg0NSMnuDp9ZyPcPEcBaLC/z8bWEvpnw/Wblz0MG2Cwf3Vkl0FY9T4S2lT6io28V45navSiXJuRcGS3xKzS2dVfiItyzHV8F/qeAY41dUYELrOgGwtfgvGDaoKpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpJwM0XnAzdcT1gIhNOmvdnESVRp0Jp8i83DqV1c8g8=;
 b=PEdAKbbqYAuxd58jz7/NCkffSD/83oietLbk5apF9UOGKOEh5vy+BmIuU9HMoNsPTSqAvCUDJRNv8U7DKpApKs5eAtep6BzKxbsGI3k0M8hV/+KluMfhLieHitxQiQnLTTAymPetaaNWCNeM7lhzUn0DtZvv+g0gTIizp/buiYE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 10/12] vhost-scsi: flush IO vqs then send TMF rsp
Date:   Mon,  6 Dec 2021 20:51:15 -0600
Message-Id: <20211207025117.23551-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6d6a283-3125-4a5c-a9e4-08d9b92c7864
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4347591FE2555EC1EA83F998F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VD4n9OgKRlJbLNi2yd1YHwunteqNYKUHFlRg4bS45M1SiN/wG39BCgTbA+bbhNP+8ctYJTxxiL5lxROodo6TND6VGONF9jIzBbv0DMrx6yEymdMXYwHlG27XN+5PoBx6e7cGwIkysR0RnzYqgic6mcdIC/w2PY4n9ugmAKH0plBvP79+4k3Tb0NaNPIOnIaaGodDL8Yb9LA5LE6VEMgcKC6bpOZavkFvJIGh6GmXbGtu3CSJSlOfAJfuXnlqle5Pc1cbKrO5y3Pv9j+T1/ocoTU7fZDJjqMqpZpQxaDzcpfv52UCyXrtHSf82o9geGpObHrKvRL3LO5U8k75WUigIthvk9M7fgLrlVGfTgBi+ZjdaINwRQVFF0vwE97L2NI59UMWKjlJFnc6YaXt/O2tZjZ0JVdCo3FDAUrM+1yicP3KE0bKvlWEI2RUFLpW9432R9XmV9XkDY4i5lPsnhIDF0QDfIC2jQkWDTXZ6VgqAKWTVwstrH1lsgv2BQpcztLMl+XxHcOMWUVOwmQxmmkdHQff8Mt7xWvViv+2sQ8CmITue2kBO2TClKsDa6iv+MfzmQuzKKqr6l+cBy1Fm9GDuzMAn8zBdvudFNUzFSz6+Nz9LUst6Org+S5IKERqAuYU4hrfPeFqiJHCxSPyggk+1fL/wT7Bgl39NM/1WG0BBpjxhFM/OjkYlbRQ37GhRiGR0Wj+0K7D1ncPwNskabMIqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AoIYetrkpaypo10jrDBJxiGN3qSF7Vf64xkKQZVImvLVqzdSRRiCjJ1uZLRS?=
 =?us-ascii?Q?DpRRuTZwSXp1ZSyPSFoK4v5n1f/q1M9du9X5q7lHe+4xKHWP2Wkf6JGMnCwQ?=
 =?us-ascii?Q?gOABiPToLSkFdtAjJXNCg4Ievx67smEGGjGCPOo0cGOTlGJWTnfBmMmJ36GT?=
 =?us-ascii?Q?y7sdcRLDQRruJqjpA518hnGS3NqphUGGkvvDUlZWvyk2fLIATDq3FEu2LQUo?=
 =?us-ascii?Q?vEk7+w++l4cTAKMzuy2W2hpprXYUdK4mmASxXvpJS512AvLPBPP9PPIcGE+6?=
 =?us-ascii?Q?9tm38zFsRSqpE9cCatgMI7LsHM4MxH3Ay7fe42JugQSlwRxD4fRG7zeyjuA8?=
 =?us-ascii?Q?91faJF9yWddALQylQ/yATqtNG0desBUzuWRRJKv4HhQwgl50XPrMKBRpEAfA?=
 =?us-ascii?Q?NWPkptmzym2+rzPmFVlJp67TH89ChZIhKg3RdWhPgAP03+kx53DEIzfDcO/D?=
 =?us-ascii?Q?JzpxVsx/N59dHH1W157dO/kCz1oaY35lrAjAC9bTHW1CRpEGF43m/1kB5YBc?=
 =?us-ascii?Q?mTDm9fhvvhZxADXqS5r9UJ73uDHHShvuJ2jL9iC3BuHoZ/1ClS/dFTSh5p1v?=
 =?us-ascii?Q?DzWvP0xfgLwPLJxjiA2Ch0QgWhfJiTlscPBd52in8WCKkuiPiM01MnIf0KKX?=
 =?us-ascii?Q?mIaAMmY76og9Mf/WNmDmJXBtEmEGW9DCaxPc+oACiPmq5nGoql+N6o0XJRt4?=
 =?us-ascii?Q?vFAewi3f645EHRbc8Pdp4I7nzJWE3WBL/P6KmUpxJlwziOnbGnsShGTSvX+P?=
 =?us-ascii?Q?dvFPc4XAxwEgECxf6Minx6kOiPJJfGQsoSfhOqqmATwxogdTzhgxlr6UF+T6?=
 =?us-ascii?Q?bGxFCtqWMDEsAfD4Hg+DP1Wkk2H/TNc5OfRTkCL2gfpi1ZsmfTSx+/ye/dso?=
 =?us-ascii?Q?SQi4GJjD/DP32AVR6kr4podMIvxbdgvaW8djKqfzQZRooyy+fCgFnl/uBO/6?=
 =?us-ascii?Q?ZJZXcSrM+MWkin6AbpnbvEAPlF+55wsGd0dMKfEoynlRdKxq0bglR/A6Rn7+?=
 =?us-ascii?Q?4mYLNtDzeZDsv67XltN8j6zbPf77u/in0upZWjRbqQu6rmoROrUvDufYmJJF?=
 =?us-ascii?Q?GZovKpiVitFNy5LR0iT4ORtyMhLdJrRFkcjTrALweOGBfaDmxx+KP3wZXZ4k?=
 =?us-ascii?Q?VxXO5BT/E2Jt8q96PUf/ZwDAdlhEJhBixVnCnU+MvUdcCcBzaPLp7OJ05C0i?=
 =?us-ascii?Q?9Ge0KyFiXltJBlg0WuSh+6bztoD92GDjDCHdOyPqN1b77JhwIS4gDV45IfXl?=
 =?us-ascii?Q?hTPDGPpnK+kozBIiNNECrvIqtVYPLD2mqpeX8fkkT+MelnAieu6NQW0j/R87?=
 =?us-ascii?Q?07cP9pZow2ZJ9JWp0Td/oPgskyo42n8wjCRehSriOLUuQ+6bZkMeE/nyEF0x?=
 =?us-ascii?Q?s+Xf+NxGq/QXvNCeDT42alr84nDbn3Q4bNmjmaHySRW+LuCtbb/aW7TsBRAJ?=
 =?us-ascii?Q?hjCAH9pqJaWBvwsdM2LlArkcGmki0MfL/Y+TG5j9euzwjiQrRtl7klY2DM+V?=
 =?us-ascii?Q?yn39TvpFAKPynJGjPGphwSNGJspNJuKogx/vwhNWUraAjORqegc6qeUBGm50?=
 =?us-ascii?Q?smZz9EE/wytm8/J4lev9FS5nWYBB9KNX9xKQprkyC585MC+tAD78TDjj6OPu?=
 =?us-ascii?Q?/XZ77OZwFxaEreDlRdRuQ6ptCmn9lP+tVMcxQyre940WJuN7pWtCoMe2A4Ew?=
 =?us-ascii?Q?LwtE9A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d6a283-3125-4a5c-a9e4-08d9b92c7864
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:30.0297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bG/9OpukN8LHSd+ZCriqg6wGtNHozQtipQtFxvG91UjaILkwlubS9HlQlwPKH7VggT06u0PaJNlm3NDt+Vl5HYl7F7kM2J9iz4tl+3vJL48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-ORIG-GUID: DVHLnu3GaCbUn6TfB_TVSGkSSw2x-vvy
X-Proofpoint-GUID: DVHLnu3GaCbUn6TfB_TVSGkSSw2x-vvy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With one worker we will always send the scsi cmd responses then send the
TMF rsp, because LIO will always complete the scsi cmds first then call
into us to send the TMF response.

With multiple workers, the IO vq workers could be running while the
TMF/ctl vq worker is so this has us do a flush before completing the TMF
to make sure cmds are completed when it's work is later queued and run.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 93c6ad1246eb..33e3ff4c1f38 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -413,7 +413,13 @@ static void vhost_scsi_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_tmf *tmf = container_of(se_cmd, struct vhost_scsi_tmf,
 						  se_cmd);
-
+	/*
+	 * LIO will complete the cmds this TMF has cleaned up, then call
+	 * this function. If we have vqs that do not share a worker with the
+	 * ctl vq, then those cmds/works could still be completing. Do a
+	 * flush here to make sure when the tmf work runs the cmds are done.
+	 */
+	vhost_work_dev_flush(&tmf->vhost->dev);
 	tmf->scsi_resp = se_cmd->se_tmr_req->response;
 	transport_generic_free_cmd(&tmf->se_cmd, 0);
 }
-- 
2.25.1

