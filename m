From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/6] qla2xxx: Send FC4 type NVMe to the management server
Date: Mon, 19 Jun 2017 12:06:41 +0200
Message-ID: <20170619100641.GB19417@linux-x5ow.site>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-5-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751090AbdFSKGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 06:06:43 -0400
Content-Disposition: inline
In-Reply-To: <20170616224744.3681-5-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

On Fri, Jun 16, 2017 at 03:47:42PM -0700, Himanshu Madhani wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
> 
> This patch adds switch command support for FC-4 type of FC-NVMe (0x28)
> for resgistering HBA port to the management server. RFT_ID command is
> used to register FC-4 type of 0x28 and RFF_ID is used to register
> FC-4 features bits for FC-NVMe port.
> 
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---

[...]

> +       ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
> +       /*
> +	* FC-GS-7, 5.2.3.12 FC-4 Features - format
> +	* The format of the FC-4 Features object, as defined by the FC-4,
> +	* Shall be an array of 4-bit values, one for each type code value
> +	*/

Indentation looks a bit odd here. Did you run checkpatch.pl on the series?

> @@ -4634,6 +4637,12 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
>  				    &vha->dpc_flags))
>  					break;
>  			}
> +			if (vha->flags.nvme_enabled) {
> +				if (qla2x00_rff_id(vha, FC4_TYPE_NVME)) {

			if (vha->flags.nvme_enabled && 
			    qla2x00_rff_id(vha, FC4_TYPE_NVME)) 
			    ql_dbg(ql_dbg_disc, vha, 0x2049, ....)

> +					ql_dbg(ql_dbg_disc, vha, 0x2049,
> +					    "Register NVME FC Type Features failed.\n");
> +				}
> +			}

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
