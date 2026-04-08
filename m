Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0960F344D90
	for <linux-scsi@vger.kernel.org>; Wed,  8 Apr 2026 22:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775687411; cv=pass; b=h57NW7++WvMtTIVsTXML2+qA9a7oHqYvW33j992yxmW5HWwveZcaewv6E67AKkBwCN21Vx8hvcCBunMKQavCJbJwZ5hrVAj7xR1IjBars4i8/M1PiHmOi1xrgjNeVGiMoZcCkIA0BMmbxBhgLmKv38WzYQVy0SZu8/wUBmQPvoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775687411; c=relaxed/simple;
	bh=Bf3HBpcXRbpnz7qtsNrFHKLAfAPv8JOiRr+8WNuuU8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GiwHSk+NBLvxXqc0rhEM/ZnvxO9GrTmp7h15gvxrMCtMxPQn0foTsRM6/uiMVCzdsZpLEPfIqVFpYjwSuPurbkYRV/A2riQf/9XlhMAroPcijX05TNma1I7Ave8c0lGPPJnmy9TvB2G4uqpkB3bb5qk+nFZiynqLw/YOiWkJn5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C8B6U1k0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OOhKfElz; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8B6U1k0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OOhKfElz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775687409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O8YmCfgK+S4qww1OeXKFRIv11CEZdN1UiyLhZqJZF1s=;
	b=C8B6U1k0SU1BwPDy6/8knN6t3akIWVaVhNtgkTt8fJLDoguyum141xKiDcWI6EP410+Lr/
	24IphUcpBwxDs0Zuxximdd9ni2ZXLhId1/Yw2ndoEQ8qLvSRgwBNc8tdbUJnV/ch91dtL5
	et0SZmry1p/RyzKMbmBd1zK7I2aUHdU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-QcCWkXRxM1KI8fg3lbC9jg-1; Wed, 08 Apr 2026 15:35:49 -0400
X-MC-Unique: QcCWkXRxM1KI8fg3lbC9jg-1
X-Mimecast-MFC-AGG-ID: QcCWkXRxM1KI8fg3lbC9jg_1775676947
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38e13b42a91so309201fa.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 12:35:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775676947; cv=none;
        d=google.com; s=arc-20240605;
        b=YWLcI78FryjdKBMOBaNJiU9zAyDyTDUJMxOqmDQFh0egPScEwF0/ROMVZHJc27M6Hr
         bNwYdXGMDl5rLyHOzJQopEzxxO2aoSXymUSFzgHnNmVkEngdtsy/a0NO18coCaFXrcVc
         1GnXc74/HL5uQ/nbXZLlaWyJgughPWb62SYR2PRzfbkdSIeeYCPpKU6Wt428xasX5iFq
         kC5ULFGxLvPaxku2214k1YRmesvt4VRVUKofKVzQRgztzTot1mW4qApszEmcD1RGDZtd
         CLX56LLDkCL64L95ugmlrGXgRjdUyimTGaGCZBNHX3T1msPvgFMQQXRRBWul365TcZAa
         cipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O8YmCfgK+S4qww1OeXKFRIv11CEZdN1UiyLhZqJZF1s=;
        fh=WfrnVlOSGChBK0eMcD8ZHxlBlA5OkWNwOeaVE6oyKcM=;
        b=gZ2jAxzM499sARWn0GJZ3yjeaEyMv3I1z/3uatHCdPU7ZJh1VNQGUtm/0L637d3kjy
         NcjIxhv4Kw6RsTZ58HOu9b+f2zUoVXDjBMr1puXbwdb7AtQgt77DJbcvycZJBpyYvSGy
         wOSoz1oz6A3fVBUh1aU92AZmBLB5o1/4IkV0K9PlZ0/0liRMsJJJ7cObX5ZzPF4lbvfF
         nDofWIypAA7YN54W7X175KsUIH6ITCSyEbV99IWPL2U4iMKzM6D6PhLLQGeL8sgeGyQX
         xywVX/l3grYA2xaLKBaRUxnMmgHCdkk6JW0Jq4gEp0kS5RAdJTtGAslZTNY3GNFUbLfG
         7mLQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775676947; x=1776281747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8YmCfgK+S4qww1OeXKFRIv11CEZdN1UiyLhZqJZF1s=;
        b=OOhKfElzk2GMgPZfI+IUj1WYNJzcxuOoBZBVX2+e9R4er7gXCQDIdE6wk1gRFMUeeo
         3E516oxg+OEiboDxUhEVU9du5KckLTboBRftES4hZA3EaY/WFcG/Nl/AEyqpLIgFeQGH
         1MwsXaxKJBa71IQg637M+uP+vicCknhr+KdZah4kg8Wt75dHPA82Z8oKhomE0tUPql81
         mc1+7tWAxG2Jldbjh9aYcDcYcEG085ryS8qN79IoK+kxM2o5+aBAw5FXrLw2Ayus50n2
         cDe7MxVBycmxllKkRxiawaeoapbmPK79a/YYTMHjEIqyKVeXA0nQdmrKW+Bvk3Kus8I6
         iqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775676947; x=1776281747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O8YmCfgK+S4qww1OeXKFRIv11CEZdN1UiyLhZqJZF1s=;
        b=oWDFlDzlZ8JZUGoQZ7MbMU16xgatWAb+92CLW1PVfpns/bAy7LWSPTjXgT5z7pkehE
         K5Z4LilR90BRp4l03sRQ0cBqDKh/hXDWYyLH0FrjW3yHO+WoX46PXr2/RR2Fyoik0wGf
         5oTHXth6HHCOdd5ptjaOrrhqb+glSIsaLpI9IK4Qwz35e9I7Ujx/gwzAII21hyWdD66l
         3SxmQI5ERfCcqKzx68mjPi6JBAGnqhAFESfTJduKqIMR/FVnkJXZNnH3qPPa94D/0FwT
         RS9Z1AegvMtPhb2cS3VaMlkRo3983K2z2Mc7q2W5/rKbeYd8RAXEDHgyDFu7aMI8iOhC
         jLaw==
