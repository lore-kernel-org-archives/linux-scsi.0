Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CD038C2B8
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 08:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784880021; cv=none; b=BwuhcBPHrhJwYzDOs6ITLZLKXlwkyOxTRiMigmB0mv1LZsmvRx1h51hW17YTJiT138dKc+p1yO8JTBQR5naHP7KNWcYhqltUmIME+FM0ElGz7tdczCEeHsElixV8F2uy8UvZB0CWIbiGMujxhznQ/jcSUxb3WxKyRVhc1am0Dus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784880021; c=relaxed/simple;
	bh=HHj9fMzh87Z/uENEL8UlBJs+fVZWxpVwcU4UjJ6Qw+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I3uJWQIOp6coopQGFApG1ZBQjR/P0w5gbJQVRMfd32iEksKUPrSS33xOk8AaBgskM8Q1AHWtNznq77b9G+kAvt4I1dfb/PZ/Vo3qCviNf3eeCLY9vbpHECsrjGGahvZEdRZ7/ivaon5y4JroBPPbGAExKqMsFNdZ8E4iA62LuWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o56gilkL; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o56gilkL"
Message-ID: <a762baf6-3e0c-44f4-9e3f-d7e9e85206bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784880007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lQJSJ2FQaCu0p9XBfAENgQYAxMg7L+yAnJ8kwhfzxwU=;
	b=o56gilkLmpCj02Y8MWLkp2tHREvFqtf5fT7ZN2K+ssAzOJHBJQ6c3eAgoX1Jhc80EVQskg
	KY0dNMhCSOv6sFDLaQdF5A5MArsP+H86OhIJDjiNtMAkWjfQHjWAy8kljmXaW0Vv+v/fHC
	AToaeNQ+WGAHooEAS6iZ3sOqyr05+W8=
Date: Fri, 24 Jul 2026 09:00:00 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 01/28] libmultipath: Add initial framework
To: Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-2-john.g.garry@oracle.com>
 <ba62d294-6954-44d3-af79-6c7da33a5ccd@suse.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: John Garry <john.garry@linux.dev>
In-Reply-To: <ba62d294-6954-44d3-af79-6c7da33a5ccd@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

>> new file mode 100644
>> index 0000000000000..e98b4b241020a
>> --- /dev/null
>> +++ b/include/linux/multipath.h
>> @@ -0,0 +1,28 @@
> 
> Please add an SPDX tag.

OK, will add

> And possibly a copyright.

I think that just the c file is fine.

> 
>> +
>> +#ifndef _LIBMULTIPATH_H
>> +#define _LIBMULTIPATH_H
>> +
>> +#include <linux/blkdev.h>
>> +#include <linux/srcu.h>
>> +
>> +struct mpath_device {
>> +    struct list_head    siblings;
>> +    struct gendisk        *disk;
>> +};
>> +
>> +struct mpath_head {
>> +    struct srcu_struct    srcu;
>> +    struct list_head    dev_list;    /* list of all mpath_devs */
>> +    struct mutex        lock;
>> +
>> +    refcount_t        refcount;
>> +
>> +    struct mpath_device __rcu         *current_path[MAX_NUMNODES];
>> +};
>> +
>> +int mpath_get_head(struct mpath_head *mpath_head);
>> +void mpath_put_head(struct mpath_head *mpath_head);
>> +int mpath_head_init(struct mpath_head *mpath_head);
>> +void mpath_head_uninit(struct mpath_head *mpath_head);
>> +
>> +#endif // _LIBMULTIPATH_H
>> diff --git a/lib/Kconfig b/lib/Kconfig
>> index 55748b68714e0..d0258bef374a1 100644
>> --- a/lib/Kconfig
>> +++ b/lib/Kconfig
>> @@ -636,3 +636,9 @@ config UNION_FIND
>>   config MIN_HEAP
>>       bool
>> +
>> +config LIBMULTIPATH
>> +    bool "MULTIPATH BLOCK DRIVER LIBRARY"
>> +    depends on BLOCK
>> +    help
>> +      If you say yes here then you get a multipath lib for block drivers
>> diff --git a/lib/Makefile b/lib/Makefile
>> index 7f75cc6edf94a..7ba5e13be4171 100644
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -334,3 +334,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
>>   obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
>>   subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
>> +
>> +obj-$(CONFIG_LIBMULTIPATH)    += multipath.o
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> new file mode 100644
>> index 0000000000000..9cc398d266adf
>> --- /dev/null
>> +++ b/lib/multipath.c
>> @@ -0,0 +1,66 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2017-2018 Christoph Hellwig.
> A bit unusual, creating a new file and add a copyright
> from _another_ person ...
> 

This code is really just a refactoring of the NVMe multipath code. Since 
Christoph copyrighted that, I think it only proper to add his copyright 
here.

I'll remove it if Christoph wants.

> 
> Otherwise:
> Reviewed-by: Hannes Reinecke <hare@kernel.org>
> 

Thanks

