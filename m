From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] ibmvscsi driver - fourth version
Date: 11 Mar 2004 12:43:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079027038.2820.57.camel@mulgrave>
References: <opr3u0ffo7l6e53g@us.ibm.com>
	<20040225134518.A4238@infradead.org>  <opr3xta6gbl6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:61928 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261626AbUCKRpW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 12:45:22 -0500
In-Reply-To: <opr3xta6gbl6e53g@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

+static int map_sg_data(struct scsi_cmnd *cmd,
+		       struct SRP_CMD *srp_cmd, struct device *dev)
+{
[...]
+		data->virtual_address = sg[0].dma_address;
+		data->length = sg[0].dma_length;

This is wrong, you must use the data accessors sg_dma_addres() and
sg_dma_len().


+static int map_single_data(struct scsi_cmnd *cmd,
+			   struct SRP_CMD *srp_cmd, struct device *dev)
+{
[...]
+	data->virtual_address =
+	    (u64) (unsigned long)dma_map_single(dev, cmd->request_buffer,
+						cmd->request_bufflen,
+						DMA_BIDIRECTIONAL);
+	if (data->virtual_address == 0xFFFFFFFF) {
+		printk(KERN_ERR
+		       "ibmvscsi: Unable to map request_buffer for command!\n");

dma_map_single() has no error return currently, what is this trying to
do?

+
+	/* Block requests until we get the SRP login back */
+	scsi_block_requests(host);
+
+	if (!scsi_add_host(hostdata->host, hostdata->dev)) {
+
+		scsi_scan_host(host);
+		return hostdata;
+	}

Er, have you actually tried this ... the block requests will block all
requests including the attempt to scan. I assume the unblock is coming
from the schedule_work, but you're still hanging the rest of the system
waiting for this on a bootup.

+static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
+				   struct ibmvscsi_host_data *hostdata)
+{
[...]
+	if (ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1]) != 0) {
+		list_del(&evt_struct->list);
+
+		cmnd = evt_struct->cmnd;
+		printk(KERN_ERR "ibmvscsi: failed to send event struct\n");
+		unmap_cmd_data(&evt_struct->evt->srp.cmd, hostdata->dev);
+		ibmvscsi_free_event_struct(&hostdata->pool, evt_struct);
+		cmnd->result = DID_ERROR << 16;
+		evt_struct->cmnd_done(cmnd);
+	}

This is still in the queuecommand path.  Are you sure you want to end
the command with DID_ERROR here, which will decrement the retry count in
error handling rather than returning SCSI_MQUEUE_DEVICE_BUSY?

There seem to be other places in the driver where the return status of
ibmvscsi_send_crq isn't being checked, should it be?

James


