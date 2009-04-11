From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH 02/15] qla2xxx: Export additional FCoE attributes for
 application support.
Date: Sat, 11 Apr 2009 00:19:07 -0700
Message-ID: <49E0446B.3040704@cisco.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com> <1239082431-19496-3-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:9723 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZDKHTJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2009 03:19:09 -0400
In-Reply-To: <1239082431-19496-3-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>



Andrew Vasquez wrote:
> Cull and export VN_Port MAC address and VLAN_ID information on
> supported FCoE ISPs.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |   32 ++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_def.h  |    5 +++++
>  drivers/scsi/qla2xxx/qla_mbx.c  |   14 +++++++++++++-
>  3 files changed, 50 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index b09993a..5d44e3e 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1088,6 +1088,33 @@ qla2x00_flash_block_size_show(struct device *dev,
>  	return snprintf(buf, PAGE_SIZE, "0x%x\n", ha->fdt_block_size);
>  }
>  
> +static ssize_t
> +qla2x00_vlan_id_show(struct device *dev, struct device_attribute *attr,
> +    char *buf)
> +{
> +	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
> +
> +	if (!IS_QLA81XX(vha->hw))
> +		return snprintf(buf, PAGE_SIZE, "\n");
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", vha->fcoe_vlan_id);
> +}
> +
> +static ssize_t
> +qla2x00_vn_port_mac_address_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
> +
> +	if (!IS_QLA81XX(vha->hw))
> +		return snprintf(buf, PAGE_SIZE, "\n");
> +
> +	return snprintf(buf, PAGE_SIZE, "%02x:%02x:%02x:%02x:%02x:%02x\n",
> +	    vha->fcoe_vn_port_mac[5], vha->fcoe_vn_port_mac[4],
> +	    vha->fcoe_vn_port_mac[3], vha->fcoe_vn_port_mac[2],
> +	    vha->fcoe_vn_port_mac[1], vha->fcoe_vn_port_mac[0]);

Should byte 0 be the MSB like most of the kernel's MAC addresses?
I see this is consistent with the way it is fetched from hardware, but
so that would have to be changed, too.

If you use the normal byte order, you could use
the function sysfs_format_mac() for this:

	return sysfs_format_mac(buf, vha->fcoe_vn_port_mac, ETH_ALEN);

Not a big deal, just a suggestion.


> +}
> +
>  static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
>  static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
>  static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
> @@ -1116,6 +1143,9 @@ static DEVICE_ATTR(mpi_version, S_IRUGO, qla2x00_mpi_version_show, NULL);
>  static DEVICE_ATTR(phy_version, S_IRUGO, qla2x00_phy_version_show, NULL);
>  static DEVICE_ATTR(flash_block_size, S_IRUGO, qla2x00_flash_block_size_show,
>  		   NULL);
> +static DEVICE_ATTR(vlan_id, S_IRUGO, qla2x00_vlan_id_show, NULL);
> +static DEVICE_ATTR(vn_port_mac_address, S_IRUGO,
> +		   qla2x00_vn_port_mac_address_show, NULL);
>  
>  struct device_attribute *qla2x00_host_attrs[] = {
>  	&dev_attr_driver_version,
> @@ -1138,6 +1168,8 @@ struct device_attribute *qla2x00_host_attrs[] = {
>  	&dev_attr_mpi_version,
>  	&dev_attr_phy_version,
>  	&dev_attr_flash_block_size,
> +	&dev_attr_vlan_id,
> +	&dev_attr_vn_port_mac_address,
>  	NULL,
>  };
>  
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 714ee67..645cfd9 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2618,6 +2618,11 @@ typedef struct scsi_qla_host {
>  	uint8_t		node_name[WWN_SIZE];
>  	uint8_t		port_name[WWN_SIZE];
>  	uint8_t		fabric_node_name[WWN_SIZE];
> +
> +	uint16_t	fcoe_vlan_id;
> +	uint16_t	fcoe_fcf_idx;
> +	uint8_t		fcoe_vn_port_mac[6];

You could use ETH_ALEN instead of 6.
Want to use u8 instead of uint8_t, etc.?  Maybe that's too big a change.

> +
>  	uint32_t   	vp_abort_cnt;
>  
>  	struct fc_vport	*fc_vport;	/* holds fc_vport * for each vport */
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 1458438..dc5a1fe 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -931,6 +931,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
>  	mcp->mb[9] = vha->vp_idx;
>  	mcp->out_mb = MBX_9|MBX_0;
>  	mcp->in_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
> +	if (IS_QLA81XX(vha->hw))
> +		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
>  	mcp->tov = MBX_TOV_SECONDS;
>  	mcp->flags = 0;
>  	rval = qla2x00_mailbox_command(vha, mcp);
> @@ -952,9 +954,19 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
>  		DEBUG2_3_11(printk("qla2x00_get_adapter_id(%ld): failed=%x.\n",
>  		    vha->host_no, rval));
>  	} else {
> -		/*EMPTY*/
>  		DEBUG11(printk("qla2x00_get_adapter_id(%ld): done.\n",
>  		    vha->host_no));
> +
> +		if (IS_QLA81XX(vha->hw)) {
> +			vha->fcoe_vlan_id = mcp->mb[9] & 0xfff;
> +			vha->fcoe_fcf_idx = mcp->mb[10];
> +			vha->fcoe_vn_port_mac[5] = mcp->mb[11] >> 8;
> +			vha->fcoe_vn_port_mac[4] = mcp->mb[11] & 0xff;
> +			vha->fcoe_vn_port_mac[3] = mcp->mb[12] >> 8;
> +			vha->fcoe_vn_port_mac[2] = mcp->mb[12] & 0xff;
> +			vha->fcoe_vn_port_mac[1] = mcp->mb[13] >> 8;
> +			vha->fcoe_vn_port_mac[0] = mcp->mb[13] & 0xff;

If the mcp->mb[] area can handle single-byte reads and the byte order
is changed, this could just be:
			memcpy(vha->fcoe_vn_port_mac, &mcp->mb[11], ETH_ALEN);


> +		}
>  	}
>  
>  	return rval;
