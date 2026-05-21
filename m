Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B9784039
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2026 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371108; cv=none; b=ciJKP4bbbH2IBpPX5CJ/4p5NiL25U9Ul5cKOU/VQmaOV/orbeeGKmbca4wleh02IFkBYf548YtzJk2ATtCHddErsvG7QA7tlfyo47QVsjcw+2u12QdIwlLgsHxumiMofHnOu7JNTUB8AY5oXaXCC9HmbwWkSbari3Qogu6s/dDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371108; c=relaxed/simple;
	bh=JmKBkku/kD8/n/a4gtEJvwwFH5TVoQOZ+eRQ7DUmO1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kjkxgyVJUAjdrE0A1GNfqZm3qJak4kUH5/m2EN/mlmKEvBO49Xrf/DBWLOd5krT/uY1XMZ1x12OrL6rkFE9kZcH4hPneSk9/U8ytxqSp3+gE8wNXVRmCQTwW4YFTLrSl1U+O6TZIUSPcTEVazGKd+O8efhBKg145UZ1y0QIBql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=apmH1Wyg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="apmH1Wyg"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c829586e894so3199295a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2026 06:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779371106; x=1779975906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dnh9Qdh/Ek2SFmUD3YQQhAJ1lm8lFb5yTi3rkZyIV7s=;
        b=apmH1WyggEos+GYDtmCU6UwvksL1feePBYzSOJ5L95TUjl2IgzIkjsOrlBLhWHn0iK
         0z2UmkKdCTPjIUcJve/SIkIWmc7pd+VdH0jdGlEuQDhSfgRzBXMZl5NMdSsh1g9HmTxu
         nFvuyqPWF9Ya78KJOvIt2VrnPlMzsG2nOuDKsE21diyTstnyCAiW+s5tm7w9z/oIw5DU
         VCZclbGcsvk/fXeq5y9QTq6c+JWo5LZk3+btZNdmusOZU9KeC1tu04gbqiYdj54MBYG+
         ONoLJtIbthd7xCi1A05VbpcJvT4SAp3a2C4Vrib6lmo3pyVIldCWzX9paUqSZahU68s+
         Mnbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371106; x=1779975906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dnh9Qdh/Ek2SFmUD3YQQhAJ1lm8lFb5yTi3rkZyIV7s=;
        b=ozBXAt5pBboithn1GOL3x1Rsh2W/Gc6YuLRK5rLMd+BLsLSeeI+OsKSn4QzXygwgPR
         BQKrGzTJKWCWpr7FJMQZ7TGhyfguH9a0i+Soo7gwrdSklNInUP8w3B4GOqWVHAIDE9de
         t6sBjjuHjv3DqOLMwyPtzMzUDac+YmTZpo/vh+GkB0ZLfRdHKJVpZnYxpxqVXMvWSnW0
         WZZ0kSzWkaeQJRTuvSAiwWywpt8gHDFpuWhjkStfucFODHhyk0wsejlTp/RkTK5OkrT9
         tbdpUndjYy81wQ+KXE9HrpxvLB6jmu+VP4LzglsMWLjfBA0e/SZg6ujsle6DTJZLA712
         hlOA==
X-Forwarded-Encrypted: i=1; AFNElJ8w4K+xLeyn4gMuPhgjgqaJNXW9VKwjy5dP3oHXzslnEg9jXYgtIdOpAuGV4au8L+Mtzbq504TXTokz@vger.kernel.org
X-Gm-Message-State: AOJu0YxA3YsjafRNc6BVqBkfR/rXZa7xcm0IMxlbHc1ePBQIJxqL8gUb
	hgruXDclkIDDCG1c77drknbIClG/TzN8IjejLFBlYSVDeuzezoIIuTZLWjmBVeQX9g9of0Tm+cC
	I5UXWxg==
X-Received: from pgvm13.prod.google.com ([2002:a65:62cd:0:b0:c85:1159:ffbd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7491:b0:3a0:bc61:62e5
 with SMTP id adf61e73a8af0-3b30883a17bmr3700528637.44.1779371104725; Thu, 21
 May 2026 06:45:04 -0700 (PDT)
Date: Thu, 21 May 2026 06:45:04 -0700
In-Reply-To: <20260521133326.2465264-9-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260521133315.work.845-kees@kernel.org> <20260521133326.2465264-9-kees@kernel.org>
Message-ID: <ag8MYC6pOZvvYHMp@google.com>
Subject: Re: [PATCH 09/11] treewide: Convert custom kernel_param_ops .get
 callbacks to seq_buf via cocci
From: Sean Christopherson <seanjc@google.com>
To: Kees Cook <kees@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Pengpeng Hou <pengpeng@iscas.ac.cn>, 
	Petr Pavlu <petr.pavlu@suse.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, Corey Minyard <corey@minyard.net>, 
	Gabriel Somlo <somlo@cmu.edu>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Hans de Goede <hansg@kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Alan Stern <stern@rowland.harvard.edu>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"Eugenio =?utf-8?B?UMOpcmV6?=" <eperezma@redhat.com>, Jason Baron <jbaron@akamai.com>, 
	Jim Cromie <jim.cromie@gmail.com>, Tiwei Bie <tiwei.btw@antgroup.com>, 
	Benjamin Berg <benjamin.berg@intel.com>, 
	"Ilpo =?utf-8?B?SsOkcnZpbmVu?=" <ilpo.jarvinen@linux.intel.com>, 
	"David E. Box" <david.e.box@linux.intel.com>, "Maciej W. Rozycki" <macro@orcam.me.uk>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
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
Content-Type: text/plain; charset="us-ascii"

On Thu, May 21, 2026, Kees Cook wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 07f4c7209ac0..00317774a90b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -368,12 +368,16 @@ static int vmentry_l1d_flush_set(const char *s, const struct kernel_param *kp)
>  	return ret;
>  }
>  
> -static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
> +static int vmentry_l1d_flush_get(struct seq_buf *s,
> +				 const struct kernel_param *kp)
>  {
> -	if (WARN_ON_ONCE(l1tf_vmx_mitigation >= ARRAY_SIZE(vmentry_l1d_param)))
> -		return sysfs_emit(s, "???\n");
> +	if (WARN_ON_ONCE(l1tf_vmx_mitigation >= ARRAY_SIZE(vmentry_l1d_param))) {
> +		seq_buf_printf(s, "???\n");
> +		return 0;
> +	}
>  
> -	return sysfs_emit(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
> +	seq_buf_printf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
> +	return 0;

For this one, can you manually change it to this?

	if (WARN_ON_ONCE(l1tf_vmx_mitigation >= ARRAY_SIZE(vmentry_l1d_param)))
		seq_buf_printf(s, "???\n");
	else
		seq_buf_printf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
	return 0;

>  }
>  
>  /*
> @@ -459,9 +463,11 @@ static int vmentry_l1d_flush_set(const char *s, const struct kernel_param *kp)
>  	pr_warn_once("Kernel compiled without mitigations, ignoring vmentry_l1d_flush\n");
>  	return 0;
>  }
> -static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
> +static int vmentry_l1d_flush_get(struct seq_buf *s,
> +				 const struct kernel_param *kp)
>  {
> -	return sysfs_emit(s, "never\n");
> +	seq_buf_printf(s, "never\n");
> +	return 0;
>  }
>  #endif
