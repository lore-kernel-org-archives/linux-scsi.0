From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: In-kernel QLE2462 driver LU enumeration bug?
Date: Mon, 6 Feb 2006 15:11:50 -0800
Message-ID: <20060206231150.GG9044@andrew-vasquezs-powerbook-g4-15.local>
References: <1138279741.1318.76.camel@echo.e.linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35838 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932363AbWBFXLw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 18:11:52 -0500
Content-Disposition: inline
In-Reply-To: <1138279741.1318.76.camel@echo.e.linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: linux-scsi@vger.kernel.org

On Thu, 26 Jan 2006, Tore Anderson wrote:

>   Hi.  I've had large problems making a setup where I'm using a QLE2462
>  card in order to connect to an EMC CLARiiON AX100.  Port 1 of the HBA
>  is connected to Storage Processor A ("SPA") of the AX100, while port 2
>  is connected to SPB.

Please try the attached patch -- not sure how this was missed as it's
been in my patch-queue for some time.

Thanks,
Andrew Vasquez

---

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7ec0b8d..6544b6d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -814,6 +814,7 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
 
 	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
