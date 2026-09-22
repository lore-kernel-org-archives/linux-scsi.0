Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381883403E8
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 02:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790045859; cv=pass; b=lqZnKqu95YYleqET+NcihtmbFNaImE7/rQwFglV2kpS5hsU0DqpMs2Q0GxhWrQdm6T8FlDxmvvRKNuO0ScB6I4tgdI/kuwIDX7WvyJmyetEQrzGg2nYc52ufH5n+GMOBrluqGxzJh6vdR2aDR4SNX5WsVD01Jz9h8JDf6CyYdqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790045859; c=relaxed/simple;
	bh=LWETzvLTCLpPXKSTvQYhK8hYMXbjqA0M3tNN958ouT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mmC/c+2T/+gGw6cuh6khuS6unW/XPZt56KNfZIYobp8dKlfZcImIJ+tyDtU7I0/Dl3H/uNFztO20RMUePFvtUHNcg095NWsQ0v9KzvCJTmRkiNZXHSpkoJW52kwgAhaZT9NmRcp1QIes+ghiJSg2w8Yv97GNOenVfLHu0VGyhGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KBcGzg+t; arc=pass smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KBcGzg+t"
Received: by mail-yx2-f43.google.com with SMTP id 956f58d0204a3-66f943b286fso3288784d50.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 19:57:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790045857; cv=none;
        d=google.com; s=arc-20260327;
        b=SBDC+hqKtui7yXYpmEl2cq3g7XGeLwxFtYf8RBxpZAO/7k5tk7XKpJHDOvPkHBeQVX
         b2bmHTFXkej+L0VuUtGb0VzbZ6kHLf4mJdIrtziguK89VAvA4y3mNMPLQ9i9THe5ptti
         xgpJCdP8oJWo0XZnY7gOjM9RZsl8bpYTGYEC0hExQrvpgFJWEZeyGJsnVdsvg8rrlyMA
         6YvRSDtfmt/cC1P3i6cWdOi7+kJqFikzfYz5t2YeeVRVwSfeRAXcKKVOHqUMJk+dmIWJ
         78Rq1oG3dW+k0HtgSZrV0grDJveSsJ/wH6GmzMAPA1bxefRBSxvRBi+SRrDKu5M9rYNp
         C78w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Oaszatv7+i7Q6ieygPW8etkdqnoGVO2BWSusRaJsgvI=;
        fh=6Qf7mkwZttJUQf/hphn8ZE9MVdbNMDbtrYRjJ5sBabY=;
        b=eS9j8n7ZS1kKE8S3SjdArNi0GHCwe7MCpX7Wx77vcx9Z9d6WaFlpsku5BmhJ0/qvXq
         xQL2HtD9gSPM+lssVMQNSTjPm4W/ctpf7JTc3lZWU9wOdca99fpXTxJc+L8ZL0Fn3fvj
         AXXsVMZh38i7Jto+uezrAmwcXO7MMtU+IWovFDYW7CvbKpkScplzYRDouBWk/x+3PZR4
         uol0Pl2bUX2p2htKITG8EnZKa8J4/EjQRd7B0yQOtrGqn8ubIeSxE1SCNIdzlDNkgEol
         quIzT6Sw10M4fjsxR1sdTNJthjRW0diuVv6isYcpOq00TEFZlHdO8iLIQ1ayhdTyDHgB
         hsag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790045857; x=1790650657; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oaszatv7+i7Q6ieygPW8etkdqnoGVO2BWSusRaJsgvI=;
        b=KBcGzg+tSPV1kXKRJ7Ki3qa/sIAEVBGoDqXXoz80fPkCiDirEYFlSSmK10YPbxOrTH
         2xqrAxaZbEhLtEUe6zWlS4Q2jLFu0J3Q8OY+w1Nfp94WG2PmRuK8lVABm5Zn2lg6ueAj
         d3lDW5aFY5D70bRO7jJeV6/JKUxo9y9lldrROmHU+ompccDnJpPuNLClnb1zUhkRfuQV
         3kncOst+RIDpHpIrTs+DII2SEE0izlHLJEI0q/afQwXfZQ2pGpS6U7qenYso6WHE8X0n
         lH9QbKAizVhmNvrDHxf60nIwLBmW6/FFM6JSO7sZj3V4L/VFkyajWLWn25kU7YxLNyKZ
         qpGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790045857; x=1790650657;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Oaszatv7+i7Q6ieygPW8etkdqnoGVO2BWSusRaJsgvI=;
        b=c3iQdioIW6kH0qV5CgroiFtDEDVbJYoFo2umrjR2RwkLnmoAPc6iHDhZBeY4kK3Qt2
         /Saoac32QFjbtv+Gjnsv6HCduWX+4h8q3FKxjP0XWJb91qTNta6LbS/Khf5/+/UQTs+y
         pKdlT7fSlCctFdkm04KuQRvBDp56vlQUlZIB+Du0N4IQZDejZqDNtRSAuIotuuMvqEb9
         7t6fPW7jqQT/gv1Vgbm3dichLcQ70NSC6184HW2FUyLSwK+xrWob8wF41DuqlC85OQld
         NxKVGOmrAsh2WhfcSMSgYUSTLaBdi2iLJKns06aLIEnG6UkHkgSCnHKtyauvNin8sO68
         RcRA==
