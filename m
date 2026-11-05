Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793905144;
	b=lNGAGtWEyZ3wvVAdmj7EGJzXhFHSilHnexFVuuLMkwGPXmZA3S2migaIxoPOqeAFQ8Yr
	 vUS8N8RKZL1kWK3QMDqiMiTvKqnL2llL3xPP/N1P+Tiy2QGPiF//RdBmJJXtLKRAuld55
	 wId2pIKuY2vZkGWiBZIWJq4mP+09/2ipBtmYIDIvsnYMJOo0vLSJAGa1BV4lBdN+v5Yg6
	 a7Uw1T38hTdleOa4SL3uvTFtkSRbhmt6yWlV8DxWy1toVXDBg+TctrLsSb9ZragZi7Akh
	 PdiS3NGgHqSXttyK0jUbxr2bJjCzpILAcTrg7V44IlnLWRu082xKLend7/Qx/AKuhiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793905144;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=GtVJ5fDzJs7dwdJ7kQ13zFePN7w2DrejpnY2Ytkrdiw=;
	b=DPqIPpYTOtJr/9WkaSOnZFlxsukpl273zu+gkjrWJC49nk/D5sflbVjejH0j26ltQi06
	 oRNC5o3gaGv47VbtH4bFUKENtIr6UbHolNfe+ucuvxrX2NIcNKjSyde21CEfq8hMV8EtR
	 vlsoM1yP5HJ53UHsGsR8SDMomf69TFUkrq3sH56/x8FgW6gLCfkaW3Hw6rVuizLcDAlAb
	 I8US/E0bmYEzgSD8GOJ5grl6iESj53PbuUxbvJ9qQNXSly2K9DjH0L7Q4r6T/fD8fEUIu
	 Uq/6YkfaXBym31Ux2l+Pp8K6ljAu6TGeV3ndf3Nk6llkd9BQTCMjy1HLf6wuJIAwFyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b3Acq52A;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=L6B5jDV+;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABB6606A328
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 18:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EABB6606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b3Acq52A;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=L6B5jDV+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793905143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GtVJ5fDzJs7dwdJ7kQ13zFePN7w2DrejpnY2Ytkrdiw=;
	b=b3Acq52A9nBxZyLUw1PdT2vejSKyyY4951g3C9KIKJEryj7ARZrPcvw57i2S0amRAvswOt
	DIZP0Hytgq2pNlWl9K7YHYbKz7jpgsATQ8g7zyjpPYX1loGRhAlGzz9uygapU9CYtdchKq
	xnoRWIgL1hcycTEuN8JYfQk96wYROtU=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-QLSdQCA3OImP73ST4pdNrw-1; Thu, 05 Nov 2026 13:59:02 -0500
X-MC-Unique: QLSdQCA3OImP73ST4pdNrw-1
X-Mimecast-MFC-AGG-ID: QLSdQCA3OImP73ST4pdNrw_1793905140
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-869553205a7so35591617b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 10:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793905140; x=1794509940; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GtVJ5fDzJs7dwdJ7kQ13zFePN7w2DrejpnY2Ytkrdiw=;
        b=L6B5jDV+fhmnDVZIKwO414AEnkdbC1y9UlWdyY1sY+9FXLp/OIb2pRQKxf8LxNGfqR
         GKsAe/hXDkpUfK5VNDRnXJmryWsxw4i3rPhyfLYDkfBXhj8qJMkwvLyJt0DDza48mJ5p
         7nDNabYytCLVRcEqiofEIXUIxj0yjn7JU/ecb9LxCxFmzdp0rvHikgCwEepns6xLUfey
         OPTw0xywPSbGwfIwQ3LaAQk27GwQ7KyzZGgqezX16MuU6g46/LL70JH6hhPbA7h1f2JX
         HkBXVHFq0TsHZ8t3xZRAC0rr4L0d8gymrARfhz3q5ZCa+ogTQAiTSR5nuFSLHCcGJRdq
         tYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793905140; x=1794509940;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GtVJ5fDzJs7dwdJ7kQ13zFePN7w2DrejpnY2Ytkrdiw=;
        b=YG87bbKnS1qGsroNkvZv5E7RYs9bNUwo6TbXaZq1PcKhYqI1nfmihNPQCtvELfbGxB
         CFmGmNPRZf3An4DWPMe0lNSTeQ3wKl0Cq27DJ62owhBnB6NpX4L4obn26Pc0Sj19PsL2
         vM/1xfypkBgrX++11vmfoGBuyYGQPAaKXNhS5FV39Hm3NO0fjWnfpy2Q5B6rMWmpT5Gg
         QV4Roh6gXpTnWzjAjdyJmbQx4uweuIbflsKsHo2OqysF97I7xmg4HmPBjuhbI+9fSTnB
         EEu78IfsMDCcaeMxgUdCCKnk/AAl8Iw52fX5Pbcys83SvJVB0p1c6Kif3p0EbSHIDG52
         8GlA==
