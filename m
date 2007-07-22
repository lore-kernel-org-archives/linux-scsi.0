From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/9] qla2xxx: Validate mid-layer 'underflow' during check-condition
 handling.
Date: Sun, 22 Jul 2007 13:50:21 +0300
Message-ID: <46A3366D.9070807@panasas.com>
References: <20070719220456.GK4015@plap.qlogic.org> <11848827641168-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12675 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbXGVKuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 06:50:35 -0400
In-Reply-To: <11848827641168-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Andrew Vasquez wrote:
> From: Shyam Sundar <shyam.sundar@qlogic.com>
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index fa21cd8..4a50b93 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1062,6 +1062,25 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
>  			    cp->device->id, cp->device->lun, cp,
>  			    cp->serial_number));
>  
> +			/*
> +			 * In case of a Underrun condition, set both the lscsi
> +			 * status and the completion status to appropriate
> +			 * values.
> +			 */
> +			if (resid &&
> +			    ((unsigned)(cp->request_bufflen - resid) <
> +			     cp->underflow)) {
> +				DEBUG2(qla_printk(KERN_INFO, ha,
> +				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
> +				    "detected (%x of %x bytes)...returning "
> +				    "error status.\n", ha->host_no,
> +				    cp->device->channel, cp->device->id,
> +				    cp->device->lun, resid,
> +				    cp->request_bufflen));
> +
> +				cp->result = DID_ERROR << 16 | lscsi_status;
> +			}
> +
>  			if (sense_len)
>  				DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
>  				    CMD_ACTUAL_SNSLEN(cp)));
NACK. Breaks data buffers accessors patch. (385d70b4e2659ae525a00e46a9f97146949cfc14)
should be:

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fa21cd8..4a50b93 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1062,6 +1062,25 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			    cp->device->id, cp->device->lun, cp,
 			    cp->serial_number));
 
+			/*
+			 * In case of a Underrun condition, set both the lscsi
+			 * status and the completion status to appropriate
+			 * values.
+			 */
+			if (resid &&
+			    ((unsigned)(scsi_bufflen(cp) - resid) <
+			     cp->underflow)) {
+				DEBUG2(qla_printk(KERN_INFO, ha,
+				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
+				    "detected (%x of %x bytes)...returning "
+				    "error status.\n", ha->host_no,
+				    cp->device->channel, cp->device->id,
+				    cp->device->lun, resid,
+				    scsi_bufflen(cp)));
+
+				cp->result = DID_ERROR << 16 | lscsi_status;
+			}
+
 			if (sense_len)
 				DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
 				    CMD_ACTUAL_SNSLEN(cp)));

