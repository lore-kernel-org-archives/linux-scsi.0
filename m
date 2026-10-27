Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131695;
	b=wSy+lRIgX1ykioHlnfzS1Lu4dLmm6ac3CZoEu8eCS59VmTmmf2Mx6CVNYDXfrt3GpBe/
	 Yic2I16VOfMiT5rioByClub8ZD9do0NYSZFH1p1r064z6oWrJJBcFbjQ0cicZX/EY0uKc
	 wpTjvpGiPOhxcTFyPa4ArEBX3nCl5rNGUoBgaxadwfzPMU+DJYid5a80nIhwdrvbExja4
	 1pWyqS+0iwwAvKjrBdsLgjU07iuPH918wkOYISCcbz2IJGi6F1r31q9/VZ3CTpg28BAQ5
	 rhpSm1EkZnr3RgZ66JTPlgo/M10w86RqAFhyUVgKtOCYKk0hUT/iGhd7YQFmFqnQm5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131695;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=1YJHX2FJISPkStTvYFWPCn9XZ+gAuo9LLswhwwgRlLw=;
	b=aDhk4eG9bW56DUkVedfmglHwMyja70VxfnRDaLwlFGpgCv819P37APoWpj5mOcmnnmhb
	 2iq9PI98E/WFAdBSUHNVzj0p2s/V3c3xwyivZ6PfYqFS5miT60IMeCJAXinaEiMWN8a4y
	 orwp4KxcWSm9XMF1agiBJh7Hsv/keoSZrRAIjaMjCrjZAhnXffhU1oQNam25oE3fCBGX+
	 KtCedh66WaBnBR8y5bXQy6CljnYie8Q8AdrBTH4x9W9LACY00LcqxlDHRPVY7Yzm5wOtQ
	 LE7a8GVyNzu5sk8cpmsKvqrPXe1ZbszME+Kp1HwUHUg+0Mo4eVGcDFUtmVbIAIY2/iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aR8cSDd9;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=q8+kAvfn;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5320B606A320
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 20:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5320B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aR8cSDd9;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=q8+kAvfn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793131694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YJHX2FJISPkStTvYFWPCn9XZ+gAuo9LLswhwwgRlLw=;
	b=aR8cSDd9jMORIlbWKoSTde0HER1rCk+/qw9qZ3Rorzf5B8ZzFryiAXcCyXp065CumI04+F
	7RxbO6VXwbf7HTuR7zmWFjdQkFEwrUOn8pS9/NXd6geseMQ5pkkjYFzs8zMsriPnR2o55S
	JoSzb9vzyPW4Q56almJz4e6Ja7NEDl0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-TzsX9k55NF2i0m42QVzeCQ-1; Tue, 27 Oct 2026 16:08:11 -0400
X-MC-Unique: TzsX9k55NF2i0m42QVzeCQ-1
X-Mimecast-MFC-AGG-ID: TzsX9k55NF2i0m42QVzeCQ_1793131691
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5337f26ee19so8555991cf.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 13:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793131691; x=1793736491; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1YJHX2FJISPkStTvYFWPCn9XZ+gAuo9LLswhwwgRlLw=;
        b=q8+kAvfnx8sybzGir6W5dQI4xnjenBkEH9mhZZhY3vmDnaU25E9waAZMqgZ1gjaF7j
         1tA4/kQq6I3ChmaFGydy9MzP4RW+WtSrp+sf48ex+Xbfq8cqnnDHfp1JdJDGSj6a+E30
         04aU0DAQgafipdhLqT/9sr+BY5eWU/i435zBAcHeWZHV+Zc2HqrBYgknqdoePO1sAC6Q
         GkFVr/Gc7Ma2SwDj5AbPYNX7qf/t3Fva3GKVkJ1abRwNengs9SvVMsSX71OeTt6p8Ws/
         +G8mHI6GR/j4vnrABLDvF1uPXkbQmxyYv/MV0+BW8Jniz/s5OIu/jfh411639535HqIk
         nkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793131691; x=1793736491;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1YJHX2FJISPkStTvYFWPCn9XZ+gAuo9LLswhwwgRlLw=;
        b=IRFe9tB1mQhE4DWRWc6k5lSE7PtZlXD+Rfay0vVmtc8EmwDcUWuIBW9Z8rhIRlJAoV
         QRgY4YGZU/OhK0X4FlO9pXAFl770HclL3B/SFphNcvrp3l2v8ng8bJNg4V56+kTA1lP3
         G5GaY2OCBQXnXfzKEFAkzUT1PRDjP3wLSGIREmORyPHxaY7nyRrqSYRZ3QPLXLc+fNRp
         lIv2h9uGHWNQU80DZuPvlyyjwFIADthIfyNm9iSIdNvLDiCDMhZLwHeg3A22TNkJniPs
         3HjsQIkT00DiDe52n8XCKF8aPOJOhbOxjZ4Nu9c0KLmTzu6LW1UbxiDZDCDMY7se0A6F
         aHSQ==
X-Forwarded-Encrypted: i=1; AKwUvByOOvkoKifwrlCXo9AxdWBAo+R+WLot8kHv9Hw+2+HnEy4z+jVFuJJfNrGqBrXEkGNyzyk4AZejc/0J@vger.kernel.org
X-Gm-Message-State: AFq9FYLFRFxS35okhPKd7+wGuQotqoIZNrE/8OnmkvevmL6SSdzAmfqC
	4byVvlFeeTM9v9fE5RC68NJeUxltkEEaP3xYLF3R06KVroHWDu3HCtkzoyJAtvSVVxnj93zJ/uw
	KlhAw3396CT1lFNvqxwnVNz86U7vlDupusAqG6w31BRlk/kv0ToetmBHfu8ILW5Y=
