From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iscsi_ibft: Print correct IPv6 netmask
Date: Wed, 16 Jul 2014 10:34:23 -0700
Message-ID: <20140716173423.GA20528@infradead.org>
References: <1405521089-13993-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1405521089-13993-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>, netdev@linux-kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 04:31:29PM +0200, Hannes Reinecke wrote:
> The iBFT table only specifies a prefix length, so we need to
> check the given IP address to figure out whether the netmask
> should be printed in IPv4 or IPv6 style.

Ccing netdev - maybe someone over there might be able to think of a
helper function that makes this look a little less arcane..

> 
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/firmware/iscsi_ibft.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
> index 071c2c9..7fddab9 100644
> --- a/drivers/firmware/iscsi_ibft.c
> +++ b/drivers/firmware/iscsi_ibft.c
> @@ -212,6 +212,36 @@ static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
>  	return str - buf;
>  }
>  
> +static ssize_t sprintf_netmask(char *buf, u8 *ip, unsigned int prefix_len)
> +{
> +	char *str = buf;
> +
> +	if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0 &&
> +	    ip[4] == 0 && ip[5] == 0 && ip[6] == 0 && ip[7] == 0 &&
> +	    ip[8] == 0 && ip[9] == 0 && ip[10] == 0xff && ip[11] == 0xff) {
> +		__be32 val;
> +		/*
> +		 * IPV4
> +		 */
> +		val = cpu_to_be32(~((1 << (32-prefix_len))-1));
> +		str += sprintf(str, "%pI4", &val);
> +	} else {
> +		u8 netmask[16];
> +		int o = prefix_len >> 3,
> +		    b = prefix_len & 0x7;
> +		/*
> +		 * IPv6
> +		 */
> +		memset(netmask, 0, 16);
> +		memset(netmask, 0xff, o);
> +		if (b != 0)
> +			netmask[o] = 0xff & (0xff00 >> b);
> +		str += sprintf(buf, "%pI6", netmask);
> +	}
> +	str += sprintf(str, "\n");
> +	return str - buf;
> +}
> +
>  static ssize_t sprintf_string(char *str, int len, char *buf)
>  {
>  	return sprintf(str, "%.*s\n", len, buf);
> @@ -288,7 +318,6 @@ static ssize_t ibft_attr_show_nic(void *data, int type, char *buf)
>  	struct ibft_nic *nic = entry->nic;
>  	void *ibft_loc = entry->header;
>  	char *str = buf;
> -	__be32 val;
>  
>  	if (!nic)
>  		return 0;
> @@ -304,8 +333,8 @@ static ssize_t ibft_attr_show_nic(void *data, int type, char *buf)
>  		str += sprintf_ipaddr(str, nic->ip_addr);
>  		break;
>  	case ISCSI_BOOT_ETH_SUBNET_MASK:
> -		val = cpu_to_be32(~((1 << (32-nic->subnet_mask_prefix))-1));
> -		str += sprintf(str, "%pI4", &val);
> +		str += sprintf_netmask(str, nic->ip_addr,
> +				       nic->subnet_mask_prefix);
>  		break;
>  	case ISCSI_BOOT_ETH_ORIGIN:
>  		str += sprintf(str, "%d\n", nic->origin);
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
