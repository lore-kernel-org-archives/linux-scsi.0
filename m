Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9D3EBF37
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772814189; cv=pass; b=YaoJo2mp2pa5eHx6rN9PerTZe4DOMmvyhVNde38oi5L7sni1bGRDdTZ2uYsuxncrp9Vrrgkf5WQaFwQT8kplRM9VMYrFYboRcr1wzi9dYA7VAud1KMIg4igUogokKZLIXuFBL08jYP4HpB4Kka9TBNgWo6Y6VUAehsByQTLVvyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772814189; c=relaxed/simple;
	bh=IbZsvgrBS6qG9+ONh351wVbKqsdzZem/iGnupFSfxjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LOlV1h71lGhvGsyhooVksvk3Q3SjzXiLew+ArZwULaI3klnTI5e0lQaU3HW9NjYk8J5Ww12xVXBpnK0yuZN1JhPwlTLtRZ/keFcb4Jg0pGdV3WSE3Kh09NjBHEYoZ7QhPSBPt3SOyRQaXo+cynwXOSmwfOHdK6yXSRgQxvsgT9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zMoC2u9C; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zMoC2u9C"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5069a785ed2so465521cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 08:23:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772814187; cv=none;
        d=google.com; s=arc-20240605;
        b=QJYodNr7/kRUbnt0OhpLJpB6f4FDj8UznmxKpUm0jMW91pgpfYg+HbQqaKrMtlYMG/
         kw1JfduEAbjPPcpqdK2S4M/v82LNrG+OPNyo6vXXuoTgXktuMRIpGk/7DH0kwYKPlmGc
         pYKovHTu8sV0jQSlXcT4CGkCYLjlce79yGJFYw+izv+osOfopJ/JyR13sYuPUEQcEWOc
         W2a2ed9deZaWo2CqPVjQfdHZjF8n2SbVHfPCCSiVbdKawBuPzuDgTlw8nMhmHWO1uU9v
         U28nEhFCD34BQZ1/nAfaoB5rZJq/N+bzzbHMG8/ejmCm86Djl2E3b3r5s/9rHNemDif8
         OhCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2DZ/CDFVfoeP8qynByzEZbDrTtlY+jSYJfWbSadwVH8=;
        fh=zLXkBjMJYwE60GUIwVszea9gBAsa/A1eM8se/NCKrCc=;
        b=B5igrO5iDFRSGcyHY6IaFxeztusV66KWq2MwkMchh2Sihj6SGtsPd91j38CoETQYmU
         WH2rqC1etE1oiRauXJkT1GvcGTq7n+PNSdzzviZb5u0x5Euiab0sm8SFUEzidfeJ08Zg
         EhXFvJ5pVlRfHtwVZ60/ck0sFJcWr13Up1st/3gMVsr4P454nSkNBgkw7mrSyyFG14aC
         C0YZuYwF6AaaOd64tYfxv6u//NUILCbLxWje2O6sGfl1XKQF8FJs5mvmA7ek16qM9d29
         cQZUimiIrnaQfnLUevx+hC5E/cMgER4iMnD2M2jyTMfiQ6F5hcDHMd353hxwyzGQSs5a
         sYJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772814187; x=1773418987; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DZ/CDFVfoeP8qynByzEZbDrTtlY+jSYJfWbSadwVH8=;
        b=zMoC2u9CTCUEA/YD12k5F4P7X8QsDxh4MJK8LD2cqPUqqGJ7Dees1ESCxifahCsUjS
         rz+MoyaRUmfZ+4Ybc44SXyUqnISGxU1d5lbJwAU3B1PSV22wsY8qfLECJ2JJW/QAPDSU
         CWQc4zfActQ2KiIymgJ5Za0RCxzCMPdVxaL+pEc1XtZYsL7BxEGneFpzmH6du2dqyOHc
         I0WZXNSeR+X4SqBzGB8pGrQoBZTXwdnAMZb/XB3/BqOS08C4PhCSB936tQMIAA53TIDw
         +TBiYCFA2wFXdCEIB9dEyMMuFt0HYrfaGkIaSLoLvH72kOC3h6AWzAcXQipYdX7b/5D9
         J/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772814187; x=1773418987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2DZ/CDFVfoeP8qynByzEZbDrTtlY+jSYJfWbSadwVH8=;
        b=WCMJB9GR46dGK7zR0hIe8WlnvjUkhEH7q5x3jExuRgtIKvKNlZ4iAS+iqRMYAt1sw9
         fHDIq1rasNfTdVlYFzrUQ84Xy/aBJvKCdKJPFbk/53ydZEzw8qbqrr7i9wqvxq1JBKa4
         rP2OVwa+COvx1s8jTibKzs6zGDGpIKv/R6HrlfYfz5zuAk3pkDNktUMqccCFnFn8VwY8
         OBWYbSAuvED9Qm60S6SkzmyN9gegbGLzbkWnXItenDlYldxUGCxfHiozvWu3j+0vZmk0
         1KBWnTIsHgKPYKVQckJ0JhM6kNHvEhuRyX5gjn67M1OKi9WS9a55HFKDMoO1SKmlIUrK
         UKuA==
