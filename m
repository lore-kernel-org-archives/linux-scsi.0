Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E33823B0
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 22:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716503127; cv=none; b=o8k5WiVAHK3lYkt8WRhXWRubn1rubkvTF2NHcNfW58A83hNOlNoaMXKFnWIMTc+5RbvYTL6bmNZuLM0/F24gOoTTl2LXpx3+SUOxQCkrCF1oVim2RYd4+N/w+0dm6zHGBSEpXa7JJCpQQMGYxFOtYlEuAv5vCl3YVcnZdtxwgDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716503127; c=relaxed/simple;
	bh=twa6gKc4Ja8rI61KLX/gmR2tcMYRjGwbQv1wJFVxwtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pOmOdxeigwIW4dqwZojxy2wrJ0Qtu+kuCQGSa6hwfBUAbwxfB5+4ob38BqvZ7bvFwWvx2cVOz+bB7RHig/z3Pqr+zFRkVMiRwa4HAOrIhlawaGSVxyCrZNBAyHpVqZXMVsVlGGCxgIMaA2fvO17MUySo6eR8R+3xiWCvs+wcHgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jq6eWdjw; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jq6eWdjw"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-627f46fbe14so20218337b3.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 15:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1716503124; x=1717107924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4WULqNW39evuzHzZCXCVZ3XQhyYSJZ/maSvMgmWDC3c=;
        b=jq6eWdjwiInLk8BKDEM5MKiiwcx4RhHvhGecPWkruHcs9V8YZi+sh64LNt5zVk1WtM
         OdGnqAT776WPbylKOTBlPolG76/zHX5UVP0FUJp1qd0DaoDTP2XWPclQV+HIlaSb05L6
         gZm8svTKuGQKCH3irUOhH8U6OxK+BsqgOnLRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716503124; x=1717107924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4WULqNW39evuzHzZCXCVZ3XQhyYSJZ/maSvMgmWDC3c=;
        b=MJtKSdxDaa9UiZMDnVKYvdHnzUoDd9lbhyDI4X6pe6kAO9CMDjF0JE9c0M9I6bTCPH
         5BpHUiNxJMLukIzSzGaEkXh0JAjorf2UgGasyQfIkMNXdmb7PHGVEWaIWmWWDAVjLbYe
         1s62m0nBzBMGYnPi2wBEXx0EWwaKzLvY7O8IQh6BnyIVPj0FYaqeHMw70qm+qtrLJdp/
         ho9wB9jAYGNsG5qnyXQ7d8WgOq80sQ/vhiYD+BPoVqYWlClEZcpnlrF6ui6fc/OHYNmr
         AO/UxsqMkUKOgYH2Gu11MONaC1yglT03tSRM8x498S8RXSrgAqqZZ066YY+TztmIG7zY
         Dzfw==
X-Forwarded-Encrypted: i=1; AJvYcCU8MgKYOL2ZV4qwyK6YGeHxkLKNhSk0JZETkWpOw3SMiFva5z4K+rotbmu7Vk8yRqbrPsFN0jnp/zhg7Egm3S1s4sHf5HXOXn+h3w==
X-Gm-Message-State: AOJu0Yxh5zqr4owfk3OKkMd/yd3PGFNSg6U5tACM3us1LvzYv/POYkU6
	dvpaxvIItNUauojJkcStIMcbXwZu0RhsRFVOECvgznBWlSRBE8hIXL4ESNc+JNMDD3H363aSQGw
	=
