From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] bfa: Implement LUN Masking feature using the SCSI Slave
 Callouts.
Date: Wed, 11 Jan 2012 12:32:34 +0300
Message-ID: <20120111093234.GA30629@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44458 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2AKJcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2012 04:32:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org

Hello Krishna Gudipati,

This is a semi-automatic email about new static checker warnings.

The patch 5b7db7af522d: "[SCSI] bfa: Implement LUN Masking feature 
using the SCSI Slave Callouts." from Dec 20, 2011, leads to the 
following Smatch complaint:

drivers/scsi/bfa/bfad_im.c +962 bfad_im_slave_alloc()
	 warn: variable dereferenced before check 'rport' (see line 959)

drivers/scsi/bfa/bfad_im.c
   957          struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
   958		struct bfad_itnim_data_s *itnim_data =
   959					(struct bfad_itnim_data_s *) rport->dd_data;
                                                                     ^^^^^^^
New dereference.

   960		struct bfa_s *bfa = itnim_data->itnim->bfa_itnim->bfa;
   961	
   962		if (!rport || fc_remote_port_chkready(rport))
                     ^^^^^
Old check.

   963			return -ENXIO;
   964	

regards,
dan carpenter

