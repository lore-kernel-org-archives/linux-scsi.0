Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2DE23393C;
	Mon, 13 Jul 2026 03:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783912219; cv=none; b=CbD6izjBghtF0U8Xdrc9j86InHRFVYL8vAH+oKKCjSYmW4bft4wszk0djVIeo9buIYTH0JXkwdy5FyJrSiqushpGboRJp5j8BQcP9c3ZOUvOmyKd739YjmGQ59JS1uZcSUq6sbUQn8oE6r5UwFme6N+4BddsL0kCtN6WJK8TGe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783912219; c=relaxed/simple;
	bh=cyycxXHtyPaZ6N8ijwl4HAdYJ1R54df1Fp8mlM2KYqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cQmmJPWin3ZUOXPZrUV6blOXTZiij5Gkfkq3rj661f2LIXn2bpgBwa4N2nkf7cVF80gfCqDSOFgDZ7p0qSz+hwu3SzkncvFPo98Sz4DDMUBpthd/QG0B9X1AEYNbxJE0KOpvLxF/qUJF41zegSpVKLFnFydyTKZXZ6AugW4DJXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=BNiqg9H1; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="BNiqg9H1"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Mwf4KJ9QNNlyIirxMTVeY9NBR/t9ZmwdBkcBaMxxFfc=;
	b=BNiqg9H14m6kLvlSZRW/u378ht1B7fco13dNkcyfC4sPrw5cWOKh2LTgQ3in5WQMCU2LW1KqE
	SygWOv5iYcQdibu04RaCJv8zu6b2mxSlWYmdF6JU/f22/+XXoLbK3CJEQ+Y+NbHDc5t2GmhO7tH
	9U9tHLkWsHK1XhTR8LOkznM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gz6cy19Msz12LGP;
	Mon, 13 Jul 2026 11:00:34 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 3675440579;
	Mon, 13 Jul 2026 11:10:13 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 13 Jul 2026 11:10:12 +0800
Message-ID: <379091c9-3cd2-7599-baae-8c7f278e7ec3@huawei.com>
Date: Mon, 13 Jul 2026 11:10:11 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
Content-Language: en-CA
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260702033211.1743313-1-yangxingui@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260702033211.1743313-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh100006.china.huawei.com (7.202.181.89) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Kindly ping for review...

On 2026/7/2 11:32, Xingui Yang wrote:
> Commit fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue
> for HA resume") introduced sas_resume_ha_no_sync() to avoid a deadlock: the
> PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue, calls
> sas_deform_port() -> sas_destruct_devices(), which removes SCSI devices and
> waits for the host to become runtime-active. But the host cannot resume
> until sas_resume_ha() -> sas_drain_work() returns, and the drain is blocked
> on that very handler.
> 
> However skipping the drain reintroduces a race: hisi_sas returns from
> resume before all PHY UP work and libsas discovery work finish. The
> controller may then autosuspend while disks are still waking up. The disks
> issue IO to a suspended controller, the IO fails, and the disks get
> disabled.
> 
> Fix the deadlock at its source by moving the PHYE_RESUME_TIMEOUT
> notification to after sas_drain_work(). By then the host resume is about to
> complete, so device removal through device_link no longer blocks on the
> resume and the cycle is broken.
> 
> With the deadlock gone, restore sas_resume_ha() (the draining variant) in
> hisi_sas and remove sas_resume_ha_no_sync().
> 
> Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue for HA resume")
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  9 +-------
>   drivers/scsi/libsas/sas_init.c         | 32 ++++++++++++++------------
>   include/scsi/libsas.h                  |  1 -
>   3 files changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 0687bdefcd63..c8673ae4e472 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -5263,14 +5263,7 @@ static int _resume_v3_hw(struct device *device)
>   	}
>   	phys_init_v3_hw(hisi_hba);
>   
> -	/*
> -	 * If a directly-attached disk is removed during suspend, a deadlock
> -	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
> -	 * hisi_hba->device to be active, which can only happen when resume
> -	 * completes. So don't wait for the HA event workqueue to drain upon
> -	 * resume.
> -	 */
> -	sas_resume_ha_no_sync(sha);
> +	sas_resume_ha(sha);
>   	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
>   
>   	dev_warn(dev, "end of resuming controller\n");
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 0bec236f0fb5..624850f1483d 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -410,7 +410,7 @@ static void sas_resume_insert_broadcast_ha(struct sas_ha_struct *ha)
>   	}
>   }
>   
> -static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
> +static void _sas_resume_ha(struct sas_ha_struct *ha)
>   {
>   	const unsigned long tmo = msecs_to_jiffies(25000);
>   	int i;
> @@ -426,6 +426,21 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>   		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
>   			 i, i > 1 ? "s" : "");
>   	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
> +
> +	/* all phys are back up or timed out, turn on i/o so we can
> +	 * flush out disks that did not return
> +	 */
> +	scsi_unblock_requests(ha->shost);
> +	sas_drain_work(ha);
> +
> +	/* Send PHYE_RESUME_TIMEOUT after sas_drain_work(). The handler
> +	 * calls sas_deform_port() -> sas_destruct_devices(), which removes
> +	 * SCSI devices and, for LLDDs using device_link() PM sync, waits
> +	 * for the host to be runtime-active. Sending it before the drain
> +	 * would deadlock: the drain waits for the handler, the handler
> +	 * waits for host resume, and host resume waits for the drain to
> +	 * finish.
> +	 */
>   	for (i = 0; i < ha->num_phys; i++) {
>   		struct asd_sas_phy *phy = ha->sas_phy[i];
>   
> @@ -436,12 +451,6 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>   		}
>   	}
>   
> -	/* all phys are back up or timed out, turn on i/o so we can
> -	 * flush out disks that did not return
> -	 */
> -	scsi_unblock_requests(ha->shost);
> -	if (drain)
> -		sas_drain_work(ha);
>   	clear_bit(SAS_HA_RESUMING, &ha->state);
>   
>   	sas_queue_deferred_work(ha);
> @@ -453,17 +462,10 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>   
>   void sas_resume_ha(struct sas_ha_struct *ha)
>   {
> -	_sas_resume_ha(ha, true);
> +	_sas_resume_ha(ha);
>   }
>   EXPORT_SYMBOL(sas_resume_ha);
>   
> -/* A no-sync variant, which does not call sas_drain_ha(). */
> -void sas_resume_ha_no_sync(struct sas_ha_struct *ha)
> -{
> -	_sas_resume_ha(ha, false);
> -}
> -EXPORT_SYMBOL(sas_resume_ha_no_sync);
> -
>   void sas_suspend_ha(struct sas_ha_struct *ha)
>   {
>   	int i;
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 163f23c92b41..36d4cb567837 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -680,7 +680,6 @@ extern int sas_register_ha(struct sas_ha_struct *);
>   extern int sas_unregister_ha(struct sas_ha_struct *);
>   extern void sas_prep_resume_ha(struct sas_ha_struct *sas_ha);
>   extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
> -extern void sas_resume_ha_no_sync(struct sas_ha_struct *sas_ha);
>   extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
>   
>   int sas_phy_reset(struct sas_phy *phy, int hard_reset);
> 
