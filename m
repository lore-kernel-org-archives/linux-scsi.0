From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/6] mptsas : NULL pointer on big endian systems causing Expander not to tear off
Date: Wed, 2 Sep 2009 11:44:19 +0530
Message-ID: <20090902061408.GC20211@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:42993 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbZIBGha (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 02:37:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org


On Big endian system kernel will crash due to address translation
is not handle properly.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index f744f0f..02a18df 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3314,6 +3314,7 @@ mptsas_send_expander_event(struct fw_event_work *fw_event)
 	expander_data = (MpiEventDataSasExpanderStatusChange_t *)
 	    fw_event->event_data;
 	memcpy(&sas_address, &expander_data->SASAddress, sizeof(__le64));
+	sas_address = le64_to_cpu(sas_address);
 	port_info = mptsas_find_portinfo_by_sas_address(ioc, sas_address);
 
 	if (expander_data->ReasonCode == MPI_EVENT_SAS_EXP_RC_ADDED) {
