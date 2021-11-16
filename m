Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD084C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 22:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96281613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 22:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhKPWs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 17:48:27 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60934 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhKPWs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 17:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637102728; x=1668638728;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CGMX/4wsP85UH9DV3HC/U1bdkvM+fqz6+rk4utOTN5g=;
  b=a60bygDNlQH6BmPKOFMsOKw65thY4OjvD5ua1IG2PbhkIPZY31pYcXUq
   mvE7nnoB52mdHmBZJ88dzn36qXtcwzhQwlbG+ZdyRK1jTVjWLcrzfSnWt
   zZKHZOVADZk3XFbi7wLI1TRP1Zudvyi2YJJdKS3k54SRVGikupAR2zN7Y
   GDcmxOkY3uixWixBWQMJ6AwNzofKNfInB6Rxr4W6WW8FIgesMzoAP66pr
   2QN2llquVWKqXF+vHbPItxWfypaQ/9e5sWftnG+JH7HPy8NWWqfK8E8d8
   8V/ZkvpbNHKOopq4tGFylWpb4Cz2NxccDLGvjCSJ2iHrkJS/ainiumwLT
   w==;
X-IronPort-AV: E=Sophos;i="5.87,239,1631548800"; 
   d="scan'208";a="185788001"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Nov 2021 06:45:27 +0800
IronPort-SDR: s8EG5DxJYt+NpFo+t86Ti3GENW4VtbMIBAIJLWZ4cYX5QtsuPhXy1GU1VzM6/gKkfIqoj1ucj5
 kocE4XR9r7QZWYQqRtsjfv+GhFuovrVqVrTIgf67DMrwZq1BbKdF5BOn895WVuPZGreH5bFsCe
 X9baAXroNfBTHK33oGrAfh2g6p6A7anI9CRPMKBhLsF/NirlEpI59X83lRhO0CrkCErslLhmxn
 6k+UnDpqdmEQE19FPVyy4DWDjbJCUNVsykN+UpUhNNivnPXqhqSfRtOarJuUX9zEzJIs+UoS/b
 5bazsY3hplLuGvi+jpG36fD7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 14:18:59 -0800
IronPort-SDR: u4QySo2NDIVSbPx6poqIUUrIEHashM1TOt1CWWoPNxnj9JqqvQp1dCsFrnvon3YLKfKzxyCDFU
 Gq8CEEe1ayR+HY9hYw+g8Ameh9OZhNakonVV8TLnrf6wjvUZWbn7a6nTztJbrLj3V/b5ccYfse
 /gZC7E+DWuslNkLeQqyFr5oYR75aa9xALxoMuMBppZcBATchZeFNWEE7QrcUrApZZMHj3redz6
 m2+yQbwAQdXe+UrlJEK26RK+tyWTeg6odKEMMJx7NPPx0hxgbJInY52DJ9tDDLK+WjFg0N71Zg
 3d8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 14:45:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Hv1Nm4jQcz1RtVx
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 14:45:28 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637102727; x=1639694728; bh=CGMX/4wsP85UH9DV3HC/U1bdkvM+fqz6+rk
        4utOTN5g=; b=TCGEmAzzYKH8kQzGnWwi4iRqmZmXaUFBfHh8xF+UK+ngPMzhT0R
        ALtVPM6gQklv1fWmtWjV01sc8c3a3ARBVSyZZNlMZ+OAN+cFzRONYnoKJfy9YXRb
        UyerrYtNdaojj2jc3BXWiWxeiqIdQpI+CD3WpClhRWhklJ8DqiLRjHEV8bFJNpRT
        o3mvcGp3wa9mUgWATzfYizgtMtr/gqV6Z+ndfWbpX7aBU5TkbS2P2fuyqd10xuRE
        UkV+4qgPsSjj2gSVfajcIvr7VJHryHrHuI+LsYsDR68NngmLtBPib0gXOvphRue7
        MRdmYoyrtsrxBfIBpWHrki6E4+0DAmkS+rw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XdD-XZ55XDG7 for <linux-scsi@vger.kernel.org>;
        Tue, 16 Nov 2021 14:45:27 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Hv1Nk3WPSz1RtVl;
        Tue, 16 Nov 2021 14:45:26 -0800 (PST)
