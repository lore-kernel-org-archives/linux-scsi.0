Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793885873;
	b=qbDhWxuupuUWN1hjNHSlIoYtwzQyR84xdIrGm6AcoyAyYe2iiZ9ba8b36lIYpJC7mWGG
	 YR2ZAHQV4P+1UcR0jXhWpJD26JrhY5B7pHKZrbQHC5QUmflnWqs+08uVajLdL88LizyyC
	 w8NiQtCbjcHZvL3s/ieiEaMwkrVYnv0xtPILkg6Uj8h+v13H5Ceno5gEUlTvfiCcF9Zsw
	 G+fpBg1pwQbnfSWQdHFEftTj6N53YYLuFWFYBISv2Ik3qw++FkFMg6EXZh8oJSSaFmBIu
	 PLKlDy+SpP1ODOp8BBNfHFZVRyT1El7Cvx3LiPsHiv3Z9wjidnXwHlxkrmZ85q3gluQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793885873;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=YNS6rAKby8LR/Cbc4BYoT1/kR2X+t0J+rzMsMWD0wNU=;
	b=tL5cSglm5zhc0XsWQDU41mr4VM54L0dFGrFnDqAdyXFzj9UjsEoV2AeN0uqsxEDMDeDW
	 4OVhrQr14r06dRiXAHfsy/u7Zs04oCxzhC9O3elAMqria9PiP/1FNpzNO1SwyfsNRaPNA
	 GW7QHySUeSskCWvVf0U4R5Agzgx7Dv/GLZHD8o4kIh5FgQKzUdbc2fA3yABuWwiu69xxS
	 FppZeE5hZpE94LSth1OFgfOzfz3/ANKN1grVaSR6ES/V0xxr+2Mrm64G1gWMmfsF6+zuz
	 mQfleVJ6if/YFgHKbOgzt2jIwYU6RGmuvz45PvnQzsBEcpraIdlCv6QOVHhaPjazl/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=A6oMGa2H;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Z1PE9Oce;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D658606A326
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 13:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D658606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=A6oMGa2H;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Z1PE9Oce
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793885871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNS6rAKby8LR/Cbc4BYoT1/kR2X+t0J+rzMsMWD0wNU=;
	b=A6oMGa2HMFBtcTyB56Rh00KW5mvLpPm1iGyZl4Q4Ls9WLwi/OIfX4orka7CA5Ma4e/Lqaj
	NsxlX12fZvOeXPJyFwGQAYQ37hUQJbihjhRm1cUDGSN4w5VPMghEe0T/Udmsjme8SKaqYQ
	MJSeTArUVlhKHOaho0nak6y7c5GT9Xs=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-Toy3c7xMOWWeE2e4CsXCVA-1; Thu, 05 Nov 2026 08:37:50 -0500
X-MC-Unique: Toy3c7xMOWWeE2e4CsXCVA-1
X-Mimecast-MFC-AGG-ID: Toy3c7xMOWWeE2e4CsXCVA_1793885869
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-70b8894d6c1so947204eaf.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 05:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793885869; x=1794490669; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YNS6rAKby8LR/Cbc4BYoT1/kR2X+t0J+rzMsMWD0wNU=;
        b=Z1PE9OcejKAtV/cAgi8lvo1166NWWcJt+P/Ybmz7nI7Cu/1VDklXsGxZMwC2lH+Rh8
         sbuKdbj2UP3y+CeujWRzaRaHD20pXVY6itmu+Hirxh6msR85iIkgPjt914qWP6TdiEJ0
         ykuiaBtm+iFj1drWXcAlnrj+p35CH2dMIBQEi9unBTKuNQEBpiJHvEpXI3f5OmVNvRUk
         R4MUAvlIogeN2C4WkRHZY8yJ3pE+fC/q4rl/rMcn9WOXLhGjQzPMVHNkz0nJ6r+DWgt7
         PUiOWOZG7+Jvu6q7JPUhEQ7TNbPlKpS8OReaXrf0AkMdfF7hYvfFKwgzaXq6YYcMgrxq
         zJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793885869; x=1794490669;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YNS6rAKby8LR/Cbc4BYoT1/kR2X+t0J+rzMsMWD0wNU=;
        b=wxkRsS+fZtGGoiCuq6P7AanJjIikGCJrwA1U4Ywflb/0tQvrF3U57yUTFVSEjGr8hQ
         Jkbq6adF23YI5IKV3xY/bXqZLPAYatrz/SOn06kp+Y8IdPvtupAxD5tMWA6wfUJh48xQ
         l/KLchF0oHNPFHV5oU+8Y99xnrJvI0dVfyam1wlSLqRxUAMQzcOF5XqXMjUpxHK3vwHe
         aayKEvtXgfJZwGy5ZnP/dvNsdOt3ZSyLMUa0celM33mwYsMl1plOkqNVWAgLaT4Ckva3
         D7kFh/PQ4jtb4QQQMlfbLXnQAoSv9u7fFriGsyjEwPME6UeB6pCxm1z7gltYcbdPjZBI
         LNDw==
