From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 08:53:25 -0400
Message-ID: <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
	<1402477799-24610-2-git-send-email-sagig@mellanox.com>
	<53A920B2.9060503@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53A920B2.9060503@cs.wisc.edu> (Mike Christie's message of "Tue,
	24 Jun 2014 01:54:42 -0500")
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Sagi Grimberg <sagig@mellanox.com>, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:

Mike> The problem is WRITE_SAME requests are setup so that
Mike> req->__data_len is the value of the entire request when the setup
Mike> is completed but during the setup process it's value changes

Oh, I see. So things break because iSCSI uses scsi_transfer_length()
where the scatterlist length was used in the past.

How about this?


SCSI: Use SCSI data buffer length to extract transfer size
    
Commit 8846bab180fa introduced a helper that can be used to query the
wire transfer size for a SCSI command taking protection information into
account.
    
However, some commands do not have a 1:1 mapping between the block range
they work on and the payload size (discard, write same). After the
scatterlist has been set up these requests use __data_len to store the
number of bytes to report completion on. This means that callers of
scsi_transfer_length() would get the wrong byte count for these types of
requests.

To overcome this we make scsi_transfer_length() use the scatterlist
length in the scsi_data_buffer as basis for the wire transfer
calculation instead of __data_len.

Reported-by: Christoph Hellwig <hch@infradead.org>
Debugged-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 42ed789ebafc..e0ae71098144 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -318,7 +318,7 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 {
-	unsigned int xfer_len = blk_rq_bytes(scmd->request);
+	unsigned int xfer_len = scsi_out(scmd)->length;
 	unsigned int prot_op = scsi_get_prot_op(scmd);
 	unsigned int sector_size = scmd->device->sector_size;
 
