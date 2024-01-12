Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2337867E79
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 11:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Uy9n+SP1"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-50e759ece35so7127308e87.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 03:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705058840; x=1705663640; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Kp9FulKRwJjGJrCfGRUMhfQ4anea3Zsj5cwNQp7FQ1o=;
        b=Uy9n+SP1XKmF1tfPZ3iFvSOjnYvf1jqqFfX4UikpzG4sj/uv82E0tB3cC8VO8KWsfR
         bvIsTaYp1ama0zCyf2wGEDJaHMWn3YOl79qyN7Lu1gk3tLM3xdANHiUJ9VO/hgv6GTRL
         6RbMCKxjOhGHFUidl26NCupWqZxveE3CcHK8aHrgKcWHZ5J/3DMLeynGqY3NUVrQArNr
         FL0a5NEG5YAmmKsDi1mTFskDuE1lmoD/OKnAp7Q1Idm36gzxDeJH8xdSHrzs71/8cWDL
         FAsgxQFCK5a3f7WoXPvXVheWgdty+2kekGU4RkVYpWXt17krNgtpjV9cMR4lwD/LwXk/
         3Qng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705058840; x=1705663640;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kp9FulKRwJjGJrCfGRUMhfQ4anea3Zsj5cwNQp7FQ1o=;
        b=Wuxtxc7PoX2zPm1JDhCKfOUtf2+GTnk/r0MEXnSTg3jKBjU+VbIoilD03lURy5uIPt
         hBux2kSvfHUtMiuocJCPA3pI+zQI2ll2+puqEyTxnPSWOFHT6Yp5+Duxjs8GJIAImZyw
         z9ZUpqOcXKkFiXH+6JYgQVWn8gn5U71sG5nF5jb9EwoaHb6ldiIN4DDShFT7LNzT73N7
         689I4G0qdkTc5ldoJK09kkScX7r9FCnArYCbXVsOnSpuGdESJ44DE65JABroq16Ss4+q
         cgXa6BenR6uPGHpFyJc3QQQA61cIDojQX8uQ7uG9vAg788IaNsOsdHCCtokKZ+MD8E+g
         HZEw==
X-Gm-Message-State: AOJu0YzmZtxz8U3aX6Q9howptMKfNo27xpv8g0FNoX3RHVzsb0Zkx9hB
	PpF/gAYrpOWTh6b0GRm45has6adbMkcYfQ==
X-Google-Smtp-Source: AGHT+IEdm8/GPp0AdnSxj/uKrOpzaNKDqHeAMpe1tqTwKfK94JJn3Q4glasMtgvGdF95sowmMK9eOA==
X-Received: by 2002:ac2:5045:0:b0:50e:7e53:8f6b with SMTP id a5-20020ac25045000000b0050e7e538f6bmr487449lfm.127.1705058840084;
        Fri, 12 Jan 2024 03:27:20 -0800 (PST)
Received: from alley ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id j25-20020a19f519000000b0050eb25590ffsm472095lfb.207.2024.01.12.03.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 03:27:19 -0800 (PST)
Date: Fri, 12 Jan 2024 12:27:17 +0100
From: Petr Mladek <pmladek@suse.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Down <chris@chrisdown.name>, oe-kbuild-all@lists.linux.dev,
	kernel test robot <lkp@intel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: core: Safe warning about bad dev info string
Message-ID: <ZaEiFXscVBdOJEeI@alley>
References: <20240111162419.12406-1-pmladek@suse.com>
 <CAMuHMdW1XyimybybSwAfwgzeUyFj6riRZZZzQK7zjTVUJziX-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdW1XyimybybSwAfwgzeUyFj6riRZZZzQK7zjTVUJziX-Q@mail.gmail.com>

On Fri 2024-01-12 10:22:44, Geert Uytterhoeven wrote:
> Hi Petr,
> 
> On Thu, Jan 11, 2024 at 5:26 PM Petr Mladek <pmladek@suse.com> wrote:
> > Both "model" and "strflags" are passed to "%s" even when one or both
> > are NULL.
> >
> > It is safe because vsprintf() would detect the NULL pointer and print
> > "(null)". But it is a kernel-specific feature and compiler warns
> > about it:
> >
> > <warning>
> >    In file included from include/linux/kernel.h:19,
> >                     from arch/x86/include/asm/percpu.h:27,
> >                     from arch/x86/include/asm/current.h:6,
> >                     from include/linux/sched.h:12,
> >                     from include/linux/blkdev.h:5,
> >                     from drivers/scsi/scsi_devinfo.c:3:
> >    drivers/scsi/scsi_devinfo.c: In function 'scsi_dev_info_list_add_str':
> > >> include/linux/printk.h:434:44: warning: '%s' directive argument is null [-Wformat-overflow=]
> >      434 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
> >          |                                            ^
> >    include/linux/printk.h:430:3: note: in definition of macro 'printk_index_wrap'
> >      430 |   _p_func(_fmt, ##__VA_ARGS__);    \
> >          |   ^~~~~~~
> >    drivers/scsi/scsi_devinfo.c:551:4: note: in expansion of macro 'printk'
> >      551 |    printk(KERN_ERR "%s: bad dev info string '%s' '%s'"
> >          |    ^~~~~~
> >    drivers/scsi/scsi_devinfo.c:552:14: note: format string is defined here
> >      552 |           " '%s'\n", __func__, vendor, model,
> >          |              ^~
> > </warning>
> >
> > Do not rely on the kernel specific behavior and print the message
> > a safe way.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202401112002.AOjwMNM0-lkp@intel.com/
> > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > ---
> > Note: The patch is only compile tested.
> >
> >  drivers/scsi/scsi_devinfo.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> > index 3fcaf10a9dfe..ba7237e83863 100644
> > --- a/drivers/scsi/scsi_devinfo.c
> > +++ b/drivers/scsi/scsi_devinfo.c
> > @@ -551,9 +551,9 @@ static int scsi_dev_info_list_add_str(char *dev_list)
> >                 if (model)
> >                         strflags = strsep(&next, next_check);
> >                 if (!model || !strflags) {
> > -                       printk(KERN_ERR "%s: bad dev info string '%s' '%s'"
> > -                              " '%s'\n", __func__, vendor, model,
> > -                              strflags);
> > +                       pr_err("%s: bad dev info string '%s' '%s' '%s'\n",
> > +                              __func__, vendor, model ? model : "",
> > +                              strflags ? strflags : "");
> 
> Do we really want to make this change?
> The kernel's vsprintf() implementation has supported NULL pointers
> since forever, and lots of code relies on that behavior.

Yeah, it was safe even in the first git commit. And it was probably
safe long before.

Well, I can't find easily how much code relies on this. I would
personally do not rely on it when writing new code.

> Perhaps this warning can be disabled instead?

IMHO, it is not a good idea to disable the warning. I believe that it
checks also other scenarios and can find real problems.

Also I think that compilers are getting more and more "clever".
So keeping the "suspicious" code might be fighting with windmills.

Best Regards,
Petr
