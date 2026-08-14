Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D69118FDDE
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 02:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786672978; cv=none; b=qH894Hk1LCQdmCDNIbU8vTRbkP2Y06+ErBpA/GS1maOBbQ9twLs6x8pBJ9LUIqHNzZaVLa+hoSBVC+wZ9OIF2AKYNrG1IgLoB9MKvLC3VKTCWqASJsCQCXaeB+D3BQa+Nr0xx3+r0+iYm+wWevgqP/14bnMLCmS7Z1tjVMSOTr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786672978; c=relaxed/simple;
	bh=5gupHmQHLbBZSbQ/vPNeGWfkz6crVs1ncYNGKA8CmBg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MsOJfeg2S78GhoJZKxp0S+K991wZzKc/1bM12sBgNqqsRid1bl0Al+iyxHdms359gVURmi+hbKf1TTqBs0cBTWkOpkOGHAX6WGe+5aKBZuiDtM4o1Gkv4Qc4EuAPT5/GL77g3aLKaZEUJVHTiYYTSG5/j3oZFYHcsAfB9SVzbkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjnQM8nM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjnQM8nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5335A1F000E9;
	Fri, 14 Aug 2026 02:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786672976;
	bh=1MnFq3bI8iCXlAvU7W0mi855gWcd0nKvpzvFJKCtjJU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kjnQM8nM3rebtEQI05biDkJyoVWSCy6q62ob8sh3NO/147XNu7cEVoUbDzRkRoLM3
	 YpkU+NxZeQLC7Y5DdD6KgeO4qMVb/kqJG3TkZoUTFGJv+u+bClFhyrnM2V3KHd2dmt
	 RRzNqurLbFf9qS4fIQdJ7/KKlOpOKx48ATgWnicB7I4OMkUsygCT5EZICOjkpMbyRp
	 NzHE5JOM9yKX8uZmoYKx57WOZoK8oL4TNCbd+bIZzewDAyRwpObejtHDFHIcguFEzG
	 35kje8h3qkpNBw4k/C7651F7dF+g15zhNqzVOxSjHjsQ3IAoBJ7UdWpKKfHjjgNysV
	 hNirlVE2OrO0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: check that the tag map is still there in
 scsi_host_find_tag()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260814010423.205976-1-yhlee@isslab.korea.ac.kr>
References: <20260814010423.205976-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 02:02:51 +0000
Message-Id: <20260814020256.5335A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The lockless checks for `shost->tag_set.tags` and `shost->tag_set.=
tags[hwq]` introduce a Time-of-Check to Time-of-Use (TOCTOU) race condition=
 that fails to safely resolve the Use-After-Free and NULL pointer dereferen=
ce vulnerabilities.
--

--- Patch [1]: [PATCH] scsi: check that the tag map is still there in scsi_=
host_find_tag() ---
commit 090ebf7d7f01fec40907d4c4480b8d9725dc44b2
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: check that the tag map is still there in scsi_host_find_tag()

This commit addresses a NULL pointer dereference in scsi_host_find_tag()
that occurs when a driver looks up a tag while the host is being removed.
It attempts to fix this by explicitly checking if shost->tag_set.tags and
shost->tag_set.tags[hwq] are non-NULL before dereferencing them.

> diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
> index ea7848e74d257..d62bae05d4e7d 100644
> --- a/include/scsi/scsi_tcq.h
> +++ b/include/scsi/scsi_tcq.h
> @@ -29,7 +29,8 @@ static inline struct scsi_cmnd *scsi_host_find_tag(stru=
ct Scsi_Host *shost,
>  		return NULL;
> =20
>  	hwq =3D blk_mq_unique_tag_to_hwq(tag);
> -	if (hwq < shost->tag_set.nr_hw_queues) {
> +	if (hwq < shost->tag_set.nr_hw_queues && shost->tag_set.tags &&
> +	    shost->tag_set.tags[hwq]) {
>  		req =3D blk_mq_tag_to_rq(shost->tag_set.tags[hwq],
>  					blk_mq_unique_tag_to_tag(tag));
>  	}

[Severity: High]
This is a pre-existing issue, but does this lockless check leave a
time-of-check to time-of-use race condition unresolved?

The commit message notes that blk_mq_tagset_busy_iter() tests the array
before using it, but that iterator operates under an srcu_read_lock(). Here
in scsi_host_find_tag(), there is no synchronization.

Could a thread evaluate shost->tag_set.tags and shost->tag_set.tags[hwq] as
non-NULL, get preempted while blk_mq_free_tag_set() clears and frees the ta=
gs,
and then resume to dereference freed memory in blk_mq_tag_to_rq()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814010423.2059=
76-1-yhlee@isslab.korea.ac.kr?part=3D1
