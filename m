Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.201
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793844846;
	b=1FFh8kDPaTmuWjBx9GqRy8VsJPMlnpmWEheCLDyQUwtN+BnTr2jtQgoAL8EfVtOWooF7
	 ZXsyMN7zhEg4YN+G9UmGsXV8VBoivqrbZCvBWUzSa4mUuNU092p/XfKUXXza2XVkmKRuh
	 zpEb+ImNcwIxrHrfJkFjpeSsloTjW8y+jIQ26H5SfAaIDL5YRRxifL2eby5YE0Vlujm8c
	 gDRvtnt7BZUGRHlWUlZccZplcFYsMv8u88Gc8uauTJKw3RoQnIiD+B+kJnx7T7u5xGUJs
	 LYwGgHZrwb7xMZJc56vPx4GOJ6vr2S0BCu9czOEhLMFJSo83QALQVN7tdtnWHVL3YYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793844846;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=tXeq94tKXH8bHOz1amsH5XRU51n2PYOOTkgxfF1PjyI=;
	b=bGL957g5f5vEQx7bjk+WbFUfBvX25Bieu+dF62Db7ZYGtCMCXezRDb1Vl6USfc9seinu
	 3VfZ7MTWhFARHEt4svXSiMZFcG/MwmxbZ9ShjCwOzWRimwrXarfUau7OS2xi5vHtsNqTl
	 2xXw50gAOGDspEBx6gJYz0WDCadg/5Kk+wLHKwOaMidI/pxKbucnHT6tTjeetMXuJScVT
	 8j6pUEQkGGdc28NTnBEvYR/fzG8MwVZkoLRDjK9z23aeUTZUc0c35pJ0K7lOzZIMdUWra
	 XlDsH3/XUwdS6UOedt+B1lesA9Eyt8Uf+Qv2vwKswwxjC+pxKjI+nOBkh1mvmnY5DoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j2sTp789;
	arc=none smtp.remote-ip=91.218.175.201
Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04596606A328
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 02:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04596606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j2sTp789
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=l5hRS8qgzR0WOCPLF0tQbQ+of37lp1oZsgw+XUQqwhg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793844844; v=1; x=1794449644;
 b=j2sTp789TAzH4+lGZ7lYWfaDwj4tzc9cwnz9VymVYz+93eIx1j2P1wIewQP0NcIfVbJQKLyf
 0DO8NIIghKzDouBSBnDym1wAnQyGpqJsD9irj2dQSZrGObeDZJB96QtjMGxheDIwPErfv1cfpzT
 zdnAQ3fG/Xx2Ge3hDWonFfXo=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7ce234fbb2517b84;
	Thu, 05 Nov 2026 02:14:03 +0000
X-Mizu-Trace-ID: 7ce234fbb2517b84
X-Migadu-Flow: FLOW_OUT
Message-ID: <fc4939cc-84ec-4c5c-88a7-658ca800377d@linux.dev>
Date: Thu, 5 Nov 2026 10:15:13 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v2 01/51] alloc_tag: don't remove /proc/allocinfo
 under the codetag module lock
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>,
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
 Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>,
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org,
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org,
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org,
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org,
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>,
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>,
 stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Cc Suren

Hi Christian

On 2026/11/5 03:06, Christian Brauner wrote:
> codetag_alloc_module_section() takes the codetag type's mod_lock for
> writing and calls reserve_module_tags() with it held. When that can't
> reserve the tags, because the section's alignment doesn't fit, because
> there are too many tags for the page flag bits or because the memory
> for them can't be allocated, it shuts memory allocation profiling down
> and removes /proc/allocinfo, still with mod_lock held.
> 
> remove_proc_entry() waits until every reader of the entry has let go of
> it, and a reader of /proc/allocinfo takes mod_lock for reading in
> allocinfo_start() while it holds the entry. So a module load that hits
> one of those paths while /proc/allocinfo is being read waits for the
> reader and the reader waits for the module load, for good.
> 
> Let a work item remove the entry in that case. The profiling is shut
> down right away like before, the file just goes a moment later.
> 
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Thanks.

