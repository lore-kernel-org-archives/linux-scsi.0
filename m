Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792F343E9C6;
	Tue, 16 Jun 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624334; cv=none; b=m8ltIMTstzJt/ea6t8LDBwAkVP5EF53OY6huYN3OP91jJFkHhuCjqtevkad9qZ5m3bv6zz238r1vtCXuCcrtXVeZ3G3crqn53jEcY/u5LQ7QjAsLZgVVz1HKusR1ZU5njruy0PwtZ8+qNLZi6YiMyyak+zuScmYFP+a6rbzNB2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624334; c=relaxed/simple;
	bh=eDnx3iYplR7uQ43mTH4XymQ87kaCJUyzWDO5MjzewEU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZJ+An3uBFxVmDSZ2rsNENFg2+jdo/vgym6Ww9WIAkjodQf7vQvR+IkDlI1jNoM5VHc5ncof2j61BgF+vJ0erQI6DtxfKZbFL/MxLCmbEpfS0yw/jK99dt7gLbLzwjNydALEnQgAdkd+5WunJ3440dMXdkWpnu2klMal0VWh50gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhwCwHHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhwCwHHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174AC1F000E9;
	Tue, 16 Jun 2026 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781624333;
	bh=eDnx3iYplR7uQ43mTH4XymQ87kaCJUyzWDO5MjzewEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lhwCwHHK53oCm+1c7pbQj1uyTyWB8WeM3JhovpUEtTZfcBwvUkmjjrhdR9SuRI4f0
	 5Q9Kpuvt5u5O0npneTDnyn3EcDsGG1LBF47mw4KA5L3sQkJphZMwC6agqWV7mV06vS
	 2zqJY1O+ONiUbaxWCpgWO0TKWtq5xaaA6ZuVU5ElfHmc5iLCvoruIdAiaKdDYmIDH+
	 yg43X//YbCrsDSWKz5G0xrdP3I+cxKLZTRF+43/w/DZzy4ohO2fsEK0s4BRz3vNIRo
	 G1+cDCi8WMpam63ZC0ksJDg1s5xQuNHV07jsP2a2xZVntEBGYKpynh+ukynblAXHwA
	 Vu4xVKzMZRJaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] driver core: do not always lock parent in shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260616152219.6268-3-djeffery@redhat.com>
References: <20260616152219.6268-3-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 15:38:52 +0000
Message-Id: <20260616153853.174AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Don't lock a parent device unless it is needed in device_shutdown. This
> is in preparation for making device shutdown asynchronous, when it will
> be needed to allow children of a common parent to shut down
> simultaneously.
>=20
> And only acquire a reference to the parent device if the parent is to be
> locked.
>=20
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616152219.6268=
-1-djeffery@redhat.com?part=3D2

