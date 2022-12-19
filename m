Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAF1C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 19:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiLST6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 14:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiLST6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 14:58:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C802613F6C
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 11:58:36 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJIx1fa007993;
        Mon, 19 Dec 2022 19:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Ls1Afuk+vREBx4X5LIJCcRdVZS5cGA//lszq4XVSrL0=;
 b=lh7MrI1giBi5aG6XXVUs29Aqh3lC+Fl1igEy0b7L6coaMm2PeXDLeG8/1InInNL0XT1t
 VHtNW82fBWBtl69SWeBZr4Zu/slgpmrkg3r+rhnn73GrdNsGTuTc/s7jhqJVUIanRjnG
 +mcEDB1ciMqan/sg4TQMPirT6o90zRJFBEUOGgI/f2Q3E/Mow9qhTzbT5QxLDFXK1o7e
 NMASU5Zr6OjkGx6xdMtq66byk5DHYeFDrYjEuxoyt/2HS3la9orG+phrWUvDN/ngqijC
 fX5SbHinV81XKFhUbMIXgR36BShHaz2jFdu9AlpcarhnzaWf+o3YsNdfEfbxV6hswnBZ nA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tm3stc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:58:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJJkipg027574;
        Mon, 19 Dec 2022 19:58:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4740bsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:58:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fT3ObwJhzJKjLCRB8dvm9ljBBEu/0YliDg+n/32M0RcKfs6ARV0DvM+e8+A8lywsHU+HphS8ebsSVw/YiohVekK6y9VsJSWDAPAiNttvjalBCqpIVshze3uqbVNVIA6rD1JbC7hCLiILMuUjHNcEeEkUpv3/VKnjPeQoE75NhIrvMXfIYA2IP8b17ogiq0//2NtVNkszjas2/70abTV07jvRPf0Vwxc/PgIvW/wzW0Z1bacp4O0FELBUWwWV+Er6QrZWIF5dvBVvD7NAQRoBj5jxmluYrUDKQtoH25nC7GYBfL+tvFuGa3+szyY7cFhsYX8FtVq714OPzvwDJl5jVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ls1Afuk+vREBx4X5LIJCcRdVZS5cGA//lszq4XVSrL0=;
 b=Qv7ZhHr46lvtNKI2Siszakh9s1LCqID7/fYNGDXb2m9chy/glnuLfSyqr5ant/byV/kdOVxstq1+d6rp9ui+X1RzyqH5tMoL7BYn3e0gWRhwJ9OHF/5GEwp0blgvwr3inm19t/XeYBlNSVoMseBsbIct+0hvokXYSalvQS3BjFb7R1GjxX+B2R5IpPsL8k3Gc9HWbCMfpmf1PAg2GqzXOhy5RFJPCUQWgyWdz/O0quRSL3Zu2nR/YtoNPjKMCWpBZvHJYbFhNUJDHhHI5UCY8us5ysC9VbsgYsVGkWlnH35WW1Qbz09MuZFX2TiDOwWQARqolxwQFT7LHTsnI75Zmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ls1Afuk+vREBx4X5LIJCcRdVZS5cGA//lszq4XVSrL0=;
 b=Vidk+9scBo3DFPwdFePdj4avUiEVh7d54Gh+V4LRZwxOPwclQ95yCmADAwToAcTII1ZAZWVRQkC5Mw/qsL0oLxevJyQLCPhG4eGu7SKK2NQwh/aTlNsDQB4kEVbfQY+DaIGAufhvNt6MQsvw7m/WlAXcuNX9+q0DSmoiOwB8+5A=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA1PR10MB6661.namprd10.prod.outlook.com (2603:10b6:806:2b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 19:58:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 19:58:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     dinghui@sangfor.com.cn, haowenchao22@gmail.com, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/2] scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress
