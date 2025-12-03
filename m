Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5C82135CE
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 22:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764800568; cv=none; b=rluBaHAeKzFT73/8m/32ShXqaCe4Gk5MFLn2Jq+26YhG7yjBC0nOyoAfJCh0UxNFSbOsyQ62lZuZX3oBl1Ax/udfAu+F5gNZY8/78yLGbxkqhezRWWAgSBM7MKIFjfAmuOU07FQW8KtbjP9JMniTfGISRJwEx6eLSnOe48t4Jbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764800568; c=relaxed/simple;
	bh=HE4FZBgYIZ+9Tsj7eFop4e6TlxwWru53xK0cTvC3QlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gsGABHHQ6tBX05g8GTWGr5LrmxZ/tR2DVZlx3kEeEoZxhOD7jO/uAHK3rmJTNmNE2VZzv/cit+nVgt6IZ32eBvP/eiiurddk/rIVXeLB8HSJhXKrZ2d7X3H5HnCruBd7UpdXCfVV3cOgwee3G3kTRkkyboLkKQLrBsT+CIDGt6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CByZCxg2; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CByZCxg2"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29568d93e87so2750935ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 14:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764800566; x=1765405366; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1R9xr0EcCpg3ULu8d2Ax5yxCivkX6UBaNBeuL6LYDqs=;
        b=CByZCxg2j+mo9TV26utsifxiaJ57787VbLbArMUUaeOP0MOm72wECV1Uah/08S3avm
         rHo0MXrC4jfzZaZlQwwryzsnGLVvLCbqv8Fh4AoX22z9JPswadGGENzDZXvAySs/rRt4
         HebLuvn3QzVMX7IwNjoWVJ0VN3u0YxVGic1HfS146mEZ6iedmBqd+13NGFDvS9/PkXJ4
         CGBzU4tQ9PyDj/OQaoIwtaewYW+NCrfLHhVAZuWa11y3SF9Hz1vcK6rwMwscS5bIUfLx
         B5ei2ayZQNkRDSyj7VRJ3FworcrhVUmPHViQCgXBJzhEL1bMRMMl16BofIvXPstLwuiG
         k6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764800566; x=1765405366;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1R9xr0EcCpg3ULu8d2Ax5yxCivkX6UBaNBeuL6LYDqs=;
        b=nybbaXZzgxwipxopvjKn6HmwvILhefrdh7kUNj5Hlb1gB6m5pJqJGrNpDUnNstbST2
         26mjEmzuh9iXDHisW+2NzPKvqh15QdvBwGr7mSk6AUNTNgudZQGtldeV7C2q6hnNBdG9
         aLeePJrbByseAWzb+c3YYnreiBUYujwd+NBcPy+B9uqDYhAH9AD0r5kK1YQn/7/8dIyf
         8mMyX+0D8Oofi4SkAG+MZV1Pvx95hfH23087HG3PXgSNkbXX9dE5QpEaPZ1LxMg1XJWb
         n5saaq+0NocgfVp0jo/ziwcBAqPuk5YVN7PynVj6oh1L0ElIsRrSjSk1SPcbtQWfrnoo
         Fi7g==
X-Gm-Message-State: AOJu0Yy7dNC2KdWZbEJVEx41tER07OKQNvyt471p6qdgCqNnfJoIL3oZ
	UXD4+Jzh5eoZM9VNFx/ahgDnwVhCjeu0gB+QnSpfb2Y4zAOv8KOYeOF9
X-Gm-Gg: ASbGncvgvAFEdKexd+XTS7IH+hQjOnAhEFfQyA59D47aynxfu4I1r5fi7ZgZJq4sP7z
	bPZuQKr7HoURJb4l3+ttvjoBSVguPgj+GYSasqolnrXiXkt9+r/3YSjgLJOMO8q08jy9puH/7pq
	cxmiZ/3iIhNtsYVySwnSXTs2pKAFoi0PW6Al4QyWyg1dfMeIa+IH8JIT90s79xSgrHdraHF9d2V
	zs6H48f4tQD9MdBlJq/xiISSwoPJe39sAxws1aXrbs1OsUMns0VeEnM8SxHi0LCn3MHs/fELcDa
	FQKsvlH5UGSkl2nnNC/n8u8SGY/4adK6vP/diuG7piR0upQ4Aoyx1xAgYiGSrOd+ODXEOhigFmK
	TllYFbfrJxhC+xnqZ/m9X1pMogj8U+06bP9GEe2IJrK4XWk59ni6MHPhYt3N30P2ujzvMBtFz6Z
	yIrQvWaFRwvQXJ0GmxY+2iyn8=
