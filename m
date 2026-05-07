Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5384C1419A4
	for <linux-scsi@vger.kernel.org>; Thu,  7 May 2026 01:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778118318; cv=none; b=P6YptZmczLefbv8Rf6pjwHiKNmCNVjthDlLjph8o5aYWx0dZD0Ae9IbbnijeD9Z+AvhxfRCiJFoZz/SaTZ1D6wZVbjux2GzB+E8xHUBFH4zXAuVcWiyrR77cIrw+DP3bJqmEOho74cMye+1A4liwFVPJAXXCYdn3sN1AKO5kmRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778118318; c=relaxed/simple;
	bh=nn+VuoW/LzPu6eLuBwL/M3i+EzeG+u/cAb5jKSt+Pmw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IgkdlccExCIqrtFoPuMn5UkmobJCDqeELAAK7UyLpLI4n4m2v4prev8dkz8254PPsYefbotjX4DLpqoPcfdjO/teFiMMI8uZcRn7r+2/3lPDhMvW2ljhnnN/FvB+Vq47AODpm9yzmzODMFxcGXmVnedRRI8x4ZdFRlC/To0jNjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PySSpYPo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EmUn3McF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PySSpYPo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmUn3McF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778118315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nn+VuoW/LzPu6eLuBwL/M3i+EzeG+u/cAb5jKSt+Pmw=;
	b=PySSpYPof0aYb4R81Ae+CXxMvEyCbWie/uEPpUaTiPnqF7bh+jYPxP0B/6jLBNqPSwkpsg
	nbR9KPvCFSVVkxfYI9JvbxL6tbTtLKqy1p0Vue0simCHfpu1ZZTs2SWxHSbYx39tao/eBY
	zNg9Q0RtAqADo3u2cmP3oq59d+7EJCo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-flsf383iMneRzDKbVU7W0w-1; Wed, 06 May 2026 21:45:14 -0400
X-MC-Unique: flsf383iMneRzDKbVU7W0w-1
X-Mimecast-MFC-AGG-ID: flsf383iMneRzDKbVU7W0w_1778118313
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50df4c130dbso12832231cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2026 18:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778118313; x=1778723113; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nn+VuoW/LzPu6eLuBwL/M3i+EzeG+u/cAb5jKSt+Pmw=;
        b=EmUn3McFjEK9GK+LB70sHMwg2xljeeoU3Bzmfp5zRdGwU6JG7XgahIqJ7orjkwDhav
         wB++/WgMJWbylw3G5x65FiAb929LA+R+pqxDSX9o2zztSs08BPWHHbvHuoirQ3EUI65H
         bADu52fAFSUOxMXqC6rGhoYT/EyzMmOt6NJIkeQxRFAEJMQNyHahDX6tJF8udnLnd7P9
         IH256Pmk3UDKKex/4KHQ7u7T2d/HGG9GA2MFdEuxtl7xPxbAdnGKcBgP8gxXz4uHi3UM
         KZ6VqBYVlfFVoIXGRVxZ2rz6KIbX/oc8NwnXYCLDbEJfEgvEewK3jm6tHqGb+EFUg+4n
         9bow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778118313; x=1778723113;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nn+VuoW/LzPu6eLuBwL/M3i+EzeG+u/cAb5jKSt+Pmw=;
        b=ADsSP1/KQ1sK98tFHqHYqa/REgo3daN+cb8POaO0TJLTJh2+lOsNjfoNOHv64AUdy+
         9BNntxMaKNNldmj9Q+gXnOn3KX9NhFEUdWaAL9pCYO+GawKaSB5yZY+HUDANixM94Fk4
         GKe9mBQMKIMoiRRDfEBxz1lBwBvBWK1Xpxl9JnbnenwEXVpYy866A3cCWBmNGyzQRShn
         ZXKsIwpEwJTQ/DfopY33f+c/JFw+2h7PPCyOFGF+EVh59lUgWaZ+43SqLmSKaGIfYdq9
         wqn8jEMvuF0xL88hFbS8MrT1uGEaEl0V4loNhs8SYl9M/5quB5/O+ZSQsramOatQslAY
         CAIA==
X-Forwarded-Encrypted: i=1; AFNElJ8tPlhRwsmhoQ7Dw+SbKWpiTCUud8Qo4/VqgFzaIZ3YzxIHLaUjCiOtzzgo8uPR818Mx24r6pp5dIoY@vger.kernel.org
X-Gm-Message-State: AOJu0YxE4Bffi0+z1HJRMWfK94paOXJ/nnzElDGXcyRNlbyKUZl5UOyr
	ZF6gQJZLHp0yTorouJ6yx7g4hWVHwvmyFHV8h+Sgxo6rfxa4ggTqMBOWn2FFXTkAnsZQ2+itOE4
	kWAkn27D2dn6ctOyr8ogAkTOjfPDkKbK+iLCXbQihM1RnQZrnhBWO8fmL8No8ATw=
