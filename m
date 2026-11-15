Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765903;
	b=WZyXFJwxm6G6lQDFFGWUPfTiZC8l+ELu8RToMR+CM2YfwX2o3MMOVGdByU/0yOrD6USO
	 LP1UP98SrX9OqFqs20bmj1rqbhYa3XkiL11tKmD1IRQTGU+c3PGdMMY0vVjdqpwaoldI0
	 tC1d9AQFkAZY5ZPkioRTm3f3LpPUBGn+7hvpoxeM6dp0+09bTBrdz5IGevA3XpKyEInAy
	 wC091ci405EsCyp+0WpCeM+aIy6n/R0hJ+ReUV/PKgOXgzjESlGj7Qs9U6lgKqfScl82y
	 Jb96knbF3DQYpnsXmLTImrXGmmxdkgptTPhx7D9z5QhtW4R7Ha9+LF64PDlTySDcLKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765903;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=FJvm5/zzuNKuQVsdQQwncA9TdHL9pGAG2/TLNuHbhRk=;
	b=I9VDGrxMerYyXqJVDxOhAAk95DD6Xg/WxzgU+O52Gc0hjTC8My5aDa/iCJY1z+hvoK6a
	 +1L2/C9af8ZGaPbRG4ZUdC5sSxPY8yuIZJdTD3glPJP1txnFu9PVSzmQcfcQtwObcqrN4
	 pn5x69rhZtTofaEqWE5/2qbeutbmkgI4KI2JRVvPVaVJB63zQZaLlqG+o7ITd5YGhBf7l
	 5L4z+9cx5Kx30x+Qq0xmzzHJ2eSblpil0EGpcEPEN0sjR0nzKx2c5sQVWCoSUp0ARE9be
	 OXpAvdvZOqkFD4b5sNsoG26sjXk0XKsB3I9NwFCWB6pAVYCsWJxleN5rONktaMpfm8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JgkiFtmg;
	arc=none smtp.remote-ip=91.218.175.180
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691F0606A31D
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 18:05:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 691F0606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JgkiFtmg
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2IH1/X6CTvt0313Vz/VAWwJDEFN/f/O4dyfh9jni4TM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794765900; v=1; x=1795370700;
 b=JgkiFtmgYEe7oNWrKZ9TGdmjzzT9V0itTqKf4Ur9WzTSV5cHjOexXjN7SlbyRUqE9wFPn9oj
 ExFMY8ZBmi5AnK7XWRSgM8rx3zxEEM+JcU+d3a3H5EocJAa8BTt5vETxFS7cC4Be6SS5/iPe2SP
 KRsteUsVlo3PIqziI0FEhB+k=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id d1d3b2979402012a;
	Sun, 15 Nov 2026 18:05:00 +0000
X-Mizu-Trace-ID: d1d3b2979402012a
X-Migadu-Flow: FLOW_OUT
Message-ID: <37cb0b01-0c6a-4b3d-b3d8-c4e5a45977a8@linux.dev>
Date: Sun, 15 Nov 2026 18:04:54 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_dh_alua: set handler_data before
 alua_initialize()
To: Laurence Oberman <loberman@redhat.com>,
 "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Bart Van Assche <bvanassche@acm.org>, Martin Wilck <mwilck@suse.com>,
 Hannes Reinecke <hare@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261109201120.1067815-1-loberman@redhat.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261109201120.1067815-1-loberman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 20:11, Laurence Oberman wrote:
