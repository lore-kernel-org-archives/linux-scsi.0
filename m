From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] libsas: Check that the firmware loader is present in
 sas_request_addr
Date: Thu, 6 Mar 2008 14:04:37 -0800
Message-ID: <20080306140437.8a193423.randy.dunlap@oracle.com>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com>
	<20080306181645.GA6046@kroah.com>
	<47D03666.9080000@oracle.com>
	<20080306210212.GC7430@tree.beaverton.ibm.com>
	<1204838233.3062.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:52001 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717AbYCFWOO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 17:14:14 -0500
In-Reply-To: <1204838233.3062.53.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Greg KH <greg@kroah.com>, linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

On Thu, 06 Mar 2008 15:17:13 -0600 James Bottomley wrote:

> We could do it that way ... I suspect what Greg was asking for was more
> like this:
> 
> James

Builds cleanly for CONFIG_FW_LOADER=n.
I'm having trouble setting CONFIG_FW_LOADER=m for test building it.
Anyway,
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> 
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 33d8f20..4d10c73 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -10,7 +10,10 @@ struct firmware {
>  	size_t size;
>  	u8 *data;
>  };
> +
>  struct device;
> +
> +#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
>  int request_firmware(const struct firmware **fw, const char *name,
>  		     struct device *device);
>  int request_firmware_nowait(
> @@ -19,4 +22,24 @@ int request_firmware_nowait(
>  	void (*cont)(const struct firmware *fw, void *context));
>  
>  void release_firmware(const struct firmware *fw);
> +#else
> +static inline int request_firmware(const struct firmware **fw,
> +				   const char *name,
> +				   struct device *device)
> +{
> +	return -EINVAL;
> +}
> +static inline int request_firmware_nowait(
> +	struct module *module, int uevent,
> +	const char *name, struct device *device, void *context,
> +	void (*cont)(const struct firmware *fw, void *context))
> +{
> +	return -EINVAL;
> +}
> +
> +static inline void release_firmware(const struct firmware *fw)
> +{
> +}
> +#endif
> +
>  #endif

---
~Randy
