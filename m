Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A416C83021
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5479221FB
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgLCCJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:09:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729496AbgLCCJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 21:09:05 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B323DqE075470;
        Wed, 2 Dec 2020 21:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=An21lTSeedpbOJBRRtdb3N0VXEp9CNxvAycyR7i/Nyo=;
 b=HbM84/12UsCuQXu4lQcLokOSTfVjzOWSJq5XRuA0HolOAQl6XrMOBB+bXPZp/zZec1Km
 XvpSFraxasIxGCI8Ez84VM58V2/GbCPJxorsYIy5cCKnNx0HGMiXzqKO7YBOsTiM72Lk
 eb743Xu90kZ0lmyq8IG5KyP9sXtZoKMYmdcRjFVT11sYSyQPuVhQZ+/Tdt8Xal/KAnkG
 zHBXHBqe2bHR1y+QwZ9U32Jb2LF8OqDgUSJ0Inb2sNiAfeB6tHTVaNXih7xqLXeF5VfX
 2/8tteh1tG87hAAGRsdUr/Roz8VFMPAScQjciG0Uu8PYGtl6ob+XEZ7eWbyyS9dpPl9d gg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 356jdgexb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 21:08:21 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B327XAx010548;
        Thu, 3 Dec 2020 02:08:20 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 355rf7pxb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 02:08:19 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B328Itq24510844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 02:08:18 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 405F47805E;
        Thu,  3 Dec 2020 02:08:18 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A908178063;
        Thu,  3 Dec 2020 02:08:17 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 02:08:17 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v3 13/18] ibmvfc: register Sub-CRQ handles with VIOS during channel setup
Date:   Wed,  2 Dec 2020 20:08:01 -0600
Message-Id: <20201203020806.14747-14-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203020806.14747-1-tyreld@linux.ibm.com>
References: <20201203020806.14747-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_14:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 phishscore=0 clxscore=1015 suspectscore=3 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030009
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
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index d94db73d4a15..d65de320252e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4512,15 +4512,35 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
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
@@ -4544,9 +4564,19 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_channel_setup_mad *mad;
 	struct ibmvfc_channel_setup *setup_buf = vhost->channel_setup_buf;
 	struct ibmvfc_event *evt = ibmvfc_get_event(vhost);
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

