Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CB33CFF6F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 13:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563770; cv=none; b=qT1JaJrdVRSfnesJkL+P9HWYme27ocA2/OReStV2pUP17hUN7RtO0kiAPApLbncbjsT63Xy0iK6I+EVJrbUtLn2VssQtw63qLd/9rVcEPbSAtYcYoZSyfmsIKPPYEUtnHhNXapd7yP6k55nl2kFq3wd3ZsDAP+SKyB4gFcW5wDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563770; c=relaxed/simple;
	bh=WxcJFrrMkqgbDJwpFWRc+yp00Lh1+7PAVbaItNhUk5E=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DIv3+UiH2A+xXncfMAgppFwI4k7iUxlC640QAeP5MkEo71ToROdCE7QEOjtsYMwA0sbEME2fXQH8rN4mmoylEZ3sVLV07h4M5Gb5F0vOmmWFokqPnpwWVKf2d/wIObv+oo3m78lvPweKmYsEeENsriFwofQ8E0nPaFldGPwwjn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IngYKC8/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=b08scG5Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IngYKC8/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="b08scG5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789563767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUjiy8zNM9FoebjQbRfwucGbuQZaAzuN8XmIQ59lcLI=;
	b=IngYKC8/1C1gImwr3S52Yndn2kUPnXpuKTSqiLHYgu8thw1cFkklwXofS/cd+kjMu7ApEQ
	egSDFzOWSjNnLFEHG7N0N53xlwbEufVnIz2YfBPJloS9tN12AIZ9h8Le9lLlVN3Bg2Boif
	H/0UFMvoLqCEOa3d3FsUpWPtYtMKMnk=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-1GTOjxs_N1KQYl0dVsrjfQ-1; Wed, 16 Sep 2026 09:02:46 -0400
X-MC-Unique: 1GTOjxs_N1KQYl0dVsrjfQ-1
X-Mimecast-MFC-AGG-ID: 1GTOjxs_N1KQYl0dVsrjfQ_1789563766
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-892af0d1bcbso5955757b3.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 06:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789563766; x=1790168566; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:to:from:subject:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oUjiy8zNM9FoebjQbRfwucGbuQZaAzuN8XmIQ59lcLI=;
        b=b08scG5QL1QHgF/mh6fcUN6iVWc76nN+vWEyRy9UTDATJ0lY1hFpthDt8PUkXdcGE0
         7xDm5KUVUHZkKzoP9c+5kpK+gOUwEWQ9c/sfWIGcWDC41hyJHeLO0Mr3EHweNLZaBO5Z
         Fd5NoGdzBMnz368M5vFeiI4JVx1q3Fc7hti0UftSKyBxKRDaTxFqr8NJUvFUTagYcal1
         l5W8oPUzfAFhIrXc76gK0X7cWuKtBysXVI+W0BJ59ZUBmJh6VBu7TVNQ52m+kngKXrsh
         /6MMS3F7caWoleeVnoMAjNEW0iZMq0xIlulv7TLENsIecu0eXyksSjn8eRyV5DTVx9ep
         2eOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789563766; x=1790168566;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oUjiy8zNM9FoebjQbRfwucGbuQZaAzuN8XmIQ59lcLI=;
        b=hFRDOqeHHIDSbbVF2BBykT++1q7wk36QBxkD8mOOyIegFtKn8539Lk1bQ/97mHiGoA
         M8NcuruObq364bf9Xs8Z+fXesxXhFZug5C/1rT9SFdM9fY1bBhyMmreaJsSszotxQpsF
         4uJG3se7v4fL/z/0UTlK5RASU44FPRmVFTeK6pEbuA37h5GNPX2Ustfl9fhnrIKLeVHf
         TcwP/kIy4P8dnaPcVroY1HldIJe25Aw4+e/5J9btlnRE6RSoE+TMBhTye2llrMHq97/Q
         5n4mERIau/Vc3S3N+5zYxtu9s2JxpA3XkRGDHMqglpSIZkS84fgr9/XwB+o4fq+irgyW
         3+MA==
