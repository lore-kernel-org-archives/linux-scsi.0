Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8853C23F424
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192518; cv=pass; b=tTKvnBAribc+1BWIy45Xk5AI/NQd0B3aYAAnPTdCmaxzdNDmi0fJjTG5p89uFIgwOiuyCp1neyeqeFUuPZEgq/w2FnC/dJqC7nHP66Ie6IyYTf2j6vx/nX4exoQrUqKQ4RaPsUpjhMZ2ljGM/5sQe6KOvf2l510QIa2eOTuESug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192518; c=relaxed/simple;
	bh=DszU/BPViRE35X2+Vz6HBukhUFn6h0zZiDuz6SphTVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QhQmRraHWege58zKeNyUhPDwBAy033EjxWvZe4A667Dvk4hfCD9wWSZoBe7TaHc+vIr8oRzhPo4m2fGCobog5zc1BXnADwOCuakB5Mbe1S5wCR5z5Y6qoXnS5Zdyk1x/y3f3+pfbI8yVUxWcGrSGCXbUGBjjNdHfOiXdw/hI/0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gZMXgse7; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gZMXgse7"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-385da75c6e6so12527891fa.2
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 10:21:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769192514; cv=none;
        d=google.com; s=arc-20240605;
        b=UM1XpzIST0hs3EL1mzS0jwz2LDyPDCNCq3WMsZE6jVUXdVgsYnTHN0nqld5z73GAMS
         JydosGWmFCTjEQs3jsXgUYAi2VuzPYtbnQrClYoKEuRRp8ZKDUiDktJJo03ftKhHDP4h
         spb6CaR220IUG9QFlSwbZ1ELaCtrndr7O1+1nNA51FYgHmMh0ZaKILC+PHYubSrPQP2E
         RlDSDx3fWEhudKM15LbTyApgAxKCLOXpYOngy5kEd2K8i2F/5k42WCMr9fns5IzglJhM
         mBUV3KO3JjVUbhvU77ensfFY6pIZR/f6AIwfkLU2WtSITNq0dTywZl7+MVhaF50v0TxP
         sqAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UE0UnsCzbrqpHFtBpip/DI+c8M6qwteJ3neggccj5XA=;
        fh=S6PNllKkdnA/QtAgEynJBnnC9UEDYAYajCmTpE91HBY=;
        b=kuw8QqUU+eA7x/HfEQ8VUvd5dWN+/KNorpT/RM/18Ou9y/3doH2cpLSSvvoIUYC+DS
         LArNan0XMm8BI2ijYJkD8+v8aWSfFj0c5BcFiN8mNZC2gvYM0jKoV8EhBXu/EwGU8e9l
         nDjmLilWJ2YdPHvZ71UX6sKHZUnMF7/TcujkJRK3VCHuaWDtLJRsvYYVSIkNpWNnX9Hk
         3q27WUZs/Ajutrb36kKe4UVCMdKJS7lwJzi/v5uKEF+LBtu7ADZ5DOkPspzyqikVd5Qx
         +HzSHC+ZLg6G1I49Zq1qQGB7sXjK/zbya1X0L/1UleWEL9AYEjDLI+cFYIQzq2Yn8LAc
         iMoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769192514; x=1769797314; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UE0UnsCzbrqpHFtBpip/DI+c8M6qwteJ3neggccj5XA=;
        b=gZMXgse76uEbD/opMg9zI7QKur3/TuULDyjU1DLALLvCBSrbOqRVtNAc6ULeH9Y/Yb
         tt7HnlLLir76GQaOy9S7Sf/RyaoUM9xwmYmnaxRjfqQc3vp7fdjCMJvR+by9FX5v+YC8
         RHU5Gj/VjyUeS6xfiLlQX5e6WPzZn84o+Ts5rOKOQ2w+lrE2qV5EyU35CFp38TiGIN9a
         AAcxl1EN+ciOkOjSLikaCtZ91wvVXHpL99B7hxRteWUys7CaWd7U5PWD1tQ7QtlsUR9+
         EoxCEzPaZeuONEM4tRJkLokcucIX9U+SMIrb1HIPeKpNXnQ0hE9aDt/aXEnryF7xhIgW
         tV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192514; x=1769797314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UE0UnsCzbrqpHFtBpip/DI+c8M6qwteJ3neggccj5XA=;
        b=NfQ7bmBN7UrPpEFehjRTmh+LKDSVtv2i5umc/GKERACZot8ZyyDEfOgZ8n19te5/qC
         dPECGZJ2LaF6qgYBdSRk1VNOJAoRsXmdYF+kb7l3wkC9HrGMXsf9XO1ZPlqkocjTLH3a
         Pn6RJMSASD/j98kCU7ZunGsnMdwkECoJk0+9nOrfD4oTyd6nqPigrSv5DuzeqdFWv2IH
         cscYBVN+r6UP86nokaAZjlNYMU5Q0aMIoRwuY1+nfmqf4//G2ZkI5LhHiuS6z/CYBP4b
         TODVLt4noTsgcT+gEtdcgiyFZXLMUdhgdrfCL257GIuI5bPAyVht0bp0StUzZBtJqdCe
         ZRjg==
