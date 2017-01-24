From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] qla2xxx: Avoid that issuing a LIP triggers a kernel
 crash
Date: Tue, 24 Jan 2017 12:59:57 -0200
Message-ID: <91a8f843-c969-72c4-1add-8e44ea2d9a8a@linux.vnet.ibm.com>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
 <20170123163446.9227-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170123163446.9227-3-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Naresh Bannoth <nbannoth@in.ibm.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

First of all, sorry for the new bug; I didn't realize the pointer could
be NULL at this scenario.

On 01/23/2017 02:34 PM, Bart Van Assche wrote:
> @@ -1624,7 +1627,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
>  					 */
>  					sp_get(sp);
>  					spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -					qla2xxx_eh_abort(GET_CMD_SP(sp));
> +					if (scmd)
> +						qla2xxx_eh_abort(scmd);
>  					spin_lock_irqsave(&ha->hardware_lock, flags);
>  				}

Now, this chunk has a problem with reference counting (and unnecessary
spin-locking), which we can avoid by simply moving up this NULL check.

The call to sp_get() increments the sp->ref_count, but if you skip the
call to qla2xxx_eh_abort() you don't get the decrement from the call to
sp->done() at abort handling from ISR, e.g., qla24xx_abort_iocb_entry().
[or if the command completed successfully between issue/complete abort,
at the completion from ISR, e.g., qla2x00_process_completed_request().]

The sp->done() call just below this chunk was supposed to drop the
initial reference [set at qla2xxx_queuecommand()] at a time we did
not call qla2xxx_eh_abort() yet... but now that we __may__ call it
(and get that sp->done() call from the ISR abort handling), we need
to only increment it if we're going to drop it.

That should be resolved with this slight change to your patch
(which also helps w/ the spin-locking).  What do you/others think?

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0a000ecf0881..a17cb63b3fd5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1600,6 +1600,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
         srb_t *sp;
         struct qla_hw_data *ha = vha->hw;
         struct req_que *req;
+       struct scsi_cmnd *scmd;

         qlt_host_reset_handler(ha);

@@ -1613,10 +1614,12 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data 
*ha)
                 for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
                         sp = req->outstanding_cmds[cnt];
                         if (sp) {
+                               scmd = GET_CMD_SP(sp);
+
                                 /* Don't abort commands in adapter 
during EEH
                                  * recovery as it's not 
accessible/responding.
                                  */
-                               if (!ha->flags.eeh_busy) {
+                               if (scmd && !ha->flags.eeh_busy) {
                                         /* Get a reference to the sp 
and drop the lock.
                                          * The reference ensures this 
sp->done() call
                                          * - and not the call in 
qla2xxx_eh_abort() -
@@ -1624,7 +1627,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
                                          */
                                         sp_get(sp);
 
spin_unlock_irqrestore(&ha->hardware_lock, flags);
-                                       qla2xxx_eh_abort(GET_CMD_SP(sp));
+                                       qla2xxx_eh_abort(scmd);
 
spin_lock_irqsave(&ha->hardware_lock, flags);
                                 }
                                 req->outstanding_cmds[cnt] = NULL;


Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
