From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: RE: [PATCH] qla2xxx: fix for byteswap in fc_host fabric_name
Date: Thu, 22 Mar 2007 16:20:16 -0700
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32BCAD954@AVEXCH2.qlogic.org>
References: <200703221553.l2MFrJEM012956@anacortes.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:23029 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbXCVXUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2007 19:20:25 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200703221553.l2MFrJEM012956@anacortes.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Lary <rlary@austin.ibm.com>, Linux Driver <Linux-Driver@qlogic.com>, linux-scsi@vger.kernel.org

ACK.

This patch will make driver to display correct port name. 
Thank you for findings.

Seokmann 

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Richard Lary
> Sent: Thursday, March 22, 2007 8:53 AM
> To: Linux Driver; linux-scsi@vger.kernel.org
> Subject: [PATCH] qla2xxx: fix for byteswap in fc_host fabric_name
> 
> From: Richard Lary <rlary@us.ibm.com>
> 
> This patch fixes byte swap issue in qla2xxx driver to fix 
> corrupted fabric_name passed to /sys/class/fc_host/host*/fabric_name.
> 
> Signed-off-by: Richard Lary <rlary@us.ibm.com>
> ---
> 
> Example: Switch fabric name: 20:02:00:0d:ec:41:51:01 # cat 
> /sys/class/fc_host/host*/fabric_name
> 0x2200d0041ec0151
> 
> # cat /sys/class/fc_host/host*/fabric_name
> 0x2002000dec415101
> 
> Applies to: 2.6.21-rc4-git5
> 
> Index: b/drivers/scsi/qla2xxx/qla_mbx.c
> ===================================================================
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1280,14 +1280,14 @@ qla2x00_get_port_name(scsi_qla_host_t *h
>  	} else {
>  		if (name != NULL) {
>  			/* This function returns name in big endian. */
> -			name[0] = LSB(mcp->mb[2]);
> -			name[1] = MSB(mcp->mb[2]);
> -			name[2] = LSB(mcp->mb[3]);
> -			name[3] = MSB(mcp->mb[3]);
> -			name[4] = LSB(mcp->mb[6]);
> -			name[5] = MSB(mcp->mb[6]);
> -			name[6] = LSB(mcp->mb[7]);
> -			name[7] = MSB(mcp->mb[7]);
> +			name[0] = MSB(mcp->mb[2]);
> +			name[1] = LSB(mcp->mb[2]);
> +			name[2] = MSB(mcp->mb[3]);
> +			name[3] = LSB(mcp->mb[3]);
> +			name[4] = MSB(mcp->mb[6]);
> +			name[5] = LSB(mcp->mb[6]);
> +			name[6] = MSB(mcp->mb[7]);
> +			name[7] = LSB(mcp->mb[7]);
>  		}
>  
>  		DEBUG11(printk("qla2x00_get_port_name(%ld): done.\n",
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
