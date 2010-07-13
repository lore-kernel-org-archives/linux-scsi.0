From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 17/20] be2iscsi: Add support for iscsi boot
Date: Tue, 13 Jul 2010 11:45:16 -0700
Message-ID: <20100713184516.54da5abd@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:16998 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab0GMSp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2010 14:45:26 -0400
In-Reply-To: 4C3C1D5F.7010201@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, konrad@darnok.org

_____  
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, konrad@darnok.org
Sent: Tue, 13 Jul 2010 01:01:35 -0700
Subject: Re: [PATCH 17/20] be2iscsi: Add support for iscsi boot

On 07/12/2010 12:59 PM, Jayamohan Kallickal wrote:
>    This patch contains changes for adding support for iscsi_boot.
> Have modified to make read of mac address from chip as a function.
>
> Since this is a rarely used call, I would like to make the call
>   to the chip

It actually gets called every logout and every login from the get host 
param path. If you do not have this info it is not going to work.

OK. You want me to cache it? Fine, will do it.

Reg all the comments reg print stetments below, will move
it to be2iscsi debugs.

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

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