is this a problem you have hit in practice?
Sashiko discovered this issue earlier and reported it as follows:

> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 2070e682fe106..112a014d4b890 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -950,10 +950,12 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>  		int grow_res;
>  
>  		module_tags.size = offset + size;
> -		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
> +		if (!tags_addressable()) {
>  			shutdown_mem_profiling(true);
This is a pre-existing issue, but does this shutdown_mem_profiling(true) call
introduce an AB-BA deadlock between /proc/allocinfo file readers (pde->in_use)
and module loading (cttype->mod_lock)?
A user reading /proc/allocinfo acquires the procfs in_use reference in
use_pde(), then blocks on down_read(&alloc_tag_cttype->mod_lock) in
allocinfo_start().
Concurrently, if a module loads and tags_addressable() fails,
codetag_alloc_module_section() holds down_write(&cttype->mod_lock) and calls
shutdown_mem_profiling(true), which removes the proc entry. This removal waits
indefinitely for the in_use reference to drop to zero, hanging both procfs
reads and module loading.
> -			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
> -				mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +			pr_warn_once("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
> +				     mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +			release_module_tags(mod, false);
> +			return ERR_PTR(-EAGAIN);
>  		}
>  
>  		grow_res = vm_module_tags_populate();

I previously sent a patch with a comparable idea, though Sashiko remained unconvinced.

[patch]: https://lore.kernel.org/all/20260817062726.106511-3-hao.ge@linux.dev/

[Sashiko's objections]: https://sashiko.dev/#/patchset/20260817062726.106511-1-hao.ge@linux.dev

Could this patch perhaps wait for mine? No worries if this is inconvenient.

Best regards                                                                                                                                                                                                                                                                  
Hao

> ---
>  mm/alloc_tag.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 82e2c3448dcf..7d7ad6704953 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -15,6 +15,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/string_choices.h>
>  #include <linux/vmalloc.h>
> +#include <linux/workqueue.h>
>  #include <linux/kmemleak.h>
>  #include <uapi/linux/alloc_tag.h>
>  
> @@ -604,6 +605,26 @@ static void shutdown_mem_profiling(bool remove_file)
>  	mem_profiling_support = false;
>  }
>  
> +static void remove_allocinfo_file(struct work_struct *work)
> +{
> +	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +}
> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> +
> +/*
> + * A module's tags are reserved with the codetag module lock held for
> + * writing, and a reader of /proc/allocinfo takes that lock with the entry
> + * pinned. Removing the entry there would wait for that reader for good, so
> + * let a work item do it.
> + */
> +static void shutdown_mem_profiling_async(void)
> +{
> +	if (!mem_profiling_support)
> +		return;
> +	shutdown_mem_profiling(false);
> +	schedule_work(&remove_allocinfo_work);
> +}
> +
>  void __init alloc_tag_sec_init(void)
>  {
>  	struct alloc_tag *last_codetag;
> @@ -855,7 +876,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>  		align = 1;
>  
>  	if (!ensure_alignment(align, &prepend)) {
> -		shutdown_mem_profiling(true);
> +		shutdown_mem_profiling_async();
>  		pr_err("%s: alignment %lu is incompatible with allocation tag indexing. Memory allocation profiling is disabled!\n",
>  			mod->name, align);
>  		return ERR_PTR(-EINVAL);
> @@ -905,14 +926,14 @@ unlock:
>  
>  		module_tags.size = offset + size;
>  		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
> -			shutdown_mem_profiling(true);
> +			shutdown_mem_profiling_async();
>  			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
>  				mod->name, NR_UNUSED_PAGEFLAG_BITS);
>  		}
>  
>  		grow_res = vm_module_tags_populate();
>  		if (grow_res) {
> -			shutdown_mem_profiling(true);
> +			shutdown_mem_profiling_async();
>  			pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
>  			       mod->name);
>  			return ERR_PTR(grow_res);
> 
