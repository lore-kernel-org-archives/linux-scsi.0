Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7B936F91F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260864; cv=none; b=SETzAh1vukxZJh27w3zcGL9u1rh6FF66AXc/7K+tDFLaUZQCkujzqfc8Eex9YrcQgrSpiq3sYspIvlJpRGEYzea3Ywv1Aep0FR4mTjK90LW194EVf8c3G9Md5qE/sg3Pr+sMhTJgrpNQM2VbUxdgVLGsmsTy1BeUN36EVqnsOHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260864; c=relaxed/simple;
	bh=6WAX/BY1sHk/+7dB46Dm7FyBEXp55ETI0OgUhcm8Qd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JvlFvxBqKeqbqq6D48NUSFh6HidgultPz5kooifqvUZmNr19strDuLaig/XS7br9ZnvTuWOuHEO3sWS+2s6QAtu53qrkkDXAQjk9sHZFErBpQNP7Yynfqt1cfdM3SlqM9nrRM116CDiYaoJsPQSRwCVg79AJPA0Xhen5p7i3Mew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WjpIh3SP; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WjpIh3SP"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490b7866869so7944875e9.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 03:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781260861; x=1781865661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IKYhDbo/BVbPAG52eCa6j34AzNbuZIzmkWiRm07K9uM=;
        b=WjpIh3SPqOtaAiWFBM/HFmo3fBXl7TrGx9d9Mi47UXKIpd0wCVBCacFTdvZdItA40H
         ogMyqzMxsjoxcysvi7hGKN+okt96eZRrC+0t1kWr3NwTEqXGEKtkXzejCkFgsF+6x86P
         y3C+NsLAvO3e2B+AZAAmkbMkiHxHooik3Am1EC9/FgKEKqFSYAhyvJUtzV+mEPUVb4Lt
         VQiiQ8p2hOLIZWO0eal29IqX8Q4X104ubDs8RWBYImtc32PLPTwd7jgB0dsisf60eqmC
         pKWYHIUDKNSTbyFHGgyXTGUUwljJfrzt0N6H4sjsyjqZ18QK1VLozVdGZ1+iTTYKvW7C
         pWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781260861; x=1781865661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IKYhDbo/BVbPAG52eCa6j34AzNbuZIzmkWiRm07K9uM=;
        b=nYimiL+p7f2CwMFGKiprvJeYSpt8vgIpGGCL76b5dhoQhgQga/N5Dk0DHQlVRKn5zT
         FNcw6urQ7mL8b5YZO9VYoOq0mgk/MtHv8lp8GDkDH3wgGNgMNc4AlUgkyDR26bqJ/hDe
         w6+3XIEDPOe+xzYy/+3D3T0QpklPpsgAqX+gg9Fb17QyHRpsho9bOpONz29napRrMsqF
         M8zNWZ/7FgY3DuWTDBqZuL0ygD/mXt9+i21FErTutyUSny4zTldZLlGKVAyyYhQVfYhO
         SBQ3tMq18mU930E1ukdz94wlHH8wwA1bwJn1iMw1pSijwnAeZ0//6EQely02RIiAe2xj
         GdXQ==
X-Gm-Message-State: AOJu0YzK7rAL5QnLSsnLFak33s6rqP+w1KqaOMDIAvnGBQPWUEMn0Bo4
	wt/J/bas5VBEIY8qfztMoivMvp/tZ6TPjNtQPZAOG7jiv6hFfbE9Yk8rZhRGa3izrHg=
X-Gm-Gg: Acq92OEWfCpj17yQvzjJ42cMyX1h8ETPClB9roekKrFpiEP1S32/Ike+28vASIQoPgn
	XSB/pG8QwUwmrWOpmn1jgU6u3hFYVLS0X64/BvsmhyCNvw+PUj34lex3SFXOLJWvh4C76aUEF+/
	nT1rYXLp3dg+ioHfNzE2OSoS7LIVifXYRRd4S6sgK86Dqq64GkDq3PmgP5VoTeqaGdMGR3MYPDD
	VXQbrXG0M6heP7r4k3yZzPPn8s5q+PjDTwMk+evx5cI5XXdUNI6KKgDFjDqrOk2rafoKWJkNc4Q
	YPo2+iStkiegENhhiVwPYAswKzMfe+ncinfb/RfgwRneWNtb6FfB920sFgrqKRLnQllgZSjCix2
	eymi7XdFQn50ngJwJuUPjs3O5ZKKP7n9sIK0BvHLJ26pV/QYjsThHaX05QwzTvPTh3iOYhsisQl
	upveqMdbW1MIsvFkl9lo/l3RLTjmUNiV7flnf7FsbadilGwUYe3qkJQBtV
X-Received: by 2002:a05:600c:4514:b0:490:e1e6:8988 with SMTP id 5b1f17b1804b1-490ec4c0327mr28465305e9.7.1781260860813;
        Fri, 12 Jun 2026 03:41:00 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2cf582bsm154474595e9.10.2026.06.12.03.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:41:00 -0700 (PDT)
Message-ID: <28469a1e-361b-45d0-9e7c-82a3565e4f45@suse.com>
Date: Fri, 12 Jun 2026 12:40:59 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/60] scsi: qla2xxx: Add 29xx series PCI device ID
 support
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-2-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-2-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Manish Rangankar <mrangankar@marvell.com>
> 
> The QLA29xx is a new generation FC HBA that shares much of its
> architecture with the 27xx/28xx family.  Register the new PCI
> device IDs, wire up IS_QLA29XX() capability checks in the probe
> and ISP-flags paths, and extend speed-capability logic so the
> driver correctly recognises and initialises 29xx adapters.
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  | 33 +++++++++++----
>   drivers/scsi/qla2xxx/qla_init.c |  2 +-
>   drivers/scsi/qla2xxx/qla_isr.c  |  5 ++-
>   drivers/scsi/qla2xxx/qla_os.c   | 74 ++++++++++++++++++++++++++-------
>   4 files changed, 88 insertions(+), 26 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
