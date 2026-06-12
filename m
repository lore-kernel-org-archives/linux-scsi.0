Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98132394E80
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263116; cv=none; b=XOtFExkuJlPrEaGAyJoTFeBpFJ1J5G0Yad3His6p5TxwlrNMoH9yiWR6QD4RFHiE1C8WEC5+PeQxYb+y6FSQnjuRAY34KauKq2jNOcXxYdtIsAPtfZI6LQjH+gT5ubl39nvkdLgkr6his7CRDbV7q8rfuAlRGzd90IFX9cDlKDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263116; c=relaxed/simple;
	bh=+bQc2YQTlP5mJB5+vAA/xbPPkD3HZwSkT1CnDymbhp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MaeP+CVby/KJEqYq7h4QaGQYWjVjOikd9/FsGLytAunmMQsKQjFMre06cGvQzijE0fTLwArnjh7/y5vjoEIn6K+KU6PpkH77nxFTIEOOd60Q/oeAejjv+wqgyYJPBx2SU705gHpW2CfW789fgXyeS3d0vXeHHcEqjnydMKKcZr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EtWxpMAW; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EtWxpMAW"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490aaeabdb4so5550525e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263112; x=1781867912; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x4Oa2OOBj4/v436/RZzRTK1VPoG52TsVXqQPPm9Ysko=;
        b=EtWxpMAWOVmoB8ugEX+svXAyHQyZ+6jIx8AEmzKWX8mDjUF/uuEhVFkULQbkO29CHm
         CsS7ovl9V6RQLmTU7atHjXmgSg8K4rm43I7yfaqnVvmcpiSdZDn3RaYg/w7kVJC4HfLx
         erwQUXLQA24nHlvtdXQCu3E4eb2mZz0ODlqM9DI42zsXFLfqViR+u1mBM9cgLmwZ6+a/
         J6XK9MD3giI/54z5NqLL4IYYrl+fsg+iVuJrgvKOH/WK71+6evN5FELj/heeIdsWvit2
         LhtnZNU2e5EWAIK5pc4hoQycOgWdyeAg2jaaB+mKWCrYJzDoLEYwtnNHbcG0wucQpnNM
         FM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263112; x=1781867912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x4Oa2OOBj4/v436/RZzRTK1VPoG52TsVXqQPPm9Ysko=;
        b=Rnqtmv3gJFFhlk+9HGnr2Go41cYWRqL83myBs6AGygwnznDUwQPc6R1JP6RGWIpWQA
         iV5BlupJVoXacfKkxT4YQUus8PWz4A90qCTibLsyK80VN08eCz9sgQUVXhEPNub7ITOf
         wrZvi7d8v/lISKevm0vQy9zkFV+87wh4Z5TEhPxkmDhbz5pr5IA+3mM0r8MGy8+9ESai
         VWJTtn6/YyU8LddsFWtbGg1pqGa3lY56c5jVXg7hqF8J167B6VlWJ5cyXI+2Yn6C/JIQ
         f5K60tI5XGqgEM0NbrZHWGv4lriGcg8sdOqv7d0fn9iXhKVTBxVXRA2R1AhcZjdX4EhP
         5J2w==
X-Gm-Message-State: AOJu0Yyr7jcCJbyr4dSrIqOwbYFdXOoYRmtAGUuknlaghYQQCI/UpyiO
	AIzVH8qq8Jlv6F0+E/gAhREiD1/zAWkNQFxqvPrje0Gfuuprk4s/3ssKiky0+Yzq6M8XHVVIlSM
	FMaWt
X-Gm-Gg: Acq92OG70TOw3wKBWqdcNCYyrZ8tl2j3Qt4ZjAXaNW2abnhHujpl0mfYsnq04IYBYxI
	FIvu3L5gng8rZa4uo9fwLjwaDaCjbcRpACy/xWbH1FqK0AqX6E/8OjeEsM1M1MHAosJXw1OR4ty
	ur5gSHemiMPycFK+OhdAlnOuJ+Y2g0qJK+L5fM0oZTecuvfK2I97YSyg30Am4hLsbEil7iLmuTm
	sfZxIpFPxBWw7G0d+dl2eCSZEpGY9LlnGZDh6ka9CqKgy0Qf530oXrBqfm8pDdeIHSc8yWnu57f
	/pmfPRemY9P/qBobWb1/+WJISvZjhYKvzDWkLjQ9dqWY5dJ8dXdRhkZ9f5EalJiIDv3dXzHo13j
	JrrhBGwNsdRIds/ph1UDTadxxkoxhKzb+b2fmvm27OjRHMSkepE23WPjvIVLFBHmK+tou0cETLv
	jd9W5hhNJbq6au3grl0IGLs8UXrwP0BaObm9vzegAgfcpjXuIg7jIV8C0Iq78cIkTTNYo=
X-Received: by 2002:a05:600c:1914:b0:491:9969:739d with SMTP id 5b1f17b1804b1-491996973c1mr16712925e9.29.1781263111874;
        Fri, 12 Jun 2026 04:18:31 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7c08fcsm65788975e9.1.2026.06.12.04.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:18:31 -0700 (PDT)
Message-ID: <adaa9e73-e491-4137-b26a-e421e4895ca3@suse.com>
Date: Fri, 12 Jun 2026 13:18:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/60] scsi: qla2xxx: Enable init_firmware mailbox for
 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-20-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-20-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> The init_firmware mailbox command needs 29xx adapter support for reading
> back SFP information via mb3 and for validating SFP status on successful
> firmware initialization. Add IS_QLA29XX() checks alongside the existing
> 27xx/28xx checks.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
