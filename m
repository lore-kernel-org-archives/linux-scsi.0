From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 11:08:54 -0500
Message-ID: <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41342 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965173AbaFXQKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2014 12:10:03 -0400
In-Reply-To: <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>


On Jun 24, 2014, at 7:53 AM, Martin K. Petersen <martin.petersen@oracle.com> wrote:

>>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:
> 
> Mike> The problem is WRITE_SAME requests are setup so that
> Mike> req->__data_len is the value of the entire request when the setup
> Mike> is completed but during the setup process it's value changes
> 
> Oh, I see. So things break because iSCSI uses scsi_transfer_length()
> where the scatterlist length was used in the past.
> 
> How about this?
> 
> 
> SCSI: Use SCSI data buffer length to extract transfer size
> 
> Commit 8846bab180fa introduced a helper that can be used to query the
> wire transfer size for a SCSI command taking protection information into
> account.
> 
> However, some commands do not have a 1:1 mapping between the block range
> they work on and the payload size (discard, write same). After the
> scatterlist has been set up these requests use __data_len to store the
> number of bytes to report completion on. This means that callers of
> scsi_transfer_length() would get the wrong byte count for these types of
> requests.
> 
> To overcome this we make scsi_transfer_length() use the scatterlist
> length in the scsi_data_buffer as basis for the wire transfer
> calculation instead of __data_len.
> 
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Debugged-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 42ed789ebafc..e0ae71098144 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -318,7 +318,7 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
> 
> static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
> {
> -	unsigned int xfer_len = blk_rq_bytes(scmd->request);
> +	unsigned int xfer_len = scsi_out(scmd)->length;
> 	unsigned int prot_op = scsi_get_prot_op(scmd);
> 	unsigned int sector_size = scmd->device->sector_size;


Do we need to check for the data direction. Something like

if (scmd->sc_data_direction == DMA_TO_DEVICE)
	xfer_len = scsi_out(scmnd)->length;
else
	xfer_len = scsi_in(scmnd)->length;

