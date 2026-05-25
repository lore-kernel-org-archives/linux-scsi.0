Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D585385D93
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 13:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779716115; cv=none; b=H/kIq8y7+CFT6rGFaNzrv60PsdYK6rBpc8K5vFdh850AVe0d8d8Pq6AOtva7Hlm3mQEgicFP/a5TVEreLlK3NsimAXeaS8jpFwB6OidjgcfoQ5sOTRkz5+eN0cZRynK5Lo89BDXswryl1TQEL0uWSEztihh8jpGLsiCbN4CscQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779716115; c=relaxed/simple;
	bh=s/CzDsE1zdMqB98tClQW/DiNhe7WU760fn0iU6bx43Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nk10+8PiaZzvpKJl1e8uP6PAvG686w1wQbsKBnc3z6VwbGDS2Hobb9MvWmeggPFQFYElW3gyJ5fIi9Zy58KQz7XaHEbYkns4Px7FUbHA8xl7ixg+RPCSEUI0VyZS41Inxp5d8b0+xngekHhZtUuaASutWmyRfERZWqlUQt//Hn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BpUH14EG; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BpUH14EG"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43d75312379so8030412f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 06:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779716110; x=1780320910; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9XVHRPBSt9KXo5wrulw6nEDVPqzcFN/DF35DZwL4F0c=;
        b=BpUH14EGnlm4UYZVu9foBdalLVCHK55wdvwsZK81HpX2SG6MTxvw/kc4VaJeXSjZQs
         3eTBMqQvcMIzwXiWfi3KT13WN+SRW8QHICGRtWD6SY/UWm63k8eQp79rk6d0NGLAc1qv
         WjIAbFurjt3Rkm4z1tsFPUIrIEG7MyEpyocm02DR2uAkfQIxvmO2cNTG+McK3R2XH7Rj
         7AUUX8rh2epSIAQYE8gycCnQ+260SuVSBqvdVV4OrRcaJMwiZDn6IsIj94PggCttQSXr
         UHNrnpG4ko2zTsVOvv0b7M9hyRTdGQZQuFT25cBFZjgK3I+CYbhCVOqZqdeTrTSrkrDJ
         92RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779716110; x=1780320910;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9XVHRPBSt9KXo5wrulw6nEDVPqzcFN/DF35DZwL4F0c=;
        b=XF7KBvUrsdR7RAAvsbWRF/vLGntO6O5eUtLDjSdZpaB1bgKwkHxc+TZTayEycLkaG/
         sOxLV2j+bWvHnQZaXEWjrTap2sGPL7DFMyZbOiMih8vPInJeoT1SgatN1DL0UaC8MiGe
         A4FSh3MLYd9wDq4XvGSrK4rYTt2el6ExMSJUaEy6sFxZaOZ7e8T+cHdvGlY2FgJjpzt1
         +ELYz43TsBlzP1BFwCo0OpXcMoOGQ/foLRyPhT6dcwvsRj1R7HBESvjnw/oyZM2XO3yR
         G5dIsV4TvqudDwGOlfNovSdqqNFyDDSy3DShFDcxQrTxoSHnqv7WNjg5WEgD2uDn/wCa
         V2Eg==
X-Forwarded-Encrypted: i=1; AFNElJ/8sXWNs/mbcXtljwc68rt1ieGaqPbdq9gsqDfYaINktVq69/h8Ex0fAGePu8eheHQfAsH6NKBzoIFD@vger.kernel.org
X-Gm-Message-State: AOJu0YxvphEJ3J0WQv2zLYF0xc6ODebQDt0PKo/9RDID6GYOb3/LoI4N
	sBOL0grcZGVzGQ6MT2C0LVlvxhLJveagmBAZyblB4PVV8+YvxgKcLT9sf+kMdyyzVqw=
X-Gm-Gg: Acq92OEPNmcrlR/5y622HJho3YxIQQDpI/xi5cAxTZCzv94lYntL6BHhwHOFP3zW5Iz
	9YCxCAwnkDby5u4y7EutO7q7yqH7BzGWuNToCimkZxd3Q8nA1tEdHa5Pdm5Xi/fVxq/Ck8hH7bI
	IPS8srTJh03llYWVQLtQDiWcbznhho3BpP+8rNNPklqItGUbdXJLKaLlpgdcsVsPORd2xJr99qW
	aqq9/3IcX8yHZ30kQ+n9qiS3NLFSe7TWrsd6T4prBhy6Q/Co+IlnCEys4Nza33rsFGHZItkDGuH
	tFagOa8Ho6FXldUCQsY3dF6NITG5j/1YZMtcozpflQN9oMveeOsN/WRDK1BVcwwOZlYFtKybIbD
	xZ2afLxGq1CEmkPl6+hm6ycRfsX48+1/xRIFKbjdUZbnFSYO9351hjj5TPGih0lZ0pTW04AfzAD
	hc+S636GztF+/YMYul8PsQhsvWRz42Tn7y4OiGjSSfww7w07nFul/i3ykMlxBHrSFmHq50cd95F
	3ZoJTtLSkpMvVNo42SDN4T2l6P9rOUCcH+MTv1TCtFFatrw5OVkiz7lScI0cKOGVC9Hxg==
X-Received: by 2002:a05:6000:2008:b0:45e:8cdc:4ee8 with SMTP id ffacd0b85a97d-45ea3128ccdmr31052715f8f.6.1779716109692;
        Mon, 25 May 2026 06:35:09 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5cb9asm29456456f8f.27.2026.05.25.06.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 06:35:09 -0700 (PDT)
Message-ID: <da358ae1-91b4-4a16-ac76-ffab99c230b9@suse.com>
Date: Mon, 25 May 2026 15:35:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] treewide: Convert struct kernel_param_ops
 initializers to DEFINE_KERNEL_PARAM_OPS
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
 <20260521133326.2465264-4-kees@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133326.2465264-4-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 3:33 PM, Kees Cook wrote:
> Using Coccinelle, rewrite every struct kernel_param_ops initializer that
> sets .get into a DEFINE_KERNEL_PARAM_OPS-family macro invocation,
> for example:
> 
> @@
> declarer name DEFINE_KERNEL_PARAM_OPS;
> identifier OPS;
> expression SET, GET;
> @@
> - const struct kernel_param_ops OPS = {
> -       .set = SET,
> -       .get = GET,
> - };
> + DEFINE_KERNEL_PARAM_OPS(OPS, SET, GET);
> 
> Using the macro for initialization means future changes can manipulate
> the struct layout and callback prototypes without having to change every
> initializer.

Nit: For consistency, I suggest also converting the few remaining
kernel_param_ops instances that specify only .set and no .get, such as
simdisk_param_ops_filename.

-- 
Thanks,
Petr
