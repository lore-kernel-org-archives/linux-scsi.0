From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings V2
Date: Wed, 21 Oct 2009 12:39:58 -0500
Message-ID: <4ADF476E.6000901@cs.wisc.edu>
References: <20091017011435.GA25197@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49832 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbZJURkF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 13:40:05 -0400
In-Reply-To: <20091017011435.GA25197@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Adding Qlogic guys on this one, because I think they want something similar.

Jayamohan Kallickal wrote:
>  4) Adds sysfs for FW commands
> 

Jay, what operations are you wanting to do with the binary sysfs file? 
Are there any operations that should be common with Qlogic?

Also if you guys both need binary operations for card specific 
operations then binary sysfs is fine. However, James S had suggested 
using bsg for this too. Since that is upstream now, and you could just 
copy the FC implementation that might be a easier route (I think qlogic 
might have mentioned sysfs was a pain sometimes, and it is something you 
both could work on and help each other out on).



Comment on the implementation.

>  MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
>  
> +static ssize_t
> +beiscsi_sysfs_fw_wr(struct kobject *kobj, struct bin_attribute *bin_attr,
> +		    char *buf, loff_t off, size_t count) {
> +
> +	unsigned int ret_len = 0;
> +	struct Scsi_Host *shost = class_to_shost(container_of(kobj,
> +						 struct device, kobj));
> +	struct beiscsi_hba *phba = iscsi_host_priv(shost);
> +
> +	ret_len = mgmt_fw_cmd(&phba->ctrl, phba, buf, count);


For normal sysfs files I think we normally want it to do only one thing. 
This one seems to be a cmd to exec and the data buffer. I am not sure if 
that is right. Maybe you just want one file per operation. Or maybe you 
want another file for the length of the opertaion so you do not have to 
waste mem on that phba buffer.

Or JamesS's comment offlist about using the bsg pass through stuff is 
also ok. Adding the infrastucture is a little more work, but it is 
probably easier in the long run for the reasons he explained.



> +	if (!ret_len) {
> +		memcpy(buf, phba->attr_mem, count);
> +		return count;
> +	} else
> +		return ret_len;
> +}
> +
> +static ssize_t
> +beiscsi_sysfs_fw_rd(struct kobject *kobj, struct bin_attribute *bin_attr,
> +		    char *buf, loff_t off, size_t count) {
> +
> +	struct Scsi_Host *shost = class_to_shost(container_of(kobj,
> +						 struct device, kobj));
> +	struct beiscsi_hba *phba = iscsi_host_priv(shost);
> +
> +	memcpy(buf, phba->attr_mem, count);
> +	return count;
> +}
> +
> +static struct bin_attribute sysfs_drvr_fw_prgrm_attr = {
> +	.attr = {
> +		.name = "be2iscsi_fw_prgrm",
> +		.mode = S_IRUSR | S_IWUSR,
> +		.owner = THIS_MODULE,
> +	},
> +	.size = 0,
> +	.read = beiscsi_sysfs_fw_rd,
> +	.write = beiscsi_sysfs_fw_wr,
> +};
> +
