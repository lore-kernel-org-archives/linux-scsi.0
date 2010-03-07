From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 21/23] bfa: Support vport create/delete from sysfs.
Date: Sun, 07 Mar 2010 13:27:15 +0530
Message-ID: <1267948635.2812.38.camel@mulgrave.site>
References: <1267846716-23559-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab0CGH52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Mar 2010 02:57:28 -0500
In-Reply-To: <1267846716-23559-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org, adapter_linux_open_src_team@brocade.com, huangj@brocade.com

On Fri, 2010-03-05 at 19:38 -0800, kgudipat@brocade.com wrote:
> From: Krishna Gudipati <kgudipat@brocade.com>
> 
> Change details:
> 
> 	- Made changes to handle vport creation/deletion from sysfs.
> 
> Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
> ---
>  drivers/scsi/bfa/bfad_attr.c |  104 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 104 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
> index d97f691..d20d223 100644
> --- a/drivers/scsi/bfa/bfad_attr.c
> +++ b/drivers/scsi/bfa/bfad_attr.c
> @@ -584,6 +584,106 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
>  	return snprintf(buf, PAGE_SIZE, "%d\n", nrports);
>  }
>  
> +static int
> +bfad_im_parse_wwn(const char *buf, u8 *wwn)
> +{
> +	unsigned int i, j;
> +	memset(wwn, 0, 8);
> +
> +	/* Validate and store the new name */
> +	for (i = 0, j = 0; i < 16; i++) {
> +		if ((*buf >= '0') && (*buf <= '9'))
> +			j = ((j << 4) | (*buf++ - '0'));
> +		else if ((*buf >= 'a') && (*buf <= 'f'))
> +			j = ((j << 4) | ((*buf++ - 'a') + 10));
> +		else if ((*buf >= 'A') && (*buf <= 'F'))
> +			j = ((j << 4) | ((*buf++ - 'A') + 10));
> +		else
> +			return -EINVAL;
> +		if (i % 2) {
> +			wwn[i/2] = j & 0xff;
> +			j = 0;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t
> +bfad_im_vport_create(struct device *cdev, struct device_attribute *attr,
> +			const char *buf, size_t count)
> +{
> +	struct Scsi_Host *shost = class_to_shost(cdev);
> +	struct bfad_im_port_s *im_port =
> +			(struct bfad_im_port_s *) shost->hostdata[0];
> +	struct bfad_s *bfad = im_port->bfad;
> +	struct bfa_port_cfg_s port_cfg;
> +	u8 wwn[8];
> +	int status;
> +
> +	memset(&port_cfg, 0, sizeof(port_cfg));
> +	status = bfad_im_parse_wwn(&buf[0], wwn);
> +	if (status)
> +		return status;
> +	memcpy(&port_cfg.pwwn, wwn, sizeof(wwn));
> +
> +	status = bfad_im_parse_wwn(&buf[17], wwn);
> +	if (status)
> +		return status;
> +	memcpy(&port_cfg.nwwn, wwn, sizeof(wwn));
> +
> +	port_cfg.roles = BFA_PORT_ROLE_FCP_IM;
> +	status = bfad_vport_create(bfad, 0, &port_cfg);
> +	if (status != BFA_STATUS_OK)
> +		return -EIO;
> +
> +	return count;
> +}
> +
> +static ssize_t
> +bfad_im_vport_delete(struct device *cdev, struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct Scsi_Host  *shost = class_to_shost(cdev);
> +	struct bfad_im_port_s *im_port =
> +		(struct bfad_im_port_s *) shost->hostdata[0];
> +	struct bfad_s *bfad = im_port->bfad;
> +	u8 wwn[8];
> +	int status;
> +	unsigned long flags;
> +	struct bfa_fcs_vport_s *fcs_vport;
> +	struct bfad_vport_s *bfad_vport;
> +	struct completion fcomp;
> +
> +	status = bfad_im_parse_wwn(&buf[0], wwn);
> +	if (status)
> +		return status;
> +
> +	spin_lock_irqsave(&bfad->bfad_lock, flags);
> +	fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0, *(wwn_t *)wwn);
> +	if (fcs_vport == NULL) {
> +		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
> +		return -EINVAL;
> +	}
> +
> +	bfad_vport = fcs_vport->vport_drv;
> +	bfad_vport->drv_port.flags |= BFAD_PORT_DELETE;
> +	bfad_vport->comp_del = &fcomp;
> +	init_completion(bfad_vport->comp_del);
> +
> +	status = bfa_fcs_vport_delete(fcs_vport);
> +	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
> +
> +	wait_for_completion(bfad_vport->comp_del);
> +
> +	if (status != BFA_STATUS_OK)
> +		return -EIO;
> +
> +	bfad_os_scsi_host_free(bfad, bfad_vport->drv_port.im_port);
> +	kfree(bfad_vport);
> +	return count;
> +}
> +
>  static          DEVICE_ATTR(serial_number, S_IRUGO,
>  				bfad_im_serial_num_show, NULL);
>  static          DEVICE_ATTR(model, S_IRUGO, bfad_im_model_show, NULL);
> @@ -605,6 +705,8 @@ static          DEVICE_ATTR(number_of_ports, S_IRUGO,
>  static          DEVICE_ATTR(driver_name, S_IRUGO, bfad_im_drv_name_show, NULL);
>  static          DEVICE_ATTR(number_of_discovered_ports, S_IRUGO,
>  				bfad_im_num_of_discovered_ports_show, NULL);
> +static		DEVICE_ATTR(vport_create, S_IWUSR, NULL, bfad_im_vport_create);
> +static		DEVICE_ATTR(vport_delete, S_IWUSR, NULL, bfad_im_vport_delete);
>  
>  struct device_attribute *bfad_im_host_attrs[] = {
>  	&dev_attr_serial_number,
> @@ -619,6 +721,8 @@ struct device_attribute *bfad_im_host_attrs[] = {
>  	&dev_attr_number_of_ports,
>  	&dev_attr_driver_name,
>  	&dev_attr_number_of_discovered_ports,
> +	&dev_attr_vport_create,
> +	&dev_attr_vport_delete,
>  	NULL,
>  };

So this isn't the correct way to do this.  vport handling should be done
through the fc transport class: that way we have unified vport handling
amongst all the FC drivers (currently it supports emulex, qla and zfcp),
which makes consumers and distributions lives much easier.  A good model
to follow for doing this is lpfc: it actually uses duplicate transport
templates for the virtual and physical ports.  Most simply all you need
to do is fill in the vport_create and vport_delete functions of the
transport template.

James


