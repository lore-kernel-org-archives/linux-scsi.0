Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F643E51C6
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 22:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785967224; cv=none; b=fiFPGdprA7KZE5DKjzoacnD06bP343xip4DFQjKD4bHarrQWOpNjEAKXTbHO3klfJqSartUlnGUnfOlC031Pole1TtS1e4E+E97HCHvlmRbIAlcKq7NnHEfu0rbOisMEublPRNUJMKPReW/YLDNnL8BI+Mc3yk+EIZxURIYaHh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785967224; c=relaxed/simple;
	bh=kF/BML60dFHEEjg+xMGShvWVecTNsXA1Gg/Mt7n0eH4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DAg/5PPfcp7+g2CXQbyufUbP6Tngby/o/INoBzJHcSYN8HrQx3klNvjjDLHWf+NC8ccNKf2p+LqKBuj/tE+9yud5GyyWA+rI9mrU87lgtHQmgrxkPlRWsP+QzwFF0qXleOEP8EMa73Rptnhhs00A7UKJ62e78tfC2kWqYw4T8Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfCsQp5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfCsQp5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7012C1F000E9;
	Wed,  5 Aug 2026 22:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785967223;
	bh=d2k4k5UA2TXYQUghcrAfKN+5a3bABD3ticElpQgveG8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UfCsQp5Qva83hdQzDiGnlrJUYwcdepYvmykp+nR/6C2kUeh+5KHopfk++SjWH6e/k
	 Ktyn6q9gCOuMqKZA28YcecM4run/AvobpAufBiho6moUH++jNoXfO/6ly/mPvl00mq
	 r9VCzm0prbP0DUs74hgNHaCiug74vM1vEQg2ykGqyummPl0wTeRThOZklFloInsCVk
	 19NaUBxU3IcSwrCQo99wBKfTVrfStnlHqpPQWmOPCP7BQnu8diMlQqRufAWdCtZyWy
	 TqLtSFvC3SbazVovATSBHxmXRah0ypyvUHJ6aG2l31P+4Iqu2ULkd9tmeb9AFYRC2Z
	 JtDpGg7QMIAnw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/6] scsi: core: Add lock context annotations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <da0d5e522eb10312076580371ee41e1d28f7ac18.1785965531.git.bvanassche@acm.org>
References: <cover.1785965531.git.bvanassche@acm.org>
 <da0d5e522eb10312076580371ee41e1d28f7ac18.1785965531.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 22:00:23 +0000
Message-Id: <20260805220023.7012C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] Incomplete implementation of lock context annotations.

Pre-existing issues:
- [High] Integer overflow in `scsi_report_lun_scan` leading to infinite loo=
p or out-of-bounds read.
--

--- Patch [4]: [PATCH v5 4/6] scsi: core: Add lock context annotations ---
commit f676281064957e5d166348bcd6e0996c11afa242
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Add lock context annotations

This commit adds lock context annotations to document which functions expect
shost->scan_mutex to be held.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index d7e0e93931947..3b82e80e807a7 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
[ ... ]
> @@ -1444,6 +1446,7 @@ static void scsi_sequential_lun_scan(struct Scsi_Ho=
st *shost,
>  static int scsi_report_lun_scan(struct Scsi_Host *shost,
>  			struct scsi_target *starget, blist_flags_t bflags,
>  			enum scsi_scan_mode rescan)
> +	__must_hold(&shost->scan_mutex)
>  {

[Severity: High]
This is a pre-existing issue, but while looking at scsi_report_lun_scan()
there appears to be an integer overflow condition when handling untrusted
device input.

If a malicious device returns 0xFFFFFFFF as the length in a REPORT LUNS
response, the addition with sizeof(struct scsi_lun) can cause an overflow:

	if (get_unaligned_be32(lun_data->scsi_lun) +
	    sizeof(struct scsi_lun) > length) {
		length =3D get_unaligned_be32(lun_data->scsi_lun) +
			 sizeof(struct scsi_lun);
		kfree(lun_data);
		goto retry;
	}

On 64-bit platforms, size_t promotion causes the addition to evaluate to
0x100000007, which is greater than length. When this is assigned back to the
32-bit length variable, it truncates to 7. This causes the code to realloca=
te
a 7-byte buffer and retry indefinitely, leading to a deadlock on scan_mutex.

On 32-bit platforms, the addition wraps to 7, skipping the reallocation
entirely. The length variable stays 0xFFFFFFFF, which results in a massive
num_luns count and eventually an out-of-bounds read past the buffer.

Could we add a bounds check to ensure the reported length doesn't overflow
before we attempt to reallocate?

[ ... ]

[Severity: Low]
Are there other functions that should be included in this update? Looking
through the SCSI core code, there are a few other static and internal helpe=
rs
that rely on scan_mutex being held, such as scsi_sysfs_add_devices() in
scsi_scan.c:

static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
{
    ...
}

and __scsi_remove_device() in scsi_sysfs.c:

void __scsi_remove_device(struct scsi_device *sdev)
{
    ...
}

Would it be useful to add the __must_hold annotation to these functions as
well so static analysis tools can catch missing locks across the subsystem?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785965531.gi=
t.bvanassche@acm.org?part=3D4
