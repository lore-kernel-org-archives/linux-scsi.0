Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C898821D001
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2025 08:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752224113; cv=none; b=rYnqaenj0DMcj3jFKrfVf63wyJP/LLt72qoAsGIIXk+SANAim0F/g3JQ/jAJm2M3AUlPbj/quQibnV6SJyJRmHW+Kw2W0MEbpVrFSLkhPhduy8MChlGSR4o60vN97IS8xEAEtY7dDNU6ynHbPO9V9U3RbXzvXInoSxfVro03x98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752224113; c=relaxed/simple;
	bh=xdSejNmMaJNIE0HQH4m5I8PRVBBmfyuJhf/+7lGolPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=coKmdqkkMA93hSGmu4DwskftqJWGZlktUrCEEGnJ5CQzoEkYKy7VrgWiNhgPGAJPeRgZD6l2Fo7B/uOkJCKkhGL3KciR0pYd1su/pXrvq9Lcgmv/DqcDdQm7Cwa0O9rNi2TolHLUrJy11NsOKqsRiZK8DqUC3+mLWqIQRrCwjBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OLjrq9Qa; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OLjrq9Qa"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b34a78bb6e7so1553855a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2025 01:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1752224111; x=1752828911; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vGEg7l06DfJAdbPrIuEVwZZYtCDdS90uREWs/0ZE8oM=;
        b=OLjrq9QazwYk7nwYtEKKpwQa81YZ8tGiE94MngsyWGHJ+T3UEHiy9HZPpU8J5RVeZn
         lPDzeLqZJvKrlKWocgqkOidrZBLUHJjd8Rj+BIcFkI2kTRUQBYQUemXOpsBPrYcOOQsx
         KBbecaEiuxyIxTTwS0LRUHK0BlKb2w62/YX2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752224111; x=1752828911;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vGEg7l06DfJAdbPrIuEVwZZYtCDdS90uREWs/0ZE8oM=;
        b=HFDjq34BlC0pzcSy6o+pOzeRnJJ2087H2Te/B1Fj/0Nn7+tAU/rZg1moGWa7NuAivt
         k4tDrtpjx2IVHYoIwPwr1UzyyITEVBgZV4lz50UA3IZGy8vOVkKfKinr2F7ULfZVJad0
         ARuNxcJ1RjhBMHXV4gjEwIqyWdGyAAv88dGJL5cdm9OrxnEB/a24WrbZA1Fhd25fXKLG
         LprspnC9pTdg5OzFKROu3b7HZd+bOz24i9rF5ejBC0aMk5JPOFxBfsvVh1pXKPFe1yjl
         y70wxi0klQLmuo/7LWV2MhglQJV0cLHH/Uh3eTcEYjTpK7OLKvnC3cmO7X36R18qUtJW
         Y01Q==
X-Forwarded-Encrypted: i=1; AJvYcCWHZqMxLyUP3wENeMU/bPDOR4gT0dDYfHl8f6xQ9ih/ag/Xdf7aXQ8nDTl1RyZlSKiAE/9b+fhGmZFI@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9dAQG7eK2e61mbgnJiGLVYN1SKskNVisAkuPSVl8ERbEkX6he
	EQo69gbnQ+sZJbERwpC2QQh91IapY1MmKJhSFEW08KC4neiIz9GBDU3x8khyzXghg8nrIUB2v9a
	2xJ9xYxcavGWxeYjW47P73r/qrwkFffiTyJzaVnMNQHZedf9V8J1rAWsZhBkeUVIK7TvqW9dyN1
	ze90iaCoPTklaTvxzJ7KOl5/g3J2FPUWt4jGXattA8
X-Gm-Gg: ASbGncvojMjzHnGlETtyW4bDgDvWyjiPTZnUjnK9UBFMgHBjnGQWXechzMS87aZpQ7q
	e2sz5VssKoQd3HzQcTSKvcwtpX1d1yoDz3FOuf0SjPgqVMkdhcv6FZKbOgPMge6yEiWPCecvVZC
	lzLKK3/0DrrqwwNGy3uUch6f05RJbFhSvsnnTPuELPamzRO7oMUNy5RzmSSK+uJpLO2nJW/0jVh
	opt+0T+
