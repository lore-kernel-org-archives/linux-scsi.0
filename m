Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231502;
	b=vtxe+9d8sN3GYujw2f4igrrXgZ6+4cY8kHE/9AM8HvQoHCj0gla1YctnvJ6f3lFC0bFx
	 99zo9jIzIwVXTpg6MbL9rVazZ7osGTQc5eyB5jVfOZr10W9xhZUdr9ZLzqrfWXVXai/XK
	 vX8Z2EgjZqMhwPbmyZJyzVbiZUgaofPefe9lQNEQ2V6GFpYynqWwbPR0yU44HA53CWPf4
	 lql2G5Nb7DXP/QF9iHck2HByllhfJAZwLQI9uipmyxVXQtZVd9EVNCPQVs1R99QVvSQj4
	 uze0rOUTzg+Lj+ZDLUijewre0DzfBGC/qVoD4FuLoYwyZeDC6UxtqmXvFmNWsV9GHhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=lvSyLytB5SwO0LPvkN3MPCaXDUFv1bn9tN9WJbt8r6Q=;
	b=uGmHf7HZ6N2qOdIhiUK0hZDlnUSrZEyAzCMrSX062KHN1VpCbldoLPCZzCOdL8GfBjgJ
	 bOW0enWslM0fpelBfkM7d7TrWc9/z0V7/w0mwYVTW6hxCgk2Qfzj9JQEJqLWh6SiGgR3Z
	 JFkghamkPVZoMBM9Cs5yKd97b0JAtmA/ay3CHbUFJyKUR01AZhFdj8WBEKHjzDT/FnK7s
	 d6IHVxY/XTXNnblBnDuwJSAlRw8yEXzq65zMqJXow8wXYNud29EoXnyoo5dojkmovMyOj
	 KXqWoeOTIszlpqlAIPJNGre3WImNl0gGsDkM+JPl7B/EROpqUuvdU9neslITT1K+hZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hsisy7x6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84C4606A338;
	Sat, 21 Nov 2026 03:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hsisy7x6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B841F000C4;
	Sat, 21 Nov 2026 03:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231502;
	bh=lvSyLytB5SwO0LPvkN3MPCaXDUFv1bn9tN9WJbt8r6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hsisy7x69QPQ4mQwO4vYWpJz+wIDoJQ4ef4aQSyHktC3aEINhK04Te27z1g0G7Kp7
	 8XMVIWb+aMqntPnuq6w+93RPo0FaYsEFZcrZLhkKWCgcR618edK4Df/UQBzjeJhuEg
	 wgzEkk3n/AnrJUzegdazauo1dkdkUhQsiHLPue2CcgzsdjH3r9yEw3uUtOF8jrEXpU
	 +o2WWIKctUmF5fRDw1utuoYTb9q3X9R4+wNn0bV914HIcryTVHL4gyfP6i8N6qck8y
	 aOxTo8+oob+szDQC6kWDHcyGTZitotQftopsxrJMesS+YjUATveKtb7ZmSe42gbb/A
	 IaNTT3YU2qrRA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Ciro Iriarte <ciro.iriarte+software@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: compare all six ISID bytes when identifying a nexus
Date: Fri, 20 Nov 2026 22:24:49 -0500
Message-ID: <179523145636.420187.17732155640521575769.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <8b1ac7d9-b0e4-42ac-b8a2-c4c70cccdddc@gmail.com>
References: <8b1ac7d9-b0e4-42ac-b8a2-c4c70cccdddc@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 09 Nov 2026 11:31:01 -0300, Ciro Iriarte wrote:

> lio_sess_get_initiator_sid() reports the ISID as twelve hex digits, and
> iSCSI TransportIDs carry the same digits. __transport_register_session(),
> __core_scsi3_do_alloc_registration() and
> core_scsi3_alloc_aptpl_registration() turn that text into
> sess_bin_isid and pr_reg_bin_isid with get_unaligned_be64(), which takes
> the first eight characters, i.e. the first four ISID bytes.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: target: compare all six ISID bytes when identifying a nexus
      https://git.kernel.org/mkp/scsi/c/fb8fd1da808f

-- 
Martin K. Petersen
