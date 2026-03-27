Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431C9149C6F
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774570358; cv=pass; b=h+wVxAr5DG2WB1iHntsrFHT0m79UElvQ/PmcNUcVJh8Bd0rVBRxpIDWbsjp+zKedggURRO248JXA54Rnemv82otkfjeaKwSsDHgS5KEkRu1cATj1gWWBVLbx3wz/F8DUdFf68PB8nwGyGsuafSEV6VgWrWeBYTq3n6tlloC7Iko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774570358; c=relaxed/simple;
	bh=hssH0q7DMIT8Y5t3csTv9BiOdey3S75Gos+3lTu5ReY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I8Jju1vx62Zly+UDYcGY3Df8yEYq4yU3w2p/C334Q0OUYXzOlhvgIj374R/hs1RlIXPPSzbz6p+8+4/ozv65T0uKV+mtu1bN4dBEqVwqfWrbQ3x8+IglCvzA7qX6smpKzuasyF70sKFPeEMHL+HpLygZ2FseiwCK631umHXh/9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=dq4qjDqQ; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="dq4qjDqQ"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38ad12fb595so24572431fa.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 17:12:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774570354; cv=none;
        d=google.com; s=arc-20240605;
        b=bHF0ZOh5fgkGb+ZAn5SeA+pwWw6GPpKmFonjbNEwAiEd24jZkTMTspM+7tUsYfmvL4
         +Bhp98AS13naZn5EsAdaP1AEGCrFgzm+QqGCFBkp9DKcWeu/Ji+/hyaFwoLBk9z56asI
         6zmtGOOO3+0X3iyck0W0K7g4JzJOiK8NZyLVKQJBMIktn9l4i6UlZRAZGATNVgiVraY9
         VomJ0VNG55oUk4BsXO0iRoV3H0HndhsTgsLJWQCQ4TCsKcmuYX5wr2cEEbq8iZ/zn3FX
         BZn+rrt4HPltgiTWQWvZkCj+coevhpMkNARy1DCmXbKUbbQJHABhYLh2c+f02Z9NGttX
         raUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=78t28iVjVygg0JEa51rXAbxZZ9nyGQycl0kuR3QBdmo=;
        fh=ZUOvmiUb//8eIwNP6NhlxVzC0si1CgBLrcqAOjtKI0Y=;
        b=eebmE5cMlohfGK7PS+zh1HCk6kOFAJcsnmw7kTjQ1dH4EgzcMXcwVejXjfGWqi0fYV
         74h3geDZLMrnLQZ7npt/vJaiuikJkKEOmcpzj45BKMLuJnLn/rQvSCkoGgNnFz9sTVuA
         ekXNgXnl4GSLZ5mS1lxQLfZ2VloeHnhfhsTDv9ACPxazKtp7hKbQtLrh3IKrCZPOxMdm
         RVjmCK0Kk04fW9FG80YQzJejqw+Ff4S3Yht7dTqICSWpSDvdAdYNngFVvc0aZtkT+Tlp
         xJUAMPu2e8RUvUeASFU7gsmH5Ay96oA9M+CFkmctFL59BEq1t3bEcywMeXkF69D24vBb
         ZfVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1774570354; x=1775175154; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78t28iVjVygg0JEa51rXAbxZZ9nyGQycl0kuR3QBdmo=;
        b=dq4qjDqQeeYScOILlV7E42NdkagLlDkolo+hKLBp8pIxIOOAZ5YESDdKtaP+h97qQA
         eBPJQ2eewPzGFfdW5Dy9c+VIsgt3rxXizbHz+VqpBEKchc74XE0cALcKAq+5INK8BpRh
         G1sMqGHcSlAXF9yEqwEkgeh0Yy+hj+9+3Z+GuHeXBYy49I3rUhFzmGeUD851X3qkD1tu
         vkW8D+QCMWWRgulaTy26UygUVzNQBbddGv38QLlFjSDmI7YHsAgcIriJY95xW+4QdnUU
         5eXdsZtkOlylkdI04QCZNABi+3hi7gnqwbSWKz2QQpqSAiR+DoB/JXjLUQ7/8rDaZZyY
         wGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774570354; x=1775175154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=78t28iVjVygg0JEa51rXAbxZZ9nyGQycl0kuR3QBdmo=;
        b=Zit/yFj2HJJppbJWPhZoScKDifgibO+tA/x6S+IBKZ58QoYr5laOHJ/tgGfzRqPSKK
         Et9RQgx8K8dTTRYXBcHoNDFTCKu4UbPfrjedLVJXcb4SLZbdwJYWnt+BR47XGLc4D8pI
         BhRp01LBRfx7oOriQ4hZ5wV+OImkLJ3+AKdR8ooeqz8bdDWYpYd8dFfFeiBdjm1ZWnlo
         0IGGsZnCiXsvX+dGFCd4AUUSPlpKW55E8AyOUq0/L+UYN0GL1Q1oZDcIkov01eHWgaMY
         X9vs6MynTi1O/aCMOo4AT7xT6Iq62I/xIym19U1kr9Nljj8hkTc7eevV/XXFzHYIK2fO
         nMsA==