X-Google-Smtp-Source: AGHT+IF4dV7863iYbBVyu4Ub5QideeFpJ50pjQt+Q2u8VuuEjmucC9VL0I2uRqsTJqQrRMbPnZjKQQHyNmZ8kStadKg=
X-Received: by 2002:a17:90b:1850:b0:313:33ca:3b8b with SMTP id
 98e67ed59e1d1-31c4ca848dfmr3739044a91.9.1752224111078; Fri, 11 Jul 2025
 01:55:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624202020.42612-1-bgurney@redhat.com> <CAHhmqcTO_Q59aDr3DywC-tPF=9pe3gxbyn6J4ycdf+eYEOayHQ@mail.gmail.com>
 <19484829-0a7b-42ce-99fe-e74ccda67dce@suse.de> <b0817e2a-1c4e-4d7d-9a84-633913d9e0e4@redhat.com>
 <0db83ea3-83aa-45ef-bafd-6b37da541d22@suse.de> <CAHhmqcTNrfjj-ABjTfj7LUCQ_qRtcTrZCzhtaERViaAQut3TUw@mail.gmail.com>
 <fb150df4-d235-455b-8394-55b816c0e6ad@suse.de>
In-Reply-To: <fb150df4-d235-455b-8394-55b816c0e6ad@suse.de>
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
Date: Fri, 11 Jul 2025 14:24:57 +0530
X-Gm-Features: Ac12FXw0R7O98xsUICSTvnPcO9AZ79F4u0VyEwe3D9YSRXTNBXtkPC99vyPeryI
Message-ID: <CAJtR8wVupqRK3t0+7shrNCTZ9qZC7gHAR2X8Ov0AR-RJamxcWg@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] nvme-fc: FPIN link integrity handling
To: Hannes Reinecke <hare@suse.de>
Cc: Bryan Gurney <bgurney@redhat.com>, John Meneghini <jmeneghi@redhat.com>, 
	linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de, 
	sagi@grimberg.me, axboe@kernel.dk, james.smart@broadcom.com, 
	dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org, njavali@marvell.com, 
	muneendra737@gmail.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000bae7140639a377e0"

--000000000000bae7140639a377e0
Content-Type: multipart/alternative; boundary="000000000000b568500639a37799"

--000000000000b568500639a37799
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>>But that's precisely it, isn't it?
>>If it's a straight error the path/controller is being reset, and
>>really there's nothing for us to be done.
>>If it's an FPIN LI _without_ any performance impact, why shouldn't
>>we continue to use that path? Would there be any impact if we do?
>>And if it's an FPIN LI with _any_ sort of performance impact
>>(or a performance impact which might happen eventually) the
>>current approach of steering away I/O should be fine.
[Muneendra]

With FPIN/LinkIntegrity (LI) - there is still connectivity, but the FPIN is
identifying the link to the target (could be multiple remoteports if the
target is doing NPIV) that had some error.  It is *not* indicating that I/O
won't complete. True, some I/O may not due to the error that affected it.
And it is true, but not likely that all i/o hits the same problem.   What
we have seen with flaky links is most I/O does complete, but a few I/Os
don't.
It's actually a rather funky condition, kind of sick but not dead scenario.
As FPIN-Li indicates that the path is "flaky" and using this path further
will have a performance impact.
And the current approach of steering away I/O is fine for FPIN-Li.

Regards,
Muneedra.

On Wed, Jul 9, 2025 at 11:15=E2=80=AFPM Hannes Reinecke <hare@suse.de> wrot=
e:

