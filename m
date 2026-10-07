Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D3D1D89EF
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791392916; cv=none; b=oPGKX1tG7Zi2DsUJMzzrvpsmbwdTWK2I3sUSo6QszmTGUJiIvlMHjJlAAznfSqEuvzquxUkYNew68+uHBSBfaGjmwfzPFB4rfSd40encrYi3be9DT6lTjeE5jQB64fOdkpmSXam6NAmPM3V2CG9p/u5Ef2jPX/auFOBzcau7108=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791392916; c=relaxed/simple;
	bh=n5uXmCT40sJiRGfdIO5maw54st53pmyAMG20Pb14vx8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fim4VRuo9b5j/XfrPW5f3Vq9zdb3JWL6m40djhKclQLqFNIPEsQqFsugC2qdzF4xV2dk+2f3HorRLl4SosCBgfB6LZOf4ULhFiUeIrDzp+7X+/jlvZJjGW+00xZSBe1rdwUkpNVoNCbfieukbRRMYOL+Ly76ZtaIxa656gG3jPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RrpVvwhS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=H5l3Kr8+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RrpVvwhS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="H5l3Kr8+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791392914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/VEUCnzfsVjtvK9gQou76yPnW0VpuzqTXSNX5pVtmXU=;
	b=RrpVvwhS7ejGNE+C3sLi8pq1l68n7Z5AWIHj46X7TVpa0ZbP8t5SM10K+iRY1+8J99iRWJ
	tGDOjPQxLZckpgDyLeUWfz1qOAncbACFvtpls3j92uUEEltezLjgQBR8K9YPYKxLxZq7e9
	bmUwpKdLtSiUvyaM6DjAtAoE+VWgyNE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-vVQDBBJaOP6FYj7iYWOKMg-1; Wed, 07 Oct 2026 13:08:30 -0400
X-MC-Unique: vVQDBBJaOP6FYj7iYWOKMg-1
X-Mimecast-MFC-AGG-ID: vVQDBBJaOP6FYj7iYWOKMg_1791392910
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91786abb5abso74964256d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 10:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791392910; x=1791997710; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/VEUCnzfsVjtvK9gQou76yPnW0VpuzqTXSNX5pVtmXU=;
        b=H5l3Kr8+pYO19YPw6xAfQwBisN+DO9h3JumURdSZVnI3mYsMdO7HyoGsBU1Lie8IV2
         PElDkql8DNiv3w/tgP2BL5m1R6uCGii9Q7r2za14iPQLEBiqvyCj7I22oLCJRxZn6hiC
         e1nV/e3WJNEnGNsBazeb5tF5hjAjQwMfbk6HJlLioJk89pAU7IWFE/agalMaLoHIMmeP
         mxvjUUYVuAu7q0BYdFPjKPuaHTC+BE2TgomfABl2zHgcLLS34Owwv5UWpPzReiKD+WXi
         O8gZj1383QOnq8H0IF9oslqUgsJiNCCq+3xqKya4PZgxOdJ+2NPcBYudScNTTYeAWrXl
         lrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791392910; x=1791997710;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/VEUCnzfsVjtvK9gQou76yPnW0VpuzqTXSNX5pVtmXU=;
        b=hixpes/nLK9SsMVw3j2gaUjFBBN/fmv3Lj8c1+b3LFaMzQXtuiuadqVL0xOyglUqVC
         SamRwJFvGGMv40++NbuTPaIfBCbi/L4Eqx+DJMaYdWEvGGyEjHBT4v1mzq56rCNs4TBS
         PZ9fK+EPAL2XNZmJ+sKMG95u3Bk05fQUpGu3e3+YpncMpxkPLxl4B3uPaxSwGXM3v860
         aUJMg8Y20tG+lHBycynrbjVlv/e40qB5YJwl3TMcLzwoAL7ynZNg7MfIrgJVbc5e0k2+
         2tT/c35R7WObefUM2WpBLM9FVU0n4cHCtjlIKpVahHmrTfzWvzH+YjYfSgW2mw4qf5ea
         XBow==
