From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC Transport : Async Events via netlink interface
Date: Wed, 19 Apr 2006 12:11:16 -0400
Message-ID: <44466124.7000809@emulex.com>
References: <1145306661.4151.0.camel@localhost.localdomain> <20060419145931.GL24104@parisc-linux.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:27612 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750979AbWDSQLT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 12:11:19 -0400
In-Reply-To: <20060419145931.GL24104@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org



Matthew Wilcox wrote:
> enable NET in order to force netlink to be built.  So something like
> this would be enough:
> 
>  config SCSI_FC_ATTRS
>  	tristate "FiberChannel Transport Attributes"
>  	depends on SCSI
> +	select NET
>  	help
>  	  If you wish to export transport-specific information about
>  	  each attached FiberChannel device to sysfs, say Y.

Thanks....

>> +#define get_list_head_entry(pos, head, member) 		\
>> +	pos = list_entry((head)->next, typeof(*pos), member)
>> +
> 
> This one sets alarm bells ringing ...

Please explain why. I've always wondered why the list macros never
let you look, without dequeuing, the head of the list. It will let
you look - as long as you use the functions that make it think
you're going to walk the list.


> I would write this as:
> 
> 	struct fc_nl_user *nluser, *tmp;
> 	list_for_each_entry_safe(nluser, tmp, &fc_nl_user_list, ulist) {
> 		kfree(nluser);
> 	}

ok.. Subtle though, as you have to know you are consuming the entire list.

-- james


