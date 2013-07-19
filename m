From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: RE: [PATCH 2/2] qla2xxx: Properly set the tagging for commands.
Date: Fri, 19 Jul 2013 09:16:51 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D353A79E5@AVMB1.qlogic.org>
References: <1373654871-29081-1-git-send-email-saurav.kashyap@qlogic.com>
 <1373654871-29081-3-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1373654871-29081-3-git-send-email-saurav.kashyap@qlogic.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This should go to stable also, added in to list. This fixes a BZ https://bugzilla.kernel.org/show_bug.cgi?id=59601

Thanks,
~Saurav


-----Original Message-----
From: Saurav Kashyap [mailto:saurav.kashyap@qlogic.com]
Sent: Saturday, July 13, 2013 12:18 AM
To: jbottomley@parallels.com
Cc: Giridhar Malavali; Saurav Kashyap; Andrew Vasquez; linux-scsi
Subject: [PATCH 2/2] qla2xxx: Properly set the tagging for commands.

Reported-by: Jack Hill <jackhill@jackhill.us>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c index 42ef481..ef0a548 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -419,6 +419,8 @@ qla2x00_start_scsi(srb_t *sp)
                            __constant_cpu_to_le16(CF_SIMPLE_TAG);
                        break;
                }
+       } else {
+               cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
        }

        /* Load SCSI command packet. */
@@ -1307,11 +1309,11 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
                    fcp_cmnd->task_attribute = TSK_ORDERED;
                    break;
                default:
-                   fcp_cmnd->task_attribute = 0;
+                   fcp_cmnd->task_attribute = TSK_SIMPLE;
                    break;
                }
        } else {
-               fcp_cmnd->task_attribute = 0;
+               fcp_cmnd->task_attribute = TSK_SIMPLE;
        }

        cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */ @@ -1525,7 +1527,12 @@ qla24xx_start_scsi(srb_t *sp)
                case ORDERED_QUEUE_TAG:
                        cmd_pkt->task = TSK_ORDERED;
                        break;
+               default:
+                   cmd_pkt->task = TSK_SIMPLE;
+                   break;
                }
+       } else {
+               cmd_pkt->task = TSK_SIMPLE;
        }

        /* Load SCSI command packet. */
--
1.7.7


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
