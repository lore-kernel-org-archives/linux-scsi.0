Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5E83DC4C8
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 13:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780405498; cv=none; b=Xw/ESbDWNzLepPu3tOdgbJ0D7S9Jkr63GbO/sJJggkE2iNDn3B3R8DpKar6JiHmlEEwmB9J3X1a7xw/dk37mkJ9JpiRIHKFPY/K8cUaUwa7K6PEIbwkj4vUmW1dXB/HcImuDSEGxP4yrqXQpCBtb4afSVe18K0oQhnGZzVXY7Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780405498; c=relaxed/simple;
	bh=Lv88enNvVjptEHx4RPDpSYkoiYl4NHCAht/k1YwYRy4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CgzmWeCfhvXcKbw7ARnTK2va1j2OgZTrmafnhH1G99D3ErgQkFNVsmA4jCfMF3G31wSknCDGk8x7I+Peg+QIlGJUqxxSUHQVXInLH758wMSQdUFu6rW6updCXnR9ngkwb6dMXOlL0eWS1gC6qudZXD4zco9CPSG2w/H5BZxH6cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oYCy8oWL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oYCy8oWL"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4904fd4f6aeso95916365e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 06:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780405496; x=1781010296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/8nMdqnIqVIuE86ZCCEmz0EQ1iXOszPXfKX9VZoGH4=;
        b=oYCy8oWLEOXs3ZZpnQ8VOQHoNFjKZT62/QUyW3df6kxvDecqCOK07UnU98cT9bih7d
         QifFlcWIr+EJiA3Y4YekpYVbMWMA0XqQZb9m0aNzEy+n6CZ9KNJxUBct5gbgm0d6jBJX
         4RYm7cSM4Fa+MgP775wpjzUTJB2NacljxFREy0lFq+bJunDJIYp2ZV4sTIDkO+Vc1xr7
         FpcRQcE1R3qM6zq5aytz97WBpu5zXpd39pgEA0GnDnl2ujkjmEdAdRZhqHjKWr+k4Lc4
         ry5o67NwkoWSsT9Lap7TwhGHQwNn20aUpkBNKTwaaKQ1kQ2Jb1T0oTaxOfTVux7BZHHQ
         5nZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780405496; x=1781010296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H/8nMdqnIqVIuE86ZCCEmz0EQ1iXOszPXfKX9VZoGH4=;
        b=dupGOgeuKZI+4rkT0rlnETkZyS+svqAa75B92GjT+2wX41GPQA3OYLr0qehCGOkyYK
         y9RmQsIWHyD8/jvz6bAT5kEzn8Sem+fsS7SMyD4jteR9JSvT/UIO93u2FlMfumeyfM+h
         DSQe5ZROgCR8LxVrJ/aIFghsVuIxBnJ8anYH78ZJjVkr+mDXFJ1BHS4JvppiHjdPDiBa
         unCsMVTjm2dCu0Eom6q63KSzPuNFcJkPa1qn/lz/pY6EzQpg5B0AwAAlvnGztu8oTh0L
         475bA2S2MGUgYywLd4m3oauOElQGZPmuER9VtzjY8fC10phFjWoTKN9fDg3bbI3iduig
         phJw==
X-Forwarded-Encrypted: i=1; AFNElJ+Cb2gr0l5Vjw6fxHzDbtAIOuyZWPifOGApWmfC6amVNPlNYsL24FjyPd8MGUy//8wcRDQz65D9cmgl@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3ZoUCaxqoVHSmCCKlAXCYGmfCr6N8hL8F2N7XddLgZOYi9JeX
	ec+Oe2A3j9jiTCX0teJzTTZbwreezmdKptSSFeAjmEryUaBFr6ppKUCq
X-Gm-Gg: Acq92OHzj8MY66Dhc/t1+VoZ2c1Ob8xernPsNrVqMx8e0PQ8Sa8oJlQ5LcRSmirrCIF
	C6OiNAVTYHW5kxRSUM8cEqq7RxTZzLlSdqllCbRv7u/zrPOjZHp4t1L7Oe1sebz3QP/PZmkZzuH
	fOgRHkrKIUz2KzLctz+vo4+w0WgzKkMKuAB5XZvSRKC/Du3NzdmYkJh5W6NVE7jPkqWQZZqtE/c
	NR50uN3mW3XnAYsgo8c5lZaJv00pmOvd+XJMn6oYCNBXSuSE4KDTB7fYJYuBNlommo23UT3Y6RD
	J1cpkmmudY+esnEeBGTbI0ZpfGVXX303PT0i5iGsR98e1GgO1ChGJQQzuU0wQA0QqmYbj2sCWMQ
	vdbh4Eim43s777G8a6AAtff7r4l7pgPNQF3ZelnKUUnx/3UqB+DyNmTI5vESJ1IA5ZTE5nfz0mD
	3WxVQ9w6TQ8slAvv0hHMrRipgAblVF9Gc0Pa+1CwWJHQCqBSlXIXTsidDftnUZ1yN2mS4wrAkG3
	jsHn0JRCw==
