Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438886E5EF
	for <linux-scsi@vger.kernel.org>; Tue,  9 Apr 2024 07:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712646740; cv=none; b=jmDPyNRyQfNwXOX3aLsSGm5sSKcXwcBEjvwvgsrFGOm7qnbnE3IaApTw72zbKXahfKw3lin6wL7q4E23VZSgGdByOjm3b3gh9HSHo6pPfxiJU1hgHOtzVJvEiNDz4vh/R/3jxUnaXJ1OBjPuu9Mj9k58uRjKFLYm5PS50G0uXjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712646740; c=relaxed/simple;
	bh=Ho8UuDKDn3dJomXIyDB+aaax60ogHDfzU1mNE6Decww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UN8JaAXYgl1uCTG7RY8g6CeJmrTxmZBjjQull5YEhlZ0ygrB2nxI9IWrmklOK7ZI5vXe08brMLQMcBD+3hRtqYErF10JrhVKF2gYV5mO6W25kBad0hM1YQDFN09Kf9bSk0w4SBPI80Ynu2DMZJndfUBNVazEiXSla+31rXophPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=n22DMnwC; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="n22DMnwC"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6151d79db7bso60414297b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Apr 2024 00:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1712646736; x=1713251536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zwdl6n9vid2pyIfyEa4g1TqkRuZa9yIoK4Qc9NMFsP8=;
        b=n22DMnwCs1PEEVheGAw8UAD5e/X8NWSNkhbpzfaBufCKbSyeiyEEPYikK07QihWM1v
         u9H3jZT5aEoN+8iRSRzd2djA4X3FZhWzydvznEWJ793n2H5WOqikfn6WcmrS595/9mFG
         4IUIWPzHYFshdIh8StBCiH7uALxa9ECI8cVipPCK3ixnzr7+NHMANuboj21WdOAnKNKf
         V1N8MCTBMd5yxeHN0VkuCB4bji8xl83/VmEAjUs1/R7LwGFIOJvzc7Lsr9vpG3K7oC5p
         EcovvdFGlaopmO1jQf9B/uXnhCHtbxRNBoMzqa0GVzdpqD1DX+hcgsONa3M7zVSxtYDL
         3LPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712646736; x=1713251536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zwdl6n9vid2pyIfyEa4g1TqkRuZa9yIoK4Qc9NMFsP8=;
        b=pABCpJ6wyEi1F5TFwKoz9zkPzWJOe9pR+ktThrOHws5yZBL4LuiaVyrJFt9rvtWsT6
         KdXFALddK3f/95CwYl+VHFagOxEWN6BwneIImfPOsqQU8q6M3AnFLE2UTDHfq4obDDFe
         SFFEgdHUD3LTn04Sm7LEMEC9+7U4i9N1L6hFgZ9Q3Aob8zhC4Ss6UywR+z20FG+F8woZ
         BFHGWzHPSNVbushqUi4VLzDmRqRwB1ohkNqjKU1DkckQ3oObZzd2WliDz5pohXd25B3F
         Y/pb4De0Yq5xh+csipLk/WySXU96VKpMVPosVKgvhSe/80Gsg7Y9VQnsHhRQeMbShZDg
         7n+A==
X-Forwarded-Encrypted: i=1; AJvYcCUfH5ZK4bez1rdfhDQH/YstHS9whvm0E0EpX+N+3ovUKb1LmoMSdE2n2NjgmkqNMAQW4s7jyNNn3NsLUcjkBS8Jowg4U0erOGAjbg==
X-Gm-Message-State: AOJu0YzX06euMSyPAj5U9fKAvV8KojNOi24PqvYAnegrUNkiMp3sfMXT
	6GdPSRuV6c4DpwG1jZrYgTI9wDWpAHnmil2M3QMN0lMhYHr/xx9idkrGpgTJ6iW5GMinjNqetHZ
	asW09gga81GurWvdfTUKKiiQDtpPwx2raMpMR1Q==
X-Google-Smtp-Source: AGHT+IFat9CYqWKiYnLWAs0EVd6FZ7PSZb9/eXaufs/Tvltb/meSM8Aog6IPhuwAY3wADjmm83qe3Ul9tXpVm7VB6CA=
X-Received: by 2002:a81:a18b:0:b0:615:378a:1130 with SMTP id
 y133-20020a81a18b000000b00615378a1130mr10371259ywg.17.1712646735554; Tue, 09
 Apr 2024 00:12:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240408100505.1732370-1-lei.chen@smartx.com> <e0179895-5d06-4c47-98f2-635175a05cf7@oracle.com>
 <CAKcXpBxp4ziNBTeNco9sxwE3TH2=GFJ4tGdapy8DGpnZjV_1qA@mail.gmail.com>
In-Reply-To: <CAKcXpBxp4ziNBTeNco9sxwE3TH2=GFJ4tGdapy8DGpnZjV_1qA@mail.gmail.com>
From: Lei Chen <lei.chen@smartx.com>
Date: Tue, 9 Apr 2024 15:12:03 +0800
Message-ID: <CAKcXpBxZWxVY4dmBQWOv9_oACY1u4NZLCrmpxeorQZeCtM2imw@mail.gmail.com>
Subject: Re: [PATCH RESEND] scsi: megaraid_sas: make module parameter
 scmd_timeout writable
To: John Garry <john.g.garry@oracle.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the non plain text format.

On Mon, Apr 8, 2024 at 8:30=E2=80=AFPM John Garry <john.g.garry@oracle.com>=
 wrote:
>
> On 08/04/2024 11:05, Lei Chen wrote:
> > When an scmd times out, block layer calls megasas_reset_timer to
> > make further decisions. scmd_timeout indicates when an scmd is really
> > timed-out.
>
> What does really timed-out mean?

scsi_times_out will call eh_timed_out (in megaraid driver, this
indicates megasas_reset_timer),
megasas_reset_timer determines whether a scmd is timed out. If not, it
will return
BLK_EH_RESET_TIMER to tell the block layer to reset the timer and do nothin=
g.
>
>
> > If we want to make this process more fast, we can decrease
> > this value. This patch allows users to change this value in run-time.
> >
> > Signed-off-by: Lei Chen <lei.chen@smartx.com>
> > ---
> >   drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
> > index 3d4f13da1ae8..2a165e5dc7a3 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -91,7 +91,7 @@ module_param(dual_qdepth_disable, int, 0444);
> >   MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual queue depth featu=
re. Default: 0");
> >
> >   static unsigned int scmd_timeout =3D MEGASAS_DEFAULT_CMD_TIMEOUT;
> > -module_param(scmd_timeout, int, 0444);
> > +module_param(scmd_timeout, int, 0644);
> >   MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), defaul=
t 90s. See megasas_reset_timer.");
> >
> >   int perf_mode =3D -1;
>
> I don't know why megaraid_sas has special handling here (and bypasses
> SCSI midlayer).
>
> If the host is overloaded and you get a time-out as a command simply
> could not be handled in time, can you alternatively try reducing the
> scsi device queue depth?


Yeah, scsi layer and drivers already have some methods to control the
queue depth. For megaraid driver,
it will throttle queue depth in megasas_reset_timer. But since scsi
disks on the same megaraid card share
 the queue depth,  that will impact other scsi disks.
In most cases, a scsi disk is more likely to be misworking than a RAID
card, which makes scmd wrong and retry.
We want to adjust scmd_timeout without reloading the driver to make
scmds against abnormal scsi disks completed faster.
