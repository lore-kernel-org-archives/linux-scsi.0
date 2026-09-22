Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746C537B011
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 02:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790043197; cv=pass; b=tZh8KgoiKCmkY8nAu1TEoRJbiZSk20dLZCHrGWICoKmD+YWIUxFpsBBQE+Recnj7AhfEKjDUCYMr5Xy4yl2vO78yJTOHRoPowfKtXrjd6MhAA2C61XyGegC1qkxXdgHmTHnr6bpkmzzSqiZglmFijtmuzQIN9PM+nqI6/HajuSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790043197; c=relaxed/simple;
	bh=vl44nk+GAHuCfD2I3sOCz7xvvreFR6dp4SQQQMUUpag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o0cPsHtuI8prD1ifaH3a4Gpl2bjk8tAKgzz8rqZBfaH4+qy023ysQjKfvRoEbfkx5phH0gzcApr13Y6pLNBZ4yO0PXMQ9uCXiuP4XZP/YXyP2KBNaSY5IgmtE6FV2KYbOyUxLe+b84JcVty7m9gDmZlkcmA3MTdy7HX4qrbYkhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gefxirmo; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gefxirmo"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66fb93aee5eso3693885d50.1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 19:13:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790043194; cv=none;
        d=google.com; s=arc-20260327;
        b=T/PBWoPKI8B7bk7SXyZGEbAGI0DOKweZS6+p4+KvMZSaAOSbQO1n0ETn6hcC/TDIYg
         eOX2W+b8cLvEU4zRI0TspefIy+Z3JoIBFNbunKFz0SB7WrkYH/TTzSa0kvMhqxnA6M0l
         rPkhGWaFdwE9RMpNAE8Rb6zPMU/weTsc1BFS6CGyualygojV+fpLd+QazIgON7SPi4na
         rPZeAk/IplQUvZcA1EAkGDrK4PMtSvAOOXzA+3C55xWD/F/vTlFKhOROkp9sn44QE3kr
         YFJWPzm4NtFpKq380F50GbAbSOCapXTQAkoMFTuI8DmE36xXpaybXoBRpWQ7ewUQW+9v
         ZklQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ULHj23OU+X4saT6RzcQcJjlqgQV+yT9LbYfIN+JAXJU=;
        fh=lM6JikfblDsIu5iNe4FVZS4w80cOU0pDNgB3SB2eWuA=;
        b=MLlPHhWeTMg6RCBQizcgAYJCV8jx4EPc6oCqlpzpeaxgCT6rQUsU7SDe+FkaHnhB4J
         7qa8zNcmlwcp1S6loeK5BB2s+tvzz7xh3shnZNGMQIpFh4lw2/QYXuPLUmx49zlcUOJm
         IqHRkzonYzQVDgt2XVH8RH3nk7sq92Ft1/phbg1+0m2ZU67yaSbQTTjzjjPfN7qJUYb2
         /6OfzFiv45xSp9NxIAefu52gYmAypNwAPCrHsKvhaXilxXN8Sb9OyBOnujEmeRRPuVC6
         qblcF/NEdOUV/M4d0WOat+lUZRl4L0pOn3JRB+JF4+L/Aj5oWakeW4moLpaylHNIIIFd
         gFSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790043194; x=1790647994; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ULHj23OU+X4saT6RzcQcJjlqgQV+yT9LbYfIN+JAXJU=;
        b=GefxirmoIahOb17JKEMzsKUtboJaX1sxPgU25KUMJ2I8Q949GZwm1O5rUNbaKhcMmR
         G7ejMkrNgl4Llqtzi5AwEDkmCaw4spn/jYZO42Io6y3B3EUng8uFehBHjLpyZRnG6Gt+
         mcXBKSNRle0nqZq8ZqQynriovAw4Xc/9K0P2vrRJVLOwSEYMBNIEOKzHTWNNAbAGY6DO
         lZjmmuYxXggvoQ8RDhIrpMGstI/gC8gWoZ37yZe0U8skK3OQXhyJjdmV9uXFo89lQAs3
         Lb6Lhe7vX9Q0yhFmEhjAEOMGcbVq8abuK9DLTF3ognFuKVso/4U8Vg11A+0wAcI9IUuC
         lnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790043194; x=1790647994;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ULHj23OU+X4saT6RzcQcJjlqgQV+yT9LbYfIN+JAXJU=;
        b=LIExGJ9dOZ3shPIyhL9QZtpJmndamgYt85lY7jqU4sozQpJtSApAlJSHJighWSiX7T
         kMHFSmczJ6KqZ1f983aQAGc+XZbXU+tqiig9L0ABsGW2VDqNWyltkN+KLf4fKXv20S6u
         PefalecDrVWP4lAmbn/8gs1RFX/f2pDaP+DkaZTUv4d/WXFeelbbwklw7UgyQY8iqmo3
         bUrsxUwDtR4zsaDafMQUiNhnHaZwlYKOHxZBWAdt1ZTpyJDp++OeOMXu7fg/7HhiQxtz
         Bw1qwspI/KdM6Zfs7RvMSpasFYm3Ynm2JlfaCcEJSwnsOzUYw8974c2ZI95r1UJJwLSk
         VXqA==
