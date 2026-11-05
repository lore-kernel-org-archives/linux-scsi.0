Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793884632;
	b=Rrme9BL583214U/kL/kNtoidBdbMckLOCIGn+GThRrtEy+RENI+GZOd3CJ/Sbudf/7+z
	 6/v086e0tFmsjRnBN23jA18OyjU9rtQ3EDcEih43a8mexjd69hZE6kQPU1tfu1JYgohFn
	 yj8NXkgcodyl/4hR1bPaRIOXwd+YAuw+ExZbBO+XVMMVA4c2/l+tGjSi0tkCppv+10OtM
	 TI0YS3intDUZlLwn1fFmRac3TbcoKrg2weRifM7Ww9mzAXDKxn9ZMvewCerK13p7GOlG1
	 8SDSzD8cdjma4bFM17K9i5w+CtApllfJvwEUT+3cLERCeBqsCqpjxqk5x8QbC6/2d5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884632;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=TVN4qqEOEmUzptSUX7FyaNSftImC/cckkBEy4eaZCfg=;
	b=Chlu5Kmlv7KmODS0bgkcJeudqCmmRxK1p2sWlPt4ICYhw2rRPta8s4zhhrTQQwHBagrO
	 d+VVY1KmWbapl7/Cb0pMxhW9I/AjVm/QjYWnwured4EPXPGd2Bv6FVo4eyo2uFCSE9CEv
	 UFEUer949/m5FhtKsyISKwnMoBjzmW07ixOu6GkrKyZaKfGfhTxfGaEvRrspucxJQaA0L
	 1UPG5WcbWpgUM04jRcHIdvU1ofE7HuPFRLZIIZ+01fCnhBAFBh4W8Z+ZM4nsb3dxV1XVy
	 yum1oYvoBInwpdQnot5ImEzA3680kYOfwPLp3DLT6Efg80HTyHA6xBNaoyXiVnz1G0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=C3fTSWsB;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ZnPw8rAT;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42582606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 13:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42582606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=C3fTSWsB;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ZnPw8rAT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793884629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TVN4qqEOEmUzptSUX7FyaNSftImC/cckkBEy4eaZCfg=;
	b=C3fTSWsB8YqgsuUw3BKo0gXo1jHmgoAE69J3xOBD813wJr/i48YkX6CFPVlSrpTU2HV/7B
	3p8XWCHlySUSwPzvuM7tRLGFA3SA2z+FaE8hRTCUQ6AvB76xzl4QTZVgccbdSwLSBBmjBa
	gsVL4JTiIw+4kehHDaIdPMRUfWSBQnc=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-FQNhh6cfNxKeNEBTHAPm8w-1; Thu, 05 Nov 2026 08:17:05 -0500
X-MC-Unique: FQNhh6cfNxKeNEBTHAPm8w-1
X-Mimecast-MFC-AGG-ID: FQNhh6cfNxKeNEBTHAPm8w_1793884625
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-8b109c28fcaso15928267b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 05:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793884625; x=1794489425; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TVN4qqEOEmUzptSUX7FyaNSftImC/cckkBEy4eaZCfg=;
        b=ZnPw8rATyVk09jGWCji0No6Sit10PBgDRBs1zQ2M5QFbBTEMo0qmq/6ehvxWToBU/T
         TwTq2ApGW2gV5dJzUZqIFFm0suGIX/4W2q82mvRL/d4i7dySsqAKFatdmLRbc717/qT/
         uWjPVF36VdoVJK95L9KDeDp+uBxc9xo950LjxY5oy3SQvA09xA0MhRlKl7VRCbyCdVoo
         sSmxTS/WD3AQAOkqTFt8BdsErsD9HQnLbqlIbWDflUxInuUxldbABSD025opIF9CFvz4
         G8QQ4ecnig2Mu6v8XX8NUCZGbyx8pqLnzXbxL/t1Gs4Vc1B6kQ9zILprvMyBRHqZplz0
         xdDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793884625; x=1794489425;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TVN4qqEOEmUzptSUX7FyaNSftImC/cckkBEy4eaZCfg=;
        b=MloKI3SxAO7S0yt3T0GtVZ6twOgL0VP79WG/0xxUOsJHKAttVOts+bLQ1wi8f8Jdw6
         ytTNaoaCq0jaD+FKl9HeIcAjysaXTUU2swLxZzjPUN9JLOpCcfwjH0Ob49mVoDpIxENn
         IFXu1uowlZDq68FQlEwE7lAP3Tth4UEbinJWaPtB7KhO0Z4Pe7AWisthZsn7YPfdjaFL
         fX/h8TyPTBDccgLsPPjAh4Sq2glmdx1h/stzm/7vEO2lOIiociMDXlPgvrSuSLunfim0
         DH8rDbqSGDKpqv9VuYjWQUe1qec9SxdP2zzYckBofp3ahqmd+o1eniYXUbstPKpn2ca6
         Mq/g==