X-Google-Smtp-Source: AGHT+IHwh38M15+1GU/8VSib38jt/Un2TXktwUspSm/hagYOen0p4DASMgUzC2YoU0McW/3GoUPwBQ==
X-Received: by 2002:a25:d815:0:b0:df4:e08c:2288 with SMTP id 3f1490d57ef6-df77218eebemr613109276.31.1716503124349;
        Thu, 23 May 2024 15:25:24 -0700 (PDT)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com. [209.85.160.182])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ac16caf23asm944156d6.131.2024.05.23.15.25.23
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 15:25:24 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-43f87dd6866so117781cf.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 15:25:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXcnzNJX6OBpF388SG6132GwWma6MGx2hkElHht/ICh2AEkHMLVDGagrHkfY0ObzS2GvzzQ3AmfXv02ohI9FzTSoYNRCwgCHkxq+w==
X-Received: by 2002:a05:622a:4acd:b0:43e:398a:b0c0 with SMTP id
 d75a77b69052e-43fb0194a6cmr918141cf.12.1716503122909; Thu, 23 May 2024
 15:25:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240318194902.3290795-1-khazhy@google.com> <20240318194902.3290795-2-khazhy@google.com>
 <6bc61553-6c8e-4705-9cbb-8e73d3f8c801@oracle.com>
In-Reply-To: <6bc61553-6c8e-4705-9cbb-8e73d3f8c801@oracle.com>
From: Khazhy Kumykov <khazhy@chromium.org>
Date: Thu, 23 May 2024 15:25:09 -0700
X-Gmail-Original-Message-ID: <CACGdZYKihs6Zfc9vpN5LrFVwx7+qqxV-cMzsO8=cpXpFYWt6ig@mail.gmail.com>
Message-ID: <CACGdZYKihs6Zfc9vpN5LrFVwx7+qqxV-cMzsO8=cpXpFYWt6ig@mail.gmail.com>
Subject: Re: [PATCH 2/2] iscsi_tcp: disallow binding the same connection twice
To: Mike Christie <michael.christie@oracle.com>
Cc: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, 
	"James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 12:34=E2=80=AFPM Mike Christie
<michael.christie@oracle.com> wrote:
>
> On 3/18/24 2:49 PM, Khazhismel Kumykov wrote:
> > iscsi_sw_tcp_conn_bind does not check or cleanup previously bound
> > sockets, nor should we allow binding the same connection twice.
> >
>
> This looks like a problem for all the iscsi drivers.
>
> I think you could:
>
> 1. Add a check for ISCSI_CONN_FLAG_BOUND in iscsi_conn_bind.
> 2. Have iscsi_sw_tcp_conn_stop do:
>
>         /* stop xmit side */
> -       iscsi_suspend_tx(conn);
> +       iscsi_conn_unbind(cls_conn, true);
>
> to clear the flag when we clean up the conn for relogin.
>
> 3. Fix up the other iscsi drivers so they call:
>
> iscsi_conn_unbind(cls_conn, true);

I took a look, and it seems like the other drivers in-tree all use
iscsi_conn_unbind already, and iscsi_tcp is the odd one out - only
supporting stop_conn, and not setting ep_disconnect. Just swapping the
iscsi_suspend_tx call for iscsi_conn_unbind works, and makes sense to
me - but makes me wonder why we were using suspend_tx directly in the
first place.

The only other side effects I see are we set the session to failed
momentarily if we stop the conn while still logging in (iscsi_tcp will
quickly change this to _TERMINATE or _IN_RECOVERY once we hit the
stop_conn), which seems OK.


>
> in their failure paths so when they fail they clear ISCSI_CONN_FLAG_BOUND=
 and
> iscsi_conn_bind can be called on the retry.
>
>
>
> > Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> > ---
> >  drivers/scsi/iscsi_tcp.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> > index e8ed60b777c6..8cf5dc203a82 100644
> > --- a/drivers/scsi/iscsi_tcp.c
> > +++ b/drivers/scsi/iscsi_tcp.c
> > @@ -716,6 +716,9 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cl=
s_session,
> >       struct socket *sock;
> >       int err;
> >
> > +     if (tcp_sw_conn->sock)
> > +             return -EINVAL;
> > +
> >       /* lookup for existing socket */
> >       sock =3D sockfd_lookup((int)transport_eph, &err);
> >       if (!sock) {
>
