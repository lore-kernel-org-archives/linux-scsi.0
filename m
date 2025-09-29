Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DC51E5711
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 17:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759167957; cv=none; b=O7ngSekfct0KmRoO1o+wgGMnsQHIH167iBr7X/MmNWCEvPPT+vcUvEt+EyeHNuJHIv3o7MzOFvKya31eC42ZCilVNQ9iRFegb8BKlQlYl6mp1zn0E0zvHOIxoAoQ5TZ26fmDIpCQtY6VBJFvMivYWl8yhJ5LqWx+qHSKP119ZOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759167957; c=relaxed/simple;
	bh=cvt2KaSAbICkzR8yA8oqgyghUNUOih7dozk9zGui538=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LH5L7qV6q2+qZ9B1A/B+nCmuPYb0p7z1apvGHO4IMxiWasJlvZ0DCAnYSTh0EqCHOXO3D/K0pruh0EtdC3gEheQ25OtkGd2G+klVYHFIjG5iIFhA/PrzY4Ak3ELkI7gdOPsA3ekj3rKQOpOvQkArNHXPGI1CotKDth+1xzz3uDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fPJ87RdG; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fPJ87RdG"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6353ff1a78dso3560817d50.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 10:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759167955; x=1759772755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rr8asw5w2LFtUosgimvTpY49NuIARrcjW6GWqnOLnQ=;
        b=fPJ87RdGWQT/+llTnIxJH35xU1iG50shaaZBq6giGWUhC9iNElcAt64SuudOtRPzdQ
         7ct/HW51p+AXQ78rBY6uDS8t6rE5v1IbH1e6kpxCl9tyuzCDyc6wYtOdUe9OZl2YfRYZ
         vVZlP1yJPv3SZL3drYttw+pZI3PrIXWmcJC3jLKSAPNxK5V9LVwwZq+DdSGi19Ly2cZi
         nJ2MfTJhqbP7Y0aQ/8Vnd1YPXhybn+TY1yC726rNMVKZcj+H3RrtLe+yvx9M0kLNcJW/
         wWpjKJRlwEPw0IW7B7njMGvBBQsFP+3ZL6vGfJSS7F1w7Ta7GIPz4cCN0qUcqjSEzFii
         rD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759167955; x=1759772755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rr8asw5w2LFtUosgimvTpY49NuIARrcjW6GWqnOLnQ=;
        b=kyDfCLr55x1b2neJt9cy6SQ8dUhDH1D/cwkkMrd1NKpUFr39fMPluJfvzlUzeqHDnS
         XDWoc087Ub14Ld2SbssKazIUs1n530jL7qDqxQZNUpdEUnwW5WsrPf4wF+XrdoXYh41/
         wSl7V6xFgTrsjXhJAY1ohxvxvUjECBW8yqEoyUnQDeaHGFeVwItgRWbfq7UKVdV7OiJd
         kISSV07fpdFePfmXY6k277wxm1xa73kyISNui+XZF/xCwkg96S3HD4HZzRWVhWaReF6K
         RIw4o+1hfy09B5e6vc+YEttqWsFr/zB/bfoDYLaWBZVafhIXQAgdvWP7G6L+l4q3qQHP
         dWgA==
X-Forwarded-Encrypted: i=1; AJvYcCUzSGgTJRoprxu1UV795L+Jd6wOfhU3rBBjoAVO17FuVNa9a+JwSUDC4yie1r44laQ7RiMQgpCZShMe@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5MLefjIteeukOx7+g9HU6wFnq0fuI9l5y3unEsfBH9KznFw5R
	sTUNe4MIUJrCEfZwpN3rSrJXuvJG5r2VeRKM/dyAmcLoCs8UBpRkB6rSWNwnZ/GQIwoJx3wf3Rw
	GajHVaD9x/mfqlNMzgK9HvDhl+9Wk4QU=
X-Gm-Gg: ASbGncsmoKOXmiPsVk/AxSnh21fFGdg03Nwitc3ZL+CSy2gLhtoaLBLp9nGYdwk5451
	9Go+rgNUdcpHcBB4GIy4JuXgh3ilRFSyOTXnmG6hsqBpXxbyBu4oGtI0ZWNOGiPVoqDh041mT0V
	QDLagnZxK5ALq6TEanMz3EEh2rh+EoR8CRkCA5T1rS1MbmiNwWWT6YSOIg2s4q7UfPCbGOEa8zX
	ZfnsM5VCE1dvGZ8/eY=
X-Google-Smtp-Source: AGHT+IGWN1U3ruetQeiQiZtCe48SxGVf5HYlg+D8N8D2z6yt7sbK2mz/SAzZzQHv+qRuaJ8dGFMSUcAUInTb49quAHc=
X-Received: by 2002:a05:690e:2508:b0:635:4ecd:75a4 with SMTP id
 956f58d0204a3-6361a8ad38amr14381272d50.50.1759167954977; Mon, 29 Sep 2025
 10:45:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926000200.837025-1-jmeneghi@redhat.com> <20250926000200.837025-8-jmeneghi@redhat.com>
In-Reply-To: <20250926000200.837025-8-jmeneghi@redhat.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 29 Sep 2025 10:45:40 -0700
X-Gm-Features: AS18NWDiG_e____J7dH1E1fhXzMsXsdLMiodTDWlX59WmDK7fVQpz_X3soSeuJk
Message-ID: <CABPRKS9SkaGZjC_vEy-YdgYELffGLvub7DTFGCYXFW68ObWqYg@mail.gmail.com>
Subject: Re: [PATCH v10 07/11] scsi: scsi_transport_fc: add fc_host_fpin_set_nvme_rport_marginal()
To: John Meneghini <jmeneghi@redhat.com>
Cc: hare@suse.de, kbusch@kernel.org, martin.petersen@oracle.com, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com, gustavoars@kernel.org, 
	hch@lst.de, Justin Tee <justin.tee@broadcom.com>, james.smart@broadcom.com, 
	kees@kernel.org, linux-hardening@vger.kernel.org, njavali@marvell.com, 
	sagi@grimberg.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

> +       u64 local_wwpn =3D fc_host_port_name(shost);
If CONFIG_NVME_FC is not enabled, then the u64 local_wwpn variables
aren=E2=80=99t used anywhere.

drivers/scsi/scsi_transport_fc.c: In function
=E2=80=98fc_host_fpin_set_nvme_rport_marginal=E2=80=99:
drivers/scsi/scsi_transport_fc.c:900:13: warning: unused variable
=E2=80=98local_wwpn=E2=80=99 [-Wunused-variable]
  900 |         u64 local_wwpn =3D fc_host_port_name(shost);
      |             ^~~~~~~~~~
drivers/scsi/scsi_transport_fc.c: In function =E2=80=98fc_rport_set_margina=
l_state=E2=80=99:
drivers/scsi/scsi_transport_fc.c:1309:13: warning: unused variable
=E2=80=98local_wwpn=E2=80=99 [-Wunused-variable]
 1309 |         u64 local_wwpn =3D fc_host_port_name(shost);
      |             ^~~~~~~~~~

Perhaps we need to ifdef the u64 local_wwpn declarations in both
fc_host_fpin_set_nvme_rport_marginal and fc_rport_set_marginal_state
routines too?

#if (IS_ENABLED(CONFIG_NVME_FC))
u64 local_wwpn =3D fc_host_port_name(shost);
#endif

Regards,
Justin
