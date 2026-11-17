Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794901769;
	b=l43umormCpiXE5AqqTrurPirAngBUWvCpJ6lMQahrc1l48fIBEH2HNk75z4Ut3cNwZe5
	 eJli7Wn+K/PRmiiOn9hM4Dnixjm6kJ6xQfsMYmw8ChPqcpKC42gxqQFQD/DGZyYKToQix
	 OG51HjiB/Zw5SAflk8uSjZYfK3lDjih9U3WP92oad0AvbN07De7VE0WdZT4ulQJiArjYu
	 LsQoHo6KqmitDt5gErgXbCeNV+tsU1gtewPNU/VFT2sPOiP9tYue1wFIYn8OEzV/5J4z2
	 t+MgAI5niBAsIzXr9GeO7WBU3yGD/f/xunECf2C7JRz+MES50QBRL9Zup+DBsV8/czQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794901769;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=d+EOPxqwkWZ2cHqsa8jpQYbKGkkd/ZQjRhVzle3euG8=;
	b=lG7DTo46jcuZNJh04jSGYMNcrfs3w0z7v7F5BQlh9PkzzJBrdcYauWdUSiVfWiYq7pQx
	 50jfQTNy3xLtu6B3fiQPWjm0k5pahVDV3Ko50/120QHg44HHy/aCGNOiNyAZe692yL/lz
	 ma4/oRY5hYUlMFNXXBZGm5eBCcWolgYeJnt+v7apjNVHtfZb7tTqwf6n3VcShD2sNI5au
	 ak48jhLMMN0Mv6L68Hxj37w5zrKHvH8jUcqqWHq5WNj0ZSmkDSeUms599Ep2y4h7BGhk7
	 uq/bB+iUCiSBXMpDVuCsjE9M+h07dHlIZLl1RkdWijAfOyrNc6t1whdPBgLo++8otrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fn3zyQbP;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=V2zpJBbT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA93606A31C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 07:49:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AA93606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fn3zyQbP;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=V2zpJBbT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794901766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d+EOPxqwkWZ2cHqsa8jpQYbKGkkd/ZQjRhVzle3euG8=;
	b=fn3zyQbP5CjaQeYk4kOavU5y0jdecuYGthfJ43Z+WL+c7El0EN9sQWahjBTM1+9rpitRK4
	OiicYBcyTkpdJgeoCkWidkTF3+R/G9Ic+zQUuL0C5B1Gmrw0pbUJx8G/AgqtgvuodnkTCs
	Jqh3KlQ5fCAYGcDYSk4L7OyxrLefKlY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-nI9KuBK5OnCMVXuPU31jqg-1; Tue, 17 Nov 2026 02:49:22 -0500
