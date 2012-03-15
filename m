From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: re: qla2xxx: Enable >= 24xx target-mode support in SCSI LLD
Date: Thu, 15 Mar 2012 15:59:44 -0700
Message-ID: <1331852384.10203.118.camel@haakon2.linux-iscsi.org>
References: <20120313172016.GC31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120313172016.GC31808@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-03-13 at 20:20 +0300, Dan Carpenter wrote:
> Hello Nicholas,
> 
> The patch bb52e091fe63: "qla2xxx: Enable >= 24xx target-mode support 
> in SCSI LLD" from Mar 8, 2012, leads to the following Smatch warning:
> 
> drivers/scsi/qla2xxx/qla_mbx.c:1458 qla2x00_get_port_database()
> 	 error: potential null derefence 'pd24'.
> 
> drivers/scsi/qla2xxx/qla_mbx.c
>   1456  
>   1457                  /* If not target must be initiator or unknown type. */
>   1458                  if ((pd24->prli_svc_param_word_3[0] & BIT_4))
>                              ^^^^^^
>   1459                          fcport->port_type = FCT_TARGET;
>   1460                  else if ((pd24->prli_svc_param_word_3[0] & BIT_5))
>                                   ^^^^^^
> These are always NULL here.
> 
>   1461                          fcport->port_type = FCT_INITIATOR;
>   1462  
> 

Fixing this up with the following patch.  Also, I believe this bit has
already be added to mainline, so I'll look at dropping this part of code
from for-next-merge.

Thanks Dan!

--nab

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7b38a66..24a5663 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1407,9 +1407,9 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
                fcport->d_id.b.rsvd_1 = 0;
 
                /* If not target must be initiator or unknown type. */
-               if ((pd24->prli_svc_param_word_3[0] & BIT_4))
+               if ((pd->prli_svc_param_word_3[0] & BIT_4))
                        fcport->port_type = FCT_TARGET;
-               else if ((pd24->prli_svc_param_word_3[0] & BIT_5))
+               else if ((pd->prli_svc_param_word_3[0] & BIT_5))
                        fcport->port_type = FCT_INITIATOR;
 
