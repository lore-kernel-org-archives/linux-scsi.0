Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE83C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 06:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF20961155
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 06:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhEWGji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 02:39:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59516 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbhEWGji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 02:39:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14N6c6UX086236;
        Sun, 23 May 2021 06:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=LuZ1wbb+abHDu6rvJZztHsp5aOZ+yNdB2YvE+5dv6UM=;
 b=MzeoHkbNPlHrhPkst0/eOPOACtiabXK7VbOKI2qAyn2jngdo8im7uvZ4cSvrcvHM3KAp
 Ptt+mZHaLGGjCqBF50CpYHHsafHghmuqOnAPuqNyvg1iq4vs0kDJOntlpnXwr3iFFGVT
 +UIt2yICnwXpzizcdqt0APIF2DGVZinL3rA/47phRv8l0DwmhJ1aAD4xC2Au/3ea6sNn
 XX3nSLR0SDS0bgLcQJajH44hYiraOLn0yp3oIqx6n9Tw8wnjPSBqMExyu5mqhJ4Fn7iT
 rLhJ5WmvgoW2sRooMMEKKgICaqTJcb8DFICC/3qxILlq33N/mLhPeTH3xK7UKWEhkL1s Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38pswn8xvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 06:38:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14N6Tuh2103594;
        Sun, 23 May 2021 06:38:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 38pr0a914y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 06:38:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEe33soZKBrz9K5Mf+27LsLs+aPIjHb/dcNRshHf79bP1iP+RLmK9JMnTCyY2raJbHvCZqJwp4CYIRPmCTro9SWj3qCEd3+YR/335FaEYTPXkLVbzCYjSwLd6H3o8du+ymNYTvpksugCyN+OwKG8o52+umyWqJlskQ9IaG6+WpN3SdCOHPEsEYbhiYkQ6YTZ9BbGqHHFTLR+Va27oVqK7YXrbo2+nUVlBDGhD3pV3ondFpcDwgVb6v+6qR+a2577FIYdKuvbCfrUxwsJgDb/Moi1qACrlPrJt8F62tR/mwPg0+bIqDlgtE2oT3uBb5I4Vnu4nRxiNkGnKeoxudS/tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuZ1wbb+abHDu6rvJZztHsp5aOZ+yNdB2YvE+5dv6UM=;
 b=dqTSlQNoWG/WKyQ6Cn3viS1Zb58WJzpWTLlnA079mCjSvdDNLYpIeMuNJfGt/2TafZJHJYp0+LBi8kcUrJvgL3vwmahnxZaQjU/BVsSRHNRvzN+boGAogF4jTa5OFoEkdMvnCOofTP3QeJQtd8G5UF1ckynGIaTHX9CBfBKZSQeMPNngFV+OqafpRVduNJl4KIFZmJUbEyaCoEdVtYlf6I2cLNAMBrDrc+n2nLpBon2B2Y/PrVH7nWLPUu/UdPwhq3bu3bfwMbzCZNzYMIrMrPimP/i/xJF7/ocFlPPVreSs60rOU/jnDUVDDZU01+t8JieDXKwHFnIr7XV0BlkkGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuZ1wbb+abHDu6rvJZztHsp5aOZ+yNdB2YvE+5dv6UM=;
 b=ybsBd2o5pWLf0LrymBBgnz4IiEtrx9shgHc89X7jexmpRcwR1RWIUsB9yyy9JB4XRGP5j5+tbNJR9BevSNH7BaF8kfMSyrJ8kNxC6MIF0XnNmY5OfpNdmdXnpR50lORKxOa33rM8wJntjnWPPhzL/eBIQmyjaXXNzWQTOuIadW8=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BY5PR10MB3876.namprd10.prod.outlook.com (2603:10b6:a03:1fa::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 06:38:03 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::18a:7c1f:bf20:ba6c]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::18a:7c1f:bf20:ba6c%3]) with mapi id 15.20.4129.034; Sun, 23 May 2021
 06:38:03 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, joe.jin@oracle.com,
        junxiao.bi@oracle.com, srinivas.eeda@oracle.com
