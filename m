Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA48762CD
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 23:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712618345; cv=none; b=VZ7SQ4P6BjCkYRo6Qr1td0jvtvCLcnYHGS9SdY6x9qNWLhtouHqTodF9FAP6ocGJAI4kAOKHqZ3XDVhe7DMG+gTFRjjx3oXY0bvFwvioCOww/xBhPoEL0J+gkcykdClqP3WiOcAwf+Xpuagi9mLFi00C+M98TfZv+YVt4LpBecU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712618345; c=relaxed/simple;
	bh=PQMQPe7JwvRgB7Nq1PucgrfKbONpXHqAhVOQ6cgCdsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQsJfqEoKNLUJyFeNXshJmmW/gylR4r+Glu0gP3arf63nzeXRIX3RSYDuA1eQD1WfWK9Lwly/GwbrXc91N13H4ViSOEDgs5dSyFjcC36bHa1C04W5TitNlWHg09MstbcI8B0Hduow6aEVeJ9j+2ZKI23umIHiJowHHjX+9trRCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bjWg5SRP; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bjWg5SRP"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ed691fb83eso658697b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Apr 2024 16:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712618342; x=1713223142; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h3mD32emJQBl2IvSe1VcXgNBzcQ7teU3gR2OBYPdgHY=;
        b=bjWg5SRP6DqVbFMF7BpLO424yer+8NwjEKkQMNg+RFMeaM1s1wE/BY62Ypr7nRfVIF
         XWIME7NcjMYGo3DdGsuAAxiv7GaEU4Jp/5RXNDZKSzKojQyKIdjFuWUCy8BCYT4Z3mYe
         ItooP02uHkeJ4Yao6I+L5syBcFlMmiJfD7HFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712618342; x=1713223142;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h3mD32emJQBl2IvSe1VcXgNBzcQ7teU3gR2OBYPdgHY=;
        b=P7Jkwv321XzJfRgUVMrZsfO3dkfKF5GXAQgKbGi4iTm8fWTIb8fSnMcbCyu2NtkSm/
         saa00AZizyn44vk1XiYs2g9rLQDa5C6MWNx5HNEwZEqM+OJHeXA7898WGMS5vojPSl/k
         sRXHl594o92fjksOksbqbqn5DWVgXGu7QmKSyyWM2aZu8v2P1RdZMWE8kIsAQofjLzMt
         ERWyNg26pR5FO/ExgFGBrl8ywRLW9JD5CkUNDPOCZUYaDTgaZaNNHgDLHI1cZ71/zrRh
         FXTQ61qwBDXd3F5Le7z6IVqid4dpZD59vnsy9VkJTDvmdiZT2FYaVFLHFTJfExHeax62
         Ba+Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/xElUkxiicEM/Pyf7tFJgH1tuQ6ly+u2GSUpoKGVzBW/bngFdrIRgyo22Jt0Yqg32/+UYGxb3JxpOOZr5EfXBD4afuT+JXC0qOQ==
X-Gm-Message-State: AOJu0YzQKhiTf9EQ2YY/VXnAFLfHG/fJRgPHoOwmuhWU1gBDVoWIfQdq
	v4k7atiqsZO9jDx+pHNhxMA2PQalIjElK2owKu9JhuMFYF2xL4fbr6JsRZrw2SGlY300cJAoU/I
	=
X-Google-Smtp-Source: AGHT+IHqssClYSKgQ3cjZ66OkUVAmh67TVCnnaDbMs5wH/wg3lt7/zh/2h+YAyxzjScWxAV7q3FclA==
X-Received: by 2002:a05:6a00:1701:b0:6e5:43b5:953b with SMTP id h1-20020a056a00170100b006e543b5953bmr10229126pfc.14.1712618342439;
        Mon, 08 Apr 2024 16:19:02 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id v14-20020a056a00148e00b006ed64f4767asm1004663pfu.112.2024.04.08.16.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 16:19:01 -0700 (PDT)
Date: Mon, 8 Apr 2024 16:19:00 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
Message-ID: <202404081602.1B1773256@keescook>
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
 <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <d45631ac-3ee6-45cc-8b5a-fab130ce39d7@cox.net>
 <CAFhGd8p=R4P6J9KoMGcXij=fN=9sixVzjuz95TLKP1TexnvV8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFhGd8p=R4P6J9KoMGcXij=fN=9sixVzjuz95TLKP1TexnvV8Q@mail.gmail.com>

