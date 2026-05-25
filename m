Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1FE384CC9
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779715640; cv=none; b=mpojyjk7q/N8SgdcAWOPda/Nx8DBbtT392H6J/1G0Syy43V5nRHfSQqkztCoGv3ugcyqWs+jeKqK2248QXCssszRz6VDVEBCO63U9gC/XtuDw+bu7cNkIddBavkDcy8XHn+4FCYguctCWBEDOKcNnkaLqMhEYOOtjGRbhnlCzDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779715640; c=relaxed/simple;
	bh=C94U0R51pf0+NwK55ZN6EU/K9cssUS28krlgs1NAXvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V/g4uZt5TIhRfv7cxwTpqQKCKTb/ypVU1XGpGWhqINtKPyb9zM9VV2VfCBVrKcH/GYV+Q2UlGU9KZdhP5EbKs31vs0z3OxWSc6zU7Fgl5DsBnFvuMeu8dB7ORGIy5lI4kH97ecSpt/il6ivFnD2gCwQ8I9yNJk7P/OVAoQpRsAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aQ7LUXtW; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aQ7LUXtW"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso121365915e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 06:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779715637; x=1780320437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ij+l12dR+ISDUAaA9eJOw0SDQ47xwS4UQDqlRXMB76c=;
        b=aQ7LUXtW5bxOb+tWWbnJ9LI9Hu4ho2cWZv/3AUVlb7neykv3e+8w6/VBaL6Xr0dGge
         z1KK2LMTAA72OCAu5AxD12Qy5s1M0/sw9ULxv7vFq7+upKOnBYr2wRR1ZvodcmgkysM4
         sWabOR3Ubm2vqDtISC9F8a7yRMxFSNpxL+BvdxucPoZsLwmwpi+VqhZI8mUejTHqAsHt
         us9KcbeyES8MwfL9wN5iAnDDh83sw6VahdIZeophjTkDCT9NWqrub1WwEH9gCU2y0gYZ
         Rh2ajrWgiGd+BqSe3mipr5Mst8DS1o2/LF66I805h9zC41cP2I0l1MO9ZLDfwi8MxZFB
         EZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779715637; x=1780320437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ij+l12dR+ISDUAaA9eJOw0SDQ47xwS4UQDqlRXMB76c=;
        b=p4jxLvlG1JrHXiAdW4v5RrBQsK20ddwdzfcjtqu6syusNPco+fmLB31YPkgWPCy5RZ
         y+PY/gFCbawaEcLkn4P6xvZtmBTIb87v0jyQ/fo1lYW5TAZaWynZP0ROKmvaIgyemv+P
         ehsbH0/URWElACVv6KvcLblpmbLUgzSyW+C4fcREkU4VIZfZubhxZGh3akqwuttDL/a5
         gSwqMrFC8EUqJdWAfQuJhQZaQR4LApQx1eED/40Kmr6iuwHkqNDOW+WFooz0JHU96y7y
         rrQJ1OYJi/BWitPSXRvWCA70wG8IhwNjE/PBD3lE1ozzJMUP1NlZ52Ez0KkF5tj+U/Cf
         uySg==
X-Forwarded-Encrypted: i=1; AFNElJ8B7ZDy3TpqTudFAzq6PuDxStgM+AXDNOaPixIFg6R90k1ppY4J51E2VQtFYa/Ted8yMJh1Bm8RmyWq@vger.kernel.org
X-Gm-Message-State: AOJu0YwENWkOFh3GUdB30Xe6CrQpf0goK6xtITSXPNE0puN/wZ9PaFXf
	GOnUzh8H6arbfvKrAQfxzbCZqXzCcTNwkCN3EVBkji382Wdv1xuKSrPSrcJy5z86Hlg=
X-Gm-Gg: Acq92OHeABV7FGsugYwsvfnVOgDURM8pd7F84F8+MIwtkK4b4z3AdPA62IdgryEv8uW
	3UcGywSdmiuljV3yJt1GMKrQMPEDilCyp8I8xl8gYxHP5U9y+Yo55weuPfG2ciWuVDv4/C8BEr9
	a0Fzn+//bhIT/Y1r992XEYq4PC3K7HK9Q113WxVKN/cehfo+ZS/ejLFiixxCQjXKb+NRey+l6DY
	VKPNfhxuGqFVWATLtLzOTSpDC40VA7QLdrw0dBlY+vRx7EPAmqLATpo4FzNkqxz+16AcXuC1rXg
	3Jwh1f0iZt0XicjoxlWA8yXzGVKLy/uFyKg67IJmMKqJOROvZdXa6qXSCjCwysYu+9PCWDBAbxU
	KmaHSeQaqhLVFLcRUzUdWNi38/9HO8gYsdaNF3T09EMXGdgtlGqdUU5vTHX0ZRPtOP20FnHViyb
	fvdOCiP2UOCIDvuPIXoGnRg84ViPAVyH8ia/wHbdd3ZRtSp56QUEjPaSO6g+7xZMA/DLfwQ/lkw
	U2bV5p9IXf1p3/ZZOT/D47r2bsM/SOsVwwCXT1TesXBGT6PNw5sPLAsEHEHb4PkWBiLxg+2TqS5
	lKFk
