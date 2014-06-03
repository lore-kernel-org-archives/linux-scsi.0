From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/2] libiscsi, iser: Adjust data_length to include protection
 information
Date: Tue, 03 Jun 2014 11:06:23 -0500
Message-ID: <538DF27F.50903@cs.wisc.edu>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com> <1401639581-20111-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401639581-20111-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 06/01/2014 11:19 AM, Sagi Grimberg wrote:
>  
> +/*
> + * data integrity helpers
> + */
> +static inline unsigned
> +iscsi_prot_len(unsigned data_len, unsigned sector_size)
> +{
> +	switch (sector_size) {
> +	case 512:
> +		return (data_len >> 9) * 8;
> +	case 1024:
> +		return (data_len >> 10) * 8;
> +	case 2048:
> +		return (data_len >> 11) * 8;
> +	case 4096:
> +		return (data_len >> 12) * 8;
> +	default:
> +		return (data_len >> ilog2(sector_size)) * 8;
> +	}
> +}
>  #endif

I do not think this should not be in the iscsi code.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
