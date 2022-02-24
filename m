Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738A3C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 12:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbiBXMug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 07:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiBXMue (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 07:50:34 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2659D1F768A
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 04:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645706987; x=1677242987;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hFrzqtmq0TTXDCsXI1fBtGLsq/MQUQ3c1RH8HRklIys=;
  b=l7iy6kpFRUPIaJm9hDKM48Wetf3DGr4g6CY5aX8/0LQLXocPW34pTSs7
   QHFZ3osMBw6CSrvIZlNJ2RcKD9IejSrRVo2sbU50CAqS7kLnTO1hrA8qQ
   25Ivk7gZUo3xQEo42AGBigdCl+XhURjLrEzZ8yNIu4rMEk9uUqgyXwK5Z
   6tYC6rB70QxRnFsn4WcTcAnRfBLhE+seQg/YuVXeZ7Sd4QtSFtw5dKay4
   m948l4twBp7LTVrUMiKe/ctfKBvNiAw3W37mZz9imgzh/+2qUlCK4n3n8
   1Un/pQCxk7hnj/zt8JWRl3PIyGfQ70UUY0TftU+5oZsG6JYgjqkj/Mn8l
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,133,1643644800"; 
   d="scan'208";a="192779567"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 20:49:35 +0800
IronPort-SDR: vPDpr+U2pI+1WIhzobBDNSQE0I4Do42MDkJWDMn0OLC+WUBSobtmz9pfmdG9ugqzG6NasKsasP
 FJV9ZXeBNviCEmHk9IHsWLcTUadooWPlaMZSNSYQs+ZOkTVdQXPJCZCAXULASF4pnDTPMIjNVr
 kLZZGHSfoXbQZ1PbBxFummZoYgx80RdKlzSAEWXmtkOSrIWHdIA4hsYIc3TcP4QxiOq7eVPpjJ
 vE6AhqdYwR/CMOrFqidiOZI03POfsawnq+WG1nWev//O6+/arzkgacW2c1GXgAai4dJASUod6w
 u9gORHvopj6pD5c8ExoLFKFg
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 04:22:11 -0800
IronPort-SDR: BN2jr44Xk6cCI+Nf0Rv21iF+1N+lTqeNv6mMd1e+J0yFlQ8bgqZ11vYGg0lqVg/3o7bvntvtrO
 DMmztnWTBu4KzV3dndp5w5CnGUO1gBfdZgu/TTNwmU7QxZukRK4MD/GghnsFhMscL/DH6d/VRx
 vqjv5ePoTTJCISIOr9SNeCf02hFnui/35UlsBCDMWRILnXIaAIQxNyHRvKDG7gCs/QynmQ1tdp
 wVc+LwqOYssY0nbaIZ2zKqxGlOitFdgGs/ZLIL0MZAf5zjeM0hdLe8AtkCmZ1CsbrFa8k/A3Z3
 7nQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 04:49:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4CR32jtCz1Rwrw
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 04:49:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645706974; x=1648298975; bh=hFrzqtmq0TTXDCsXI1fBtGLsq/MQUQ3c1RH
        8HRklIys=; b=FZAh2zCcsHg6Q2OcsCOtCQgOhHeQ7OxwZUkSjggOmbpb3jRVbiR
        v4XD2W6q7tbNKPE8z81W/uR+c9kZVcKCM9HHWhtyXOjniLcOQgV+zjsZ0VOpOKKB
        Xz6loa8UncBskn70W+ESOpWxiPGEC/3UI9d5dlPunR6r5fACa/5U/7us06zX8bnO
        tp8jNvk1y+EG+SMBVtfPRf7mbJ6YZhywnONR2RiXlAj/UPFCP3/RQZGaUk4JA1K5
        u1ZoDeonojNJasXjOC/a2RRlcwnKi7K3NiJR9zHy5Q21BUEXV2U83uwnWN6IjXMB
        bbyr+c3unzYNtfHA0Ih1BDxqP/yROVuBYiw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4bBSGmMuHgqg for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 04:49:34 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4CR10wjDz1Rvlx;
        Thu, 24 Feb 2022 04:49:32 -0800 (PST)
Message-ID: <4b107020-2494-2470-ba1b-c2000eae1355@opensource.wdc.com>
Date:   Thu, 24 Feb 2022 21:49:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/2] scsi: libsas: Use bool for queue_work() return code
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     chenxiang66@hisilicon.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
References: <1645700699-82369-1-git-send-email-john.garry@huawei.com>
 <1645700699-82369-3-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1645700699-82369-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/22 20:04, John Garry wrote:
