Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795858005;
	b=IMm1ORJxvdr3K0Pu24dYUKfAjz3Qy2Vital0j/ttfWFFeBsYcLBU1EcXYIcT+0qZaFfr
	 ps/LbKsLqHdFbpWp4Gn4RPtjJHjGb8Gdh8gXIwcV+jfrSv4YuraI0vJdUkj7mOqP60IJn
	 74JRW2gM9memKP6ne86g0neb8ZuqOPYZLxnZezLnlJcAo7/WoVMlIazg/DCX99V/k8VoD
	 PTt6jCu86oXxfwGxvFfWNb5b2fkaJz8G2DWJuko09lWr5dU+zTyDtZi/xjeygE9QT982K
	 anBxIPGYZqzJ9O3WPHieydy5/pMcDnOL7MzbbA5o2Jg+FcAkLK74maIz9G1TW0khxlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795858005;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=XePVpPEMY1kO0/i3l/MzHVEvZGt+qA4HbNIOln1umLw=;
	b=0BjkATAilkeXWruayuo2LNlWFxo1tt5yK2GrorpFO2asFDMnov6bBwwnzCi1dC8gI0Pv
	 vhV6pgpiR2Lr7bIST7J4qdwXgZIeYS+od7JXzPvQVASJdHlg86MCQQXYsmAp8KoHje5VC
	 tppYc+idXoRBtBMCAhdZeVtJsqbOw5WnOrea3/FVPfiTbJZEakztVfNjtqXkKnApB3inu
	 pLMyFFXsOeWgHwi2lknozuk55wnF6X7T9g6I2JWSdI7F/clwICDCEaDsU3/sLn//vkS0B
	 PKPl5guFL1YjQ5MEfg8urCT+IXjwxIttwXRFj2SRRsJLJ3AS0925PDpxpubDoj8y7iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=fnWZn8Jl;
	arc=none smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7313606A33D
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 09:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7313606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=fnWZn8Jl
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b595601695so12215777b3.3
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 01:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795858004; x=1796462804; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XePVpPEMY1kO0/i3l/MzHVEvZGt+qA4HbNIOln1umLw=;
        b=fnWZn8Jl4hDG3v5ER3vWgpdY7JkM78obS5xy8U2vgnCamKlefXD7OY0//4PbSnI/QN
         GPZ5wKFFFWoq0YwitfeRxHRRAlj0DFGhhC4cmXQ3lGhQ1HnDdgKINGfigTifYQluaCxI
         B6H9BzV9FoxfNr9MpzqkqP5qEQgH7hDQ6vkqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795858004; x=1796462804;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XePVpPEMY1kO0/i3l/MzHVEvZGt+qA4HbNIOln1umLw=;
        b=CP4tqNvFjGsR5OQM2kEmHMxyK5TTxKjJvOKg8CoA5+mEV/kzmFvgP+Hm8Sg0bVHQp3
         9AvW+JjMBbb6RCh8m48gItGIbYRnS0LQnvks6Ko2HJGTqxpXcLVZi2OUZ2zYJZQHBmcq
         RowOkuuxLWEtI30JRuHLL8QG9AY2sq2AvKLWsSZ8SQtRAHdR7GY2MaLbxI9PZj6HOV7w
         VrDxBRnh+3dVKxSg/73Wrxmzo2GSi3NfzhVqj2hq04JDQFaVPK5NttW6XHMEOTm3z0HV
         acW3urarYa6Y5j90FzmXZMGnef/5MzJ374i3Z+uH1QJ/8JQgdtr4OXIc8pKDu7pkNy7K
         gG+g==
X-Forwarded-Encrypted: i=1; AL+hErGSR81IW8uH2tqMIv1+bioAaGSFoFT7D2SLXAyJETgQJ4tjuIB9pQ9u09V4rD+vj0s95hjOTr3xu/XF@vger.kernel.org
X-Gm-Message-State: APuU4Z8TH0sFzNk0K7ZvB1BlURkUHwwb3tgtAoDVK0I+UNtpcx3ADhqp
	efz5A4gEYhu+a4dJCutp9+pUihrS0sBYw0AgHKyWugaTyeloPSgR2wsPzawXxXp4mt8=
