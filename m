Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793031140;
	b=pIFeZWk8Hy3YqQtzvv5hFDjVL+K9k8YIdq/MS7qHRzS1EujSrRoh/Xdp3XyYf95GKK3m
	 ledIl3z2147ru6lyPi3rtmjvCZulHAQIU8PEEAVVLdfIXdKLNI0IlvFpjAsra7F2oBD0b
	 aEZG+vclejoCWqFgf+DudLd0mlvDSSlGvKjgE0AS/lcRBFekHkYsm9JGVQX3GJ1OFWDF5
	 iXVQqZ1h3sKb7hkNV6lhvUGo6zh6CV3xELEZJJ61TmO5ofHdc19b2eGL9eAmtF7o98Qk6
	 6pVAah0ki5aLyIknI5so2629ApMOW/FC2lgNbWWrO0j1cMls6iCwuUtTc7g4uJ6HqYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031140;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=09IOwG5JDndjYFaj+K+hzBiH/v9WxlSaY0hoWZ3Empk=;
	b=VDMg6OBHfmztUvDLTIoRypFmpOjxRBXWLIjCWRolW8BhNc+DMtrGRF4M9IkYzZvN82Vr
	 IhtfxRi3Uo+ZW+gVFMv5Q7CM6djtwhIzcfTwkrEQg26gJXz31stzl16QBZ4U0uQWaLrwv
	 Sh/GltrOAf/rySXm1eOG8sD1wRBm5L5bmdRa7qPvkgJHUx7PPZqPoKW/98dXFtXGaZC+J
	 7MWwTgx/4oh3a6d9A54K6NcBXDDw5H7izqje/RVEIuw0NJMcSdhpRarooy6ZEXdiVka94
	 8zWynGwpKxV7HbgViCgVlSnh/mWGoXMCmoBmnppXXuxz1o7ampjoJLH9ElkNcHio6vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MeYqZdx2;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=s9iJ38O5;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BAD606A31D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 16:12:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10BAD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MeYqZdx2;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=s9iJ38O5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793031139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09IOwG5JDndjYFaj+K+hzBiH/v9WxlSaY0hoWZ3Empk=;
	b=MeYqZdx2PkOT6PhXaPEPe638+HQv/afB/MpHaOYaqcmlcMPjpPv2rWOPNjAVWsEMymhSW3
	92/Bd4KERPFJMLpHzjijyy+44kpktPjYI3ALXoqIChIMozC6yl2sxwizHUls9xN0satSrp
	dTLDl2QLy9KyyeVZJz0sFiIwIbnOtzI=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-PR9kQcwVMWOKqlvwl4griw-1; Mon, 26 Oct 2026 12:12:11 -0400
X-MC-Unique: PR9kQcwVMWOKqlvwl4griw-1
X-Mimecast-MFC-AGG-ID: PR9kQcwVMWOKqlvwl4griw_1793031131
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-836c9f68dcbso48583517b3.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 09:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793031131; x=1793635931; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=09IOwG5JDndjYFaj+K+hzBiH/v9WxlSaY0hoWZ3Empk=;
        b=s9iJ38O5x4N8poKWzSVBS2+4au6ssR6Bs0YgXCPngGFXbaMVpEz06tAr1ND+ZeGS76
         93vXmWiJGfXoaDgMSTl7PNIX3TlVlPRzWBd9rjf6YhSrnAjx/0dhhd7MBOEpldUQnpYN
         wE3tqBhtfHDvHeSp059YtJCwGlffARxM6NIygRfFMk01CFds89V31XFlvNnb1BsCpv8G
         ni1ZOKmLBRDZ8UYdGGSJuENq32pFcdSch7z/QMs4vN9FolB8Tn6PL4w8Wib23C2HrJAB
         sRVaDP40S93NloiZkNZfzC04RksEibMKZmST/uTCscBZXtDehZpbtBl+rJCF/qleMkeH
         ngRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793031131; x=1793635931;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=09IOwG5JDndjYFaj+K+hzBiH/v9WxlSaY0hoWZ3Empk=;
        b=eFCg+Fw6oyxXSiVzWZWhmIeOIwPC/lhhpEry3HhBXBEEBXZJ43r513PPHWwp+CaA9u
         aotgbo9a6hlORjXu42PMV21Wohhg58/Q4v+HDTCy2yFwCYovVHei71CrltINiMKIoBH5
         2ECuovEpC5UFGyn8Vn/avDS4s1nVSezY3W7Gn2CClXeDb1CgfPuluTcENngfj9wwzvHZ
         86HEMY/D+PO8IqSThj6gWo2jiQgkLgPLdorc4KaNjuC9EBzVPlCBJ+ch7Vl9XGHLzlvT
         W/c8hzeHcCdKWMIoxaA4c0as7gGK65cephiLOmx2HFMH2rIjfGO76PMAowTIJRlQqM4G
         uH/Q==