X-Forwarded-Encrypted: i=1; AJvYcCUax8F6lwdGfYPDPkSaJdahLZQ5J0R5HTTORsYi5DqVfGfYoWvwZOENvYFuaG2SeZPWPSKmU4pIVyVN@vger.kernel.org
X-Gm-Message-State: AOJu0YyADvb8n5a+JpHDamgRQT/3Zmx044YCZ412ZyK22KlsUB6Ih9Wt
	6JXpNULa4U6FvdHE++YmO5qGHyKR3UOpUXVtcjVZ4w6hHwPOLPfIo8BiXXfE5ALnIuKtF7GjDYN
	k7U3OUDbY2b+QRkqjXcZ3w/G1IYCFbLNi16emMRK3
X-Gm-Gg: ATEYQzwuYv37XiGvvViqBUWLLnupHDho8P4DV9Ai4FTGcyBrJajl8mqVqeAWVUcYdVX
	ZAMRzCHStbX8Ui3ADMrN2on6NWTIQsdAgJXkmbUvKN86GQ8nwlaNn6ELLF7yxEPmMLwQk2Wp8tX
	tJnJqD1DHj0phqtqdflACAicrzSyltvbjgiwiH4lu4mSqr/0jwRWmrtUnj4D+EcG25klhy+VGel
	HYOyS54dglkpxiE7etySXqAEzHcCtPsSymB5pRMiRadEOrWi7IhBYb8SGOsIJmUdYabl4wFP+uB
	Lybtz214B+8ZjisLb7m84T+LUqS0Mzz7Mk2G/UGIRQ==
X-Received: by 2002:a05:622a:91:b0:501:3e46:6bd5 with SMTP id
 d75a77b69052e-508f3a8dbd1mr4339751cf.19.1772814186599; Fri, 06 Mar 2026
 08:23:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302180117.2797184-1-vamshigajjela@google.com>
 <1fa500fdfbfff7d43bea1839ce1992fb4283c5eb.camel@mediatek.com>
 <2cdc620b-b521-4058-a802-87591aa4c253@acm.org> <151ef927de40cd3e663b816194761a029c07ab23.camel@mediatek.com>
 <c18581fb-d44a-4aff-973c-27cdcc9683fa@acm.org> <8b1faf1871c067c28e25f1248d0f358facde38b7.camel@mediatek.com>
In-Reply-To: <8b1faf1871c067c28e25f1248d0f358facde38b7.camel@mediatek.com>
From: VAMSHI GAJJELA <vamshigajjela@google.com>
Date: Fri, 6 Mar 2026 21:52:54 +0530
X-Gm-Features: AaiRm50PUgJhFxKijtOCoFghbJDJHsYjfFHSQWZkFqmlT3pK29eDMbJhD7Y1Sc0
Message-ID: <CAMTSyjo1LzUwqW8wnoJka=V_whC3-2VBtUQko6P-BOtoeNhjXg@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Handle MCQ IAG events
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, 
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, 
	"arthur.simchaev@sandisk.com" <arthur.simchaev@sandisk.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 or

On Fri, Mar 6, 2026 at 9:19=E2=80=AFAM Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=
=8B) <peter.wang@mediatek.com> wrote:
>
> On Thu, 2026-03-05 at 06:07 -0600, Bart Van Assche wrote
> >
> > Hi Peter,
> >
> > It is not clear to me why the above code is considered confusing?
> >
> > UFS controllers are the only storage controllers I know of
> > that generate different interrupts depending on whether or not
> > interrupt
> > aggregation is enabled. All other storage controllers I know of use
> > the
> > same completion interrupt whether or not interrupt aggregation is
> > enabled.
> >
> > To me the above code means that whether or not interrupt aggregation
> > is
> > enabled, ufshcd_handle_mcq_cq_events() is called to process the
> > pending
> > completions.
> >
> > Thanks,
> >
> > Bart.
>
> Hi Bart,
>
> Sorry, I may not have explained it clearly enough. Normally,
> the logic is to handle A when receiving A event, and handle B
> when receiving B event. But now, the code seems to be hnadle A
> when receiving B event.
> If not familiar with this hardware logic, it=E2=80=99s easy to
> misunderstand.
>
> Thanks
> Peter

Hi Peter and Bart, thanks for the feedback and discussion

Bart: I agree that renaming the boolean flag to reset_iag improves clarity,
and I will address this in the next version of the patch

Peter:  I understand your concern about the readability when calling
ufshcd_handle_mcq_cq_events for both the events. As said, either
MCQ_CQ_EVENT_STATUS or MCQ_IAG_EVENT_STATUS, we are
essentially handling Completion Queue events. The only extra step in
the IAG path is clearing the counters/timers.

Sticking to ufshcd_handle_mcq_cq_events and adding the agreed-upon
descriptive argument reset_iag should help the readability IMO.

Do you think a more detailed comments right before those two function
calls would be beneficial?

Regards,
Vamshi G.
