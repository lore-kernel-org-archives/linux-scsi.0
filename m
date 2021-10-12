Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6B8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 00:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92CA460F14
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 00:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhJLBBk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 21:01:40 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:32737 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhJLBBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 21:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634000379; x=1665536379;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jAwU+E0enN/GskkqxO0apWzzzQVB78XhEvXft7VFBBE=;
  b=ADlbYOWdRceojSMcjJveu7m+gOIb4URPCQLOHbeXGrNEr2r948f/PG8m
   Y7AyI4n4KOlJDVrGAZRO5Got/4xIcnQ0TC71u3pe5tagCTQtJmn76M34W
   r0VuSoyFqIymBWtTlrmq8lB/NreytEg31vQpB3eRctaLPXJuGgc0ax1mW
   5XL+Nrve4QuAExnteyeqyPDFgWh0IpM35b8XQvNpw8EXT1LzkOe7uvaVv
   yFbKNHnWJpW8wwaKwhkKeWe5jxZOVcVqMiNrUYqQPfgZ2jT3yyKnrfmXp
   1O+KUE5mXeOlysO4GoAUEALf09qDYdYDUzWFvlsTuCuWRW5UprpEVbL8A
   A==;
X-IronPort-AV: E=Sophos;i="5.85,366,1624291200"; 
   d="scan'208";a="294273395"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Oct 2021 08:59:39 +0800
IronPort-SDR: VtedP/JO5rSiSpFpYZTvlew5aizv/FsjNyOnh6VJvB/yS8Fu7PGKLWUjArVvbdAET3onajJUQc
 rzPqWIATdwUUgWMzwijnU/ffPhvePC3WB1BJPSlRoLWQ17PAqLxQrSvjdwBqj50p3UjSjZMb9H
 lr7c2nR8k7rh3ifY+x1+J95WH1fEsXNMpL4aMZH0EcsL5iotJxQFj/agjTQvydzkN7zu0iSTsH
 64SrslI13AAimIRa4MygeHOgZ9LGqhZDsNxJLQUW2E4f0bhNtIMAyaIUBeEb33nK8RiLfIezlJ
 LIsU0Zts463x45dMgwfJsHGG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 17:33:54 -0700
IronPort-SDR: AdBQOmAVdf5SBIj7nmSWfd7CS6Ili2HaeWPQ686Bvq7b3UjdPVU2nBwPVS19HVCNhBVY0mt84C
 jKfQET5kbfMJPK3O4qmGjOJqc8bdNtD9s3PNLDfxMPyWVXfsVSclQn8qNHqTwouQzuhppC04TD
 /mnEOOteqgvS44ZGH344NEckZv4Zpc1USv04JDDHB2wjVRz110nAGd3E+8ij60XSx1Qmd04PPS
 CVc2MhNKlzXD1rlDuOl6NTb5DcHD4NXquZ+w96AKbYv40EVhNGFdTx+CyQgwqvZbaHYvhLW6cb
 XhE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 17:59:39 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HSy4B5yPQz1RvlJ
        for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2021 17:59:38 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1634000378; x=1636592379; bh=jAwU+E0enN/GskkqxO0apWzzzQVB78XhEvX
        ft7VFBBE=; b=b9fLrIDLcAR1u9mizveeaMZyO9aaT5UQTNOJzDTVmpt8g0UNEAn
        CaYThZeGPG31Ytc1fkEC4sfW99z1oj7saZCx5PAl7fJ+p43yUB0+2h8yQZujyH1b
        UTgyM7V5s46e0ulXw1qIULpMjGpEflM1m+gDoNZVdhksaIQWuI8x/0QJuKXZIw+i
        413OupEitKU9BV+0eUXv5vTh4VasL1G8gnocfijpgfdvR91J3xSmdlx9Nb/i1nD0
        X1G0b4YHaIxwRQak6vDDltJ19xa+hIT5kiWUMfQ0a0znqzoWdGD8J92FVx9+NqeB
        TYfZ0ZLbU2t2tEtsJ6s92bRlHy/CfeibTjQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wj1GoYt-zwnQ for <linux-scsi@vger.kernel.org>;
        Mon, 11 Oct 2021 17:59:38 -0700 (PDT)
Received: from [10.225.163.54] (unknown [10.225.163.54])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HSy494phjz1RvTg;
        Mon, 11 Oct 2021 17:59:37 -0700 (PDT)