X-Gm-Message-State: AFq9FYKrY5jqIH5BYj9HoQmhudHQ3aNLA7CkcgiJFqtnLdqSpAn3+hJL
	ePWdVa8tCTTNLFMFNpXaLHxCa8s28bIfCoQ1+whiuDpyKbh7NRSIMK2t4ijtZqluZzljoFU4Shh
	ajs51ygofkLFvgtr9YUW+8ErKAA3LlfdHQFFQuhoI1mqUUqDeqeU6Suj+LRSh/FQ=
X-Gm-Gg: AYBFou3JbbAffs8JqjOG3I740ZF1+nkQcLI36nyagVUN1RlkxpuzFNAR4CDtxLH1JMn
	sm/POYaawJcs52OKVsvR50MFc9naRnvm5c6hDfaYovM2w7PRAzFk/WiMVrDnAXFTLRV/HczYUmA
	oA7D9uoeddmKSTtbyDS5TwgKu4MGOlOITTureS6KM9ETK9KQW5Da1aybvAfBzhpR4175SVjYp++
	GJPamw/KJ/lpJMPXMg0NeEMKE+HS1OY34mJr2jNtoMCzwbJjlEGvVd5yaU+4lArSH+NO0luqqj7
	6Toau0KAojSbphb6a61vhEpSNP+5WAHrYZZq6c2CZv8Cb7FBSRz6scD1NSg9ClbWbv/1k4mijUj
	gEndVNJMGB1Qr37AGcWLML6n9Bu+DuBZAHFG0HzoE7npouAI2YT1cN3L+zDuS6r+bOHZaTdc99S
	wtCrk+FPoDQLBty20DTRQejA==
X-Received: by 2002:a05:690c:c354:b0:8b0:d421:e024 with SMTP id 00721157ae682-8b166be0d33mr33251587b3.44.1793031130902;
        Mon, 26 Oct 2026 09:12:10 -0700 (PDT)
X-Received: by 2002:a05:690c:c354:b0:8b0:d421:e024 with SMTP id 00721157ae682-8b166be0d33mr33251437b3.44.1793031130373;
        Mon, 26 Oct 2026 09:12:10 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166dcf543sm33937057b3.14.2026.10.26.09.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 09:12:09 -0700 (PDT)
Message-ID: <8d705915480f6cbe6a1b37c2cd06eb98727b3207.camel@redhat.com>
Subject: Re: [PATCH v4 0/3] scsi: target: iscsi: fix stalled and doubly
 completed aborted WRITEs
From: Laurence Oberman <loberman@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 12:12:08 -0400
In-Reply-To: <79480408-8403-4a93-a2dc-c5f01864a20c@acm.org>
References: <20261026150710.1063511-1-loberman@redhat.com>
	 <79480408-8403-4a93-a2dc-c5f01864a20c@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-10-26 at 08:24 -0700, Bart Van Assche wrote:
