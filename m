From: Markus Mayer <markus.mayer@broadcom.com>
Subject: Re: [PATCH 1/6] lib: string: add function strtolower()
Date: Mon, 4 Jul 2016 13:18:18 -0700
Message-ID: <CAGt4E5sgTbwqb+paF2NaJP_vgQwrvGpTtzLAs28LapGRqMaKFA@mail.gmail.com>
References: <1467330612-26242-1-git-send-email-mmayer@broadcom.com>
 <1467330612-26242-2-git-send-email-mmayer@broadcom.com> <8737nt83sc.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <8737nt83sc.fsf@rasmusvillemoes.dk>
Sender: target-devel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, devel@acpica.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1 July 2016 at 14:08, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> A few suggestions:
>
> - Make the function take separate src and dst parameters, making it explicitly
>   allowed to pass the same value (but not other kinds of overlap, of
>   course). That way one can avoid "strcpy(dst, src); strtolower(dst);".
>
> - Drop the NULL check. If someone does "foo->bar = something;
>   strtolower(foo->bar); put foo in a global data structure...", the
>   dereference of foo->bar may happen much later. Doing the NULL deref
>   sooner means it's much easier to find and fix the bug. (Also, other
>   str* and mem* functions don't usually check for NULL).
>
> - While it's true that strcpy and memcpy by definition return dst, that's
>   mostly useless. If you want it to return anything, please make it
>   something that might be used - for example, having stpcpy semantics
>   (returning a pointer to dst's terminating \0) means a caller might avoid
>   a strlen call.
>
> - Maybe do strtoupper while you're at it. Quick grepping didn't find any
>   use for the copy-while-lowercasing, but copy-while-uppercasing can at
>   least be used in drivers/acpi/acpica/nsrepair2.c,
>   drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c,
>   drivers/power/power_supply_sysfs.c along with a bunch of inplace
>   uppercasing.
>
>
> Rasmus

Thanks for the suggestions to you and Jani. Based on the feedback I
received, I am reworking the series now and will post v2 probably
tomorrow.

Regards,
-Markus
