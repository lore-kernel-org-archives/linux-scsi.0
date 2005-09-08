From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] move iscsi to a better place in Kconfig
Date: Thu, 08 Sep 2005 14:23:14 -0500
Message-ID: <43208FA2.8070304@cs.wisc.edu>
References: <1126191378.4845.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:26281 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964945AbVIHTXU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 15:23:20 -0400
In-Reply-To: <1126191378.4845.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alex Aizman <itn780@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Now it looks like we'll have multiple users of the iscsi transport
> class, the iscsi initiator shouldn't really be a dependency of it.  This
> patch moves iscsi to being an initiator in its own right which selects
> the transport attributes.

I think the reason it was a dependency was becuase the transport class 
manages does the lifetime management/refcounting for the 
initiators/iscsi_tcp.c session struct. scsi_transport_iscsi allocates 
the scsi_host, and the initiator/iscsi_tcp.c's session structure is 
allocated in that host_data.


> 
> James
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -235,12 +235,18 @@ config SCSI_ISCSI_ATTRS
>  	  each attached iSCSI device to sysfs, say Y.
>  	  Otherwise, say N.
>  
> +endmenu
> +
> +menu "SCSI low-level drivers"
> +	depends on SCSI!=n
> +
>  config ISCSI_TCP
>  	tristate "iSCSI Initiator over TCP/IP"
> -	depends on SCSI && INET && SCSI_ISCSI_ATTRS
> +	depends on SCSI && INET
>  	select CRYPTO
>  	select CRYPTO_MD5
>  	select CRYPTO_CRC32C
> +	select SCSI_ISCSI_ATTRS
>  	help
>  	 The iSCSI Driver provides a host with the ability to access storage
>  	 through an IP network. The driver uses the iSCSI protocol to transport
> @@ -258,11 +264,6 @@ config ISCSI_TCP
>  
>  	 http://linux-iscsi.sf.net
>  
> -endmenu
> -
> -menu "SCSI low-level drivers"
> -	depends on SCSI!=n
> -
>  config SGIWD93_SCSI
>  	tristate "SGI WD93C93 SCSI Driver"
>  	depends on SGI_IP22 && SCSI
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

