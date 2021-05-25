Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050CDC47088
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC30610A8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhEYSIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:08:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhEYSH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:07:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI5Qt4060362;
        Tue, 25 May 2021 18:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Su4W3BAyb8WcHT6WIE6SBIOjo6Gf6G84W0MS1fUQASU=;
 b=htgGKjMyZPALbCp3zb81jNmwVg+tkcXKTXyqcZIbez8goMl8AWY8kA+B3HaO9ol2gjDj
 hBFIEcMJHG0NN8ZP2Rem9nNxCXUdq1/LHvgIUvU3TPV7UVmNbzOQlbmoO0S0NRqZbdO1
 I2dzOsjjqWdFhlbfGZSJMyIRGTSLOLwJIke7LwDhYESItfjOBesAuVcSupeR67wIlQw4
 VFlsQzJ9A0s381P0cRpopIUBSRzpa4ewTGouKi+3DaPdvUX8e3xXEd6tCOcOMvVUzo/L
 ycXodXSzoxRHTcB9GG99G6pbiXrmy73ZiGGRjlZso6Wp2SxY6dvb8PLwBJABOcBlnpAZ zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp6uqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHou15022048;
        Tue, 25 May 2021 18:06:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 38rehapch5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3ZPkzWi/Bj1J/ipvTWVwdPYuNyKil36L6tazABA7Egt5oi6iVb0E+aFJKufIn2fzeJBcXIkuFklE5GiaKVd/aWL3qEFu1gWgOo1KlEEeZR3t7Di56zo+t83zX5GuRm6zoa0wtV4kkv9YEA0E9cbVaowo0wMAvVXCZEd60p6hzuQe+cC5FZ/bQIP4Igyw7OWcV2NiUsONaaMt6lBcIyeUfx2R9eKP66vzCa57s5bjMwD+m/8HbfQU3OhAm3Pa2f1ukOP6HXzvxkHaWRdQWrbjY+oIydhkNDonUJLYWAgenW4S735cJz0Vjmofw1/gLhwdc9w1HhZOMXTpnSgSCA6QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Su4W3BAyb8WcHT6WIE6SBIOjo6Gf6G84W0MS1fUQASU=;
 b=jfopy9m6NbJKKt96sXyCW+oZdzOJirEFxT8R+bHxI8sm9Z5VpwmDYuQOlKtc/YxZLn6eUx/IYjRKrK+vzr5vlS61RHHIUdykgIvJFh2CVqndk//ur7aAcL6zJTtjnwO5A1zF5D6g3JZoru0sBzHjh5ousFW1wCKEkebheBRQYFAIvCmiWelJAyUi8M1LSiRv2aVumhOF9Zj/wfpXx+pdTVRkr+UYxEVKR4VndEeR3DH1cSkiaCp/JHzHIQ7At3KwTVJSn9F0GVwMbHIaCZVemS3ID6tyQOrFsB7JPdncWWP6sOKR4aGsWFi6UtnFJK0wkbdR3+ZUUrGpE1MpG3nUxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Su4W3BAyb8WcHT6WIE6SBIOjo6Gf6G84W0MS1fUQASU=;
 b=Ab8HDJfQekWykgs2LXlqqY0Km1dUdBzOjTj/ZuDlsGTOwB08ONJIhtpd/AGrEgQygc9CYojHo+xcaxrkAfe2hvj/8DLHPfn2+VRFrfhR2r4MYJqNB/CCI7FSuJj9qZGFJ4QnV2NYdGXqoNY4zQAHKBVvcT2wPwH9e/JrN97oj2s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:06:18 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/9] vhost-scsi: flush IO vqs then send TMF rsp
