Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197844;
	b=UhR++E43WznOyUv/AdJL3fIVU/VHUjNATjweTKzkyUyU5/B0N6rS++c85ec2kZ+qj8jN
	 ua6kt1e1nw89dxqkJiYRIXi4Bs4yA136qD7JiHKGtO/YeYfV+zhYuvNyHpLX5PxQCAZyU
	 Jc7UCuSmQSUASQnO0svH72sAaUamQF1XP1iGXvU27I3Fach989QCnOGkC1FFF855EKR6k
	 UZ3p15WIQ9ga+nRAT1R1kxw4RBbLSJxuv13HmA1+BMgApw7rt1LKz11iu+NuNy5ooqmLA
	 /0ddF0sB8I3oAdzwJg7gpGKCxWbD95QzJ9YhdumV7EWFAO6eXtGnZf50XCsbi5qNj8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197844;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=Sv/iTPs4xlWjnrYC4tMYxP+iSSAMw3Kx4oBZaMa50nw=;
	b=l7Yw1FW7V3SUfIzAWX+h1oQK+5IXnwMrZ1vjSYEJ0VU6SR50joOi1qr9GNe2ZmW8hZTe
	 7FgdCUlreUP1QO5gGAdWEnOfRVGR1gjD1zFtxaQ91wCu8jp8GmqMHPcnH675BDNhYktT9
	 v33ZrK2NIPtfGpyXty95sbNUUx18mjPcfvqXRoywbtlwX4Cx4iH5pQYaeEXMT/gwC1Vky
	 UsTDzXPC8WY/99OgJl9YP2ueSaO0Avmumtw083gfauE0EiKAbjaoTWiLtCdhOSGJT448B
	 H4TNFKmqbYnN5ogyjIb2J9c6l5q2sm5AHetwvah0PwwjX5Wt3MIgtox3H0wreHHWiwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aQHn9TsG;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="RbUYO/D0";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A1B606A320
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 14:30:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72A1B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aQHn9TsG;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=RbUYO/D0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793197841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sv/iTPs4xlWjnrYC4tMYxP+iSSAMw3Kx4oBZaMa50nw=;
	b=aQHn9TsGrEXCmBUPbz4ruTyirrH9FDL2gRRhTHwGAQN8dR/NOig76SneA0HsnepVfp/Kvy
	lASwuFtqOVmqwAewDwKxiGdtxHaAVwM1JRMRrB92D5/PY3WLZVKM34O2A6IFepE7rDxtcd
	ixVPSCxshWxHzup52oNKIJMhi+OSLIg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-2oTOsFyIMKmMKZhfk1R9Uw-1; Wed, 28 Oct 2026 10:30:40 -0400
X-MC-Unique: 2oTOsFyIMKmMKZhfk1R9Uw-1
X-Mimecast-MFC-AGG-ID: 2oTOsFyIMKmMKZhfk1R9Uw_1793197840
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91c818c72bdso15076376d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 07:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793197839; x=1793802639; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Sv/iTPs4xlWjnrYC4tMYxP+iSSAMw3Kx4oBZaMa50nw=;
        b=RbUYO/D03w3KFDtoVh8mz6tiGtVOwCV4DT3OXWPknHGN1MkTDhIvwOcsi30fSDe5BI
         d1yXEBSBfKNu1K7K+hENUr92yJz2jquGolvqL50ceS9td/q04sT/ZnK6pACLQv+9nyrI
         9oLgzQpaLjcEc3ljeof9sxe8HoIt2sipnMJlEAF6Vnm45Y43lKqBOg5fzA4G/dyQdRp8
         btDpMmmu0f7txvQvKHuSRot65rfwQd4n76fpTXgajZy7BlloYdzKhIHQPC2Ujg/3i3Hm
         JafVrjzKDevhJwIrJeVJuY+Nl5HXR5k6qiM/DrLIaVia6Ouk82wljTWMO94EIm+JnyUf
         uBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197839; x=1793802639;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sv/iTPs4xlWjnrYC4tMYxP+iSSAMw3Kx4oBZaMa50nw=;
        b=EutO8F95rZVS8DjUimNunadEjkIUG+efVCuSr1bI7agxv8dIWXlt4R5vIr67rc4RW9
         JkaFVkFrt6Sd5/WZlHsBj9FC24o8eaNj0Dzqw08W4IykvNeTWN9OU8A/mgk+eKf4Lqnh
         aY13n/ywyalccRupi3Q4x8Io6BlvDcKjPd+cj7w6yp/IBrsf7dfu8UsPwUq8bMooF9P9
         cEXH0G4HkEDobrUVxY4EoKd5QTjR7uBeLwKtLv93ypZXbd9kX7oY6ZVWYclkH6xbllKN
         sSeUEmAYPCXWn6j2OXWa5UuICjMw4IigLI5reMuzAzez9X9XKcwhU0nFm8MEvs/FEHvZ
         jCUg==
