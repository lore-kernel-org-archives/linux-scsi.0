Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D974854F1
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 13:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789132699; cv=pass; b=TjUfGsFoTEWSKAm0yNPCr0j1u61v1snKM1UL+HhqwoV1ScKMN0ogKeCSMpXjdWRsrPAWv0RhB5+nH7iCFNOjVW73cd1njK0c6AS3dD7DqDqkCCUCFWBZG9WEnSnZWWuo2nssSD5nQCgs8IK5TTLx6fkbivmYepXzH+z9TqpxRWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789132699; c=relaxed/simple;
	bh=K4LaHWFmEK3IYVvGCmtsW+XE/AM4kN+3jt1Lhu0vGrQ=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hZZi9waGZVZjSrODqKlTBsPVapA4uDTEDKcrVgz3avv3ztyIYFFVTFXxhdQq/qWRXf0YfUzGaUjTTvA/3UhZVHnTudqPDIZFsbwxmjqn3eua2qWJvJzPxtQphw5yHs91aIQ9BO6UfQuptJ7N0ylOt1EKUY26hXqW7dnVIbzpQC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HqO+Dv/U; arc=pass smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HqO+Dv/U"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so233151cf.0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 06:18:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789132697; cv=none;
        d=google.com; s=arc-20260327;
        b=Y5g7A+D2kMWIMOJlQ0xWwgHo3RyPKsMl7Dk0sP/kI8qgXkmbE/gLivmYSU4RBwsbLX
         evLfzIiUGlfh4EPyQpczONUNie9+hcziR/cOMzavU4tQoIm0KOE6P2kpp8OcacrGKOo+
         qelLpLUjfdI9dit1HEmKQxYIozmq7X4haP6syrXNkoCmep5AvHqa2XCSO0F4ND/kENZk
         g+hOe4h4+WuBS3fc/cBJip5nGnJnwqBdCIby7OM79j+fmIcf4XcFfXF7EGJGNh0FJW0x
         7SwsJiFfas5ukGODR518/G4xCu6zleQPYj54uGSAW6mMcctXV0kzpZbljDvCASqnQLvJ
         HKEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=cSM57NSb2bqH4CibrYZpRofl0NWuwtByEycwX3Z2gtA=;
        fh=DtgVUJXhkvD2ez+rmgfLHhjDcAzWVj8B72uDQh/nkps=;
        b=igw1ytqGofesWSQpb1tFe+dNjAfPZg58/9aaYNOJOWadFifF+zKt862l3yxU1mLEXW
         ssFiJqsvM5DZjYwZaAw2nZCHPBRRlU4+U6LhRVUoDP0aEvqYZMCQ+1Fn6z+rkSLh4QvX
         QV17siKAN3T5HijgCjtQvPfF4zNXh9I06p6xek6FqJwTikdv1/tX76NYimBqyYNkyQKr
         WCCS9eYWmA2Egv3GBUL3TWKZCeEzyV0zTP21XDwL4Exf12gmpvEK+YaPPiuYCKyr6/Nk
         GzG5xssvH/R+hQWr2IdLyysSUpjSncJyBJS0K/aLS9pnj0rgKkqKboX59PO0EMMRXdTU
         UcHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789132697; x=1789737497; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cSM57NSb2bqH4CibrYZpRofl0NWuwtByEycwX3Z2gtA=;
        b=HqO+Dv/UK5ONBLE0xNDZoqih5IRTWBMPeA/A1xYwGeCwlzZvTjz6Ja8KbWLkyPo/5f
         fiHeqrhPw/Mmgn4O4NbY/iO0OWslSb2Gp6uGLpSRIlt8F+ebitAxOSHliTR6tNpQwvK4
         hFHkGopexZcdbRJYFtUDlxVk4Q71QmB+7tdNBIs6g995Eg1KGUXIB/5z4jz5xlyKh46P
         UOlO/ZdFJm6UVGKbIWYS2N4EMatpIP4NIWdz/yaV2LWR3eZVhVkvxH4jxWNj/t9qoQmR
         ZQLs5w8q/AJ6qvHbiegukw4EBduFbnDvxlxLakt9eMuhV3POqVFrwcXNcb8V5HVyG+aZ
         bycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789132697; x=1789737497;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cSM57NSb2bqH4CibrYZpRofl0NWuwtByEycwX3Z2gtA=;
        b=fDMGHRMaW48iLMotxmhZKoUu04YlawkhfHkh5OJr2wxXo7Msym4AzVPy3r8SOtpDO7
         6g8Btc8MNl4G0ZUEcxXG0x7mAkE2dWKKMsgbgJ2ii/tfa6rygHpmc093Z2h6vZhp1LuX
         uhthIbIU7qAmg+kN48wIo2H8YJQE4Ot+3SeBRAfTki/AD9sJ4dmcT3Su7eoElGP+UIZu
         PQS14pWwN45b1bexfVuWI5KUizwHMw+uQ3oQhr/9N5/6uvh6jItTtWMYtsrE9L1mZoDB
         /9ZhDRZpLJ4TWPja5E7mrV+xzykKqcx9wVws5gS9/bOPXBsKzMFKDRYRAIaddcnmCZ7L
         noBg==
