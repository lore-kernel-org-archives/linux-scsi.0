Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4921EC433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 17:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A4C2220F
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 17:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgLURSp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 12:18:45 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2276 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLURSp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 12:18:45 -0500
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4D05gh3Hcrz67SNF;
        Tue, 22 Dec 2020 01:14:56 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 21 Dec 2020 18:17:59 +0100
Received: from [10.210.168.224] (10.210.168.224) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 21 Dec 2020 17:17:58 +0000
Subject: Re: [PATCH 11/11] scsi: libsas: event notifiers: Remove non _gfp()
 variants
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Jason Yan <yanaijie@huawei.com>,
        "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
 <20201218204354.586951-12-a.darwish@linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <68957d37-c789-0f0e-f5d1-85fef7f39f4f@huawei.com>
Date:   Mon, 21 Dec 2020 17:17:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20201218204354.586951-12-a.darwish@linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.224]
X-ClientProxiedBy: lhreml739-chm.china.huawei.com (10.201.108.189) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/12/2020 20:43, Ahmed S. Darwish wrote:
> All call-sites of below libsas APIs:
> 
>    - sas_alloc_event()
>    - sas_ha_struct::notify_port_event()
>    - sas_ha_struct::notify_phy_event()
> 
> have been converted to use the new _gfp()-suffixed version.
> 

nit: Is it possible to have non- _gfp()-suffixed symbols at the end, 
i.e. have same as original?

Thanks,
John

