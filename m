Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF5FC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 04:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiB0EAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Feb 2022 23:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiB0EAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2022 23:00:42 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF1C1DB3E1
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 20:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645934406; x=1677470406;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+xrsuOI9TEYJqO66rOjju0qwmMM8tmROUCmeVCpyQHI=;
  b=mf4fRUx7d6+nFUFNvriPbGZ6eJrKAsgiE3SzoPWfZ8g5pRnz2UeSIwFk
   MPgcyw33817imUjnic/bi6RTxNTEfiS16JnHqUcizXWpTJ1hArLBhp8Bw
   VWgIKd40L6kvr6sd8MNRFLSXpyoSfwy9uYrPDvvoKk3l79i7h4qbyKMMs
   NhD7Ca8fNqkzvyN8a9fZrayOcUVWb2a4fiPMlRRZLerq70alwM8phG0SF
   C0rz+vrR/TZi3EHfc8aiExbuccaKK6AXWFKP9YbRjTeJ3jP4tjL0QE1d9
   ZThoAqD6MXWCd6xjb7ejYGkyieFVcYBEmK5IHjrNKD8CljtVnaaStg2TE
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,140,1643644800"; 
   d="scan'208";a="192948255"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Feb 2022 12:00:04 +0800
IronPort-SDR: d1bkg2lr6a6vawch+JyCeRTzRCQfAo5sW8Dyzi+06Bcq9xIa7Khrx2bSvGG7fXmRPIysJEXoM6
 B08CAl9fpVoJSoebZD0vcBpXc7f1zExLzU1vO/ljCwTcTcj33IBg062a3AXFscZjIrfiuQf6s2
 rP+a8c0Tk5AxbID3R1v2+GMfGTgfDzGQaAeR67AbM5/2O/tXXioFo6ZtA4t6PjLiuATFLsGYqJ
 R5lIU81RvIiIvmxv4dmqr51zZUjBshZXheTdvUzQIWBeUQGvGjWTpNaA4bDpFUJ7T+qbbWxwT3
 RN+N4UxEYZM70Qs3PhJgLnv2
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2022 19:31:31 -0800
IronPort-SDR: VkRkzFEY0Sw7sthY46x7JXolsHdJbISb1mwvjEtmn171LNiOneqKCjsg+ENwh+olHt0WnO/024
 Tj5rCdZDvfSySrqJhqK+lIGu3xRONQexTUGen5IRP0FU6F2mIlN7gAZS28XXT1/tEsoNbPeQzT
 cZRSLZ0EIVey/Htj6L9h5+oUwrHP7qqNhI7yPcq3yX9hXU6I3d5oV44uuitw4uukQGJQxk1Kgk
 F1ODZpO7fkD6rmQKPZu2m8UEq9vpnqvrtmQIPVRoG4FiZn2obt/5VL+IvLn7iXMI/WevhCyx4I
 l4g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2022 20:00:05 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K5qXh1p3Dz1SVp2
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 20:00:04 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645934403; x=1648526404; bh=+xrsuOI9TEYJqO66rOjju0qwmMM8tmROUCm
        eVCpyQHI=; b=jk1YeFgsPfCpag0c2T6Oy7mM3oQ5g7iy2tDGelWSdpN3qQwMMXK
        qZYW0NLhfY5+sxsbPtEHClAA8g1TaQ210PqaMA1o1kBA46Ja/NU6w3OY6A/WTiyh
        Dh8Ba3PWulUDlK+6OfYAagahcf6chfwEPL5Cp8JhgWS4AJZOvMMiEhvtqQbbUnI3
        CV+1wuIq+u6Nri/M1k51CHxnV9iqhhGfW0+iZ5me7sxcoGuzNJPhQyDb3vlx0gVI
        Mp5OKG5S7JqJkV5+8w7QqNmLA+3WWkKVlGrQvbKfwMf1NA3kaPxcmPL+Q1SE5Z9L
        WN1V4CEg4BtJdDmK6SJstmZhzHz8dd/Fv6Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jaP32LwbT83n for <linux-scsi@vger.kernel.org>;
        Sat, 26 Feb 2022 20:00:03 -0800 (PST)