> On 7/9/25 15:42, Bryan Gurney wrote:
> > On Wed, Jul 9, 2025 at 2:21=E2=80=AFAM Hannes Reinecke <hare@suse.de> w=
rote:
> >>
> [ .. ]
> >>> This may be true with FPIN Congestion Signal, but we are testing Link
> >>> Integrity.  With FPIN LI I think we want to simply stop using the pat=
h.
> >>> LI has nothing to do with latency.  So unless ALL paths are marginal,
> >>> the IO scheduler should not be using any marginal path.
> >>>
> >> For FPIN LI the paths should be marked as 'faulty', true.
> >>
> >>> Do we need another state here?  There is an ask to support FPIN CS, s=
o
> >>> maybe using the term "marginal" to describe LI is wrong.
> >>>
> >>> Maybe we need something like "marginal_li" and "marginal_cs" to
> describe
> >>> the difference.
> >>>
> >> Really not so sure. I really wonder how a FPIN LI event reflect back o=
n
> >> the actual I/O. Will the I/O be aborted with an error? Or does the I/O
> >> continue at a slower pace?
> >> I would think the latter, and that's the design assumption for this
> >> patchset. If it's the former and I/O is aborted with an error we are i=
n
> >> a similar situation like we have with a faulty cable, and we need
> >> to come up with a different solution.
> >>
> >
> > During my testing, I was watching the logs on the test host as I was
> > about to run the command on the switch to generate the FPIN LI event.
> > I didn't see any I/O errors, and the I/O continued at the normally
> > expected throughput and latency.  But "if this had been an actual
> > emergency..." as the saying goes, there would probably be some kind of
> > disruption that the event itself would be expected to cause (e.g.:
> > "loss sync", "loss signal", "link failure"), but
> >
> > There was a Storage Developer Conference 21 presentation slide deck on
> > the FPIN LI events that's hosted on the SNIA website [1]; slide 4
> > shows the problem statements addressed by the notifications.
> >
> > In my previous career as a system administrator, I remember seeing
> > strange performance slowdowns on high-volume database servers, and on
> > searching through the logs, I might find an event from the database
> > engine about an I/O operating taking over 30 seconds to complete.
> > Meanwhile, the application using the database was backlogged due to
> > its queries taking longer, for what ended up being a faulty SFP.
> > After replacing that, we could get the application running again, to
> > process its replication and workload backlogs.  The link integrity
> > events could help alert on these link problems before they turn into
> > application disruptions.
> >
> But that's precisely it, isn't it?
> If it's a straight error the path/controller is being reset, and
> really there's nothing for us to be done.
> If it's an FPIN LI _without_ any performance impact, why shouldn't
> we continue to use that path? Would there be any impact if we do?
> And if it's an FPIN LI with _any_ sort of performance impact
> (or a performance impact which might happen eventually) the
> current approach of steering away I/O should be fine.
> Am I missing something?
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich
>
>

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--000000000000b568500639a37799
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div>&gt;&gt;But that&#39;s precisely it,=
 isn&#39;t it?</div><div>&gt;&gt;If it&#39;s a straight error the path/cont=
roller is being reset, and</div><div>&gt;&gt;really there&#39;s nothing for=
 us to be done.</div><div>&gt;&gt;If it&#39;s an FPIN LI _without_ any perf=
ormance impact, why shouldn&#39;t</div><div>&gt;&gt;we continue to use that=
 path? Would there be any impact if we do?</div><div>&gt;&gt;And if it&#39;=
s an FPIN LI with _any_ sort of performance impact</div><div>&gt;&gt;(or a =
performance impact which might happen eventually) the</div><div>&gt;&gt;cur=
rent approach of steering away I/O should be fine.</div><div>[Muneendra]</d=
iv><div><br></div><div>With FPIN/LinkIntegrity (LI) - there is still connec=
tivity, but the FPIN is identifying the link to the target (could be multip=
le remoteports if the target is doing NPIV) that had some error.=C2=A0 It i=
s *not* indicating that I/O won&#39;t complete. True, some I/O may not due =
to the error that affected it.=C2=A0 And it is true, but not likely that al=
l i/o hits the same problem.=C2=A0 =C2=A0What we have seen with flaky links=
 is most I/O does complete, but a few I/Os don&#39;t.=C2=A0</div><div>It&#3=
9;s actually a rather funky condition, kind of sick but not dead scenario.<=
/div><div>As FPIN-Li indicates that the path is &quot;flaky&quot; and using=
 this path further=C2=A0 will have a performance impact.</div><div>And the =
