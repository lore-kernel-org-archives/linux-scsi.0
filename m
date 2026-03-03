Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F41A2BE057
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 07:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522377; cv=none; b=EstW6cESd926cjzHa5rS8kJ8T7oV0/u+T0maHUTGJhVftm9o/8dC81DQKjg88fV49zMvRhQuHhZNa5G9CyEsJuE3jpMYWMyMa68fH2AzWaU8QfiirUWhud0zl6bYeroaUK8dzhQAxinFjnV5r0RahmWD36uN9nWmDYII+5Zp+Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522377; c=relaxed/simple;
	bh=CwpYG7JVqX3mAprWsx7y8qvWB1SdKDYQNXQBFtdWS/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wmf9At6qAvBGcGnl0hBeZG54oV81NHY70Nh+qPKkD4H552+FCINQ5wiD6F5EAPgqykmWwQwXdSivPRCEjuuHiseqnqc2AffcqnVStlslXpjJStTXMrY/uWtp7VxzkMuCUbFBZy8h00CtviAbwJAGwWNQjwyHL51yaD8xWipFMSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WjTAwvaa; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WjTAwvaa"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4327790c4e9so3912958f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 23:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772522375; x=1773127175; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=emzxcalxhefyJPtrnF5BVbzsZJUc4QzYRAPUO5dkvYQ=;
        b=WjTAwvaauVuzzJx6YP2PK71akBqEIUvswWoXuw5jL9qpnfw+GjeeBMgI4/DbuJ4FlH
         xDEW2FQYO3XE9YAOamNyo1FCBQXORgYL2yy56UmQRM3eOzAkxgsQyZPqtH5rDehDQHXY
         dNzOeYHOf5icmac+w7lSNv/9WQPk/aZLzwK9B8oiWyFu8C23AiatmSyCyyBarYp7TGZy
         7qyd0mvjEHhZtGAiP43s02chKqNLF4BgMdNbaBG4Kjw3wUxGRE22+wmTnnSfHRhQS93w
         ZkDnjTRoNpTQNYYIM6CXpTj2kfXcS4nnWwMDd4kN6lCeZwccNlI1QRSdXJNmX8IhA8x/
         Fv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772522375; x=1773127175;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=emzxcalxhefyJPtrnF5BVbzsZJUc4QzYRAPUO5dkvYQ=;
        b=hfjNNMqI124i8rOLcO16vpJjN7BV+Ud4PaPzVQDd4U/Ps6U39XL6zMcdEQFQnRO2+5
         Q9FiZ02gyZ9A5M5sXwyjrHa10w34kOFsiPG2Wx5AWvA9sAkAEbDtSQ/NPpjIv8CtiD6D
         gCuZjHvj/lwcfQIuYEN/Qif88WTZvool+cHB0PWHxAkRMlmV+aWpHr6E0mNUbr5eF9/u
         ZR9zvSy/qWrKIzrY5X60s2RK4rKzfCOskLpqQ29ZntXlUat6vYIGYw3iMa15EZBX50VS
         +DE/+HIxyPJmg+U3ncIBjigwuBLcr4fbLOO89BujKoSctalG6lmxWJHreUA6u8ulckyb
         t0Gg==
X-Forwarded-Encrypted: i=1; AJvYcCWwZeBdhKev9xg4tbpd5BuNqlNx7Fv9q1w8GdsFC8iGHoEvygyUppYaskkjq91HnUyUKmmHlgfxuvMg@vger.kernel.org
X-Gm-Message-State: AOJu0YxtSfrEaOzVNBZcq9iYqRv94TVFUpVUt7r+1aSUTURkollBl+7o
	ZCxy0ihHOWIgVeEWh1f4gu6CmvtlhtUY8E0ki6dYpe3szUkvukVhYPIKMuBdn5NkWqI=
X-Gm-Gg: ATEYQzxDNzO8M8cN4cbQQu3rp+yIdajewLnoTNfHozo895MBQs/T0dZ9/3+PIvcYM+0
	xBe2PUgOvHOplgyezM3FK0wNLxAGJ4MPUqRaMkpjMxBILVxwPEKxALCmlsXVr+5myCbCJ+SoxT/
	i4r6f0rlpMgQHcNHhabWO+i//33mV70NlFNj7T30wHy4auu/1j9lTj/aG3VI1NU3CSL1X/jy24U
	u2FIQe6Kmwotab2X6Zcd4Gmm3ZblGSKynbcBUqXqNlwXJnLP145UQ54Wt9L/CK6ljfIL5AQ3w+Y
	GTfWPeL64UEE57E3CptfiPWHjFbFwOHJR+kyyI/ROKCs8FHEWzpgmMQFN5u9zqH6Ht9LBabE8wp
	IFe4puqeu3Perc4aAffvVzr+5Uk0y+jwhDKhZQk505wfvdEFKROMGiz2ndwqjHJBBZI/wcVateN
	yIltjREgnHMrMAaAJRaEfSnJKbcSAxNn6spcmVEwfh/LJhB1LhqLbBl52bSKxm+4dfEQ==
X-Received: by 2002:a05:600c:1d0e:b0:480:3bba:1cac with SMTP id 5b1f17b1804b1-483c9bc55c0mr240863065e9.6.1772522375015;
        Mon, 02 Mar 2026 23:19:35 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd7030b9sm370239755e9.4.2026.03.02.23.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 23:19:34 -0800 (PST)
Message-ID: <3c173449-bad5-4d74-bdff-4fc9fe4df566@suse.com>
Date: Tue, 3 Mar 2026 08:19:33 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/24] scsi-multipath: provide sysfs link from to
 scsi_device
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-6-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.
> 
> An example is as follows:
> # ls -l /sys/class/scsi_mpath_device/0/multipath/
> total 0
> lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
> lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_multipath.c | 45 +++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_sysfs.c     |  5 ++++
>   include/scsi/scsi_multipath.h |  9 +++++++
>   3 files changed, 59 insertions(+)
> 
And again; just what I complained about in the previous patch.
Still not sure about the naming; 'multipath' conveys to me
the opposite (ie the multipath device, not the devices which
are part of a multipath device).

But anyway.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
