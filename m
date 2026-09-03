Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A857B35E958;
	Thu,  3 Sep 2026 03:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405038; cv=none; b=Ijr0Wh4ZxQ/NLE6QqDdsbhGiW6e3IoKskYc6r5iPfZIJ2pAJ0gzj0KuDLLRRlix2SENDazaXyPktnmzlquRJYDc89U9QVjtxhvWIR3AcKmAW10XwdQ1fkXyRYoGfJu8HbLrow05/XQ1yP77XuGUTUlGkz0GAHgXGOyk1R3wMua0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405038; c=relaxed/simple;
	bh=b+aBQT6mcYtDqIjLs8WpZtomcOm9+Z/ikYg+Y4ZRYGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRHP5E39KIO3SaAL/68G9z7vPeV7LpIdJSZcAusII/oglrTSX66usMaWb4XSNwJ7qQDWyAmQ/7uN/7zG2/jNgw0y893HCF57oAAdx75nOYyko/C5FKea7fWaHFbBHo8Ei+ziXqmx9SX0TrB0qEK2GBmlld3BjcICzn4girje8n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVX+3lFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVX+3lFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72801F00A3E;
	Thu,  3 Sep 2026 03:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405035;
	bh=yybKu6oeC5BMhqO6e+ZFcCSMZjL+gU7ig8BylD5OMf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVX+3lFoburDDKWX4GeJV5DPLSfhB6PyhMuFWMFWIHUncoAZzjwEi2ROTw6No7qhg
	 1J4nRmG8cxc4QeNt4bqeHfy9Sw+jkOxY68AtiKLhkDdsFolZNfqaPInw+hy1s3Dhju
	 N/Ij8Zlxk7Mh1pE4ID2tBKVnByoWMJVliOqmdu0f6PMHXEBeV6qUnAWOr5hMB0Iuzw
	 uYbmr4NzPwmzSZ0AqcDRiYYBWItadj4d3mPaUaeBI7W2z0I8iFP+UrReO3YmiQXQ+/
	 Vv1BCznrT2ep6cAO9duftNC4CnPGRKsV9a9hjj5lld82LEZWWY9Rlxo/mA4gExLMDD
	 PfC8Csz3boLkQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	sangram kumar yerra <sangram.k.y@intel.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	adrian.hunter@intel.com
Subject: Re: [PATCH 0/2] scsi: ufs: ufs-pci: Intel UFS 4.0 HS-Gear5 and MCQ support
Date: Wed,  2 Sep 2026 23:10:14 -0400
Message-ID: <178840472591.670675.2465069974924053457.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818112830.453402-1-sangram.k.y@intel.com>
References: <20260818112830.453402-1-sangram.k.y@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 18 Aug 2026 16:58:28 +0530, sangram kumar yerra wrote:

> 096cd6b7adf2 ("scsi: ufs: ufs-pci: Add support for Intel Nova Lake")
> added the PCI ID for Intel's UFS 4.0 controller (8086:D335), reusing
> the existing Meteor Lake variant operations table. That table is
> missing two things this controller needs to work correctly at UFS 4.0
> capability: a PA_INITIAL_ADAPT sequence for reliable HS-Gear5 link
> training, and the MCQ resource/runtime-config hooks required for
> ufshcd_alloc_mcq() to succeed. Without either, the controller still
> works, but silently falls back to Gear5 link instability or legacy
> single-doorbell mode respectively.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/2] scsi: ufs: ufs-pci: Add support for Intel UFS 4.0 HS-Gear5
      https://git.kernel.org/mkp/scsi/c/ef675ea16845
[2/2] scsi: ufs: ufs-pci: Add MCQ support for Intel UFS 4.0 controllers
      https://git.kernel.org/mkp/scsi/c/c46cc9cee39b

-- 
Martin K. Petersen
