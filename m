From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: fix resource address formatting and add attribute
 for device ID
Date: Tue, 10 Aug 2010 15:32:47 -0500
Message-ID: <4C61B76F.3050100@linux.vnet.ibm.com>
References: <20100810160721.438853503@linux.vnet.ibm.com> <4C617A7A.5070906@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49171 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab0HJUdN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2010 16:33:13 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7AKOxn8019858
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2010 14:24:59 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o7AKX5Mp111054
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2010 14:33:07 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o7AKWqbB006751
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2010 14:32:54 -0600
In-Reply-To: <4C617A7A.5070906@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

On 08/10/2010 11:12 AM, Wayne Boyer wrote:
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2010-08-05 11:23:35.000000000 -0700
> +++ b/drivers/scsi/ipr.h	2010-08-09 10:09:04.000000000 -0700
> @@ -372,7 +372,7 @@ struct ipr_config_table_entry {
> 
>  	struct ipr_res_addr res_addr;
>  	__be32 res_handle;
> -	__be32 reserved4[2];
> +	__be64 lun_wwn;
>  	struct ipr_std_inq_data std_inq_data;
>  }__attribute__ ((packed, aligned (4)));
> 
> @@ -1210,6 +1210,7 @@ struct ipr_resource_entry {
> 
>  	__be32 res_handle;
>  	__be64 dev_id;
> +	__be64 lun_wwn;

This should be two __be32's or just an array of u8's instead,
since this field is not aligned on an 8 byte boundary. You can
use the unaligned accessors to make it easier to deal with.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


