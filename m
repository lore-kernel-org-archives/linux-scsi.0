Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110ECC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7BDE22CB8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403869AbhALAZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403877AbhAKXNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 18:13:24 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BMo3GR040130;
        Mon, 11 Jan 2021 18:12:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+PynfPSrmwGMPIiDCYzkA6Jm1QrL5Oi+bjFx8FNL/4M=;
 b=VOgpuEAZNiCbGG4WEJTsjiYFFbMciT6PhnNKe8hz8VRAW1mr1JFoeVg4EwGkynTwtf5K
 Dor61d9I9Rj329AnNJRO7DOI+pRKRBHVYcWJHu8dsTpwO0Clmt7Ax9M5flWTluH5xPbj
 FG7oI5cSDqzQvcSgWwLbvTbTVSD3BXGqD2t+vRnuIS5dmvbTESt6jGdHUdGWdSArU05S
 XHoPd7uQWzYIdDtix/dftDhZYQ8vTXFwF9SW0V35FxwAyuRLUt0sjalXr9E/JtpYHI6M
 RrRJFFLGoGzbobBv6vq3IBrcUaPK+9873jD2TNFewzWew+fma+lkwxpEI7WCjmWphYit 2g== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 360ytk8gjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 18:12:37 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BN80g3008161;
        Mon, 11 Jan 2021 23:12:37 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 35y448xcpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 23:12:37 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BNCZOL25952696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 23:12:35 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 962E378064;
        Mon, 11 Jan 2021 23:12:35 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 324077805C;
        Mon, 11 Jan 2021 23:12:35 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 23:12:35 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v4 16/21] ibmvfc: register Sub-CRQ handles with VIOS during channel setup
Date:   Mon, 11 Jan 2021 17:12:20 -0600
Message-Id: <20210111231225.105347-17-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210111231225.105347-1-tyreld@linux.ibm.com>
References: <20210111231225.105347-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 phishscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110126
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the ibmvfc client adapter requests channels it must submit a number
of Sub-CRQ handles matching the number of channels being requested. The
VIOS in its response will overwrite the actual number of channel
resources allocated which may be less than what was requested. The
client then must store the VIOS Sub-CRQ handle for each queue. This VIOS
handle is needed as a parameter with  h_send_sub_crq().

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 865b87881d86..578e27180f10 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4627,15 +4627,35 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
+	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
+	struct ibmvfc_scsi_channels *scrqs = &vhost->scsi_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
+	int flags, active_queues, i;
 
 	ibmvfc_free_event(evt);
 
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Channel Setup succeded\n");
+		flags = be32_to_cpu(setup->flags);
 		vhost->do_enquiry = 0;
+		active_queues = be32_to_cpu(setup->num_scsi_subq_channels);
+		scrqs->active_queues = active_queues;
+
+		if (flags & IBMVFC_CHANNELS_CANCELED) {
+			ibmvfc_dbg(vhost, "Channels Canceled\n");
+			vhost->using_channels = 0;
+		} else {
+			if (active_queues)
+				vhost->using_channels = 1;
+			for (i = 0; i < active_queues; i++)
+				scrqs->scrqs[i].vios_cookie =
+					be64_to_cpu(setup->channel_handles[i]);
+
+			ibmvfc_dbg(vhost, "Using %u channels\n",
+				   vhost->scsi_scrqs.active_queues);
+		}
 		break;
 	case IBMVFC_MAD_FAILED:
 		level += ibmvfc_retry_host_init(vhost);
@@ -4659,9 +4679,19 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_channel_setup_mad *mad;
 	struct ibmvfc_channel_setup *setup_buf = vhost->channel_setup_buf;
 	struct ibmvfc_event *evt = ibmvfc_get_event(&vhost->crq);
+	struct ibmvfc_scsi_channels *scrqs = &vhost->scsi_scrqs;
+	unsigned int num_channels =
+		min(vhost->client_scsi_channels, vhost->max_vios_scsi_channels);
+	int i;
 
 	memset(setup_buf, 0, sizeof(*setup_buf));
-	setup_buf->flags = cpu_to_be32(IBMVFC_CANCEL_CHANNELS);
+	if (num_channels == 0)
+		setup_buf->flags = cpu_to_be32(IBMVFC_CANCEL_CHANNELS);
+	else {
+		setup_buf->num_scsi_subq_channels = cpu_to_be32(num_channels);
+		for (i = 0; i < num_channels; i++)
+			setup_buf->channel_handles[i] = cpu_to_be64(scrqs->scrqs[i].cookie);
+	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
 	mad = &evt->iu.channel_setup;
-- 
2.27.0

