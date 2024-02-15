Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1202C136663
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708016953; cv=none; b=BqQhIU2g/zviwhrctA2d4s+cxClbRxYoDvI2FCSoyv9DhHn4YqTlvvoPpsURco9Zn6Sv9wClkPuw7wd/6e3wbz9vZ4pjoxRBsyoDV6NX6Sonx40jDGWI3DVBEq1aWqMwpFgX09z6USe6cYHBEngrkJxmJd0RK+b17ONmTsqp+e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708016953; c=relaxed/simple;
	bh=+gxxkxAnAEQlZleQZ+wm/qc2F5HNzRdgPWV8KaEq+mw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LxWUcS0qOV2MKjUeURbN53uQXKm3BJeZxRGLhuYLKy/E9mYFPP5ssdNkFUrkT9BBWsCp8me2ywkPLRGn3riDCET+g1VNLFJQCG6XuxzQJvOJoMP+E/KlPJZi1RwIQdOZPs3vpHYG3QHGG4pZTsyQWjHu9vL/bMKGoV4HbUNBCyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDu3vs9K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDu3vs9K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708016950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+gxxkxAnAEQlZleQZ+wm/qc2F5HNzRdgPWV8KaEq+mw=;
	b=UDu3vs9Kqv/3kWrNcupr4ynsRmM/BQ6BhYP41euWUMln/1R/gaEqhhr5HJKGvDA9VhlIYo
	rCB4gUoA2zx75TbBHLpyTisQaIjpkCc8nAmiRGyGIV6xjmOlbqnRUR/Dd1Y99BrJl2HjzP
	LvkDpRFbK4GqclebesXFz8khOXcchUc=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-jNODk-HPN8CM6chUCO6ipg-1; Thu, 15 Feb 2024 12:09:08 -0500
X-MC-Unique: jNODk-HPN8CM6chUCO6ipg-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7d66eb43de3so1839433241.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 09:09:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708016948; x=1708621748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gxxkxAnAEQlZleQZ+wm/qc2F5HNzRdgPWV8KaEq+mw=;
        b=Caa2XdVo6dwTQNOZB9CDgBkQVS0qzxLx/C+9ev4c6mHngC08TIsnAPT6ncZG4jHrEd
         QvmcK16gL86nPvRLzyNA28OpOx0BuQHZZC7B0uGid0Dl1l1+HWVDddAAqvUzMNjP0kba
         g/jdYnJhPF220vNy22j5n+XUhnktApQAilAdAKEzA7Te2nMufHVajxzQ4RES6uYPCeFv
         Oe8AaxlVmZGifG5cNBuTCkOp99E4Pi3Zu2JGbuf3LENLu43/bPMhVFqamRG7knlAOxOj
         IFAkLwLxjiWXzULDUxEkkHW3s38tBHNTptxhjkp5vWVyZVTOMr8t4BSaXNWPWjAIG0lu
         m8ow==
X-Forwarded-Encrypted: i=1; AJvYcCXzwX5UpPC+pjDrAwTBM8ENL6epmGiHq+6C4uCVxfrQ9wi3P5w1Uwd+acH87si8V3FjTGojO35fZVL6VIeGvWG6xRzLR9csfjFXcQ==
X-Gm-Message-State: AOJu0Yz+jgy7MZmt1sUKvcxnGyATsbNzQqgUgGThfqiOPPjKxJA89Go0
	AppeJ6Oo6irKAESo0pXldnRGINxrzvvxo5tQwr2p93gUjiTryT1/944ZzdJXX5RI1JSljkhrcTh
	XAZU+4x1k/uJHDIy2Z0oVAQEew3U9e9uf7cTsH8FeLh9lSMuEcjvlNtQ4H3L4vyjwykAeXmCLu9
	3TAPxTdpjRqUUl6HAczcoz+wcdyCcHgDYNNw==
X-Received: by 2002:a05:6102:b16:b0:46e:cb85:998c with SMTP id b22-20020a0561020b1600b0046ecb85998cmr6102132vst.3.1708016947879;
        Thu, 15 Feb 2024 09:09:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqKN8nXG9DHdlGCKBx7j2h+yBVgeTITjkwdhQ86LVF1SxQWbSi60KlBl6PJI+9np84yiXLCdbc47riWfuRXdk=
X-Received: by 2002:a05:6102:b16:b0:46e:cb85:998c with SMTP id
 b22-20020a0561020b1600b0046ecb85998cmr6102094vst.3.1708016947610; Thu, 15 Feb
 2024 09:09:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215143944.847184-1-mlombard@redhat.com> <20240215143944.847184-3-mlombard@redhat.com>
 <69dfb8a5-ef4d-4b38-8b5f-f793166b2c24@oracle.com>
In-Reply-To: <69dfb8a5-ef4d-4b38-8b5f-f793166b2c24@oracle.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Thu, 15 Feb 2024 18:08:56 +0100
Message-ID: <CAFL455mS93DvhizUizcro7c3+Go_4LJxsE04ywQ2TLc5RCCE0g@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] target: set the xcopy_wq pointer to NULL after free.
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com, target-devel@vger.kernel.org, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 15. 2. 2024 v 17:42 odes=C3=ADlatel <michael.christie@oracle.com> n=
apsal:
> Why do you need this? Isn't this only called when the module is unloaded?
>
> We don't normally do this for that type of case in general. In the target
> code alone we have lots of places we don't do this.
>

I don't really need this, it's just a matter of personal preference,
we can drop this one.

Maurizio