X-Received: by 2002:a05:600c:3b02:b0:48f:e1ac:c94f with SMTP id 5b1f17b1804b1-490424b3938mr247672645e9.10.1779715636631;
        Mon, 25 May 2026 06:27:16 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454b1ab3sm284841905e9.14.2026.05.25.06.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 06:27:16 -0700 (PDT)
Message-ID: <1c21f66f-0d0f-4a8b-835b-23408242cff1@suse.com>
Date: Mon, 25 May 2026 15:27:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] moduleparam: Add DEFINE_KERNEL_PARAM_OPS macro
 family
To: Kees Cook <kees@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Pengpeng Hou
 <pengpeng@iscas.ac.cn>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Corey Minyard <corey@minyard.net>, Gabriel Somlo <somlo@cmu.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Bart Van Assche <bvanassche@acm.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Hans de Goede <hansg@kernel.org>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
 Lukasz Luba <lukasz.luba@arm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jiri Slaby <jirislaby@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
 Tiwei Bie <tiwei.btw@antgroup.com>, Benjamin Berg <benjamin.berg@intel.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 "David E. Box" <david.e.box@linux.intel.com>,
 "Maciej W. Rozycki" <macro@orcam.me.uk>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Vinod Koul <vkoul@kernel.org>,
 Frank Li <Frank.Li@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, John Johansen <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Georgia Garcia <georgia.garcia@canonical.com>, kvm@vger.kernel.org,
 dmaengine@vger.kernel.org, linux-modules@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, linux-um@lists.infradead.org,
 linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
 qemu-devel@nongnu.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-serial@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20260521133315.work.845-kees@kernel.org>
 <20260521133326.2465264-3-kees@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133326.2465264-3-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 3:33 PM, Kees Cook wrote:
> Add macros that define a struct kernel_param_ops initializer through a
> macro so the underlying field layout can evolve without touching every
> call site. Three variants cover the three cases:
> 
>  DEFINE_KERNEL_PARAM_OPS(name, set, get) // basic
>  DEFINE_KERNEL_PARAM_OPS_NOARG(name, set, get) // set KERNEL_PARAM_OPS_FL_NOARG
>  DEFINE_KERNEL_PARAM_OPS_FREE(name, set, get, free) // also set .free
> 
> Callers prefix their own visibility qualifiers, e.g.:
> 
>   static DEFINE_KERNEL_PARAM_OPS(my_ops, my_set, my_get);
> 
> Also update module_param_call() and STANDARD_PARAM_DEF() to use
> DEFINE_KERNEL_PARAM_OPS internally so the generated ops table will go
> through the same macro as everything else.
> 
> Subsequent commits convert all open-coded struct kernel_param_ops
> definitions to use these macros, in preparation for migrating to a
> seq_buf .get API.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  include/linux/moduleparam.h | 36 ++++++++++++++++++++++++++++++++++--
>  kernel/params.c             |  6 ++----
>  2 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 075f28585074..26bf45b36d02 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -68,6 +68,39 @@ struct kernel_param_ops {
>  	void (*free)(void *arg);
>  };
>  
> +/*
> + * Define a const struct kernel_param_ops initializer. Callers prefix with
> + * any required visibility qualifiers (typically "static"):
> + *
> + *   static DEFINE_KERNEL_PARAM_OPS(my_ops, my_set, my_get);
> + *
> + * Routing the @_set and @_get function pointers through the macro
> + * (rather than naming the struct fields at every call site) lets the
> + * field layout change in one place when callbacks are migrated to a
> + * new signature.
> + */

Nit: The newly introduced DEFINE_KERNEL_PARAM_OPS*() macros remain in
place at the end of the series after the migration is complete and this
comment is removed in patch 7. It would be helpful to describe in the
commit message why these macros are generally preferable to defining
kernel_param_ops instances directly.

I assume the motivation is that the structure is simple enough and using
macros then makes defining kernel_param_ops instances a bit more
concise. A minor disadvantage is that some analysis tools, such as
ctags, may no longer see the generated definition, but that is also the
case for DEFINE_MUTEX() and other similar macros.

-- 
Thanks,
Petr
