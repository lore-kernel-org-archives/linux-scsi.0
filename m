Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972552;
	b=yko89/SLqlhNYZKtrWgN+tRNUyBADT7drJgeSwWkpzw3UC/AFOKK86b1bevjkQdHobCf
	 /eWzYk4nw1rr1UiJtQjvSsDOF14jtq+pZ81sAO85XEX3Hyw2Gxoz2WCOHdlo2yH8NVejj
	 VPsgk1Y94L5TaN86QEe3T6wE7LCAK0nfrDT6/9c/wB84WbJtOzr1Gstpk0aoD6BElmtvm
	 bZzfaUddIVRVEMF5LwtiDnYj1ZzZQSc0Accy+FwYRB0RgKvF3pviyrusLPxSW6+NjveZx
	 mKgmmTwACIr7hIod6W9ptAhaV5Q6mTvJq7qRWIf8Ef1qh2S1RsG7rAhmIVUPFgJPDKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972552;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=M2OtBz6UMPgdGIuaycWDBNbfaEpTV0kfhUa+atvwSh8=;
	b=YjvWaf6snNqSAlDb+41pyOnfZ1qW+6F945N2jfISGPg3MbhJKfL2zkym+Go+LZZ7Abhg
	 bonpMt7OfXF/6tTbPbW1/9/GxBmKCNABmWcxNroRa2rBrO1C18T37KvaXRZBYQzb4OWcc
	 aqkQU2kID5zjN/uAKZamJtspyIFryMUnO9Fh54ugsDK2Bw2xvUMPr0fIs/T8IzK/+qYm5
	 xrs+P85TBOdzixl1zZnRRqQNrW7VlPC0il6ms2T02k5It4SCEbLlVG+ANkaiFpyhepocB
	 66wamyfleXJEFAsLraUGGQCtiQPP7kyHE0wmastd/j5fWnYIl9e9CUo5+VXl6Q+XvWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gEgI8OQG;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=nhnolO2m;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93843606A32C
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 13:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93843606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gEgI8OQG;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=nhnolO2m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793972545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2OtBz6UMPgdGIuaycWDBNbfaEpTV0kfhUa+atvwSh8=;
	b=gEgI8OQGpjFBuRLGDZQK0KctfCEvLulN3J2Hc0Ot2ShYpHaxubQGhGFomvGGz36sB3iSqO
	mvYvYCs4XuX2uZjrf6FBogxvcffRQxP0UKuaZaCdnF9LgWwBsU4TVaZXpuAgS+91SZB18Q
	TuSwBM6TiRvUYLnf+DPb+FguSW9jt1o=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-_M3UIKYYMX2Yxw_gBfMVhg-1; Fri, 06 Nov 2026 08:42:21 -0500
X-MC-Unique: _M3UIKYYMX2Yxw_gBfMVhg-1
X-Mimecast-MFC-AGG-ID: _M3UIKYYMX2Yxw_gBfMVhg_1793972535
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-677c4ca2265so1063643d50.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Nov 2026 05:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793972535; x=1794577335; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=M2OtBz6UMPgdGIuaycWDBNbfaEpTV0kfhUa+atvwSh8=;
        b=nhnolO2mnG/dIXW1NWmgUqxAJwG48k9brC0aSkEsA0aR6IYjYD4/yTbM8w7IthbqhT
         aZ5aq/Q9iP0a7n66LpZuOx4wlsdowHeKYFr+NnM/1uzrBZdXJ44gyOmeuE2I5I8ePAID
         tTvrIY/emDSOvBZwYwobHWJahI409afdv240Z3ep5xnIk7bKsofSXF39175nLGW1zG3B
         y3UVmn44I8zSz1cHQyFk+lrY2QQzLNLi/oYa/CH8sOJ/IAQIf/iTKAeFYlRwlbPOirZu
         qqIE3l99hn4TFn6KSoX7SkiSj1Kzxy8NkaLq23hzAg2juq4Y9F8hxlOu2qP4STSJM+bX
         ugog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972535; x=1794577335;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M2OtBz6UMPgdGIuaycWDBNbfaEpTV0kfhUa+atvwSh8=;
        b=wfjydSBdQI++T1pEgsJqxewsJX9Le/Ygps14ZJ49tLDVYusNShHBkakAcXLHYI+HdQ
         rrdJL6YapnejL4qXZeqXp4+ImYJ78+2267SgEjUxO/b5EnL6zljHpVYxJBZUqXhThIxt
         C/YOz+bkm8/AwPafP/hD3Lh1oARGyGdkVARqlhbzenCiO4khcy80WawS5go3RB2zaVmP
         QpRvFicd7qXLcwiRiRGLJAnw7ZJtOWcV9ew2mN7D7WtRjR2ktuP169vuoBAl/Gm56ckU
         x5dbO5sLAfAU+QLnXJw4UfKDoA5tNHOhS5wkzXK/xtDOQq2w4SWbAxxUxNPBk2+n33qX
         k6yQ==
