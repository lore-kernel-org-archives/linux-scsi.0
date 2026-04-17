Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA072D73A0
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 06:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776407128; cv=pass; b=Tg3PYYd9sGgPS/6lKM2gVuzA1IkJavr4Esl1AI3DbSI3MxwHJXGc4jmNpEvwpofOo8/zp8b0jKSr2a2Mcx2ZfYOQBGtivvtWjcvPGUqcjK+rp84JxcS73GOiKiw0VgYEJrtmDNhUTNNZowmQTkoqIDws4BqPNd1J0D0zvUhuJ9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776407128; c=relaxed/simple;
	bh=GQICckAKjLzrssi5/n/p/RByLwIZn3HWZrGojwIYRR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UK2UDhaJ+7Jtts91k70q0Wlt1hskUDOuyxbuQPST2lHSSNML6RZXd8xVUoAyuvvnWJFXIx0TNpe5TUhHOae/9jh622nCdbnsO4CDx9ZLiQI4W/18XKEy8GzeWMUYi6T1F+XdF2c3QRS+PR7raMugyZ16af/ETQ44h9v/n36EnvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DQdq2n9W; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQdq2n9W"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6530287803cso333620d50.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 23:25:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776407126; cv=none;
        d=google.com; s=arc-20240605;
        b=HU2XkviUQpwTNo192De4Zsi8CuepdRujajPIj6BosfT9AwxzPVnodGvXoHIJFuwzj6
         GZ5LNZGoGEmmgapeEBC6GZm0aY73EbWQRQ50uKBBbn9n/Gak7kyIy4d8AHD2PBDR7uJ6
         +078aB5uhrTBsj+37MamloPPchPPKHjupm8IFxLdzPHph5BM2zfCjZwTg29Pi4G4c4R8
         z1oa3/VmurFrNs0MZGfowIu5EOgOjwDxWjpkjcUdVhIzivti403CGzIDOeJguNr44esG
         VqbSggCZhPb6M72+/rG44wcflYXapZQTfZM3NkbC3p8hu7hcxuEjsC0DGWT3Job+lkUB
         zIxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GQICckAKjLzrssi5/n/p/RByLwIZn3HWZrGojwIYRR4=;
        fh=cHtsbgfqUhxPwYFz4/6tky2XKFh8ouYbyY8OY1SwKBk=;
        b=ZgZ7da1PEJekLWfd+s2E/BgRkIwHkduy6aVfHBtTi1NSIwDKMSYpBUCo60JmqKuZSc
         PtpUz2AlFggiUeoQbOsqDuwgGhz9OjiC82x5dUpgQmkSxrq08jYY9fGfdM7r3MteBZwq
         hqXH4cJ9cAuApHNWo8Z0l4JpE5NKCVHD5MD/jwPRIoBDNrHuiql0tgF8buIjScIv9/iq
         B4mMddZC72wsgKvTfLmk+1oeWbHaf2lz98AySn43HQcuU0rH/GKyFpB7ZCG6+5t6FRHq
         wz2THi556s/VzO+wgfS2dWAbqHrW8kf7ZR98B1iVI6LfOMZf81nmauYg7ay/hOi3q5lK
         /ITQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776407126; x=1777011926; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQICckAKjLzrssi5/n/p/RByLwIZn3HWZrGojwIYRR4=;
        b=DQdq2n9WUlaLuBCam0pdqbcAbBuaZhtuUO/ATN+y2gsQRhK5+qtuRzHVMbk1uaAaz3
         1DorF4Gi0WmHR7X4x5UTeQvwiYtpYwsKSfEK89V7aVTd4lL/hpPK4EsIryxo1lupDzh7
         M9BzUA9iI6QlSzOn1Yd1C0lOo8UmRqV6WVqb0NvlyAAi0OsD4xHxZqSr+b89l2cguQ53
         R2M6a6idlNPFiSC2rDMRkTtgVk8OsXt9Y/thq+RxtDpDE66W/PUH4ghbJH9ifHHdHNax
         VE/N2onrEwDpdtrG8ORFVsRBSn0ERH2bBcNAKAOa5UWxK/xMZlzuzVTW9lH+WenPYVNA
         bKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776407126; x=1777011926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GQICckAKjLzrssi5/n/p/RByLwIZn3HWZrGojwIYRR4=;
        b=Upb8qv/S9f0FXDuJtUFy3Yftpdp8flfCzAwFtNBQh7gtuyj1ojLktmMwAR6cTBbkaK
         /beDoaZ9gVvR8oSrNyabQ0H6jr90WKdOmE91xzVv6jDDoTjhLN4W47gZeT5xBmouc5kl
         OSrggj6xvqeo0VJ3/q4UX+t+neMHIq8p9HRRXP4v/3csh8C/zTQ6xra6pqr1k5Fq2c+E
         YqVhWoN/jtE9LqeEm+21JGRRRAEx0XVudM/0r1RsdPhqUWNhJ2KvjtJ3wmSe4Opr3gkG
         RRFUPy59r6/sZcVpZrkMZw5uK1wnvW5EIrlq9sPxG2E9GRIS8GXTZZRF078NsgwuOzQ6
         yisg==
