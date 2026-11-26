Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664116;
	b=ND/lRbRMV4NnuRjfmQIhv7XWGoJZvWiDJnzSmbMIu5+9EC+ZDlr9HiSEubYbdg+PSU+z
	 uqNpVZNr+WkXkH2zIbgXr/EYAe4bbrQQK4wT4D6pmDrT+72W4zjucI9Nnd+4/oDf9utsg
	 N+t4saSnYXNB7Q6pmq1BTmd37/quvIktWbVjzhJtc1/3kj4ssRBxcCLHMXUgROd93Uuj9
	 Yd0lbx+Pbw1Y9xy8pTFBLUgE28wiKo82R0MTii3miTfzEtSs9d8Z2J4uAD7u+Svdr3iHE
	 AEYpoF2DsbGgtjIebae1aDrBWXuZumzrJrJndxe4xUU2VYZCLpgmhSKTL48Iz2khKDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=74k3A1mvZKRD9oHJaqDoU3OL+iKBd00+OZL7CPLuCzw=;
	b=SBCrtmeSWp3TbSGrkS2QsU171HQjkrXu7g8txYgsN7zxgatCrww4sLAstExwQJxtv9tR
	 np4IdCXGwBd4L33lNyk3dAXpc8tkQWaYNW0/SvKP6G1/RhFqiVircbS0uw7RKWnR1C1+r
	 OBNQaOqwcA64aPpqzpNRzS8iPmjTMbDUGCrArsBGjzCxoGUPrD6NiZFRYgRTByvFUoDx3
	 nSfOsdwX5RreqXqGDN6msPSj/vnCu2c+JbZPEo0ZBmq3lykYJT5q2mR4LwUcPZcX+HCdN
	 mKh3N9QQNShsQ7VvCU8BH11LpfuY1xM1yejcNZFqWZtaMhVfNk0dRdEMuj+m5NlOQ3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cs1C4Aj2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19704606A32E;
	Thu, 26 Nov 2026 03:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cs1C4Aj2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DF61F000D2;
	Thu, 26 Nov 2026 03:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664115;
	bh=74k3A1mvZKRD9oHJaqDoU3OL+iKBd00+OZL7CPLuCzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cs1C4Aj2dFSEvnYHbiXp/0HybyMpvIEXk0gHhvAZzSII5Ir6M9uWKrfl51RtfLt1w
	 QoZE27aPysCF//WWLYm1g9G+FbVKUekIX6/gK+ODUbTYjEiiI6gVl+dkdDZafTSrnt
	 KJRwrvtIYecXZs18pSmIqBo91H0ktExIh/ECkO9N4CRcspuN9pLw7TY2Q9ZssDEOjf
	 R7Y5ydUSGtfgT6Bl2Rspi3WWHqXbKW8pfgo5InY88NRFdMr2N6GzOT78uudYJfXwa8
	 RR4/lYloANDsCOa/nWhCLBOt7YVXh9NLatXV/Uo3Y/X9TwSFQV/DwNtRZfNAx5if/j
	 LxcgcPGhXRFow==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Adam Radford <aradford@gmail.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	Don Brace <don.brace@microchip.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Brian King <brking@us.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Kees Cook <kees@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	target-devel@vger.kernel.org,
	storagedev@microchip.com,
	megaraidlinux.pdl@broadcom.com,
	Markus Schneider-Pargmann <msp@baylibre.com>
Subject: Re: [PATCH RESEND] scsi: Consistently define pci_device_ids using named initializers
Date: Wed, 25 Nov 2026 22:34:54 -0500
Message-ID: <179566062790.467514.15408147834251467411.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261111183844.1906794-2-u.kleine-koenig@baylibre.com>
References: <20261111183844.1906794-2-u.kleine-koenig@baylibre.com>
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

On Wed, 11 Nov 2026 19:38:43 +0100, Uwe Kleine-König (The Capable Hub) wrote:

> ... and PCI device helpers.
> 
> The various struct pci_device_id arrays were initialized mostly by one
> of the PCI_DEVICE macros and then list expressions. The latter isn't
> easily readable if you're not into PCI. Using named initializers is more
> explicit and thus easier to parse.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: Consistently define pci_device_ids using named initializers
      https://git.kernel.org/mkp/scsi/c/002ab4954ef6

-- 
Martin K. Petersen
