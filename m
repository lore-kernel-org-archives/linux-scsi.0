Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC15E363C59
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263154; cv=none; b=FPPolIcQ2M2e9tIXG8dOKO/6G1Gs18tSHRApfT2NY3p0+pnufcVDzKFjmBgnFy1PJgNYJQXiWpEgntN7KTsTdPjFWl2QCcxeJ/HalBGH0Hpb6D8SfMkizHfELA0WHhyWNwyFzfRCCeftEL/GWgnn/dPpqvDjt5PXkOZuLQfPxXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263154; c=relaxed/simple;
	bh=tXIoTz0WUf+MkznMFU2r3v+ooUWylkT6mAXUH6BfoIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ur7GERSgC1O3LTYn/zn1STulNFWhtwMSq9fVYsrvGCQsFNTd5DrYABWciOhsLmiAbzZmdtAdO/RwT0LrSvWQ6MIWysbLn/kJouAy3grkzq8WTVuJOcLpg1hXXoqgY2zx3E/GJa6kGrJlaGhSw9yykAIJ0AWT4naB386llygPQuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EsU+S0a9; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EsU+S0a9"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-46015dc517aso648062f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263150; x=1781867950; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=876SNnzIWCWmTDEdgdzsoasPPro7tXe9odvz2h2lB7c=;
        b=EsU+S0a9oewSMNT0jnStMfU7lbujXOme8e8bBLne49r2pKPQyzuLYD1Sg+X9Ea1E72
         zFBtm1rqjCNCDFeXerJ5vXqJ4fdR71kwEBNZkC+/b0qDB2zOzvD/RqFUNe7DiJ2qUrxT
         mcPDU4Z2PmKkIMGdVvjmIgTTUQkfyjhLsfJ1bkDhVyBux0SfmmDW51FNL2joqOVbKQLy
         G2pC+DvJxBaj2KUkUMIMatSTZ4fs3I49z+GFCE6AnqOyv/udRbKnL8OPQWjWtlT5JOq5
         MjUOqY0HTZE6M2jhZje1fWqPvhmqJWaYbiu4xNrtTPOkRXNKGTRLpAii4KJEfoiHy3Xz
         Pc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263150; x=1781867950;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=876SNnzIWCWmTDEdgdzsoasPPro7tXe9odvz2h2lB7c=;
        b=WMXU/Mj8RPlrRworbh0Pux3x5yJ8Co9Ue3GdO4dQ5Id2Ig1+a66XaAguCvp+t0UxGp
         tSN/xQ0L4vrQ1QF2T7PVYCSLWg0f/cvud7IFNzGmgsPXyKFjG4qoqHhYv+DjmPQ0ZhsF
         reWoppqj4TQ2YlzCdYjaxJ21m2Orr/zVVVZwQmNkPPl1sOeyr6ta8m7dkJkQOTlH1pdX
         pAv3g2nn8CfgeBPW1ULaeQUXAZydCKJZNlVOSTGlehvM2lqyq/76jjwIZpC+dgC1em+F
         bv1VXLNkVBy8EF/mqfxjWW/x755C3NFvlxrXcEATYR+d/BM4vk+U+E9FA0PCNpWdi82C
         SRJA==
X-Gm-Message-State: AOJu0YwZXvoYh4CpsHVWKgu3D8YhlmNKCA9/MQiprnf13SkefResgC0u
	6WGXGWTb+VI2wB04BpDevPiGal4xjXF4jCkEVE7Fu2ni9wXADgql9a4/8ljW4MLykas=
X-Gm-Gg: Acq92OFoYRelBdZMUU7wt1NlbblluD3x91HIWQcU4A6av30qNILMO9GU2QFeojLuoA5
	5Zq5m7lP5goRUe5fppJNUBmz6u7DZ2kMlJZfadjLZNMxxg4uZKvPORhG1QRic031U2W6R+EUdMw
	PFGrwV6LtNqVQ74QCf9iRK0+EqtiyDRi+6GDOo4ftLeynQOqLcCy3t+BoZAvDs7icltjx1jexVq
	vkRaGdxiX/No9zEC7n/od0BrZVJU1uigZGZctD7oNJ1MMzx/GsjIA2POtRLgaUwp/j+EsiTgGaQ
	B6rngoSwRV2mRgzL1286OIIpE5194Zx0CyG2EvIVJVb94jm9QGKSlHMrhq4sDzK+5xe4IzzRzP1
	0RE0qwm+qYyH+QGm3N1K8IrjxF4h0EwvRpnISAE+4ONge7JzLOuCh6cYgnrFR98ox8WG62jPFf+
	B7kZyCR1TrXdKUIwJRrihZfcJvk7p1LWQ9n7iStPjZ6pSdvXCYQJrN/6wD
X-Received: by 2002:a05:6000:41e1:b0:45e:fa17:a1d5 with SMTP id ffacd0b85a97d-4606dba1e09mr3498310f8f.33.1781263149928;
        Fri, 12 Jun 2026 04:19:09 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2e592csm4916329f8f.36.2026.06.12.04.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:19:09 -0700 (PDT)
Message-ID: <bff19429-c8d9-4dc1-a114-e1650c87eae5@suse.com>
Date: Fri, 12 Jun 2026 13:19:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/60] scsi: qla2xxx: Enable get_firmware_state for
 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-21-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-21-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> Enable get_firmware_state mailbox command for 29xx adapters by adding
> IS_QLA29XX() checks alongside existing IS_QLA27XX/IS_QLA28XX checks.
> This ensures MBX_12 (MPI state) is properly set up and reported for
> 29xx adapters.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 2 +-
>   drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
>   2 files changed, 4 insertions(+), 4 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