X-Google-Smtp-Source: AGHT+IHJC76nQfGfOxkaTCNB5SpMy8YzX6Y6dpw2clfguLJsINNYueKCnLRH21FsGd2sm+JBAga7fg==
X-Received: by 2002:a17:903:11cf:b0:295:9c48:96c0 with SMTP id d9443c01a7336-29d9f67cab3mr8457855ad.5.1764800565934;
        Wed, 03 Dec 2025 14:22:45 -0800 (PST)
Received: from [192.168.1.43] (c-24-5-244-16.hsd1.ca.comcast.net. [24.5.244.16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb28019sm198839755ad.58.2025.12.03.14.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 14:22:45 -0800 (PST)
Message-ID: <4f21bb3b-4cb2-4911-b9d9-ee149ff1a921@gmail.com>
Date: Wed, 3 Dec 2025 14:22:44 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] qla2xxx: Misc feature and bug fixes
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
 jmeneghi@redhat.com
References: <20251202060355.1713302-1-njavali@marvell.com>
Content-Language: en-US
From: Himanshu Madhani <hmadhani2024@gmail.com>
In-Reply-To: <20251202060355.1713302-1-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/25 10:03 PM, Nilesh Javali wrote:
> Hello Martin,
> 
> Please apply the qla2xxx driver load flash FW mailbox support
> along with miscellaneous bug fixes to the scsi tree at your
> earliest convenience.
> 
> Thanks,
> Nilesh
> 
> Anil Gurumurthy (5):
>    qla2xxx: Delay module unload while fabric scan in progress
>    qla2xxx: free sp in error path to fix system crash
>    qla2xxx: validate sp before freeing associated memory
>    qla2xxx: Query FW again before proceeding with login
>    qla2xxx: fix bsg_done causing double free
> 
> Himanshu Madhani (1):
>    qla2xxx: Add Speed in SFP print information
> 
> Manish Rangankar (4):
>    qla2xxx: Add support for 64G SFP speed
>    qla2xxx: Add load flash firmware mailbox support for 28xxx
>    qla2xxx: Validate MCU signature before executing MBC 03h
>    qla2xxx: Add bsg interface to support firmware img validation
> 
> Nilesh Javali (1):
>    qla2xxx: Update version to 10.02.10.100-k
> 
> Shreyas Deodhar (1):
>    qla2xxx: Allow recovery for tape devices
> 
>   drivers/scsi/qla2xxx/qla_bsg.c     | 147 ++++++++++++++++--
>   drivers/scsi/qla2xxx/qla_bsg.h     |  12 ++
>   drivers/scsi/qla2xxx/qla_def.h     |  30 +++-
>   drivers/scsi/qla2xxx/qla_gbl.h     |   5 +
>   drivers/scsi/qla2xxx/qla_gs.c      |  41 +++--
>   drivers/scsi/qla2xxx/qla_init.c    | 232 +++++++++++++++++++++++++++--
>   drivers/scsi/qla2xxx/qla_isr.c     |  19 ++-
>   drivers/scsi/qla2xxx/qla_mbx.c     |  88 +++++++++++
>   drivers/scsi/qla2xxx/qla_nx.h      |   1 +
>   drivers/scsi/qla2xxx/qla_os.c      |   5 +-
>   drivers/scsi/qla2xxx/qla_sup.c     |  29 ++++
>   drivers/scsi/qla2xxx/qla_version.h |   8 +-
>   12 files changed, 560 insertions(+), 57 deletions(-)
> 
> 
> base-commit: e6965188f84a7883e6a0d3448e86b0cf29b24dfc

Code changes look good.

Once you fix the build failure. You can add

Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>

---
Himanshu Madhani