> Remove the old APIs from libsas code, headers, and documentation.
> 
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Jason Yan <yanaijie@huawei.com>
> ---
>   Documentation/scsi/libsas.rst      |  2 -
>   drivers/scsi/libsas/sas_event.c    | 72 +++++++-----------------------
>   drivers/scsi/libsas/sas_init.c     | 15 +------
>   drivers/scsi/libsas/sas_internal.h |  2 -
>   include/scsi/libsas.h              |  2 -
>   5 files changed, 18 insertions(+), 75 deletions(-)
> 
> diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
> index dc85d0e4c107..7e1bf710760b 100644
> --- a/Documentation/scsi/libsas.rst
> +++ b/Documentation/scsi/libsas.rst
> @@ -189,8 +189,6 @@ num_phys
>   The event interface::
>   
>   	/* LLDD calls these to notify the class of an event. */
> -	void (*notify_port_event)(struct sas_phy *, enum port_event);
> -	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
>   	void (*notify_port_event_gfp)(struct sas_phy *, enum port_event, gfp_t);
>   	void (*notify_phy_event_gfp)(struct sas_phy *, enum phy_event, gfp_t);
>   
> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
> index 31b733eeabf6..23aeb67f6381 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -131,57 +131,21 @@ static void sas_phy_event_worker(struct work_struct *work)
>   	sas_free_event(ev);
>   }
>   
> -static int __sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
> -				   struct asd_sas_event *ev)
> -{
> -	struct sas_ha_struct *ha = phy->ha;
> -	int ret;
> -
> -	BUG_ON(event >= PORT_NUM_EVENTS);
> -
> -	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
> -
> -	ret = sas_queue_event(event, &ev->work, ha);
> -	if (ret != 1)
> -		sas_free_event(ev);
> -
> -	return ret;
> -}
> -
>   static int sas_notify_port_event_gfp(struct asd_sas_phy *phy,
>   				     enum port_event event,
>   				     gfp_t gfp_flags)
> -{
> -	struct asd_sas_event *ev;
> -
> -	ev = sas_alloc_event_gfp(phy, gfp_flags);
> -	if (!ev)
> -		return -ENOMEM;
> -
> -	return __sas_notify_port_event(phy, event, ev);
> -}
> -
> -static int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
> -{
> -	struct asd_sas_event *ev;
> -
> -	ev = sas_alloc_event(phy);
> -	if (!ev)
> -		return -ENOMEM;
> -
> -	return __sas_notify_port_event(phy, event, ev);
> -}
> -
> -static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
> -					 enum phy_event event,
> -					 struct asd_sas_event *ev)
>   {
>   	struct sas_ha_struct *ha = phy->ha;
> +	struct asd_sas_event *ev;
>   	int ret;
>   
> -	BUG_ON(event >= PHY_NUM_EVENTS);
> +	BUG_ON(event >= PORT_NUM_EVENTS);
>   
> -	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
> +	ev = sas_alloc_event_gfp(phy, gfp_flags);
> +	if (!ev)
> +		return -ENOMEM;
> +
> +	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
>   
>   	ret = sas_queue_event(event, &ev->work, ha);
>   	if (ret != 1)
> @@ -193,31 +157,27 @@ static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
>   int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
>   			     gfp_t gfp_flags)
>   {
> +	struct sas_ha_struct *ha = phy->ha;
>   	struct asd_sas_event *ev;
> +	int ret;
> +
> +	BUG_ON(event >= PHY_NUM_EVENTS);
>   
>   	ev = sas_alloc_event_gfp(phy, gfp_flags);
>   	if (!ev)
>   		return -ENOMEM;
>   
> -	return __sas_notify_phy_event(phy, event, ev);
> -}
> +	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
>   
> -int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
> -{
> -	struct asd_sas_event *ev;
> +	ret = sas_queue_event(event, &ev->work, ha);
> +	if (ret != 1)
> +		sas_free_event(ev);
>   
> -	ev = sas_alloc_event(phy);
> -	if (!ev)
> -		return -ENOMEM;
> -
> -	return __sas_notify_phy_event(phy, event, ev);
> +	return ret;
>   }
>   
>   int sas_init_events(struct sas_ha_struct *sas_ha)
>   {
> -	sas_ha->notify_port_event = sas_notify_port_event;
> -	sas_ha->notify_phy_event = sas_notify_phy_event;
> -
>   	sas_ha->notify_port_event_gfp = sas_notify_port_event_gfp;
>   	sas_ha->notify_phy_event_gfp = sas_notify_phy_event_gfp;
>   
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 2d2116f827c6..e08351f909fb 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -590,8 +590,8 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
>   }
>   EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
>   
> -static struct asd_sas_event * __sas_alloc_event(struct asd_sas_phy *phy,
> -						gfp_t gfp_flags)
> +struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
> +					  gfp_t gfp_flags)
>   {
>   	struct asd_sas_event *event;
>   	struct sas_ha_struct *sas_ha = phy->ha;
> @@ -623,17 +623,6 @@ static struct asd_sas_event * __sas_alloc_event(struct asd_sas_phy *phy,
>   	return event;
>   }
>   
> -struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
> -{
> -	return __sas_alloc_event(phy, in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
> -}
> -
> -struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
> -					  gfp_t gfp_flags)
> -{
> -	return __sas_alloc_event(phy, gfp_flags);
> -}
> -
>   void sas_free_event(struct asd_sas_event *event)
>   {
>   	struct asd_sas_phy *phy = event->phy;
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 437a697b6f73..b0422d47675b 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -48,7 +48,6 @@ int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf);
>   int  sas_register_phys(struct sas_ha_struct *sas_ha);
>   void sas_unregister_phys(struct sas_ha_struct *sas_ha);
>   
> -struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy);
>   struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy, gfp_t gfp_flags);
>   void sas_free_event(struct asd_sas_event *event);
>   
> @@ -78,7 +77,6 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
>   			enum phy_func phy_func, struct sas_phy_linkrates *);
>   int sas_smp_get_phy_events(struct sas_phy *phy);
>   
> -int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
>   int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event, gfp_t flags);
>   void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
>   struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index f7c2530bbd9d..fdd338fa65c9 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -392,8 +392,6 @@ struct sas_ha_struct {
>   				* their siblings when forming wide ports */
>   
>   	/* LLDD calls these to notify the class of an event. */
> -	int (*notify_port_event)(struct asd_sas_phy *, enum port_event);
> -	int (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
>   	int (*notify_port_event_gfp)(struct asd_sas_phy *, enum port_event, gfp_t);
>   	int (*notify_phy_event_gfp)(struct asd_sas_phy *, enum phy_event, gfp_t);
>   
> 

