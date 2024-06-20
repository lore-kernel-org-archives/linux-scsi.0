Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057AE1B9AAA
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2024 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906949; cv=none; b=BQQ9teVKzPgz95yt/RUzEj0fLet48Q2yxHb34L6MTobRTdx58o7Y2q48yDCmIpL8yGjmqF+jbLMlD1J4TCUhpkBnlolvTFzxRL8XxLvvwH70tahsNVws3xjTsxuxVPor1/xAH5zlnmcrAc1TifuVIbHUO5H2AAQ5Zdhm7N9QFy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906949; c=relaxed/simple;
	bh=29OxgEL3l6wtk/wr9HSlAcydEGnms+qvS9bonjZCeq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AQd1o76uQ/waeCJ1dGSSZzDLJzc3py7Zzsn6bN39h6Ehrn0zP73p12RFgm04uL7ZOZH5CArDWJDOxrt+35FIo4B6EcK2BsBqG9LVzO9bUTHcE8LhtjWMvo2y9rByWaVc2BHMjNSwA+39F06hlO3CJIPKTlYVDtlaLHknLEE06yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EQd6i1rW; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EQd6i1rW"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a6cb130027aso72383466b.2
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2024 11:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1718906946; x=1719511746; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fuatl8An2r1cXJScFESolD1f90VPFvdc9a3mKIi/oro=;
        b=EQd6i1rW6SngkrksdtzeMVa3nitdWbN7E7ep56CjgCegKG+IQkw+9GAmhWS/pwC2Po
         d5NSrhFh2bwqA9cHCrvSeGmcoJsS0xKm59rqvmuEtfWsAvC7L78xdTajsSyK1gDhT5ju
         wcUewESMRB/UFJQ+ViC65iqUVpFwJjRCwL6Aw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906946; x=1719511746;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fuatl8An2r1cXJScFESolD1f90VPFvdc9a3mKIi/oro=;
        b=SCyjBrxmR5bWnx+331dQY/rzoNv/chn5L5ov0zZL/wM1rC7gWdrNG7Req+k2UAZ/fV
         5xbQ+pAXfcL8w/qprHfsUWJU7bZRgkKWlbkDIl5BT+IsV8hjhYL/4LXEG5ImArkkZybc
         VlxAvZSi4JcysAJWzxLfN2lm3m53pV2J0FOBAni2san0FxwZX5mHAy/TurSgBdhj56ng
         Psb7FPjXeT2P1omJ6dL0G5HvxnVtWVjgItlu2Hm6j1MjgkwdLnoY4vlRxvkiJ9AQmb5h
         NXhAede00ytwxW/f6Upx3jvLyXrbt+8UiveffXWdYGJien3gbe9xIk+jUFOziv+l/ANt
         AHUg==
X-Forwarded-Encrypted: i=1; AJvYcCVte5mm4UQgpbIxzRgx5qOUHYgefjh2tf7G+q0fZS83SmOeYSZYKd8vMqdlzzTr2bMQh19mIfNTh7cmMI6AeBytzn9CTn+bJomt9A==
X-Gm-Message-State: AOJu0YxWKV1Z81AihjI4QjUMC8g69XiR76mbsbFY0Fo5FGGPnu4ba9RM
	A+BgrKIcIAW1o0cS7HN052P7DaYsGynHq+s08zz0/4UmkCDUmIBzeL59w+NWimm8qoOyoE9xXUp
	20c5fxIyY
X-Google-Smtp-Source: AGHT+IG2pjw6d65jV5VE+5sJYZYYq3uhXXQuNMIGYO4nQPn9PwHWGZgW8C3FyR995x7ysKdAHoLIHw==
X-Received: by 2002:a50:9b54:0:b0:57a:4c22:b3 with SMTP id 4fb4d7f45d1cf-57d07e0d43dmr4374610a12.1.1718906946158;
        Thu, 20 Jun 2024 11:09:06 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d0e28ddb2sm2018261a12.90.2024.06.20.11.09.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 11:09:05 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-362bc731810so1152374f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2024 11:09:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV79sfiIXlOPucaOfqcN8+0iGHmUdEtl3HL+CsKrTHSsndXc0aAC+LYzYdvvSYutPfIb7KoNOjDIZBNps/Rx3+iWRN9PuvQqeuZiA==
