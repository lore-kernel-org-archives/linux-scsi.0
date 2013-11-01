From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] qla2xxx: Add support for ISP8044.
Date: Fri, 1 Nov 2013 13:30:30 +0300
Message-ID: <20131101103030.GL29795@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36832 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3KAKdh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 06:33:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: atul.deshmukh@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hello Atul Deshmukh,

This is a semi-automatic email about new static checker warnings.

The patch 7ec0effd30bb: "[SCSI] qla2xxx: Add support for ISP8044." 
from Aug 27, 2013, leads to the following Smatch complaint:

drivers/scsi/qla2xxx/qla_os.c:2958 qla2x00_probe_one()
	 error: we previously assumed 'base_vha' could be null (see line 2628)

drivers/scsi/qla2xxx/qla_os.c
  2627		base_vha = qla2x00_create_host(sht, ha);
  2628		if (!base_vha) {
                    ^^^^^^^^^
Existing check.

  2629			ret = -ENOMEM;
  2630			qla2x00_mem_free(ha);
  2631			qla2x00_free_req_que(ha, req);
  2632			qla2x00_free_rsp_que(ha, rsp);
  2633			goto probe_hw_failed;
  2634		}

[ snip ]

  2935	probe_failed:
  2936		if (base_vha->timer_active)
  2937			qla2x00_stop_timer(base_vha);
  2938		base_vha->flags.online = 0;
  2939		if (ha->dpc_thread) {
  2940			struct task_struct *t = ha->dpc_thread;
  2941	
  2942			ha->dpc_thread = NULL;
  2943			kthread_stop(t);
  2944		}
  2945	
  2946		qla2x00_free_device(base_vha);
  2947	
  2948		scsi_host_put(base_vha->host);
  2949	
  2950	probe_hw_failed:
  2951		if (IS_QLA82XX(ha)) {
  2952			qla82xx_idc_lock(ha);
  2953			qla82xx_clear_drv_active(ha);
  2954			qla82xx_idc_unlock(ha);
  2955		}
  2956		if (IS_QLA8044(ha)) {
  2957			qla8044_idc_lock(ha);
  2958			qla8044_clear_drv_active(base_vha);
                                                 ^^^^^^^^
Patch introduces new unchecked dereference.

  2959			qla8044_idc_unlock(ha);
  2960		}

regards,
dan carpenter