X-Gm-Gg: AYBFou1l/d8lKhHyvIiOpZB0GZ2beWUhHDkbaSpNvYJo+vv9Qwmew3jHOCVcnbfL2Bx
	Tl0vDm/ATOt2P2jcY9De6pCJnod4XQAuFYKO/RIL96D/mU1HPFUBz/1hNV1u8Rl8aEGVXZZEKGM
	hd+HzWwf2rVG+4Yr7MZzMNaYIBFzlsZWh67tzeU11pr917Nt+9wTIiRF8dM4PO6AabEhu2NZKpj
	EPUcvU2LeR+tF59ilTn0xwyXQpxTS6EYn5jjV4svECUSq2dMpGd0IVQnoCZioM58FuPTW/qUsGt
	/jR2+oIlEkXKtU0ud/JwuvO+VN+z1T/HzS0cGOu7XcB1prmGQ4jIez1Gw3ywsBkDSv9GAhYwS+u
	1mNfAggxsup0tfT2wK8rw0E/ejo3emenfArfQ+23JCycEirAYOHr5nJ17AW+42YK6ebNTaDF+uf
	3eJmYeaggID1yjzg4=
X-Received: by 2002:a05:622a:1822:b0:533:983b:e53f with SMTP id d75a77b69052e-53fcd197865mr6547521cf.59.1793131691229;
        Tue, 27 Oct 2026 13:08:11 -0700 (PDT)
X-Received: by 2002:a05:622a:1822:b0:533:983b:e53f with SMTP id d75a77b69052e-53fcd197865mr6546721cf.59.1793131690641;
        Tue, 27 Oct 2026 13:08:10 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([96.39.69.186])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53838cf49c9sm87523701cf.3.2026.10.27.13.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 13:08:09 -0700 (PDT)
Message-ID: <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>, Martin Petersen
	 <martin.petersen@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>, 
	target-devel@vger.kernel.org
Cc: michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Tue, 27 Oct 2026 16:08:08 -0400
In-Reply-To: <20261027180123.13163-1-d.bogdanov@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
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

On Tue, 2026-10-27 at 21:01 +0300, Dmitry Bogdanov wrote:
> ISCSI has some old leftovers in the code that prevents passing the
> aborted
> command to the target core to make the actual abort. Such commands
> hang
> until connection is closed.
> So remove those leftovers.
>=20
> Dmitry Bogdanov (2):
> =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING
> =C2=A0=C2=A0=C2=A0 commands"
> =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
>=20
> =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
 19 -------------------
> =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> =C2=A02 files changed, 27 deletions(-)

Hello Dmitri
Thanks for posting this. I have a series in flight for the same hang:

https://lore.kernel.org/linux-scsi/20261027122837.2148074-1-loberman@redhat=
.com/

Is the revert maybe aimed at the wrong layer, and the sashiko review of
your 2/2 makes the case better than I can: with the fabric check
removed, an aborted command reaches target_execute_cmd(),
target_cmd_interrupted() queues target_abort_work and returns without
changing t_state, the command stays on conn_cmd_list in
TRANSPORT_WRITE_PENDING, and iscsit_release_commands_from_conn()
completes it a second time if the connection closes.

That is the same double completion you are reverting d5869dae5080 for.
It
is not a defect in Maurizio's patch and it will not be fixed by
replacing
it -- target_cmd_interrupted() records nothing when it queues an abort,
so
any site that completes an aborted WRITE_PENDING command can be
followed
by another one. I found this from vmcores on a customer system before
either of us posted, so no argument from me that it is real.

Patch 3 of my series fixes it there, under t_state_lock, for both
queueing sites in target_core_transport.c and for every fabric. With
that
in place your 2/2 is safe and d5869dae5080 does not need reverting for
this reason -- which matters, because the revert is not free: that
commit
carries CVE-2026-97951 and is in 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y,
6.18.y and 7.2.y.

Two questions on 2/2 independent of all that.

Removing the sense_reason early return in iscsit_execute_cmd() means
transport_send_check_condition_and_sense() now runs for an aborted
command. It guards only on SCF_SENT_CHECK_CONDITION, never checks
CMD_T_ABORTED, and ends in queue_status(); target_handle_abort() also
calls queue_status() for a CMD_T_TAS command, and each drops a
reference.
Can an aborted command with a sense reason send both a CHECK CONDITION
and a TASK ABORTED, and drop two references?

And with the early return gone, a LUN_RESET aborting a large WRITE
waits in target_put_cmd_and_wait() for the whole remaining data
transfer. That is bounded where today it is not, but on a large
transfer it may still trip the hung task timeout that made this
visible.

On the overlap: your 2/2 and patch 4 of my series touch the same lines,
so only one can apply, and I have no attachment to mine if yours is the
better shape. Patches 1 to 3 are core-side and conflict with nothing
you have posted.=C2=A0

Martin, would you prefer those three as their own series,
given both candidate iSCSI fixes need patch 3 to be correct?

I am happy to test either or both: I have a reporter's environment that
reproduces this reliably and 300-cycle runs on it.

Many Thanks
Laurence

