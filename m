Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBAD2E174A
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068579; cv=none; b=dCseYuOy72Wm8CNEwsKZy44SXwgdoi/8eXNnLxOQ9SB8cabtK+XSyqPa+wkhOzbNNyEMcZ739/8SXuWwal9h87IIRJmEnbDKor9EISE0UK2xkPrpsYzZV51FKbPC1c2aKrThP94YiChnMIDG/pAt8o8P6jXH1q03LVbdvt953tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068579; c=relaxed/simple;
	bh=zedoMAKvG5OEntoYvyJAjOfw/RjsogJvkdssZ5XpKRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pt8rD+CrAIBBZ0LMI6OQod19s98BrpzB4sKdp/WeSr8GEv9CAUIPUCoB3zmGWrGepGZVybQb20g7hzyhrn2mNYQFIwj23vWolbEvdIObS8CIzvXxKc43OrGh7WjIJaJx2NhpKGpaozNYzulP+9LdqxFVPVw4Gj+yf+tcmWJr3Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fSBB3871; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fSBB3871"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752068576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0guZz0nxGosC58GUk7QyOJH24N9dOr04NyvpD1yjTvY=;
	b=fSBB38711JxeozcDsmWTy5K/eSBnDA+J5ZGforO50INKCJiCO+J0Ux0Buyasa3e2qhTtAE
	xi8+gP2KvzwttYh5CJhK/H1o5LjMYfo959JCDHBVbRai5pynRuJ3WHdUJH7GAqh1Dc4qT/
	6Q4G2SFqxpw1aQBoRGnckK/hQZNSUVc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-bvTV0gofNTeDDbmOUKOsCA-1; Wed, 09 Jul 2025 09:42:55 -0400
X-MC-Unique: bvTV0gofNTeDDbmOUKOsCA-1
X-Mimecast-MFC-AGG-ID: bvTV0gofNTeDDbmOUKOsCA_1752068574
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451ecc3be97so29305915e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2025 06:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752068571; x=1752673371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0guZz0nxGosC58GUk7QyOJH24N9dOr04NyvpD1yjTvY=;
        b=quOuMVj0+/9H18HuF5U/TrhrhO6yEy4JPI9/ylwy48f+ujM7E1z6pw/V6qTdcX6Kvd
         8iRcj5p68fNKRBh2ROWluGfz+oaNsasW3LrLqlINjyi0C1+it0MDSb96cBd1e1ONLhpX
         JCc+NeLitvp9G67xj7RYOyzCR4WNVDmuWF+EsnuRpt74TacJPRf8MIFQLb8ktQm6bs1i
         0VoI2Lkh7rKlpy8qfwj5IMayKcpdQpywx7NW4QWFp8hATh7kXefpZHzqR61gnv1UOMLH
         xGh0f9Q0ddurDqvJh9V3XBQAWbn2FEMXAC2Fg9tDdu1+Bau+MOTHZ3kibU4C8tK3h6aP
         Agkw==
X-Forwarded-Encrypted: i=1; AJvYcCUicH3gZQJJFWR+lRn7ULU/6vRMX4PFFY+qaxfUsg+WZ5a6qoWYAr9fS3EwsHN1Xl8CDrO6pFBdyCNn@vger.kernel.org
X-Gm-Message-State: AOJu0YxmRTTQRRCXj4wJp23H1nysJDPMEMMVc793WlW30Sxup5DX+gEK
	l+7Fm684fZHiuOn7biXd27z3uet9bMsMifKykr+GvsCW0Y3cZNjiUXgIMcXLUAFg09vwydGxNfY
	uZv5Ld+Mw2mgXulI6OSNQ+c52uvQexZbDyf/X94INRG3D07Ok0AjagUQVe2/00PP3qly/EqWU/j
	0bFXVSpJLEOa/wOASv+gn6fGZsJDf2tBZ+XB8iLg==
