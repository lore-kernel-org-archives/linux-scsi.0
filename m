Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F3C1B86F5
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 13:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725886975; cv=none; b=WVb4dPKzTjgonOiWJ1X/iFY7lGGMdZozsLxpcXH9rYYaiFSvSGz5mqpI2AqKCiP1s6EkeQIEnpSxFvuGt1lyu3F+Sw6mtuIG7RE8yUqs0FJdaNi6V5SZw9ahdWSakPCG6k1ng96jlsTwY0TM0N8HLT2o2s2eYW71qU2vr21PMEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725886975; c=relaxed/simple;
	bh=T3YX5/Lpd4lYkt45t/7q4cjSITWugSsonc6UgJRAfvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TP//Q2vXZXOc5ttPwa0FMllL2BzQVZOXqHY+Ox+WDWdMb7lxSjvaexvulkE3w8sYfhkm3So82u1S9YvMbAjvJUnPQPUf4wnMCkSkmatouSsQ3WlRmK0DvdBNoR2DP7gW38m42D9UlBmdyFpVwcCm/sCudgj9d4XonDKLZM2qPeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GYOxmlB6; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GYOxmlB6"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8a7cdfdd80so259147366b.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Sep 2024 06:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725886971; x=1726491771; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7mMqU87htuX/vKBzsNQkDBJ4RpNR7Zr8uFLI9xAQvGQ=;
        b=GYOxmlB6cqxQooQnEt7X++w7jM/eK/CATiRIFTlUeVsvxT9Ux4sbdQFL2Yj3y9IIxs
         1/hT/mWfLkUwjQW8l2PNx5z/9dOebysSNFmr2JJncBXgRbJQhZb4hNCn3LQWhoQK3uLw
         MV1gOuwILIxvf+50GlQ3QALoWEgbLslRE+2Q64nHbx49SQ6N0NLiheIo0yVonh7UYmeT
         6SMAMkpaiXDARG4w8d4qLxh+oSDXZAPEZQh9Oct2MBiOFq71aPVkh8y/npv7+MtEzih2
         Awjsn9QaZNnSNtTZ7wnelsK2bB36E55nfpNa4W8U2xHredMXRNYHtN1ZsSdL2br2YUGd
         URtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725886971; x=1726491771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mMqU87htuX/vKBzsNQkDBJ4RpNR7Zr8uFLI9xAQvGQ=;
        b=wOtyXk3XYiRnnbNlQnmtE60hWJHY4Nm8ZO29eWritmYewfhrPOFpCw9gQrz2MCCnuN
         o+Im85T19qEio39O+5sSzsq6RuA/SZ0VU5Lk+TpI5E0Bk6YBy9bDi4cOMo+obxHaYkF8
         FrdYox5Vaqb2Ayy96iklmRGo+OGEFgr5n0gxvcQZ9bDBWgBBk9UifOYOD+JEMg6+IT4D
         lf4DMydPC8pgPF/+8BRExXPOayVPkWbU17QlqcosImZ/2sosbzHHMi8OqHxQa+6QIo8A
         beQxauz2b382pzb/M8k3BBi9Ev/ZaIgyK6V53rHtT2LhuCIkcat4ajkjITYIYktH0nDB
         E4EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWojEdWs8ZR8Rc8FirXi4F0VavKRexm9WhdNhLI7fHPtL+ktn638Ue+lrBXB/z07t1AX47KHgndpZDV@vger.kernel.org
X-Gm-Message-State: AOJu0YxKA3msxPUo1qerFD4QxDd3EC7u+DaY9xFv+CupGj/6kdgNCf3u
	0qvzlR4ZiKgBgiA5STeouO8awUJVnoeTU1iHEpnP87Cce5Xcomqu0zN5VSu/srg=
X-Google-Smtp-Source: AGHT+IGBCWEcHjOnjDa3tv0OU9sQsIWi0rYKMo1x8pgZwqnvO0g9WWezq8axRIpo3yitGDVIG7HaOA==
X-Received: by 2002:a17:907:368a:b0:a86:8953:e1fe with SMTP id a640c23a62f3a-a8a8884be2cmr906103366b.47.1725886971281;
        Mon, 09 Sep 2024 06:02:51 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54abbsm337715666b.203.2024.09.09.06.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 06:02:51 -0700 (PDT)
Date: Mon, 9 Sep 2024 15:02:49 +0200
From: Petr Mladek <pmladek@suse.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-fscrypt@vger.kernel.org, linux-scsi@vger.kernel.org,
	bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND v2 16/19] lib/test_scanf: Include
 <linux/prandom.h> instead of <linux/random.h>
Message-ID: <Zt7x-dJF6RzEByBO@pathway.suse.cz>
References: <20240909075641.258968-1-ubizjak@gmail.com>
 <20240909075641.258968-17-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909075641.258968-17-ubizjak@gmail.com>

On Mon 2024-09-09 09:53:59, Uros Bizjak wrote:
> Substitute the inclusion of <linux/random.h> header with
> <linux/prandom.h> to allow the removal of legacy inclusion
> of <linux/prandom.h> from <linux/random.h>.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>

I have just acked v1 and missed that there already is v2.
Just for record:

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