X-Forwarded-Encrypted: i=1; AJvYcCUgQswsCGgwusgrA+4+b2+Y5+yso/b222dClle16Zb8ukwxX0sbjYPNEwAw5rxQ/mugIbJmPrXpmk7K@vger.kernel.org
X-Gm-Message-State: AOJu0YwRUwnV7OfEcX4EkjSd54xX0oID3ex/0OHgPBZ4GIZl7NbsQpYX
	h3xaWWiHNOrA0cc++Ik3jbW/ykxUE+/D2X0DC04EpdAbu5LZnS5kgzu8DWe5SSNioGeiN9eUxfo
	YxEdTaO4OyJPvjgMUle+OqEGJi707S1uD3VPTqBDdJtfHa5n8rqRWEC6XOxecbG2HK4dhyI8LWF
	wN1sPvXVdQM36Oz76H7+O/i4fe1AUJGHwTgc7LRw==
X-Gm-Gg: AeBDieu65TtV7uoamizbRLqO/pj4eceCo3Ro8/C7AQXqMxVWN1722BfcMWfRtN8WFfJ
	KwNLrYH9geX1HGad/w6qlXsT4CIxVmWDMXpIIDO1gJaxUTq4ms9A8M5ZEVgNiL7hwArcM67yHU1
	gkXyIhxKcPCPopiv/oHzzp6zVXNduTfEJ6ne/TnG1ahWERE7Z56BZbl5MXJiqJ2N8FmrlPGsvJz
	QwI
X-Received: by 2002:a05:651c:1509:b0:38e:2933:cefd with SMTP id 38308e7fff4ca-38e2933d33dmr12737641fa.9.1775676947325;
        Wed, 08 Apr 2026 12:35:47 -0700 (PDT)
X-Received: by 2002:a05:651c:1509:b0:38e:2933:cefd with SMTP id
 38308e7fff4ca-38e2933d33dmr12737381fa.9.1775676946827; Wed, 08 Apr 2026
 12:35:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407153532.6395-1-djeffery@redhat.com> <20260407153532.6395-6-djeffery@redhat.com>
 <c5cb8cf0-9beb-4bc4-8ce6-83b4544beede@oracle.com> <CA+-xHTG9tMCCf11NZwKfvE5xvCfjXrttDXhFsyz=SCofAc9Mgw@mail.gmail.com>
 <069f3f1b-8150-41e8-a760-f85a0b1b0ce4@oracle.com>
In-Reply-To: <069f3f1b-8150-41e8-a760-f85a0b1b0ce4@oracle.com>
From: David Jeffery <djeffery@redhat.com>
Date: Wed, 8 Apr 2026 15:35:34 -0400
X-Gm-Features: AQROBzD1jjRkWpzNwb8uyDg7e1dbHkjzLDl0riAoAiR4l1_QYsvUdLm-veMvcSg
Message-ID: <CA+-xHTFdKaCCwkytXpWdvp6vZ4ZCh+Pp8wzkoVZYPOy--CjiSw@mail.gmail.com>
Subject: Re: [PATCH 5/5] scsi: enable async shutdown support
To: John Garry <john.g.garry@oracle.com>
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 8, 2026 at 11:54=E2=80=AFAM John Garry <john.g.garry@oracle.com=
> wrote:
>
> On 08/04/2026 15:16, David Jeffery wrote:
> > On Tue, Apr 7, 2026 at 12:35=E2=80=AFPM John Garry<john.g.garry@oracle.=
com> wrote:
> >>
> >>>    }
> >>> @@ -1396,6 +1397,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sde=
v)
> >>>        transport_configure_device(&starget->dev);
> >>>
> >>>        device_enable_async_suspend(&sdev->sdev_gendev);
> >>> +     device_enable_async_shutdown(&sdev->sdev_gendev);
> >> We call device_enable_async_shutdown(&sdev->sdev_gendev) here and
> >> scsi_sysfs_device_initialize() - any reason for that?
> >>
> > It was added to match locations where async suspend is set.
>
> Well it is not exactly like that. We have the following:
>
> scsi_sysfs_add_sdev() -> device_enable_async_suspend(&sdev->sdev_gendev)
>
> and
>
> scsi_sysfs_device_initialize() ->
> scsi_enable_async_suspend(&sdev->sdev_gendev) ->
> device_enable_async_suspend(&sdev->sdev_gendev) when not async
>
> Maybe similar needs to be done for this shutdown feature. AFICS, Bart,
> added scsi_enable_async_suspend(), so maybe he can comment.
>

My inclination is to drop adding device_enable_async_shutdown into
scsi_sysfs_device_initialize. The intent is for normal scsi devices,
and I see little value in setting the flag so early to flag partially
initialized or pseudo devices.

David Jeffery

