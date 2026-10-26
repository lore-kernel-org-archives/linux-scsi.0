Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041035;
	b=XezMnpu2hsHXBnn5kROS2wA5jIUN0BR6gLQD6hWmyJ7V43TTtC1F//EGZdwAtxxZNP4L
	 A/2aTArgHRjxL49ly3IoJbxos7dNmZafcHmop5T7lppNIhcZBN8igWT61FHScHLayR913
	 cBVvt2sICk8B4cVoEnvh1XAxjMA71BU9senimwOS52TFwqch1+EjgZZ7jJaw4mRw/zD4i
	 mikTPaG2okd/d2LJZocJYkMTkK4XEmGTDvJUPuZCb2cNKEB+gsuQRPp2C7i9eEuL6ujMf
	 /WOb8aD3hseTSrMRvVWuho+W1ARHjhIGatFwa8/7YMZVQ/U6g61p/Qd7LR+CK18/OkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041035;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=bWlVFKk/hA3IhLifvlVvVb0OqBSStw22ybdS81uZBv0=;
	b=Co872LNOCUIVi2nZYNHnPkuPdktur3wencUvDy6oXVRO250EIpQ6x4f9efFCxCApdT3A
	 Tbz8e96JRPdsUclwaZyN57aoYJ8FKSSbz58SgnBfpLmWnJ7gEbVFnPnB/vlxknkbi298H
	 3xY7DaTOS9hM7RjjspIy56UF2ktenFjPvEdcEkhfQ5x6boKO794cREc88IdD3tv81CrnC
	 6H7/53MrRd/yNgeFJd42AFIPtrzrfPthAZAUekC0EyAvPbU8TER792HFIOjXAP8kDnYkG
	 ae/1XAVzf/PIHfTKcqyG8zMZJ+2TtckK4by/36GGcnFHyGTECaxH0lsA4iHrt/75Q/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FO59fizD;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=eVKkmdjZ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C45606A323
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 18:57:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17C45606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FO59fizD;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=eVKkmdjZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793041034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bWlVFKk/hA3IhLifvlVvVb0OqBSStw22ybdS81uZBv0=;
	b=FO59fizDN/zivDl+yCLDTGWClgm+5H6IlD/RTGxgH1VmRCLBM9vBTYmQZM9r32y0eT0sEv
	QGQkqCgUE3LZz7h1PrhMxdbKkIjagYgqDn6H/KtTXS/0XhR5I3ZzqESDWzpFHedv4h31RO
	DVOY4CbVEKQiQKVw/9bh+1HUX2iLDeI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-XQHE-jbLN0-LCXpAU2leCA-1; Mon, 26 Oct 2026 14:57:06 -0400
X-MC-Unique: XQHE-jbLN0-LCXpAU2leCA-1
X-Mimecast-MFC-AGG-ID: XQHE-jbLN0-LCXpAU2leCA_1793041026
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f2005ce21so570976985a.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 11:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793041026; x=1793645826; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bWlVFKk/hA3IhLifvlVvVb0OqBSStw22ybdS81uZBv0=;
        b=eVKkmdjZXIfl1EbKxJKCtX4YZ/S7YtWVJDgJrYGVtSim9FJcF9tWiDyzIxd6aHclFH
         Mntc+reNjLfL4GGQyeUyu6pkC91+NRG32xPi2U9e4QGDoIZjwY0P4GKFiUF6ytd66Lzv
         IDByNf0OtDPAUXgZYYVqaeElHqMovGt3bpqjSfRmPJh4kd3z4OZ/FdtRpMCWBtsWQv/6
         oEtgexJXnpg2oUV/LDCI/NIQRa3N4aN7trnt8Za/9rIIlYhm2/5xXJFHiJKVX+FuprDD
         LXhkjwFUf8qBMA8mzlJ75XCM3g3DhiE1mh/akoK0p5HqB4Ow9CXec+JQMDdwYv4f2dBf
         LA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793041026; x=1793645826;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bWlVFKk/hA3IhLifvlVvVb0OqBSStw22ybdS81uZBv0=;
        b=jP1vK87Qjj8k4yhZvU3kpfiZN/6YeBawXrAeTm1cTefGdxaIpBcr0/A7Ky1Ov7lDMr
         K7CWIol9iL9Kuo7FZsvqLyY7yy7h6ECgEC5obQhskM5Nu4I4E/fo10UW/1vy8FMJr/r4
         MX+4IXuE3fzzCB8xGFoZAUMh+Sv4T6VA4kPV6X9VxjZafE7brOGKvECCUApWKPyudZ9/
         7g0C/8PvfksYjOfwwl+aggkEzL+DvWgR7CfkK/7xD9H+eX5ZZq3hud2Ww+FT/3Rnb4DG
         QIogYDnleKN/ChL5yTl9avMh/cuqpt9ZTH9rtG5auKLlF4TQGCksUu8ep95qIjFuCVOL
         zzGA==