X-MC-Unique: nI9KuBK5OnCMVXuPU31jqg-1
X-Mimecast-MFC-AGG-ID: nI9KuBK5OnCMVXuPU31jqg_1794901761
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3adfb744fe7so3821841fa.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 23:49:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794901761; cv=none;
        d=google.com; s=arc-20260327;
        b=qZQQXEWXUc0A7IgMdEpkVJagOtv/fgjl6I46hk/e8M4Rc6cL4+sdkT1acLvPTjKFwn
         g+2AWYVpAlvlv4z30lxyKGWT+D/0xg1ly3aNiouFQKw+xH+g7MwIhpOv0/30hnXHBYqT
         aYiE4uwRwkZQYPK8Bllw1Q64eNc83Q8ylCp6yxI5CrSsfYVsJtox3wru6BVMCmcNyHVC
         piNTosAoU0a374o2S/r8O99S0r+nzCD2+kC7QuK5+NVayHO6gQTlskpWeYy/Ngs1aOG7
         Zx1jWwNc9FAGG7Wn9l/0TrZiATaTXuobbH18iz+d3CPDCiRbjbzG4VYyhXt3nSAkT9ij
         eh0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d+EOPxqwkWZ2cHqsa8jpQYbKGkkd/ZQjRhVzle3euG8=;
        fh=u/+n3v/VP47ZxiXEB5hX3PwZlrDZKaJv/zNdi8NMG/4=;
        b=BHjBuqoXJjv9ntklswMuQhjYgzeYhW3SIw8chKwkpPngcMhP+nuohF+Nr+zTHJU+QM
         FtAYxbHR4cckbUxrRkj/QdpGmE+KQJZ5lFME0HsVdjk/d9OkABYSiGpFjgcbN/iPJUTx
         +29qqHIq2QZDh87u/tZgqs8sIMlp+flSsoyTspkHKjzKv3+RfaJIvxVDotl1a7rw42GN
         K0WoESpYhl01hKO4FfJCvjjLB6cMh1jbQ2/OZkOGTx6jssVA+oaPzlodpkPhnk4mOdJ8
         U3zOwjxUuM3FlSMQq+2AKvyy8adnNErn9QaGwPbATONKBj/VkjJMcUlIWyjX3ksZkzsW
         5owA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794901761; x=1795506561; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d+EOPxqwkWZ2cHqsa8jpQYbKGkkd/ZQjRhVzle3euG8=;
        b=V2zpJBbTXxkyoGTreMuJ14euKVod122hAysL1cy2Pp7qNhi6D5bJG9decyEleDU/Aa
         58UkFi8590j2zxCjtbk9BMl1zKZzkaSYQUlRjIdSaM+BjhAYLMpT0a/2NkgHlGzcrp4f
         2Fikgu8USNCNL8lGXOZZ5Z3kW0KYd2st2+AydGRththFRS+3WhWpzoTYZz/5DlVciS5W
         WSiC3BwGDT8/wWkYUcJrG3AtcnCs6ttN2tN8aoImaoYmexbYxVL5MKExZnsmxQVCr/6B
         Qy05q7yFqoG3J5ePSrhu9PGOMsb58qWBjE/DP+hLcvT/eBuej9EES+btxked85b1cocm
         0yLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794901761; x=1795506561;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d+EOPxqwkWZ2cHqsa8jpQYbKGkkd/ZQjRhVzle3euG8=;
        b=MihRmfV8Jfydlwecb5U71PSRUZSRTMZU6MS1kB5FYDu3aMQWxxpdoV9MVyJV/RGuCe
         7JXi9FQxlyo21y9ZUjqpy8IEs932hlLaDpTWvv3dt+7q8qATQAIwNpkY6m61ZOcvALE8
         50BJ1sstn5sedZygEHzowDVt9z3x+OHIE8ejzbLqVLj7BZ8hpLWOCPGcRZgkrkRQi5eM
         514Tn1dMCP2XHngquKe7Go6rOeUF5yb2BBQGTDNPIwwmktyBHhTtBHLQlRw1UPtGwsGR
         v384+eu71kxcTOwk6oLcBhOoYk4+48vzkG5f8aiMxE6/iKqEaQCWwK8moXjTzVp0LPuv
         S8rw==
X-Forwarded-Encrypted: i=1; AL+hErF6wZGbYTyCS2fYYtjOeVOBUha0GSJv8IRNkNIsOi1JuSVNrTHlX8Xl0igaddrvkJGqlVOiNCpwH20v@vger.kernel.org
X-Gm-Message-State: APuU4Z+lsx68wiVwGVv+eKngPAnbidsDr4EzdibIq+aaKEx9nq+A8yi/
	4ygZ8d6QrJsTW+czFAbiz9DeM2VvwG9/wE2OmfH/CYJedEhOG2sx2aH2E2ptk6pvyzFtRYClpY0
	9+GCdYTVcKZB+NphK0I/nlrWoBjCD5uYKt/wqP6gZ/ERmYtAEQEXwKHhLucyFhrfZNIrBDO+y03
	5gbiMw2lZC+Q5QT1IsAGZYgOZQgnE/xIv/AplC3Q==
X-Gm-Gg: AYBFou3rgUQifIDLQ2uBNfr65AIerLjopArf4q/qiL/2TLygMDi+YML94XftpXh2mJz
	K6T6wwlxiUGE4AStcNDIz80tuLV1oCYBkDRsDsNEDYkt7mj6+qQeAk10RwXTeLWY2KTynE9Q2Lm
	kElQ2eQ7vL4J2r0toW4wQVgQlM+8LaB13Hb3R+WedT3lXYT0eAaom03qyq
X-Received: by 2002:a05:651c:4414:20b0:3ae:1073:570 with SMTP id 38308e7fff4ca-3ae2b38d801mr30812031fa.0.1794901761052;
        Mon, 16 Nov 2026 23:49:21 -0800 (PST)
