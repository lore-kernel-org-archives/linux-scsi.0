Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5240EC8301B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 00:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3F84207FF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 00:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgLBAyd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 19:54:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727691AbgLBAyc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 19:54:32 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B20VoM5168161;
        Tue, 1 Dec 2020 19:53:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qZNk9STSil9c1rAgDWaxbhfSAG4Rj3HfKb/TUyv5A9E=;
 b=Yx843BofA7w+SR+KW9RLRSgQEoQKAJt63z1jAlZJHv6nz3F1EzEsqm5Ho2jMW3cp+I/S
 pVrspzWqH3Am0USVfpEabD24IPAhHPlZ1QoWz9gT3dadVEVKdJBHf0piLU4zmiN6taTT
 OqTjMse4BYgiVmN9Lrz05PrxzJdPGY3lnU3VCkkTfR0Q7y/0ExcV5odW/e1EOIN/Rcqr
 3sPjYY+FpnfkU5nJwThILZL3yMIT6ajRvN/N24XT9dIhdQAgb5djUoaAk4qcEz9yeYYv
 4CIfuPTQqLH3DOKolKSwpNYeWAGkxMfoe5C1vWbfhKXdJbJ6sNI61F40rhmKlp7PQPs3 /w== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355jwvgtx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:53:40 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B20bNEf013453;
        Wed, 2 Dec 2020 00:53:39 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 353e69umee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 00:53:39 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B20rblZ10354952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 00:53:38 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2D657805C;
        Wed,  2 Dec 2020 00:53:37 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D3267805E;
        Wed,  2 Dec 2020 00:53:37 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 00:53:37 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 13/17] ibmvfc: register Sub-CRQ handles with VIOS during channel setup
Date:   Tue,  1 Dec 2020 18:53:25 -0600
Message-Id: <20201202005329.4538-14-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201202005329.4538-1-tyreld@linux.ibm.com>
References: <20201202005329.4538-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_12:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 suspectscore=3 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010142
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
index 3bb20bfdaf4b..c1ac2acba5fd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4509,15 +4509,35 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
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
@@ -4541,9 +4561,19 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
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

