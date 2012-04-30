From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] bfa: Fix to defer vport delete handler invocation till
 firmware logo response.
Date: Mon, 30 Apr 2012 11:20:58 +0300
Message-ID: <20120430082058.GA4459@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:21942 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2D3IVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2012 04:21:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org

Hello Krishna Gudipati,

This is a semi-automatic email about new static checker warnings.

The patch 17c201b3281c: "[SCSI] bfa: Fix to defer vport delete 
handler invocation till firmware logo response." from Apr 9, 2012, 
leads to the following Smatch complaint:

drivers/scsi/bfa/bfa_fcs_lport.c:5725 bfa_fcs_vport_free()
	 warn: variable dereferenced before check 'vport_drv' (see line 5715)

drivers/scsi/bfa/bfa_fcs_lport.c
  5714	
  5715		if (vport_drv->comp_del) {
                    ^^^^^^^^^^^^^^^^^^^
Old dereference.

  5716			complete(vport_drv->comp_del);
  5717			return;
  5718		}
  5719	
  5720		/*
  5721		 * We queue the vport delete work to the IM work_q from here.
  5722		 * The memory for the bfad_vport_s is freed from the FC function
  5723		 * template vport_delete entry point.
  5724		 */
  5725		if (vport_drv)
                    ^^^^^^^^^
New check.

  5726			bfad_im_port_delete(vport_drv->drv_port.bfad,
  5727					&vport_drv->drv_port);

regards,
dan carpenter