X-Received: by 2002:a50:96cf:0:b0:57c:5874:4f5c with SMTP id
 4fb4d7f45d1cf-57d07ea857fmr5124279a12.32.1718906455555; Thu, 20 Jun 2024
 11:00:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620175703.605111-1-yury.norov@gmail.com>
In-Reply-To: <20240620175703.605111-1-yury.norov@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Jun 2024 11:00:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiUTXC452qbypG3jW6XCZGfc8d-iehSavxn5JkQ=sv0zA@mail.gmail.com>
Message-ID: <CAHk-=wiUTXC452qbypG3jW6XCZGfc8d-iehSavxn5JkQ=sv0zA@mail.gmail.com>
Subject: Re: [PATCH v4 00/40] lib/find: add atomic find_bit() primitives
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	"H. Peter Anvin" <hpa@zytor.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Andersson <andersson@kernel.org>, Borislav Petkov <bp@alien8.de>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Christian Brauner <brauner@kernel.org>, Damien Le Moal <damien.lemoal@opensource.wdc.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, David Disseldorp <ddiss@suse.de>, 
	Edward Cree <ecree.xilinx@gmail.com>, Eric Dumazet <edumazet@google.com>, 
	Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gregory Greenman <gregory.greenman@intel.com>, 
	Hans Verkuil <hverkuil@xs4all.nl>, Hans de Goede <hdegoede@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	Jaroslav Kysela <perex@perex.cz>, Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>, 
	Jiri Pirko <jiri@resnulli.us>, Jiri Slaby <jirislaby@kernel.org>, Kalle Valo <kvalo@kernel.org>, 
	Karsten Graul <kgraul@linux.ibm.com>, Karsten Keil <isdn@linux-pingi.de>, 
	Kees Cook <keescook@chromium.org>, Leon Romanovsky <leon@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Martin Habets <habetsm.xilinx@gmail.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Michal Simek <monstr@monstr.eu>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Neukum <oneukum@suse.com>, Paolo Abeni <pabeni@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ping-Ke Shih <pkshih@realtek.com>, Rich Felker <dalias@libc.org>, Rob Herring <robh@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shuai Xue <xueshuai@linux.alibaba.com>, Stanislaw Gruszka <stf_xl@wp.pl>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wenjia Zhang <wenjia@linux.ibm.com>, 
	Will Deacon <will@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	GR-QLogic-Storage-Upstream@marvell.com, alsa-devel@alsa-project.org, 
	ath10k@lists.infradead.org, dmaengine@vger.kernel.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-media@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-net-drivers@amd.com, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	mpi3mr-linuxdrv.pdl@broadcom.com, netdev@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, 
	Alexey Klimov <alexey.klimov@linaro.org>, Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Sergey Shtylyov <s.shtylyov@omp.ru>
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Jun 2024 at 10:57, Yury Norov <yury.norov@gmail.com> wrote:
>
>
> The typical lock-protected bit allocation may look like this:

If it looks like this, then nobody cares. Clearly the user in question
never actually cared about performance, and you SHOULD NOT then say
"let's optimize this that nobody cares about":.

Yury, I spend an inordinate amount of time just double-checking your
patches. I ended up having to basically undo one of them just days
ago.

New rule: before you send some optimization, you need to have NUMBERS.

Some kind of "look, this code is visible in profiles, so we actually care".

Because without numbers, I'm just not going to pull anything from you.
These insane inlines for things that don't matter need to stop.

And if they *DO* matter, you need to show that they matter.

               Linus