X-Forwarded-Encrypted: i=1; AKwUvBxVZhhVhz8Gy+oWpZRwN2n0izhdlgrN1j+xHst+q/cyvYi+I1L85qCP1Om0ZtZKlR7AwuS/UR3s2WYc@vger.kernel.org
X-Gm-Message-State: AFuF++lo7vMTSM7qg/JpJCFJHM/+laPBDlRygGLqaP5kKZs4ikFuJEQK
	LcDmWzg/6/01EfvVoXgVEPxVb88hcv9BMgd2UAvP8YPryatbsAXcABKBk8cqZBNecuwKMeAYe9o
	lYYkNOoai7J6zIu0b1oMwZZXnOSqSZdJvzklPjFe0oB9Q
X-Gm-Gg: AYBFou2VklyBMxqHwwgQn726fNMDt17LUtyehdFR4Hfas0ENYMqfktDQRCznB706yuQ
	planqKoLOSPThv/VNliOwdG8adsmpPMoX1O8WsXAVi5F8WbDxaPrsRbwqwFMYgKmyUdxXWklKHy
	RwbxD348sJxiyhs76jLXkzxm/yz6oVkaWBrqXhmb11BklPop/2JL2SbM3vYFMr0e6Tei+lOxXo5
	YUdtijYDMtwXxD+f0W2njkrFPPfVM3LxySz21fb07tG1FiGlq8V7wZ6ZttMkw3hNwstaEYgGhlB
	cs8udj2UW3NRfGeTK2AMZ4KZd8Y1WYpsBt/1djRQYVJBfrGFIh1X50hG0g==
X-Received: by 2002:a53:d006:0:b0:671:3b1b:997d with SMTP id
 956f58d0204a3-672c54d38a1mr331322d50.88.1790045857248; Mon, 21 Sep 2026
 19:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180201.3624568-1-lgs201920130244@gmail.com> <arFKj506cRh4H_z6@quoll>
In-Reply-To: <arFKj506cRh4H_z6@quoll>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Tue, 22 Sep 2026 10:57:23 +0800
X-Gm-Features: AcwNN1UNJV-7RuK0vc2B42wvjUNKiAuWoNgu3YBpAo8NLf9Va9n2bdK2fcb_odo
Message-ID: <CANUHTR-zXzW1b9oajnzrxEQxC65mWNhaijfdhu51XyV3DrySNg@mail.gmail.com>
Subject: Re: [PATCH] scsi: zorro7xx: put SCSI host on remove
To: krzk@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, 
	James Bottomley <James.Bottomley@steeleye.com>, Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

Thank you for your feedback.

On Mon, 21 Sept 2026 at 23:17, <krzk@kernel.org> wrote:
>
>
> On Sat, 19 Sep 2026 02:02:01 +0800, Guangshuo Li wrote:
> > zorro7xx_init_one() obtains a SCSI host through NCR_700_detect(). The
> > probe failure path drops the host reference with scsi_host_put(), but
> > the normal remove path does not perform the corresponding cleanup.
> >
> > As a result, the SCSI host reference remains allocated after the
> > device is removed.
> >
> > Call scsi_host_put() after all users of the SCSI host have been torn
> > down to release the reference acquired during probe.
> >
> > This issue was found by manual code inspection.
> >
> > Fixes: 45804fbb00ee ("[SCSI] 53c700: Amiga Zorro NCR53c710 SCSI")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> >  drivers/scsi/zorro7xx.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
>
>
> You sent multiple independent patches, to multiple independent
> subsystems. The amount of these patches clearly suggest this was
> AI generated and most likely not tested.
>
> More importantly, you sent all this work without properly organizing
> relevant patches into patchsets. This makes reviewing difficult
> and might cause multiple reviewers to address the same issue.
> Replying to the entire set is impossible and requires handling each
> patch independently, instead of applying or discarding the set.
> Maintainers also won't see the bigger picture of your work. Quite
> worrying.
>
> This is on the verge of hostile patch: bomb us with so many
> contributions, we won't be able to handle them in efficient manner,
> like responding ONCE to ask you to slow down.  Considering all this
> is untested and LLM generated, I have even more doubts whether this
> should be considered for review.
>
> Please read kernel documentation BEFORE posting more work. It will
> explain you how to identify subsystems, how to organize your work per
> subsystem, how to document usage of LLM and how what you should not
> do if this was posted in a good faith.
>
> Best regards,
> Krzysztof
>
>
>
I would like to clarify that these patches were manually reviewed and
audited by us; they were not simply generated and submitted by an LLM.
However, I understand why the recent submission pattern may have given
that impression. We sent too many patches in a short period of time,
and we also failed to respond to some discussions in a timely manner,
which made the situation look worse.

Many of the recent patches, especially the v2 revisions, are
corrections and improvements based on previous review feedback rather
than completely new untested changes. That said, we recognize that the
way we submitted them increased the burden on maintainers and
reviewers.

We apologize for the pressure this caused to the community. We will be
more careful about organizing patches by subsystem, preparing proper
patchsets, and following the kernel contribution guidelines before
sending future work.

Thank you again for pointing this out.

Best regards,
Guangshuo