Subject: [RFC] virtio_scsi: to poll and kick the virtqueue in timeout handler
Date:   Sat, 22 May 2021 23:38:43 -0700
Message-Id: <20210523063843.1177-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.16]
X-ClientProxiedBy: SJ0PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::17) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (138.3.200.16) by SJ0PR03CA0192.namprd03.prod.outlook.com (2603:10b6:a03:2ef::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Sun, 23 May 2021 06:38:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f22ca5a-3d7e-405a-fa46-08d91db550b9
X-MS-TrafficTypeDiagnostic: BY5PR10MB3876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3876A4601D736FEF97DFF217F0279@BY5PR10MB3876.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JatjdqohoCdHSIcA/wQrxDETthjIrF/n3ug7C0HQ+8qC3a4WjvB8s57KIraevh/fIWigjdtxsI6VVFi8uS4LNYdMFUV4cfTYbl6ZY/5JtHqBefVEJwj/dmSnUzFiFtQzKSA7f1QNL11AcW147FGVprMeSqwas6BqhX46Sz4C+bXWgIeoYby1agQTuY5FumhiQza680rMmyH9tokG4cPdLI8QYNXzK+LMStmIik8wV9TtwBU6R1dMc8m/CpyCIk2DanNj5lfL6oclZAWciS3oXH+aPBOpY7XzoyLRiDYv6rq/FW/rlq1018HR55N4XqnIPGU3Ut3icJB2goGIoREnI/7iVwnoH3G7S8WOExo1mO3nKobl6DTZqKH+4b7RI2/ls7NjxTI+aicg9CeQhDcunf5LnFVRa1tXkM+2NGytG9SV/zDsfqw5dCr16m7cDJkIPam+7vTQIZN1W0T9gi23a/EwqYAlmFjUiLSUbA7xf6WtSGNGxeOl3Ke49ovX7oVD+By3k6ZeoyiQmEW97bgS01lH5WgTT4aGFJdI0n4j3vz7PK4c8N3xUysFO5G5JAC3mEIYYtL8m+mEZyu8iu65QXdd/AGr49RaGs6HkPV/f5mQ10Gsx3DubrQOeNdSmAJNAyJp63hbvqj4pbDun0jgog0e0gn0Wr9ZGXG2ufacb2a7ou+xS+P7whK0nTJfqT1YM/RRIoivqHyf2uVKk7+ezebbDhvacwSD4NP6bhPg1ck9aqfxqoSYZgGo28XfQYSNioMW4nskR+WasNJ4ik1xgpLwzh2+LNnshB70o1SG+MY4if5di9/A2+eeoBdYfP4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(396003)(376002)(8676002)(2616005)(52116002)(956004)(26005)(83380400001)(38350700002)(38100700002)(6666004)(44832011)(8936002)(6506007)(86362001)(6512007)(107886003)(66476007)(16526019)(2906002)(66946007)(316002)(186003)(66556008)(4326008)(1076003)(36756003)(6486002)(5660300002)(478600001)(966005)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YZNuPbBl420WSmjMfuXYsflsiAjd0RlbieAKcbhwH6rWdO1j0pKr2LRgGJqC?=
 =?us-ascii?Q?TBYh+uawpjImYact86fUrl66wXaXih+N8t9MvhoalHLngklysiVCTCwCH8Uf?=
 =?us-ascii?Q?fkwJLoy0u5eeboIwKtbE/mepA6eSlaLyyTSmRPrGgIMpf+FSsZlrjnw129JJ?=
 =?us-ascii?Q?IswRhFc0lcRTOS7C5n34BhJNKOnLPRYYOPCOjt65NSFYGzg/+vo/UIUpeBWv?=
 =?us-ascii?Q?62JwxVwjoy0nmLt5PZCRzYTU1jW/QXOoWyId9uvfnbxnAdJNWQUTz5DOsVvT?=
 =?us-ascii?Q?H2voLLdlzRZn1AuXCf7RPvAGBw5Suu2rXfNa0Z5yKlkfxcJPJ/0fT0u6atuR?=
 =?us-ascii?Q?ryDDaTvlujPz6F1zeMQSql6L7Yzsp+NHzMVlh1auLaqmpZmsXiLSdKCVbpsO?=
 =?us-ascii?Q?sA9jxglXtEsItZwnd1ky2ApzKDZY9b/eJNmOaz5V7P8TnEnXVNjB7kf0LJ34?=
 =?us-ascii?Q?fQTF/hb5RCkGPQZlfR8eSE5IBIbqygKVuEgXiqjCjkNm6U2oa+njvXHTD76+?=
 =?us-ascii?Q?5wiyUIcuW+MALleh4jlDDtbA0LLzvU+ZPVq6ppoKy2v7kUIWZb49RPmse3/b?=
 =?us-ascii?Q?vE14SvM0DQaeBXgB55D09Ibmk7CnXdvYvu8tt5XnXeeROnp1bWb/HrKtkxq1?=
 =?us-ascii?Q?zMrQM7PFbI9ljiFd5WRtk/K3rNwi7okgaTorwdWs9ABr+uDjojes4yjtIhlM?=
 =?us-ascii?Q?V9y69Ypy6wNQxwPogs3rs0fL0NR6KAMlpuNJWOfz8g+wyn0nJuhBzweYLsUI?=
 =?us-ascii?Q?rRTb1MrZnvxG1HJG8LrZXgDdeP51WWGnohZlLZq3b+Uyi+bwxfEmBh8nprcT?=
 =?us-ascii?Q?aW6DZ/P/qyzrRRi+aUpc1Ih1suTo9Gw3MWdIiKb0zdlgxuGgHlNkBHU6WGMg?=
 =?us-ascii?Q?F1XPRK3TI9CnRqKXxFR4Ma0tLTJA4m5NcCiBs58YSOANB7z0C+qWjYoxejbJ?=
 =?us-ascii?Q?DlVH3ArGAel8HXwNzzDfMU+hWZi2tV2WpJWvEqD0ZVCg7mdnug/LmbIGowBG?=
 =?us-ascii?Q?sNdZAtgc/UPALCqfTPkyJMe5nW6/z2yCK483wqVT+eWh5+5wy5u9Q6Ua66Tr?=
 =?us-ascii?Q?RcabUNLGmbJhuxLn7lSlsYAKfPSvFxhHssbne/FoC6EIM6jinZwhUqWTtQSX?=
 =?us-ascii?Q?APZvr/wX4XMYeBy+sBhlE88SNfsLQQQ4S3sVjdpJQij4BuZUd5HDRqY1VEls?=
 =?us-ascii?Q?d0a/srZcFdhgfahKgY0HpA6HaX5N7dvGVJTPEzvHU6qfT/n6kuwb3kfBBWlg?=
 =?us-ascii?Q?ri8WksA//3k9yltMcwoESDgqpt3DNhULqJogqwT+k2WRwAbRZvXJ5R6pbqfr?=
 =?us-ascii?Q?uAytxwzS7B9gWSM9m+AhaJ0H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f22ca5a-3d7e-405a-fa46-08d91db550b9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 06:38:03.1936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kF7b8f2Lqb2ebSH6dVlwTGGfvMGjs5LfwgnGJ7IIUDYPrhclGKJD+jmatUAZpgCHKi6OAlrz20g3lrDkym9E1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3876
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9992 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230048
X-Proofpoint-GUID: HP8e5hc0AFD0mHXHN0BT44HQbtzXnbkW
X-Proofpoint-ORIG-GUID: HP8e5hc0AFD0mHXHN0BT44HQbtzXnbkW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9992 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This RFC is to trigger the discussion about to poll and kick the
virtqueue on purpose in virtio-scsi timeout handler.

The virtio-scsi relies on the virtio vring shared between VM and host.
The VM side produces requests to vring and kicks the virtqueue, while the
host side produces responses to vring and interrupts the VM side.

By default the virtio-scsi handler depends on the host timeout handler
by BLK_EH_RESET_TIMER to give host a chance to perform EH.

However, this is not helpful for the case that the responses are available
on vring but the notification from host to VM is lost.


Would you mind share your feedback on this idea to poll the vring on
purpose in timeout handler to give VM a chance to recover from stalled
IO? In addition, how about to kick for an extra time, in case the
stalled IO is due to the loss of VM-to-host notification?


I have tested the IO can be recovered after interrupt is lost on purpose
with below debug patch.

https://github.com/finallyjustice/patchset/blob/master/scsi-virtio_scsi-to-lose-an-interrupt-on-purpose.patch


In addition, the virtio-blk may implement the timeout handler as well,
with the helper function in below patchset from Stefan.

https://lore.kernel.org/linux-block/20210520141305.355961-1-stefanha@redhat.com/T/#t


Thank you very much!

Dongli Zhang

--------

Considering there might be loss of interrupt or kick issue, the timeout
handler may poll or kick the virtqueue on purpose, in order to recover the
IO.

If the response is already available on vring, it indicates the host side
has already processed the request and it is not helpful by giving host a
chance to perform EH.

There will be syslog like below by the timeout handler:

[  135.830746] virtio_scsi: Virtio SCSI HBA 0: I/O 196 QID 3 timeout, completion polled

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b9c86a7e3b97..633950b6336a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -36,6 +36,9 @@
 #define VIRTIO_SCSI_EVENT_LEN 8
 #define VIRTIO_SCSI_VQ_BASE 2
 
+static bool __read_mostly timed_out_enabled;
+module_param(timed_out_enabled, bool, 0644);
+
 /* Command queue element */
 struct virtio_scsi_cmd {
 	struct scsi_cmnd *sc;
@@ -732,9 +735,38 @@ static void virtscsi_commit_rqs(struct Scsi_Host *shost, u16 hwq)
  * The host guarantees to respond to each command, although I/O
  * latencies might be higher than on bare metal.  Reset the timer
  * unconditionally to give the host a chance to perform EH.
+ *
+ * If 'timed_out_enabled' is set, the timeout handler polls or kicks the
+ * virtqueue on purpose, in order to recover the IO, in case there is loss
+ * of interrupt or kick issue with virtio.
  */
 static enum blk_eh_timer_return virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 {
+	struct Scsi_Host *shost;
+	struct virtio_scsi *vscsi;
+	struct virtio_scsi_vq *req_vq;
+
+	if (!timed_out_enabled)
+		return BLK_EH_RESET_TIMER;
+
+	shost = scmnd->device->host;
+	vscsi = shost_priv(shost);
+	req_vq = virtscsi_pick_vq_mq(vscsi, scmnd);
+
+	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
+
+	if (test_bit(SCMD_STATE_COMPLETE, &scmnd->state)) {
+		pr_warn("Virtio SCSI HBA %u: I/O %u QID %d timeout, completion polled\n",
+			shost->host_no, scmnd->tag, req_vq->vq->index);
+		return BLK_EH_DONE;
+	}
+
+	/*
+	 * To kick the virtqueue in case the timeout is due to the loss of
+	 * one prior notification.
+	 */
+	virtqueue_notify(req_vq->vq);
+
 	return BLK_EH_RESET_TIMER;
 }
 
-- 
2.17.1

