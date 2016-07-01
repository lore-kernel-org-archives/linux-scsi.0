From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 1/6] lib: string: add function strtolower()
Date: Fri, 01 Jul 2016 23:08:35 +0200
Message-ID: <8737nt83sc.fsf@rasmusvillemoes.dk>
References: <1467330612-26242-1-git-send-email-mmayer@broadcom.com>
	<1467330612-26242-2-git-send-email-mmayer@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36654 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbcGAVJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2016 17:09:31 -0400
Received: by mail-wm0-f54.google.com with SMTP id f126so40006000wma.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2016 14:08:38 -0700 (PDT)
In-Reply-To: <1467330612-26242-2-git-send-email-mmayer@broadcom.com> (Markus
	Mayer's message of "Thu, 30 Jun 2016 16:50:07 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Mayer <mmayer@broadcom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, devel@acpica.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jul 01 2016, Markus Mayer <mmayer@broadcom.com> wrote:

> Add a function called strtolower() to convert strings to lower case
> in-place, overwriting the original string.
>
> This seems to be a recurring requirement in the kernel that is
> currently being solved by several duplicated implementations doing the
> same thing.
>
> Signed-off-by: Markus Mayer <mmayer@broadcom.com>
> ---
>  include/linux/string.h |  1 +
>  lib/string.c           | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 26b6f6a..aad605e 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -116,6 +116,7 @@ extern void * memchr(const void *,int,__kernel_size_t);
>  #endif
>  void *memchr_inv(const void *s, int c, size_t n);
>  char *strreplace(char *s, char old, char new);
> +char *strtolower(char *s);
>  
>  extern void kfree_const(const void *x);
>  
> diff --git a/lib/string.c b/lib/string.c
> index ed83562..6e3b560 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -952,3 +952,17 @@ char *strreplace(char *s, char old, char new)
>  	return s;
>  }
>  EXPORT_SYMBOL(strreplace);
> +
> +char *strtolower(char *s)
> +{
> +	char *p;
> +
> +        if (unlikely(!s))
> +                return NULL;
> +
> +	for (p = s; *p; p++)
> +		*p = tolower(*p);
> +
> +	return s;
> +}
> +EXPORT_SYMBOL(strtolower);

A few suggestions: 

- Make the function take separate src and dst parameters, making it explicitly
  allowed to pass the same value (but not other kinds of overlap, of
  course). That way one can avoid "strcpy(dst, src); strtolower(dst);".

- Drop the NULL check. If someone does "foo->bar = something;
  strtolower(foo->bar); put foo in a global data structure...", the
  dereference of foo->bar may happen much later. Doing the NULL deref
  sooner means it's much easier to find and fix the bug. (Also, other
  str* and mem* functions don't usually check for NULL).

- While it's true that strcpy and memcpy by definition return dst, that's
  mostly useless. If you want it to return anything, please make it
  something that might be used - for example, having stpcpy semantics
  (returning a pointer to dst's terminating \0) means a caller might avoid
  a strlen call.

- Maybe do strtoupper while you're at it. Quick grepping didn't find any
  use for the copy-while-lowercasing, but copy-while-uppercasing can at
  least be used in drivers/acpi/acpica/nsrepair2.c,
  drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c,
  drivers/power/power_supply_sysfs.c along with a bunch of inplace
  uppercasing.


Rasmus
