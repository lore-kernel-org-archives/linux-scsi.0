From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] fcoe: provide translation table between Ethernet and FC
 port speeds
Date: Fri, 19 Aug 2016 10:37:04 +0200
Message-ID: <7044694b-7991-8daa-55bd-faa603c1f6f8@suse.de>
References: <1471274649-27113-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471274649-27113-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/15/2016 05:24 PM, Johannes Thumshirn wrote:
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
>  drivers/scsi/fcoe/fcoe_transport.c | 48 ++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index 7028dd3..3e7f0e7 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -83,6 +83,36 @@ static struct notifier_block libfcoe_notifier = {
>  	.notifier_call = libfcoe_device_notification,
>  };
>  
> +static const struct {
> +	u32 fc_port_speed;
> +	u32 eth_port_speed;
> +} fcoe_port_speed_mapping[] = {
> +	{ FC_PORTSPEED_1GBIT, SPEED_1000 },
> +	{ FC_PORTSPEED_2GBIT, 2000 },
> +	{ FC_PORTSPEED_4GBIT, 4000 },
> +	{ FC_PORTSPEED_8GBIT, 8000 },
> +	{ FC_PORTSPEED_10GBIT, SPEED_10000 },
> +	{ FC_PORTSPEED_16GBIT, 16000 },
> +	{ FC_PORTSPEED_20GBIT, SPEED_20000  },
> +	{ FC_PORTSPEED_25GBIT, SPEED_25000  },
> +	{ FC_PORTSPEED_32GBIT, 32000 },
> +	{ FC_PORTSPEED_40GBIT, SPEED_40000  },
> +	{ FC_PORTSPEED_50GBIT, SPEED_50000  },
> +	{ FC_PORTSPEED_100GBIT, SPEED_100000 },
> +};
> +
Hmm. Why not 'SPEED_2000' etc?

This looks a bit weird, mixing values with defines ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
