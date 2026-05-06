Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04600214A84
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 22:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778106109; cv=none; b=omKydcMv1bhhpyUT7d18CzVGvavCs/bmOyQOFJbSDzzh9QWE2xqIdDJ0XlkgCxl9BIfDF2XhpiEjSkomAbByt3BinDbUhIeK5EG32oBDv2AMVpHO2wAYlfY80pq7WrhVBwijC5hc2CZ7vFhOTfPS7gaW3FxPoADLmAtTPURysNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778106109; c=relaxed/simple;
	bh=2juvgxjW5b9ZVDatfg1vz08IAt5uhUG2nGLLSx9mCL0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=diIm0OUmhy2vkOD27VlekQxypBoCgLaOqTWaJllTYcfE9a5wrXdcBbex/hQTF3OisNFQZ1XBlgyXVqANriiMrg/bDgUnf/1NSHcy6K15HHs8KEXjrLIS5umLK4V1valscnHrcMgcWwF6Y398HQEdS3f3iizmdldotWE2jKXf+dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=esnaY6OC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IGMgD6Ux; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="esnaY6OC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IGMgD6Ux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778106107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2juvgxjW5b9ZVDatfg1vz08IAt5uhUG2nGLLSx9mCL0=;
	b=esnaY6OCxUHTkrtY0C7kb2Mtgdo/oYY0JRuNG+dbBwlVAYTsEiLGxy2EcYkMvY18lma5fA
	h3tZS4byBRaR4siBJH+DM4eqf7h99CH2YVelm9QqwHHeej6mbSL7OTZfOFVYfIL8O18QPS
	QQ8DJ/pgRkYh/pZ5fzJHPGF2EIM1a7g=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-wFEht51ZNXmpD2mITyRh2Q-1; Wed, 06 May 2026 18:21:45 -0400
X-MC-Unique: wFEht51ZNXmpD2mITyRh2Q-1
X-Mimecast-MFC-AGG-ID: wFEht51ZNXmpD2mITyRh2Q_1778106105
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50edf0245b0so2460581cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2026 15:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778106105; x=1778710905; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2juvgxjW5b9ZVDatfg1vz08IAt5uhUG2nGLLSx9mCL0=;
        b=IGMgD6Uxe+eFouI6+MWdadMYSQfyADEPPLIYufIEYcmvZftLyrl0L05/qkhNdpGOyI
         jKIJcqWKOfb+eEE+lBrb3ILzsoroARwt4lAMoBHMLJ7uzBY5VgvjBGxE5K6YSsVsMwGG
         7JHWEvu/RUgB8Lm0BRyzkR0hy5+4HtUNOAGz9pJOsMgQndMzl1SSRYI9nmKoIs53tepq
         m4kzzk2lTQE+YnTfZEwIAlKDIztshc0YzzfCRp4rE4fBI/GvGY3yYtIhv4IMGhhjMONs
         pwGer4D69LVWCEXtv67pFbEuU1ZqX0aGKqU9W+XEu00FVMrXmdwBmcVdhkEDFFMYlXy9
         XjCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778106105; x=1778710905;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2juvgxjW5b9ZVDatfg1vz08IAt5uhUG2nGLLSx9mCL0=;
        b=rpGomEyt/2cYGxr7btiI5oSsy+Vkjxv5InzHWQjZRcM0qIh9Jp/pQw7RXbRpKAgyDh
         mFeSqpPdFnsaCdbegB/cYTyBsTmifJzEfkYqyvtVRYD1kyPy4EoyX3hqz2TRtnyDpdvr
         ivrwXvXynpNGkZp7pEaz9pdntpLzrG/2kkBI5aMw2l1uXAsnaWdvr2ckovQAP4JzMXGf
         7M+/8aLdp8ySi+SIUquARYVC3DfBgfc9mUbc3mIL0RvCIeZAWqAGOOaur6b53ry6de6O
         tUEnsrBzCWJv+SLwCEmFzjSn2sa1WTdWbwQ/BMbC8jRXZBD/a23NtduGB8ptt6UZ4lPZ
         jGMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rjA5ywn+FIo2k+ntpr+9xAE9/6C/gNHg1aQwMOfobDkg5yce2Y4mHwzTbjDnrqvTEGpXiIVMMPbVK@vger.kernel.org
X-Gm-Message-State: AOJu0YyY1nEXZdp8Kucr5PupIkLWs3WMVeFkd+WcOrgnG/lkqsrX1Lhr
	nF8YERd9aaes8xrsVTyuF3PdiHbEwiEqG5N6aO358LUetx95C9HSwN249tUSyOI9fWyxJXaLCRT
	O87oq0C5T9+WcCFU1TcmZNE4DrT8tgxLM8b9jU02IdC8eKsUkRdwq5UwjFZep+8I=
