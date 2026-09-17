Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6FB4D7D5F
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650772; cv=none; b=addvFs/Uf0m3idxXJGnSFcva+QBPwHb4Ol+P5hSXLpoC2Hx4jvOuJS9hF3cugpVYeixx7l41Cn74cSbNwEC9EcPb1TmasOEoeo9YzeD1cd6G86uBPjkQ4PQ7PxoHIrMfFHDnqx21ll1ZyBenFIH4YMJt+KvzI7GhqmNBU+ZbKwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650772; c=relaxed/simple;
	bh=HmX0q5c651o5pUNi+Gvxswc4t9HwAij0rANwXByERHk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rjWQaW5BJ97xpsK9xJgoEIu+n2oVJBw8gTV9nstWiSmdFn9g3bl2W0QVjMmFUPu1pkYp1gn/jM3oSr9kEsUWqltRSflLkhXfrNnL1eoJCr92/I6jVUUm02w3QbX1KL6XBwM8531iPP4SFTmoa5L1JAWaFM2PWfrzGuD/83ilUlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ffogQLzE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ffogQLzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445AC1F000FF;
	Thu, 17 Sep 2026 13:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650771;
	bh=stT5z7xXMQZZ55AUCWjY0JrcYXPPShk7SzBm2irJH9A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ffogQLzEOT2tXqI5b3uRf3hUidJ817AHRKpinOWbBf04rU/4IEd5ULk5943lPGAJI
	 eEmPwnsA2JHIAHHw8bB2xU5nuHtwPtrBMjXVkkDPhrsugNJU7q1rjXeEyPTkV47XWe
	 GBihe9P0CBGEeFpTt9gPGT9n7GboEVTDQ2sl5pZzAP53Wv0uJVY2ThxqPeXrKEb+Lq
	 S+K4J0YsXZn4Kebv9gvYA/7REk7+Zfu3zBncXoqyo1yhfvHYnDFAO8fnSOuR2EnxuE
	 4qaUQcrZX7j6JMbHqVufDP6ztGTs6TwmyW+SWhCy5c50BZKuSbY8r/rKysGiyb09FO
	 UD9nQUWEFRiwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/6] scsi: scsi_debug: Map the region written by
 WRITE ATOMIC (16)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917125445.1376493-13-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-13-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 13:12:50 +0000
Message-Id: <20260917131251.445AC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi_debug: ABBA deadlock between resp_atomic_write() and resp_com=
p_write()
- [Medium] scsi_debug: TOCTOU race in resp_atomic_write() via double evalua=
tion
--

commit d00845f77d0b11824b6bd723b3a99d9e2026b838
Author: Niklas Cassel <cassel@kernel.org>

scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)

When logical block provisioning is enabled, commands that write user data m=
ark
the region in the provisioning map. WRITE ATOMIC (16) leaves the map untouc=
hed,
so this patch calls map_region() and takes the metadata write lock across t=
he
access.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 64f32d97455d6..33f2df26e5af7 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> @@ -6228,7 +6229,18 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>  		}
>  	}
> =20
> +	if (scsi_debug_lbp()) {
> +		sdeb_meta_write_lock(sip);
> +		meta_data_locked =3D true;
> +	}
> +
>  	ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);

[Severity: High]
Does this code introduce a lock inversion deadlock with resp_comp_write()?

Here in resp_atomic_write(), the metadata lock is acquired before calling
do_device_access(), which acquires the data lock:

resp_atomic_write()
  sdeb_meta_write_lock(sip);
  do_device_access()
    sdeb_data_lock(sip, true)
      sdeb_data_write_lock(sip);

However, in resp_comp_write(), the locks are acquired in the reverse order:

resp_comp_write()
  sdeb_data_write_lock(sip);
  sdeb_meta_write_lock(sip);

Could concurrent execution of write atomic (16) and compare and write
commands to the same target cause the scsi processing kworkers to deadlock?

> +	if (unlikely(scsi_debug_lbp()))
> +		map_region(sip, lba, len);

[Severity: Medium]
Could this result in a race condition due to evaluating scsi_debug_lbp() tw=
ice?

If an administrator modifies /sys/bus/pseudo/drivers/scsi_debug/fake_rw whi=
le
a write atomic (16) command is executing, the first evaluation could return
false, bypassing the lock acquisition. If the second evaluation then returns
true, map_region() would be executed without the metadata lock being held.

Could this be fixed by caching the result of the first evaluation,
or checking meta_data_locked instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917125445.1376=
493-8-cassel@kernel.org?part=3D5
