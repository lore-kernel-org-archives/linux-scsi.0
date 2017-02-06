From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 13/39] megaraid_sas : set residual bytes count during IO compeltion
Date: Mon, 06 Feb 2017 18:52:00 -0500
Message-ID: <yq1poiuubbz.fsf@oracle.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <1486375212-17329-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37131 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbdBFXwP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:52:15 -0500
In-Reply-To: <1486375212-17329-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        (Shivasharan S.'s message of "Mon, 6 Feb 2017 01:59:46 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

>>>>> "Shivasharan" == Shivasharan S <shivasharan.srikanteshwara@broadcom.com> writes:

Shivasharan> Fixing issue of not setting residual bytes correctly.

@@ -1464,6 +1465,15 @@ map_cmd_status(struct fusion_context *fusion,
 			       SCSI_SENSE_BUFFERSIZE);
 			scmd->result |= DRIVER_SENSE << 24;
 		}
+
+		/*
+		 * If the  IO request is partially completed, then MR FW will
+		 * update "io_request->DataLength" field with actual number of
+		 * bytes transferred.Driver will set residual bytes count in
+		 * SCSI command structure.
+		 */
+		resid = (scsi_bufflen(scmd) - data_length);
+		scsi_set_resid(scmd, resid);

Is data_length guaranteed to be a multiple of the logical block size?
Otherwise you need to tweak the residual like we just did for mpt3sas.

-- 
Martin K. Petersen	Oracle Linux Engineering
