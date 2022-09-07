Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CAAC54EE9
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 22:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiIGWRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIGWRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 18:17:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EAE99274
        for <linux-scsi@vger.kernel.org>; Wed,  7 Sep 2022 15:17:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287LJUc1017876;
        Wed, 7 Sep 2022 22:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ChuNcVTb5/ihcK8RWL9JqnNd3cm3ZW1N57OddTsjNQ0=;
 b=Y9j/XF0RbhqbOqY2xrvOErShNbK2OEtIBw7/xazuHkAvqdhNuCOU6Qs2IUiwDOJ2MWpi
 GJwWVhjP0AZo67TjiN5EEAH7nBwvUB61h/syGd/V/5kzGteG953yZnZFf3vdy/JQYXCg
 c7+K1A14z9OGdcLM+4T8IpcoLJ2nSjI3bZPzaemokNq9Ws5s8jHy3Nn/Y2skRFmbm8uL
 S33SkM2dKwegY2KzgvED/DpNYRbuJWLLjtgGFRPwwXox1YLGuRgyO+/cbLzW9lA5MwUF
 mcBWNcDILAKoPggfERsvgQVePrtgHNy51ieHKB6QHpVlrnNNAUH9qvVnjirUnl1EYBTo 9A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwh1j881-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 22:17:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 287MFemF031125;
        Wed, 7 Sep 2022 22:17:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwcavjm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 22:17:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3Nj9FHuL6IY7Z+kSRpSjMp2IVwHLiOIYgTj0A6BxBNJWsUnd3SNslfcvNYn8ia7svaztKgoQTdyM0SlrNIxnPWzWl9bi3kUG7mKugzA1SpcAydFcaqs97UGV7ZN4Su3G+gGWPnyRc9gqTJAGMCthzGKHiG0ZLVfBMdBKKXVQX0dor4Ab64C/3dVl36bG1i75U10aQ1YWmAYpLEsjAqlDSdOMsd/eIs9dW/zXqBYt9EVAYGQ1LX9JLFyw5qsX1p1rAqAJOI7cn2iCL09bbn9TaV3I408Uh+PgqZH+JgA/j0okCoKNYIiTXd1NF76/FBMzu9l7e3MsJczrJbr3aveGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChuNcVTb5/ihcK8RWL9JqnNd3cm3ZW1N57OddTsjNQ0=;
 b=MU/VO9SubQ9UeFVuPX7p3FehyUmjkZr0LK2gkDDQ9bUNdwBu1My2saDsVYsFzXrCgmz2fv4sAblTV7fHlwPful5g3CONQ+o6+XGxmXuojJfmeJHusxlO1bycL2onDPRsf4bslDTbTiqfVo/TDpk5UABd0r4yFfPQWOSqqwycNOHF0B1Ok0x90BUkBuddg57huml+eXAsfR7Qe2J9XbzLYaceoemyG/DEBXRwhi4qM/WJLqd1nnj5oEVr8MlGDyEN71pYK1K7kpeozw+XMwHE7qnv9HCGe4JsmAHH0LkZ83lYDkaRZCWu3OdhuUZlKSE590oI5fsHbnzX5ZyrVz1+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChuNcVTb5/ihcK8RWL9JqnNd3cm3ZW1N57OddTsjNQ0=;
 b=aat3M/Bx2Fr0Tkk3IPsjHcyS3qS3vM85jqva+MJScvD6olIMlgsRPiTSmtpXi7F8zrqnhAxUwFmI6grcaBxaIGGMQn7WjRQVsh8GXRretFiP11ggA16f+3vGBPU2VU/Ad2vrPL5qq5hCyCt4LHPj1SZ0u4gJ+fCQgRUWOI9QasQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ1PR10MB5956.namprd10.prod.outlook.com (2603:10b6:a03:489::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Wed, 7 Sep
 2022 22:17:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 22:17:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lijinlin3@huawei.com, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/1] scsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername
Date:   Wed,  7 Sep 2022 17:17:00 -0500
Message-Id: <20220907221700.10302-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ1PR10MB5956:EE_
X-MS-Office365-Filtering-Correlation-Id: b8083f94-7f3c-42c0-5e8e-08da911eb06c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VNht/17nlUW2fS+Uce1cwZhCE+bxxAkwnFoROoMfD4AeP3LbEGqiSaNT++umaaJISu5iX8KKuRBktiCx3iv4Xc1NGPoXY245D4Vf8o81+phf1pGaeBUU8K+IkjkoE3UcAjcHnRKPh23SCgI274jZJ+xcv9rWAbCK9rVd8V3PCjPJxb32IKFXcgKOU1bLT3MpFcUspiRVKjSw5VhkGKhsvWiBXsg3aJrc/Et5tTZBRvJoJPk9ktGMlbG/fq6xB2JH+d7UOcJxF+beir7m1ygna57+hYlBKff/xp4fUhnjKhcREUUbAnXK/W4G/6pAbVmKvnue9IkaElzGfhGdXYUDnen8k10JGcAzBpVysUBjwnlMRjVvc2AT39OuRX7cvcPWFKNAg0E0PKwuqatIEnF82xaVVnOEdY94ew1ogjv7Ujl2pFuztIAn5rG3TgUZpJo/59kNOrDS55LExEYuknmpGQMwXgfXIDR9DQjuGpcpprXiL5SZVf9pigL0TMcuAGR2mHo0rek7e7sNUvOX8WUt+4mqS0aG8XlRqB+pj8oLADtQ5mpZJXhIfSMcd9XUTVTG8e5QHlVMPebFLFM1YFUtkRzpTmH8/olY1riVBxU+goyUyHRyoHrN1JVP4P6+y+KOKTXlb99umyVrTe5v8fNZV9Hb1OxM2Bd5Q1KE7gXRepkY1iVa1uHsgqmBgy0fnrm5KOK1O7B4SslEKHrJmIrQ0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(346002)(39860400002)(376002)(396003)(186003)(26005)(6512007)(478600001)(5660300002)(66556008)(6506007)(2906002)(41300700001)(86362001)(8936002)(6486002)(83380400001)(2616005)(107886003)(38100700002)(1076003)(316002)(36756003)(4326008)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sd7Mm/aA0ITwfntW68HsAbwmNV/rndOzxJtszvK0wuGC3Peto1mYZVXSXSYr?=
 =?us-ascii?Q?JgViFgSmG9umdk04OgeKcTnBuuDE6J6jRk+tc/1FxqkfznKvnfQf4Bm3uQ36?=
 =?us-ascii?Q?t+vgfsKPtldLh5PYwz97vQDi8dJrM3ZJf35Nt/OTzCT0ETjqTwYci/4d3qKG?=
 =?us-ascii?Q?BmUVuor53WErRJORukuCnV7wj/U39Mugkmi367LDCKmgxZAcYF6DWEH9M0eE?=
 =?us-ascii?Q?t5lMB7O893E961POblsEaXoowiuPl/4Y8NXzhRUQzcYzfxjoclDXAtQQ2Ca4?=
 =?us-ascii?Q?Aq1Xj2XX+4tRSWUfGJgq2yNcQPeWP3DpvsrwkvBuj6sLYVpqFCA/VoEgVsX8?=
 =?us-ascii?Q?4m9t9CV86C4XKPThfBezPmUgFXfsiLqMSnljmkGYH28Lv+xhN5Dz9CwjZH9h?=
 =?us-ascii?Q?+mxp1y1SFuze96EaGOxMtDiuPdk3TXG50GKOjDUrgD9UtGdgd/uvcoMqGwXf?=
 =?us-ascii?Q?COGEla0FsG2lQfR3OukIGU2d459g0uYlTYV2eGkJRL2lEo7mJ0srqEpk1OZ3?=
 =?us-ascii?Q?51MlWCSakFq8HZfVARGkBrcfn6aAAP3budDfCcwKbdGCryUanoh1akh+ysnO?=
 =?us-ascii?Q?VpVHwUebt0GEhwN+g3s6ON7mUSzxdTECPzNMrSzZyyZ6peYfq9ruHuZdGFMY?=
 =?us-ascii?Q?1kY5zGigjHB/FGduRfjXMlziDoQmk1SwoxsHjm1iH0IwC/dsb0TnMA591KAO?=
 =?us-ascii?Q?fdqlIyR+ZdI3mihuE7kH6tWsh09iTvPL2eTeNvHWhs/j+2IFywA72kuoHNt6?=
 =?us-ascii?Q?S+4jg2EBpXCK7T+lCsbUl8uuIjgUrTdTOilwvqGCTaLpdKUh1LwTUTo88VCh?=
 =?us-ascii?Q?d5MoZQqhV/x6/o6LQmx6lIN6NDE2TkfAOGmRMhrZ5ckFC4a66eNdpHmcJK+Y?=
 =?us-ascii?Q?GQU2lRiFlH4S9FfiHsWVyamge+fVGnxv7pyrv0byjQglRD09z5/HdNyBY3jA?=
 =?us-ascii?Q?vA5GpzIMQqgdNcWHZM4ob968jmvcp2HMzrvKVRizmMbAm+CU1QqrWmX9905P?=
 =?us-ascii?Q?zN928aGojOH9hrrkSiN+RryLIEtJwhQWkXXA30KP0yHluZlDbjOQ2HuMXjdA?=
 =?us-ascii?Q?gspiWGHPFRY5IOOh03N4kjjsxePG3MZdC2ycjHnqCXgYl3aSQJs/zMsww5b2?=
 =?us-ascii?Q?Xw+fGe3Tze5vkwu5rB3UR4JLJKdrZvKkoXnqy2vDjXK+hf0A+wgatMwtLzQ3?=
 =?us-ascii?Q?xwu9+C5F1rMDTU8DLkXq940W7iMs1GyqO1+gZw9RModheayqCELSwgEtL1sJ?=
 =?us-ascii?Q?7aJf14lAvyJi/sO6ae17OeFf3BfLMQ5hS/eYpEkHhXb21rX77rhpFafUh7zU?=
 =?us-ascii?Q?c60H6R+5ZTdUdYBp3A89UTAwAx7GZ97WAHjykjuAsED4lHHkoqWZSmhQJ6nU?=
 =?us-ascii?Q?vI1sDUCRROusDPK5vnZS/6/iSKrmk2VTNqxGpUZUX06iqmErZEKmPANHgJwO?=
 =?us-ascii?Q?RvT24luuPYgpMJcnIJDO52iVOXNfJdsPS0p6LFV8P1kiyzDllVxdvjTclKXX?=
 =?us-ascii?Q?lREvvkZ5Fh6Li0t7srdH9zq1dNA9FY8yeBB0jsvDD8t6NwkCftraB+prdXid?=
 =?us-ascii?Q?Gj+ZH+DalGYBRFGf3Mu5fyxIPvov65JM0HHDW7iDTpNQmR2FidWOTw07CSwB?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8083f94-7f3c-42c0-5e8e-08da911eb06c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 22:17:02.2847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNwvbJx+sztnIFnpPfB2etsMd8Q+LACPFUA8ZGCkBYxcraKJQEs+yPAtVwH9JZ2CEynmXBoN+juFNc5SblezbMqgi1YdV/neJ/3AmpSOzNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070082
