From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 03/16] libfcoe: Save some memory and optimize name lookups
Date: Thu, 13 Dec 2012 08:54:10 +0100
Message-ID: <50C989A2.2070400@acm.org>
References: <20121212232203.13084.3630.stgit@fritz> <20121212232219.13084.99143.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:45157 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2LMHyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2012 02:54:19 -0500
In-Reply-To: <20121212232219.13084.99143.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On 12/13/12 00:22, Robert Love wrote:
> @@ -210,25 +210,23 @@ static ssize_t show_fcoe_fcf_device_##field(struct device *dev,	\
>   #define fcoe_enum_name_search(title, table_type, table)			\
>   static const char *get_fcoe_##title##_name(enum table_type table_key)	\
>   {									\
> -	int i;								\
> -	char *name = NULL;						\
> -									\
> -	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
> -		if (table[i].value == table_key) {			\
> -			name = table[i].name;				\
> -			break;						\
> -		}							\
> -	}								\
> -	return name;							\
> +	if (table_key >= ARRAY_SIZE(table))				\
> +		return NULL;						\
> +	return table[table_key];					\
>   }

The old code was safe if table_key < 0 but the new code not. Can 
table_key be negative ?

> +static char *fip_conn_type_names[] = {
> +	[ FIP_CONN_TYPE_UNKNOWN ] = "Unknown",
> +        [ FIP_CONN_TYPE_FABRIC ]  = "Fabric",
> +	[ FIP_CONN_TYPE_VN2VN ]   = "VN2VN",
> +};

A minor nit: indentation style is inconsistent here. Two elements are 
indented with a tab and another with eight spaces.

Bart.
