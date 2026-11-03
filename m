Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711298;
	b=Qa1uJNuePSBFNmmlbD5vbrn9rBAN+7AUg/2yrhhRkaACx7s371Dilmai9ADFlee3zbLe
	 4tkoVrQx2t0WHW9CDRX8K1j7P2c/dIkmsQTUA1qq+cA3oEn0tAtv+EXqP7SNyOfWN6ZcA
	 M0JoLBL++j+hEpuufEWZiOXeTKTXGax+T69CJRqD4ICazZY7IwNMalm63Om78pEZfIAPQ
	 vVS+pFfLIy86gtIpxRI+HAXnTU542flaR4hfNlLlMcEY50jenbDayOWN80JLvPjGsZEkk
	 vY8AbbGaoFxwbmU/Cx0lbzQkZ5aAuBBkuA0kRalJdLZgFd4vstNETZQDlpghr3MZptA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711298;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=JweHxHOgQQEqqfkoSADQQDEsVhp2wjrIIS3nJ/SiuXQ=;
	b=fZ7sBEg7POFU+ilTRDUwMfjC7QaNn7aW0cM/s5SgNYan4+oY8czcYCnuaB2k9XZFJ+Pi
	 HXlI/oHiX+mY/g+/JGD/A47wsk/EmqCTME0QTDp7xQ72bafWl1JwC4eZx1OrLDN+pEtns
	 0HFV4LgjWjdn/RbzvUaULlXCM81m9vbvrVOWqydVtF0Csi/5E9O5S+ejQhOhpQMxfKDUW
	 BdzuxIZkqPrM/c1Pv56gt+DNz8CkcANsSCaX/SDhkvuswrn5sHbu/2ZELIEqr72Vav+0I
	 6poUvzXv28i/u4TqwiBWY3nC2oNIQDVd0a5pVEURm7OeSurUBLeBNdSvCcEuom6Z1iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UFaKxwSv;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dUodlXJe;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C88B60A2602
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 13:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C88B60A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UFaKxwSv;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dUodlXJe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793711296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JweHxHOgQQEqqfkoSADQQDEsVhp2wjrIIS3nJ/SiuXQ=;
	b=UFaKxwSvQ2i06ocyjAV+G20PaK85H8vx4CyrErCH7+Aj/jABJecH5jRDEPzhsKdmVguxTz
	DJfpz2UgBlP7gNtMXV8SuYq4Stt5ge4wYNkLkQB6C7mCKbvmM7oGEXoFHBSOTbPBQh3U5A
	LPx6ZOqCkD6xW1iqVKjE8TjU6iEeLHA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-wpDTkF_JNM2rrZCp9q73ng-1; Tue, 03 Nov 2026 08:08:15 -0500
X-MC-Unique: wpDTkF_JNM2rrZCp9q73ng-1
X-Mimecast-MFC-AGG-ID: wpDTkF_JNM2rrZCp9q73ng_1793711295
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93cb71b1443so859185185a.2
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2026 05:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793711295; x=1794316095; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=JweHxHOgQQEqqfkoSADQQDEsVhp2wjrIIS3nJ/SiuXQ=;
        b=dUodlXJeH1mtjhklU9OYb+ab+2VpHsQ3JmQ0Nm+HpzmkcAjdZAEMVIuXUeBLty604y
         5/0fg5bA/d37fsI9nvaRzdr01aASYkb95wpxZmQLuqLEmQAW8BjRIgQI9/9F2oZwgaOv
         TZuhz1nStvdq9ftevqGmcYDFTLeL969wvH2EHKxYQdY2d2P+p75LpFS2oPw+G1WVWaee
         /5c2e8Zmko24JKNUaSffKdPhI26QyvQdxHFymzVfZeExHjOAuurvEzS85DcCrOq6AoOQ
         1NCRaHGoqYXD4j5tcZOmpPMv0PQfz1YfSa00izSaErLKKZFYjYViIbZo2swPHbsw7R9C
         Iy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793711295; x=1794316095;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JweHxHOgQQEqqfkoSADQQDEsVhp2wjrIIS3nJ/SiuXQ=;
        b=fc1wV+FUZisgaAlqTI24VN3/oUtflhgbyS+Wr0CyNKR+8O/eERHGb9MciauTqQaMoc
         fNXvI+Cyh/lJProlLvXguSivWc4Y+DPnDgtCQixm8mqZ76lEKv9jWij2sWia4ERIjuPm
         z+RUALk4QIayAW2hW7jekX0zS/85yn9B6tlqEhy0jHa+H9DzWZIfbAbwIoGCgFWUnZin
         5bJP/zol9zHKnZL0XHM+/vzxki0oM1u1gbxJAqp5YJgP5iZ2Cx4a7WlMoCJCVpq02Qfg
         rI22cLq9UyQDejKCYBmCvMzWiC6TNErFzF9Z/bfxX5VISz8l0eZezr56fs6b0iZ76B4z
         Rn1g==