Received: from [10.225.33.67] (unknown [10.225.33.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K5qXd1TT3z1Rvlx;
        Sat, 26 Feb 2022 20:00:00 -0800 (PST)
Message-ID: <d81c76bd-36aa-4885-1f36-1aec17ab5098@opensource.wdc.com>
Date:   Sun, 27 Feb 2022 12:59:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 2/2] scsi: libsas: Use bool for queue_work() return
 code
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     chenxiang66@hisilicon.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
References: <1645786656-221630-1-git-send-email-john.garry@huawei.com>
 <1645786656-221630-3-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1645786656-221630-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/02/25 19:57, John Garry wrote:
> Function queue_work() returns a bool, so use a bool to hold this value
> for the return code from callers, which should make the code a tiny bit
> more clear.
> 
> Also take this opportunity to condense the code of the those callers, such
> as sas_queue_work(), as suggested by Damien.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/libsas/sas_event.c    | 30 +++++++++++-------------------
>  drivers/scsi/libsas/sas_internal.h |  2 +-
>  2 files changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
> index 8ff58fd97837..f3a17191a4fe 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -10,29 +10,26 @@
>  #include <scsi/scsi_host.h>
>  #include "sas_internal.h"
>  
> -int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
> +bool sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
>  {
> -	/* it's added to the defer_q when draining so return succeed */
> -	int rc = 1;
> -
>  	if (!test_bit(SAS_HA_REGISTERED, &ha->state))
> -		return 0;
> +		return false;
>  
>  	if (test_bit(SAS_HA_DRAINING, &ha->state)) {
>  		/* add it to the defer list, if not already pending */
>  		if (list_empty(&sw->drain_node))
>  			list_add_tail(&sw->drain_node, &ha->defer_q);
> -	} else
> -		rc = queue_work(ha->event_q, &sw->work);
> +		return true;
> +	}
>  
> -	return rc;
> +	return queue_work(ha->event_q, &sw->work);
>  }
>  
> -static int sas_queue_event(int event, struct sas_work *work,
> +static bool sas_queue_event(int event, struct sas_work *work,
>  			    struct sas_ha_struct *ha)
>  {
>  	unsigned long flags;
> -	int rc;
> +	bool rc;
>  
>  	spin_lock_irqsave(&ha->lock, flags);
>  	rc = sas_queue_work(ha, work);
> @@ -44,13 +41,12 @@ static int sas_queue_event(int event, struct sas_work *work,
>  void sas_queue_deferred_work(struct sas_ha_struct *ha)
>  {
>  	struct sas_work *sw, *_sw;
> -	int ret;
>  
>  	spin_lock_irq(&ha->lock);
>  	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
>  		list_del_init(&sw->drain_node);
> -		ret = sas_queue_work(ha, sw);
> -		if (ret != 1) {
> +
> +		if (!sas_queue_work(ha, sw)) {
>  			pm_runtime_put(ha->dev);
>  			sas_free_event(to_asd_sas_event(&sw->work));
>  		}
> @@ -170,7 +166,6 @@ void sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
>  {
>  	struct sas_ha_struct *ha = phy->ha;
>  	struct asd_sas_event *ev;
> -	int ret;
>  
>  	BUG_ON(event >= PORT_NUM_EVENTS);
>  
> @@ -186,8 +181,7 @@ void sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
>  	if (sas_defer_event(phy, ev))
>  		return;
>  
> -	ret = sas_queue_event(event, &ev->work, ha);
> -	if (ret != 1) {
> +	if (!sas_queue_event(event, &ev->work, ha)) {
>  		pm_runtime_put(ha->dev);
>  		sas_free_event(ev);
>  	}
> @@ -199,7 +193,6 @@ void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
>  {
>  	struct sas_ha_struct *ha = phy->ha;
>  	struct asd_sas_event *ev;
> -	int ret;
>  
>  	BUG_ON(event >= PHY_NUM_EVENTS);
>  
> @@ -215,8 +208,7 @@ void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
>  	if (sas_defer_event(phy, ev))
>  		return;
>  
> -	ret = sas_queue_event(event, &ev->work, ha);
> -	if (ret != 1) {
> +	if (!sas_queue_event(event, &ev->work, ha)) {
>  		pm_runtime_put(ha->dev);
>  		sas_free_event(ev);
>  	}
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 24843db2cb65..13d0ffaada93 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -67,7 +67,7 @@ void sas_porte_broadcast_rcvd(struct work_struct *work);
>  void sas_porte_link_reset_err(struct work_struct *work);
>  void sas_porte_timer_event(struct work_struct *work);
>  void sas_porte_hard_reset(struct work_struct *work);
> -int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw);
> +bool sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw);
>  
>  int sas_notify_lldd_dev_found(struct domain_device *);
>  void sas_notify_lldd_dev_gone(struct domain_device *);


-- 
Damien Le Moal
Western Digital Research
