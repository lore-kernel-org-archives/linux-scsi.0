From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS
 RAID controller
Date: Tue, 6 Jan 2015 12:53:08 +0300
Message-ID: <20150106095308.GA8698@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17414 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbAFJxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 04:53:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil_ravindranath@pmc-sierra.com
Cc: linux-scsi@vger.kernel.org

(Sorry, this code is really old, and normally I wouldn't report it but
 I'm making a tutorial).

Hello Anil Ravindranath,

The patch 89a368104150: "[SCSI] pmcraid: PMC-Sierra MaxRAID driver to
support 6Gb/s SAS RAID controller" from Aug 25, 2009, leads to the
following static checker warning:

	drivers/scsi/pmcraid.c:3860 pmcraid_ioctl_passthrough()
	error: potential NULL dereference 'cmd->scsi_cmd'.

drivers/scsi/pmcraid.c
  3764          cmd->scsi_cmd = NULL;
                ^^^^^^^^^^^^^^^^^^^^
We set this to NULL here.

  3765          ioarcb = &(cmd->ioa_cb->ioarcb);
  3766  
  3767          /* Copy the user-provided IOARCB stuff field by field */
  3768          ioarcb->resource_handle = buffer->ioarcb.resource_handle;
  3769          ioarcb->data_transfer_length = buffer->ioarcb.data_transfer_length;
  3770          ioarcb->cmd_timeout = buffer->ioarcb.cmd_timeout;
  3771          ioarcb->request_type = buffer->ioarcb.request_type;
  3772          ioarcb->request_flags0 = buffer->ioarcb.request_flags0;
  3773          ioarcb->request_flags1 = buffer->ioarcb.request_flags1;
  3774          memcpy(ioarcb->cdb, buffer->ioarcb.cdb, PMCRAID_MAX_CDB_LEN);
  3775  
  3776          if (buffer->ioarcb.add_cmd_param_length) {
  3777                  ioarcb->add_cmd_param_length =
  3778                          buffer->ioarcb.add_cmd_param_length;
  3779                  ioarcb->add_cmd_param_offset =
  3780                          buffer->ioarcb.add_cmd_param_offset;
  3781                  memcpy(ioarcb->add_data.u.add_cmd_params,
  3782                          buffer->ioarcb.add_data.u.add_cmd_params,
  3783                          buffer->ioarcb.add_cmd_param_length);
  3784          }
  3785  
  3786          /* set hrrq number where the IOA should respond to. Note that all cmds
  3787           * generated internally uses hrrq_id 0, exception to this is the cmd
  3788           * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
  3789           * hrrq_id assigned here in queuecommand
  3790           */
  3791          ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
  3792                            pinstance->num_hrrq;
  3793  

[ snip ]

  3857                          cmd->ioa_cb->ioarcb.cdb[0]);
  3858  
  3859                  spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
  3860                  cancel_cmd = pmcraid_abort_cmd(cmd);
                                     ^^^^^^^^^^^^^^^^^^^^^^
This will Oops because cmd->scsi_cmd is NULL.

  3861                  spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
  3862  
  3863                  if (cancel_cmd) {

regards,
dan carpenter
