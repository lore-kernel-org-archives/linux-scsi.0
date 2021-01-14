Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D91C4321A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 516E223A56
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbhANUda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:33:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727703AbhANUcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 15:32:43 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EK3JEx056320;
        Thu, 14 Jan 2021 15:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OVJmnGCGIYi28nfmWuMS2jM2uI1tF69N45Tl2rSaKQ4=;
 b=jBVzLL5SKWynYgYRVMSwy53M2PwbOrzJ9D76mZosjRfGZ1Ko81nL0xAoX8mwK8rvr9VN
 Z16yYUELMx4JxisdLZJQtUU8no8V9z73z638/6KAfOWyOy70fPJyw13nKcX0W6Rewtgs
 pPku1t6FZ3Dg/cKjC3TOT27dppEXFtfdj/wX2M8t4Bn7/vFM0DpBPH+3I263b9IfqWdJ
 p7J3H/44ZXZxDaexkJmniU3uwCpM0uegHJY2qZNDJdMQiYvs8HgWDlCpgzFidXSk7L00
 KrBmDjD8oTAwM0aSOWoPGfX5A6Q/HF4jSlCmKgRDP56Yx8CLUxxmuCdwmElVfLcGuWy+ sg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362vca94eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:31:59 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EKS8W2026137;
        Thu, 14 Jan 2021 20:31:58 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 35y449sneh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:31:58 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EKVu7E26739060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 20:31:57 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E36C66E04C;
        Thu, 14 Jan 2021 20:31:56 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 908CB6E052;
        Thu, 14 Jan 2021 20:31:56 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 20:31:56 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v5 16/21] ibmvfc: register Sub-CRQ handles with VIOS during channel setup
Date:   Thu, 14 Jan 2021 14:31:43 -0600
Message-Id: <20210114203148.246656-17-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210114203148.246656-1-tyreld@linux.ibm.com>
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_07:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101140115
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