X-Forwarded-Encrypted: i=1; AKwUvBxPLlyAkZbgO6g1iM9aX0xQYXMl/tS3VoOBI3Ip7+AEuk1wvxdShFVA46FkGJVB/byypWBstDckyXML@vger.kernel.org
X-Gm-Message-State: AFq9FYLgwNIk7tXbu68+oEj03afCfwRY7YkV5g9rcqSfy+iLDrgn2Ltg
	dmJWv5DnKiBKI6lyc6JWN//INhn6elSwOhMIWlJgjDnwos+03gOWZ+tX4JzSwkAxBO3tO9ilAaV
	AEYHm+Nf6Ay8c8hv4Qy3ZHRTFfBI262DAw3FfMyZiC1iKct76fCoOwaTG2ZrcSfo=
X-Gm-Gg: AYBFou2gRdfCAWlFE/KRVp7U3sudGdUUNgW7XuShY8pKFKrbXBbk2PN/ouo8O+pYWDp
	DPimi4laCu8NPWWgmJ/ycfOjhLllxIUSIczug/LeetRT/naWeQyoK3IZawjEwQX1AIuHXI+MuzH
	qvKrHMUW7fQqfiCRta1+Fzx26rR/Eka9rRKUKWhHOgJQ+Ax6F0Stzx/RAWVk3uPbpqUj0DSiDdb
	p3cVeCmc8S91YLl1l+Z7z7EXyXFsBBEYsExHLdQNzccd6WxVoqRUEG9e4zQ9uzhl6xVG+yT7eRD
	DPAwwq0A12Gt9aeCW1TVu5nqLdln+zMYmcEFjxqbwAAn/x8RUESfWf/voMjQZToHUNFuqY7vj7f
	X4OwpznE0W0ms/dSTnbWRSZKEv7Z5MLYpsAgaLdg9Xyzt1kEhp4RmEu03jOZcEijczQjuXdvY6f
	KHrbJ2NbL2wLoVhaFIK9If3XPFe3L+r38L5i4vPkzv7Uo9QWRW0lwRgs0WRYsgZlzosDM4KvE=
X-Received: by 2002:a05:6214:450c:b0:91b:ec1d:1746 with SMTP id 6a1803df08f44-91c7d216835mr39651746d6.55.1793197839249;
        Wed, 28 Oct 2026 07:30:39 -0700 (PDT)
X-Received: by 2002:a05:6214:450c:b0:91b:ec1d:1746 with SMTP id 6a1803df08f44-91c7d216835mr39650396d6.55.1793197838400;
        Wed, 28 Oct 2026 07:30:38 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm131076236d6.3.2026.10.28.07.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 07:30:37 -0700 (PDT)
Message-ID: <f4cbbca9e8b743da07902e97b09e49ac7e1cc5fb.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	 <mlombard@redhat.com>, target-devel@vger.kernel.org, 
	michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Wed, 28 Oct 2026 10:30:36 -0400
In-Reply-To: <20261028140221.GB32229@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
	 <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
	 <20261028140221.GB32229@yadro.com>
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