X-Forwarded-Encrypted: i=1; AKwUvBxGTfomwAaGQ0NleFyOQFbfHvAvv+2lfmAvzQFBodL7ozOAjDxcjAFhnf5pHvUJvjSs7mC79SlMgMWw@vger.kernel.org
X-Gm-Message-State: APuU4Z+jin1p2bXNrchTkpSVey79SoMZw6GecJkRq3SQd6331D2jmF/S
	IM0280KH0p6dcO5gM6am4pH0xMjILpYnYDSYOVz9ZIe8WmRS6Vo/8TOmyc5r2HN6kbHT8jz1L7D
	hheL6sw8vk8cVjk1fGaJ5OTjWhj34DkbtCoGPp2vk/F4yOZQVN13Jz3URa7pCC2s=
X-Gm-Gg: AYBFou3GQrd9406muZWuOpK+hE0pEyGwxq0AxfaqCPH2dp9HreuvGxE27GYeu4ew+3N
	jK4YydKF7h4MqkzYcu9BF2rLTWeZmfcc20VzEZD+4KDvnz7OIr7RKcr3krJ6nNM8E4iLa2vtfl1
	GL2WEJJwiw6GbGQFrdndMX9fBV05WJAtVt70gOlC9L5mb6mXoPbMRCe1cSfnZw6jf1GJZPp+57T
	CkywC3RIdFnj786p7be/ER+YKKSOQBbeX+umCOOyQMvvl51exhjOsy301rjsqyHf51qHpVqFh0y
	1mRHQGLbeSWvj7+SfVfntZIexmkhK408iRQ0nBvkp53OomVWyfrX+hBmyY+J0v8uFfdjcV0gppu
	4jdxqXdeVSfOcGKG62LQYP0OdOampZnAb5PMcRkHDUGof/Lu6RukO3N70yHTqD80UkczLzA+XQA
	ZFZTOPfT4e0SbRllGMMcWIOp2I4QaflG1rZmyPRKyyGJiKJCvvaquZbRx6j4m0jVDb3P6hpbU=
X-Received: by 2002:a05:690e:2046:b0:675:6f9d:dd53 with SMTP id 956f58d0204a3-67ba4c90a38mr8239517d50.8.1793884624729;
        Thu, 05 Nov 2026 05:17:04 -0800 (PST)
X-Received: by 2002:a05:690e:2046:b0:675:6f9d:dd53 with SMTP id 956f58d0204a3-67ba4c90a38mr8239506d50.8.1793884624188;
        Thu, 05 Nov 2026 05:17:04 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bedc40ac4sm3479221d50.0.2026.11.05.05.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 05:17:03 -0800 (PST)
Message-ID: <0e12bf8de941ab70a7eb2136fb794cf1dc4bfd8d.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	 <mlombard@redhat.com>, target-devel@vger.kernel.org, 
	michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Thu, 05 Nov 2026 08:17:01 -0500
In-Reply-To: <7e08a1f08defd24b42722ce0ad52326ff59236cd.camel@redhat.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
			 <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
			 <20261028140221.GB32229@yadro.com>
		 <f4cbbca9e8b743da07902e97b09e49ac7e1cc5fb.camel@redhat.com>
	 <7e08a1f08defd24b42722ce0ad52326ff59236cd.camel@redhat.com>
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

