Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C9312834
	for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 08:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200136; cv=none; b=S52SkT6qNnFWSebV6vNccXYxrtMp2SxCm+hsZGpT61eBfRs5S90AQmANqmSnU5QIGh3OJxm+r6b632AvjmDlVR8kcQ9Rj7Q5j76NPUfJQIgk0NSp4oiO3dt3z+arc4lBrg+ShaYnAfgk8LEeIjmsBpEP8OsscqSfPw3F182slRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200136; c=relaxed/simple;
	bh=KPQCrb7pjA1fhvHYn7pUmUWaxJoAAPefqmz3Grwf7pI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uxgrnrKJhGvVa7wemD/NLlh8OYzYBwSIXKn2qI/VcQk699IBBSY1Wcz53hUppuX/FM85ySVKcMuS+/CXKra+6okFPwf3UbkKQZMWihoCtZ6ea0DVEW+Pq136P6DmJPUNzUKYEB4JsobKlHNpRxHay/Nl0Z128B4jAjKCfHKGAEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8r0lXvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8r0lXvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16871F00893;
	Sat, 12 Sep 2026 08:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789200134;
	bh=4gne8kza6sFfCC+UoUu0fGjwlTSBh/7kZHxxYlS1SbQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j8r0lXvISHKiHI2xn2pEuu/9OpjIXYKvGg1uhm1k1e7Cq2kjiWWgWQwpLA6xf1eV2
	 MKCcWCvSzW5vv55DWbkWQ1Hl2Pm948PNr0cVW9dQH7CMWsencXKljaFri2EMw/4x0H
	 wWNY+ETQJZDkaix2txCj18Ab9pZbHgwIJd3PbAg/jPK58O1u75vEV5c2WiPdeq0W+X
	 ESFoTfzztKPcnsM3nbzIpD79vKkm2zsYro3BdeGkd/TlyJvg0j06TEtvBwu9Ml3Syc
	 DTMm9xMDsC4hWsJAbaYKNjgv5D8IcjqlJEz7p3n4Xz88y4YBfPSS5K6CAesrq1J5O3
	 BX+LJgC8PaypA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] scsi: scsi_debug: Drain RCU callbacks before module
 exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yibo Tan" <lhfff@tju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260912074737.972055-1-lhfff@tju.edu.cn>
References: <20260912074737.972055-1-lhfff@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 12 Sep 2026 08:02:14 +0000
Message-Id: <20260912080214.B16871F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The RCU-protected pointer `err` is dereferenced after dropping `rc=
u_read_unlock()`, leading to a use-after-free.
--

commit b240d3e53ad8297843c17afca537b20b652bc674
Author: Yibo Tan <lhfff@tju.edu.cn>

scsi: scsi_debug: Drain RCU callbacks before module exit

Replacing or removing a debugfs error-injection rule queues callbacks
through call_rcu() during device teardown. This commit adds a call to
rcu_barrier() in scsi_debug_exit() to ensure all queued callbacks
finish before the module text is released. This prevents a crash when
executing module unload procedures.

Link: https://github.com/kimaiden1984-boop/linux-kernel-poc-collections/tre=
e/main/cases/scsi-debug-rcu-callback-after-unload

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -8844,6 +8844,7 @@ static void __exit scsi_debug_exit(void)
>  	sdebug_erase_all_stores(false);
>  	xa_destroy(per_store_ap);
>  	debugfs_remove(sdebug_debugfs_root);
> +	rcu_barrier();
>  }

While reviewing the RCU changes in this file, I noticed a separate issue
in sdebug_fail_cmd():

drivers/scsi/scsi_debug.c:sdebug_fail_cmd() {
    ...
    rcu_read_unlock();
    goto out_handle;
    ...
out_handle:
    if (err->cnt < 0)
        err->cnt++;
    mk_sense_buffer(cmnd, err->sense_key, err->asc, err->asq);
    result =3D err->status_byte | err->host_byte << 16 | err->driver_byte <=
< 24;
    *info =3D *err;
    ...
}

[Severity: High]
This is a pre-existing issue, but does dropping the RCU read lock before=20
dereferencing the RCU-protected pointer err lead to a use-after-free?

If a user writes to the debugfs error injection file to remove or replace=20
a rule, the structure could be freed concurrently. Since the reader drops=20
the RCU read lock before it finishes accessing err, could this result in=20
reading from freed memory and returning corrupted sense data?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912074737.9720=
55-1-lhfff@tju.edu.cn?part=3D1
