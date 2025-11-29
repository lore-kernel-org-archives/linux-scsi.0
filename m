Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248C0883F
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 04:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764390256; cv=none; b=pw0DkwNZfMHyLvj3spJg7npmflay2TSkDnPocORVMvZ3xNfVMqMFC2GwyEnOl75z+t/b7o6FooUYZv2QmBptBbA9ERTX2vzrcx/J3TxLG3wPHdBlF6IpY89jgA9/qpNbOkfdC1jsf87cz8gxhzlsnZDhqn/mZROXGcUGkY7Vg5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764390256; c=relaxed/simple;
	bh=nn6jsh1bpVDmqtk/NIx+mMCz1c5oxMsCpAGmjg9X0rE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KjwBJUf9IOV/N7O89Eu8EtSdV/eZX98WXrfwjO7/cT9N7fMwmvSAiJsc8eUYVYZgdnTYjjB11OVNmkzKsvaZrjEQDDe6CBtPbbVKFASnEz0XIQekEcRhfFIN1gD809umOpRGIA2Xje2lS/0l+EPAz9POe7eLQWR/xfUtHXI10tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-78a835353e4so25730397b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 20:24:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764390254; x=1764995054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nn6jsh1bpVDmqtk/NIx+mMCz1c5oxMsCpAGmjg9X0rE=;
        b=oyiixmiFztO++Qv+hh1pdhUJm3jMJ7RfEXSnUW76Dbxdb94M2rSehGaeYcHIEtx0A7
         5GnXcdihVBAw58nzB7+ihe+bU7VylLqlhT2Cbg6EulB2h7GMNlAwhPy7scjhuz74JBS7
         rW3m01/SZluN6+SOOMne1V61ogG7ctO0pQZwimh+HeWAiGk6GkBH/PZdbvuvrX0FblDq
         0Zd2N4CO4MDqk8wCgtVNTo4r5OXbrAgdPyA4PxvKWcn83ZIfJ31zhnT1iTckCrJKwI71
         EzqLFldFx4oKj/ssJJsEzTZhjkNMt49PiuytkQtXXVAw3xUvAvbNJpAODMWbKnRUL63M
         Nm8w==
X-Forwarded-Encrypted: i=1; AJvYcCUBK3z0vd7eXVsqcwTBdbOrtNFgTjyqk6niadRPl+y4LScrIeKKfAbLM6AsCIYg0LCTW0DjwlwjU0fg@vger.kernel.org
X-Gm-Message-State: AOJu0YxBrtreWbBvzdWKECiXYnp9J/SWoSJQSkFa3/8PiAj7gpulADLY
	NHF0r+1l/Wl5LsuD3qhqrysM6RAlZgWYx2AJ9Uzd3iEWUozs+/gEwT5Zdthhag==
X-Gm-Gg: ASbGncsfYcnq/iSRSyA7deWOZH8JcJQRHzaAnyNswspmXdZb2h9rszFv/9/taVbAgqB
	MhErCrE+lve5hfhhygbsGnNewVv7ZiMvKMTloEVlCi6NRdjVAvC0PYwf6Fw7wPRu1Vq+NNdGvLV
	u6V+Eg047FLs0X/x3OyMmh2svB83rbvV4XgYldJq4pjXmVuddYQ9PTeYg72lHDAyHqt1i9MqFDi
	KFYIe4wVAKXO8AV9ndfpvFTuu+eOeaydE/KGxRkTxdXp51+AQhGosmE6GnXTM0iQR/TD5h7PozA
	2aKA4d4VrVTtppoOk0rDbVs8qY0BZ8gmB5GJ/+sq94yrBE5KLryfLDq48S8+Ty5tKLXAjxj4reu
	pA6zoGWDFWUAaB1TcEeF1BU8T9rRytwcIzjuREWBAbJ/NmyK+++I9/BjUSx2AqP7kQemq40vOo4
	2xYPn8Ljy+P1Q87PLrY60SK1BaqdQ46UaWrhRZpZwwYraLADHgg+Ir
X-Google-Smtp-Source: AGHT+IEc6vhoAtjrSOsCfNZUQ3akeHtCVPdDemy0MUcQzenAV9O7HFGH+gHbYuGf+S/KShHUuCWMDQ==
X-Received: by 2002:a05:690c:4989:b0:788:1cde:cac0 with SMTP id 00721157ae682-78a8b479b3emr247320907b3.1.1764390253710;
        Fri, 28 Nov 2025 20:24:13 -0800 (PST)
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com. [74.125.224.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad0d4179csm21957567b3.11.2025.11.28.20.24.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 20:24:13 -0800 (PST)
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-63fc6115d65so1999442d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 20:24:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXr5JGp+vemGsDMfMbrlVJLB44BZh0bWZU1MAbwM60raOybj8WcPbejrUql/KOdbVjjDSsINwLfLUQ/@vger.kernel.org
X-Received: by 2002:a05:690c:61c3:b0:78a:8251:8476 with SMTP id
 00721157ae682-78a8b4953f2mr269176467b3.24.1764390253181; Fri, 28 Nov 2025
 20:24:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEQ9gE=Yo71Aji02a5uGdv7uZ+fJcCa1TKAEZskdM_-VZedTqQ@mail.gmail.com>
 <cb777f15-1017-4183-91a8-b7e968d0df9c@acm.org>
In-Reply-To: <cb777f15-1017-4183-91a8-b7e968d0df9c@acm.org>
From: Roger Shimizu <rosh@debian.org>
Date: Fri, 28 Nov 2025 20:24:02 -0800
X-Gmail-Original-Message-ID: <CAEQ9gEnYYBEHMFczvcx4mggOM5ydjsQeMRaBd3gQnjisJtXE6A@mail.gmail.com>
X-Gm-Features: AWmQ_bl0nAXwowbEB-c9sP8HCaOH34_OsmMyuH8qM-e1WZaJrV9P4OX5byzVG1s
Message-ID: <CAEQ9gEnYYBEHMFczvcx4mggOM5ydjsQeMRaBd3gQnjisJtXE6A@mail.gmail.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved request
To: Bart Van Assche <bvanassche@acm.org>
Cc: mani@kernel.org, James.Bottomley@hansenpartnership.com, 
	adrian.hunter@intel.com, avri.altman@sandisk.com, beanhuo@micron.com, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, peter.wang@mediatek.com, quic_nguyenb@quicinc.com, 
	Hongyang Zhao <hongyang.zhao@thundersoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 6:44=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 11/28/25 12:12 AM, Roger Shimizu wrote:
> > While testing Rubik Pi 3 [2], I found the above UFS issue, too.
> > for next-20251121, I used the revert cmd below to workaround:
> > $ git revert 7ff1cca -m 1
> >
> > for next-20251128, I used cmd below, and there's a conflict to resolve.
> > $ git revert f10ce81 -m 1
>
> Does your kernel tree include this patch:
> https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvanassche@ac=
m.org/?

Yes, both "next-20251121" and "next-20251128" already included the
patch mentioned.
And "next-20251128" is the latest from AFAIK.

> If not, please try a more recent for-next
> kernel. If your kernel tree includes that patch, please share the
> kernel log.

You can find the serial log here: https://people.debian.org/~rosh/next-2025=
1128/
* serial_6.18.0-rc7-next-20251128.txt: boot stuck.
* serial_6.18.0-rc7-next-20251128_revert-c1ec7dc.txt: reverted
[c1ec7dc], so boot OK.

Thank you!
-Roger

>
> Thanks,
>
> Bart.