X-Gm-Gg: ASbGncsxLobGytbJ6TNxEp+ZmDWzw0Ta9mIKRBv5m6G6EH0NrX0f5CBfQQyp8JCE3O+
	CBWrADrwFh7IRJ01SrYIU6KmxTz0Loy7sezgJEwor+2g7lVC/KX4Q1epaniKLZ8Jk+Mon/8fK7b
	bO+vde
X-Received: by 2002:a05:600c:8518:b0:43d:2313:7b49 with SMTP id 5b1f17b1804b1-454d52fb208mr24824085e9.12.1752068570611;
        Wed, 09 Jul 2025 06:42:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH89dnCuTL2cmPNRDmvKQh+uZM/OIYRcbHCPQ09jQ4AZOfXPI2kJkY3Dwz8Ha1kZZSib18R9qACe1iJBvTWqmM=
X-Received: by 2002:a05:600c:8518:b0:43d:2313:7b49 with SMTP id
 5b1f17b1804b1-454d52fb208mr24823785e9.12.1752068570157; Wed, 09 Jul 2025
 06:42:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624202020.42612-1-bgurney@redhat.com> <CAHhmqcTO_Q59aDr3DywC-tPF=9pe3gxbyn6J4ycdf+eYEOayHQ@mail.gmail.com>
 <19484829-0a7b-42ce-99fe-e74ccda67dce@suse.de> <b0817e2a-1c4e-4d7d-9a84-633913d9e0e4@redhat.com>
 <0db83ea3-83aa-45ef-bafd-6b37da541d22@suse.de>
In-Reply-To: <0db83ea3-83aa-45ef-bafd-6b37da541d22@suse.de>
From: Bryan Gurney <bgurney@redhat.com>
Date: Wed, 9 Jul 2025 09:42:38 -0400
X-Gm-Features: Ac12FXwzG1gS7v9UtZ_ikdOvnf5ZBD8N95qvu58iwnI37g1slCVzvxgwerBnmeQ
Message-ID: <CAHhmqcTNrfjj-ABjTfj7LUCQ_qRtcTrZCzhtaERViaAQut3TUw@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] nvme-fc: FPIN link integrity handling
To: Hannes Reinecke <hare@suse.de>
Cc: John Meneghini <jmeneghi@redhat.com>, linux-nvme@lists.infradead.org, kbusch@kernel.org, 
	hch@lst.de, sagi@grimberg.me, axboe@kernel.dk, james.smart@broadcom.com, 
	dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org, njavali@marvell.com, 
	muneendra737@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 2:21=E2=80=AFAM Hannes Reinecke <hare@suse.de> wrote=
