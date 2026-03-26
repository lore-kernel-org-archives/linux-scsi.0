Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADD5388390
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 10:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774520355; cv=none; b=Cv3ZhCLrM+qkyhO86eFssRqh2/GQxhgxd1oQRQLRvfFbD7q5FypYwO4kXs7I66lhCflMvBJ5vOBu4PfjeZDrxIj2H46KB+QAIddBJSXZVLLq3TUaAgPJg//VQMQZM/zOO+RS7VrKTHjE9BUHQUPuTt2CK3mPU238i4DolxD0Pd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774520355; c=relaxed/simple;
	bh=Qae2gKOQfzbdP6PYGh8B/FDl0l8PUDf9Q4RiAP+IZxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SOCrFHaTg90bgPN5qqJsgYXRXmO/Gx/2N1j8vSKgrDAENT20zKiXVt7dB8HgcZ4kRG7mYLevtoBP6OVD/z9h4bYdcU4TZM8Ydj1ApX1FNhIbSvaaKujiJF+6pjJPTuSrnmfi7IrPNMFqeCKdAA8DlzSR9BB+u5DnEaYmNPCm30U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d846WNLZ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d846WNLZ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-487035181a7so4818435e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 03:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774520352; x=1775125152; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uc5ku6PvKiOyOZH+1palqwgwPAuIYwNWvmlAsBkODIQ=;
        b=d846WNLZtL9H7vxa2qyw+eYwQD55oGoN6YhgDKJX0fpuieVNgYFbJCv+tOLqREAOhJ
         Aj3bT/vayYQNWaDAOTIEROEUrILwmxbPmAkUb4LsFnxeAY67HPoMOSOiQrXYtvFxxoF7
         v7elVgqaSJXBDutCBpsyiA7aau4vyd4XXivWndembfkX+2W1ixNl9rCO4B0EMFa++A5u
         BWd4L4OD98YXHSouC6Siih5kvsSjyClL1eU942EClqESQRT7W9+PZgVR0m1Msr14jmYS
         DBUL8CD3+bSSWFxYukl8YghYNuPhbFPv7YgeKedAoq+Dlxg8xRulUOXZ+/5VSLImmNFB
         p1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774520352; x=1775125152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uc5ku6PvKiOyOZH+1palqwgwPAuIYwNWvmlAsBkODIQ=;
        b=gHbCtP/+RY931rwUL8PR5Aeai1uoSrZEaD7GHoxIQP8CSCuHTe1jgQw1uNSyB9LP12
         FuMdnCrgf5GiZ+HYFp+2t3PvLhejMcafFJv/qjYP0WEDxqGJ12q4jaszCQE51Dch6xtK
         2Q4pq95V+Zp5TospP4TusRZMf4HUVPoS9CHqcOw3rUy453dzrHLT0znTEDaBHd5l/ACA
         lEjouCTYrRq6jGScYVzUmWYGFFrXb19CWCDm9khQFRpS2/ECmGP3wJTqqDFqtli10gKW
         n/gA895k/7H7x+ThbINgIN2EbuAlwHbp5G1O+qC8PR+06+NpnQdN2znKOKEAAsBbNnrV
         LaQA==
X-Forwarded-Encrypted: i=1; AJvYcCW2WLVPZQyw1mFzsiU0IdFp4eg3Bxmai8P9KbmjzTllHNX8MALOqVWFRRv6KJsG44VPYNoNQ8BpAraO@vger.kernel.org
X-Gm-Message-State: AOJu0YxfeIf6dh0KHXgFb09XTyiyv7v+HS/SM+B1opoJIGKS9LLwRcux
	aQ2SNFxcVpkN5wFo49gJIBMQo9+L3n3g+rOae2G+nXqn4udvHg6V0FHy85Gv7nb07e4=
X-Gm-Gg: ATEYQzzQwBjMKGYpz4B9Gs3eUzFbUfv+zlWfGkpV1jU/38HZcIEXLsxae8qDmysfwW/
	iQRQS4QnERCb3Ez7FIdUSvgA70gc5Zawxc++omLteONU9c7L7T6F7fbECMwqre1rW9TP0QZAoL/
	wKMaGxg9vDiDs1Awr/D/IycWj47OJCQLEzigyc8Bp8xzQ9ZIWm21laJkUTDiWzVPaXC4XWxmajW
	v+IirsPLsNKEvmNg+Yuql6mEM/GxHAgWK+KBT2Fd4u5Hz5khZFZ4FKAWqVIg8UQAP/13kBs8cLi
	H1XZ7YFZiPzDmybHF8gENFScq0kH0J5vWObx5DRqOikY9xnmvBtmfuX7lOR11jX7WQsjCN06jer
	PTymj3km1Bp7NdPsExxY55EGOcZi6KJxZHKD8nGSBe9q9lzt5Vm5abshaVQKbIggqJ1ZUpTj9M/
	5bJWqSn5wVdWIRw0ogNQ+4drCGHCx3fgUVA6R0hNjHeEi2NJCReVHLv/dW
X-Received: by 2002:a05:600c:a4f:b0:486:fbd1:9dc0 with SMTP id 5b1f17b1804b1-487160350d6mr95710745e9.22.1774520351745;
        Thu, 26 Mar 2026 03:19:11 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722fa8dc6sm38717085e9.1.2026.03.26.03.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 03:19:11 -0700 (PDT)
Message-ID: <ff1d65e0-bb5a-4dc1-8bbc-dc781acb341d@suse.com>
Date: Thu, 26 Mar 2026 11:19:10 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: John Garry <john.g.garry@oracle.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
 <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/24/26 16:12, John Garry wrote:
> On 24/03/2026 13:58, Benjamin Marzinski wrote:
>>>> If it allowed device handlers to get attached, these two
>>>> developement efforts (native scsi multipath and refactoring the alua
>>>> support) could go on in parallel.
>>>>
>>>> Or am I missing something here?
>>> It just seems to be about this DH stuff is that there is bad history 
>>> there
>>> and no more users are wanted.
>> Just to be clear, if the idea was that the Native Multipath code
>> shouldn't use include/scsi/scsi_dh.h, I completely agree with that. But
>> I don't see why it can't make use of the results of the existing
>> implicit ALUA support, since IIUC it doesn't need the scsi_dh interface
>> to do that.
> 
> We would need something like the following to ensure that DH ALUA is 
> present to update sdev access_state:
> 
> @@ -80,6 +80,7 @@ config SCSI_MULTIPATH
>          bool "SCSI multipath support"
>          depends on SCSI_MOD
>          select LIBMULTIPATH
> +       select SCSI_DH_ALUA
>          help
>            This option enables support for native SCSI multipath support 
> for
>            SCSI host.
> 
> And that is even enough, as Kconfigs should only specify build 
> requirements.
> 
> We really should be also calling something like scsi_dh_attach() for 
> scsi multipath to ensure that DH is attached (and running to update 
> sdev->access_state).
> 
> And I am not sure how the dh alua module is even autoloaded. I think 
> that on my ubuntu machine the multipath-tools.service does it - 
> something like this would not be nice for native SCSI multipath support.
> 
Gnaa. But then we don't need this patchset at all.
Main point was that we _do not_ need to hook into scsi dh for implicit
ALUA.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