X-Proofpoint-GUID: tdB6XZYT0nZpn3yrZ5vm8N_rDZyvBErm
X-Proofpoint-ORIG-GUID: tdB6XZYT0nZpn3yrZ5vm8N_rDZyvBErm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes a NULL pointer crash that occurs when we are freeing the
socket at the same time we access it via sysfs.

The problem is that:

1. iscsi_sw_tcp_conn_get_param/iscsi_sw_tcp_host_get_param takes the
frwd_lock and does sock_hold() then drops the frwd_lock. sock_hold does a
get on the "struct sock".
2. iscsi_sw_tcp_release_conn does sockfd_put() which does the last put on
the "struct socket" and that does __sock_release which sets the sock->ops
to NULL.
3. iscsi_sw_tcp_conn_get_param/iscsi_sw_tcp_host_get_param then calls
kernel_getpeername which acceses the NULL sock->ops.

Above we do a get on the "struct sock", but we needed a get on the
"struct socket". Originally, we just held the frwd_lock the entire time
but in:

commit bcf3a2953d36 ("scsi: iscsi: iscsi_tcp: Avoid holding spinlock
while calling getpeername()")

we switched to refcount based because the network layer changed and
started taking a mutex in that path, so we could no longer hold the
frwd_lock.

Instead of trying to maintain multiple refcounts, this just has a use a
mutex for accessing the socket in the interface code paths.

Fixes: bcf3a2953d36 ("scsi: iscsi: iscsi_tcp: Avoid holding spinlock
while calling getpeername()")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

v2:
- set_param will be serialized with setup by the iscsi class but after
the conn is added to sysfs, userspace can call into the driver. This
adds a check in iscsi_sw_tcp_conn_get_param to make sure we have been
bound (leaddconn is set) so we know setup has completed and we have
connected to a target at least once.


 drivers/scsi/iscsi_tcp.c | 73 ++++++++++++++++++++++++++++------------
 drivers/scsi/iscsi_tcp.h |  3 ++
 2 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 29b1bd755afe..5fb1f364e815 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -595,6 +595,8 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 	INIT_WORK(&conn->recvwork, iscsi_sw_tcp_recv_data_work);
 	tcp_sw_conn->queue_recv = iscsi_recv_from_iscsi_q;
 
+	mutex_init(&tcp_sw_conn->sock_lock);
+
 	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm))
 		goto free_conn;