X-Forwarded-Encrypted: i=1; AKwUvByMESFW37Gz4BKLVtx0FZinJwbGARTypz/Z1rk8YU4j+GUS+nBgfyHhzcTavFof7CCiQRWkg8k+QNqt@vger.kernel.org
X-Gm-Message-State: APuU4Z+qZKA0rynQ/ghfgZSv2xyXUDSxmSnCC5FauJCXxh/mpVTVcrr5
	ynQDPhYcPtQSTIhQxHenPZlsCyhEs5KdMrfSB/H0YSv8HCDbhfuZry/GOZRa0joLkkycwG1tORu
	3KWSUXjKNIhviU7uHzxgBr/O4fA/yuwKgiB4InGqYGk3oFHIrfpQS8efpMzKsSwU=
X-Gm-Gg: AYBFou1lwT8X0VygsIAO6p3lCsDihhWWgv27ZWSaPH0VfQtpuaZZZm97X8vEOB4I4K2
	uUS5reAb0Q/coy8yvL+s7B+oD/Y/WyfFoDFiM381+DD5HNn3UYo3mypgqe/gFwyyGDsxLOWAzg3
	LwkxB4nmgicb8KvOVGXtITsFDzLcSBvWkchJLaoUZDnJbxqKumlCMGoF0GLvoqr1mNv8LA+SE9E
	2XRoRrheiNUtGN2SVqOZ1ENr204VsmPyQ2jXNRRK294/WagAmKwoZpFR24JLeYHOoR5kQXsxAJn
	+IAFjlWeO1VchOw+37Js90ND0WGsxPkwvM5ac2och9rVQfa9UzoexYwtVb+iizwbkGqWh+4ocGX
	+Odp5Iziw/WsoXcbmQqCdXlTcVoUPuXg0o5+pNU+KcO1Es7dj3AiPTbrY+CU21o2GO1ocJlcenj
	eeVlXdZdJRLGBmLk7dShcych+CBeKfbiXV9gjSMPdfqwFtzp6V3Haq5gWTfdbYrCtK1IAKq+4=
X-Received: by 2002:ac8:5d14:0:b0:533:4da1:b5d1 with SMTP id d75a77b69052e-542b659318bmr211569811cf.23.1793711294294;
        Tue, 03 Nov 2026 05:08:14 -0800 (PST)
X-Received: by 2002:ac8:5d14:0:b0:533:4da1:b5d1 with SMTP id d75a77b69052e-542b659318bmr211568931cf.23.1793711293406;
        Tue, 03 Nov 2026 05:08:13 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5498b49d829sm25499641cf.8.2026.11.03.05.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:08:12 -0800 (PST)
Message-ID: <7e08a1f08defd24b42722ce0ad52326ff59236cd.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	 <mlombard@redhat.com>, target-devel@vger.kernel.org, 
	michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Tue, 03 Nov 2026 08:08:10 -0500
In-Reply-To: <f4cbbca9e8b743da07902e97b09e49ac7e1cc5fb.camel@redhat.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
		 <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
		 <20261028140221.GB32229@yadro.com>
	 <f4cbbca9e8b743da07902e97b09e49ac7e1cc5fb.camel@redhat.com>
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

