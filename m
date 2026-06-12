Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B733803DA
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269724; cv=none; b=sqAdlJByU1AYXXRVuYxNb63Fsdoal5XhidkmFoZo+WtmhmPoXbI/sCKTYCgewQ1HprgFH9WLyyXJ3HneyZe/TFXQ4fD0W3fQd3AknT33l1InAUsfcC9iAKdfOCvX5bHC/te9G486HrNEmHM2A8ycmO4Ux6XYzBoYuCLTWVMHQE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269724; c=relaxed/simple;
	bh=9N3epS28TFfoCdJqV5zSZbeZietjpyG7c6FS+dhG3is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9WEP313oPl7pFv5SQ0GjqOtGUGbEOzhL12/F5ir938+PkeEsDj//q1mjxRQOTa8nWuKCUBIKfgzxr8Mp/2fnIQT91Er0cwfM4T4CXfSzBVQhTkJpHOa7iHdqphWNu49Vy+WLfvlosY28E0ezOhsGCniKWtfkOmdLPcQgazQFuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GDylNDbZ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GDylNDbZ"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45eea68dd6fso546197f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269721; x=1781874521; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s36tVkuou7qfSuaNiPeyahyD0lJM+lGOdnmBj/ohJjc=;
        b=GDylNDbZPvq8THsPrePC6AGqV/X4X/B7MgcbEnXBxIDDQoNG+ayw2g+NTQ8uPjJElv
         4urkiP0Gisy8uHka57qZNaeRL0WisADOwZ2Bib3Kutl6o/i/TfjvBUiX3xNEbLhY44ZK
         6NTTpcXKtv68cPks8SVxPYdTshsBAZ60ohLBq1Mm8jfakBpY9NzVJuV7ahX1LEHHXB/r
         ZyVg9dJmAkjT7MNjkJrQQdSPo1IDEh3e7gZ5nwQoYKPcDR+NjNG2wikVKABgZzHdBuxd
         qgk+LkKzVXMdMWAyxEoAZYF9vwb9NDYtnKN4Ihupuf2BMhTsvynirtslgh/EsiC2pvTM
         wz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269721; x=1781874521;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s36tVkuou7qfSuaNiPeyahyD0lJM+lGOdnmBj/ohJjc=;
        b=p02GfWTcgYUfyv1H/8djxjV4RVE8TLPrmUM+i0m1OJbL+LW+3R3uqMUt4+e4n1KsG5
         4Ev3gPHZmYrF3pQ4bYkAwKPIIcdjJO5BSdkrzs62q8eVHJFNIhVV+3CWeD8h2Ik6qBdg
         tujopjs6+TrOGcuj8/LkoK/xqXyf7RPh8vJqhX5buxD6aODZSpHFE9n3CYwWZNZzstvi
         d0oafky6vJi7mdtMYulW79K8YQ2CCRuqGN0QJkRq9SStp3P00NyRjq97wKyTaFX9O37/
         wBukESHjkfDK6SEsgmr0G7OQ4UYqtbpPdEmto1vDt+ZqpnN1O8d2jqeU9+aPODemo/Ro
         M4Lg==
X-Gm-Message-State: AOJu0Ywzy2m5lvyISYWokjxWm7hFFhJOhYHc2PaArGhqpGHcxI48XWY3
	yZ9Rk6uhc9+h9nNDNmUzV5vIvEpBtpyAU0t1k0eDPPw9b1G4/htLYr0zPu7dN+hgDJg=
X-Gm-Gg: Acq92OH733NkEcJk7kpYWhKVP4DbyfMmOkriU4pFm6S3B7iIQpbcv3kVaIkCWVE2fAF
	U5A0K4Jp5YTEjdTsUZb5TsLqtFLU0kbIVVUNj39QutjpVlCETgDFH/SyJzRAZjJv1ZMUaIaUJQY
	TlZro6roaZfOP/AAcD02q+G3lW5Le/uhaQ0rnfrCLowzfBdkB6CFjEZxWE/l+Altrgc9T3a6eiX
	tZkLhIobaOhT8iZzv1DTw2qUU4gpamFtzjE9mkhvtL1a/OCKttcHMmbwIvBsRsIgJvZaUwlwgSh
	5oX8Cw58ztUaejrR2ozAE4PBSvOc0uHDw9qXsK97EubdRq0Ub+4ZPrcMMl1zoMuzx0H9Z39Ya79
	QcBge5eR99/8vAoAlbZztmbRSbcdv88jbQ5adxoMmKWVceskG+qY0mM2r6hnd6M457zDPj9WptL
	YKsHUXMUACa5/7CmAh+kw1OmVc4LSx+0h5TJWw/9COBJb5Ud11prVmkywJ
X-Received: by 2002:a05:6000:29ca:b0:45e:d3aa:e45f with SMTP id ffacd0b85a97d-4606db98fd9mr2871894f8f.28.1781269721395;
        Fri, 12 Jun 2026 06:08:41 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f450sm6256564f8f.10.2026.06.12.06.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:08:41 -0700 (PDT)
Message-ID: <3386b16f-3643-4965-b621-00493dedc658@suse.com>
Date: Fri, 12 Jun 2026 15:08:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 52/60] scsi: qla2xxx: Fix Name Server logout detection
 on FWI2 adapters
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-53-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-53-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> In the CS_PORT_LOGGED_OUT case of qla2x00_chk_ms_status(), the
> FWI2-capable branch compared ms_pkt->loop_id.extended against NPH_SNS
> to decide whether the Name Server had logged out. On FWI2 and later
> adapters the response is a ct_entry_24xx / ct_entry_24xx_ext, where
> loop_id.extended (via the legacy ms_iocb_entry_t view) aliases offset 8,
> which is comp_status, not nport_handle (offset 10). As this code runs
> under CS_PORT_LOGGED_OUT, the field read back 0x29 (CS_PORT_LOGGED_OUT)
> and the comparison against NPH_SNS (0x7fc) was always false.
> 
> As a result the driver never recognized a Name Server logout on FWI2/
> 29xx adapters: it returned the generic QLA_FUNCTION_FAILED instead of
> QLA_NOT_LOGGED_IN and skipped setting LOOP_RESYNC_NEEDED /
> LOCAL_LOOP_UPDATE, so the fabric rediscovery triggered by an SNS logout
> did not happen.
> 
> Read nport_handle from the ct_entry_24xx layout (offset 10) instead.
> nport_handle is at the same offset in ct_entry_24xx and
> ct_entry_24xx_ext, so a single cast covers 24xx-class and 29xx. The
> non-FWI2 branch keeps using loop_id.extended, which is correct for the
> ms_iocb_entry_t response on those adapters.
> 
> Fixes: b98ae0d748db ("scsi: qla2xxx: Fix name server relogin")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_gs.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index eefd1440d197..0d345009732a 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -192,8 +192,8 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
>   			break;
>   		case CS_PORT_LOGGED_OUT:
>   			if (IS_FWI2_CAPABLE(ha)) {
> -				if (le16_to_cpu(ms_pkt->loop_id.extended) ==
> -				    NPH_SNS)
> +				if (le16_to_cpu(((struct ct_entry_24xx *)
> +				    ms_pkt)->nport_handle) == NPH_SNS)
>   					lid_is_sns = true;
>   			} else {
>   				if (le16_to_cpu(ms_pkt->loop_id.extended) ==

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