X-Gm-Message-State: AOJu0YzBrGzAIUSwk9trYJ2gtotaoSR0XoA/h5EDqLAU0ETg1/MHAlzt
	aNl8sQENz5bVkRqJmad0IYeTav+S7HLtqCMHvoDs+eNn/pseKd2i0XcblF6i9YHHPrORvvHqWcW
	sJBmH4FvyawrnJAOknXvowj3346c0u1wfz1pGorRfVw==
X-Gm-Gg: ATEYQzz3qBMzyZztC2csyJi/jy7p7SbQJFjy8CSNTlmUazKqjlZvKTS7LiiCKB2U2Ry
	Vwxe8+RLkrzQfxkQakHjrQqcIpxdsIZcQy56VTfFO6wurWjyWVPIEKRYNt7Cq2z47UnsNoJyTrq
	xJLMaDuQm4v6yRzagkOlnJVBE4GitrzYo/bNL2W4Z1kPNJv5ayWaAE4D785CLC36vpV5rQi8lvp
	B7rBnfzePkWwGL6Nct8t6BY+sDPmDE//u0GvLozOzoDuVeBDjYQAF1XW2fiXIvEp5ReSQo2208C
	nLC/+XCPu5IrkCtMu28yMprw1GMlD2ltE7nWEsLp2wlJQzlrMtuwCFGcwFOICiggxza1NVVVvJ1
	rDFqEnQtZL1cLTX/ARdibiLt5o7njTF/d
X-Received: by 2002:a2e:9616:0:b0:38b:e005:7fa0 with SMTP id
 38308e7fff4ca-38c6537beb4mr9162711fa.4.1774570354174; Thu, 26 Mar 2026
 17:12:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260325151515.18688-1-brian@purestorage.com> <20260325151515.18688-2-brian@purestorage.com>
 <e5a8a8a0-9e1e-44c1-9db5-5ee6b8ba867f@suse.com>
In-Reply-To: <e5a8a8a0-9e1e-44c1-9db5-5ee6b8ba867f@suse.com>
From: Brian Bunker <brian@purestorage.com>
Date: Thu, 26 Mar 2026 17:12:23 -0700
X-Gm-Features: AQROBzCkNTl47iVRzlyUyAuTKvm0PG3goOS9XpTcAMAAQP9bIZFigVcE3zP8Zy8
Message-ID: <CAHZQxyL-SrVwAg7PKbTAO60y5wE4KEoLt=282oata3kZr_Aqig@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: scsi_dh_alua: use the device timeout rather than
 a constant
To: Hannes Reinecke <hare@suse.com>
Cc: linux-scsi@vger.kernel.org, Krishna Kant <krishna.kant@purestorage.com>, 
	Riya Savla <rsavla@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 26, 2026 at 3:22=E2=80=AFAM Hannes Reinecke <hare@suse.com> wro=
