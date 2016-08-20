From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH v2] fcoe: provide translation table between Ethernet and
 FC port speeds
Date: Fri, 19 Aug 2016 17:36:28 -0700
Message-ID: <abf83fb9-f283-6fc4-72ae-0fe27d829c61@suse.com>
References: <1471613617-21291-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755529AbcHTAo4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Aug 2016 20:44:56 -0400
In-Reply-To: <1471613617-21291-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On 08/19/2016 06:33 AM, Johannes Thumshirn wrote:
> Provide a translation table between Ethernet and FC port speeds so odd
> speeds (from a Ethernet POV) like 8 Gbit are correctly mapped to sysfs
> and open-fcoe's fcoeadm.
> 
> Before:
>     Description:      BCM57840 NetXtreme II 10/20-Gigabit Ethernet
>     Revision:         11
>     Manufacturer:     Broadcom Corporation
>     Serial Number:    6CC2173EA1D0
> 
>     Driver:           bnx2x 1.712.30-0
>     Number of Ports:  1
> 
>         Symbolic Name:     bnx2fc (QLogic BCM57840) v2.10.3 over eth2
>         OS Device Name:    host1
>         Node Name:         0x20006cc2173ea1d1
>         Port Name:         0x10006cc2173ea1d1
>         FabricName:        0x100000c0dd0ce717
>         Speed:             unknown
>         Supported Speed:   1 Gbit, 10 Gbit
>         MaxFrameSize:      2048 bytes
>         FC-ID (Port ID):   0x660702
>         State:             Online
> 
> After:
>     Description:      BCM57840 NetXtreme II 10/20-Gigabit Ethernet
>     Revision:         11
>     Manufacturer:     Broadcom Corporation
>     Serial Number:    6CC2173EA1D0
> 
>     Driver:           bnx2x 1.712.30-0
>     Number of Ports:  1
> 
>         Symbolic Name:     bnx2fc (QLogic BCM57840) v2.10.3 over eth2
>         OS Device Name:    host1
>         Node Name:         0x20006cc2173ea1d1
>         Port Name:         0x10006cc2173ea1d1
>         FabricName:        0x100000c0dd0ce717
>         Speed:             8 Gbit
>         Supported Speed:   1 Gbit, 10 Gbit
>         MaxFrameSize:      2048 bytes
>         FC-ID (Port ID):   0x660701
>         State:             Online
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
> 
> Changes to v1:
> * Add definitions for non-native Ethernet speeds
> 
>  drivers/scsi/fcoe/fcoe_transport.c | 53 ++++++++++++++++++++++++++------------
>  1 file changed, 36 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index 7028dd3..c164eec 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -83,6 +83,41 @@ static struct notifier_block libfcoe_notifier = {
>  	.notifier_call = libfcoe_device_notification,
>  };
>  
> +static const struct {
> +	u32 fc_port_speed;
> +#define SPEED_2000	2000
> +#define SPEED_4000	4000
> +#define SPEED_8000	8000
> +#define SPEED_16000	16000
> +#define SPEED_32000	32000
> +	u32 eth_port_speed;
> +} fcoe_port_speed_mapping[] = {
> +	{ FC_PORTSPEED_1GBIT,   SPEED_1000   },
> +	{ FC_PORTSPEED_2GBIT,   SPEED_2000   },
> +	{ FC_PORTSPEED_4GBIT,   SPEED_4000   },
> +	{ FC_PORTSPEED_8GBIT,   SPEED_8000   },
> +	{ FC_PORTSPEED_10GBIT,  SPEED_10000  },
> +	{ FC_PORTSPEED_16GBIT,  SPEED_16000  },
> +	{ FC_PORTSPEED_20GBIT,  SPEED_20000  },
> +	{ FC_PORTSPEED_25GBIT,  SPEED_25000  },
> +	{ FC_PORTSPEED_32GBIT,  SPEED_32000  },
> +	{ FC_PORTSPEED_40GBIT,  SPEED_40000  },
> +	{ FC_PORTSPEED_50GBIT,  SPEED_50000  },
> +	{ FC_PORTSPEED_100GBIT, SPEED_100000 },
> +};
> +
> +static inline u32 eth2fc_speed(u32 eth_port_speed)
> +{
> +	int i;
> +
> +	for (i = 0; i <= ARRAY_SIZE(fcoe_port_speed_mapping); i++) {
> +		if (fcoe_port_speed_mapping[i].eth_port_speed == eth_port_speed)
> +			return fcoe_port_speed_mapping[i].fc_port_speed;
> +	}
> +
> +	return FC_PORTSPEED_UNKNOWN;
> +}
> +
>  /**
>   * fcoe_link_speed_update() - Update the supported and actual link speeds
>   * @lport: The local port to update speeds for
> @@ -126,23 +161,7 @@ int fcoe_link_speed_update(struct fc_lport *lport)
>  			    SUPPORTED_40000baseLR4_Full))
>  			lport->link_supported_speeds |= FC_PORTSPEED_40GBIT;
>  
> -		switch (ecmd.base.speed) {
> -		case SPEED_1000:
> -			lport->link_speed = FC_PORTSPEED_1GBIT;
> -			break;
> -		case SPEED_10000:
> -			lport->link_speed = FC_PORTSPEED_10GBIT;
> -			break;
> -		case SPEED_20000:
> -			lport->link_speed = FC_PORTSPEED_20GBIT;
> -			break;
> -		case SPEED_40000:
> -			lport->link_speed = FC_PORTSPEED_40GBIT;
> -			break;
> -		default:
> -			lport->link_speed = FC_PORTSPEED_UNKNOWN;
> -			break;
> -		}Reviewed-by: Lee Duncan <lduncan@suse.com>
> +		lport->link_speed = eth2fc_speed(ecmd.base.speed);
>  		return 0;
>  	}
>  	return -1;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

-- 
Lee Duncan