On Wed, 2026-10-28 at 10:30 -0400, Laurence Oberman wrote:
> On Wed, 2026-10-28 at 17:02 +0300, Dmitry Bogdanov wrote:
> > Hi Laurence,
> >=20
> > On Tue, Oct 27, 2026 at 04:08:08PM -0400, Laurence Oberman wrote:
> > >=20
> > > On Tue, 2026-10-27 at 21:01 +0300, Dmitry Bogdanov wrote:
> > > > ISCSI has some old leftovers in the code that prevents passing
> > > > the
> > > > aborted
> > > > command to the target core to make the actual abort. Such
> > > > commands
> > > > hang
> > > > until connection is closed.
> > > > So remove those leftovers.
> > > >=20
> > > > Dmitry Bogdanov (2):
> > > > =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted
> > > > WRITE_PENDING
> > > > =C2=A0=C2=A0=C2=A0 commands"
> > > > =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
> > > >=20
> > > > =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 19 ----------------
> > > > --
> > > > -
> > > > =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> > > > =C2=A02 files changed, 27 deletions(-)
> > >=20
> > > Hello Dmitri
> > > Thanks for posting this. I have a series in flight for the same
> > > hang:
> > >=20
> > > https://lore.kernel.org/linux-scsi/20261027122837.2148074-1-loberman@=
redhat.com/
> >=20
> > I know, that is why both you and Maurizio in To: field. I want from
> > you some comments. Thank you for review.
> >=20
> > >=20
> > > Is the revert maybe aimed at the wrong layer, and the sashiko
> > > review of
> > > your 2/2 makes the case better than I can: with the fabric check
> > > removed, an aborted command reaches target_execute_cmd(),
> > > target_cmd_interrupted() queues target_abort_work and returns
> > > without
> > > changing t_state, the command stays on conn_cmd_list in
> > > TRANSPORT_WRITE_PENDING, and iscsit_release_commands_from_conn()
> > > completes it a second time if the connection closes.
> >=20
> > As I said in response to sashiko-bot, that is the current (always
> > be)
> > behavior.
> > It is not introduced by my patch.
> >=20
> > > That is the same double completion you are reverting d5869dae5080
> > > for.
> > > It
> > > is not a defect in Maurizio's patch and it will not be fixed by
> > > replacing
> > > it -- target_cmd_interrupted() records nothing when it queues an
> > > abort,
> > > so
> > > any site that completes an aborted WRITE_PENDING command can be
> > > followed
> > > by another one. I found this from vmcores on a customer system
> > > before
> > > either of us posted, so no argument from me that it is real.
> >=20
> > Not the same, d5869dae5080 greatly increases the probability of the
> > double completion by calling target_complete_cmd() which is allowed
> > to be
> > called only once for the cmd. Calling it twice is wrong by nature.
> > Fabric
> > module shall call either target_execute_cmd() either
> > transport_generic_request_failure(). target_complete_cmd() is for
> > backstore modules. That target_complete_cmd() at the iscsi
> > connection release is not so good too. But it was intended to be
> > the
> > last(and the only) call from fabric driver for the command never be
> > in
> > the target core.
> >=20
> > >=20
> > > Patch 3 of my series fixes it there, under t_state_lock, for both
> > > queueing sites in target_core_transport.c and for every fabric.
> > > With
> > > that
> > > in place your 2/2 is safe and d5869dae5080 does not need
> > > reverting
> > > for
> > > this reason -- which matters, because the revert is not free:
> > > that
> > > commit
> > > carries CVE-2026-97951 and is in 5.10.y, 5.15.y, 6.1.y, 6.6.y,
> > > 6.12.y,
> > > 6.18.y and 7.2.y.
> >=20
> > My intention is to not create a situation when there a race is
> > possible
> > instead of fixing those races.=20
> >=20
> > > Two questions on 2/2 independent of all that.
> > >=20
> > > Removing the sense_reason early return in iscsit_execute_cmd()
> > > means
> > > transport_send_check_condition_and_sense() now runs for an
> > > aborted
> > > command. It guards only on SCF_SENT_CHECK_CONDITION, never checks
> > > CMD_T_ABORTED, and ends in queue_status(); target_handle_abort()
> > > also
> > > calls queue_status() for a CMD_T_TAS command, and each drops a
> > > reference.
> > > Can an aborted command with a sense reason send both a CHECK
> > > CONDITION
> > > and a TASK ABORTED, and drop two references?
> >=20
> > No, transport_send_check_condition_and_sense will change t_state,
> > send
> > status and decrease cmd->refcnt and then unblock
> > wait_for_completion
> > of
> > ABORT/LUN_RESET. Both the commnand and ABORT of that command will
> > be
> > completed sucessfully.
> > Noone calls target_handle_abort().
> >=20
> > > And with the early return gone, a LUN_RESET aborting a large
> > > WRITE
> > > waits in target_put_cmd_and_wait() for the whole remaining data
> > > transfer. That is bounded where today it is not, but on a large
> > > transfer it may still trip the hung task timeout that made this
> > > visible.
> > =C2=A0
> > That is a idea for a future discussion and improvmens. This
> > patchset
> > is
> > narrowed to just to fix the stuck of WRITE_PENDING commands.
> >=20
> > The abort of WRITE_PENDIG command in the state waiting for DataOuts
> > currently will wait for the data completion. So, my patch again
> > does
> > not
> > do worse.
> >=20
> > > On the overlap: your 2/2 and patch 4 of my series touch the same
> > > lines,
> > > so only one can apply, and I have no attachment to mine if yours
> > > is
> > > the
> > > better shape. Patches 1 to 3 are core-side and conflict with
> > > nothing
> > > you have posted.
> > >=20
> > > Martin, would you prefer those three as their own series,
> > > given both candidate iSCSI fixes need patch 3 to be correct?
> > >=20
> > > I am happy to test either or both: I have a reporter's
> > > environment
> > > that
> > > reproduces this reliably and 300-cycle runs on it.
> >=20
> > My patch is more than 2 years old in customers setups, but
> > certainly
> > it would be great to test it in other environments too.
> >=20
> > BR,
> > =C2=A0Dmitry
>=20
> OK Great, reverting d5869dae5080 and applying yours and getting it
> tested. If it passes than we can revisit my patches 1-3 for a later
> series.
>=20
> On testing: I will build revert + your 2/2 on a RHEL9.8 based distro
> kernel and put it through the reporter's environment -- an Oracle RAC
> cluster where this reproduces reliably and where the earlier
> candidate
> fixes failed at 95 and 196 LUN_RESET cycles. The pass mark is 300
> cycles, which is what my patch 4 cleared twice. I will deliberately
> leave my core patches out of that build so the result is about your
> series alone.
>=20
> Thanks for all your reviews and assistance.
> Laurence
Hello Dmitry

OK, your series looks great, we passed 3000 reset loops so we should
take your series in ASAP.

For the series:
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Tested-by:   Laurence Oberman <loberman@redhat.com>

Regards
Laurence Oberman