current approach of steering away I/O is fine for FPIN-Li.<br><br>Regards,<=
/div><div>Muneedra.</div></div></div><br><div class=3D"gmail_quote gmail_qu=
ote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Jul 9, 2025 at=
 11:15=E2=80=AFPM Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@=
suse.de</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-lef=
t:1ex">On 7/9/25 15:42, Bryan Gurney wrote:<br>
&gt; On Wed, Jul 9, 2025 at 2:21=E2=80=AFAM Hannes Reinecke &lt;<a href=3D"=
mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>&gt; wrote:<br>
&gt;&gt;<br>
[ .. ]<br>
&gt;&gt;&gt; This may be true with FPIN Congestion Signal, but we are testi=
ng Link<br>
&gt;&gt;&gt; Integrity.=C2=A0 With FPIN LI I think we want to simply stop u=
sing the path.<br>
&gt;&gt;&gt; LI has nothing to do with latency.=C2=A0 So unless ALL paths a=
re marginal,<br>
&gt;&gt;&gt; the IO scheduler should not be using any marginal path.<br>
&gt;&gt;&gt;<br>
&gt;&gt; For FPIN LI the paths should be marked as &#39;faulty&#39;, true.<=
br>
&gt;&gt;<br>
&gt;&gt;&gt; Do we need another state here?=C2=A0 There is an ask to suppor=
t FPIN CS, so<br>
&gt;&gt;&gt; maybe using the term &quot;marginal&quot; to describe LI is wr=
ong.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Maybe we need something like &quot;marginal_li&quot; and &quot=
;marginal_cs&quot; to describe<br>
&gt;&gt;&gt; the difference.<br>
&gt;&gt;&gt;<br>
&gt;&gt; Really not so sure. I really wonder how a FPIN LI event reflect ba=
ck on<br>
&gt;&gt; the actual I/O. Will the I/O be aborted with an error? Or does the=
 I/O<br>
&gt;&gt; continue at a slower pace?<br>
&gt;&gt; I would think the latter, and that&#39;s the design assumption for=
 this<br>
&gt;&gt; patchset. If it&#39;s the former and I/O is aborted with an error =
we are in<br>
&gt;&gt; a similar situation like we have with a faulty cable, and we need<=
br>
&gt;&gt; to come up with a different solution.<br>
&gt;&gt;<br>
&gt; <br>
&gt; During my testing, I was watching the logs on the test host as I was<b=
r>
&gt; about to run the command on the switch to generate the FPIN LI event.<=
br>
&gt; I didn&#39;t see any I/O errors, and the I/O continued at the normally=
<br>
&gt; expected throughput and latency.=C2=A0 But &quot;if this had been an a=
ctual<br>
&gt; emergency...&quot; as the saying goes, there would probably be some ki=
nd of<br>
&gt; disruption that the event itself would be expected to cause (e.g.:<br>
&gt; &quot;loss sync&quot;, &quot;loss signal&quot;, &quot;link failure&quo=
t;), but<br>
&gt; <br>
&gt; There was a Storage Developer Conference 21 presentation slide deck on=
<br>
&gt; the FPIN LI events that&#39;s hosted on the SNIA website [1]; slide 4<=
br>
&gt; shows the problem statements addressed by the notifications.<br>
&gt; <br>
&gt; In my previous career as a system administrator, I remember seeing<br>
&gt; strange performance slowdowns on high-volume database servers, and on<=
br>
&gt; searching through the logs, I might find an event from the database<br=
>
&gt; engine about an I/O operating taking over 30 seconds to complete.<br>
&gt; Meanwhile, the application using the database was backlogged due to<br=
>
&gt; its queries taking longer, for what ended up being a faulty SFP.<br>
&gt; After replacing that, we could get the application running again, to<b=
r>
&gt; process its replication and workload backlogs.=C2=A0 The link integrit=
y<br>
&gt; events could help alert on these link problems before they turn into<b=
r>
&gt; application disruptions.<br>
&gt; <br>
But that&#39;s precisely it, isn&#39;t it?<br>
If it&#39;s a straight error the path/controller is being reset, and<br>
really there&#39;s nothing for us to be done.<br>
If it&#39;s an FPIN LI _without_ any performance impact, why shouldn&#39;t<=
br>
we continue to use that path? Would there be any impact if we do?<br>
And if it&#39;s an FPIN LI with _any_ sort of performance impact<br>
(or a performance impact which might happen eventually) the<br>
current approach of steering away I/O should be fine.<br>
Am I missing something?<br>
<br>
Cheers,<br>
<br>
Hannes<br>
-- <br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 Kernel Storage Architect<br>
<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 +49 911 74053 688<br>
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg<br>
HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich<br>
<br>
</blockquote></div>