X-Gm-Gg: AeBDies3K4RrkPfwzTFUvXw9LKS5xwEgMR3dLiYTm0ELQ3MlQtyRHXcKPZXYc/ZDT77
	O6q5Tz05rv0KZ9zrrvRspveY0DWG6C181RiU516nuEXicqqmw66TaxUXflJO9iBS+HmpwjhGTTS
	iXMoxCYAw2bTPxx2lIy9rmjComeg69mLF1fcqGjUA/vczE8zcbsiZYtdCgqCp0bliCT1ivWnNWr
	sVL1/ppq8Cc46XrUekF78QYQRoZAlQpNZl1OKGVXutOjlvffHdSJCSNrrI2FRXS/AD56Vxo8COM
	lTQgIF72QnCpuJqqvuKtGmOTXcaTS3Q7HoKbHT/WZz9TUQABp6/yRVjHzu9Vby2uW8+2EDUiKVs
	4+oPXYfwnRv6rnlwRueSuiQ2goozczQN2WcWsxbIegTfJga5jJbcePISepujDLDYPi8GSjhR8CZ
	M36Lk=
X-Received: by 2002:a05:622a:5cd:b0:50f:c133:2dc6 with SMTP id d75a77b69052e-51475c0ff06mr12978331cf.19.1778118313440;
        Wed, 06 May 2026 18:45:13 -0700 (PDT)
X-Received: by 2002:a05:622a:5cd:b0:50f:c133:2dc6 with SMTP id d75a77b69052e-51475c0ff06mr12978171cf.19.1778118312849;
        Wed, 06 May 2026 18:45:12 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040908d6bsm163629391cf.7.2026.05.06.18.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 18:45:12 -0700 (PDT)
Message-ID: <9b49bda9e8e3dce89eaf969f452ddd2315c2f953.camel@redhat.com>
Subject: Re: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
From: Laurence Oberman <loberman@redhat.com>
To: Mateusz Nowicki <mateusz.nowicki@posteo.net>, don.brace@microchip.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, 
	storagedev@microchip.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Wed, 06 May 2026 21:45:11 -0400
In-Reply-To: <9624a8d152197522d353ef7bb2b4928d1c6238ae.camel@redhat.com>
References: <cover.1778075755.git.mateusz.nowicki@posteo.net>
	 <9624a8d152197522d353ef7bb2b4928d1c6238ae.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-05-06 at 18:21 -0400, Laurence Oberman wrote:
> On Wed, 2026-05-06 at 14:01 +0000, Mateusz Nowicki wrote:
> > A PCIe bus reset (e.g. "echo 1 > /sys/bus/pci/devices/<bdf>/reset")
> > on a
> > controller without FLR support leaves the HPE SR932i-p Gen10+
> > unusable
> > until reboot: smartpqi registers no pci_error_handlers, so the
> > driver
> > is not notified, firmware reverts to SIS mode, and all queue
> > mappings
> > are dropped while the driver still drives PQI.
> >=20
> > Patch 1 adds .reset_prepare / .reset_done reusing
> > pqi_ofa_ctrl_quiesce() / _unquiesce() / pqi_ctrl_init_resume().
> >=20
> > Patch 2 raises SIS_CTRL_READY_RESUME_TIMEOUT_SECS from 90s to 180s,
> > matching the cold-boot path; without this patch 1 fails at the SIS
> > ready check because firmware boot after reset takes ~125s on the
> > SR932i-p Gen10+.
> >=20
> > Tested on HPE SR932i-p Gen10+ against Linus' master at
> > 74fe02ce122a.
> >=20
> > Note: the From: header is my Posteo address because my employer's
> > SMTP
> > is unavailable for external mailing lists.=C2=A0 The Signed-off-by
> > carries
> > the Microchip attribution.
> >=20
> > Mateusz Nowicki (2):
> > =C2=A0 scsi: smartpqi: add pci_error_handlers for bus reset recovery
> > =C2=A0 scsi: smartpqi: increase SIS ctrl ready resume timeout to 180s
> >=20
> > =C2=A0drivers/scsi/smartpqi/smartpqi_init.c | 47
> > +++++++++++++++++++++++++++
> > =C2=A0drivers/scsi/smartpqi/smartpqi_sis.c=C2=A0 |=C2=A0 2 +-
> > =C2=A02 files changed, 48 insertions(+), 1 deletion(-)
> >=20
> > --
> > 2.43.0
> >=20
> >=20
> >=20
> Hello
>=20
> I did reproduce this so I am testing the patches as well.
> They look correct to me, I will reply again after testing with a
> review.
>=20
> Thanks
> Laurence
>=20
>=20
> [2513778.140012] smartpqi 0000:64:00.0: no heartbeat detected - last
> heartbeat count: 4207808511
> [2513778.140031] smartpqi 0000:64:00.0: controller offline: reason
> code
> 0x4 (no controller heartbeat detected)
> [2513778.141346] sd 1:0:0:0: [sda] tag#549 FAILED Result:
> hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D18s
> [2513778.141355] sd 1:0:0:0: [sda] tag#550 FAILED Result:=C2=A0
>=20
> "xfs_buf_ioend_handle_error+0xd5/0x3f0 [xfs]" at daddr 0x9f78 len 8
> error 5
> [2513778.141526] XFS (dm-0): log I/O error -5
>=20

Hello=20

For the series:

I tested the patches and it recovers with them applied.
The patches look good.

Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>