@@ -629,11 +631,15 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 
 static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 {
-	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct socket *sock = tcp_sw_conn->sock;
 
+	/*
+	 * The iscsi transport class will make sure we are not called in
+	 * parallel with start, stop, bind and destroys. However, this can be
+	 * called twice if userspace does a stop then a destroy.
+	 */
 	if (!sock)
 		return;
 
@@ -649,9 +655,9 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 
 	iscsi_suspend_rx(conn);
 
-	spin_lock_bh(&session->frwd_lock);
+	mutex_lock(&tcp_sw_conn->sock_lock);
 	tcp_sw_conn->sock = NULL;
-	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&tcp_sw_conn->sock_lock);
 	sockfd_put(sock);
 }
 
@@ -703,7 +709,6 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
 		       int is_leading)
 {
-	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
@@ -723,10 +728,10 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	if (err)
 		goto free_socket;
 
-	spin_lock_bh(&session->frwd_lock);
+	mutex_lock(&tcp_sw_conn->sock_lock);
 	/* bind iSCSI connection and socket */
 	tcp_sw_conn->sock = sock;
-	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&tcp_sw_conn->sock_lock);
 
 	/* setup Socket parameters */
 	sk = sock->sk;
@@ -763,8 +768,15 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
+
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		if (!tcp_sw_conn->sock) {
+			mutex_unlock(&tcp_sw_conn->sock_lock);
+			return -ENOTCONN;
+		}
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
+		mutex_unlock(&tcp_sw_conn->sock_lock);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		return iscsi_tcp_set_max_r2t(conn, buf);
@@ -779,8 +791,8 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				       enum iscsi_param param, char *buf)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn;
+	struct iscsi_tcp_conn *tcp_conn;
 	struct sockaddr_in6 addr;
 	struct socket *sock;
 	int rc;
@@ -790,21 +802,36 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_CONN_ADDRESS:
 	case ISCSI_PARAM_LOCAL_PORT:
 		spin_lock_bh(&conn->session->frwd_lock);
-		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
+		if (!conn->session->leadconn) {
 			spin_unlock_bh(&conn->session->frwd_lock);
 			return -ENOTCONN;
 		}
-		sock = tcp_sw_conn->sock;
-		sock_hold(sock->sk);
+		/*
+		 * The conn has been setup and bound, so just grab a ref
+		 * incase a destroy runs while we are in the net layer.
+		 */
+		iscsi_get_conn(conn->cls_conn);
 		spin_unlock_bh(&conn->session->frwd_lock);
 
+		tcp_conn = conn->dd_data;
+		tcp_sw_conn = tcp_conn->dd_data;
+
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		sock = tcp_sw_conn->sock;
+		if (!sock) {
+			rc = -ENOTCONN;
+			goto sock_unlock;
+		}
+
 		if (param == ISCSI_PARAM_LOCAL_PORT)
 			rc = kernel_getsockname(sock,
 						(struct sockaddr *)&addr);
 		else
 			rc = kernel_getpeername(sock,
 						(struct sockaddr *)&addr);
-		sock_put(sock->sk);
+sock_unlock:
+		mutex_unlock(&tcp_sw_conn->sock_lock);
+		iscsi_put_conn(conn->cls_conn);
 		if (rc < 0)
 			return rc;
 
@@ -842,17 +869,21 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 		}
 		tcp_conn = conn->dd_data;
 		tcp_sw_conn = tcp_conn->dd_data;
-		sock = tcp_sw_conn->sock;
-		if (!sock) {
-			spin_unlock_bh(&session->frwd_lock);
-			return -ENOTCONN;
-		}
-		sock_hold(sock->sk);
+		/*
+		 * The conn has been setup and bound, so just grab a ref
+		 * incase a destroy runs while we are in the net layer.
+		 */
+		iscsi_get_conn(conn->cls_conn);
 		spin_unlock_bh(&session->frwd_lock);
 
-		rc = kernel_getsockname(sock,
-					(struct sockaddr *)&addr);
-		sock_put(sock->sk);
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		sock = tcp_sw_conn->sock;
+		if (!sock)
+			rc = -ENOTCONN;
+		else
+			rc = kernel_getsockname(sock, (struct sockaddr *)&addr);
+		mutex_unlock(&tcp_sw_conn->sock_lock);
+		iscsi_put_conn(conn->cls_conn);
 		if (rc < 0)
 			return rc;
 
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 850a018aefb9..68e14a344904 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -28,6 +28,9 @@ struct iscsi_sw_tcp_send {
 
 struct iscsi_sw_tcp_conn {
 	struct socket		*sock;
+	/* Taken when accessing the sock from the netlink/sysfs interface */
+	struct mutex		sock_lock;
+
 	struct work_struct	recvwork;
 	bool			queue_recv;
 
-- 
2.18.2

