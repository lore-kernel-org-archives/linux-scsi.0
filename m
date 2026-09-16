Received: from mail-ua2-f12.google.com (mail-ua2-f12.google.com [74.125.226.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098204D37BE
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.226.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595085; cv=pass; b=GXbRi270UdCxNgx5yUPCdnSsSn8MSZ33XPMoeLzOT8DrPIhs0B0u5XcaS6i/++sCj4Slb0DMHDrSaK4BLA8iT3k87lNmeCmLNKbljC/PjCoVijF3YbB2ZifUzC8X/it7O0L+995qY6QnTKK8DANltS+rbF4FyWF5rXnoeHNI3gE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595085; c=relaxed/simple;
	bh=+TMWi8xF1c/GpLGSJWBDMGttEHh102/5Ofx0+5TAWdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WaFNBMQACW+gu6Lqcm/mSeRdFukLxj259aJ4mvqpQAqLzGsKb5ngdFdtGQcojcFFr7eJAovLckj22v8ypDaPXuM7yKlki3bzmMdclFHnwt+lexJPWMN+wF3ZILk+Ce92JX8zdAg4I6SMbyzOuPlzZEOgyX9Qnl8+mp1yjMkd0gA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PhRvxyDc; arc=pass smtp.client-ip=74.125.226.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PhRvxyDc"
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-97e80579b7dso49677241.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 14:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789595057; cv=none;
        d=google.com; s=arc-20260327;
        b=AKJqV3g5iHp4nkQsfgFY4C+Z/fOn4o0M6mLDyrKiy/HbmRYGtpUeHXEzXLwyspyqpU
         Go9hq+/gNFUM1293C2GC/1xU6rHng17Q8YZmFEHwbpMFHSn49Ya3QBI2jubwAHV7X94b
         pxXtAGTj/1S88ucJLlNxLfbR5L1Na3aLe18ij/KA0LdisC+3Wbwcij06lZB2tFOHKGrB
         zFca2BKPkFLVwbKNrSabfssMwWtBf7ItxjSD9QiuAJbiXqV1akADuIpjIySkcxJ5O48Z
         1lZSSXoQjIyMBUKId+xmr9WexUJkwV3AreVMnFEoojXqDUScSKXi+uhi2SLo5H+lbAyu
         Gklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+TMWi8xF1c/GpLGSJWBDMGttEHh102/5Ofx0+5TAWdU=;
        fh=d2YQFy7QJBlAWgiZgOhyXB9umHHpxTMqrDJBsiJWqRI=;
        b=gWXJFP1EGi4FAngtra+7c0Df4EYJHtB8kpGPugQWAT3UQMijKN6R0HuJxQpF3hiGdY
         +3y7x7EGUb4CUIU70XbZzv6HNBNWB4pGkJ2kf89JG9rU4BkioRP/8QMqvSOnGehk6kLA
         2hfGkufCGlJZeCO+B921ViM9jgn5l505bR5g7n8hJOZi65IRRrza4/7pGNB6tlQMSHvm
         fGOQLyJGPgY6wfxecsJB/JWuTD7GACLU1zbYOssfK8SOBnxQsbOvMWjSUV9OBdV2X4FA
         31Pz//qEfUrD/BKPlqQAHui9YZwRLQgezmiT8nuQTu2zmBXUx8n5ZiTnvMC/wf0qws0t
         QSag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789595057; x=1790199857; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+TMWi8xF1c/GpLGSJWBDMGttEHh102/5Ofx0+5TAWdU=;
        b=PhRvxyDcEKpo82rz7bjO1wDQ8uBdzgmqFw/6qMLJ6ysl579NXOSm57qPRzt39pD3oV
         RQb6cdMJNN/Ek0B5W2zGNfO0RqIoSKMqtIpUc7eAhIfyNHQGufGBDtCJwInLu+pX9hxn
         J9cpThCkU1tmfCxsOJRLdZFf8wYm3kRlo/yoPwYzsu2PbhjQqcSKR20KyEdhLP8618yJ
         5CmZfZeIm2+Na8mFl/ktZ3dXA1iPW6HhEYtD+ujAGpNgWXor7U3Ki4cMIqiM6LMBSHL9
         ktggN+6MCwK15bvCxc3iBeUikkFZwpbRMOG0Pyt60U5y0YJFcb8fm4EhJ+LQPrX9SbDv
         Tdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789595057; x=1790199857;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+TMWi8xF1c/GpLGSJWBDMGttEHh102/5Ofx0+5TAWdU=;
        b=GntdU/6dYoSt6UdCmuw3e1SnxvDL8oTGoaHTeNvhVnsxJ8mvBLKTa/8hSUaMd1jCoG
         QYzrTZ1XSX5HWJclI0Isa300DDAHosE/DcX2emeHzTh3mS3DWIpMwSNCqzRhr8omeLE5
         M90JLXNZs/qhRH2KGbgtVrQCsvdMq02kLzMxw4KwsxZMIlZyiz7R6zw+OkqZbd+Z5TMM
         ny7vTrchTFvLNL9gQwln8/p9vTLpLRGB75WOSHF0ZumXe3HdyRqjjJX1yQnY0q2PS1+5
         zwbR70jbLHhrUYSu5WcYW7ljVYK+249J7Bpeqi0CSXdzVSsWsK7jZj3BR5O4C4udiDNQ
         4SeA==
X-Forwarded-Encrypted: i=1; AKwUvByf/epf3t4aZI+Kurul5DP/5T6u2R6dEXtUE+5xybk3ORRLU5iEI2IlZttm25XTJqROsquz8G44D8TQ@vger.kernel.org
X-Gm-Message-State: AFuF++lzv8KqWEwMBqrzZWTp6cGUEax33EH6R1YCSSIg8iLWQzuPw31X
	F0ikvJhza0XS0QuGqfxDg3xCdj64ABO7TbSWsTYxhq7Zs+DW4ksQY8UFs5cm7aSYgCHBbKMsJxP
	xzmMOpi6myc5wP0ZA594Yvq9R8Mxw4ZLfVRsgGNo=
X-Gm-Gg: AYBFou1rKWuygO/cLkQxHppkMXXCt/cuHQi3y4cTAzY962FPW7vcwDZzXPpxzZ/MzM/
	vHMZdTdT+QmIVtsabmK8Nr+Sp2OIeIK8Z4cPRlOpTrCzHCmhoSpVl6u8vtpLQvK7yUl31OTs0Ea
	URSizxCco+AmYmg3ycAl44xCwCFvCTPZmHP3lpNrjJPrg37WrD9dU4/qmHGwydUa0Akl8EZ5uUJ
	aSeLi+waiEVBDZQjhJF+5l+Iu9sked9fElMnoR/kbc0NxVvCcS650R4BC5kDW+Htmc43vLWQEhk
	xOB72v2T+LNdmYQtIgN87+ZyAZDVHOB1OGJd2z7o66WyipuWHCjcmsMLF7CiiuJkl9u0DAMrN5D
	CSk1/J59M0A2ywmVx/ncx
X-Received: by 2002:a05:6102:a85:b0:7a2:2a6b:e7b4 with SMTP id
 ada2fe7eead31-7a22a6be8efmr62586137.2.1789595055938; Wed, 16 Sep 2026
 14:44:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915081910.4142719-1-morbo@google.com> <20260915081910.4142719-26-morbo@google.com>
 <202609151258.5FC01072@keescook> <20260916010945.GEaqnsWSZ-DTMyTO25@fat_crate.local>
In-Reply-To: <20260916010945.GEaqnsWSZ-DTMyTO25@fat_crate.local>
From: Bill Wendling <morbo@google.com>
Date: Wed, 16 Sep 2026 14:43:59 -0700
X-Gm-Features: AcwNN1XbboPOY3deKY79Gty15vkSErYIT9HTgeQdVXaDzFhBvm8_kiOA449bIqU
Message-ID: <CAGG=3QVZRCJ94+DOfSsSDhsrXVYf-ec01NZBy299nYiCAYfXKg@mail.gmail.com>
Subject: Re: [PATCH 25/28] EDAC/thunderx: Replace strlcat() with seq_buf
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	codemender-patching+linux@google.com, Russell King <linux@armlinux.org.uk>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Tony Luck <tony.luck@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Matthew Brost <matthew.brost@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Matthias Schwarzott <zzam@gentoo.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, Rob Herring <robh@kernel.org>, 
	Saravana Kannan <saravanak@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Sylwester Nawrocki <s.nawrocki@samsung.com>, Peter Griffin <peter.griffin@linaro.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Linus Walleij <linusw@kernel.org>, 
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>, 
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, Jiri Pirko <jiri@resnulli.us>, 
	Simon Horman <horms@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Kanglong Wang <wangkanglong@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Qiang Ma <maqianga@uniontech.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Pengpeng Hou <pengpeng@iscas.ac.cn>, Ard Biesheuvel <ardb@kernel.org>, Breno Leitao <leitao@debian.org>, 
	Thorsten Blum <blum@kernel.org>, Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Lyude Paul <lyude@redhat.com>, 
	Ashutosh Desai <ashutoshdesai993@gmail.com>, Imre Deak <imre.deak@intel.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Johan Hovold <johan@kernel.org>, 
	Johannes Berg <johannes.berg@intel.com>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	Alexander Stein <alexander.stein@ew.tq-group.com>, 
	Cryolitia PukNgae <cryolitia@uniontech.com>, Jiaming Zhang <r772577952@gmail.com>, 
	Will Porter <mrwillporter@gmail.com>, Cen Zhang <zzzccc427@gmail.com>, 
	=?UTF-8?Q?C=C3=A1ssio_Gabriel?= <cassiogabrielcontato@gmail.com>, 
	Rong Zhang <i@rong.moe>, Arun Raghavan <arunr@valvesoftware.com>, 
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-edac@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-input@vger.kernel.org, 
	linux-media@vger.kernel.org, intel-wired-lan@lists.osuosl.org, 
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nfs@vger.kernel.org, devel@lists.orangefs.org, 
	linux-hardening@vger.kernel.org, linux-sound@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 6:11=E2=80=AFPM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Tue, Sep 15, 2026 at 01:00:00PM -0700, Kees Cook wrote:
> > Seems like seq_buf would be better her? But yes, at the very least, thi=
s
> > needs to be scnprintf, not snprintf (or add the checks as you have
> > here).
> >
> > The rest of the seq_buf conversions look right.
>
> This driver has been an orphan for a while now (we just made it official)=
 so
> I'd prefer it if we don't do anything here.
>
I'll remove those changes from future emails.

> And yes, that mega CC list is just gross.
>
Apologies. :-(

-bw