> On 10/26/26 8:07 AM, Laurence Oberman wrote:
> =C2=A0> On moving the one-shot guard into target core:
> =C2=A0>
> =C2=A0> This will be explored later on but is not in scope for this
> series; it
> =C2=A0> changes the path every fabric completes through and I have no way
> to test
> =C2=A0> easily in iSER, FC or SRP right now.
>=20
> I don't think that argument holds. Fabric drivers that complete an
> aborted command exactly once never trigger a one-shot guard in
> target_cmd_interrupted(), so their behavior wouldn't change. The
> guard
> can be a new transport_state bit that is tested and set under
> t_state_lock, and the CMD_T_ABORTED test can be moved under that lock
> too. Today target_cmd_interrupted() reads transport_state without
> holding any lock. That would:
> - make the iSCSI-private completion_claimed member and both new
> helpers
> =C2=A0=C2=A0 unnecessary;
> - close the race that patch 3 only narrows (CMD_T_ABORTED being set
> =C2=A0=C2=A0 between the iSCSI test and target_cmd_interrupted());
> - also cover the sites this series doesn't touch, e.g. the deferred
> =C2=A0=C2=A0 ICF_OOO_CMDSN path where iscsit_execute_ooo_cmdsns() ends up
> calling
> =C2=A0=C2=A0 target_execute_cmd() for an aborted command without taking t=
he
> claim.
>=20
> Please consider doing this instead of adding iSCSI-specific
> bookkeeping. If the iSCSI-only approach is kept for stable, please
> explain in the cover letter why the core approach isn't suitable.
>=20
> Patch 1/3:
>=20
> =C2=A0> Fixes: aaa00cc93c1d ("scsi: target/core: Fix TAS handling for
> aborted=20
> commands")
>=20
> transport_check_aborted_status() only sent the TASK ABORTED status.
> It
> didn't drop the reference that the abort path now waits on. Nothing
> waited in target_put_cmd_and_wait() until commit 2c9fa49e100f
> ("scsi: target/core: Make ABORT and LUN RESET handling synchronous").
> I think that's the commit this patch fixes, or at least it should be
> mentioned too. Both commits went into v5.0, so stable coverage
> doesn't
> change.
>=20
> =C2=A0> +bool iscsit_claim_completion_locked(struct iscsit_cmd *cmd)
> =C2=A0> +{
> =C2=A0> +	lockdep_assert_held(&cmd->se_cmd.t_state_lock);
>=20
> Please also add __must_hold(&cmd->se_cmd.t_state_lock) to the
> declaration so that Clang's context analysis can check this at
> compile
> time.
>=20
> =C2=A0> +/* Complete an aborted command at most once.=C2=A0 Must not hold=
=20
> t_state_lock. */
> =C2=A0> +void iscsit_complete_aborted_cmd(struct iscsit_cmd *cmd)
>=20
> Please change that comment into a __must_not_hold() annotation.
>=20
> =C2=A0> +	spin_lock_irqsave(&se_cmd->t_state_lock, flags);
>=20
> All callers run in process context with interrupts enabled, and
> iscsit_release_commands_from_conn() uses spin_lock_irq() on the same
> lock. spin_lock_irq() is enough here.
>=20
> =C2=A0> +	bool			completion_claimed;
>=20
> Please add __guarded_by(&se_cmd.t_state_lock) instead of just stating
> in a comment which lock protects this member.
>=20
> Patch 2/3: looks fine to me, assuming the series stays as it is.
>=20
> Patch 3/3: as explained above, this patch narrows the race but
> doesn't
> close it, and the ooo_cmdsn branch right above the new code still
> defers to a path that doesn't take the claim. I'd rather see this
> solved in target_cmd_interrupted() than merge a partial fix that will
> be replaced later anyway.
>=20
> Thanks,
>=20
> Bart.

Hi Bart



You are right, I apologize. A guard that only fires on a
second completion is a no-op for any fabric that completes once, so
there is nothing for iSER, FC or SRP to regress. I will do it in
target_cmd_interrupted() instead.

That makes v5 two patches: the core guard, and the iscsit_execute_cmd()
completion that is the actual hang fix, with no completion_claimed
member and no helpers. v4 patches 2 and 3 are then unnecessary, since a
second target_complete_cmd() becomes harmless wherever it comes from,
and it also picks up the ICF_OOO_CMDSN path you mention, which I could
not reach from the fabric side at all.

One design question before I write it. target_cmd_interrupted() has two
branches:

	if (cmd->transport_state & CMD_T_ABORTED) {
		...
		INIT_WORK(&cmd->work, target_abort_work);
		queue_work(target_completion_wq, &cmd->work);
		return true;
	} else if (cmd->transport_state & CMD_T_STOP) {
		...
		complete_all(&cmd->t_transport_stop_comp);
		return true;
	}

If the guard is one-shot across both, a second call that would have
taken the CMD_T_STOP branch is suppressed too, and I am not sure that
is safe --
a suppressed complete_all() could leave a waiter in
transport_wait_for_tasks() stuck. Should the guard cover only the
CMD_T_ABORTED branch, or do you see a reason it is safe across both?

 > I think that's the commit this patch fixes, or at least it should be
 > mentioned too.

Agreed. transport_check_aborted_status() sent the status but nothing
waited on the reference until 2c9fa49e100f, so that is what turned this
into a hang. v5 will carry:

  Fixes: 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET
handling synchronous")

and explain aaa00cc93c1d in the body as what left the site with nothing
to complete the command. Both are in v5.0 so the stable range is
unchanged.

On the annotations: thank you, I had not come across them. They are in
include/linux/compiler-context-analysis.h and I can see how
drivers/nvme/host uses them. They apply to completion_claimed and the
two
helpers, which the core approach removes, so there may be nothing left
to
annotate -- but if any of that survives in v5 it will carry
__must_hold()/__must_not_hold()/__guarded_by() rather than comments,
and
spin_lock_irq() rather than spin_lock_irqsave(), which is right for the
process-context callers.

Worth saying plainly: the core guard will be new code with no field
evidence behind it. The 300 reset cycles validated completing the
command in iscsit_execute_cmd(); the claim was only ever there to stop
a double completion that an earlier version of mine had caused. Moving
that guard into target core does not change the hang fix, but it does
mean the guard itself arrives untested, and I would rather say so than
imply otherwise.

The reporter is covered on a distro backport in the meantime, so there
is no schedule pressure on this from my side.

I will post v5 once you have had a chance to answer the CMD_T_STOP
question.

Thanks for the thorough review.

Laurence

