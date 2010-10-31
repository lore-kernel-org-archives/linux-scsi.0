From: Jaswinder Singh <jaswinder@infradead.org>
Subject: Re: [GIT PATCH] final SCSI updates for the merge window.
Date: Sun, 31 Oct 2010 23:00:17 +0530
Message-ID: <1288546218.3120.4.camel@netbook.satnam>
References: <1288536363.3056.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288536363.3056.7.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Sun, 2010-10-31 at 09:46 -0500, James Bottomley wrote:
> The main pieces of this are qla2xxx, qla4xxx, lpfc megaraid_sas, and
> fcoe driver updates.  Plus some well documented bfa cleanups and a
> couple of assorted bug fixes.
> 
> Also, I'd like to do a queuecommand API change in -rc1.  I'd like to
> push the queue lock out of the mid layer and into the drivers'
> queuecommand routine which will eliminate a spurious lock and unlock for
> drivers that don't need it (should improve latency for multicore) Andi
> Kleen has a coccinelle script to do this mechanically, so it will be a
> big bang single commit for all drivers.  We'll do the optimisations as
> part of the usual enhancements in the next merge window, but I'd like
> the mechanical API change to go in last when the tree is getting stable.
> 
> The current patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> The Short Changelog is:
> 
> Andrew Vasquez (2):
>       qla2xxx: Correct PRLI failure response code handling.
>       qla2xxx: Initialize the vport_slock spinlock.
> 
> Anil Ravindranath (2):
>       pmcraid: add support for set timestamp command and other fixes

This patch looks ugly and it smells bad endian-wise.

Do you mind running endian check on it by :

make C=1 CF="-D__CHECK_ENDIAN__" 


 /**
+ * pmcraid_set_timestamp - set the timestamp to IOAFP
+ *
+ * @cmd: pointer to pmcraid_cmd structure
+ *
+ * Return Value
+ *  0 for success or non-zero for failure cases
+ */
+static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd)
+{
+       struct pmcraid_instance *pinstance = cmd->drv_inst;
+       struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
+       __be32 time_stamp_len = cpu_to_be32(PMCRAID_TIMESTAMP_LEN);
+       struct pmcraid_ioadl_desc *ioadl = ioarcb->add_data.u.ioadl;
+
+       struct timeval tv;
+       __le64 timestamp;
+
+       do_gettimeofday(&tv);
+       timestamp = tv.tv_sec * 1000;
+
+       pinstance->timestamp_data->timestamp[0] = (__u8)(timestamp);
+       pinstance->timestamp_data->timestamp[1] = (__u8)((timestamp) >> 8);
+       pinstance->timestamp_data->timestamp[2] = (__u8)((timestamp) >> 16);
+       pinstance->timestamp_data->timestamp[3] = (__u8)((timestamp) >> 24);
+       pinstance->timestamp_data->timestamp[4] = (__u8)((timestamp) >> 32);
+       pinstance->timestamp_data->timestamp[5] = (__u8)((timestamp)  >> 40);
+
+       pmcraid_reinit_cmdblk(cmd);
+       ioarcb->request_type = REQ_TYPE_SCSI;
+       ioarcb->resource_handle = cpu_to_le32(PMCRAID_IOA_RES_HANDLE);
+       ioarcb->cdb[0] = PMCRAID_SCSI_SET_TIMESTAMP;
+       ioarcb->cdb[1] = PMCRAID_SCSI_SERVICE_ACTION;
+       memcpy(&(ioarcb->cdb[6]), &time_stamp_len, sizeof(time_stamp_len));
+
+       ioarcb->ioadl_bus_addr = cpu_to_le64((cmd->ioa_cb_bus_addr) +
+                                       offsetof(struct pmcraid_ioarcb,
+                                               add_data.u.ioadl[0]));
+       ioarcb->ioadl_length = cpu_to_le32(sizeof(struct pmcraid_ioadl_desc));
+       ioarcb->ioarcb_bus_addr &= ~(0x1FULL);
+

Thanks,
--
Jaswinder Singh.
