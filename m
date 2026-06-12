Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0262EA173
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262925; cv=none; b=ers7lTNk26f5xz55XNGym1Vxwr8zCkZCTXEvdIzoljX5+/o/mJWcqODVmLzJNr579POka4FlyzwdPDd+VRLuFxSK7rwcE+oXE95fP5lZE/iiBCaIDq7+5CczijSK1IlHSLUq8YY1RULudg4FS7JrJ96XEigI6A4C0INQ1585Yh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262925; c=relaxed/simple;
	bh=RpStlovlFvM2gu8GlFdcoz2meixb68g8mkCgP68R5x8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aTM5HDdx/fwknSM5eKzAwZ7YEJSn8MO5mLgBZj9oomL+760qZgCNf3t/Vl7ea+OfsAAjarBDR4qVYEkQPofj0ABOe3e0pfgo1NcZcshohMLPfuWyuAzwIWoJyd6o53qB73ctbwO7jzmchnPsWkCKlXxA3L1q003O4hpNYe9NdAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U0HUDvyL; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U0HUDvyL"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b12270b3so5074745e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781262922; x=1781867722; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/WTzLLEhbVXynVpBWMeL1XKNiHj8bTj8HW/ZVF5I5rk=;
        b=U0HUDvyL+oNh3VpNvxhhWsDPH43kymgqs3M2YBMrhpDlkd5mr9oK8OFDZ2G+oeLqw0
         uJzMSWhsuDAYA6IA3yRYTPrj3fKpSlO2hZ9XF0Jt13Vz5HKBCKWls73qDQNogsXC7tK5
         FTMGoXu/qAskGa56KqpZJo4vchNPaIsDrhzdKp5i9GkShFsvqU3SmkSOdoGrxLk++Ns5
         /drL7mTKj4+d05Nq9FPzPcV24EiWrM/w9c8EECAc9aV3Qd2lrHjKXgNmnPDw92XrdJtt
         l71DHjI+PAPuGQKX7WeshvDPU3WT89Ig3+BZij2Q0a75MaCiksf6xpzdhuCTAEypmcTT
         G7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781262922; x=1781867722;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/WTzLLEhbVXynVpBWMeL1XKNiHj8bTj8HW/ZVF5I5rk=;
        b=m5ejuweENPbTpoBOmNp3E+5rKakpw1etWqSRxlvulojrNXmvrMUraXqjeRCb28UWZQ
         1Ql7ahGyefzyrdVga0FKzPXXWOD6p1ihB1tcet59RSVl7tNHR7hiLN/foz0KZHCVFJjx
         8fY6teAcV9e7xfjU63SM2Rkr0/mDTiFvlv0PNUH++y1YwXEgKIVGNUr9kbFmnCY3Lke6
         s+MlYThfI1Bp5CsZEwzmM8KCH1gqupsXNyRdded73302e3gnvXBiQVY3VjkJAjRQML/p
         ui/+8gXBB2NkPPab5e4MhW0V3kTXkaqxYAwlSIVsN0N918tp2XU6IBnCUev9SYVcUdor
         8UIw==
X-Gm-Message-State: AOJu0Yy/Kt7SIbtcpiHKB779q0Y1n9LFi+3/OkISJHtFc/FSTjka4szg
	/fTqNlE3WR+R1iVlmWRugnZftNv8WOKlfoUdN/3IFmOzMfIWOK3tQGJOte5bMMjeMhQ=
X-Gm-Gg: Acq92OGn5DxkVU0L9sryaggZtx7v3+ikpsS0HvEtl7TBihTPJYaurSv7h5fGwYYRHe8
	50M9O/cHBXemjIyey3ps6GYlt2NuFUXiPriRS8EJ0puqurXswGS2YClShHjV8A6XbN09V7NP7oh
	KoDiIhrPjaHxkByWiQ2dDi61a4LfKpQs7Bq7049AVzVg576JpW1NFRgTH43CEl/UU3Ei4eJDurz
	eVoE5HA6fNfhABEnjPUzLb2mLZ9TqC8nfzDICUmlHVp0Plv1WNAFUiJQOvg+mdBkN01Hsc2JUlI
	+knUn74XHXHV+9DYLipkT4XJ9OvEAvNXqjPtUaf23xMVXToDwMkFTibWM5EI4q67/5gcMHWEMUS
	2SC+KnvypT3zuQLzIvB+T2Ua4NB7MA2au7GQEPzJspEV2HNh4G2Ij45goqccaR6ydAjctrnnxfU
	9MFMtXeb/8Llxr+FR2KLajVudl+hoxvB2xruCHNpRh6YthpOGBzrVBTG3n
X-Received: by 2002:a05:600c:5487:b0:490:ea8a:32da with SMTP id 5b1f17b1804b1-490ec509524mr30019345e9.26.1781262922329;
        Fri, 12 Jun 2026 04:15:22 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2d0475asm225503035e9.12.2026.06.12.04.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:15:22 -0700 (PDT)
Message-ID: <d07a5225-5793-48db-a729-dfb5a446affa@suse.com>
Date: Fri, 12 Jun 2026 13:15:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/60] scsi: qla2xxx: Skip unsupported sysfs attributes
 for 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-16-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-16-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> Not all sysfs attributes are applicable to the 29xx adapter.
> Return -EPERM for attributes that are meaningless on 29xx (gold
> firmware version, 84xx firmware version, flash block size, VLAN
> ID, VN-port MAC address, and CNA firmware dump toggle) so that
> userspace tools do not see stale or undefined values.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