Date:   Mon, 19 Dec 2022 13:58:18 -0600
Message-Id: <20221219195818.8509-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221219195818.8509-1-michael.christie@oracle.com>
References: <20221219195818.8509-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0412.namprd03.prod.outlook.com
 (2603:10b6:610:11b::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA1PR10MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: f854732c-e1d8-4738-d116-08dae1fb62ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYv1a4Ih352K4a/qV6ApKbPEr06OVAwvlRsqz7W1S63wHXJmiIsBK8WlbLiF1AY0RBYxOwO84zEXkgGQJt7wkyiF+FamUahdh6HY4ITaiQ3/P4psgHZIUX11dVeFxIkgX175ATpmWfhsy4M61vjsessruBm6S+hphYDqu+LTYyDrUQJKN4jExEyMGX4oBZON5gJqjodohBIA5f9xpym6bWpOsFN6swElpiSvjvBXvtZm4xt9eqVCfxoah/YzABcLsFC1yIJxoi/oZ1hNzSUSk+KdfbJ1ZSPSeJm6IA6PUFx+ifEdZWxdoSPGa2sUhDz9hcaz2r0sLasoxUqrOIiR6/qiaBCG1md4M3njO6t8c4eB2urTq2joWPLK7kPfRC2VI1CoJc6Z4oMExf2o6LG80aKltmlPNr/4R+D1uY/hJ7wc53oOGwmUDU/n69VIuU0KMd4xhl/6YLAtC6uFGwCazgMdTTa/0i7ffW2vynosLABozUxeZJeg+A6wlarQwVoTWaYZK0xGab+c3T3aOfDoLwHGmQGrWUCQNbe4lhobHtQRUO1tsfva8pLmoTFkmZbdQVrakXnUhYM9s0acePLqiLSPTsCT2AnLFBqvhUB8mw+C8kDIVjzwBqxz45PA9r+8CfLKf4owL4huKl8lFn/zXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(36756003)(8676002)(6512007)(26005)(4326008)(186003)(66946007)(66476007)(2616005)(41300700001)(478600001)(1076003)(2906002)(86362001)(5660300002)(8936002)(6486002)(83380400001)(66556008)(6666004)(107886003)(316002)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?teHpQgT24MI/wznqTZ29BumycNK3b8Vaw5PSzcoc5BK7SOGPt2r7g2cthwLZ?=
 =?us-ascii?Q?lC5zxH50l3Db2RNmtYdqkm/kiJ1r8o1SZeByIx1WrhGlXoFM6IB0Y6em8Uo2?=
 =?us-ascii?Q?Nw8Aa178XvX1YSgKbdjfQuKVzi8KM+BfAyno2KdNkU0bBWfphCc+OkesmQbI?=
 =?us-ascii?Q?goXJ+8J4uHCcn1HYSQt6iRgm22k+2j86oviqsrXJRiSBRFhgTvjmJYN3YqDu?=
 =?us-ascii?Q?2kJSAX8VQ/W3ZQmKTfKmEmeiG+UmUJ7sVkhKAmOtU7JTsyo26Xv+agN3K9Ij?=
 =?us-ascii?Q?FeM4XgvfbqoeNosJtpDK9JbsMumpoyfC3/IrQQasJxSU57WZdeO9+nadHAUZ?=
 =?us-ascii?Q?m+0eGCXqFLz9TzMlv5cw90HYaRBqnTc+ajZ8/G9jR+ZXwftg9niEZ50KL/E9?=
 =?us-ascii?Q?XA9sr2txoUBFUN+A2Ef196mI0/R2B7Q8nBtcGPvVDJ2mcDwKgwiKD7T/jhds?=
 =?us-ascii?Q?GAAC/EKA5RdHXiuxRK79P2zxAFBr/ENQNsDEDYd/Mv/tiBfYAdDrjYkIxQFJ?=
 =?us-ascii?Q?IyR/ZuBo88FLqaQHajKkLa03deXuE//4ZCfyBhdlmqn6VE0dsqvDRSl5Rnkt?=
 =?us-ascii?Q?CsIKH2G0VGvcHg7X8ASfvgPDd6lvNCYMdqOql7jXNGCymWJQDPd9uqR6LTmW?=
 =?us-ascii?Q?OE1vNlfDcbVHZMO79OyyL1AxpCtc50ARHICi8SIL4vNOD2GlOISfziCWh52f?=
 =?us-ascii?Q?aLFZ+UzKhC0zsqphZe7yK6TS7AeQ8776V/ta80zdG8CBqr0tUAlUDZF0ePIw?=
 =?us-ascii?Q?QxGaxiTunhfo8i/0lTVl4NkC4Ka0JRx/nax5eJffi8AXm6zVntQI1jz2tD2n?=
 =?us-ascii?Q?KWqeB9Mgw5GV2LS107EzVCEEVWkdJxkV1uUJyPMgXR8rfwZM+9Ys1mCH/hAu?=
 =?us-ascii?Q?lRRfneUEQDxvfKGKaGVsQj1truc9q1rg1TIqeKBVa/AGiYwfbVYs8i1Pqjgp?=
 =?us-ascii?Q?RDnkGlI+lSwVJRrLHYfy5/NuSpGehFFo1FLqcVAEQdKJzpobmBwFKV+KXN6V?=
 =?us-ascii?Q?ruxKaoJ/PToYNmwhXfi/z4mH5b4UFsrqxMCQqBa2N7Z5rvFBa0xkd2D0Srnc?=
 =?us-ascii?Q?DTVFohER7b8Appa/1CTz10A7/NVS8oGoKCbuAi0vzDv1YwFv+J6qqMWT4m9J?=
 =?us-ascii?Q?dYC3++IK6xgVJi+zSs1b5p6w/yAxlS+I/Dziui0eHsVUQHimS8Gf7h88ypF6?=
 =?us-ascii?Q?BhTngEPPR8QKrK0USCNy1Nz82P76Yh+BpHpJeXhmFb1q1yQ3RPwMvN2DwQ1v?=
 =?us-ascii?Q?CJ2ojE8DbfuoSc8xyt/2yTFG46d0OJ2s6iTN5yb5/8Lz/4WL/vpo+opgUKD9?=
 =?us-ascii?Q?CG0awJG4f80qeXktYfTyxSEyREGZHzUK1YqKAkZgB4+4Yrrb/mtBN9xMNC4s?=
 =?us-ascii?Q?FnvxXki7zv7oXhxCeAafPyOylWXohiqbMeiVppRRlmb/gaGhmBn6Fo41CCSm?=
 =?us-ascii?Q?6tXuWWA9Yvn3zwD2gG0grXzig7dxMOqPo903/GNvvoTkhCftr0WsjEmzK+Pw?=
 =?us-ascii?Q?TFySuR0tYDTfL8WBEzR9QPflGWSoQ5ZrZ93uf/wiqyxeKd/+XkykeBaDlVu9?=
 =?us-ascii?Q?V9TRxwL3wX8Jhi85ck+XTvGAoWvGE17XI43OqGybsmZj1EXR131M4I1GW6wx?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f854732c-e1d8-4738-d116-08dae1fb62ee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 19:58:24.0299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLFX5jaMqp3uKmEfqBrRBIfaGHpz4ovHAnuiAqI6/gIuaE1Wjqf3qw54+L2sG6hDtnn/IGJ54XgBuldfCX2OmSLOoWzhS3/hc1DZbRmy3pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6661
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190177
X-Proofpoint-GUID: uFhMZS3BlPXV14kpbct8AslXrj1Difwy
X-Proofpoint-ORIG-GUID: uFhMZS3BlPXV14kpbct8AslXrj1Difwy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If during iscsi_sw_tcp_session_create iscsi_tcp_r2tpool_alloc fails
userspace could be accessing the host's ipaddress attr. If we then
free the session via iscsi_session_teardown while userspace is still
accessing the session we will hit a use after free bug.

This patch has us set the tcp_sw_host->session after we have completed
session creation and can no longer fail.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9c0c8f34ef67..c3ad04ad66e0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -848,7 +848,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 				       enum iscsi_host_param param, char *buf)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
-	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
@@ -858,6 +858,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
+		session = tcp_sw_host->session;
 		if (!session)
 			return -ENOTCONN;
 
@@ -958,11 +959,13 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
-	tcp_sw_host = iscsi_host_priv(shost);
-	tcp_sw_host->session = session;
 
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
+
+	/* We are now fully setup so expose the session to sysfs. */
+	tcp_sw_host = iscsi_host_priv(shost);
+	tcp_sw_host->session = session;
 	return cls_session;
 
 remove_session:
-- 
2.25.1