X-Forwarded-Encrypted: i=1; AFNElJ9It36fkLYYXc8s1MRSRlIuHEMfL+Sc/4+jtGS0gLdbxz3uFDxhcd1pyZdWmT9AfYax96UGBX/GCaHB@vger.kernel.org
X-Gm-Message-State: AOJu0YwOGwudNpa8/VP+44PLoEglvGw5w+dhgJL3aiadngajZcL4tOmr
	r5ugSTYmHop1x+JqjQXe6ESfWuRedoDsmXlLz4MgE0ds7kTvRkclpgfEmHhzdTRBzHEUeQdh0VG
	OVQeLf/mJejrebo7iIApOQda/a1yOx755iZOpVAC9fQ==
X-Gm-Gg: AeBDievJ/+tYhy1lMyfLu2OrMfV/MN4Lv7eP/4kSsAGpD26ByvwGkIX1RLqZQqyTFZW
	0vKOkxrMP+PQoVyXW7Lk5P4ImSNjBl0mwcZ0kIFUAAqaBDUH9JbqgF9duoRaH3u570yKaP19W8u
	vo+M9+ebF/9iHDSWz6UzgYywiKfRAd/ULJYK01ov7BfJdfWI6Vz+8onIsp4vtPUw6cCVvNbEXaL
	z5ZyanRStdGXofmt4s1hhjQhFifLnl5HcEsXu6E69znY6fz52wNzKC/9WQySX0fudsaNr67P1JL
	JFxHS9FNBOT4luxrxTRM
X-Received: by 2002:a05:690e:4289:10b0:653:285:d180 with SMTP id
 956f58d0204a3-65310a8fbd8mr1124657d50.61.1776407125978; Thu, 16 Apr 2026
 23:25:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416165935.3958686-1-lgs201920130244@gmail.com> <aeEfqbaI6LNObJAC@casper.infradead.org>
In-Reply-To: <aeEfqbaI6LNObJAC@casper.infradead.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Fri, 17 Apr 2026 14:25:15 +0800
X-Gm-Features: AQROBzAWhi0EQ1TZMfMFXO9yfwCQdkrn-vbSB6OUbjnZ7VolNnyLb6shB7Qy1ZI
Message-ID: <CANUHTR-BAvcRGy8YBMx0tgS4HLDTdMH1JkkLM97Sk6JO7JiUnw@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] advansys: fix host resource leak in EISA probe
 error path
To: Matthew Wilcox <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@steeleye.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

On Fri, 17 Apr 2026 at 01:43, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Apr 17, 2026 at 12:59:35AM +0800, Guangshuo Li wrote:
> > A manual code audit found that advansys_eisa_probe() frees saved
> > Scsi_Host objects directly in its error path.

I understand the concern. This issue was found through my own manual
review of the error handling path in `advansys_eisa_probe()`.

Specifically, I first compared the error handling path in
`advansys_eisa_probe()` with the normal cleanup path in
`advansys_eisa_remove()`, and noticed that they release saved
`Scsi_Host` objects differently.

In `advansys_eisa_remove()`, each saved host is released through
`advansys_release(shost)`. Following that path shows that
`advansys_release()` eventually releases the SCSI host through
`scsi_host_put()`, which drops the embedded device reference and
invokes the SCSI host release callback, `scsi_host_dev_release()`,
when the reference count reaches zero.

That release callback does more than just `kfree(shost)`. It also
releases resources associated with the `Scsi_Host`, such as the host
IDA index, `shost_data`, and other host-side state managed by the SCSI
core.

However, the `free_data` path in `advansys_eisa_probe()` frees the
saved `data->host[]` entries directly with `kfree()`. My concern is
that this bypasses the `scsi_host_put()` / `scsi_host_dev_release()`
path and may therefore leak resources associated with the initialized
SCSI host.

That is why the patch changes the error path to release saved hosts
through `advansys_release(shost)` instead of directly freeing the
saved host pointers.

I also noticed that I accidentally removed the final `kfree(data)`
while preparing the patch. That was an unintended editing mistake, and
if the proposed cleanup approach is acceptable, I will fix it in v2.

> I've been told all your patches are AI slop, I'm not reviewing this.

If possible, could you please share what your assessment is based on?

Also, if there is any technical issue with this patch, I would
appreciate it if you could point it out concretely. I=E2=80=99m happy to
revise the patch if there is something incorrect in the analysis or in
the fix itself.

Thanks,
Guangshuo