X-Forwarded-Encrypted: i=1; AKwUvBxqLQXvZZvJJNr9AxC4dKPBIWY0Z+GnCrHSZk4EY1AZk6bp3E6BhziiBz+T0x+nu+s9VQMZcOhdNeit@vger.kernel.org
X-Gm-Message-State: AFuF++lZcbOwecqebhvzjXma1daMd42WtpjGFaqIsk80kI29YODXVh7Z
	xAa1PODgmRXxkqQ6UE1YxxdICXAp8mEQcJE4BYDGEctA5CZVrzz0JlLcU//RakTTCYyebXyu/vd
	oq3jphlsyCtbkAY+Wycb4UTBGv+FJp924So4WSATjMig7xOuI8m/wZVMIiUYyjJL5cJHJ6Jw=
X-Gm-Gg: AYBFou2LHaS4jFMm2KTZwgnNNWox/R8N8ifzz2+Xh+ezOrWicso0sxWtLdcYl6xcE2t
	gFtdwpNl/aOJavQSV24v6mTM4fFY/YOutQkxCW+HAI3x6Bh6KcWDdNNIyLxo51jjYAMizDtVuq+
	bTxshNVqbLha6R1AxrmwvSArizJTNyhQFNRfGjv1Ujpb9yJHscPjPJiPzwxPu+hRFxbWjz9TyoG
	lrFtYgZzrqeZcYs4qsuWsT3Ecl1UD5uDRSlbRxGTpoghjyuVsgUfBx3aUd5u1bZQm6lgJWHsJsv
	1XDaCU8xPeqwgbWHE6KftyHIUC96aUvOpXYF4PeHVjM0TmSyBfn+Oe68VImr0bqkcv2TgwDrrGT
	GZSxlWHZHvsUdwRRF+mPxcesCenrAvRScY4Bk
X-Received: by 2002:a05:690c:dc9:b0:88f:8384:d446 with SMTP id 00721157ae682-8922545e6b4mr7135267b3.29.1789563765650;
        Wed, 16 Sep 2026 06:02:45 -0700 (PDT)
X-Received: by 2002:a05:690c:dc9:b0:88f:8384:d446 with SMTP id 00721157ae682-8922545e6b4mr7134557b3.29.1789563765029;
        Wed, 16 Sep 2026 06:02:45 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53261fd7e5bsm21368071cf.7.2026.09.16.06.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 06:02:43 -0700 (PDT)
Message-ID: <46720470ca01b0394afbfc1e5721555accdc8e72.camel@redhat.com>
Subject: Re: [PATCH] scsi: devinfo: add BLIST_SKIP_IO_HINTS for EMC Symmetrix
From: Laurence Oberman <loberman@redhat.com>
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Date: Wed, 16 Sep 2026 09:02:42 -0400
In-Reply-To: <20260915173800.39117-1-emilne@redhat.com>
References: <20260915173800.39117-1-emilne@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-15 at 13:38 -0400, Ewan D. Milne wrote:
> EMC Symmetrix returns an error on MODE SENSE for page 0Ah subpage 05h
> because it does not implement the SBC-5 I/O hints.=C2=A0 These commands
> began to be sent as a result of commit 4f53138fffc2 ("scsi: sd:
> Translate
> data lifetime information").=C2=A0 Add BLIST_SKIP_IO_HINTS to avoid
> sending
> these commands because in large configurations the failed commands
> are
> displacing other useful information in internal error logs.
>=20
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
> =C2=A0drivers/scsi/scsi_devinfo.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_devinfo.c
> b/drivers/scsi/scsi_devinfo.c
> index 2bccadf4f22f..cfc259fd0141 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -161,7 +161,7 @@ static struct {
> =C2=A0	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* EMC
> CLARiiON, no storage on LUN 0 */
> =C2=A0	{"EMC",=C2=A0 "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> =C2=A0	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN
> |
> -	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF},
> +	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF | BLIST_SKIP_IO_HINTS},
> =C2=A0	{"EMULEX", "MD21/S2=C2=A0=C2=A0=C2=A0=C2=A0 ESDI", NULL, BLIST_SIN=
GLELUN},
> =C2=A0	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
> =C2=A0	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},

Looks good
Reviewed-by: Laurence Oberman <loberman@redhat.com>