X-Forwarded-Encrypted: i=1; AJvYcCXzS973ZR1nk7gnVy7xmlnpjY9T9NwyLArm0TVaxyMloD+f7qs/RaL3voIFUBuFgwK/LR+A3vtA9szb@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd3QISmKkc0yT/9PeWmtmc+hfNfuoapPXJBee1UIXsn7C2Hil9
	dsIL3TuMSa3BCk6Q5g3nS9mnTMcCetnin0iy/RQcRFaq1NN7amAWNrB00aTdFQL2GbOuv0sMKc0
	siZwp2OM/RmoIklw7UhbSmVnkh4WPu/L9oPKrXAyJGw==
X-Gm-Gg: AZuq6aJAWuOKfhdJzTrHKBT/YQnDuY/Dbf/vWRe8gu8ecPpQP12u6ikbbkkIaQXOmvB
	T634ZsbaDwtK7sQZ8ZQt5vTtWNntwQy1iTNgKlWwZ6MYKnsZw248xCHX16gF5VexFN2sZqX0ePt
	s/e8Lae6kAF1HzUT05a7Po6KnZLy0Kqcy9fgnYoiyXFdY0DuiIlvBD63o6ynsIlE7QGS1M+qmCe
	NtYbgWaB9aH4ReWctFUy7d6GOfGgvoUbJhv53v3Gwb/x+V25Y43l67yN5yhiUq7h9n9NSFFnM+c
	BfiSoLs=
X-Received: by 2002:a05:651c:41c9:b0:37b:ab43:8958 with SMTP id
 38308e7fff4ca-385d9f55f4emr12067091fa.16.1769192514069; Fri, 23 Jan 2026
 10:21:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104100424.8215-1-hare@kernel.org> <20251104100424.8215-5-hare@kernel.org>
 <SJ0PR11MB5896BDD3102F17EA15356C95C3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <b8631995-a3df-4232-9f89-514d7a502bc0@suse.de> <SJ0PR11MB58964721E3ABEF2CF62D7D10C3C3A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB5896BEB89C838BF3E4929135C38FA@SJ0PR11MB5896.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5896BEB89C838BF3E4929135C38FA@SJ0PR11MB5896.namprd11.prod.outlook.com>
From: Lee Duncan <lduncan@suse.com>
Date: Fri, 23 Jan 2026 10:21:42 -0800
X-Gm-Features: AZwV_QgVGBhyPz1abbZZV7W6EH3oVDz4h9XIvOpwE6s8EmVyKxYoRUkBL5kNxsc
Message-ID: <CAPj3X_WDYDuqvCmoccNC2dHkB03K1gq1okkY0L3z2dZxd_q6=g@mail.gmail.com>
Subject: Re: [PATCH 4/4] fnic: make interrupt mode configurable
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
Cc: Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	James Bottomley <james.bottomley@hansenpartnership.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)" <satishkh@cisco.com>, 
	"Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, 
	"Arun Easi (aeasi)" <aeasi@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 9:04=E2=80=AFAM Karan Tilak Kumar (kartilak)
