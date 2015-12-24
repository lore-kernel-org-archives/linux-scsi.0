From: Alexei Potashnik <alexei@purestorage.com>
Subject: RE: qla2xxx: Delete session if initiator is gone from FW
Date: Thu, 24 Dec 2015 00:11:25 -0800
Message-ID: <711352de7005df8de3d0df6d13eb17e8@mail.gmail.com>
References: <20151222194617.GA31313@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33812 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbbLXIL1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2015 03:11:27 -0500
Received: by mail-wm0-f46.google.com with SMTP id l126so171941856wml.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Dec 2015 00:11:27 -0800 (PST)
In-Reply-To: <20151222194617.GA31313@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: linux-scsi@vger.kernel.org

I my original patch line 3583 was:

+			bool logged_out = (status & 0xFFFF) ==
CTIO_PORT_LOGGED_OUT;

and line 3587 was:

+			    logged_out ? "PORT LOGGED OUT" : "PORT
UNAVAILABLE",

Forwarding  to Quinn and Himanshu who must have massaged it.

Alexei

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, December 22, 2015 11:46 AM
> To: alexei@purestorage.com
> Cc: linux-scsi@vger.kernel.org
> Subject: re: qla2xxx: Delete session if initiator is gone from FW
>
> Hello Alexei Potashnik,
>
> The patch b93bb8ecc389: "qla2xxx: Delete session if initiator is gone
from
> FW" from Dec 17, 2015, leads to the following static checker
> warning:
>
> 	drivers/scsi/qla2xxx/qla_target.c:3587 qlt_do_ctio_completion()
> 	warn: impossible condition '(logged_out == 41) => (0-1 == 41)'
>
> drivers/scsi/qla2xxx/qla_target.c
>   3580                  case CTIO_PORT_LOGGED_OUT:
>   3581                  case CTIO_PORT_UNAVAILABLE:
>   3582                  {
>   3583                          bool logged_out = (status & 0xFFFF);
>   3584                          ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
>   3585                              "qla_target(%d): CTIO with %s status
%x "
>   3586                              "received (state %x, se_cmd %p)\n",
vha->vp_idx,
>   3587                              (logged_out == CTIO_PORT_LOGGED_OUT)
?
>                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Bool cannot equal 0x26.
>
>   3588                              "PORT LOGGED OUT" : "PORT
UNAVAILABLE",
>   3589                              status, cmd->state, se_cmd);
>   3590
>   3591                          if (logged_out && cmd->sess) {
>                                     ^^^^^^^^^^
> 	== CTIO_PORT_LOGGED_OUT here?
>
>   3592                                  /*
>   3593                                   * Session is already logged
out, but we need
>   3594                                   * to notify initiator, who's
not aware of this
>   3595                                   */
>   3596                                  cmd->sess->logout_on_delete = 0;
>   3597                                  cmd->sess->send_els_logo = 1;
>   3598
qlt_schedule_sess_for_deletion(cmd->sess, true);
>   3599                          }
>   3600                          break;
>   3601                  }
>
> regards,
> dan carpenter
