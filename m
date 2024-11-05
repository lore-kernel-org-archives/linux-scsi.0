Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893BE20ADD3;
	Tue,  5 Nov 2024 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835107; cv=none; b=VJvQOFCtbduaNtEhRu5e9gRY5G55Re9jL6fgguPGS7hUrOkQrociY0YZBsHzsJK60MnKXgq9w12fQjA/sEaIFdh5om/2YHj+vwasmU0zq1XTKuKUia78pRjqJ4iGlWR/dunEHLmVH69F5eZRpdwOtb82mKXRbl8FHPu0D/nVv+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835107; c=relaxed/simple;
	bh=+wo5a89XCfR+vllQwUd68ocwBNi2wyOV4mF7KfCALrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sRLzzdvYdNZeNJUdqxDU/7vZVHey6ux/4gITKtSa3ZxFcWih/WM5qScxz7VCOO/Iu3Sg8FwLX9a3npYrrC5IuA0cZMGf1n7e/7gx53wh2ww7tP1QMKMfAZMt6VGrjznGTHB0/55MO31/SGHfnI3/TbfOBuUQEP6WRNbvfiW1waY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SdsDQ8Bo; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SdsDQ8Bo"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6e3c3da5bcdso53897317b3.2;
        Tue, 05 Nov 2024 11:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730835105; x=1731439905; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qx81oG6eFhFtkvLBZexdKBfFzUiItaWVe7s7qCD1UIs=;
        b=SdsDQ8BofYbJIASHfrZQFTkL8eZbBNyxMSTUwnF1QerX6nIB/xwJZNOu9oqoS6dPRj
         FW9WQceVU/ojB1X37ygqaLQ+zl5DcKdgXn4UUGRDg7GkdXzr8bvCJTdWqtNsUP5eHKP+
         YIg7nsq0XMYJ0ptzgVS1WqRfgpUt9BNAK2VWHifLdUS98ICCwIcFI/rwkRy6IYZDBTjD
         DUXJbd3BD4oU6xjjcfKHn4Pdix4bsNclbXhJX6KrQiqWGGrF+P70TVl/OOFSN4oxH5OR
         QtJaSWrTyjAcYdZX+crzsZ9dvPFwFYkTOXZEV7AstkHN1lVC+EQqhD2pBwfY/LeTmT3h
         4YFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835105; x=1731439905;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qx81oG6eFhFtkvLBZexdKBfFzUiItaWVe7s7qCD1UIs=;
        b=mLH+QnQ4vaNd1Ltjpp4ica5eOPmL0ZAO/rrAvM46NJJA8A9QV4Asm3axdDfNRZSgC3
         mrDcRSFBRx/nIQ1XOIhWK+xdTO2cv/jm3NgcAVRkX5xD/qWzb+O1JQ7YAyWReXmlaJ9R
         NMNQwSxVpYLFIRSFGNauLk6OUz4vZY9pt4hasN43aQAb3ohPlYhyx9wxfPtwLuzaSXZS
         ZxPnde/T+xV3cP47CNtkUR58D/91fbk7M989lBRNnW8najjDJNX5zxxbzjKz4KxfSct6
         w57FbyrfF/ncgJV6Y2GEU9tcYGCgzfKoN9AYjxMLPnOhJxRrZeU32XuxVFsJeVZdyNWv
         bL8w==
X-Forwarded-Encrypted: i=1; AJvYcCUFZ2es+7NypLgQ9o3oqTZy7fsAl152lK9t0LjUMjlZPUftloeSqcygb7JhpJRbXc4ukl3W5KTDrFor4Q==@vger.kernel.org, AJvYcCUNdMCasNIiZ2+IGi6Aqi4/s8L6WdlGg784QLA1kHojhgmwd4PvzNwj/bBENqHt2DmOq5qqG2gv@vger.kernel.org, AJvYcCVpPYEywwak+5SaGEYtlNnxmOlf9nqwCVzMCU/gEHPcAO+Iul96YW/HvY0OiKvyLTdpuCwdapK9F6cLJ1A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7bSVRvAu80YSo3Vvqgyug22H4H6T8wv6uxkShvdAFqFWesleO
	w5zvTSoriEQTiB6W1llXEc4FstosU23GdEzWHrbt75VnzcJ0Qz8w1wCNvr0yDc97yVsAJFIBQQP
	psIJCVKXwISq3TjmBCC7+OOMst4w=
X-Google-Smtp-Source: AGHT+IHNxvK4el4AFjKkLHz4BPVUM4q40Bp+gu7JB/Ln2PRph4hXov1iTlfbIRpUX91XvZipJoIPoVqLssAXyosYFJI=
X-Received: by 2002:a05:690c:2fca:b0:6e2:7dd:af66 with SMTP id
 00721157ae682-6ea3b8afecdmr182459867b3.19.1730835105542; Tue, 05 Nov 2024
 11:31:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105130902.4603-1-chenqiuji666@gmail.com>
In-Reply-To: <20241105130902.4603-1-chenqiuji666@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 5 Nov 2024 11:31:39 -0800
Message-ID: <CABPRKS_f1LvugQo2Hzs9q-ycAE5NyF6JxH4jS=UbyQqbhwt15A@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix improper handling of refcount in lpfc_bsg_hba_get_event()
To: Qiu-ji Chen <chenqiuji666@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, james.smart@broadcom.com, 
	dick.kennedy@broadcom.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Qiu-ji,

Similar to the other suggested patch, this does not look logically
correct.  if (evt_dat == NULL) evaluates to true, then that means the
list_for_each_entry_safe(evt, evt_next, &phba->ct_ev_waiters, node)
loop did not find an evt lpfc_bsg_event object of interest or that the
phba->ct_ev_waiters list is empty.

Why would this patch want to call lpfc_bsg_event_unref on an evt
object that is not of specified interest indicated by the bsg
event_req object?

Even worse, as mentioned in the other email, this patch could kref_put
on the phba->ct_ev_waiters head which is not a preallocated
lpfc_bsg_event object leading to references on an uninitialized memory
region.

Sorry, but I cannot acknowledge this patch as well.

Regards,
Justin
