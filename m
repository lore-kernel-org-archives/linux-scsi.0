Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6F61FC101
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 07:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522213; cv=none; b=JaA0WeNP0NaGK5Id2hlm/yt9gsse9UlU1otUA9R/2icFhaPwvhkb83v4TduZWTj7Hepkb3/lWPDXKXg0T3o1mb7/Tjdo1YoHR8liJoK9tBWDE5U2uGVyEtl57g0hh1YLQ5NOvk9ZM7GOYbJp+C8aCTV5D4VocXnkApiGCZ+L+dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522213; c=relaxed/simple;
	bh=/Qfj9Rfe9VHa6B3SdwOqVDt88Ex5URZd6iDmMVRAVRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fPapgrojQPza7HSu/9iKtLoMQHpPxRssRtHgUdl6sQxZT1YcHVuTEKg37hyjEMS7iPfc5NEof3UjjRDiaCjlAgcmPfG3Wa/yCkdmOTS/1eprvT9i6Lpt72FyvXTK+dmzOATyedKI3k/g3G603HG7vbYQxsHFbr/mgI1le4Zz5Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZstI/1m4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZstI/1m4"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48374014a77so63262565e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 23:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772522211; x=1773127011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ubymJC3yMVrWaVX4434QCzD6ml7X+t88qVksAj99ZwM=;
        b=ZstI/1m4eXgftaR2BynHz+xQM1nh5Wq0h9bBRG343kl2AiFbcm4TIDbFriZv+d2h9F
         ElAZpepzK1WN9eB4w8qSl/LLs9AI82hoUQW6hFXmQR0od74x9uNlGtacpNAdKH97yCkX
         IKsmHFIWWqAFJjnxcE1FJNkDq9hKmtz7UOOcthtgWJNHCdFxT3ybTqFajaNKT8fx38ZE
         y2zmDW9MOQFmo4HfyPkPoYGeajKAeH+YtNMeZKwOpQdWsm3g0JVqWOL3pM/VUyxKlNVe
         O7n2Xo1bpUPlBssUNiMXTnrTTRillcSVD28D2rsq3DOsh4F70i1lEoNCEb7hj+YV9p8A
         zQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772522211; x=1773127011;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ubymJC3yMVrWaVX4434QCzD6ml7X+t88qVksAj99ZwM=;
        b=w2WvdhX0Lw2jHyj6ip5xHCSIWu49Ym50DBvbze+AiAjjUGCnUsz6L9qGEDllcftnCL
         bvJ06pKrfMWRkYWEyh7x4Ou5b6QUaViOiwPJQ8p6mQB/wUjN8s1bu3ohPhFiFzfAmsiB
         njUEahljBrxmeWY85d+J2c7SfVfFRGzT/B1jXKN6OHoG9mg/cneyr5JR4mElY4e+tqRa
         GkeuBt20h8zRc2ELLVyqUerlm1ObkdhJltgeotjQ6LyPs/KLI7vGojFsGyyLkpdcFcme
         3OlH0jAEzpMVoB8BqsMS+qhR3O3DKZVgEi/o9pEDJFWquQh6bituYMEMsvSG0yheAKiR
         UO9g==
X-Forwarded-Encrypted: i=1; AJvYcCWVj26XYR0OMkpFEoOhSulSNPS758+p4FoxQTUJjgfKGAPruLqtBmSef33UZfVyk+NasNhTqRgOcyUo@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0HKZe+YhIIzHau12HNPnYEUEVk7rPEJQFBxz+QMJ31Todwkht
	baQn5HXhg7PN2ysGXJuS0vQj3EccZClwjG9zR+3bLEa7JqLI/u8W3cL+UWJZzpsmj2I=
X-Gm-Gg: ATEYQzyJTX95EQgoXrrVq/qNoS/ImaP2nNrdyCFSuX2lwsT0MZT/CvlUzBMig6BAb/i
	4eE4ZaekL96XxTQ8OjpDnj1tsoqiCpa59xKimGoxNzQjpN/y/QZL1a2YNOoBbmZ2CEUyXc2++0b
	a8UxsSZwXeqjPeJ9gKVw6YwJxMi3ktRP0RmXzy11Bbe+bsOm+iWLgmPPFcrlUdcv+CpsOFV10Th
	r+Mxxq/VwQSwXiWNCY+J6L9gEduCyhXNdsL+1r/xoB3RmAarVah2AXl2uQibP4cMBgK7TJSyycK
	9v56rRxUPthjAuS1BLrx52ccPbwj9DX7ad/b50s+fU91wXG4jCQ/8HIA7mYZmNHNUNi/HOtuwWj
	TrRxOSnFrb5OmGVdci1lwmT5hmsPVoICD/cZ4HBTFcwoYdE9v8Dq2d6uMHfm2Ke1aWniyEGTGvi
	EZlgXZVzfpSApBYdBWp3eg+nMBzR+T2vrXt40puFUfFZuDYMsA+ySySGlCI3hAB0CF5w==
X-Received: by 2002:a05:600c:3108:b0:483:709e:f238 with SMTP id 5b1f17b1804b1-483c9c1d177mr268411375e9.29.1772522210626;
        Mon, 02 Mar 2026 23:16:50 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485125bbb48sm16093555e9.0.2026.03.02.23.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 23:16:50 -0800 (PST)
Message-ID: <9881a867-244c-4ae5-852a-3332b7eb0614@suse.com>
Date: Tue, 3 Mar 2026 08:16:49 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi-multipath: introduce scsi_mpath_device_class
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-5-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> Introduce a new class for multipathed devices, scsi_mpath_device_class.
> 
> The purpose of this class is for managing the scsi_mpath_head.dev member.
> 
> The naming for the scsi_device structure is in form H:C:I:L,
> where H is host, C is channel, I is ID, and L is lun.
> 
> However, for a multipathed scsi_device, all the naming members may be
> different between member scsi_device's. As such, just use a simple
> single-number naming index for each scsi_mpath_head.
> 
> The sysfs device folder will have links to the scsi_device's so, it will
> be possible to lookup the member scsi_device's.
> 
> An example sysfs entry is as follows:
> # ls -l /sys/class/scsi_mpath_device/0/
> total 0
> drwxr-xr-x    2 root     root             0 Feb 24 11:56 power
> lrwxrwxrwx    1 root     root             0 Feb 24 11:56 subsystem -> ../../../../class/scsi_mpath_device
> -rw-r--r--    1 root     root          4096 Feb 24 11:55 uevent
> -r--r--r--    1 root     root          4096 Feb 24 11:56 wwid
> # cat /sys/class/scsi_mpath_device/0/wwid
> naa.600140505200a986f0043c9afa1fd077
> 
Ah, here it is.
So you can ignore my comments from the previous patch.
(and you might think of merging this and the previous patch).

But device naming is still dodgy. A plain number has so many ways of
being misinterpreted.
Wouldn't it be better to name it 'mpathX' ?

And, of course: how can we get the topology?
Do we get a list of the underlying scsi devices from sysfs?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