te:
>
> On 3/25/26 16:15, Brian Bunker wrote:
> > Instead of using a constant for timeouts, use the timeout of the SCSI
> > device itself. There are reasons why someone might want to extend
> > the SCSI timeout and having the constant out of sync can lead to
> > early timeouts.
> >
> > Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> > Signed-off-by: Riya Savla <rsavla@purestorage.com>
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > ---
> >   drivers/scsi/device_handler/scsi_dh_alua.c | 12 +++++++-----
> >   1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/=
device_handler/scsi_dh_alua.c
> > index efb08b9b145a..a4ee67109548 100644
> > --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> > +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> > @@ -143,7 +143,7 @@ static int submit_rtpg(struct scsi_device *sdev, un=
signed char *buff,
> >       put_unaligned_be32(bufflen, &cdb[6]);
> >
> >       return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
> > -                             ALUA_FAILOVER_TIMEOUT * HZ,
> > +                             READ_ONCE(sdev->request_queue->rq_timeout=
) ?: ALUA_FAILOVER_TIMEOUT * HZ,
> >                               ALUA_FAILOVER_RETRIES, &exec_args);
> >   }
> >
> > @@ -178,7 +178,7 @@ static int submit_stpg(struct scsi_device *sdev, in=
t group_id,
> >       put_unaligned_be32(stpg_len, &cdb[6]);
> >
> >       return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
> > -                             stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
> > +                             stpg_len, READ_ONCE(sdev->request_queue->=
rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
> >                               ALUA_FAILOVER_RETRIES, &exec_args);
> >   }
> >
> > @@ -512,7 +512,7 @@ static int alua_tur(struct scsi_device *sdev)
> >       struct scsi_sense_hdr sense_hdr;
> >       int retval;
> >
> > -     retval =3D scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
> > +     retval =3D scsi_test_unit_ready(sdev, READ_ONCE(sdev->request_que=
ue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
> >                                     ALUA_FAILOVER_RETRIES, &sense_hdr);
> >       if ((sense_hdr.sense_key =3D=3D NOT_READY ||
> >            sense_hdr.sense_key =3D=3D UNIT_ATTENTION) &&
> > @@ -552,7 +552,8 @@ static int alua_rtpg(struct scsi_device *sdev, stru=
ct alua_port_group *pg)
> >       valid_states_old =3D pg->valid_states;
> >
> >       if (!pg->expiry) {
> > -             unsigned long transition_tmo =3D ALUA_FAILOVER_TIMEOUT * =
HZ;
> > +             unsigned long transition_tmo =3D min(READ_ONCE(sdev->requ=
est_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
> > +                                                (unsigned long)U8_MAX =
* HZ);
> >
> >               if (pg->transition_tmo)
> >                       transition_tmo =3D pg->transition_tmo * HZ;
> > @@ -664,7 +665,8 @@ static int alua_rtpg(struct scsi_device *sdev, stru=
ct alua_port_group *pg)
> >       if ((buff[4] & RTPG_FMT_MASK) =3D=3D RTPG_FMT_EXT_HDR && buff[5] =
!=3D 0)
> >               pg->transition_tmo =3D buff[5];
> >       else
> > -             pg->transition_tmo =3D ALUA_FAILOVER_TIMEOUT;
> > +             pg->transition_tmo =3D min((READ_ONCE(sdev->request_queue=
->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ) / HZ,
> > +                                      (unsigned long)U8_MAX);
> >
> >       if (orig_transition_tmo !=3D pg->transition_tmo) {
> >               sdev_printk(KERN_INFO, sdev,
>
> Weelll ... The transition timeout is _vastly_ different from the device
> command timeout. While the latter tends to be rather small (ie in the
> seconds range), the former can take _really_ long time.
> Ask you competitors, they regularly require tens of _minuntes_ here.
>
> Having is settable is a good idea, but not to the command timeout.
The SCSI path timeout represents a contract between the initiator and
the target. Storage vendors provide recommended path timeout values
for their arrays as a best practice, and administrators are expected to
configure these values accordingly. This timeout value reflects what the
target vendor has determined is the appropriate maximum time to wait for
any operation on that path, accounting for the target's internal processing=
,
failover capabilities, and expected behavior under various conditions.

When the implicit transition timeout honors this same path timeout, it simp=
ly
extends that existing contract to cover ALUA state transitions. The
target vendor
whoever recommended a 30-second or 60-second path timeout did so with full
knowledge of their array's behavior, including how long implicit
transitions might
take. If their array requires longer transitions than the recommended
path timeout allows, that is a deficiency in their recommendation, not
in the use
of it as a default.

The SCSI SPC specification itself constrains the implicit transition
timeout to a single byte in the RTPG extended header, limiting it to
255 seconds. The
kernel's data structure reflects this with an unsigned char for
transition_tmo. If the
specification authors believed implicit transitions could legitimately
require tens of
minutes, they would have allocated more than one byte for this field.
Beyond the spec and
data structure constraints, when the implicit transition timer expires
the port group
state is forced to STANDBY and new commands fail immediately.
Supporting tens of minutes is not
possible with the current implementation regardless of the default chosen. =
Using
the path timeout as the default creates consistency with the broader
timeout contract that already exists between the initiator and the
target, rather than
introducing a separate arbitrary value that may conflict with the
administrator's I/O expectations
behavior on that path.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.com                               +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich

Thanks,
Brian
--=20
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