Message-ID: <1366628a-358f-6348-e0ac-11f47182093f@opensource.wdc.com>
Date:   Tue, 12 Oct 2021 09:59:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 02/46] ata: Switch to attribute groups
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-3-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20211008202353.1448570-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/9/21 05:23, Bart Van Assche wrote:
> struct device supports attribute groups directly but does not support
> struct device_attribute directly. Hence switch to attribute groups.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/ata/ahci.h        |  8 +++---
>  drivers/ata/ata_piix.c    |  8 +++---
>  drivers/ata/libahci.c     | 52 ++++++++++++++++++++++++++-------------
>  drivers/ata/libata-sata.c | 19 ++++++++++----
>  drivers/ata/libata-scsi.c | 15 ++++++++---
>  drivers/ata/pata_macio.c  |  2 +-
>  drivers/ata/sata_mv.c     |  2 +-
>  drivers/ata/sata_nv.c     |  4 +--
>  drivers/ata/sata_sil24.c  |  2 +-
>  include/linux/libata.h    |  8 +++---
>  10 files changed, 79 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 2e89499bd9c3..eeac5482f1d1 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -376,8 +376,8 @@ struct ahci_host_priv {
>  
>  extern int ahci_ignore_sss;
>  
> -extern struct device_attribute *ahci_shost_attrs[];
> -extern struct device_attribute *ahci_sdev_attrs[];
> +extern const struct attribute_group *ahci_shost_groups[];
> +extern const struct attribute_group *ahci_sdev_groups[];
>  
>  /*
>   * This must be instantiated by the edge drivers.  Read the comments
> @@ -388,8 +388,8 @@ extern struct device_attribute *ahci_sdev_attrs[];
>  	.can_queue		= AHCI_MAX_CMDS,			\
>  	.sg_tablesize		= AHCI_MAX_SG,				\
>  	.dma_boundary		= AHCI_DMA_BOUNDARY,			\
> -	.shost_attrs		= ahci_shost_attrs,			\
> -	.sdev_attrs		= ahci_sdev_attrs,			\
> +	.shost_groups		= ahci_shost_groups,			\
> +	.sdev_groups		= ahci_sdev_groups,			\
>  	.change_queue_depth     = ata_scsi_change_queue_depth,		\
>  	.tag_alloc_policy       = BLK_TAG_ALLOC_RR,             	\
>  	.slave_configure        = ata_scsi_slave_config
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 3ca7720e7d8f..0b2fcf0d1d6c 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -1085,14 +1085,16 @@ static struct ata_port_operations ich_pata_ops = {
>  	.set_dmamode		= ich_set_dmamode,
>  };
>  
> -static struct device_attribute *piix_sidpr_shost_attrs[] = {
> -	&dev_attr_link_power_management_policy,
> +static struct attribute *piix_sidpr_shost_attrs[] = {
> +	&dev_attr_link_power_management_policy.attr,
>  	NULL
>  };
>  
> +ATTRIBUTE_GROUPS(piix_sidpr_shost);
> +
>  static struct scsi_host_template piix_sidpr_sht = {
>  	ATA_BMDMA_SHT(DRV_NAME),
> -	.shost_attrs		= piix_sidpr_shost_attrs,
> +	.shost_groups		= piix_sidpr_shost_groups,
>  };
>  
>  static struct ata_port_operations piix_sidpr_sata_ops = {
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index 5b3fa2cbe722..28430c093a7f 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -108,28 +108,46 @@ static DEVICE_ATTR(em_buffer, S_IWUSR | S_IRUGO,
>  		   ahci_read_em_buffer, ahci_store_em_buffer);
>  static DEVICE_ATTR(em_message_supported, S_IRUGO, ahci_show_em_supported, NULL);
>  
> -struct device_attribute *ahci_shost_attrs[] = {
> -	&dev_attr_link_power_management_policy,
> -	&dev_attr_em_message_type,
> -	&dev_attr_em_message,
> -	&dev_attr_ahci_host_caps,
> -	&dev_attr_ahci_host_cap2,
> -	&dev_attr_ahci_host_version,
> -	&dev_attr_ahci_port_cmd,
> -	&dev_attr_em_buffer,
> -	&dev_attr_em_message_supported,
> +static struct attribute *ahci_shost_attrs[] = {
> +	&dev_attr_link_power_management_policy.attr,
> +	&dev_attr_em_message_type.attr,
> +	&dev_attr_em_message.attr,
> +	&dev_attr_ahci_host_caps.attr,
> +	&dev_attr_ahci_host_cap2.attr,
> +	&dev_attr_ahci_host_version.attr,
> +	&dev_attr_ahci_port_cmd.attr,
> +	&dev_attr_em_buffer.attr,
> +	&dev_attr_em_message_supported.attr,
>  	NULL
>  };
> -EXPORT_SYMBOL_GPL(ahci_shost_attrs);
>  
> -struct device_attribute *ahci_sdev_attrs[] = {
> -	&dev_attr_sw_activity,
> -	&dev_attr_unload_heads,
> -	&dev_attr_ncq_prio_supported,
> -	&dev_attr_ncq_prio_enable,
> +static const struct attribute_group ahci_shost_attr_group = {
> +	.attrs = ahci_shost_attrs
> +};
> +
> +const struct attribute_group *ahci_shost_groups[] = {
> +	&ahci_shost_attr_group,
> +	NULL
> +};
> +EXPORT_SYMBOL_GPL(ahci_shost_groups);
> +
> +struct attribute *ahci_sdev_attrs[] = {
> +	&dev_attr_sw_activity.attr,
> +	&dev_attr_unload_heads.attr,
> +	&dev_attr_ncq_prio_supported.attr,
> +	&dev_attr_ncq_prio_enable.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group ahci_sdev_attr_group = {
> +	.attrs = ahci_sdev_attrs
> +};
> +
> +const struct attribute_group *ahci_sdev_groups[] = {
> +	&ahci_sdev_attr_group,
>  	NULL
>  };
> -EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
> +EXPORT_SYMBOL_GPL(ahci_sdev_groups);
>  
>  struct ata_port_operations ahci_ops = {
>  	.inherits		= &sata_pmp_port_ops,
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 8f3ff830ab0c..79e0f86aa3ae 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -922,13 +922,22 @@ DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
>  	    ata_ncq_prio_enable_show, ata_ncq_prio_enable_store);
>  EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_enable);
>  
> -struct device_attribute *ata_ncq_sdev_attrs[] = {
> -	&dev_attr_unload_heads,
> -	&dev_attr_ncq_prio_enable,
> -	&dev_attr_ncq_prio_supported,
> +struct attribute *ata_ncq_sdev_attrs[] = {
> +	&dev_attr_unload_heads.attr,
> +	&dev_attr_ncq_prio_enable.attr,
> +	&dev_attr_ncq_prio_supported.attr,
>  	NULL
>  };
> -EXPORT_SYMBOL_GPL(ata_ncq_sdev_attrs);
> +
> +static const struct attribute_group ata_ncq_sdev_attr_group = {
> +	.attrs = ata_ncq_sdev_attrs
> +};
> +
> +const struct attribute_group *ata_ncq_sdev_groups[] = {
> +	&ata_ncq_sdev_attr_group,
> +	NULL
> +};
> +EXPORT_SYMBOL_GPL(ata_ncq_sdev_groups);
>  
>  static ssize_t
>  ata_scsi_em_message_store(struct device *dev, struct device_attribute *attr,
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 1fb4611f7eeb..75c54b2761bf 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -234,11 +234,20 @@ static void ata_scsi_set_invalid_parameter(struct ata_device *dev,
>  				     field, 0xff, 0);
>  }
>  
> -struct device_attribute *ata_common_sdev_attrs[] = {
> -	&dev_attr_unload_heads,
> +static struct attribute *ata_common_sdev_attrs[] = {
> +	&dev_attr_unload_heads.attr,
>  	NULL
>  };
> -EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
> +
> +static const struct attribute_group ata_common_sdev_attr_group = {
> +	.attrs = ata_common_sdev_attrs
> +};
> +
> +const struct attribute_group *ata_common_sdev_groups[] = {
> +	&ata_common_sdev_attr_group,
> +	NULL
> +};
> +EXPORT_SYMBOL_GPL(ata_common_sdev_groups);
>  
>  /**
>   *	ata_std_bios_param - generic bios head/sector/cylinder calculator used by sd.
> diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
> index be0ca8d5b345..16e8aa184a75 100644
> --- a/drivers/ata/pata_macio.c
> +++ b/drivers/ata/pata_macio.c
> @@ -923,7 +923,7 @@ static struct scsi_host_template pata_macio_sht = {
>  	 */
>  	.max_segment_size	= MAX_DBDMA_SEG,
>  	.slave_configure	= pata_macio_slave_config,
> -	.sdev_attrs		= ata_common_sdev_attrs,
> +	.sdev_groups		= ata_common_sdev_groups,
>  	.can_queue		= ATA_DEF_QUEUE,
>  	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
>  };
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index 9d86203e1e7a..24130e551b26 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -670,7 +670,7 @@ static struct scsi_host_template mv6_sht = {
>  	.can_queue		= MV_MAX_Q_DEPTH - 1,
>  	.sg_tablesize		= MV_MAX_SG_CT / 2,
>  	.dma_boundary		= MV_DMA_BOUNDARY,
> -	.sdev_attrs             = ata_ncq_sdev_attrs,
> +	.sdev_groups		= ata_ncq_sdev_groups,
>  	.change_queue_depth	= ata_scsi_change_queue_depth,
>  	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
>  	.slave_configure	= ata_scsi_slave_config
> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index c385d18ce87b..16272c111208 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -380,7 +380,7 @@ static struct scsi_host_template nv_adma_sht = {
>  	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
>  	.dma_boundary		= NV_ADMA_DMA_BOUNDARY,
>  	.slave_configure	= nv_adma_slave_config,
> -	.sdev_attrs             = ata_ncq_sdev_attrs,
> +	.sdev_groups		= ata_ncq_sdev_groups,
>  	.change_queue_depth     = ata_scsi_change_queue_depth,
>  	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
>  };
> @@ -391,7 +391,7 @@ static struct scsi_host_template nv_swncq_sht = {
>  	.sg_tablesize		= LIBATA_MAX_PRD,
>  	.dma_boundary		= ATA_DMA_BOUNDARY,
>  	.slave_configure	= nv_swncq_slave_config,
> -	.sdev_attrs             = ata_ncq_sdev_attrs,
> +	.sdev_groups		= ata_ncq_sdev_groups,
>  	.change_queue_depth     = ata_scsi_change_queue_depth,
>  	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
>  };
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index 06a1e27c4f84..f99ec6f7d7c0 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -379,7 +379,7 @@ static struct scsi_host_template sil24_sht = {
>  	.sg_tablesize		= SIL24_MAX_SGE,
>  	.dma_boundary		= ATA_DMA_BOUNDARY,
>  	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
> -	.sdev_attrs		= ata_ncq_sdev_attrs,
> +	.sdev_groups		= ata_ncq_sdev_groups,
>  	.change_queue_depth	= ata_scsi_change_queue_depth,
>  	.slave_configure	= ata_scsi_slave_config
>  };
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index c0c64f03e107..bd1b782d1bbf 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1388,7 +1388,7 @@ extern int ata_link_nr_enabled(struct ata_link *link);
>   */
>  extern const struct ata_port_operations ata_base_port_ops;
>  extern const struct ata_port_operations sata_port_ops;
> -extern struct device_attribute *ata_common_sdev_attrs[];
> +extern const struct attribute_group *ata_common_sdev_groups[];
>  
>  /*
>   * All sht initializers (BASE, PIO, BMDMA, NCQ) must be instantiated
> @@ -1418,14 +1418,14 @@ extern struct device_attribute *ata_common_sdev_attrs[];
>  
>  #define ATA_BASE_SHT(drv_name)					\
>  	ATA_SUBBASE_SHT(drv_name),				\
> -	.sdev_attrs		= ata_common_sdev_attrs
> +	.sdev_groups		= ata_common_sdev_groups
>  
>  #ifdef CONFIG_SATA_HOST
> -extern struct device_attribute *ata_ncq_sdev_attrs[];
> +extern const struct attribute_group *ata_ncq_sdev_groups[];
>  
>  #define ATA_NCQ_SHT(drv_name)					\
>  	ATA_SUBBASE_SHT(drv_name),				\
> -	.sdev_attrs		= ata_ncq_sdev_attrs,		\
> +	.sdev_groups		= ata_ncq_sdev_groups,		\
>  	.change_queue_depth	= ata_scsi_change_queue_depth
>  #endif
>  
> 


-- 
Damien Le Moal
Western Digital Research