> Since commit 50759b881e1d ("scsi: device_handler: alua: Call
> scsi_device_put() from non-atomic context"), alua_rtpg_queue() only
> queues an RTPG when sdev->handler_data points at an alua_dh_data whose
> port group matches:
> 
> 	struct alua_dh_data *h = sdev->handler_data;
> 	...
> 	if (h && rcu_dereference(h->pg) == pg) {

Do we still require this check (for h being non-NULL) after the change 
in this patch? I assume that we flush any calls to this function prior 
to unsetting sdev->handler_data.

> 
> However alua_bus_attach() only assigns sdev->handler_data after
> alua_initialize() returns, and alua_initialize() -> alua_check_vpd()
> is where the initial RTPG is queued. At that point handler_data is
> still NULL, so the initial RTPG is silently dropped: no RTPG is sent,
> nothing is logged, and sdev->access_state keeps its zeroed default of
> active/optimized for every path.
> 
> With dm-multipath this goes unnoticed, as pg_init calls
> scsi_dh_activate() once the map is loaded, which queues an RTPG after
> handler_data is set, and multipathd's alua prioritizer issues its own
> RTPG from userspace. Anything relying on sdev->access_state without a
> subsequent activate (sysfs access_state/preferred_path, native SCSI
> multipath path selection) sees every path as active/optimized until a
> Unit Attention or rescan triggers an RTPG.
> 
> Seen on an HP P2000 G3 FC array (implicit ALUA, two port groups, four
> paths per LUN) with dm-multipath not in use: sg_rtpg reports port group
> 0 active/non-optimized and port group 1 active/optimized, but
> /sys/class/scsi_device/H:C:T:L/device/access_state reads
> active/optimized on all four paths after boot, and no
> "alua: port group XX state ..." message is logged. Writing "activate"
> to dh_state sends the RTPG and corrects access_state.
> 
> Kernels without commit 50759b881e1d queue the attach-time RTPG
> unconditionally and are not affected.
> 
> Fix by assigning sdev->handler_data before calling alua_initialize(),
> and clearing it again on failure. sdev->handler is only set once
> scsi_dh_handler_attach() sees ->attach() succeed, so no handler
> callback can observe the partially initialised alua_dh_data. On the
> failure paths of alua_initialize(), h has not been added to a port
> group and no RTPG has been queued, so freeing it is unchanged.
> 
> Fixes: 50759b881e1d ("scsi: device_handler: alua: Call scsi_device_put() from non-atomic context")
> Cc: stable@vger.kernel.org
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
> 
> Notes:
>      Tested on an HP P2000 G3 FC array (30 LUNs, 4 paths each): with this
>      patch the "alua: port group 00 state N ..." messages are logged during
>      boot and access_state shows two active/optimized and two
>      active/non-optimized paths per LUN without any manual activate.
>      Without it, all paths read active/optimized until an RTPG is triggered.
>      
>      I found this while testing John Garry's native SCSI multipath series
>      (v9) on an HP P2000 G3 FC array (30 LUNs, 4 paths each, dm-multipath
>      not in use). Native multipath uses sdev->access_state for path
>      selection, and every path showed active/optimized, although sg_rtpg
>      and dm-multipath (alua prio 50/10) both report port group 0 as
>      active/non-optimized. No "alua: port group XX state ..." message was
>      logged at boot. Writing "activate" to dh_state corrected access_state,
>      which pointed at the attach-time RTPG never being queued.
>      
>      With this patch, the port group state messages are logged during boot
>      and access_state shows two active/optimized and two
>      active/non-optimized paths per LUN without any manual activate.
>      
>      This fix is independent of the native multipath series. It affects any
>      user of access_state/preferred_path, and ALUA prep_fn fast-fail, on
>      kernels with 50759b881e1d where nothing calls scsi_dh_activate()
>      after attach.
>      
>      v9 series: https://lore.kernel.org/linux-scsi/20261108204733.557995-1-
>      john.garry@linux.dev/
> 
>   drivers/scsi/device_handler/scsi_dh_alua.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 87ac0a6d63e5..84ff3aed2c46 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1233,13 +1233,20 @@ static int alua_bus_attach(struct scsi_device *sdev)
>   	INIT_LIST_HEAD(&h->node);
>   
>   	mutex_init(&h->init_mutex);
> +	/*
> +	 * alua_rtpg_queue() only queues an RTPG when sdev->handler_data
> +	 * points at this alua_dh_data, so set it before alua_initialize()
> +	 * otherwise the initial RTPG issued from alua_check_vpd() is
> +	 * silently dropped and sdev->access_state is never populated.
> +	 */
> +	sdev->handler_data = h;

Note: I was checking which members of alua_dh_data are not initialized 
prior to publishing sdev->handler_data, and alua_dh_data.group_id is 
never accessed at all AFAICS.

Thanks,
John
