From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] qla2xxx: Fix to allow to reset devices using sg interface
 (sg_reset)
Date: Thu, 27 Jul 2006 21:21:25 +0400
Message-ID: <44C8F615.4060902@vlnb.net>
References: <44C61AE4.2010600@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-01.infobox.ru ([85.249.135.210]:11393 "EHLO
	out-relay-01.infobox.ru") by vger.kernel.org with ESMTP
	id S1751818AbWG0RWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jul 2006 13:22:01 -0400
In-Reply-To: <44C61AE4.2010600@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

Also I've found that without this patch qla2xxx_eh_device_reset() 
refuses to reset the device during normal error recovery carrying out by 
SCSI mid-layer as well. I didn't do deeper investigations though, with 
this patch the error recovery works as expected.

Vlad

Vladislav Bolkhovitin wrote:
> Currently it is impossible to reset provided by Qlogic QLA2xxx driver 
> SCSI devices externally using corresponding sg devices, particularly via 
> sg_reset utility, because qla2xxx driver in qla2xxx_eh_device_reset() 
> function checks if the input scsi_cmnd has its private data (CMD_SP()) 
> attached. Then the found pointer isn't used anywhere inside of 
> qla2xxx_eh_device_reset(). If the RESET request comes from sg device, it 
> doesn't have such private data.
> 
> The attached patch removes check for non-NULL CMD_SP() from 
> qla2xxx_eh_device_reset(), hence allows to reset QLA2xxx's devices using 
> corresponding sg devices.
> 
> Against 2.6.18-rc2.
> 
> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
> 
> Vlad
> 
> P.S. Sorry for the attachment format, I hope there will be no problems 
> with it for such a small patch.
> 
> 
> ------------------------------------------------------------------------
> 
> --- linux-2.6.18-rc2/drivers/scsi/qla2xxx/qla_os.c	2006-07-21 18:05:55.000000000 +0400
> +++ linux-2.6.18-rc2/drivers/scsi/qla2xxx/qla_os.c	2006-07-21 18:07:26.000000000 +0400
> @@ -744,7 +744,6 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
>  {
>  	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
>  	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
> -	srb_t *sp;
>  	int ret;
>  	unsigned int id, lun;
>  	unsigned long serial;
> @@ -755,8 +754,7 @@
>  	lun = cmd->device->lun;
>  	serial = cmd->serial_number;
>  
> -	sp = (srb_t *) CMD_SP(cmd);
> -	if (!sp || !fcport)
> +	if (!fcport)
>  		return ret;
>  
>  	qla_printk(KERN_INFO, ha,