X-Forwarded-Encrypted: i=1; AKwUvBxXsdBsol2ZBF76BV2gmXmBWUelbQQRwVJ84uRP6NQqFv7Uz+uAJJmuUqQxmQoDqn0nIBQhhQHiBH7C@vger.kernel.org
X-Gm-Message-State: AFq9FYLxjTs/b0wze+AO7icLyigBcCtlZXuPvcf/oc44xLSvgkLo5PUg
	OZAs9Hlqv9uGJP4i7KlmRGRLv7q/rpiFMRXwKN1dw6iQmBLBs1QTsaSVTvL+DGRnF4KjYMtSwz1
	tzcbYBLGhSp3BQdhKV5nU+8h0gxbkTajb3GEZ7+EEsuJsbnPxqe+4UEVfN4uoJDs=
X-Gm-Gg: AYBFou3O0YN2u5WpddEjn+Nuvf6kH0vcNR6ro0lxolWzq0lEYtx6hfxPFksh3gry1xx
	G1R6x7SeOusKD4H27TBZ1zW3yFT37wZy6NsqqH2jyYuo+uoSCg6SWZ+ycuwA2gwzPl3xTJsHtw8
	g3dXwVEfiMv3y+jIrVgokGStL5fBdAp1caoqEP+MG7k2hXwuRueBJb1UKPmGK91lC9Y+aweNU/P
	k1/LDEVpUFd876Sz6xjV60pHidS/1FwOStyGrtArJcCaZc51gKiIM8qEs4yNw24cs1Kc4LBAHRk
	LYy3dw6yTjzke9I5i0LI9U9uVggv7LzvfhrcSiObpthRm98tM2vMavrf2z5gTsfw6hhosr21mFD
	sYik8MQzxsIALrLaoKQDnAXwNpAfg/PsVG+3n
X-Received: by 2002:a05:6214:c27:b0:919:8962:5400 with SMTP id 6a1803df08f44-91997873d7dmr54049566d6.36.1791392910126;
        Wed, 07 Oct 2026 10:08:30 -0700 (PDT)
X-Received: by 2002:a05:6214:c27:b0:919:8962:5400 with SMTP id 6a1803df08f44-91997873d7dmr54048966d6.36.1791392909554;
        Wed, 07 Oct 2026 10:08:29 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91996ba7b7csm25090416d6.5.2026.10.07.10.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 10:08:28 -0700 (PDT)
Message-ID: <c9f5d7c62a0af6a5532ff5bcdff6cc3be0548c84.camel@redhat.com>
Subject: Re: [PATCH] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
From: Laurence Oberman <loberman@redhat.com>
To: Matthew Whitehead <tedheadster@gmail.com>, linux-scsi@vger.kernel.org
Cc: mkp@kernel.org, James.Bottomley@hansenpartnership.com, emilne@redhat.com
Date: Wed, 07 Oct 2026 13:08:27 -0400
In-Reply-To: <20260929144528.7061-1-tedheadster@gmail.com>
References: <20260929144528.7061-1-tedheadster@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-29 at 10:45 -0400, Matthew Whitehead wrote:
> aha1542 never DMA maps the command's scatterlist. Data is bounced
> through a per-command buffer allocated with dma_alloc_coherent() in
> aha1542_init_cmd_priv(), the adapter is programmed with
> acmd->data_buffer_handle, and the payload is copied to and from the
> request segments in aha1542_queuecommand() and aha1542_free_cmd().
>=20
> The scsi_dma_unmap() call left in aha1542_free_cmd() therefore unmaps
> a scatterlist that was never mapped. With CONFIG_DMA_API_DEBUG
> enabled
> this results in:
>=20
> =C2=A0 device driver tries to free DMA memory it has not allocated
> =C2=A0=C2=A0=C2=A0 [device address=3D0x0000000000000000] [size=3D0 bytes]
>=20
> Remove the call.
>=20
> Verified by testing on real hardware.
>=20
> Fixes: 2f2fef022c3e ("aha1542: use a local bounce buffer")
> Suggested-by: Laurence Oberman <loberman@redhat.com>
> Assisted-by: LLM
> Signed-off-by: Matthew Whitehead <tedheadster@gmail.com>
> ---
> =C2=A0drivers/scsi/aha1542.c | 2 --
> =C2=A01 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index fd766282d4a4..a197b3d0b26b 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -271,8 +271,6 @@ static void aha1542_free_cmd(struct scsi_cmnd
> *cmd)
> =C2=A0			buf +=3D bv.bv_len;
> =C2=A0		}
> =C2=A0	}
> -
> -	scsi_dma_unmap(cmd);
> =C2=A0}
> =C2=A0
> =C2=A0static irqreturn_t aha1542_interrupt(int irq, void *dev_id)

Looks correct to me, and was tested at Red Hat.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

