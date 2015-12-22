From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: qla2xxx: Delete session if initiator is gone from FW
Date: Tue, 22 Dec 2015 22:46:17 +0300
Message-ID: <20151222194617.GA31313@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28533 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbbLVTq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2015 14:46:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: alexei@purestorage.com
Cc: linux-scsi@vger.kernel.org

Hello Alexei Potashnik,

The patch b93bb8ecc389: "qla2xxx: Delete session if initiator is gone
from FW" from Dec 17, 2015, leads to the following static checker
warning:

	drivers/scsi/qla2xxx/qla_target.c:3587 qlt_do_ctio_completion()
	warn: impossible condition '(logged_out == 41) => (0-1 == 41)'

drivers/scsi/qla2xxx/qla_target.c
  3580                  case CTIO_PORT_LOGGED_OUT:
  3581                  case CTIO_PORT_UNAVAILABLE:
  3582                  {
  3583                          bool logged_out = (status & 0xFFFF);
  3584                          ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
  3585                              "qla_target(%d): CTIO with %s status %x "
  3586                              "received (state %x, se_cmd %p)\n", vha->vp_idx,
  3587                              (logged_out == CTIO_PORT_LOGGED_OUT) ?
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Bool cannot equal 0x26.

  3588                              "PORT LOGGED OUT" : "PORT UNAVAILABLE",
  3589                              status, cmd->state, se_cmd);
  3590  
  3591                          if (logged_out && cmd->sess) {
                                    ^^^^^^^^^^
	== CTIO_PORT_LOGGED_OUT here?

  3592                                  /*
  3593                                   * Session is already logged out, but we need
  3594                                   * to notify initiator, who's not aware of this
  3595                                   */
  3596                                  cmd->sess->logout_on_delete = 0;
  3597                                  cmd->sess->send_els_logo = 1;
  3598                                  qlt_schedule_sess_for_deletion(cmd->sess, true);
  3599                          }
  3600                          break;
  3601                  }

regards,
dan carpenter