> Function queue_work() returns a bool, so use a bool to hold this value
> for the return code, which should make the code a tiny bit more clear.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/libsas/sas_event.c    | 23 +++++++++--------------
>  drivers/scsi/libsas/sas_internal.h |  2 +-
>  2 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
> index 8ff58fd97837..e5eb24100e2d 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -10,13 +10,13 @@
>  #include <scsi/scsi_host.h>
>  #include "sas_internal.h"
>  
> -int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
> +bool sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
>  {
>  	/* it's added to the defer_q when draining so return succeed */
> -	int rc = 1;
> +	bool rc = true;
>  
>  	if (!test_bit(SAS_HA_REGISTERED, &ha->state))
> -		return 0;
> +		return false;
>  
>  	if (test_bit(SAS_HA_DRAINING, &ha->state)) {
>  		/* add it to the defer list, if not already pending */
> @@ -28,11 +28,11 @@ int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
>  	return rc;

While at it, I would cleanup this function like this:

diff --git a/drivers/scsi/libsas/sas_event.c
b/drivers/scsi/libsas/sas_event.c
index 3613b9b315bc..38e6e91aaf36 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -12,20 +12,17 @@

 int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 {
-       /* it's added to the defer_q when draining so return succeed */
-       int rc = 1;
-
        if (!test_bit(SAS_HA_REGISTERED, &ha->state))
-               return 0;
+               return false;

        if (test_bit(SAS_HA_DRAINING, &ha->state)) {
                /* add it to the defer list, if not already pending */
                if (list_empty(&sw->drain_node))
                        list_add_tail(&sw->drain_node, &ha->defer_q);
-       } else
-               rc = queue_work(ha->event_q, &sw->work);
+               return true;
+       }

-       return rc;
+       return queue_work(ha->event_q, &sw->work);
 }

No local variable :)

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
> @@ -44,13 +44,12 @@ static int sas_queue_event(int event, struct sas_work *work,
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
> +		if (sas_queue_work(ha, sw) == false) {

if (!sas_queue_work(ha, sw)) ?

>  			pm_runtime_put(ha->dev);
>  			sas_free_event(to_asd_sas_event(&sw->work));
>  		}
> @@ -170,7 +169,6 @@ void sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
>  {
>  	struct sas_ha_struct *ha = phy->ha;
>  	struct asd_sas_event *ev;
> -	int ret;
>  
>  	BUG_ON(event >= PORT_NUM_EVENTS);
>  
> @@ -186,8 +184,7 @@ void sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
>  	if (sas_defer_event(phy, ev))
>  		return;
>  
> -	ret = sas_queue_event(event, &ev->work, ha);
> -	if (ret != 1) {
> +	if (sas_queue_event(event, &ev->work, ha) == false) {

Same.

>  		pm_runtime_put(ha->dev);
>  		sas_free_event(ev);
>  	}
> @@ -199,7 +196,6 @@ void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
>  {
>  	struct sas_ha_struct *ha = phy->ha;
>  	struct asd_sas_event *ev;
> -	int ret;
>  
>  	BUG_ON(event >= PHY_NUM_EVENTS);
>  
> @@ -215,8 +211,7 @@ void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
>  	if (sas_defer_event(phy, ev))
>  		return;
>  
> -	ret = sas_queue_event(event, &ev->work, ha);
> -	if (ret != 1) {
> +	if (sas_queue_event(event, &ev->work, ha) == false) {

And again.

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
