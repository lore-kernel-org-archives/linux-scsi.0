Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26DC1494D9
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755364557; cv=none; b=eCJqw/Ae3ImPHmC+4KNSEfPUTaydtvpjj4lHnYaY7J+oZ35ZrSMmfxqdBSOWQWoRIifJkQgSqHc2XbtsVlIWRmfeqhSdd20LuHSwe8wFiNLKH1kmYnQHaiKPMye3K8i/6oF29V95sbonbmfT1JNwS7909Owv3tzZc8TsEqM8gRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755364557; c=relaxed/simple;
	bh=ThKzClGHA7jgqPLOlN8mJRduE6aRMNGldbvyaEZ3vv4=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:To:From:
	 In-Reply-To:Content-Type; b=BnmZK5zEdYkWz6UeHJz+Du96bFI4qByNGVXqoFM8U4QpSgka0ZnwjmEilTe6zyAvzX6jxkfNk9I9YnhyAucWM66vUYR86+ApaMwybg1j69v7zyuwg5fUskA51F0ZVUg9I9owcCFUHmgDiko4P/6yHzItUgR1mpS0SFKrU7AbW/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIrU0RPH; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIrU0RPH"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b9e414ebb5so110834f8f.3
        for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 10:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755364553; x=1755969353; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17xGCAOYPaXnnoQHmlg6SyfhhHnDFJ6cUvyz6KfIIP0=;
        b=XIrU0RPH8nD48R80jNgjm/yQveGVFRV/GtAI95DVskwWoPqae1VZOBZsDhOYyX2ut+
         o8EWgm4t9Do6O9g3OMVvkD0QR9GEy/CZZWCsKm4xarPdLXT2TOpbnj8LJGItQMACikm3
         pqNM0LujW1S0ztpOmwwsjIzDqwIIaO+HaNNE2stvDww0DdNFoqJ5gZiq5SKIAK2jjKhy
         cmszfOzKzgIW8DBAzKZzT46lR3I2mDH4q1loev5ekACF/4LQ9OjWrmgj1T+dG4c8E9Ar
         vTJfb5MckO5bjunaMuyGzB/2WEhW4v5oeBb52K41zJGUo4APDZFDCcaDsbKdqstI77wB
         Hz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755364553; x=1755969353;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:cc:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=17xGCAOYPaXnnoQHmlg6SyfhhHnDFJ6cUvyz6KfIIP0=;
        b=eF11zDpKRC1Yu2ZXRcPakWUD+0UYARVg6eA9L5yhE/X5dumwKU0d7OgNqvaD/cWhAz
         BJ7q/vbXgr6qXM34iQk8fCdp/aExPssWUOnSeHeDOhNivF+F4daaFvbgGKWbdamdtN1p
         W4mNPzcZ0ZoHeZyTawNml7pV7uAiw064oFZJKIcp+h6mSv1Jfzibd7EF/u85D2kX0cOZ
         KzDHUlTcWgNgiIuPqA0bVNqOSNA31cd2Um74b4sURXmhBajuRztU6XS5CM04+CCYGEos
         2H2orPJkO0Um5fPT+Ow1rmpAKupyLxz6DPLhRwm8+jF/5+KG4z6lmyizbgo+o3fG+qGp
         Gq2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXidMpM01i712CrEXGzxiJhw0wzRQUkuM4XtNSaBnM9gGIHgM4XWfOO6K6nCsTrFugIn2FfWmuiV3gE@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv9k7CF/nz8ACaqIgQa8v4bI1tepxycxDgLEs6PiXcfpGq6VAG
	TPjN87+pRXNPFKw/Ah9baTgOfahxUZw5/eIkpHpNaNMa5aORz5iSIas=
X-Gm-Gg: ASbGncv24pLT3syVnzKG3iLwdWNPEYIl5OYGHf51HFBIhU+AHFWjGim9ROcOks+zFc4
	Y7YK3FnZ5hQhbMpNHf6UB9ystTkAUCHmgVdZPGn7Fo0DT4wRaE7nIDNtrdxqytzf6hySNpq3NJU
	Qwv8N8gAKIzgN9nbEac45swUIJU/3GDcVPkS48XvEjFhJB60BPpz9UTuxUxl2/gqBILKgBf5xK0
	l9xgdnU2Hx6wqyDfO/zR5u6qTrzTYWSPS8zGy81VckiBq9/sVLJkcu6dl6UxvzhnPGu5VS/RP+x
	OGB/EDQUKAJCOT501ACMjeIwOcgQC23ZZ+vrAFNDRfNSQ99bHa0o5J4Dq2179IAhRr6cD1dnOEh
	2yNYYQQtauQacHASU8ubu8KaaIdu766SJh3RhB+P+m5zB/T3CFmaS7QykWaNQ
X-Google-Smtp-Source: AGHT+IHd/4fzeAVJN3EXLt7ZlstRloPqKelylWmj3/Y+2tnuaQjwHYDO4ph7lm/aJohEgv2+8c04Dg==
X-Received: by 2002:a05:600c:8116:b0:43b:c825:6cde with SMTP id 5b1f17b1804b1-45a2314999amr19516375e9.3.1755364552681;
        Sat, 16 Aug 2025 10:15:52 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a22321a54sm61127145e9.18.2025.08.16.10.15.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 10:15:52 -0700 (PDT)
Message-ID: <7ccfba05-ec5a-4a42-a1ea-5254e7b7d97f@gmail.com>
Date: Sat, 16 Aug 2025 19:15:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] nvme-cli: nvmf-autoconnect: udev-rule: add a file for new
 arrays
Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
 Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
 Martin George <marting@netapp.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 Zou Ming <zouming.zouming@huawei.com>, Li Xiaokeng <lixiaokeng@huawei.com>,
 Randy Jennings <randyj@purestorage.com>, Thomas Song
 <tsong@purestorage.com>, Jyoti Rani <jrani@purestorage.com>,
 Brian Bunker <brian@purestorage.com>, Uday Shankar
 <ushankar@purestorage.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Marco Patalano <mpatalan@redhat.com>,
 "Ewan D. Milne" <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>,
 Simon Schricker <sschricker@suse.de>, Daniel Wagner <dwagner@suse.de>,
 Daniel Wagner <wagi@monom.org>, Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 NVME-ML <linux-nvme@lists.infradead.org>,
 SCSI-ML <linux-scsi@vger.kernel.org>
References: <20250815202133.51160-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
To: DM_DEVEL-ML <dm-devel@lists.linux.dev>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20250815202133.51160-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 10:21 PM, Xose Vazquez Perez wrote:

> And it is unnecessary to set ctrl_loss_tmo to -1 for NVMe/TCP devices,
> because it is the default.

Totally wrong. I misread the code:

$ grep NVMF_DEF_CTRL_LOSS_TMO drivers/nvme/host/fabrics.c
     int ctrl_loss_tmo = NVMF_DEF_CTRL_LOSS_TMO, key_id;

$ grep ^#define drivers/nvme/host/fabrics.h
#define _NVME_FABRICS_H 1
#define NVMF_MIN_QUEUE_SIZE     16
#define NVMF_MAX_QUEUE_SIZE     1024
#define NVMF_DEF_QUEUE_SIZE     128
#define NVMF_DEF_RECONNECT_DELAY        10
#define NVMF_DEF_CTRL_LOSS_TMO          600   <---
#define NVMF_DEF_FAIL_FAST_TMO          -1

It's 10 minutes.
