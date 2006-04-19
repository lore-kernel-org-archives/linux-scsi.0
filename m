From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] FC Transport : Async Events via netlink interface
Date: Wed, 19 Apr 2006 08:59:31 -0600
Message-ID: <20060419145931.GL24104@parisc-linux.org>
References: <1145306661.4151.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43501 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750730AbWDSO7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 10:59:32 -0400
Content-Disposition: inline
In-Reply-To: <1145306661.4151.0.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Mon, Apr 17, 2006 at 04:44:21PM -0400, James Smart wrote:
> PS: Comments on Kconfig change appreciated. I don't have much experience on
>   changing the kernel config and build process.
> 
> diff -upNr a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> --- a/drivers/scsi/Kconfig	2006-03-29 11:53:24.000000000 -0500
> +++ b/drivers/scsi/Kconfig	2006-04-17 12:03:31.000000000 -0400
> @@ -221,7 +221,7 @@ config SCSI_SPI_ATTRS
>  
>  config SCSI_FC_ATTRS
>  	tristate "FiberChannel Transport Attributes"
> -	depends on SCSI
> +	depends on SCSI && NET && NETFILTER && NETFILTER_NETLINK
>  	help
>  	  If you wish to export transport-specific information about
>  	  each attached FiberChannel device to sysfs, say Y.

I would use a select here rather than a depends.  So enabling a driver
that uses FC_ATTRS will force netlink to be added.  However, I think you
have the wrong symbols here.  NETFILTER_NETLINK is the netlink interface
for netfilter -- entirely unrelated.  It looks like you only need to
enable NET in order to force netlink to be built.  So something like
this would be enough:

 config SCSI_FC_ATTRS
 	tristate "FiberChannel Transport Attributes"
 	depends on SCSI
+	select NET
 	help
 	  If you wish to export transport-specific information about
 	  each attached FiberChannel device to sysfs, say Y.


> +#define get_list_head_entry(pos, head, member) 		\
> +	pos = list_entry((head)->next, typeof(*pos), member)
> +

This one sets alarm bells ringing ...

>  static void __exit fc_transport_exit(void)
>  {
> +	struct fc_nl_user *nluser;
> +
> +	sock_release(fc_nl_sock->sk_socket);
> +	netlink_unregister_notifier(&fc_netlink_notifier);
> +	while (!list_empty(&fc_nl_user_list)) {
> +		get_list_head_entry(nluser, &fc_nl_user_list, ulist);
> +		list_del(&nluser->ulist);
> +		kfree(nluser);
> +	}
>  	transport_class_unregister(&fc_transport_class);
>  	transport_class_unregister(&fc_rport_class);
>  	transport_class_unregister(&fc_host_class);

I would write this as:

	struct fc_nl_user *nluser, *tmp;
	list_for_each_entry_safe(nluser, tmp, &fc_nl_user_list, ulist) {
		kfree(nluser);
	}

