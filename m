Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE483D96A
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2024 02:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731034446; cv=none; b=Ra1m70mgQRzQr0rIJYzRcqz/GaG6obYQkSXawXFFjNXU98xh8/M4j51RA5OVKJh1cgNY6dWQpaMzc5PZP+L4dhu/fJK44rpnY0dAVuCFzZ0Z+p5sEllrxLvMFRUtk0rEUW5MeUUNpOUe2Sc/xyejRH05Iua/YpX33rdAwa8vRZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731034446; c=relaxed/simple;
	bh=cwEqbnHj/TJxnIy+3o2VhKgoUs8GcxvB6wBbbqhMWAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jx40KfGi1Jz9I/2Ahf8rvM+ZVOE4GxPNmZ5ec6neKIPawQGKOZ+tuPxKtMgzh+wn1j6qgfeYOOy0Jr0OlRBS82AQTq7zxTreV0gwFFgo3lNMtxbysgk00z64cuf9kWiIaQg07oAA7OGuogl1Xw/1kmDM1FdviXlDGi01RnOQAzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ujrubfna; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ujrubfna"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731034444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cwEqbnHj/TJxnIy+3o2VhKgoUs8GcxvB6wBbbqhMWAU=;
	b=Ujrubfna44Raer7m0SiDuwhj/e0q1yzL/RkvOHEUQl33MV4WhVHbrpLnV0mQLBy4bPjXju
	XmC2SQikTSzXZg7mS255WxB2h3JpWac1o8qj1wT1HGakDbt/QTzAlR942Qv9NYF1kmv6fR
	Jj8Rbg8mDUwhL0qLeHlOLL3BjAFR6+s=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-8dMOe54yM12TPgJLOX8uaQ-1; Thu, 07 Nov 2024 21:54:02 -0500
X-MC-Unique: 8dMOe54yM12TPgJLOX8uaQ-1
X-Mimecast-MFC-AGG-ID: 8dMOe54yM12TPgJLOX8uaQ
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2e2eb765285so1895774a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2024 18:54:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731034441; x=1731639241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cwEqbnHj/TJxnIy+3o2VhKgoUs8GcxvB6wBbbqhMWAU=;
        b=YLmG2AuhsoEIesavBPQQDtnagIwVObSDw+xeOIh1aLp9rW+MFyTCVLIHAmR4EW8QiY
         ZVQT5NS1+jKYpY6tTOSMH5NlThVxqIn0WBom68D7590PC/JYxle3vBG7LWsYCbl1IVRr
         TLCpfzmjDshOkP9loPjquUHwbzc10bk5JG1smqpT5Z5WFKlixmViyAJYiCUA8+7csuxl
         JIHrYyXkqFtJ6qxk5EA1Qk6x2vhVpsY0ZYng8cxguamMIoAGxNYlG266WMuOjoDGXpSX
         xAwAkVKNR9hfATLYzAY+KRGuu8jCI9rFjXxYOj4Dj9R2KXdOg39MgYgZx8vIguwPwZLK
         WNiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjA7Y6MFomElxLGhk63s7bClg+n3dxMWux8wVBfD24RXZIJzlCXZ1hDJitZryzJcZ8Re5b8dQOE+Sb@vger.kernel.org
X-Gm-Message-State: AOJu0YwFMLAOjNojLnehpba3v4FZTJZSzR0c/E58nNocuG0jyOAxYUX1
	Rv1bRhIgYyiFYkJB1xaRrVOgZPferS62iqc0FF2AOlsWZQkm36Zs28hsSFvm2f6dWhUr2sdSrC1
	95URveASl/0N5uBuQkvd0S0GmH6rimpWKBzkcJa5sUxf2k/0hOU1uFxuyxrklNDxquBNFS2x91X
	lcsfzuoaAShwzA/zsQE5zLszYO0xFyDajKRg==
X-Received: by 2002:a17:90b:3d91:b0:2e2:a029:3b4b with SMTP id 98e67ed59e1d1-2e9b177632bmr1984112a91.28.1731034440900;
        Thu, 07 Nov 2024 18:54:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeAKu6FXOO8aouj3/WFxZQgxhtW8ocCUmDNXhuRcpuePvBO35pclspRsjXFn6dE+pdWYMrEjjMCT0rnXoNyZM=
X-Received: by 2002:a17:90b:3d91:b0:2e2:a029:3b4b with SMTP id
 98e67ed59e1d1-2e9b177632bmr1984080a91.28.1731034440508; Thu, 07 Nov 2024
 18:54:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031030847.3253873-1-qiang4.zhang@linux.intel.com>
 <20241101015101.98111-1-qiang4.zhang@linux.intel.com> <CACGkMEtvrBRd8BaeUiR6bm1xVX4KUGa83s03tPWPHB2U0mYfLA@mail.gmail.com>
 <20241106042828-mutt-send-email-mst@kernel.org>
In-Reply-To: <20241106042828-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 8 Nov 2024 10:53:49 +0800
Message-ID: <CACGkMEv4eq9Ej2d2vKp0S8UdTgf4tjXJ_SAtfZmKxQ3iPxfEOg@mail.gmail.com>
Subject: Re: [PATCH v2] virtio: only reset device and restore status if needed
 in device resume
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qiang4.zhang@linux.intel.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gonglei <arei.gonglei@huawei.com>, 
	"David S. Miller" <davem@davemloft.net>, Viresh Kumar <viresh.kumar@linaro.org>, 
	"Chen, Jian Jun" <jian.jun.chen@intel.com>, Andi Shyti <andi.shyti@kernel.org>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Gerd Hoffmann <kraxel@redhat.com>, Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Qiang Zhang <qiang4.zhang@intel.com>, 
	virtualization@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-i2c@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-sound@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 5:29=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Fri, Nov 01, 2024 at 10:11:11AM +0800, Jason Wang wrote:
> > On Fri, Nov 1, 2024 at 9:54=E2=80=AFAM <qiang4.zhang@linux.intel.com> w=
rote:
> > >
> > > From: Qiang Zhang <qiang4.zhang@intel.com>
> > >
> > > Virtio core unconditionally reset and restore status for all virtio
> > > devices before calling restore method. This breaks some virtio driver=
s
> > > which don't need to do anything in suspend and resume because they
> > > just want to keep device state retained.
> >
> > The challenge is how can driver know device doesn't need rest.
>
> I actually don't remember why do we do reset on restore. Do you?
>

Because the driver doesn't know if the device can keep its state, so
it chooses to start from that.

Thanks

