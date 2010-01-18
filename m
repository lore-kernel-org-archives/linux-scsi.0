From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/4] qla2xxx: Add BSG support for FC ELS/CT passthrough
 and vendor commands.
Date: Mon, 18 Jan 2010 16:47:24 -0600
Message-ID: <1263854844.2773.92.camel@mulgrave.site>
References: <1263330169-347-1-git-send-email-giridhar.malavali@qlogic.com>
	 <1263330169-347-3-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab0ARWrd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2010 17:47:33 -0500
In-Reply-To: <1263330169-347-3-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Tue, 2010-01-12 at 13:02 -0800, giridhar.malavali@qlogic.com wrote:
> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 
> Signed-off-by: Sarang Radke <sarang.radke@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |  746
> ++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/qla2xxx/qla_def.h  |  155 ++++++++
>  drivers/scsi/qla2xxx/qla_fw.h   |   33 ++
>  drivers/scsi/qla2xxx/qla_gbl.h  |    5 +
>  drivers/scsi/qla2xxx/qla_init.c |   14 +-
>  drivers/scsi/qla2xxx/qla_iocb.c |  120 +++++++
>  drivers/scsi/qla2xxx/qla_isr.c  |  105 ++++++-
>  drivers/scsi/qla2xxx/qla_mbx.c  |  151 ++++++++
>  drivers/scsi/qla2xxx/qla_os.c   |    1 +
>  9 files changed, 1326 insertions(+), 4 deletions(-)

Did this actually get compile checked?  It's giving me this error:

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla2x00_process_vendor_specific':
drivers/scsi/qla2xxx/qla_attr.c:2233: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'dma_addr_t'
drivers/scsi/qla2xxx/qla_attr.c:2233: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
drivers/scsi/qla2xxx/qla_attr.c:2251: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'dma_addr_t'
drivers/scsi/qla2xxx/qla_attr.c:2251: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'

A simple cast fixes it.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 6ecbda9..5a19aea 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2232,7 +2232,7 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 				vha->host_no, type, vendor_cmd, elreq.options));
 			DEBUG2(qla_printk(KERN_INFO, ha,
 				"scsi(%ld) tx_addr: 0x%llx rx_addr: 0x%llx tx_sg_cnt: %x rx_sg_cnt: %x\n",
-				vha->host_no, elreq.send_dma, elreq.rcv_dma, elreq.req_sg_cnt, elreq.rsp_sg_cnt));
+				vha->host_no, (unsigned long long)elreq.send_dma, (unsigned long long)elreq.rcv_dma, elreq.req_sg_cnt, elreq.rsp_sg_cnt));
 			command_sent = INT_DEF_LB_LOOPBACK_CMD;
 			rval = qla2x00_loopback_test(vha, &elreq, response);
 			if (IS_QLA81XX(ha)) {
@@ -2250,7 +2250,7 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 				vha->host_no, type, vendor_cmd, elreq.options));
 			DEBUG2(qla_printk(KERN_INFO, ha,
 				"scsi(%ld) tx_addr: 0x%llx rx_addr: 0x%llx tx_sg_cnt: %x rx_sg_cnt: %x\n",
-				vha->host_no, elreq.send_dma, elreq.rcv_dma, elreq.req_sg_cnt, elreq.rsp_sg_cnt));
+				vha->host_no, (unsigned long long)elreq.send_dma, (unsigned long long)elreq.rcv_dma, elreq.req_sg_cnt, elreq.rsp_sg_cnt));
 			command_sent = INT_DEF_LB_ECHO_CMD;
 			rval = qla2x00_echo_test(vha, &elreq, response);
 		}