:
>
> On 7/8/25 21:56, John Meneghini wrote:
> > On 7/2/25 2:10 AM, Hannes Reinecke wrote:
> >>> During path fail testing on the numa iopolicy, I found that I/O moves
> >>> off of the marginal path after a first link integrity event is
> >>> received, but if the non-marginal path the I/O is on is disconnected,
> >>> the I/O is transferred onto a marginal path (in testing, sometimes
> >>> I've seen it go to a "marginal optimized" path, and sometimes
> >>> "marginal non-optimized").
> >>>
> >> That is by design.
> >> 'marginal' paths are only evaluated for the 'optimized' path selection=
,
> >> where it's obvious that 'marginal' paths should not be selected as
> >> 'optimized'.
> >
> > I think we might want to change this.  With the NUMA scheduler you can
> > end up with using the non-optimized marginal path.  This happens when
>  > we test with 4 paths (2 optimized and 2 non-optimized) and set all 4
>  > paths to marginal.  In this case> the NUMA scheduler should simply
> choose the optimized marginal path on
> > the closest numa node.  However, that's not what happens. It consistent=
ly
>  > chooses the non-optimized first non-optimized path.>
> Ah. So it seems that the NUMA scheduler needs to be fixed.
> I'll have a look there.
>
> >> For 'non-optimized' the situation is less clear; is the 'non-optimized=
'
> >> path preferrable to 'marginal'? Or the other way round?
> >> So once the 'optimized' path selection returns no paths, _any_ of the
> >> remaining paths are eligible.
> >
> > This is a good question for Broadcom.  I think, with all IO schedulers,
> > as long
> > as there is a non-marginal path available, that path should be used.  S=
o
> > a non-marginal non-optimized path should take precedence over a margina=
l
> > optimized path.
> >
> > In the case were all paths are marginal, I think the scheduler should
> > simply use the first optimized path on the closest numa node.
>
> For the NUMA case, yes. But as I said above, it seems that the NUMA
> scheduler needs to fixes.
>
> >>> The queue-depth iopolicy doesn't change its path selection based on
> >>> the marginal flag, but looking at nvme_queue_depth_path(), I can see
> >>> that there's currently no logic to handle marginal paths.  We're
> >>> developing a patch to address that issue in queue-depth, but we need
> >>> to do more testing.
> >>>
> >> Again, by design.
> >> The whole point of the marginal path patchset is that I/O should
> >> be steered away from the marginal path, but the path itself should
> >> not completely shut off (otherwise we just could have declared the
> >> path as 'faulty' and be done with).
> >> Any I/O on 'marginal' paths should have higher latencies, and higher
> >> latencies should result in higher queue depths on these paths. So
> >> the queue-depth based IO scheduler should to the right thing
> >> automatically.
> >
> > I don't understand this.  The Round-robin scheduler removes marginal
> > paths, why shouldn't the queue-depth and numa scheduler do the same?
> >
> The NUMA scheduler should, that's correct.
>
> >> Always assuming that marginal paths should have higher latencies.
> >> If they haven't then they will be happily selection for I/O.
> >> But then again, if the marginal path does _not_ have highert
> >> latencies why shouldn't we select it for I/O?
> >
> > This may be true with FPIN Congestion Signal, but we are testing Link
> > Integrity.  With FPIN LI I think we want to simply stop using the path.
> > LI has nothing to do with latency.  So unless ALL paths are marginal,
> > the IO scheduler should not be using any marginal path.
> >
> For FPIN LI the paths should be marked as 'faulty', true.
>
> > Do we need another state here?  There is an ask to support FPIN CS, so
> > maybe using the term "marginal" to describe LI is wrong.
> >
> > Maybe we need something like "marginal_li" and "marginal_cs" to describ=
e
> > the difference.
> >
> Really not so sure. I really wonder how a FPIN LI event reflect back on
> the actual I/O. Will the I/O be aborted with an error? Or does the I/O
> continue at a slower pace?
> I would think the latter, and that's the design assumption for this
> patchset. If it's the former and I/O is aborted with an error we are in
> a similar situation like we have with a faulty cable, and we need
> to come up with a different solution.
>

During my testing, I was watching the logs on the test host as I was
about to run the command on the switch to generate the FPIN LI event.
I didn't see any I/O errors, and the I/O continued at the normally
expected throughput and latency.  But "if this had been an actual
emergency..." as the saying goes, there would probably be some kind of
disruption that the event itself would be expected to cause (e.g.:
"loss sync", "loss signal", "link failure"), but

There was a Storage Developer Conference 21 presentation slide deck on
the FPIN LI events that's hosted on the SNIA website [1]; slide 4
shows the problem statements addressed by the notifications.

In my previous career as a system administrator, I remember seeing
strange performance slowdowns on high-volume database servers, and on
searching through the logs, I might find an event from the database
engine about an I/O operating taking over 30 seconds to complete.
Meanwhile, the application using the database was backlogged due to
its queries taking longer, for what ended up being a faulty SFP.
After replacing that, we could get the application running again, to
process its replication and workload backlogs.  The link integrity
events could help alert on these link problems before they turn into
application disruptions.


Thanks,

Bryan

[1] https://www.snia.org/sites/default/files/SDC/2021/pdfs/SNIA-SDC21-Johns=
on-Introducing-Fabric-Notifications-From-Awareness-to-Action.pdf

> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich
>

