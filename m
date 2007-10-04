From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [RFC] [PATCH 1/2] blk request timeout handler patches
Date: Thu, 4 Oct 2007 16:40:55 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01EE627C@otce2k301.adaptec.com>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:37508 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbXJDUlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Oct 2007 16:41:17 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20071004181750.GB16689@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

ACK for the trivial portion surrounding aacraid and ips!

Sincerely -- Mark Salyzyn
 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of 
> malahal@us.ibm.com
> Sent: Thursday, October 04, 2007 2:18 PM
> To: linux-scsi@vger.kernel.org; jens.axboe@oracle.com
> Subject: [RFC] [PATCH 1/2] blk request timeout handler patches
> 
> Mike Christie's patches refreshed to 2.6.23-rc8-mm1.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
. . .
> diff -r 3697367c6e4d drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c	Thu Sep 27 00:12:13 2007 -0700
> +++ b/drivers/scsi/aacraid/aachba.c	Thu Sep 27 00:13:07 2007 -0700
> @@ -1125,7 +1125,7 @@ static struct aac_srb * aac_scsi_common(
>  	srbcmd->id       = cpu_to_le32(scmd_id(cmd));
>  	srbcmd->lun      = cpu_to_le32(cmd->device->lun);
>  	srbcmd->flags    = cpu_to_le32(flag);
> -	timeout = cmd->timeout_per_command/HZ;
> +	timeout = cmd->request->timeout/HZ;
>  	if (timeout == 0)
>  		timeout = 1;
>  	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
. . .
> diff -r 3697367c6e4d drivers/scsi/ips.c
> --- a/drivers/scsi/ips.c	Thu Sep 27 00:12:13 2007 -0700
> +++ b/drivers/scsi/ips.c	Thu Sep 27 00:13:07 2007 -0700
> @@ -3862,7 +3862,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * 
>  		scb->cmd.dcdb.segment_4G = 0;
>  		scb->cmd.dcdb.enhanced_sg = 0;
>  
> -		TimeOut = scb->scsi_cmd->timeout_per_command;
> +		TimeOut = scb->scsi_cmd->request->timeout;
>  
>  		if (ha->subsys->param[4] & 0x00100000) {	
> /* If NEW Tape DCDB is Supported */
>  			if (!scb->sg_len) {
. . .