X-Forwarded-Encrypted: i=1; AL+hErHfGjas+12yhcv8mUurjegfz365jH2idsIeYnai71u44otAEVLJi41sVd6Li4UUMGM9x5HcxK7Wq8G6@vger.kernel.org
X-Gm-Message-State: APuU4Z90hjsqZOpsI2db327OH0yRyO5u2JaKV8yhVMNyryBBa1dfnRRM
	dmWXLpaMbbg1owW6P6cVk4fGe+ADxpGeFmkyGs+LXtTeER9tisGpyIO/8Jgo5zxS4oAT+QjkkuN
	yTBZpJtelRXfWekjWPTrb+l2GxLFOikefJEEAWPT2H+CSIELy5RS0A/xH6nqM+Rl9e97TR1o=
X-Gm-Gg: AYBFou3Xo6jgGdl/TkThThbso23IVloaTTyRoXoYJwnICBfFLRzOsVJ8ZmUANeKCtmc
	6PFopctCYAkoo5VGyUmwCVIm4cxgIka33lLyvLCvwDhhAGnb78nQZom6MZnpcGv+X1BF77yRyiX
	WmBqT9UOkU2N2MzijDt1SW9lRtNK0VJo7YctWwNIe5wy4bt2X59XGV/ZcvoH5oJpI5y2HRYtnti
	DIX78jzWHbMx7JKPY9HMdzv4+b+l5T8dwWzR0wXC+O4U9ZQjdI7tHFztDPW93UUWgjro3bdSgLf
	deMbmQxW0rK/J8pSx7XJ5eUKGpPDi4sUojTPiSY22Ea0dkAq5DEgb1hjqupan0WITC4gJlZdaPK
	cQfmyaYm+EkO/U9Gn6YW6VlJ7gEV5wxTe06M+bgUhwxdYW7dJzxaxyWHmhB9rgmGDcdgEeUZGON
	rE/n8haUxf5HQZS9Ir7e/lABN9eQ444UPC8L4xPNmGK6cv2cfs8AiGtzd1TQ9G/8kOgPMz04A=
X-Received: by 2002:a05:690e:4385:b0:675:3ec2:25e3 with SMTP id 956f58d0204a3-67c1456dd29mr910178d50.50.1793972535198;
        Fri, 06 Nov 2026 05:42:15 -0800 (PST)
X-Received: by 2002:a05:690e:4385:b0:675:3ec2:25e3 with SMTP id 956f58d0204a3-67c1456dd29mr910167d50.50.1793972534598;
        Fri, 06 Nov 2026 05:42:14 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c135ada39sm1930977d50.16.2026.11.06.05.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:42:13 -0800 (PST)
Message-ID: <e89f5d5656ef983e21e27a8557ddd178e108295d.camel@redhat.com>
Subject: Re: [PATCH 5/5] scsi: st: factor out the end-of-medium completion
 test
From: Laurence Oberman <loberman@redhat.com>
To: shao.mingyin@zte.com.cn, bvanassche@acm.org, mkp@kernel.org, 
	linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com, 
	beanhuo@micron.com, stanleyjhu@google.com, jmeneghi@redhat.com, 
	linux-kernel@vger.kernel.org
Date: Fri, 06 Nov 2026 08:42:12 -0500
In-Reply-To: <20261106154249447T0sEhKHXg8J8MF0Fo1Op0@zte.com.cn>
References: 
	20261105193339565ydLHLai73bbBko0TtjrtV@zte.com.cn,1023acf9-999f-4e42-8dff-e84a69c7e259@acm.org <20261106154249447T0sEhKHXg8J8MF0Fo1Op0@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-11-06 at 15:42 +0800, shao.mingyin@zte.com.cn wrote:
> On 11/5/26 09:21, Bart Van Assche wrote:
> > The first occurrence is in st_flush_write_buffer(). That function
> > submits a synchronous WRITE(6) command and has nothing to do with
> > write-behind. Additionally, I count five conditions instead of six.
> > Please fix the patch description.
>=20
> You are right on both counts.=C2=A0 I will describe it as the synchronous
> WRITE(6) issued by st_flush_write_buffer() and drop the condition
> count.
>=20
> > Please declare the argument const and please choose a more
> > descriptive
> > name, e.g. st_all_written_at_eom(). The "All written at EOM early
> > warning" comment from st_flush_write_buffer() could be moved above
> > this
> > function.
>=20
> Will do: const struct st_cmdstatus *cmdstatp,
> st_all_written_at_eom(), and
> the comment moved above the helper.=C2=A0 v2 will follow.
>=20
> Thanks,
> Shao

Hi,

Thanks for the patch.

The refactor looks correct, but I don't think it buys enough to justify
touching this code. The EOM handling in st is mature and subtle around
buffered writes and residuals, and having the condition inline at each
call site, with its comment, makes it clear what "success at EOM" means
in that context. A helper named st_eom_ok() hides that.

Unless this is a prerequisite for a functional fix, I'd prefer to leave
it as is.

NAK for now.

Regards,
Laurence