Date:   Tue, 25 May 2021 13:05:56 -0500
Message-Id: <20210525180600.6349-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525180600.6349-1-michael.christie@oracle.com>
References: <20210525180600.6349-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:5:bc::34) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d37ed923-a50e-4b69-bbed-08d91fa7cb00
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431A30061D2EA0BBBC1C127F1259@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0h81gzWEuQPXf+oMwJ8AcPATDcfDpXgY36MVlA0DygjWhWqN8msjk9CDZPDaX559vTjycQTA3eF7T7wQN34pjSeoQShu3UW1FjgYCKtQjrZOLvwqT+oyHhVSFc5vd/OisIB15sS86X9YJ6QzkoqUb+EBz/jG0d94M0IcxUZnuIMhukXrC30PREDqFE7FmDJmQ4epcSwOpP7NIZT9Fjhz2UFFc4LPNYt6FtIB/V4DGej1jsBFcwffEw5mW0LleNB4+W8/avNu6zMu3FQf/W73D/mvFo9Xnw7aw5KIhcFQ+pvuIVchulfhGZQxBwXI8Us1SUyW7rJWzD9RtZfNLdvdxXtudnoiR/wc3BQ2nIMLukP51TJ7Ypoamvg5FgBw6ZJnMIuuPXR6LcWUBRktVGD5bvxOZU//B8dQKAKkJzB9HOY+d/i854BhRHb/4dqkRYJDuQomDTrHZ+DZVINemADGXH1fnFfMBq328E7/vdUYalVV5SjVmVxmV1egDqR6RSHfAny7QvanUaCS/T0B0aTdMqthsWjv3rvmaaTwzkQouWzDlhTTc9KZSGUDmI/Fv0mJi6HyG4kfLa3+QfVDgLGYNvB/p5/BQIDlbbUNHFN/QN8TiXG5chohAjWd+HraqUbM6optnUct+d9NZv92EuLnaVidULTGCCFNujTdh2VEqysX9tyaQuZU4QTSwovxOKie
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(136003)(366004)(6512007)(26005)(38350700002)(186003)(66556008)(66476007)(52116002)(2616005)(8936002)(86362001)(6506007)(38100700002)(83380400001)(956004)(66946007)(8676002)(4326008)(5660300002)(2906002)(1076003)(6486002)(316002)(16526019)(6666004)(107886003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Kd9QX6NsMxXv+cS73goBlpJ7V3saYqdMtt34DuRfyFfgT+pMVmtEnZKKQRPB?=
 =?us-ascii?Q?EF89tOfKjlc8WCJImIKccNeqV5v8kI8q/P0OtxT8HpQnhDktM4hcFTsPsrOV?=
 =?us-ascii?Q?9N5PiIr85HnhelPd1M5GEB7N3VKeesLsMr9IS1DF55IOosuNh4rmKyg+bzKN?=
 =?us-ascii?Q?9baMEI7aXlaQe+Mxd7ZmshIXuRTUyCIWG7aafYKijqDqoVC6RT+x41B3xEjV?=
 =?us-ascii?Q?zHwMaeRwnSP3ST8mlQePeX2CvUmYF8b0urft9h5nF9glNAUVf4mocqtJV0CA?=
 =?us-ascii?Q?5BDp4m4o505Sptig98xmwOahIRqmZVhDbeHeYQPqaDlGOnln9B/TWJi8ElN1?=
 =?us-ascii?Q?syENbuM+1H/aNnWupQ00884TXV9ZZ6sFKdbpmmPeVyR8uLszxcEKDTGW1XmW?=
 =?us-ascii?Q?CwFnTLpQvM419n55ByZda8wYfKjuVlKmvfNaE4uFx2EAhAIvpdaHtRtVxdEf?=
 =?us-ascii?Q?6Iu88tbQ2tAO748lOEbKXMHBSpff6pqqLI+ALMcfIofS45lNZSp42nBErBUS?=
 =?us-ascii?Q?9ofHqGkyWYaR+6EqvFhDb+IiSD3e3n/2MWQupXwDYq2gc+w/RJc2oCCMOSxZ?=
 =?us-ascii?Q?JAIOiHo3h7OLM/lpuJmqBzeI7nIA3ecobJisrm1kYVCWUDY/58OEnANuT1UO?=
 =?us-ascii?Q?2EWm3Zl/2pVn1Kgysjkp8zxt7tybDT5GnE8JcEgTfhuybUhZy9lZIwoWJ4H2?=
 =?us-ascii?Q?Rk6JmWKyemPypO+DTHSBFEPJjVvu/eswNsjMXQjRaBzMpA6pWu73NNAcsvQ0?=
 =?us-ascii?Q?haw+mFaULdiImXJq3OLAz5N74XfV+CeCkegRISjadgvIz9iXDQnk25rimCrv?=
 =?us-ascii?Q?xYcZqc9ZU2rb887CyV9QRQNneQ9TdywAOfOivVBunxqBxAm6DinZzzhwbLal?=
 =?us-ascii?Q?VbcZQg755VWNskdkjCy6PDg7U+vNV5TbSWhBfGjQTiigDD3fLcFut353oK7j?=
 =?us-ascii?Q?ZVHXi9/Dg3oSZkyPdJNfk9m0dLGG4qtrs8zLZaEQPFrWZpVqUGsloJ18pxyp?=
 =?us-ascii?Q?neIPh5Y8iaS48Q6gXFNIzfIQLiJemcIkJezmVEfJvouhZER632KQgLq0SW5D?=
 =?us-ascii?Q?Y3TAF+kZciFpiD+GrHAluNzAK+zqF9vo2XyD1j+Whrnr+yPvEv5m36UuixUg?=
 =?us-ascii?Q?2jnOtBLmKtwRNOKEeagmV/w2TA63LZjvEkisxYjzvJhNXKinAsnYX7uDWcaj?=
 =?us-ascii?Q?BvwYhdrfdjwBKv1mpXLLo9VZ0QhaM7OdUCLAUZz7s81JEUHqnjtT4i3K1gaB?=
 =?us-ascii?Q?nCbSiSufErvuRuy1spAbdZAK/7OR1hKI14A4kYWSvbaKYI+Nctt4FVdd8eW6?=
 =?us-ascii?Q?yFkgfhI+bxSdLJt+bxhMuQM8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d37ed923-a50e-4b69-bbed-08d91fa7cb00
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:17.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEvXM9N2L7pRuEK3erKe8UYSgkJFnbQT1QikUN6gVoOdtXCD7y62u2pSVUiDyFB78ldiuzZo0C+p6DBQ5IQwR1tf7hzPjHOA8omENmTsl64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250110
X-Proofpoint-GUID: U9eXuwFymvfUDjo_crtPeE0Gt4tdyy9y
X-Proofpoint-ORIG-GUID: U9eXuwFymvfUDjo_crtPeE0Gt4tdyy9y
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With one worker we will always send the scsi cmd responses then send the
TMF rsp, because LIO will always complete the scsi cmds first which
calls vhost_scsi_release_cmd to add them to the work queue.

When the next patches adds multiple worker support, the worker threads
could still be sending their responses when the tmf's work is run.
So this patch has vhost-scsi flush the IO vqs on other worker threads
before we send the tmf response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c  | 17 ++++++++++++++---
 drivers/vhost/vhost.c |  6 ++++++
 drivers/vhost/vhost.h |  1 +
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 46f897e41217..e585f2180457 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1168,12 +1168,23 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 {
 	struct vhost_scsi_tmf *tmf = container_of(work, struct vhost_scsi_tmf,
 						  vwork);
-	int resp_code;
+	int resp_code, i;
+
+	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE) {
+		/*
+		 * When processing a TMF lio completes the cmds then the TMF,
+		 * so with one worker the TMF always completes after cmds. For
+		 * multiple worker support we must flush the IO vqs to make
+		 * sure if they have differrent workers then the cmds have
+		 * completed before we send the TMF response.
+		 */
+		for (i = 1; i < tmf->vhost->dev.num_workers; i++)
+			vhost_vq_work_flush(&tmf->vhost->vqs[i + VHOST_SCSI_VQ_IO].vq);
 
-	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE)
 		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
-	else
+	} else {
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+	}
 
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3cc1196d465b..345ade0af133 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -300,6 +300,12 @@ bool vhost_has_work(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_has_work);
 
+void vhost_vq_work_flush(struct vhost_virtqueue *vq)
+{
+	vhost_work_dev_flush_on(vq->worker);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
+
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
 {
 	vhost_work_queue_on(work, vq->worker);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 6880e7a29872..0a252dd45101 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -47,6 +47,7 @@ struct vhost_poll {
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
+void vhost_vq_work_flush(struct vhost_virtqueue *vq);
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-- 
2.25.1