X-Gm-Message-State: APuU4Z9F99asTvGBd62KS9lf8EQUv8dUpWjXyMOeSIje4+By2Xzd+GSZ
	BPSmrOOt2a1ip6KPCQBT4Dg9C52g5KHKVZ58FJttgqw43Tcvs/SI+a8QfTFTIxVfXghMFOYizre
	9JY/RKp14dy5JOIqoBGT9QitNr+pV7lZEA0fA8/8bAy002qkCsEmrO5LvUP1KzNw=
X-Gm-Gg: AYBFou11ZGeLxw4IVUTb+TLWbkI50V9AecAADWDMQRHAo9Bl8s6zDXUgaxLT2WKrGV5
	/tJPj5lAgj6eWtNMcYIFfVjeDwkhDuIEM8TDW4n2ERRp6LAjC8bFUQZ2fjvhZffNms4uw6HksaA
	WnV8Tgm0yHHRi/7+v6TS1zQI/y/KCOj9fRBy4v0tZs3y+UczEnawPfwHCRWFMuqSnU1zi2Ccy4a
	f0hssD/P6ux/nRGxm821ukKCRbXhO/VSgqXEqGa4iJ28qY9v+YGks1L9+5Tx7EoLotFdUaJPQFu
	9jpzkXAJh2ZSyI9Y9LrkD/SapQncp2EYo4dWGQWRsRpvodcrYhnUqMBruPZTy03XuLjUPg2mJLS
	z9ZBs5OXx7VGZUM2eQF9FjYrIuSwe2KFGWLesmQkhq4moglBrXN5tPMtAzL2LaYm/4ZYRgdSs+I
	gUQ51125oFiORk2Jrspm/RDPiy6DNgUUp0pkO6Vg==
X-Received: by 2002:a05:6820:60a:b0:716:c870:7eb9 with SMTP id 006d021491bc7-716d1ed0d87mr1387474eaf.17.1793885869472;
        Thu, 05 Nov 2026 05:37:49 -0800 (PST)
X-Received: by 2002:a05:6820:60a:b0:716:c870:7eb9 with SMTP id 006d021491bc7-716d1ed0d87mr1387460eaf.17.1793885869035;
        Thu, 05 Nov 2026 05:37:49 -0800 (PST)
Received: from mgandhi-thinkpadp16vgen1.punetw6.csb ([2401:4900:88fb:e4bc:f699:bfa1:8ae:63f7])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-716c12b7d84sm4066366eaf.7.2026.11.05.05.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 05:37:47 -0800 (PST)
Date: Thu, 5 Nov 2026 19:07:42 +0530
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: sashiko-reviews@lists.linux.dev, sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: mpi3mr: Validate reply frame size bounds
Message-ID: <auyGpgpDR_SJ_7UM@mgandhi-thinkpadp16vgen1.punetw6.csb>
References: <20261103123316.223917-1-mgandhi@redhat.com>
 <20261105122401.266559-1-mgandhi@redhat.com>
 <sashiko-outbox-199052@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-199052@kernel.org>

On Thu, Nov 05, 2026 at 12:45:39PM +0000, sashiko-bot@kernel.org wrote:
> [Severity: High]
> Is a minimum of 16 dwords (64 bytes) for MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS
> sufficient for event notification replies that carry struct
> mpi3_device_page0?

The intent of this patch is specifically to establish baseline firmware 
interface sanity in mpi3mr_issue_iocfacts()—preventing the integer overflow 
on reply_sz, accommodating standard fixed reply frames, and avoiding 
underflows in logdata sizing calculations.

Event notification payload validation touches a broader set of event types 
and handling paths, which would expand the scope of this targeted fix. 
That can be addressed in a separate follow-up patch.

Thanks,
Milan