X-Received: by 2002:a05:651c:4414:20b0:3ae:1073:570 with SMTP id
 38308e7fff4ca-3ae2b38d801mr30811681fa.0.1794901760567; Mon, 16 Nov 2026
 23:49:20 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-ufs-rtc-query-retry-v1-1-4de69b175e8d@redhat.com> <780f3f4ceacd7cf078542c9a8a4c8c8dba9666b0.camel@iokpp.de>
In-Reply-To: <780f3f4ceacd7cf078542c9a8a4c8c8dba9666b0.camel@iokpp.de>
From: Enric Balletbo i Serra <eballetb@redhat.com>
Date: Tue, 17 Nov 2026 08:49:08 +0100
X-Gm-Features: AclHuK8oY8bBLMyg0w_iWRcoEI_SclPw8SCGmbuuZYp9-Co4zfSo7Au867IO_8Y
Message-ID: <CALE0LRs_nkDT_NQfNw31F0hdnEyUko2LzmHpmM4RFh09dkysxA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Use ufshcd_query_attr_retry() for RTC update
To: Bean Huo <beanhuo@iokpp.de>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Mike Bi <mikebi@micron.com>, 
	Avri Altman <avri.altman@sandisk.com>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
	Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, NXP S32 Linux Team <s32@nxp.com>, 
	linux-arm-kernel@lists.infradead.org, Frank Li <Frank.Li@nxp.com>, 
	Larisa Grigore <larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 16, 2026 at 11:28=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrote:
>
> Thanks for the patch. A few comments:
>
> On Mon, 2026-11-16 at 14:39 +0100, Enric Balletbo i Serra wrote:
> > ufshcd_update_rtc() uses ufshcd_query_attr() directly to write the
> > bSecondsPassed attribute, making it the only query attribute caller in
> > the UFS core that does not use the retry variant. All other callers use
> > ufshcd_query_attr_retry(), which retries up to three times on transient
> > failures before escalating to dev_err.
> >
> > This causes spurious error messages during boot on some platforms when
> > the write-attribute command hits a transient OCS_INVALID_COMMAND_STATUS
> > error:
> >
> >   ufs-s32n7 4ac80000.ufs: ufshcd_query_attr: opcode 0x04 for idn 15 fai=
led,
> > index 0, err =3D 15
>
> this is printed by ufshcd_query_attr() itself at dev_err level, so it wil=
l still
> show up with this patch. Could you share the log with the patch applied?
>

I assume I got confused because after applying the patch both messages
disappeared, but what you mention, and sashiko also pointed, is right,
from code I should have still see the  ufshcd_query_attr: opcode 0x04
... message

The fact that I didn't see those messages after applying the patch
likely means it showed a case where the first attempt succeeded. I
didn't perform a lot of boots.

> and err =3D 15 is OCS_INVALID_COMMAND_STATUS, the value the driver puts i=
n the
> UTRD before sending. So the request was completed but the host controller=
 did
> not update OCS. This looks like a host side problem? not a transient devi=
ce
> failure, and a retry here would only hide it. Is this SDB or MCQ? Does it=
 only
> happen on the first RTC update after probe?
>

Answering your last question, yes, it seems to happen on the first RTC
update after probe.

Larisa mentioned there is a known errata that will be documented in
the future that could be related. We should probably wait for that
errata to better understand the problem.

>
> >   ufs-s32n7 4ac80000.ufs: ufshcd_update_rtc: Failed to update rtc 15
> > Switch to ufshcd_query_attr_retry() to handle transient failures
> > gracefully, consistent with every other attribute query in the driver.
> >
>
> ufshcd_update_rtc() is not the only caller without retry. ufs-sysfs.c, uf=
s-
> hwmon.c and ufs-txeq.c also call ufshcd_query_attr() directly, so the com=
mit
> message is wrong.
>

Right, I used the wrong wording here and made the mistake of only
looking at core/ufshcd.c, not the full core files.c not the full core
files.

>
> > Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
>
> > Signed-off-by: Enric Balletbo i Serra <eballetb@redhat.com>
>
>
> I would like to understand the root cause first.
>

Agree, let's wait for Larisa patches.

Thanks,
  Enric

> Kind regards,
> Bean
>
>
>
>