On Mon, Apr 08, 2024 at 12:59:52PM -0700, Justin Stitt wrote:
> https://lore.kernel.org/all/d45631ac-3ee6-45cc-8b5a-fab130ce39d7@cox.net/
> 
> On Sat, Apr 6, 2024 at 1:42 PM Charles Bertsch <cbertsch@cox.net> wrote:
> > Justin,
> > Yes, undo of that patch does fix the problem, the scsi controller and
> > all disks are visible.
> >
> > So did changing .config so that FORTIFY would not be used.
> >
> > Given other messages on this subject, there seems a basic conflict
> > between using strscpy() to mean -- copy however much will fit, and leave
> > a proper NUL-terminated string, versus FORTIFY trying to signal that
> > something has been lost. Is there a strscpy variation (_pad maybe?) that
> > FORTIFY will remain calm about truncation?
> 
> I think fortified strscpy() should allow for the truncation, this, at
> least in my eyes, is the expected behavior of strscpy(). You copy as
> much as you can from the source and slap a '\0' to the end without
> overflowing the destination.

The trouble is with truncation. Some strings:

char longstr[]  = "This is long."; // sizeof(longstr) == 14, strlen(longstr) == 13
char truncstr[] = "This is trunc";
char nonstr[sizeof(truncstr) - 1]; // sizeof(nonstr) == 13
char dest[64];

/* Create "nonstr" without a trailing NUL */
memcpy(nonstr, trunc, strlen(trunc));

strscpy(dest, long, sizeof(dest) /* 64 */)
	=> 13 (i.e. strlen(longstr))
strscpy(dest, long, strlen(longstr) + 1 /* 14 */)
	=> 13
strscpy(dest, long, strlen(longstr) /* 13 */)
	=> -E2BIG, we saw that "." wasn't a NUL
strscpy(dest, nonstr, 13)
	=> -E2BIG, we saw that "." wasn't a NUL
strscpy(dest, nonstr, 14)
	=> fortify error, we can't examine the char after "."

If we used sizeof(src) to try to work around the off-by-one, we'd
suddenly lose the ability to detect actually corrupt strings, because
we'd silently start "accepting" strings that were exactly sized off by
1, and gain ambiguity in our handling.

> I think Kees has some plans to address this as we spoke offline.

But, this use of strncpy() *is* another "legitimate" use-case. But like
the other strncpy() uses, it is ambiguous. So, I think we need the
reverse of strtomem(), to take a "maybe NUL padded but not terminated"
character array and unambiguously construct a NUL-terminated string from
it.

I think something like this, memtostr:

diff --git a/include/linux/string.h b/include/linux/string.h
index 9ba8b4597009..5def02c7c0ce 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -422,6 +422,30 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
 	memcpy(dest, src, strnlen(src, min(_src_len, _dest_len)));	\
 } while (0)
 
+/**
+ * memtostr - Copy a possibly non-NUL-term string to a NUL-term string
+ * @dest: Pointer to destination NUL-terminates string
+ * @src: Pointer to character array (likely marked as __nonstring)
+ *
+ * This is a replacement for strncpy() uses where the source is not
+ * a NUL-terminated string.
+ *
+ * Note that sizes of @dest and @src must be known at compile-time.
+ */
+#define memtostr(dest, src)	do {					\
+	const size_t _dest_len = __builtin_object_size(dest, 1);	\
+	const size_t _src_len = __builtin_object_size(src, 1);		\
+	const size_t _src_chars = strnlen(src, _src_len);		\
+	const size_t _copy_len = min(_dest_len - 1, _src_chars);	\
+									\
+	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
+		     !__builtin_constant_p(_src_len) ||			\
+		     _dest_len == 0 || _dest_len == (size_t)-1 ||	\
+		     _src_len == 0 || _src_len == (size_t)-1);		\
+	memcpy(dest, src, _copy_len);					\
+	dest[_copy_len] = '\0';						\
+} while (0)
+
 /**
  * memset_after - Set a value after a struct member to the end of a struct
  *


I've also identified other cases where this pattern exists, so I think
we can apply this and any needed fixes using it instead of strscpy().

-- 
Kees Cook
