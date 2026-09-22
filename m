Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ACB41B8CD
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 08:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065597; cv=pass; b=qzB1h6ehuZcIa1lXwnijHkDglzlLvN/anxFrMyZioMfJNnraBZLZITDwCGNDQNAZ+bGnSSfNHbzygkFxIt6nCUcleEBSNuxnIeb79CVvSWHl+vNuJCfQ71YWokZvpFv6dY7iJr0pybeFTk2y3SlTgVd14rRK392raiwxgm6Qc4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065597; c=relaxed/simple;
	bh=lvacjQG68N2xcrdqTRJ9VHj4mhfJsAvTAX68qY7zwqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rCFVwCCcTRKUEI9csqs7akqBwqzi8Jit+fg+MeuDfQkjhoxP0NVU2jOip7U5ONsEOpsuCIaCI3VdhfQhX46P1J79GaGSaBmc664qVDGR5di3+EIrNhM2osmD4013Xpm0l5XwNh6BgZLKi+o/vJQHeh+HFBTSvlWSYgNNlMzB3/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bHhcjsp4; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bHhcjsp4"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66fded6b087so3705483d50.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 01:26:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790065594; cv=none;
        d=google.com; s=arc-20260327;
        b=CMtXw5HGU0O3Poglbxex2v5YGAcvkdmnT+AcOryJ+GdUlmeme0q8Cs7GBSEjNr5Otn
         PwOBiF8l5tClHPOD+HkdUr/42q0S1FzLjdll+oGwbam1ahfQ2I+0aKYUnvgbQQ5bvDZR
         etuWESf2kqnj2GajSBuZplsijQppFs69A5msqqbOLeYZuqfDbRDvES+EFR+wEfEfrk7G
         ZDT6ZUZNk55mLwAbGUs66x4SC/XvzRG+4gxYwqR3y/VI8Jw9t5xqkOsOtCWJWc4I4xRN
         jOW8kXb6iafB5u/vzT0DFDrdSEBs3baXRt0Z241NZPuat9enr9j1auUqW+xve3TmsRGa
         J0Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=99LwW3jpXQMD0BKLN315tdPNzOGqAVo36rmxu/uCw48=;
        fh=aXh64H8bUJDqw3iTJcVc/rP6nRksDGyhDwtMEnbOBrk=;
        b=RhAR7Baazzs7t8N40GjaO9xbjGICn22tYlDADJHWLfwlDsq+S6l6QsNH07Ub5Qa3eg
         hzcucwtLKY5bpUzNhmmcAAH0olnb79PS2D3oJIwBOCRikF2hkTohk1yb1mZJzfvxa5U7
         sfuJYzw+Fhd+h5MF08mfpAebTJOaBFSOypT2JKhDrg8U2bbOt4MO+M+XZgI271BDbBgg
         UcP8C3sHoG59mZSjWWdSAJUN1193jhJUyLi+Lf1y+AkAefaE1IrU3JTXKW2Ga4za26HD
         p2nAF6THU2NX/wrl9LqJHT5QBkRNocYUF46lKL4c9pnt5Wb70DJxBqvx8IG8Mo2jfctw
         4maQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790065594; x=1790670394; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=99LwW3jpXQMD0BKLN315tdPNzOGqAVo36rmxu/uCw48=;
        b=bHhcjsp4gEOP5ylEWN1PmBWC113BvpM4G49UlW0jHo0CR4HKz7FeKaws1/xMgYycpf
         RRMFs1Ik611/CaYKiv+NfMORhcbp/fuWxxkY6uXX+TjEFYsO5qM7YKu918wya07Nxr/Q
         K52i0ox8PVrkp/K+5kjVHjvQJ5AoZEQ+xTewGbXRyiNUjuhrLOoLVR50OigAjeTFwycD
         1+lq8kYlL85j2qwp6gDJtWhyHqtRZz3tnwADB9pUAWIUfcVwsRMqq/NTvUpSfIzdyxIL
         U5ALdrp+HrnLucIWIPwDTfAthYr+pk91m+8O9EjEGjPoPUg5nAKizKZTiGhkf9O+MwCh
         uEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790065594; x=1790670394;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=99LwW3jpXQMD0BKLN315tdPNzOGqAVo36rmxu/uCw48=;
        b=nFdgB9//luR4K8Ox2+rZZMAw/MqgF67/RQe/w+SteHD6q7DsSEx9oRaauVgPCiHyNp
         O+mhd0jE5jclVmsVltZS+dW3wTi8DiY+AQSuVJ9rAPFuCIb5u65zPFKjHZzTCJoD3vFF
         Oe3wnbrBFVxEq90HSvlHOx7wRhnQrfr9/q5RGzwvuqVINGOytRA/RdIZJFxh3EO7uVIO
         XZCnmAcsRmObdKBpVRf4rYCmeI4+bjojZY3H0yYXP99TuMgLXADgxWRtA4Z3FyyYA1oJ
         QeLA2HsTLn7jLCS2fpTWmjVHmb12dtWQmoTKk7bNr6iK2J9tykXblYv20YLXtdNcZWEC
         AspA==
X-Forwarded-Encrypted: i=1; AKwUvBxwm6Ep/HdTTUWrx8y4Uxlzi+Cm0YP2G7Z0aZaF+qGMxr6EBI31IfIS06CyD/NNcOKyCuV2yhLLVyhb@vger.kernel.org
X-Gm-Message-State: AFuF++kJ2t87l6LljGkfe42mNfm3lsdX2pDILKsnrdnaqVM90067KqWP
	cWZx1GOJAkbpOhF6QMkoVhG3C9TdhCD/mf11FzVy79QWg17fd8tlmUNNgtOm4QlS1GFXM6XERrJ
	pEyNqHVz9Eg84Z0NxJt57yAIuQhbNo3k=
