From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v3 0/7] lib: string: add functions to case-convert strings
Date: Sat, 9 Jul 2016 23:13:33 -0400
Message-ID: <9b88baed-a067-fcfd-d087-66e36f3060d7@mellanox.com>
References: <1468017794-4818-1-git-send-email-mmayer@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468017794-4818-1-git-send-email-mmayer@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Markus Mayer <mmayer@broadcom.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Kees Cook <keescook@chromium.org>
Cc: dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/8/2016 6:43 PM, Markus Mayer wrote:
> This series introduces a family of generic string case conversion
> functions. This kind of functionality is needed in several places in
> the kernel. Right now, everybody seems to be implementing their own
> copy of this functionality.
>
> Based on the discussion of the previous version of this series[1] and
> the use cases found in the kernel, it does look like having several
> flavours of case conversion functions is beneficial. The use cases fall
> into three categories:
>      - copying a string and converting the case while specifying a
>        maximum length to mimic strlcpy()
>      - copying a string and converting the case without specifying a
>        length to mimic strcpy()
>      - converting the case of a string in-place (i.e. modifying the
>        string that was passed in)
>
> Consequently, I am proposing these new functions:
>      void strlcpytoupper(char *dst, const char *src, size_t len);
>      void strlcpytolower(char *dst, const char *src, size_t len);
>      void strcpytoupper(char *dst, const char *src);
>      void strcpytolower(char *dst, const char *src);
>      void strtoupper(char *s);
>      void strtolower(char *s);

You may want to read the article here:

https://lwn.net/Articles/659214/

and follow up some of the discussion threads on LKML about the best
semantics to advertise for the strlcpy/strscpy variants.  It might be
helpful to return some kind of overflow/truncation error from your
copy functions so people can error-check the result.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
