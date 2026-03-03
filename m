Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C153335898
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 06:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772521037; cv=none; b=nwekSa3ty7HvDnwbiBPYKRtv35T84m6br2hJ+zGU7PHoWjwVlhTZyn+GKkZi+/KFMwBIN1OP00l15E1P31lUm3LGcAxdKXCHQU+A3dnRDMWo1/3y6+KNiSdJa9cCQnqhBtGLvDGwZcOBUz8rON7oaUICgrpX6H/K59ZGIUWZroE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772521037; c=relaxed/simple;
	bh=brmgYvldAEzJ2O8fsEmwzrbBh4ultBTeueXu8bmByKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ctiXU75Dc2PA1ZalSxiAL+QCCFfwEjllpMlHu8sQQBlZOwkojg1gx4tg5li1nJraXeoYmXTiq97pbX1F7Q7b7SjxtQU7iAGbBiD7eWN3i9XcZo4UzSpmVqAFFVsYiZWnLRlWI85nbFKN9MEWIOUNfD+urFYPxWY416KgixHO1Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cFpmwWab; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cFpmwWab"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-436e8758b91so3395011f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 22:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772521034; x=1773125834; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+UWoE6mn2375qZ/+kFXj+S+YU2oT2pZiLz3gYYgeg/c=;
        b=cFpmwWabk3Yww6ESHhDeYJi2bD22oPTWIhv36cwI0qbC3LM0/boXyXsa1yojvCJMMX
         BT0sEj+CAPryDqJlE9sZ8IpBg5cgK3Z7ahS989YrIhpkST/4T/vPIdkruCG+CpIwwuT2
         LxUEOsJsN+j8OYxlrh/zIKcMpWP0Ju9rMszdPwobV393pfm/4Rtaqeq9CvZ8c12yfvfp
         FXI64GaowLdgEWAUzFXrhKHFEe89BY779V2U93522leikCVtf1OIiyg+2KTBhw+tGHG+
         KLndZ9C8sFFHvKGeMNVQziXl/lDqU+Qox7g1etwpEKJqfhuok1FY1h3tzUJG/9cVxsHB
         Mk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772521034; x=1773125834;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+UWoE6mn2375qZ/+kFXj+S+YU2oT2pZiLz3gYYgeg/c=;
        b=ZuiipG78jQKs/px55AD6KXgDWwtdO3rN8dQWpK1nyDHgr/ZoZb90dMUnSZUil4jnfD
         jIJPdY0TuVfFxTUIINA5hpBc3doYHkL2fdre+8OEp7Q/MIXFaqUuNQ4Ucf4ZZvEEULxB
         n77+L29OSUcdoZE5yCKMmAVXw0uaF87CxxfnXj+Z+8FG0aBo1Ril+fpz9y8MOLvil6I9
         M5AQ4Fh82LiVRDy6CRVBcIvNng0Hk8ra30N50ou+vy7HHz7JGLfPbrns78TTJtruMt7v
         7lUpXKQmbFQTYqRb937rpJezQjYoiHXVvPcwNqBo4J5NgAjkHkaPMMaRuTLEfRvg6qHB
         YwUA==
X-Forwarded-Encrypted: i=1; AJvYcCWCENIu/nBaNAA0esynWXoUcuXzEX6u/51B1uKjsnwBWwi/Oa8qTB0a9jn7PpdtFei511DQn4PcpStC@vger.kernel.org
X-Gm-Message-State: AOJu0YwJPlOjclSn2Fi/ftoFkbCSljcyZVQ4pvVFAVvZSqkS/1qahPgJ
	9vp37XkXZyH99OlqgTtwViQExIREOM+9U3BGl72o/tdgZUCq/LNsbEuIx5I6OI3d0u4=
X-Gm-Gg: ATEYQzzsi8VEtLmu2jAyyQVQIOSOPFPF2W5f09Vr2pkHUpYiXoEM8dERcozg4/1Rb6d
	o6E4pHvLyicbh++BR0Yrs0aa7aMmBKEMZEvMcTfd0RYlVH52huCKt4Txpjb2hkKbIYLipuqdwzH
	1D7ayqH0VFv1Xtx5MioyiHA0TjpoJEUtUHhjkJxosPmTeiaIrEQHxbrvtmSz2FTwmTrCIDvbXN4
	4eiLSybBkFAJ8dyj9QXG+GxKbtQ9y4ExeWDM/3/BUk2G9B3MqzTN5TPLtSVPM61M2bKTdGyyEv/
	de9DrUVNOq+s7cWkDItmhDO5shlnAU+WCIOpcBcauXjC+UxYOz78d5NwmGQkKeC/6K7etrSHnre
	7K0I3hFnFouVRBNjfeFthsfzV2eVhwoKivjfzJYzV5HU9z19/k5RriTArMQB2nL4msj/qiIOY8b
	X4Zonai6joDkjOcftx2dOqVSNaqQTP4uOOBA1tuBbfMmKOMP4qlXWE8aEkhQCBSLoyyQ==
X-Received: by 2002:a05:600c:8108:b0:483:7907:ea02 with SMTP id 5b1f17b1804b1-483c9bfa9eamr271767355e9.16.1772521034082;
        Mon, 02 Mar 2026 22:57:14 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485132f202bsm16289535e9.0.2026.03.02.22.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 22:57:13 -0800 (PST)
Message-ID: <e22f5444-f8ff-4c91-b9ab-fa95714f2df7@suse.com>
Date: Tue, 3 Mar 2026 07:57:12 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> For a scsi_device to support multipath, introduce structure
> scsi_mpath_device to hold multipath-specific details.
> 
> Like NS structure for NVME, scsi_mpath_device holds the mpath_device
> structure to device management and path selection.
> 
> Two module params are introduced to enable multipath:
> - scsi_multipath
> - scsi_multipath_always
> 
> SCSI multipath will only be available until the following conditions:
> - scsi_multipath enabled and ALUA supported and unique ID available in
>    VPD page 83.
> - scsi_multipath_always enabled and unique ID available in VPD page 83
> 
Why don't you merge these two options, and have
scsi_multipath=on
and
scsi_multipath=always
?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
