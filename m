Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536113A963E;
	Thu, 17 Sep 2026 16:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663576; cv=none; b=jUVqt/RYZjnOzLyLPyd6pMer9MfRn5NcnkQ4MPHah5Bk6/Dc6pKGA0NLMdrz75fe5zZtEYuS61DTk8JDz4J4fG4HI4s6HqietWfQdeiiU5lXfhKKcOj7bbrZ/6CheYhjhaQc8PrJnL/xHPE6M+M1DFs+ikZlIO0m30aEtB//faQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663576; c=relaxed/simple;
	bh=+/6dP/tc8y91FwlyDopq/x0v1dZoVJ2RxSzY2tr973M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a5GyV+Us5aiWjuoiycnJ/u3Zy/xzukcYYkr/lUHjw3RuetDXd6J3Ffzg+Q6oscGY04ROoOVEkSqgf6wYwwJE6iTHWuHjmUJxF4z31zGPcYDD1jPoXw93rLzXJVMvLC8B530NN0ba8LAcngnYlM0cKoDeu6rF/t2lPW9OdWmNSf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfVPjIK7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfVPjIK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15051F000FF;
	Thu, 17 Sep 2026 16:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663574;
	bh=+/6dP/tc8y91FwlyDopq/x0v1dZoVJ2RxSzY2tr973M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hfVPjIK7tdl76eXtbjTQGTByiYpiKtjOZ6BvEqbmvXBTGbJO2wpOdjEdk69c8Avt9
	 Mi60UA6VEUd7EbQiCHt5nRLC+zEg8F1xoTkBVZu6cxKM+IZx6xbWZs2Pz4aQSthlLX
	 W8Gqbidtg4ALKChnqHSlg9da3YTAH/nB/b07zJTRpstCBoqRv5xpqKQ4Vsa4QUWq7q
	 HxZcvy9q7GwEmpZLmeLJCPryqOPmSINbThzAV37FRTinsmnEK8Phod2aLwS5+dl0ql
	 Zs55RiqrqjYRIf2ZVE3BFFWmxCJIFsAmRhkO4pt15XargE2NVzzzQ6mpfzZUV1pmjV
	 b+MSXv1sctw8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/9] driver core: prevent device_add() during system
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Danilo Krummrich" <dakr@kernel.org>, driver-core@lists.linux.dev, "Rafael
 J. Wysocki" <rafael@kernel.org>, "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, "Pasha Tatashin" <tatashin@google.com>, "Bjorn
 Helgaas" <helgaas@kernel.org>, "John Meneghini" <jmeneghi@redhat.com>, linux-scsi@vger.kernel.org, "John
 Garry" <john.g.garry@oracle.com>, Maurizio <mlombard@redhat.com>, "Jeremy
 Allison" <jallison@ciq.com>, linux-kernel@vger.kernel.org, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "Stuart Hayes" <stuart.w.hayes@gmail.com>, "Bart
 Van Assche" <bvanassche@acm.org>, "Ewan Milne" <emilne@redhat.com>, "Tarun
 Sahu" <tarunsahu@google.com>, kexec@lists.infradead.org, "Laurence Oberman" <loberman@redhat.com>
In-Reply-To: <20260917163744.191748-3-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-3-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:46:12 +0000
Message-Id: <20260917164612.F15051F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> From: Tarun Sahu <tarunsahu@google.com>
>=20
> In Async device shutdown, device_kset->list lock is released to handle
> asynchronisation and hold again to get entry from device_kset->list.
> Which will leave window when device_add can try to add the device to
> device_kset list and temper with ongoing shutdown process. New added
> device can be async type or sync type and might also introduce new
> dependency which can cause device_shutdown path to deadlock. S is
> waiting C to finish but C is never scheduled as it was added recently
> from device_add path. And C can only be scheduled when main loops
> continue to reach to C which is waiting on S.
>=20
> So, When a system enters shutdown (SYSTEM_HALT, SYSTEM_POWER_OFF, or
> SYSTEM_RESTART), new devices should not be allowed to be added.
> Adding system_state check (system_is_shutting_down()) to avoid
> device_add incase of these states of the system. And use srcu so the
> device shutdown operation can synchronize device_add and ensure any
> device_add in progress is finished.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D2