X-Received: by 2002:a05:600c:8105:b0:490:b072:1be6 with SMTP id 5b1f17b1804b1-490b0721e0amr76565325e9.25.1780405495119;
        Tue, 02 Jun 2026 06:04:55 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b834esm33184301f8f.11.2026.06.02.06.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 06:04:54 -0700 (PDT)
Date: Tue, 2 Jun 2026 14:04:51 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
 Pengpeng Hou <pengpeng@iscas.ac.cn>, stable@vger.kernel.org, Petr Pavlu
 <petr.pavlu@suse.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Len
 Brown <lenb@kernel.org>, Corey Minyard <corey@minyard.net>, Gabriel Somlo
 <somlo@cmu.edu>, "Michael S. Tsirkin" <mst@redhat.com>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Bart Van Assche <bvanassche@acm.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Laurent
 Pinchart <laurent.pinchart@ideasonboard.com>, Hans de Goede
 <hansg@kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Bjorn
 Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Daniel Lezcano <daniel.lezcano@kernel.org>,
 Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby
 <jirislaby@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, Jason Baron
 <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>, Tiwei Bie
 <tiwei.btw@antgroup.com>, Benjamin Berg <benjamin.berg@intel.com>, Ilpo
 =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, "David E. Box"
 <david.e.box@linux.intel.com>, "Maciej W. Rozycki" <macro@orcam.me.uk>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Vinod Koul <vkoul@kernel.org>, Frank Li
 <Frank.Li@kernel.org>, Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen
 <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, Alexander
 Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 John Johansen <john.johansen@canonical.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn"
 <serge@hallyn.com>, Georgia Garcia <georgia.garcia@canonical.com>,
 kvm@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-modules@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, apparmor@lists.ubuntu.com,
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
Subject: Re: [PATCH 01/11] params: bound array element output to the
 caller's page buffer
Message-ID: <20260602140451.2e3e6622@pumpkin>
In-Reply-To: <ah699hwLxIIOZ0-7@ashevche-desk.local>
References: <20260521133315.work.845-kees@kernel.org>
	<20260521133326.2465264-1-kees@kernel.org>
	<ah699hwLxIIOZ0-7@ashevche-desk.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Jun 2026 14:26:46 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Thu, May 21, 2026 at 06:33:14AM -0700, Kees Cook wrote:
> > 
> > param_array_get() appends each element's string representation into the
> > shared sysfs page buffer by passing buffer + off to the element getter.
> > 
> > That works for getters that only write a small bounded string, but
> > param_get_charp() and similar helpers format against PAGE_SIZE from the
> > pointer they receive. Once off is non-zero, an element getter can
> > therefore write past the end of the original sysfs page buffer.
> > 
> > Collect each element into a temporary PAGE_SIZE buffer first and then
> > copy only the remaining space into the caller's page buffer.  
> 
> ...
> 
> > +	elem_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);  
> 
> get_free_page() (or how it is called)?

The kmalloc() should be faster and I think has to be aligned.
There is another patch set to replace get_free_pages() with kmalloc().

Although all these 'show' functions should really head to using a safer
interface.
Although, at the moment, it is really difficult to find the ones that
are guaranteed to be passed a page aligned buffer.

-- David

> 
> > +	if (!elem_buf)
> > +		return -ENOMEM;
> > +
> >  	for (i = off = 0; i < (arr->num ? *arr->num : arr->max); i++) {
> > -		/* Replace \n with comma */
> > -		if (i)
> > -			buffer[off - 1] = ',';
> >  		p.arg = arr->elem + arr->elemsize * i;
> >  		check_kparam_locked(p.mod);
> > -		ret = arr->ops->get(buffer + off, &p);
> > +		ret = arr->ops->get(elem_buf, &p);
> >  		if (ret < 0)
> > -			return ret;
> > +			goto out;
> > +		ret = min(ret, (int)(PAGE_SIZE - 1 - off));  
> 
> It's usually discouraged to use castings in min/max/clamp. Can we make ret long
> or do something different here?
> 
> > +		if (!ret)
> > +			break;  
> 
> > +		/* Replace the previous element's trailing newline with a comma. */
> > +		if (i)
> > +			buffer[off - 1] = ',';  
> 
> Can't we do this after with help of strreplace()?
> 
> > +		memcpy(buffer + off, elem_buf, ret);
> >  		off += ret;
> > +		if (off == PAGE_SIZE - 1)
> > +			break;
> >  	}
> >  	buffer[off] = '\0';
> > -	return off;
> > +	ret = off;
> > +out:
> > +	kfree(elem_buf);
> > +	return ret;  
> 