<kartilak@cisco.com> wrote:
>
>
> Cisco Confidential
> On Friday, November 7, 2025 2:23 PM, Karan Tilak Kumar (kartilak) wrote:
> >
> > On Friday, November 7, 2025 12:29 AM, Hannes Reinecke <hare@suse.de> wr=
ote:
> > >
> > > On 11/6/25 23:09, Karan Tilak Kumar (kartilak) wrote:
> > > >
> > > > Cisco Confidential
> > > > On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke <hare@kernel.=
org> wrote:
> > > >>
> > > >> In some environments (eg kdump) not all CPUs are online, so the MQ
> > > >> mapping might be resulting in an invalid layout. So make the inter=
rupt
> > > >> mode settable via an 'fnic_intr_mode' module parameter and switch
> > > >> to INTx if the 'reset_devices' kernel parameter is specified.
> > > >>
> > > >> Signed-off-by: Hannes Reinecke <hare@kernel.org>
> > > >> ---
> > > >> drivers/scsi/fnic/fnic.h      |  2 +-
> > > >> drivers/scsi/fnic/fnic_isr.c  | 13 +++++++++----
> > > >> drivers/scsi/fnic/fnic_main.c | 10 +++++++++-
> > > >> 3 files changed, 19 insertions(+), 6 deletions(-)
> > > >>
> > > >> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> > > >> index 1199d701c3f5..c679283955e9 100644
> > > >> --- a/drivers/scsi/fnic/fnic.h
> > > >> +++ b/drivers/scsi/fnic/fnic.h
> > > >> @@ -484,7 +484,7 @@ extern struct workqueue_struct *fnic_fip_queue=
;
> > > >> extern const struct attribute_group *fnic_host_groups[];
> > > >>
> > > >> void fnic_clear_intr_mode(struct fnic *fnic);
> > > >> -int fnic_set_intr_mode(struct fnic *fnic);
> > > >> +int fnic_set_intr_mode(struct fnic *fnic, unsigned int mode);
> > > >> int fnic_set_intr_mode_msix(struct fnic *fnic);
> > > >> void fnic_free_intr(struct fnic *fnic);
> > > >> int fnic_request_intr(struct fnic *fnic);
> > > >> diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic=
_isr.c
> > > >> index e16b76d537e8..b6594ad064ca 100644
> > > >> --- a/drivers/scsi/fnic/fnic_isr.c
> > > >> +++ b/drivers/scsi/fnic/fnic_isr.c
> > > >> @@ -319,20 +319,25 @@ int fnic_set_intr_mode_msix(struct fnic *fni=
c)
> > > >> return 1;
> > > >> }
> > > >>
> > > >> -int fnic_set_intr_mode(struct fnic *fnic)
> > > >> +int fnic_set_intr_mode(struct fnic *fnic, unsigned int intr_mode)
> > > >> {
> > > >> int ret_status =3D 0;
> > > >>
> > > >> /*
> > > >> * Set interrupt mode (INTx, MSI, MSI-X) depending
> > > >> * system capabilities.
> > > >> -      *
> > > >> +      */
> > > >> +     if (intr_mode !=3D VNIC_DEV_INTR_MODE_MSIX)
> > > >> +             goto try_msi;
> > > >> +     /*
> > > >> * Try MSI-X first
> > > >> */
> > > >> ret_status =3D fnic_set_intr_mode_msix(fnic);
> > > >> if (ret_status =3D=3D 0)
> > > >> return ret_status;
> > > >> -
> > > >> +try_msi:
> > > >> +     if (intr_mode !=3D VNIC_DEV_INTR_MODE_MSI)
> > > >> +             goto try_intx;
> > > >> /*
> > > >> * Next try MSI
> > > >> * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 1 INTR
> > > >> @@ -358,7 +363,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
> > > >>
> > > >> return 0;
> > > >> }
> > > >> -
> > > >> +try_intx:
> > > >> /*
> > > >> * Next try INTx
> > > >> * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 3 INTRs
> > > >> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fni=
c_main.c
> > > >> index 870b265be41a..4bdd55958f59 100644
> > > >> --- a/drivers/scsi/fnic/fnic_main.c
> > > >> +++ b/drivers/scsi/fnic/fnic_main.c
> > > >> @@ -97,6 +97,10 @@ module_param(pc_rscn_handling_feature_flag, uin=
t, 0644);
> > > >> MODULE_PARM_DESC(pc_rscn_handling_feature_flag,
> > > >> "PCRSCN handling (0 for none. 1 to handle PCRSCN (default))");
> > > >>
> > > >> +static unsigned int fnic_intr_mode =3D VNIC_DEV_INTR_MODE_MSIX;
> > > >> +module_param(fnic_intr_mode, uint, S_IRUGO | S_IWUSR);
> > > >> +MODULE_PARM_DESC(fnic_intr_mode, "Interrupt mode, 1 =3D INTx, 2 =
=3D MSI, 3 =3D MSIx (default: 3)");
> > > >
> > > > Based on fnic team's review: there is a way to choose the interrupt=
 mode using the UCS management platform.
> > > > We do not want to expose this as a module parameter.
> > > >
> > > Yeah, I know. It was primarily used during testing to easily change
> > > between the various modes.
> > > I can drop it for the next round.
> >
> > Thanks Hannes. Sounds good.
> >
> > > >> struct workqueue_struct *reset_fnic_work_queue;
> > > >> struct workqueue_struct *fnic_fip_queue;
> > > >>
> > > >> @@ -869,7 +873,11 @@ static int fnic_probe(struct pci_dev *pdev, c=
onst struct pci_device_id *ent)
> > > >>
> > > >> fnic_get_res_counts(fnic);
> > > >>
> > > >> -     err =3D fnic_set_intr_mode(fnic);
> > > >> +     /* Override interrupt selection during kdump */
> > > >> +     if (reset_devices)
> > > >> +             fnic_intr_mode =3D VNIC_DEV_INTR_MODE_INTX;
> > > >> +
> > > >> +     err =3D fnic_set_intr_mode(fnic, fnic_intr_mode);
> > > >> if (err) {
> > > >> dev_err(&fnic->pdev->dev, "Failed to set intr mode, "
> > > >> "aborting.\n");
> > > >> --
> > > >> 2.43.0
> > > >>
> > > >>
> > > >
> > > > Thanks for these changes, Hannes.
> > > > For the other changes in this patch, I will need to test and get ba=
ck to you.
> > > >
> > >
> > > Thanks.
> > > The 'reset_devices' thing is primarily there for kdump; might be an i=
dea
> > > to make is explicit by using 'is_kdump_kernel()' directly.
> >
> > Yes Hannes. That would be better. Thanks.
> >
> > > Cheers,
> > >
> > > Hannes
> > >
> > > --
> > > Dr. Hannes Reinecke                  Kernel Storage Architect
> > > hare@suse.de                                +49 911 74053 688
> > > SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg
> > > HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich
> > >
> >
> > I'm bringing up a setup to test. I'll wait for your next revision.
> >
> > My plan is to induce a kdump to test out these changes.
> > If you have any other tests in mind, please let me know.
> >
> > Thanks,
> > Karan
> >
>
> Hi Hannes,
>
> Please consider sending out a new revision of these changes.
> I'd like to test all the changes and add a tested-by tag to them.
>
> Thanks,
> Karan
>

Hi Karan:

My name is Lee Duncan, and I work with Hannes. He is otherwise occupied
right now, so I'll do my best to take it from here.

It seems like you wanted two changes to patch#4:
1. Remove the newly-added module parameter, and
2. Use "is_kdump_kernel()" to test for setting the interrupt mode to INTX

I have made those changes to patch#4, and internal testing shows that
kdump works.

I will resubmit the patch sequence after one more internal test. I apprecia=
te
your patience.

P.S, I believe the patches will end up getting to you through other channel=
s,
since a bug was filed, but if you'd like to test them and want a copy befor=
e
I repost the sequence, please contact me.
