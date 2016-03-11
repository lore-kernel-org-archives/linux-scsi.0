From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] bfa: Brocade BFA FC SCSI driver
Date: Fri, 11 Mar 2016 11:25:37 +0300
Message-ID: <20160311082537.GA28779@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41820 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717AbcCKIZp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 03:25:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: huangj@brocade.com
Cc: linux-scsi@vger.kernel.org

Hello Jing Huang,

The patch 7725ccfda597: "[SCSI] bfa: Brocade BFA FC SCSI driver" from
Sep 23, 2009, leads to the following static checker warning:

	drivers/scsi/bfa/bfa_fcs_fcpim.c:596 bfa_fcs_itnim_create()
	error: potentially using uninitialized 'itnim'.

drivers/scsi/bfa/bfa_fcs_fcpim.c
   588          struct bfa_fcs_lport_s *port = rport->port;
   589          struct bfa_fcs_itnim_s *itnim;
                                        ^^^^^
   590          struct bfad_itnim_s   *itnim_drv;
   591  
   592          /*
   593           * call bfad to allocate the itnim
   594           */
   595          bfa_fcb_itnim_alloc(port->fcs->bfad, &itnim, &itnim_drv);
                                                      ^^^^^
This function should probably return negative error codes on failure.

   596          if (itnim == NULL) {
                    ^^^^^^^^^^^^^
   597                  bfa_trc(port->fcs, rport->pwwn);
   598                  return NULL;
   599          }

regards,
dan carpenter