X-Gm-Message-State: AFq9FYJXVOe/OqlSNOMiI6Oi8UEWRUeuuP5R9RymSgxKtHRaDgsnXZGu
	iBjbyuwQxbNTN3RpnCGnj7vheGJhx4OHMjVHb3CnEvgCVsAkjf5JCjUCJLeGWR3kTSV2bie+zO3
	nEXrql2IPimQLkhwgp2f+WxSaXtL9lYzSjTFRRkFntdi958UPMPlxobSVGj3l1UgAAXdOLi0=
X-Gm-Gg: AYBFou3yq64UF6THKBBTf5P8Ufo1VMTm9yiOpSLJa0t7yh9I7yrqz8/jqo+uGXJ+S9V
	q2Px8ej7/HnTrbR5y+gVVJG+/ZGVmbcOuWIuozHN8Hm8Zi7fFJhY64rGAMo/Ndy0SPnfhEcFuKN
	bQ4gAUErj5Tg+FMuOchIz0+xw2SZUCpXzeOJ1ga/0UIPGZqK/lZl6vckQUag0Quux7qXNgT8oMs
	JF6AB/sRCADFiDAgEF/Ys4+HEr0av2S4glspOoNypDg/5+rr2Z6KLFnXQKMOYxiFGwvIvTfiFra
	FznkBFgA7naK9a//UfHvjwkchQFSSfyt81aMP1/Ybjxg6iWCIXz2eYc/aF83zSbeuzkz1EjJEEU
	F/fXL5LIkbEYZSFTHTD+gM4AM1difsfbGM3V3ZOufGYZEZvVEW6WUr1PvjHu61NbnoNLN81zmCo
	MgPdeV5AWEBAUkNHDHCFx8SA==
X-Received: by 2002:a05:620a:3714:b0:93f:c3d:7bf6 with SMTP id af79cd13be357-940ef7d3964mr1197184085a.6.1793041025570;
        Mon, 26 Oct 2026 11:57:05 -0700 (PDT)
X-Received: by 2002:a05:620a:3714:b0:93f:c3d:7bf6 with SMTP id af79cd13be357-940ef7d3964mr1197179785a.6.1793041025086;
        Mon, 26 Oct 2026 11:57:05 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a9720csm765520485a.42.2026.10.26.11.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:57:04 -0700 (PDT)
Message-ID: <698f6e4ff260d9480316c68ea30a63af05c936f5.camel@redhat.com>
Subject: Re: [PATCH v4 0/3] scsi: target: iscsi: fix stalled and doubly
 completed aborted WRITEs
From: Laurence Oberman <loberman@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 14:57:03 -0400
In-Reply-To: <ea77fa74-3290-4685-b1d7-24c45ca1286c@acm.org>
References: <20261026150710.1063511-1-loberman@redhat.com>
	 <79480408-8403-4a93-a2dc-c5f01864a20c@acm.org>
	 <8d705915480f6cbe6a1b37c2cd06eb98727b3207.camel@redhat.com>
	 <ea77fa74-3290-4685-b1d7-24c45ca1286c@acm.org>
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

