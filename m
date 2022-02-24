Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2056C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 12:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiBXMoU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 07:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiBXMoT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 07:44:19 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2551B7562
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 04:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645706629; x=1677242629;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n4fzh44QAy22moc9qJ4F1Z/J9ZjLZgoIz8vevQPxfjQ=;
  b=Sv45PvtWZCicOOqr/WI+UTCu+BFWm2G+X0U41b0URNK0tFfjWlHzhQjM
   hFEEI2GeE/HoTHBaoyXWvjeJTio1OMAq0G48lsiPZtE/OFcyeU5WUQlNa
   kWR5cDxiJ+1YXSFFhlD/UNDEXF2Yv5ahAXCn8SbZLspBl82d/euOXVuOO
   Ib8fP09XjUwmtfCrSohmNX4/4PZimNEM4XQBfG47rZMm8vKPHWMfIbF0G
   UtnwMpao3QAH3LRsP5T8makGsU7jlCCbRN2TKABO6bUYh130T3rIxkxDv
   a5gI404FmdlVVh9/JndZFRxuv6PlayEDbXY5Sembs5NL313131jzVNdAA
   A==;
X-IronPort-AV: E=Sophos;i="5.90,133,1643644800"; 
   d="scan'208";a="198681762"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 20:43:47 +0800
IronPort-SDR: d0EQvKrNQEkGoFbmxb3YJCoBJ/dQil1lJLXWN7C7A/CSyMPafX1bvdE0UzYn5VWik5kstZxLsf
 fwLddwJiv7bGLYfDohMUQxtYsxjvdvM5s32g+W4ht7lTm8POXhjecXoB4xv8KhzxfHkJzTV1st
 /94wwxbIgGM/VG3lE7nGzFonOItNeLaprWxGISOwDd0v6Gdkd+fE1pwkGcdBnG+Xn5975SSzLc
 raffQihPyxbklz8NY223i4AhS7ZiMZfSwXkh9HcpwnKJy0VPVXALacnAHHZ7gis8drRgVXHsPu
 g/C7bGOZ5g1OGYUODo1BlU/q
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 04:15:18 -0800
IronPort-SDR: 6XZyfnKVspeURNkCXCIhIq+X1TLxIHK5H1y3uvDS5/xTIk1q/vr7ad5m+QN334SoBBjsBy0etw
 PeHP3Nih0OmTv2cNaen6OpujoPgW7gFBSz5YOGa02Wdq24pbQx8oWf/mhimVUCHI2WgMpSL2gh
 ZnEKiQr1cmDpSo3N63py7QRt1fM3q6qSH35cVFL+UnClgY15lxXz6ZLVVOIcP+TCMRHGKEPkmk
 zHx9op+QFqkFoiCgRbc9co/BhdrFkwwBIoapGZTaKCxnsTqSC4M4uRkUYp6gmVsgjdfRmVzlJm
 pQk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 04:43:48 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4CJM2xrNz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 04:43:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645706626; x=1648298627; bh=n4fzh44QAy22moc9qJ4F1Z/J9ZjLZgoIz8v
        evQPxfjQ=; b=aqJXpR3SA6H1bY+CRnGXXkNNgDKwJ6UcL0jOmYTUtVZ8l1IHxL4
        DK5J2FbPGo1WiOfYoEB9cYRcYzVF/fAhrM35IpHYe7Gn20paZoBkDpwPLcGbtRGt
        u7gvq/In+YWLi6trxrLBdTpCo0+1IgAN8OJYuBF15XCOH0/49Y43LUfzbe72TjHL
        VVSu8IrZia2EZMf4iU/6S+vvYhSXkeqRn02yPKmj5pAupa1y1wZb8sP39FbBlH7r
        k9gTXIkGfPl4QFMVUPto6W/ha9NMbHdBj3Ufagi9wA33NHtpIdvhhKm+lDN2lRkX
        XHr2AutzWtaHFcgo626IYOrSO/qgSMVXbYg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id eRNOlaQLpUiH for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 04:43:46 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4CJK04msz1Rvlx;
        Thu, 24 Feb 2022 04:43:44 -0800 (PST)
