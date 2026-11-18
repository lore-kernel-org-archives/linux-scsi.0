Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977372;
	b=JSQY1U2q2k4CUTj1l4pQPHUtfmOojgIvzL5+QeAlEPOWH1hw1+jQsdAPvsgOjBCa6tXe
	 H619GVoAw0rNhwp2jN9Gj45RDhJfDUaJNkqtg5S66VzIgeIST6fY12yWYLELim+4lEoTF
	 CVgTV6YzVTVqxR9gUTNN+URbZZX7ZNF+FG0BujaTeocGUrFerwm7eM05Zpg/ktHteao4D
	 7aDLY3bvRLxhOxQTjEgml4hUnfDKJayvsbEHUzFYTjrQLzyYA6WFfWaBHcQCZPk9oop8t
	 P6JgXbERqgJcA04+T0W77yYvAKFuSgPzjKSQ0uC8icx2uX3cJsVhUwdPZdFPRfzZGPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=OCHqk2PeXDufw9vwABnpKQSKDmIYyMW8BLs0qfjELmU=;
	b=jLh6siRAayP42G3wl0TJ2IE6lhY2GXQjI2k4/CttRBRVjDRxR2nya9gqF4Xv8VSy3ao7
	 /vRvczVhPsNH9Zr+CW5XhNcelImyEp/c5stMB7GxkcO+jLIQ/kmC92oRKc0Gh6prsmevD
	 GYqIqQuH4f/KLcGHaStLku2WmZ3V4gbgCaNuqcM5AHiGcngsyZ7flDBzC5QmTzxHnNjOy
	 6HwEOVQFoW1h+x2FS71cFV+E8WVYgkxe8Svzc6x+tEboxEoAR6UNoL2yfT/LCZDi5xgHq
	 gTn2ckUfzxBZ5wF3ds4cip8TwGxzhMGzZIr+iupdOvRUgH7dR7S4uxv0nfvxG8YrFIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSKqfLTu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC4E606A31C;
	Wed, 18 Nov 2026 04:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSKqfLTu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD94C1F000C4;
	Wed, 18 Nov 2026 04:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977371;
	bh=OCHqk2PeXDufw9vwABnpKQSKDmIYyMW8BLs0qfjELmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSKqfLTu5yoH+z5awZ0OqbMy7czQFEMw1J23XrAtz7GiPnM2OwHVVWxdcAHBcr9oT
	 zNH5tC9SExbAaKbPjqgI5B/6k3ORXuJndfOqxrQYPv50lSG9ZHu4dr4cDth75qpNKI
	 8w1GvqLF3yavZNMV0qzdK7WUq94NVv05Yr/kF+0OWdHyB7kQcLna36BeGxRVP40DZb
	 eTh/eEyGcxzpceo/MqQbVfgONMbxrClWVdTrSPn5a4UeHG6mtZwemZqd7aPmX2LZp+
	 lRjTHmZGHE1hNc9F4u7xT3tMpD0vLl9D5vMad1ENqwUk5nsi2RVHxHusDuZdSniLhs
	 96Xa2EZw2WYcw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Niklas Cassel <cassel@kernel.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	stable@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: scsi_ioctl: require write access for the depopulation commands
Date: Tue, 17 Nov 2026 23:49:20 -0500
Message-ID: <179497726100.2093762.8374047680850209324.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117122952.3451870-2-cassel@kernel.org>
References: <20261117122952.3451870-2-cassel@kernel.org>
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

On Tue, 17 Nov 2026 13:29:53 +0100, Niklas Cassel wrote:

> scsi_cmd_allowed() lets anybody who can open a SCSI device, even
> read-only, send any SERVICE ACTION IN(16) command. Besides READ
> CAPACITY(16) and the other read-only service actions, that opcode also
> carries the storage element depopulation commands of SBC-4: REMOVE
> ELEMENT AND TRUNCATE, RESTORE ELEMENTS AND REBUILD and REMOVE ELEMENT
> AND MODIFY ZONES. These change the capacity of the device, and after
> REMOVE ELEMENT AND TRUNCATE the data on the device is most likely gone.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: scsi_ioctl: require write access for the depopulation commands
      https://git.kernel.org/mkp/scsi/c/040d27029306

-- 
Martin K. Petersen