<br>
<span style=3D"background-color:rgb(255,255,255)"><font size=3D"2">This ele=
ctronic communication and the information and any files transmitted with it=
, or attached to it, are confidential and are intended solely for the use o=
f the individual or entity to whom it is addressed and may contain informat=
ion that is confidential, legally privileged, protected by privacy laws, or=
 otherwise restricted from disclosure to anyone else. If you are not the in=
tended recipient or the person responsible for delivering the e-mail to the=
 intended recipient, you are hereby notified that any use, copying, distrib=
uting, dissemination, forwarding, printing, or copying of this e-mail is st=
rictly prohibited. If you received this e-mail in error, please return the =
e-mail to the sender, delete it from your computer, and destroy any printed=
 copy of it.</font></span>
--000000000000b568500639a37799--

--000000000000bae7140639a377e0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ys9fYL+GlV3PS9wS3h0MI90cAfs5ZQjER5eWqMBARhfrW70fFVMSdZzBpXljqRjD+GOJm711FgvN
RsH9iq2Ndn7XY7jpnxND6cwSKympBXWuvQ54YyFDLr0m9eC6BNU5bQIDAQABo4IB3TCCAdkwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsG
AQUFBwMEMB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBTJvvnIS4Qf
Z+gEeC51xAB2l3lqOzANBgkqhkiG9w0BAQsFAAOCAQEAE6G8pLIpwrdO0Dmi603StqsNLN3t3i5m
SU/J+ZHnSeVNQFmfJjYSlZHSeAYrw+nsLEw08xiT4N2dPLbnowDKw0cVDRV5hL6+Uis2nqNkp9Kk
dXMVNlGeqGqBo98QRdRdzLgc/3FBQp3XIGUo2VDOMYW/RPbI1muHQOBKaVx4q8jqitNbqThvZkt/
t8KBiojEq4d7/scDRRtEsaL6Hl7cAYNMrS5EpijZrYjNYercaQNHcHP38l/XM9n36jllylt12koc
Dfj3D142STRRnexoNURmkc9EAKyZPRv/JRGz6YP0i2y1JqgpjF8CggD2osV3pA9e8ecXWQ7/ZJly
zHlFgjGCAmAwggJcAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDEnR
Sel9Ku9INR0BhDANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgyJB59vzcbLBn3hUK
eRD8Qi0wYJZPnGqBCSvKMb8PNxYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjUwNzExMDg1NTExWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggEAK2c7hafVjBMlaO9ThdbwuMLll0LEidQASQEwroQDS3Ck1EDQeBBU
8tW/zQBOrwTUZeUqXX89BbVDIAcFEFiRvwi1NnfOk9bTynY/T5bGs0sR+JWfxXPifNCeO21gcPR3
3hbaVU4xhQA89wr5IgmZN0eS3WiUWOI8DGWBTBv8shDatcluRVOPShOrLI91/1NweexCcoSuMGzT
H94C8B5FPGpWVlqGOjrq86VuhdAApSf8M2gEw7wo7Krg9E5NzpwTiQkGU8SU+oRWw67OA8T+IQ3J
BINZV/wQzOAjNBEs/DmTiTZf1Lax+3RPX9GZm8/nlY+yYR8nGfnNQv96zMQ1Og==
--000000000000bae7140639a377e0--