X-Forwarded-Encrypted: i=1; AKwUvBxcyDaFSuAX8Tx0ZSY0n7KhL3Q7a/nQuqfsWSzdQQ7VWk/65x+k1N9etFzNeZGuVofm4Ky9aadv6UCQ@vger.kernel.org
X-Gm-Message-State: AFuF++lNo84YyY7KWfDK7Oy8rUmVUxk6TwmoJ5B2f694CPuW/jeidPyg
	8XFm1S7uB9bT2ADdKcO8qDa+rS2H7GM7Ce81bvZwTLwqBvsn0gDqios4RvLsAxjbIov+wHaAKZ6
	ypW2lmE8dKznIHdxq1sjE+d61uJLxefknLV4PdwiE
X-Gm-Gg: AYBFou1zxgGSocfG0uBkS2DTUeU16vKPuVIDXyLjhcWKvwN+Du1sCHuInIFAiF7bo7Y
	e0FQTdJbdU9WmQWZwyPDWHosj/5XyG6+qVQ6DUnElcslQ3evkCer54A5osMl8JhuGqA2fvCxylO
	C1+AJ4nrmNbBxdZsAGjNXNqSljO+gpLP4ivFSzr0weKSAHBVdsfeefampi17WEoZv3Kiz9RjRBj
	C7Ci6gcEOrmQcPZsg0pRrxwjkptqER0aNrYC6I0/5nIwzzaWixgEPlY5pGV78SIH9/WmzGXg4xO
	eRtKNHS4ywQtPFflYLt3mkAGZeHhOZnBnpFUZe07f1RwXiDDJoioYN5FIb9pGzxblJjECAHRSPp
	DQH5ZVvtbU7VPcFdrNg==
X-Received: by 2002:a05:622a:999:b0:530:5120:19da with SMTP id
 d75a77b69052e-530c93581c6mr17607741cf.2.1789132693409; Fri, 11 Sep 2026
 06:18:13 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 08:18:12 -0500
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 08:16:57 -0500
In-Reply-To: <6f78c4bd-a70b-402d-abfd-599091b67674@acm.org>
References: <CAE14pdef2u=Eo7M9NGdABzsjy2o2SO=Z-U_BbRn9n45nJJR+wg@mail.gmail.com>
 <6f78c4bd-a70b-402d-abfd-599091b67674@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stanley Jhu <stanleyjhu@google.com>
Date: Fri, 11 Sep 2026 08:18:12 -0500
X-Gm-Features: AcwNN1UmqJQwItU9X_dh_8-vmqHmW7HvbyT2cnBdNolC9xFwWq_P473Pus4ih3Q
Message-ID: <CAE14pddGDqiYaaHeTd2JEK_938EY+2DCUwZ8pwFF=p7U4ibx7Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: Set BLK_FEAT_SKIP_TAGSET_QUIESCE on pseudo
 SCSI devices
To: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>
Cc: hare@suse.de, john.g.garry@oracle.com, hch@lst.de, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Sep 2026, Bart Van Assche wrote:
> Has it been considered to remove the blk_mq_unquiesce_tagset()
> call from ufshcd_err_handling_unprepare() and to change the
> blk_mq_quiesce_tagset() call in ufshcd_err_handling_prepare() into
> blk_mq_wait_quiesce_done()?

I tested that on next-20260824. It clears the NOP OUT deadlock.

However, switching to wait-only means no request queue is ever marked
with QUEUE_FLAG_QUIESCED during error recovery.

blk_mq_wait_quiesce_done() is only a drain, not a barrier; its
kernel-doc explicitly notes that it expects the driver to have set the
quiesce flag beforehand on the target queues. Without QUEUE_FLAG_QUIESCED,
the block layer dispatch path remains wide open. In testing with
background direct I/O under a non-fatal error, wait-only allowed 27
commands to dispatch to the controller during prepare, whereas
quiescing kept dispatches at 0.

Prior to commit 2a36646012fc ("scsi: ufs: core: Simplify
ufshcd_err_handling_prepare()"), the prepare path explicitly blocked
new dispatches via ufshcd_scsi_block_requests() alongside
blk_mq_wait_quiesce_done(). Dropping quiesce entirely therefore leaves
regular LUNs completely unguarded during recovery.

Quiescing logical units individually via shost_for_each_device()
resolves this: it preserves the block-layer quiesce contract and
pre-existing protection on storage queues, while cleanly leaving
pseudo_sdev unquiesced for NOP OUT.

On the SCSI core patch, your point holds: ufshcd_pause_command_processing()
and clock scaling also need pseudo_sdev quiesced, so a queue-level flag
is the wrong abstraction. Please consider that patch withdrawn.

I posted that patch at:

  https://lore.kernel.org/linux-scsi/20260902082306.2299159-1-stanleyjhu@google.com/

If this direction looks good to you, I will respin v2 with the Link: tag
fixed and the commit message updated with the above rationale.

Thanks,
Stanley