X-Gm-Gg: AeBDievJNuY75Abx2wbms1TF8s4SIe2PJkdKIb4ivaGC402FQAg0ST7Sy/9jEIuogCG
	IJomsi1f4iy+aakR+4JGXAxlyAyko/TB7hWC37UV/ppn59sKUqi0QfFF/QbQtBpXvW49uRW20ll
	zJX24V08nI/7awYsalC2rpCje2qmj9pKIrVmQ9PNLckhiLXwHaKdmyrfgS9J3wLFL63v+J0N1HE
	FRsvIVfDeecEoX90K6Bz9BPRxKgk6IaZZM5YcF0dLTV4ObU9MHiNBa22yAKY/0rkIW9zaDXvCHO
	/cmyndaE5OgOLP7Mzw5jXTJzsqqxRqlqpAJcI+1BCjF4AKcc/8/HC/CX2hZlQ8O9Qj2DNTgzPyA
	JTI1SGWMV+9GhtYsBp2P+R+9upkUOwMM/SiNZTzMat1uZkaK0/XuDkQprowwZ8pvtQr1w
X-Received: by 2002:a05:622a:8ce:b0:50f:783f:31a6 with SMTP id d75a77b69052e-51461f7e899mr77483401cf.38.1778106105145;
        Wed, 06 May 2026 15:21:45 -0700 (PDT)
X-Received: by 2002:a05:622a:8ce:b0:50f:783f:31a6 with SMTP id d75a77b69052e-51461f7e899mr77483081cf.38.1778106104727;
        Wed, 06 May 2026 15:21:44 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5104090bb03sm160576221cf.10.2026.05.06.15.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 15:21:43 -0700 (PDT)
Message-ID: <9624a8d152197522d353ef7bb2b4928d1c6238ae.camel@redhat.com>
Subject: Re: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
From: Laurence Oberman <loberman@redhat.com>
To: Mateusz Nowicki <mateusz.nowicki@posteo.net>, don.brace@microchip.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, 
	storagedev@microchip.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Wed, 06 May 2026 18:21:41 -0400
In-Reply-To: <cover.1778075755.git.mateusz.nowicki@posteo.net>
References: <cover.1778075755.git.mateusz.nowicki@posteo.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-05-06 at 14:01 +0000, Mateusz Nowicki wrote:
> A PCIe bus reset (e.g. "echo 1 > /sys/bus/pci/devices/<bdf>/reset")
> on a
> controller without FLR support leaves the HPE SR932i-p Gen10+
> unusable
> until reboot: smartpqi registers no pci_error_handlers, so the driver
> is not notified, firmware reverts to SIS mode, and all queue mappings
> are dropped while the driver still drives PQI.
>=20
> Patch 1 adds .reset_prepare / .reset_done reusing
> pqi_ofa_ctrl_quiesce() / _unquiesce() / pqi_ctrl_init_resume().
>=20
> Patch 2 raises SIS_CTRL_READY_RESUME_TIMEOUT_SECS from 90s to 180s,
> matching the cold-boot path; without this patch 1 fails at the SIS
> ready check because firmware boot after reset takes ~125s on the
> SR932i-p Gen10+.
>=20
> Tested on HPE SR932i-p Gen10+ against Linus' master at 74fe02ce122a.
>=20
> Note: the From: header is my Posteo address because my employer's
> SMTP
> is unavailable for external mailing lists.=C2=A0 The Signed-off-by carrie=
s
> the Microchip attribution.
>=20
> Mateusz Nowicki (2):
> =C2=A0 scsi: smartpqi: add pci_error_handlers for bus reset recovery
> =C2=A0 scsi: smartpqi: increase SIS ctrl ready resume timeout to 180s
>=20
> =C2=A0drivers/scsi/smartpqi/smartpqi_init.c | 47
> +++++++++++++++++++++++++++
> =C2=A0drivers/scsi/smartpqi/smartpqi_sis.c=C2=A0 |=C2=A0 2 +-
> =C2=A02 files changed, 48 insertions(+), 1 deletion(-)
>=20
> --
> 2.43.0
>=20
>=20
>=20
Hello

I did reproduce this so I am testing the patches as well.
They look correct to me, I will reply again after testing with a
review.

Thanks
Laurence


[2513778.140012] smartpqi 0000:64:00.0: no heartbeat detected - last
heartbeat count: 4207808511
[2513778.140031] smartpqi 0000:64:00.0: controller offline: reason code
0x4 (no controller heartbeat detected)
[2513778.141346] sd 1:0:0:0: [sda] tag#549 FAILED Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D18s
[2513778.141355] sd 1:0:0:0: [sda] tag#550 FAILED Result:=C2=A0

"xfs_buf_ioend_handle_error+0xd5/0x3f0 [xfs]" at daddr 0x9f78 len 8
error 5
[2513778.141526] XFS (dm-0): log I/O error -5


