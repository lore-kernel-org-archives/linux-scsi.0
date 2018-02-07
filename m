From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH v3 2/2] qedi: Cleanup local str variable
Date: Wed, 7 Feb 2018 10:03:36 -0800
Message-ID: <20180207180336.GC27465@straylight.hirudinean.org>
References: <20180207161236.12975-1-nilesh.javali@cavium.com>
 <20180207161236.12975-3-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754109AbeBGSDi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 13:03:38 -0500
Content-Disposition: inline
In-Reply-To: <20180207161236.12975-3-nilesh.javali@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh Javali <nilesh.javali@cavium.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

On Wed, Feb 07, 2018 at 08:12:36AM -0800, Nilesh Javali wrote:
> Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>

Signed-off-by: Chris Leech <cleech@redhat.com>

> ---
>  drivers/scsi/qedi/qedi_main.c | 43 ++++++++++++++++++++-----------------------
>  1 file changed, 20 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index deaed93..47c45a5 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -1735,7 +1735,6 @@ static ssize_t qedi_show_boot_eth_info(void *data, int type, char *buf)
>  {
>  	struct qedi_ctx *qedi = data;
>  	struct nvm_iscsi_initiator *initiator;
> -	char *str = buf;
>  	int rc = 1;
>  	u32 ipv6_en, dhcp_en, ip_len;
>  	struct nvm_iscsi_block *block;
> @@ -1769,32 +1768,32 @@ static ssize_t qedi_show_boot_eth_info(void *data, int type, char *buf)
>  
>  	switch (type) {
>  	case ISCSI_BOOT_ETH_IP_ADDR:
> -		rc = snprintf(str, ip_len, fmt, ip);
> +		rc = snprintf(buf, ip_len, fmt, ip);
>  		break;
>  	case ISCSI_BOOT_ETH_SUBNET_MASK:
> -		rc = snprintf(str, ip_len, fmt, sub);
> +		rc = snprintf(buf, ip_len, fmt, sub);
>  		break;
>  	case ISCSI_BOOT_ETH_GATEWAY:
> -		rc = snprintf(str, ip_len, fmt, gw);
> +		rc = snprintf(buf, ip_len, fmt, gw);
>  		break;
>  	case ISCSI_BOOT_ETH_FLAGS:
> -		rc = snprintf(str, 3, "%hhd\n",
> +		rc = snprintf(buf, 3, "%hhd\n",
>  			      SYSFS_FLAG_FW_SEL_BOOT);
>  		break;
>  	case ISCSI_BOOT_ETH_INDEX:
> -		rc = snprintf(str, 3, "0\n");
> +		rc = snprintf(buf, 3, "0\n");
>  		break;
>  	case ISCSI_BOOT_ETH_MAC:
> -		rc = sysfs_format_mac(str, qedi->mac, ETH_ALEN);
> +		rc = sysfs_format_mac(buf, qedi->mac, ETH_ALEN);
>  		break;
>  	case ISCSI_BOOT_ETH_VLAN:
> -		rc = snprintf(str, 12, "%d\n",
> +		rc = snprintf(buf, 12, "%d\n",
>  			      GET_FIELD2(initiator->generic_cont0,
>  					 NVM_ISCSI_CFG_INITIATOR_VLAN));
>  		break;
>  	case ISCSI_BOOT_ETH_ORIGIN:
>  		if (dhcp_en)
> -			rc = snprintf(str, 3, "3\n");
> +			rc = snprintf(buf, 3, "3\n");
>  		break;
>  	default:
>  		rc = 0;
> @@ -1830,7 +1829,6 @@ static ssize_t qedi_show_boot_ini_info(void *data, int type, char *buf)
>  {
>  	struct qedi_ctx *qedi = data;
>  	struct nvm_iscsi_initiator *initiator;
> -	char *str = buf;
>  	int rc;
>  	struct nvm_iscsi_block *block;
>  
> @@ -1842,7 +1840,7 @@ static ssize_t qedi_show_boot_ini_info(void *data, int type, char *buf)
>  
>  	switch (type) {
>  	case ISCSI_BOOT_INI_INITIATOR_NAME:
> -		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
> +		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
>  			     initiator->initiator_name.byte);
>  		break;
>  	default:
> @@ -1871,7 +1869,6 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
>  qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
>  			char *buf, enum qedi_nvm_tgts idx)
>  {
> -	char *str = buf;
>  	int rc = 1;
>  	u32 ctrl_flags, ipv6_en, chap_en, mchap_en, ip_len;
>  	struct nvm_iscsi_block *block;
> @@ -1910,48 +1907,48 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
>  
>  	switch (type) {
>  	case ISCSI_BOOT_TGT_NAME:
> -		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
> +		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
>  			     block->target[idx].target_name.byte);
>  		break;
>  	case ISCSI_BOOT_TGT_IP_ADDR:
>  		if (ipv6_en)
> -			rc = snprintf(str, ip_len, "%pI6\n",
> +			rc = snprintf(buf, ip_len, "%pI6\n",
>  				      block->target[idx].ipv6_addr.byte);
>  		else
> -			rc = snprintf(str, ip_len, "%pI4\n",
> +			rc = snprintf(buf, ip_len, "%pI4\n",
>  				      block->target[idx].ipv4_addr.byte);
>  		break;
>  	case ISCSI_BOOT_TGT_PORT:
> -		rc = snprintf(str, 12, "%d\n",
> +		rc = snprintf(buf, 12, "%d\n",
>  			      GET_FIELD2(block->target[idx].generic_cont0,
>  					 NVM_ISCSI_CFG_TARGET_TCP_PORT));
>  		break;
>  	case ISCSI_BOOT_TGT_LUN:
> -		rc = snprintf(str, 22, "%.*d\n",
> +		rc = snprintf(buf, 22, "%.*d\n",
>  			      block->target[idx].lun.value[1],
>  			      block->target[idx].lun.value[0]);
>  		break;
>  	case ISCSI_BOOT_TGT_CHAP_NAME:
> -		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
> +		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
>  			     chap_name);
>  		break;
>  	case ISCSI_BOOT_TGT_CHAP_SECRET:
> -		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
> +		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
>  			     chap_secret);
>  		break;
>  	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
> -		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
> +		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
>  			     mchap_name);
>  		break;
>  	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
> -		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
> +		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
>  			     mchap_secret);
>  		break;
>  	case ISCSI_BOOT_TGT_FLAGS:
> -		rc = snprintf(str, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);
> +		rc = snprintf(buf, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);
>  		break;
>  	case ISCSI_BOOT_TGT_NIC_ASSOC:
> -		rc = snprintf(str, 3, "0\n");
> +		rc = snprintf(buf, 3, "0\n");
>  		break;
>  	default:
>  		rc = 0;
> -- 
> 1.8.3.1
> 
