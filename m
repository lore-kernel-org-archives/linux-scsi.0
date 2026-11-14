Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686759;
	b=oKA54xbJINvwOfRNepu/yyiFnRTn2VpPdGmYBuSXww32nx1UpIg9ruLVPdQleDyb65ln
	 J7OQUOoiflgFDfvx0DP0tkZhbCkBXSvcf+3Tg8bawLC9om6s44YeCUIfxD8W2wEX1ykyu
	 Z9PhiDY4Cs2CE+9x/H/kTgBNmR0AOoeH4QTimTQOcPLlgO/fEzp8Qa9edskakysiSM0pg
	 dEkjuHYtHK5GGt4YRgKfmVqXkx8viJ5o5Gx8cbW83yJyftwYy0BuIij20VZ0gnORGKSNj
	 +TL/QLqYaNApe2hFTJTQMs7KWu6TUECZbT/u6gpJG8AAxl0K08wrcCEAmQKIYJFuNMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
	b=X5RSb9jjJF5QqXBYxw5Irdvw+BJCY/FglzuhtENzWqqaZF5hEejIb1rV8NcGnWjLPXvx
	 YHy6TMD8gFrMXcuB5aJNCtKZ4QvIXddvwVuRavaqq35tdq8+qanYpYb4zOXDXBJSYvD45
	 ivWdbgxP1cZ8jwZW4R5v3wwX8dFDS6Y5dBVrx3/FJI6hkcN3CtCaMt2h+dvW0gCp0L+vX
	 uShtl1c5j6gpimpQk+Oj4P34JKwcbCDxO5tawHTWBOD2RRs2Gt6OtxlBR5wWQS2RaL1WJ
	 kX8Xr+0Q4J+vzxDimO+OpeB5v67Xmfd3eCtW1usK8PV3tZhmd8uvG6GhuFHZwtX59eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=t4xxtvlP;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1F860A2605
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 20:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B1F860A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=t4xxtvlP
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso832548a12.3
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 12:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686758; x=1795291558; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=t4xxtvlP4RAICjpBIWPIkESb6EJJVOcRd9+LEytv251d1ZQsfD2pYblwETMOf/zroc
         BDzAo5elUgpAiRA0oYEfExHYSjjGywxztBxThvGs665InMbo4S8LytfXKr2B4Cw2IX6x
         hCl30XcWjOl3zGKKK0Vny1KN9lt2zjyLiPz3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686758; x=1795291558;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=Df5DJLMnWsiigkYV9RaCJo+LGsmvCDS7d7AY8eDPrPNtJYEkMsdXEQNzsqXMZwtydJ
         clApdjhes+Z2xkB34WAI7nHK2C1ygEYzX9DEMkYxSJXhkKcOc/iAdmaGlyILFFgxHR+w
         eUTJJu+vG2BTAPH3UXFen1ZFe5sUzpKyC7/CRqSIrQLlK25CSKw7ntAkQXcPa2IoZjJH
         03xV9tUtUje0czYUX5xYFysBQBCfs8cQzJg37ByqsW0QPiVb/Ox7CHsDuyIzvDh6l9jC
         2ATldVFSbT/nbe8F0lf+dO8DP8bLlW5LP0Y8bXaPgdrD0hVu7EeQkKLHibFG47TUgjZy
         tBBg==
X-Forwarded-Encrypted: i=1; AL+hErFG5zcJuJSqY1jb0yyTXbhLBcN+O2ECY5WWxO8G/CZdKdWC1uQv+BNHhj0pKC3pLl05neNDHLPdjrg2@vger.kernel.org
X-Gm-Message-State: APuU4Z/gDLc4y4ndSkU08fONLTLzFtLFR5GcUq7IPjcaXRyF9Q2bfPVx
	BkpBICiIF7EbGE5ucEq6SbP6kWdpIg837Y6pNjbkSZsSjqgm8DKX5P3gsEk8PrO0/lQ=
X-Gm-Gg: AYBFou0N+mdHbbyX8K3J6//WWVb2J+S6jVg5OUX0yCQe7P2xYv2wbIVsOlOzKJspk35
	OOH7Z3JugsNeVWYII3jbUd95GjNqyPhEqYnejZtisrTk34irnXZSSyx2zd/OktvtLlyydkGw67A
	tw438CMoA29Gw87Md7MoQy+PWM/KgGZwWNEtWdRgy/4K4d63ax/xk5ItIB2V7gG2li8aP+ryKo+
	6L8PnpeiE3VaUfZ9LvoDrdOSJ183MIai//pvEa+a96RPYzC5LqBfYTExFEURol5tKEYKCYHKNzl
	G2VsVddAztqtIg3g9jQYuMTBD0oeBzPcb0Mtz+oukDW1D4n0cQTa29wVe6LMFIMOTuba8QqoC0f
	GRAQq6ZCL9uQR+tZCH13iaLerr/0/Zdd/RHVoHm5uk9iMNcUmZ2cAT1waQI4mb4Y5nk/xPcjtrA
	PS4PklE/dUsZTh5RIFD1NBoEv7bORHKv/FHmVIUg+1+GxWWR10cp6yjFsrEAhC0GrxqF+a4+ljY
	ZMHm3YTi+T0S0mNmxelrE35yYejBXwIBTr5IamxWPsrAgniQmy9st0dIWvrd8FskRAdetdPYiWX
	AgqBZdhWtoagaRt806XHT88bLz6+9OV+KZ0TaNMDgAQcWahlb1SGFiXidZDCULO0mqOFOC4C+jd
	AG0aE79hxOVByXUKOZKkmtc1d5AuqxwhUKcx/iZxQ8MRPEKZh/X64uS9pZCIm6i0GM6EavnWjri
	hZYkyoiUrbrPfhw5HBCyYKwB4+uOrTYqicYDuKj4C7J8SjzCqMivMAhwC/
X-Received: by 2002:a17:90b:3b8a:b0:3b0:9f53:e8a8 with SMTP id 98e67ed59e1d1-3b1b0b5f2c1mr6192503a91.52.1794686758572;
        Sat, 14 Nov 2026 12:05:58 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b266d873sm4654869a91.1.2026.11.14.12.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:57 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:55 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
In-Reply-To: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Christian Brauner writes:
>AppArmor puts a .null device node into securityfs but only ever opens
>it via dentry_open() which doesn't care about SB_I_NODEV.

Not a big deal, but userspace can see that node too, as
/sys/kernel/security/apparmor/.null. Opening it by path works in current
kernels and fails with EACCES after this patch. Now, I don't know of
anything that does that, but selinuxfs gets SB_I_NODEV cleared again in
the next patch for the same kind of node, so I think we should do the
same thing here. If not, it would be good to have a line in the
changelog saying that opening it by path is meant to stop working.

Once that's fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
