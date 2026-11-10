Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794273637;
	b=qQF9smh1XGIdflZAHQFfmxYlTr+qTrbInkiisMSdzn+V1Vd0mxnAHogN4uVULGJ1lKCN
	 EDnEooX0U1YTmFP4IaobndMyVLzgSdMRD7lMuHJQQSXmVMg2kaOEbgtZiKxJSeM/LIS7L
	 IXrtmLa3gdgHiggJbldXSTUN1vrGWGrj/lYLmPnPlOnSzzuxyZxB6pL2/4J1YSQfTC9fJ
	 teD5bs2s96Fyw6LsjIYWSTn8zpt6mOi+0Mqfl9hCJk71gg+GGw2onprr/m2JzDCdkIp2a
	 mHZFTHssrYBEljhai+UVc7I/I063ejLD1goi6MkbTnLjoAH/SacIBFc80BBKIWfhIhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794273637;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
	b=ZHyzw4j/8k8wN0NGMCEK/QIe0JFsY8j+DYWTb4NcRBPoWJuF8qX8raypvZwFS7Omie0V
	 V7KTJNC0E3/gH1w0J78CkQbDFZX0AWKlMZIlwdv/LmPjIn90OM/o9QrgvPX17Bc9YfTpK
	 HBqRlCThU0MM+5rarcOdLSfWN6FTEwNXn2BeCXdSD2cHM2BWwleZL2P6cjZQZixA8Wxmo
	 OKlzQrJiqjRddU/dM0g7Lp901EzzwjeveOEoo1lDgweQd/swClmhUSelLl96sd153FhIW
	 6R53zj3tJ2UTU7wfqmSc62VUzjGSv4ewOS/KWy9+laqlylTnXS9BCGHXycwqeesDzNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=hcZPL2al;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3C1606A333
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 01:20:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB3C1606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=hcZPL2al
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b577addee9so2036747a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 17:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794273635; x=1794878435; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=hcZPL2alXf5NNTzoMJCI4/C3R9UHgONwDCN3X/odbKN1C7VBUSK5MBOfSsw0Dz4qAB
         gFl6FPqcKNhpdKxKjwJdDYxEDJFPNtCMBVtRg83hCZlpK1ZQDdOmNaUk8+gvKHt7nn4J
         RFtVQQNW5QuuGl1iCLkphFleuoM2N1/RX2I9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794273635; x=1794878435;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=iHpfISUDnJkViZkfe2impXHRv8L32To6XdIZuEhiRAvQZhGzaG3Q77KpP6MuJ8x0qv
         l7t8jaH1vqVsA0N7VHjtRw1yX9OpiI0KVKploT0AwltRSehA9XiW/+vYaKHY9PM0HAXz
         ukIrC0005OItHfFZuqCePT1S4CQS5ZJiGGrgO2ZUYXQvueBjTVaDFrfFBK0SaqUvO96g
         C2OpOWY9EfWk0vKSzod6jZK3wbOQbjlZUprF0ckjVy2tqSpE3EtK5+ZEXIMr/oHL4q9L
         kWfRqUR8rZtN3YnRUCgoyCHLKOJaB0RUYagdmIWVug/ZnaBOKUSslWY7j4I8TvNoFNaY
         FSJw==
X-Forwarded-Encrypted: i=1; AL+hErGqDUftxVQyAjhXXX3oPK3DQI2jlPEYvt92jFmT6SPkPmnz+5449iyOn2n9erXBqhExS4OZ4knxOZLg@vger.kernel.org
X-Gm-Message-State: APuU4Z95WuOJDRnNfCdlTMvr0+hqTUnqlKxaPAg6CsW8CDvkBQka1S+F
	Jeg7R40x4gu6g4/ymGazAuEl4gbVIMAkasBIJW5QN4nWr1RH06Aod/vma9/ujCoEZra6TmiRTpP
	cddv+0FaSUQ==
X-Gm-Gg: AYBFou1zkfz2/eOJuNJoGg92f4qaN4cjGGdJH4AxetS3szFV80qfBzbKSNoyyI8FE8O
	DhRtyfc04UKaon1fB5H0blSqWzTBHq4OLUzFekNLWx8kGTfAZZiaLiV3POX4QZVbKoUe81sQGRu
	zlYEK3MOq6jd5T0zdAMk89i8q/gYhf73zTRaOt5Rwn9LWBCigjf5l3b61CYKx4jGcUWYYuH/VQC
	UfvYHruJ3ZzHZZ99B6QT/fKp5Fi8+rnONQfX1jgcVkC2LRa9RH6X/lyh+Y5jb25l3LR1s17XHF5
	UvKxxOCNfUvdML6UH83eThK4pbyGo5yAcUyED8y9KhG4wNjSIYff0sT3YPTvFa0yqZlywBVD1zo
	bLswWNQ6TT10+p2GFVsCeS23/Fj5tpVIv0CERtP1Vg5HROrLycleaw5rJtqQilCz2rw32IPE+dY
	hAkmdqBo9LDvyBimPbB+7eo66iOHgi55wJNFRTi6cx/yjncWwt6+1O07aGsWHlUHoGa5SwEdU7C
	5wvYD+ry4tS0BjImiXAOeLbNY52U21xq/pPbSClbFGq9InF4MEi5IzDYJrbsrb6LYZw8qFLQOK+
	xzcFNUyt/oQezr4+RxKHllM+58x9CMMUh0/cJ4w1JcXguleOrT8XnMYD9DiL2tATJ6SmSTP5ReO
	yow==
X-Received: by 2002:aa7:d896:0:b0:6b7:2969:a2b4 with SMTP id 4fb4d7f45d1cf-6b756aeeca3mr634252a12.39.1794273635110;
        Mon, 09 Nov 2026 17:20:35 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7578d2508sm441329a12.14.2026.11.09.17.20.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 17:20:35 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so242308966b.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 17:20:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEkZB8m0EncJv1kWx60ZlKn04+1wURzaxv5wpYzwB3ZyTHYWcutbOvGKgA6WLfa9Yv3QDcqSYm9Vzsi@vger.kernel.org
X-Received: by 2002:a17:907:9451:b0:c41:1750:59a2 with SMTP id
 a640c23a62f3a-c50495dfbd5mr87253466b.12.1794273275844; Mon, 09 Nov 2026
 17:14:35 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
 <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
 <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner> <20261108185953.28054fb3@pumpkin>
 <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk> <20261109214558.0d9d5228@pumpkin>
In-Reply-To: <20261109214558.0d9d5228@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 17:14:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
X-Gm-Features: AclHuK-x8jcOOQUqd2amGoGEAKER9jIFGaeL4LxxWAd0cGV7dz_RR64PtDogpPU
Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
To: David Laight <david.laight.linux@gmail.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Christian Brauner <brauner@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Nov 2026 at 13:46, David Laight <david.laight.linux@gmail.com> wrote:
>
> Just that the cast would have to be:
>         u8 *foo = (u8 *)bar;
> where 'bar' is 'char *', and I don't think you need a cast there when
> char is unsigned.

.. and just to clarify: 'char' is always unsigned in the kernel on all
architectures since commit 3bc753c06dd0 ("kbuild: treat char as always
unsigned") back four years ago...

            Linus