Message-ID: <014a69ed-7a99-2a67-fa3a-947d11601114@opensource.wdc.com>
Date:   Thu, 24 Feb 2022 21:43:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] scsi: libsas: Make sas_notify_{phy,port}_event()
 return void
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     chenxiang66@hisilicon.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
References: <1645700699-82369-1-git-send-email-john.garry@huawei.com>
 <1645700699-82369-2-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1645700699-82369-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/22 20:04, John Garry wrote:
> Nobody checks the return codes, so make them return void. Indeed, if the
> LLDD cannot send an event, nothing much can be done in the LLDD about it.

It really sound like the LLDDs should be fixed to e.g. reset the adapter
if things go south with these functions. No sure though.

> 
> Also remove prototype for sas_notify_phy_event() in sas_internal.h, which
> should not be there.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>

In any case, these changes do not make anything worse :)

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/libsas/sas_event.c    | 20 ++++++++------------
>  drivers/scsi/libsas/sas_internal.h |  2 --
>  include/scsi/libsas.h              |  8 ++++----
>  3 files changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
> index 3613b9b315bc..8ff58fd97837 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -165,8 +165,8 @@ static bool sas_defer_event(struct asd_sas_phy *phy, struct asd_sas_event *ev)
>  	return deferred;
>  }
>  
> -int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
> -			  gfp_t gfp_flags)
> +void sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
> +			   gfp_t gfp_flags)
>  {
>  	struct sas_ha_struct *ha = phy->ha;
>  	struct asd_sas_event *ev;
> @@ -176,7 +176,7 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
>  
>  	ev = sas_alloc_event(phy, gfp_flags);
>  	if (!ev)
> -		return -ENOMEM;
> +		return;
>  
>  	/* Call pm_runtime_put() with pairs in sas_port_event_worker() */
>  	pm_runtime_get_noresume(ha->dev);
> @@ -184,20 +184,18 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
>  	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
>  
>  	if (sas_defer_event(phy, ev))
> -		return 0;
> +		return;
>  
>  	ret = sas_queue_event(event, &ev->work, ha);
>  	if (ret != 1) {
>  		pm_runtime_put(ha->dev);
>  		sas_free_event(ev);
>  	}
> -
> -	return ret;
>  }
>  EXPORT_SYMBOL_GPL(sas_notify_port_event);
>  
> -int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
> -			 gfp_t gfp_flags)
> +void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
> +			  gfp_t gfp_flags)
>  {
>  	struct sas_ha_struct *ha = phy->ha;
>  	struct asd_sas_event *ev;
> @@ -207,7 +205,7 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
>  
>  	ev = sas_alloc_event(phy, gfp_flags);
>  	if (!ev)
> -		return -ENOMEM;
> +		return;
>  
>  	/* Call pm_runtime_put() with pairs in sas_phy_event_worker() */
>  	pm_runtime_get_noresume(ha->dev);
> @@ -215,14 +213,12 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
>  	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
>  
>  	if (sas_defer_event(phy, ev))
> -		return 0;
> +		return;
>  
>  	ret = sas_queue_event(event, &ev->work, ha);
>  	if (ret != 1) {
>  		pm_runtime_put(ha->dev);
>  		sas_free_event(ev);
>  	}
> -
> -	return ret;
>  }
>  EXPORT_SYMBOL_GPL(sas_notify_phy_event);
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index b60f0bf612cf..24843db2cb65 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -78,8 +78,6 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
>  			enum phy_func phy_func, struct sas_phy_linkrates *);
>  int sas_smp_get_phy_events(struct sas_phy *phy);
>  
> -int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
> -			 gfp_t flags);
>  void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
>  struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
>  struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index dc529cc92d65..df2c8fc43429 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -727,9 +727,9 @@ int sas_lu_reset(struct domain_device *dev, u8 *lun);
>  int sas_query_task(struct sas_task *task, u16 tag);
>  int sas_abort_task(struct sas_task *task, u16 tag);
>  
> -int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
> -			  gfp_t gfp_flags);
> -int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
> -			 gfp_t gfp_flags);
> +void sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
> +			   gfp_t gfp_flags);
> +void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
> +			   gfp_t gfp_flags);
>  
>  #endif /* _SASLIB_H_ */


-- 
Damien Le Moal
Western Digital Research
