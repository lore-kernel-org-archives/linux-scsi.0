Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD563FC1F
	for <linux-scsi@vger.kernel.org>; Sat,  9 Mar 2024 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710007545; cv=none; b=TJE081RvXyV/HsCYf1cpDvMzaIrKHi+zvhjlBfKZGpRsb6dHAby5VN0AOTp2ZpeT/Jlc+y6+GP8v1BVFT2CtBVA9khbgihZEG3wDAiZalfgLHM1F5h9wDw7iE4fqvbeRDPjNc6uRbimaUlLeZJEtklu9Vx1j5Pb/fvtSmQLIfl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710007545; c=relaxed/simple;
	bh=/PtZj1THudgmWXg55mQ9XJrnkglTEegrHaESQa9gBFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bp8ppEzm4FwU8SKNxsH6Iiy4EifZDS0we4CHhkumvMGDoK1l6DKLkxmpUVzNu6mVb2CGC8rNNCsY3IQJTYIgePIQO4RuysNIhJvrFT9PgjlQunqKDLcVRozYgMIvAQIGYN0i8geLX3cfKuB9c4O7h3rvNtYl2n/LS1u+rKJswSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=axulDVbW; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="axulDVbW"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56829f41f81so2645154a12.2
        for <linux-scsi@vger.kernel.org>; Sat, 09 Mar 2024 10:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710007540; x=1710612340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ITjBMAYZbjYo7OABjVqPiHGlJq6tqTY9J1maIuyk9g=;
        b=axulDVbW/tDc/D7TG7PSTPnl9Xui3OchqCkM73ZRnmnOv5IRc469alZ5v9ZFoTSpcp
         +FFzztrB39goA5QqtDDBHfHkTH2TcjRNGBdPVGii23PTpMsvx9PqQzwKtP9pnXoOOhnK
         3GU6tU+YdNk3ZXLE8sJiXrVSnRFgn+q9gHZRd3mcNsxoVebULScKXFPtJCNdIa/lCKh6
         QJMrFH09fbLogXOPT8xRYYF+P0MXeb3yejjTb0eY020BLskkRyiQ+twotwZvUrZ8o2x1
         lc6x834HnT2YwTsRPVgwzOmScPuVvqki9kCvtAZuv8Be7S5XsnCUGJmsapn9Cc1xcnnB
         tsxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710007540; x=1710612340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ITjBMAYZbjYo7OABjVqPiHGlJq6tqTY9J1maIuyk9g=;
        b=T9/FliTkwjpDc9PoFX8qRubPbclcI1IivVDhYnczp/GtBVVglZO2Hi9YV2AbhutzsZ
         x3yqEAoq3c2rBxCJl2JdEI7ptAjwgOCoUIAZTSfe4gVnsyoWt35kmrdOmn8kt4qDjTdh
         s6C0NORd2er+p7wwei7W1IOUrafp3G71kdWM76BbK2o2baMDR5OHKyXD4OjaXGtFkPjJ
         5v8MQpnxAclAydd5Tk9J9S8YAEfYdkETc2QwU0eepEYw0L49iPsCgxnkY+KGE1h+jyEt
         z6AJwYajHAxLrCvoAU2XqfsyvqWdQznOW3xYM5T+C0J7Ko+IsaRc4nezereGNnLQhLJ6
         yItg==
X-Gm-Message-State: AOJu0YxUtLWOm1XZNL5pbUlRc5ewWWf/1jZnyWQlWPYXmjmquRLwPSHo
	m90xc+JBmf0FeHcRyOYn/Xy7m/EIdQBYO0EfkHAhG+pi6X1Ep8DyKfPCgeZbHLRoCw5DF5qeV4Q
	po0aMgoCBZIGztsLBZsxV2CivjHv5i60TgRpIBg==
X-Google-Smtp-Source: AGHT+IHvRfRvVdOpSqga2VG+TMQSk8gbq3W0T+xahiDiFkVNTHojG2kqWZT3iOcIpvoLdLnWdwXVoH7BCpXTdklDjPY=
X-Received: by 2002:a50:8d51:0:b0:567:b54f:86b3 with SMTP id
 t17-20020a508d51000000b00567b54f86b3mr1426814edt.20.1710007540217; Sat, 09
 Mar 2024 10:05:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1701540918.git.lduncan@suse.com> <437f863520874ee386b6882ef749bf8d988839ca.1701540918.git.lduncan@suse.com>
In-Reply-To: <437f863520874ee386b6882ef749bf8d988839ca.1701540918.git.lduncan@suse.com>
From: Lee Duncan <lduncan@suse.com>
Date: Sat, 9 Mar 2024 10:05:29 -0800
Message-ID: <CAPj3X_UKdC_sXG=qm5w=BeufDC0p_88xF2nvkBAB0SXzJfo3xQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: target: iscsi: don't warn of R/W when no data
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dbond@suse.com, 
	hare@suse.de, cleech@redhat.com, michael.christie@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I didn't see any objections to this patch.

Are there any issues?

On Sat, Dec 2, 2023 at 10:45=E2=80=AFAM lduncan@suse.com <lduncan@suse.com>=
 wrote:
>
> From: Lee Duncan <lduncan@suse.com>
>
> The LIO target code has a warning about setting the
> read and/or write header bits with a PDU that has zero
> transfer length, even though the code mentions that the
> SPEC (RFC 3720) allows this, and that some initiators
> set these bits. But in practice such initiators end up
> flooding the logs with thousands of warning messages for
> IO that is allowed.
>
> So change this to a debug message, and clean up the wording
> just a little bit while at it.
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> Reviewed-by: David Bond <dbond@suse.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index f246e5015868..c82dc2cd08b3 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1039,9 +1039,10 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn=
, struct iscsit_cmd *cmd,
>                 hdr->flags &=3D ~ISCSI_FLAG_CMD_READ;
>                 hdr->flags &=3D ~ISCSI_FLAG_CMD_WRITE;
>
> -               pr_warn("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
> +               pr_debug("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
>                         " set when Expected Data Transfer Length is 0 for=
"
> -                       " CDB: 0x%02x, Fixing up flags\n", hdr->cdb[0]);
> +                       " CDB: 0x%02x, cleared READ/WRITE flag(s)\n",
> +                       hdr->cdb[0]);
>         }
>
>         if (!(hdr->flags & ISCSI_FLAG_CMD_READ) &&
> --
> 2.43.0
>