Message-ID: <95c9ae06-c9ec-b3f9-e780-1fadce963b3a@opensource.wdc.com>
Date:   Wed, 17 Nov 2021 07:45:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH] scsi: core: Remove Scsi_Host.shost_dev_attr_groups
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211116223115.2103031-1-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211116223115.2103031-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/17 7:31, Bart Van Assche wrote:
> Simplify the scsi_host_alloc() implementation by setting the shost_class
> .dev_groups member instead of copying all host attribute group pointers
> into the shost_dev_attr_groups[] array.
> 
> Cc: Steffen Maier <maier@linux.ibm.com>
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Suggested-by: Benjamin Block <bblock@linux.ibm.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/hosts.c      | 15 +++------------
>  drivers/scsi/scsi_priv.h  |  2 +-
>  drivers/scsi/scsi_sysfs.c |  7 ++++++-
>  include/scsi/scsi_host.h  |  6 ------
>  4 files changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8049b00b6766..f69b77cbf538 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -61,6 +61,7 @@ static void scsi_host_cls_release(struct device *dev)
>  static struct class shost_class = {
>  	.name		= "scsi_host",
>  	.dev_release	= scsi_host_cls_release,
> +	.dev_groups	= scsi_shost_groups,
>  };
>  
>  /**
> @@ -377,7 +378,7 @@ static struct device_type scsi_host_type = {
>  struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  {
>  	struct Scsi_Host *shost;
> -	int index, i, j = 0;
> +	int index;
>  
>  	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);
>  	if (!shost)
> @@ -483,17 +484,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->shost_dev.parent = &shost->shost_gendev;
>  	shost->shost_dev.class = &shost_class;
>  	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
> -	shost->shost_dev.groups = shost->shost_dev_attr_groups;
> -	shost->shost_dev_attr_groups[j++] = &scsi_shost_attr_group;
> -	if (sht->shost_groups) {
> -		for (i = 0; sht->shost_groups[i] &&
> -			     j < ARRAY_SIZE(shost->shost_dev_attr_groups);
> -		     i++, j++) {
> -			shost->shost_dev_attr_groups[j] =
> -				sht->shost_groups[i];
> -		}
> -	}
> -	WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups));
> +	shost->shost_dev.groups = sht->shost_groups;
>  
>  	shost->ehandler = kthread_run(scsi_error_handler, shost,
>  			"scsi_eh_%d", shost->host_no);
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index a278fc8948f4..0f5743f4769b 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -144,7 +144,7 @@ extern struct scsi_transport_template blank_transport_template;
>  extern void __scsi_remove_device(struct scsi_device *);
>  
>  extern struct bus_type scsi_bus_type;
> -extern const struct attribute_group scsi_shost_attr_group;
> +extern const struct attribute_group *scsi_shost_groups[];
>  
>  /* scsi_netlink.c */
>  #ifdef CONFIG_SCSI_NETLINK
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 7afcec250f9b..342a3de6b994 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -424,10 +424,15 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
>  	NULL
>  };
>  
> -const struct attribute_group scsi_shost_attr_group = {
> +static const struct attribute_group scsi_shost_attr_group = {
>  	.attrs =	scsi_sysfs_shost_attrs,
>  };
>  
> +const struct attribute_group *scsi_shost_groups[] = {
> +	&scsi_shost_attr_group,
> +	NULL
> +};
> +
>  static void scsi_device_cls_release(struct device *class_dev)
>  {
>  	struct scsi_device *sdev;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index ebe059badba0..72e1a347baa6 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -691,12 +691,6 @@ struct Scsi_Host {
>  
>  	/* ldm bits */
>  	struct device		shost_gendev, shost_dev;
> -	/*
> -	 * The array size 3 provides space for one attribute group defined by
> -	 * the SCSI core, one attribute group defined by the SCSI LLD and one
> -	 * terminating NULL pointer.
> -	 */
> -	const struct attribute_group *shost_dev_attr_groups[3];
>  
>  	/*
>  	 * Points to the transport data (if any) which is allocated
> 

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
