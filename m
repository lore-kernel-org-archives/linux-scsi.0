From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 17/20] be2iscsi: Add support for iscsi boot
Date: Tue, 13 Jul 2010 03:01:35 -0500
Message-ID: <4C3C1D5F.7010201@cs.wisc.edu>
References: <20100712175931.GA11828@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38106 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab0GMH7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2010 03:59:04 -0400
In-Reply-To: <20100712175931.GA11828@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, konrad@darnok.org

On 07/12/2010 12:59 PM, Jayamohan Kallickal wrote:
>    This patch contains changes for adding support for iscsi_boot.
> Have modified to make read of mac address from chip as a function.
>
> Since this is a rarely used call, I would like to make the call
>   to the chip

It actually gets called every logout and every login from the get host 
param path. If you do not have this info it is not going to work.

>
> +static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
> +{
> +	struct beiscsi_hba *phba = data;
> +	char *str = buf;
> +	int rc;
> +
> +	printk(KERN_ERR " In beiscsi_show_boot_tgt_info type=%d\n", type);


I think you wanted this to be a beiscsi debug statement or at least 
KERN_INFO or KERN_DEBUG.


> +
> +static ssize_t beiscsi_show_boot_ini_info(void *data, int type, char *buf)
> +{
> +	struct beiscsi_hba *phba = data;
> +	char *str = buf;
> +	int rc;
> +
> +	printk(KERN_ERR " In beiscsi_show_boot_ini_info type=%d\n", type);

Same as above.

> +static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)
> +{
> +	struct beiscsi_hba *phba = data;
> +	char *str = buf;
> +	int rc;
> +
> +	printk(KERN_ERR " In beiscsi_show_boot_eth_info type = %d\n", type);

Same.

> +
> +static int beiscsi_setup_boot_info(struct beiscsi_hba *phba)
> +{
> +	struct iscsi_boot_kobj *boot_kobj;
> +	char *set_name;
> +
> +	set_name = kasprintf(GFP_KERNEL, "iscsi_boot%u", phba->shost->host_no);
> +	if (!set_name)
> +		return -ENOMEM;
> +
> +	phba->boot_kset = iscsi_boot_create_kset(set_name);
> +	if (!phba->boot_kset) {
> +		kfree(set_name);
> +		return -ENOMEM;
> +	}
> +

You should use iscsi_boot_create_host_kset.