On Wed, 2026-10-28 at 17:02 +0300, Dmitry Bogdanov wrote:
> Hi Laurence,
>=20
> On Tue, Oct 27, 2026 at 04:08:08PM -0400, Laurence Oberman wrote:
> >=20
> > On Tue, 2026-10-27 at 21:01 +0300, Dmitry Bogdanov wrote:
> > > ISCSI has some old leftovers in the code that prevents passing
> > > the
> > > aborted
> > > command to the target core to make the actual abort. Such
> > > commands
> > > hang
> > > until connection is closed.
> > > So remove those leftovers.
> > >=20
> > > Dmitry Bogdanov (2):
> > > =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDIN=
G
> > > =C2=A0=C2=A0=C2=A0 commands"
> > > =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
> > >=20
> > > =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 19 ------------------
> > > -
> > > =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> > > =C2=A02 files changed, 27 deletions(-)
> >=20
> > Hello Dmitri
> > Thanks for posting this. I have a series in flight for the same
> > hang:
> >=20
> > https://lore.kernel.org/linux-scsi/20261027122837.2148074-1-loberman@re=
dhat.com/
>=20
> I know, that is why both you and Maurizio in To: field. I want from
> you some comments. Thank you for review.
>=20
> >=20
> > Is the revert maybe aimed at the wrong layer, and the sashiko
> > review of
> > your 2/2 makes the case better than I can: with the fabric check
> > removed, an aborted command reaches target_execute_cmd(),
> > target_cmd_interrupted() queues target_abort_work and returns
> > without
> > changing t_state, the command stays on conn_cmd_list in
> > TRANSPORT_WRITE_PENDING, and iscsit_release_commands_from_conn()
> > completes it a second time if the connection closes.
>=20
> As I said in response to sashiko-bot, that is the current (always be)
> behavior.
> It is not introduced by my patch.
>=20
> > That is the same double completion you are reverting d5869dae5080
> > for.
> > It
> > is not a defect in Maurizio's patch and it will not be fixed by
> > replacing
> > it -- target_cmd_interrupted() records nothing when it queues an
> > abort,
> > so
> > any site that completes an aborted WRITE_PENDING command can be
> > followed
> > by another one. I found this from vmcores on a customer system
> > before
> > either of us posted, so no argument from me that it is real.
>=20
> Not the same, d5869dae5080 greatly increases the probability of the
> double completion by calling target_complete_cmd() which is allowed
> to be
> called only once for the cmd. Calling it twice is wrong by nature.
> Fabric
> module shall call either target_execute_cmd() either
> transport_generic_request_failure(). target_complete_cmd() is for
> backstore modules. That target_complete_cmd() at the iscsi
> connection release is not so good too. But it was intended to be the
> last(and the only) call from fabric driver for the command never be
> in
> the target core.
>=20
> >=20
> > Patch 3 of my series fixes it there, under t_state_lock, for both
> > queueing sites in target_core_transport.c and for every fabric.
> > With
> > that
> > in place your 2/2 is safe and d5869dae5080 does not need reverting
> > for
> > this reason -- which matters, because the revert is not free: that
> > commit
> > carries CVE-2026-97951 and is in 5.10.y, 5.15.y, 6.1.y, 6.6.y,
> > 6.12.y,
> > 6.18.y and 7.2.y.
>=20
> My intention is to not create a situation when there a race is
> possible
> instead of fixing those races.=20
>=20
> > Two questions on 2/2 independent of all that.
> >=20
> > Removing the sense_reason early return in iscsit_execute_cmd()
> > means
> > transport_send_check_condition_and_sense() now runs for an aborted
> > command. It guards only on SCF_SENT_CHECK_CONDITION, never checks
> > CMD_T_ABORTED, and ends in queue_status(); target_handle_abort()
> > also
> > calls queue_status() for a CMD_T_TAS command, and each drops a
> > reference.
> > Can an aborted command with a sense reason send both a CHECK
> > CONDITION
> > and a TASK ABORTED, and drop two references?
>=20
> No, transport_send_check_condition_and_sense will change t_state,
> send
> status and decrease cmd->refcnt and then unblock wait_for_completion
> of
> ABORT/LUN_RESET. Both the commnand and ABORT of that command will be
> completed sucessfully.
> Noone calls target_handle_abort().
>=20
> > And with the early return gone, a LUN_RESET aborting a large WRITE
> > waits in target_put_cmd_and_wait() for the whole remaining data
> > transfer. That is bounded where today it is not, but on a large
> > transfer it may still trip the hung task timeout that made this
> > visible.
> =C2=A0
> That is a idea for a future discussion and improvmens. This patchset
> is
> narrowed to just to fix the stuck of WRITE_PENDING commands.
>=20
> The abort of WRITE_PENDIG command in the state waiting for DataOuts
> currently will wait for the data completion. So, my patch again does
> not
> do worse.
>=20
> > On the overlap: your 2/2 and patch 4 of my series touch the same
> > lines,
> > so only one can apply, and I have no attachment to mine if yours is
> > the
> > better shape. Patches 1 to 3 are core-side and conflict with
> > nothing
> > you have posted.
> >=20
> > Martin, would you prefer those three as their own series,
> > given both candidate iSCSI fixes need patch 3 to be correct?
> >=20
> > I am happy to test either or both: I have a reporter's environment
> > that
> > reproduces this reliably and 300-cycle runs on it.
>=20
> My patch is more than 2 years old in customers setups, but certainly
> it would be great to test it in other environments too.
>=20
> BR,
> =C2=A0Dmitry

OK Great, reverting d5869dae5080 and applying yours and getting it
tested. If it passes than we can revisit my patches 1-3 for a later
series.

On testing: I will build revert + your 2/2 on a RHEL9.8 based distro
kernel and put it through the reporter's environment -- an Oracle RAC
cluster where this reproduces reliably and where the earlier candidate
fixes failed at 95 and 196 LUN_RESET cycles. The pass mark is 300
cycles, which is what my patch 4 cleared twice. I will deliberately
leave my core patches out of that build so the result is about your
series alone.

Thanks for all your reviews and assistance.
Laurence

