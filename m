From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 05/19] be2iscsi: Display driver name and version in
 device attribute
Date: Wed, 24 Oct 2012 02:00:13 -0500
Message-ID: <508791FD.8060004@cs.wisc.edu>
References: <9fdbe712-1e34-4864-949e-f570426e0b09@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43495 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282Ab2JXHAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2012 03:00:21 -0400
In-Reply-To: <9fdbe712-1e34-4864-949e-f570426e0b09@CMEXHTCAS2.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>

On 10/19/2012 06:12 PM, John Soni Jose wrote:
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c |    2 ++
>  drivers/scsi/be2iscsi/be_mgmt.c |   16 ++++++++++++++++
>  drivers/scsi/be2iscsi/be_mgmt.h |    3 +++
>  3 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 2d1bbb8..bd0f49f 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -153,8 +153,10 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
>  		"\t\t\t\tIO Path Events		: 0x10\n"
>  		"\t\t\t\tConfiguration Path	: 0x20\n");
>  
> +DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
>  struct device_attribute *beiscsi_attrs[] = {
>  	&dev_attr_beiscsi_log_enable,
> +	&dev_attr_beiscsi_drvr_ver,
>  	NULL,
>  };
>  
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index aab5dd3..1ec1db3 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -1136,3 +1136,19 @@ int mgmt_set_vlan(struct beiscsi_hba *phba,
>  	free_mcc_tag(&phba->ctrl, tag);
>  	return 0;
>  }
> +
> +/**
> + * beiscsi_drvr_ver_disp()- Display the driver Name and Version
> + * @dev: ptr to device not used.
> + * @attr: device attribute, not used.
> + * @buf: contains formatted text driver name and version
> + *
> + * return
> + * size of the formatted string
> + **/
> +ssize_t
> +beiscsi_drvr_ver_disp(struct device *dev, struct device_attribute *attr,
> +		       char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, BE_NAME "\n");
> +}


It seems this should just be some sort of standard attr. All drivers
should export the name and version in some standard place to make it
easy for users and tools. Maybe until that day this is ok?

