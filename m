Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165FF3C414F
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 06:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779778394; cv=none; b=taGR5qWEnx27xbBXkc0j9YQb3j4O/nz58WZfdWQk7zZ+SZxdauTCxnWkhkXGmew6Uy1LaBzcuHT9K00Occ2Z1QvIBtDhDC59LQAjAg1cqD+0yBO/AxRRHB/+7IYdxTN8eb11Wov5aFIvB85OJATtR3UEANJuOLcbRYjkpm5QUWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779778394; c=relaxed/simple;
	bh=lI94k3K5Kcc20pekEfGAOaAomJ1QgkYtP6G74MUe9gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QlMMXgdXAIflrYZOpk0qlh13zPfPAx9zc/J0435IU5r3QSS6GNw82craNubKQNa7dBcIiI12eVgj/1JGk2quup+W+m3aTDDcjTtMCIb6o7jzuXb7HWtQl6edBkVQ7n+znZrSTSZEQKuTEYE+Eo34l+h60yHtwM2RJ0YfQrVkBrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TR/s+dSF; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TR/s+dSF"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-459bf19e87bso5943362f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 23:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779778389; x=1780383189; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yXWASYjT/jE4WzpKhE8nVhHkzGwmPlTITkkcMF0D8BI=;
        b=TR/s+dSFI2Vk05JY9oKvhTkUPLyGjERphtpAPMGuiQxvuv3fbFSbN1th4lK+bttysm
         cFb/iWCpkNb08kRUbTcn9WjfJUaB3xcjwa8CXEuHNu8ztYYWGwWQbD8loHo0HuyuciOC
         0TwcL+CxgU01vXU93n3aCg4f5dmgC1/3cis8o9d493p1B0tb+ArlTCB5LaW6RVOHuZSe
         xFgNBY2Ddet/gPdHUxjFVULwbZSkZetwjzSKlyv7KFRavsith7RHUAc5uHnKUJqDu/G4
         H3+i6q7GH893mbCE8FjnHXqiv6/6t+5ocWoYo60XT6575r8A+rywJ8KG4tumaLrCo8Ff
         W8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779778389; x=1780383189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yXWASYjT/jE4WzpKhE8nVhHkzGwmPlTITkkcMF0D8BI=;
        b=otBJ8jIVr9x1DOWbzUM9tSRz5IFV9Xtnz6KD+ky/gyS5cLeFSxTW389P4GAGh0NcqI
         xzpWv/49znif5fHhK0jfUN4AZznSyZ79bkjPQOleLehyKHfCR9bHTV9B4NQkGF1/DpZL
         gh5Hnf1Iov/g+N2wFe+CMI6VoVatLwLSz00b8fTnNjQqOY/WqzipzHWv8+9SgNn8FbL2
         FC4cqFX/wv7a+EkgTpMZeJl+3I0IoTwvuPlPdKv4f3012BPUArcs0htlcSIQ4k3dcANH
         MpvtZVhlIHMxhaZh9WkL9nfIGVYDpaZ1IPP8UbReMXZ0IUninjbLzPIzXkFsOs7na2Q5
         0KFQ==
X-Forwarded-Encrypted: i=1; AFNElJ+iS633g5PScvtWubQv53idWcxy0O2j+RavhDZnpIBcbcm3UgNgMUWn5YvhmcmU+0JSMi/vhqu9Ypl3@vger.kernel.org
X-Gm-Message-State: AOJu0YwQKSceVNi8JOQbl9M+0V7my2xQsVunZtduzibC9MfS03imS58b
	OX+DWYCO6EuEuLF6QUxghTuVWGjFU1Eil2ZK2t/BSD/NmMrVk4i8ST/Y41GqtnyvQD8=
X-Gm-Gg: Acq92OHJVTDHw/hBAL0mXNlsHp1MwruN5YK3Zq69CD48kQLNM72IsrrncQSOyQag1jm
	hItEnpKLqSaiJiZRhKjooSIKsiq13JIFLdn1hHRB6Gov7kHC+Ym5AfWVSbABKwmr8oN/65ooGbD
	OV/8G1wMxe6ztHXeu988ACdh3B+APWUT7yfbvGjYF39bRcHTprBzAJ7YQTi+3d+GNopG84gp7zx
	aQbB2yxq6LjUNTxEUytSicPmfwh3BFHTGEeqtrKR1BxtYTitCpTQdt1D1D8HMKVQ1QZmMHediqf
	nLF24HYVb67GyAbJFngBJ2Q6e3G/PWr60dqkZChJEP1I42BLjSCb6/IdpEpxQ0IzTGkvsIdYJa6
	LHhn3r6AAhgPB8Cz9ssljWRegMwQvHPXPP0+1KYo7Upc4Id0+OgO7o+CwopqchzwPicU7InXWdl
	ff8P42ipRxH58vJYXYHAB7attoCkCSRYcIheSdAPr9Ihl+dC7Z/OqYrxjOCk+zdf6f9NGozqrK3
	f3VKhq8u5n3VW5ExOr84IGsbLFJzPZ3kl8JMZspow1gHqMZRXjyTWL0s4C9rIT6FgNjRZWTVUGm
	+xhg
X-Received: by 2002:a05:6000:2003:b0:43b:4136:1e6f with SMTP id ffacd0b85a97d-45eb38e4b46mr29516257f8f.38.1779778389230;
        Mon, 25 May 2026 23:53:09 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9ba2esm33848641f8f.8.2026.05.25.23.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 23:53:08 -0700 (PDT)
Message-ID: <88c5ca1d-eeda-4023-bc7a-397b92780db9@suse.com>
Date: Tue, 26 May 2026 08:53:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] Convert moduleparams to seq_buf
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
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133315.work.845-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 3:33 PM, Kees Cook wrote:
> Hi,
> 
> I tried to trim the CC list here, but it's still pretty huge...
> 
> We've had a long-standing issue with "write to a string pointer" callbacks
> that don't bounds check the destination (and for which the bounds is
> also not part of the callback prototype, even if it is "known" to be
> PAGE_SIZE, which sysfs_emit() depends on). Both moduleparams and sysfs
> use this pattern. As a first step, and to test the migration method,
> migrate moduleparams first.
> 
> There are 2 "mechanical" treewide patches that are handled by Coccinelle:
> - treewide: Convert struct kernel_param_ops initializers to DEFINE_KERNEL_PARAM_OPS
> - treewide: Convert custom kernel_param_ops .get callbacks to seq_buf via cocci
> 
> The last treewide patch is manual, and may need to be broken up into
> per-subsystem patches, though I'd prefer to avoid this, as it would
> extend the migration from 1 relase to at least 2 releases. (1 to
> release the migration infrastructure, then 1 release to collect all the
> subsystem changes, and possibly 1 more release to remove the migration
> infrastructure.)
> 
> Thoughts, questions?

This looks reasonable to me. I added a few minor comments on the patches
but they already look solid.

-- 
Thanks,
Petr