X-Forwarded-Encrypted: i=1; AKwUvBym5KSK+RUmNG+j2R37245naHIFe3xq+Gy9FBFB1AbJZ6yS8ovNWa+JLYgGkFA8sCVPdC7q4FXneiT2@vger.kernel.org
X-Gm-Message-State: AFuF++l5VVd5i/FtiDK4WJ4qj991ET72z9ktYLPeVuVvu3Jut3p7ziNO
	csG91TNZY8fP4I9o86UZ+jAHah3RUZ7h9jd1tCt5geL6L/EEnwlPnkIB7SiPrFfr3bMKsomN2qD
	gpKlr+0CYdqhVsPcCSK61szRUe+CQ1+I=
X-Gm-Gg: AYBFou3YcDIakvWVlZdNvRp7N0PtB/3Qw0QUwP2+qSJIfzcwqCP5NpU8d+kEP2pGcVl
	NV9weVXKEamftUa/og0Ot0+vz1cFrhXSQ8CfUA2KvIl8kWdQwEWvws3YQu8WbbbiMtzA0iRSTDz
	HZORj/JEGctCED6zNuNlvbZxQOc4h4SLBuzlZDjxsK2Ph2P02WRYLG6b5Cv5MITTNMoIHIZWtkS
	obiDxr0Rq/LvOGOjkSspq2SHqUcksxre+cZXJMo3X9C78YiVFvmrW3uI6AUgwR9gkPhIZ1Nh0pn
	Ya/7nHH/yL/yyVfB6Kdq72krFCDwAQepNfH7necQhb6CUkF4QeMnVAFWUw==
X-Received: by 2002:a05:690e:c41:b0:672:b897:9b8d with SMTP id
 956f58d0204a3-672b897b1a7mr1578174d50.79.1790043194211; Mon, 21 Sep 2026
 19:13:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260919173405.3718408-1-lgs201920130244@gmail.com>
 <arFKHueZaSQAOSbc@quoll> <b9bc4c58-c34c-43b0-85bc-45aa0d251f41@kernel.org>
In-Reply-To: <b9bc4c58-c34c-43b0-85bc-45aa0d251f41@kernel.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Tue, 22 Sep 2026 10:13:01 +0800
X-Gm-Features: AcwNN1XQAS3TF7su8S9S3A9jUbbyHP4JvqT1HivMJFxHlgzVj13Y81vp1_lJchI
Message-ID: <CANUHTR-eWUywrh_Gj=xdg3q+FipYt3WyBfLEw+QYddn_3Bo+iw@mail.gmail.com>
Subject: Re: [PATCH] scsi: libfc: fix directory server rport memory leak
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>, 
	James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

Thank you for your feedback.

On Mon, 21 Sept 2026 at 23:30, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 21/09/2026 17:15, krzk@kernel.org wrote:
> >
> > On Sun, 20 Sep 2026 01:34:05 +0800, Guangshuo Li wrote:
> >> fc_rport_recv_plogi_req() creates an rport before allocating the frame
> >> used for the PLOGI LS_ACC response.
> >>
> >> fc_rport_create() does not add FC_FID_DIR_SERV rports to the discovery
> >> rport list. If fc_frame_alloc() fails while handling a PLOGI from the
> >> directory server, the function returns without starting the rport state
> >> machine or dropping the initial rport reference.
> >>
> >> Since the directory server rport is not present in the discovery list,
> >> there is no later teardown path that can find the object and release
> >> that reference. The allocated fc_rport_priv is therefore leaked.
> >>
> >> Record when the failed frame allocation leaves an unlisted directory
> >> server rport behind and drop its initial reference after releasing the
> >> rport mutex. Keep the existing lifetime unchanged for ordinary rports,
> >> which remain owned by the discovery list.
> >>
> >> The issue was identified by a static analysis tool I developed and
> >> confirmed by manual review.
> >>
> >> Fixes: 3ac6f98f4113 ("[SCSI] libfc: correctly handle incoming PLOGI request.")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> >> ---
> >>  drivers/scsi/libfc/fc_rport.c | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >
> >
> > You sent multiple independent patches, to multiple independent
> > subsystems. The amount of these patches clearly suggest this was
> > AI generated and most likely not tested.
> >
> > More importantly, you sent all this work without properly organizing
> > relevant patches into patchsets. This makes reviewing difficult
> > and might cause multiple reviewers to address the same issue.
> > Replying to the entire set is impossible and requires handling each
> > patch independently, instead of applying or discarding the set.
> > Maintainers also won't see the bigger picture of your work. Quite
> > worrying.
> >
> > This is on the verge of hostile patch: bomb us with so many
> > contributions, we won't be able to handle them in efficient manner,
> > like responding ONCE to ask you to slow down.  Considering all this
> > is untested and LLM generated, I have even more doubts whether this
> > should be considered for review.
> >
> > Please read kernel documentation BEFORE posting more work. It will
> > explain you how to identify subsystems, how to organize your work per
> > subsystem, how to document usage of LLM and how what you should not
> > do if this was posted in a good faith.
> >
>
> Apologies for spamming here. Fighting fire with fire :). No, just mutt
> mistake on my side.
>
> Best regards,
> Krzysztof

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