On Mon, 2026-10-26 at 09:47 -0700, Bart Van Assche wrote:
> On 10/26/26 9:12 AM, Laurence Oberman wrote:
> =C2=A0> If the guard is one-shot across both, a second call that would
> have
> =C2=A0> taken the CMD_T_STOP branch is suppressed too, and I am not sure
> that
> =C2=A0> is safe -- a suppressed complete_all() could leave a waiter in
> =C2=A0> transport_wait_for_tasks() stuck. Should the guard cover only the
> =C2=A0> CMD_T_ABORTED branch, or do you see a reason it is safe across
> both?
>=20
> Please limit the guard to the CMD_T_ABORTED branch. The only things
> in
> target_cmd_interrupted() that must not run twice are in that branch:
> INIT_WORK() + queue_work() on cmd->work, and the
> transport_complete_callback() call. For COMPARE AND WRITE the latter
> releases dev->caw_sem in compare_and_write_callback(), so calling it
> twice would release that semaphore twice.
>=20
> The CMD_T_STOP branch doesn't need a guard. complete_all() is
> idempotent and t_transport_stop_comp is initialized only once, in
> __target_init_cmd(). Suppressing a repeated complete_all() wouldn't
> strand a waiter either, since the completion stays done. However, a
> guard shared by both branches would be wrong for another reason: if
> the first call takes the CMD_T_STOP branch and CMD_T_ABORTED is set
> afterwards, a shared guard would suppress queueing target_abort_work
> and we would be back to the target_put_cmd_and_wait() hang.
>=20
> Something like this (untested):
>=20
> 	static bool target_cmd_interrupted(struct se_cmd *cmd)
> 	{
> 		bool queue_abort =3D false, stop =3D false;
> 		unsigned long flags;
> 		int post_ret;
>=20
> 		spin_lock_irqsave(&cmd->t_state_lock, flags);
> 		if (cmd->transport_state & CMD_T_ABORTED) {
> 			if (cmd->transport_state &
> CMD_T_ABORT_QUEUED) {
> 				spin_unlock_irqrestore(&cmd-
> >t_state_lock,
> 						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags);
> 				return true;
> 			}
> 			cmd->transport_state |=3D CMD_T_ABORT_QUEUED;
> 			queue_abort =3D true;
> 		} else if (cmd->transport_state & CMD_T_STOP) {
> 			stop =3D true;
> 		}
> 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>=20
> 		if (!queue_abort && !stop)
> 			return false;
> 		if (cmd->transport_complete_callback)
> 			cmd->transport_complete_callback(cmd, false,
> 							 &post_ret);
> 		if (queue_abort) {
> 			INIT_WORK(&cmd->work, target_abort_work);
> 			queue_work(target_completion_wq, &cmd-
> >work);
> 		} else {
> 			complete_all(&cmd->t_transport_stop_comp);
> 		}
> 		return true;
> 	}
>=20
> Notes:
> - Please use spin_lock_irqsave(): target_complete_cmd() may be called
> by
> =C2=A0=C2=A0 backend drivers from interrupt context.
> - Call the callback and queue_work() after unlocking t_state_lock,
> =C2=A0=C2=A0 like the current code does.
> - A repeated call in the aborted case must still return true so that
> =C2=A0=C2=A0 callers don't proceed with normal completion.
> - Please describe in the patch description that the second call is a
> =C2=A0=C2=A0 no-op by design and that fabrics that complete once are
> unaffected.
>=20
> Thanks,
>=20
> Bart.

Hello Bart,=20
You always take the time to help me and I appreciate it very much.
I am following up shortly with a V5 that I think addresses your
concerns and also limits this to only two patches.=20
I am back-porting to RHEL9 and will get it tested the same way there
too but I expect it will be fine.

Thank you
Laurence

