From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 18/22] Add Fabric assigned WWN support.
Date: Thu, 20 Apr 2017 09:49:10 +0200
Message-ID: <20170420074910.GR6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-19-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S941795AbdDTHtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:49:13 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-19-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:37PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> Adding support for Fabric assigned WWPN and WWNN.
> 
> Firmware sends first FLOGI to fabric with vendor version changes.
> On link up driver gets updated service parameter with FAWWN assigned port
> name.  Driver sends 2nd FLOGI with updated fawwpn and modifies the
> vport->fc_portname in driver.
> 
> Note:
> Soft wwpn will not be allowed when fawwpn is enabled.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Aparrt form the superflous parenthesis like in this hunk:

> @@ -354,9 +356,26 @@ lpfc_update_vport_wwn(struct lpfc_vport *vport)
>  		memcpy(&vport->fc_sparam.nodeName, &vport->fc_nodename,
>  			sizeof(struct lpfc_name));
>  
> -	if (vport->fc_portname.u.wwn[0] == 0 || vport->phba->cfg_soft_wwpn)
> +	/*
> +	 * If the port name has changed, then set the Param changes flag
> +	 * to unreg the login
> +	 */
> +	if ((vport->fc_portname.u.wwn[0] != 0) &&
> +		memcmp(&vport->fc_portname, &vport->fc_sparam.portName,
> +			sizeof(struct lpfc_name)))
> +		vport->vport_flag |= FAWWPN_PARAM_CHG;
> +
> +	if ((vport->fc_portname.u.wwn[0] == 0) ||
> +	    (vport->phba->cfg_soft_wwpn) ||
> +	    (vvvl == 1 && (cpu_to_be32(*fawwpn_key)) == FAPWWN_KEY_VENDOR) ||
> +	    (vport->vport_flag & FAWWPN_SET)) {
>  		memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
>  			sizeof(struct lpfc_name));
> +		vport->vport_flag &= ~FAWWPN_SET;
> +		if (vvvl == 1 && (cpu_to_be32(*fawwpn_key)) ==
> +		    FAPWWN_KEY_VENDOR)
> +			vport->vport_flag |= FAWWPN_SET;
> +	}


Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
