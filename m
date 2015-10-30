From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1 22/25] hpsa: enhance device messages
Date: Fri, 30 Oct 2015 15:32:33 +0100
Message-ID: <56337F81.1040403@redhat.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220644.5323.17616.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758975AbbJ3Ocg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 10:32:36 -0400
In-Reply-To: <20151028220644.5323.17616.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 28.10.2015 23:06, Don Brace wrote:
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 33fd0aa..b2418c3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -609,7 +609,7 @@ static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
>  }
>  
>  static const char * const raid_label[] = { "0", "4", "1(+0)", "5", "5+1", "6",
> -	"1(+0)ADM", "UNKNOWN"
> +	"1(+0)ADM", "UNKNOWN", "PHYS DRV"
>  };
>  #define HPSA_RAID_0	0
>  #define HPSA_RAID_4	1
> @@ -618,7 +618,8 @@ static const char * const raid_label[] = { "0", "4", "1(+0)", "5", "5+1", "6",
>  #define HPSA_RAID_51	4
>  #define HPSA_RAID_6	5	/* also used for RAID 60 */
>  #define HPSA_RAID_ADM	6	/* also used for RAID 1+0 ADM */
> -#define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 1)
> +#define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 2)
> +#define PHYSICAL_DRIVE (ARRAY_SIZE(raid_label) - 1)

RAID_UNKNOWN is used in few other places - raid_level_show for example,
shouldn't be that also adapted?

-tm

> /
>  
>  static inline bool is_logical_device(struct hpsa_scsi_dev_t *device)
>  {
> @@ -1144,21 +1145,55 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
>  static void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
>  	struct hpsa_scsi_dev_t *dev, char *description)
>  {
> +#define LABEL_SIZE 25
> +	char label[LABEL_SIZE];
> +
>  	if (dev == NULL)
>  		return;
>  
>  	if (h == NULL || h->pdev == NULL || h->scsi_host == NULL)
>  		return;
>  
> +	switch (dev->devtype) {
> +	case TYPE_RAID:
> +		snprintf(label, LABEL_SIZE, "controller");
> +		break;
> +	case TYPE_ENCLOSURE:
> +		snprintf(label, LABEL_SIZE, "enclosure");
> +		break;
> +	case TYPE_DISK:
> +		if (dev->external)
> +			snprintf(label, LABEL_SIZE, "external");
> +		else if (!is_logical_dev_addr_mode(dev->scsi3addr))
> +			snprintf(label, LABEL_SIZE, "%s",
> +				raid_label[PHYSICAL_DRIVE]);
> +		else
> +			snprintf(label, LABEL_SIZE, "RAID-%s",
> +				dev->raid_level > RAID_UNKNOWN ? "?" :
> +				raid_label[dev->raid_level]);
> +		break;
> +	case TYPE_ROM:
> +		snprintf(label, LABEL_SIZE, "rom");
> +		break;
> +	case TYPE_TAPE:
> +		snprintf(label, LABEL_SIZE, "tape");
> +		break;
> +	case TYPE_MEDIUM_CHANGER:
> +		snprintf(label, LABEL_SIZE, "changer");
> +		break;
> +	default:
> +		snprintf(label, LABEL_SIZE, "UNKNOWN");
> +		break;
> +	}
> +
>  	dev_printk(level, &h->pdev->dev,
> -			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
> +			"scsi %d:%d:%d:%d: %s %s %.8s %.16s %s SSDSmartPathCap%c En%c Exp=%d\n",
>  			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
>  			description,
>  			scsi_device_type(dev->devtype),
>  			dev->vendor,
>  			dev->model,
> -			dev->raid_level > RAID_UNKNOWN ?
> -				"RAID-?" : raid_label[dev->raid_level],
> +			label,
>  			dev->offload_config ? '+' : '-',
>  			dev->offload_enabled ? '+' : '-',
>  			dev->expose_device);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