X-Gm-Gg: AYBFou0QBewqjuWxR7ax4hRxZ+2avI4L4WBRX6lMa5WoANIVcbPmQ8Ysiqh5837SfVq
	Erz3+hY1lV9BxQlDRrDbY5rGsZvmMCEXZgzu7XLYJRLIpVvt83c88TMrPBwqDqXG5REuAtIqppv
	cfDiAENluUExoZ1PXxj2pZ96IHVIKbnUS3lpQanyiqujfJ+ALhoGZ9ycPQAk4wKM+ekX2RbAo2z
	RFkU+xoQWW+7jaKJKhneTCIh9bTbzwgTgZSkjCirg+XPfiWR3dxGuFVPgbGnVozVvzNrvJdl3L1
	Dco+imbagb44ttJBBDLrF6UmHWN8rZ0QZVb3+UuGpXHokc94bfNPrgS30g==
X-Received: by 2002:a05:690e:4087:b0:671:316c:3945 with SMTP id
 956f58d0204a3-6717fc63363mr4790057d50.18.1790065593563; Tue, 22 Sep 2026
 01:26:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260919173405.3718408-1-lgs201920130244@gmail.com> <4ca4f5c5-5021-4a63-bb14-4b7d0502eef6@suse.de>
In-Reply-To: <4ca4f5c5-5021-4a63-bb14-4b7d0502eef6@suse.de>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Tue, 22 Sep 2026 16:26:20 +0800
X-Gm-Features: AcwNN1Vp1Z9Tq03Y5viAHRjjzoW0XTYRpGaxw2OWC81kqrhnlnCGwEcxNi_VTN4
Message-ID: <CANUHTR-AHqeBhiuTpoVSrGjBqpWzug2JW3npaQEv7ZDZj7q9BA@mail.gmail.com>
Subject: Re: [PATCH] scsi: libfc: fix directory server rport memory leak
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Robert Love <robert.w.love@intel.com>, 
	James Bottomley <James.Bottomley@suse.de>, Joe Eykholt <jeykholt@cisco.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hannes,

On Mon, 21 Sept 2026 at 16:48, Hannes Reinecke <hare@suse.de> wrote:
>
> On 9/19/26 7:34 PM, Guangshuo Li wrote:
> > fc_rport_recv_plogi_req() creates an rport before allocating the frame
> > used for the PLOGI LS_ACC response.
> >
> > fc_rport_create() does not add FC_FID_DIR_SERV rports to the discovery
> > rport list. If fc_frame_alloc() fails while handling a PLOGI from the
> > directory server, the function returns without starting the rport state
> > machine or dropping the initial rport reference.
> >
> > Since the directory server rport is not present in the discovery list,
> > there is no later teardown path that can find the object and release
> > that reference. The allocated fc_rport_priv is therefore leaked.
> >
> > Record when the failed frame allocation leaves an unlisted directory
> > server rport behind and drop its initial reference after releasing the
> > rport mutex. Keep the existing lifetime unchanged for ordinary rports,
> > which remain owned by the discovery list.
> >
> > The issue was identified by a static analysis tool I developed and
> > confirmed by manual review.
> >
> > Fixes: 3ac6f98f4113 ("[SCSI] libfc: correctly handle incoming PLOGI req=
uest.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> >   drivers/scsi/libfc/fc_rport.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rpor=
t.c
> > index c25979d96808..884b233c2f72 100644
> > --- a/drivers/scsi/libfc/fc_rport.c
> > +++ b/drivers/scsi/libfc/fc_rport.c
> > @@ -1848,6 +1848,7 @@ static void fc_rport_recv_plogi_req(struct fc_lpo=
rt *lport,
> >       struct fc_els_flogi *pl;
> >       struct fc_seq_els_data rjt_data;
> >       u32 sid;
> > +     bool drop_rdata =3D false;
> >
> >       lockdep_assert_held(&lport->lp_mutex);
> >
> > @@ -1940,8 +1941,10 @@ static void fc_rport_recv_plogi_req(struct fc_lp=
ort *lport,
> >        * Send LS_ACC.  If this fails, the originator should retry.
> >        */
> >       fp =3D fc_frame_alloc(lport, sizeof(*pl));
> > -     if (!fp)
> > +     if (!fp) {
> > +             drop_rdata =3D sid =3D=3D FC_FID_DIR_SERV;
> >               goto out;
> > +     }
> >
> >       fc_plogi_fill(lport, fp, ELS_LS_ACC);
> >       fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
> > @@ -1949,6 +1952,8 @@ static void fc_rport_recv_plogi_req(struct fc_lpo=
rt *lport,
> >       fc_rport_enter_prli(rdata);
> >   out:
> >       mutex_unlock(&rdata->rp_mutex);
> > +     if (drop_rdata)
> > +             kref_put(&rdata->kref, fc_rport_destroy);
> >       fc_frame_free(rx_fp);
> >       return;
> >
>
> Wouldn't it be better to always create an rport for the directory
> server?
> That would make the teardown path far easier.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich

Yes, that sounds cleaner.

I kept the current directory-server special case to minimize the change, bu=
t
using the normal rport lifetime would avoid this extra cleanup logic.

Do you mean adding the directory-server rport to the regular rport list as
well, so the existing teardown path can release it?

Thanks,
Guangshuo