On Tue, 2026-11-03 at 08:08 -0500, Laurence Oberman wrote:
> On Wed, 2026-10-28 at 10:30 -0400, Laurence Oberman wrote:
> > On Wed, 2026-10-28 at 17:02 +0300, Dmitry Bogdanov wrote:
> > > Hi Laurence,
> > >=20
> > > On Tue, Oct 27, 2026 at 04:08:08PM -0400, Laurence Oberman wrote:
> > > >=20
> > > > On Tue, 2026-10-27 at 21:01 +0300, Dmitry Bogdanov wrote:
> > > > > ISCSI has some old leftovers in the code that prevents
> > > > > passing
> > > > > the
> > > > > aborted
> > > > > command to the target core to make the actual abort. Such
> > > > > commands
> > > > > hang
> > > > > until connection is closed.
> > > > > So remove those leftovers.
> > > > >=20
> > > > > Dmitry Bogdanov (2):
> > > > > =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted
> > > > > WRITE_PENDING
> > > > > =C2=A0=C2=A0=C2=A0 commands"
> > > > > =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
> > > > >=20
> > > > > =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 19 --------------
> > > > > --
> > > > > --
> > > > > -
> > > > > =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> > > > > =C2=A02 files changed, 27 deletions(-)
> > > >=20
> > > > Hello Dmitri
> > > > Thanks for posting this. I have a series in flight for the same
> > > > hang:
> > > >=20
> > > > https://lore.kernel.org/linux-scsi/20261027122837.2148074-1-loberma=
n@redhat.com/
> > >=20
> > > I know, that is why both you and Maurizio in To: field. I want
> > > from
> > > you some comments. Thank you for review.
> > >=20
> > > >=20
> > > > Is the revert maybe aimed at the wrong layer, and the sashiko
> > > > review of
> > > > your 2/2 makes the case better than I can: with the fabric
> > > > check
> > > > removed, an aborted command reaches target_execute_cmd(),
> > > > target_cmd_interrupted() queues target_abort_work and returns
> > > > without
> > > > changing t_state, the command stays on conn_cmd_list in
> > > > TRANSPORT_WRITE_PENDING, and
> > > > iscsit_release_commands_from_conn()
> > > > completes it a second time if the connection closes.
> > >=20
> > > As I said in response to sashiko-bot, that is the current (always
> > > be)
> > > behavior.
> > > It is not introduced by my patch.
> > >=20
> > > > That is the same double completion you are reverting
> > > > d5869dae5080
> > > > for.
> > > > It
> > > > is not a defect in Maurizio's patch and it will not be fixed by
> > > > replacing
> > > > it -- target_cmd_interrupted() records nothing when it queues
> > > > an
> > > > abort,
> > > > so
> > > > any site that completes an aborted WRITE_PENDING command can be
> > > > followed
> > > > by another one. I found this from vmcores on a customer system
> > > > before
> > > > either of us posted, so no argument from me that it is real.
> > >=20
> > > Not the same, d5869dae5080 greatly increases the probability of
> > > the
> > > double completion by calling target_complete_cmd() which is
> > > allowed
> > > to be
> > > called only once for the cmd. Calling it twice is wrong by
> > > nature.
> > > Fabric
> > > module shall call either target_execute_cmd() either
> > > transport_generic_request_failure(). target_complete_cmd() is for
> > > backstore modules. That target_complete_cmd() at the iscsi
> > > connection release is not so good too. But it was intended to be
> > > the
> > > last(and the only) call from fabric driver for the command never
> > > be
> > > in
> > > the target core.
> > >=20
> > > >=20
> > > > Patch 3 of my series fixes it there, under t_state_lock, for
> > > > both
> > > > queueing sites in target_core_transport.c and for every fabric.
> > > > With
> > > > that
> > > > in place your 2/2 is safe and d5869dae5080 does not need
> > > > reverting
> > > > for
> > > > this reason -- which matters, because the revert is not free:
> > > > that
> > > > commit
> > > > carries CVE-2026-97951 and is in 5.10.y, 5.15.y, 6.1.y, 6.6.y,
> > > > 6.12.y,
> > > > 6.18.y and 7.2.y.
> > >=20
> > > My intention is to not create a situation when there a race is
> > > possible
> > > instead of fixing those races.=20
> > >=20
> > > > Two questions on 2/2 independent of all that.
> > > >=20
> > > > Removing the sense_reason early return in iscsit_execute_cmd()
> > > > means
> > > > transport_send_check_condition_and_sense() now runs for an
> > > > aborted
> > > > command. It guards only on SCF_SENT_CHECK_CONDITION, never
> > > > checks
> > > > CMD_T_ABORTED, and ends in queue_status();
> > > > target_handle_abort()
> > > > also
> > > > calls queue_status() for a CMD_T_TAS command, and each drops a
> > > > reference.
> > > > Can an aborted command with a sense reason send both a CHECK
> > > > CONDITION
> > > > and a TASK ABORTED, and drop two references?
> > >=20
> > > No, transport_send_check_condition_and_sense will change t_state,
> > > send
> > > status and decrease cmd->refcnt and then unblock
> > > wait_for_completion
> > > of
> > > ABORT/LUN_RESET. Both the commnand and ABORT of that command will
> > > be
> > > completed sucessfully.
> > > Noone calls target_handle_abort().
> > >=20
> > > > And with the early return gone, a LUN_RESET aborting a large
> > > > WRITE
> > > > waits in target_put_cmd_and_wait() for the whole remaining data
> > > > transfer. That is bounded where today it is not, but on a large
> > > > transfer it may still trip the hung task timeout that made this
> > > > visible.
> > > =C2=A0
> > > That is a idea for a future discussion and improvmens. This
> > > patchset
> > > is
> > > narrowed to just to fix the stuck of WRITE_PENDING commands.
> > >=20
> > > The abort of WRITE_PENDIG command in the state waiting for
> > > DataOuts
> > > currently will wait for the data completion. So, my patch again
> > > does
> > > not
> > > do worse.
> > >=20
> > > > On the overlap: your 2/2 and patch 4 of my series touch the
> > > > same
> > > > lines,
> > > > so only one can apply, and I have no attachment to mine if
> > > > yours
> > > > is
> > > > the
> > > > better shape. Patches 1 to 3 are core-side and conflict with
> > > > nothing
> > > > you have posted.
> > > >=20
> > > > Martin, would you prefer those three as their own series,
> > > > given both candidate iSCSI fixes need patch 3 to be correct?
> > > >=20
> > > > I am happy to test either or both: I have a reporter's
> > > > environment
> > > > that
> > > > reproduces this reliably and 300-cycle runs on it.
> > >=20
> > > My patch is more than 2 years old in customers setups, but
> > > certainly
> > > it would be great to test it in other environments too.
> > >=20
> > > BR,
> > > =C2=A0Dmitry
> >=20
> > OK Great, reverting d5869dae5080 and applying yours and getting it
> > tested. If it passes than we can revisit my patches 1-3 for a later
> > series.
> >=20
> > On testing: I will build revert + your 2/2 on a RHEL9.8 based
> > distro
> > kernel and put it through the reporter's environment -- an Oracle
> > RAC
> > cluster where this reproduces reliably and where the earlier
> > candidate
> > fixes failed at 95 and 196 LUN_RESET cycles. The pass mark is 300
> > cycles, which is what my patch 4 cleared twice. I will deliberately
> > leave my core patches out of that build so the result is about your
> > series alone.
> >=20
> > Thanks for all your reviews and assistance.
> > Laurence
> Hello Dmitry
>=20
> OK, your series looks great, we passed 3000 reset loops so we should
> take your series in ASAP.
>=20
> For the series:
> Reviewed-by: Laurence Oberman <loberman@redhat.com>
> Tested-by:=C2=A0=C2=A0 Laurence Oberman <loberman@redhat.com>
>=20
> Regards
> Laurence Oberman

Gentle ping on this one, I really needing Dmitry's series to be taken.=C2=
=A0
A large customer is waiting so we can include this in RHEL.
I did lots of testing and due diligence on this issue.
Thanks as always=20
Laurence

