From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] qla2xxx: Add framework for async fabric discovery
Date: Mon, 6 Feb 2017 14:37:56 +0300
Message-ID: <20170206113755.GA22938@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51097 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdBFLiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 06:38:08 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: quinn.tran@cavium.com
Cc: linux-scsi@vger.kernel.org

Hello Quinn Tran,

The patch b79414ee4988: "qla2xxx: Add framework for async fabric
discovery" from Jan 19, 2017, leads to the following static checker
warning:

	drivers/scsi/qla2xxx/qla_init.c:3910 qla2x00_alloc_fcport()
	warn: use 'flags' here instead of GFP_XXX?

drivers/scsi/qla2xxx/qla_init.c
  3894  fc_port_t *
  3895  qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
  3896  {
  3897          fc_port_t *fcport;
  3898  
  3899          fcport = kzalloc(sizeof(fc_port_t), flags);

In pratice "flags" is always GFP_KERNEL.

  3900          if (!fcport)
  3901                  return NULL;
  3902  
  3903          /* Setup fcport template structure. */
  3904          fcport->vha = vha;
  3905          fcport->port_type = FCT_UNKNOWN;
  3906          fcport->loop_id = FC_NO_LOOP_ID;
  3907          qla2x00_set_fcport_state(fcport, FCS_UNCONFIGURED);
  3908          fcport->supported_classes = FC_COS_UNSPECIFIED;
  3909  
  3910          fcport->ct_desc.ct_sns = dma_alloc_coherent(&vha->hw->pdev->dev,
  3911                  sizeof(struct ct_sns_pkt), &fcport->ct_desc.ct_sns_dma,
  3912                          GFP_ATOMIC);

There isn't an obvious reason why GFP_ATOMIC is required here.

  3913          fcport->disc_state = DSC_DELETED;
  3914          fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
  3915          fcport->deleted = QLA_SESS_DELETED;
  3916          fcport->login_retry = vha->hw->login_retry_count;
  3917          fcport->login_retry = 5;
  3918          fcport->logout_on_delete = 1;
  3919  
  3920          if (!fcport->ct_desc.ct_sns) {
  3921                  ql_log(ql_log_warn, vha, 0xffff,
  3922                      "Failed to allocate ct_sns request.\n");
  3923                  kfree(fcport);
  3924                  fcport = NULL;
  3925          }
  3926          INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
  3927          INIT_LIST_HEAD(&fcport->gnl_entry);
  3928          INIT_LIST_HEAD(&fcport->list);
  3929  
  3930          return fcport;
  3931  }

regards,
dan carpenter