X-Gm-Gg: AZFdTZdNl0ZoERcuCZHjBbU7Hf6LpmvFvnu0sOMHjSaVBxlG+o0nLKO+30Q35RjS2kw
	LibodbFqrQa9N4L8Wylx4JtO+om+bDOHDZpnNZxKbAgKPuq25+JJ8+8tv+6bSNffy/hF7CkhnMW
	n27tfV8tLYAHVfedTxmP862S0SexIxr9uXh/a/2lk8wH3d8tz+7k4KEWM3xDMzzHidp7lBtrm+j
	/iytYsMACcHA4l/YKfboOyh4RSXo1jbz8FWlBBcD3YgTBBl2SvAoTFaaPZBIsKGlCizobMy3bc0
	HSnrihgGTY7Il1npfXq4bCKLh0y/f/15z3fGhCYGxXLtnLMp4sY2CfOyt/2hmg/anK4tvTLLZ4T
	BWHIYQBgUiumcYwFvBKz1EMYlc5BHPS7h9es0iDU8a6dIk9MhTQ/f0RxSpIYoCF37uUYrq87Cmr
	sVch71yqdPuJp09hDuwK44JDxXJka7vghNiZUC9OXLxnNNwbP4KbQigOHbqaU7VizMNLvq/8VzB
	a/v68UAdbnBsAlKhwDljHocq9dATkKoXd2OrREpfTEGHn0rr4TY6qrtVpdhNU468X6hyBSPLsJk
	i8wxausgI1OE7K9rIN7BV/15xWhz2pOjXWk7OvOewFthGBp1r9v6dFuttmFJ+a1Nec1I5nZZyNC
	EK0JVB6Jnd6PZsYIZNg3IWk9Uu+QNmreTxzgdFJ75o7+u5G/NIIgPow3D6bom5hTx10UfmrC+cC
	FBvVjPkS3G6gCWfZ0JNhMvMjJG6nvHtNJTEZZYLgnW/mvaCu9lp7tYeEFnyv4HAH8KqmnDvWSrD
	68x/keLNguWsNv6fI1TZ3I=
X-Received: by 2002:a05:690c:6b82:b0:8b4:c1ef:ebba with SMTP id 00721157ae682-8b5204ebe21mr92952047b3.54.1795858004057;
        Sat, 28 Nov 2026 01:26:44 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b56fc6131fsm42801917b3.34.2026.11.28.01.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:26:42 -0800 (PST)
Date: Sat, 28 Nov 2026 01:26:41 -0800
From: Chris Down <chris@chrisdown.name>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] scsi: sd: Fix data corruption in WRITE SAME(10) write
	zeroes
In-Reply-To: <20261111164632.GB18355@lst.de>
References: <cover.1794069087.git.chris@chrisdown.name>
	<5cb23933fe87df3c342d9805a7fe8c2a1e08ff37.1794069087.git.chris@chrisdown.name>
	<20261111164632.GB18355@lst.de>
Message-ID: <awqeUXDLbKDiovWx@chrisdown.name>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christoph,

Christoph Hellwig writes:
>Shoudn't we simply refuse to use writesame_10_unmap for devices
>where 10-byte commands can't fit the entire capacity instead?

Yeah, that's simpler. I'll do that in v2, both when sd picks the mode
and when it's written to zeroing_mode in sysfs.

That only takes care of the LBA, though. sd_config_write_same() keeps a
write zeroes limit above 0xffff blocks if the device reports one, so
the count can still be truncated in writesame_10_unmap mode, even on a
small disk. I think we should still cap the limit in that mode, as
sd_config_discard() already does for the discard limit in writesame_10
mode. Does that sound ok?

Thanks!

Chris
