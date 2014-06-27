From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] b2iscsi: Fix memory leak in mgmt_set_ip()
Date: Fri, 27 Jun 2014 18:32:10 +0200
Message-ID: <53AD9C8A.7010007@redhat.com>
References: <1403873720-9642-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaF0S34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 14:29:56 -0400
In-Reply-To: <1403873720-9642-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, jayamohan.kallickal@emulex.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hch@infradead.org, JBottomley@parallels.com

On 06/27/2014 02:55 PM, Maurizio Lombardi wrote:
> The if_info pointer is not released by the mgmt_set_ip() function
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/be2iscsi/be_mgmt.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index 07934b0..a3e5648 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -1015,7 +1015,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>  		if (if_info->dhcp_state) {
>  			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
>  				    "BG_%d : DHCP Already Enabled\n");
> -			return 0;
> +			goto exit;

rc should be initialised - so this needs to be added to your patch
Cheers, Tomas
@@ -955,7 +955,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 	struct be_dma_mem nonemb_cmd;
 	uint8_t *gtway_addr;
 	uint32_t ip_type;
-	int rc;
+	int rc = 0;
 
 	if (mgmt_get_all_if_id(phba))
 		return -EIO;

>  		}
>  		/* The ip_param->len is 1 in DHCP case. Setting
>  		   proper IP len as this it is used while
> @@ -1033,7 +1033,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>  				sizeof(*reldhcp));
>  
>  			if (rc)
> -				return rc;
> +				goto exit;
>  
>  			reldhcp = nonemb_cmd.va;
>  			reldhcp->interface_hndl = phba->interface_handle;
> @@ -1044,7 +1044,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>  				beiscsi_log(phba, KERN_WARNING,
>  					    BEISCSI_LOG_CONFIG,
>  					    "BG_%d : Failed to Delete existing dhcp\n");
> -				return rc;
> +				goto exit;
>  			}
>  		}
>  	}
> @@ -1054,7 +1054,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>  		rc = mgmt_static_ip_modify(phba, if_info, ip_param, NULL,
>  					   IP_ACTION_DEL);
>  		if (rc)
> -			return rc;
> +			goto exit;
>  	}
>  
>  	/* Delete the Gateway settings if mode change is to DHCP */
> @@ -1064,7 +1064,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>  		if (rc) {
>  			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
>  				    "BG_%d : Failed to Get Gateway Addr\n");
> -			return rc;
> +			goto exit;
>  		}
>  
>  		if (gtway_addr_set.ip_addr.addr[0]) {
> @@ -1076,7 +1076,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>  				beiscsi_log(phba, KERN_WARNING,
>  					    BEISCSI_LOG_CONFIG,
>  					    "BG_%d : Failed to clear Gateway Addr Set\n");
> -				return rc;
> +				goto exit;
>  			}
>  		}
>  	}
> @@ -1087,7 +1087,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>  			OPCODE_COMMON_ISCSI_NTWK_CONFIG_STATELESS_IP_ADDR,
>  			sizeof(*dhcpreq));
>  		if (rc)
> -			return rc;
> +			goto exit;
>  
>  		dhcpreq = nonemb_cmd.va;
>  		dhcpreq->flags = BLOCKING;
> @@ -1095,12 +1095,14 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>  		dhcpreq->interface_hndl = phba->interface_handle;
>  		dhcpreq->ip_type = BE2_DHCP_V4;
>  
> -		return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
> +		rc = mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
>  	} else {
> -		return mgmt_static_ip_modify(phba, if_info, ip_param,
> +		rc = mgmt_static_ip_modify(phba, if_info, ip_param,
>  					     subnet_param, IP_ACTION_ADD);
>  	}
>  
> +exit:
> +	kfree(if_info);
>  	return rc;
>  }
>  

