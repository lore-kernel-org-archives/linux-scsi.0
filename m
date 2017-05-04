From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi: qedf: Cleanup the type of io_log->op
Date: Thu, 4 May 2017 11:07:52 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1705041107260.1192@n6024mn968stm1.qlogic.org>
References: <20170503212357.cdl4e43ihpyzl2w6@mwanda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0060.outbound.protection.outlook.com ([104.47.34.60]:23903
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752126AbdEDPIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 11:08:02 -0400
In-Reply-To: <20170503212357.cdl4e43ihpyzl2w6@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


On Wed, 3 May 2017, 5:23pm, Dan Carpenter wrote:

> We store sc_cmd->cmnd[0] which is an unsigned char in io_log->op so
> this should also be unsigned char.  The other thing is that this is
> displayed in the debugfs:
> 
> 	seq_printf(s, "0x%02x:", io_log->op);
> 
> Smatch complains that the formatting won't work for negative values so
> changing it to unsigned silences that warning as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
> index 40aeb6bb96a2..07ee88200e91 100644
> --- a/drivers/scsi/qedf/qedf.h
> +++ b/drivers/scsi/qedf/qedf.h
> @@ -259,7 +259,7 @@ struct qedf_io_log {
>  	uint16_t task_id;
>  	uint32_t port_id; /* Remote port fabric ID */
>  	int lun;
> -	char op; /* SCSI CDB */
> +	unsigned char op; /* SCSI CDB */
>  	uint8_t lba[4];
>  	unsigned int bufflen; /* SCSI buffer length */
>  	unsigned int sg_count; /* Number of SG elements */
> 

Makes sense.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