X-Forwarded-Encrypted: i=1; AL+hErHLlM5aMxLNbEfxHZNA1k4w8RKS91nGro5FX6dIQTnUpbdlEKvkbHroi3aYBTv49hmWqMe7sYJD2NYb@vger.kernel.org
X-Gm-Message-State: APuU4Z9qTkIx0+SkmyeDsiukVgkogyM6baHwQZTc6hK+ITjnIgNlT3Df
	Z3BMb/IsJjXLLG0K0lxregCTc5ok9ouDxFI4sUdjgXkhROczDbE7wBikVPbcbO64O2t9u8sbgFV
	saLzI2WU58e2CHAl/p97ViYQxZMU94dMEbaMFRPIxZh1+/ibw7OOttCg8pxcDrMo=
X-Gm-Gg: AYBFou1MJ9NcUDzn9bMiBFqpRak5rNpy32FywhrskknVtTGAOlsVi+vXKBjMx3vYoD/
	hw+wcoykHZ0tohUckMUamLsLggcIpsudPiJCdbrGPtLDSNFFBMIRs3LQlYYwlGGyKODTRRvJERn
	t4wy4MKUPpdRX6vb5Pv5qMX3f6t6u7nTK3d+AOcBCmXjHOoxrY2v5FzUw5tpTsCACwMrSYeGR+K
	gKDJQdTBSTCT3IYEAJWbShzF2/zmlHWBr/NrJAiLdHZUlygwXjMk6VRmZ43Y0t4Egwy4r9S3QyZ
	GD9owjvxhlXRHnknoqCbvk6BFqvzK1ZYUQCO/SM92fo62OZo+rnDEk2F0tKom6TmzfsJWfGXJQr
	23CGMMwhT0RaPWPLqWmDt9CKbTBgdNi6XsE3oh5Mhs9uouoKmUmYl49EI1V/iclwbZDwQl+hoA6
	JkVyoymNfWhtBv451/zL9ZDebD0QfvOflsBNh8yFX3O9HNqc7KHDKUQj4ZdPrfetEaarrnVdw=
X-Received: by 2002:a53:bd83:0:b0:679:887f:a2bf with SMTP id 956f58d0204a3-67c142c35eamr78961d50.36.1793905140282;
        Thu, 05 Nov 2026 10:59:00 -0800 (PST)
X-Received: by 2002:a53:bd83:0:b0:679:887f:a2bf with SMTP id 956f58d0204a3-67c142c35eamr78942d50.36.1793905139634;
        Thu, 05 Nov 2026 10:58:59 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c135e8d5esm242675d50.19.2026.11.05.10.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 10:58:58 -0800 (PST)
Message-ID: <7dccd24b8dc18be694ffca063cd4c13655ff1c9a.camel@redhat.com>
Subject: Re: [PATCH 1/2] target: iblock: drop the dead kmap() NULL check
From: Laurence Oberman <loberman@redhat.com>
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Date: Thu, 05 Nov 2026 13:58:57 -0500
In-Reply-To: <20261105193351820CRZfBnzFE8zZm2DrNx0T_@zte.com.cn>
References: 
	20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn <20261105193351820CRZfBnzFE8zZm2DrNx0T_@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-11-05 at 19:33 +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>=20
> kmap() never returns NULL, so the check after it is dead code.
>=20
> No functional change.
>=20
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> ---
> diff --git a/drivers/target/target_core_iblock.c
> b/drivers/target/target_core_iblock.c
> index ea65d39fef88..604fca959f2e 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -461,8 +461,6 @@ iblock_execute_zero_out(struct block_device
> *bdev, struct se_cmd *cmd)
> =C2=A0	int ret;
> =C2=A0
> =C2=A0	buf =3D kmap(sg_page(sg)) + sg->offset;
> -	if (!buf)
> -		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> =C2=A0	/*
> =C2=A0	 * Fall back to block_execute_write_same() slow-path if
> =C2=A0	 * incoming WRITE_SAME payload does not contain zeros.

Looks good.
Reviewed-by: Laurence Oberman <loberman@redhat.com>

