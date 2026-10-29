Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239389;
	b=GnS+F9oCI9leoIaoG8S3mpBcSLhHJCcKh33TLaCKfCBTnuoulxyYVjQb6KtKKNBaXPqr
	 4JfzVmFvDzHUkWmhTYsFcbl8T6/63vd1Gk7sR0FhWxnTCjpppJH9eyK2j1l9Ki3dCIrCq
	 pR9wGDCdOTKJg6d8C2RO9fKt8QdFQCh9ymjFHqtyO5T394p7Q9aD7Txn60w69u4NhaqqG
	 ktPD891i0goU0fDW1PIhSED0qXDLiWSoJ9tkznK+traZq5W9JzDbYToZHXSAuxLWW0Zvk
	 ryRgJNlmzf6M5qxq5h/8vGBIrSEa5RMmcaAXyxJW0vB8g7nBQULY0wvRz2wX8OQf9GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=J3FncaVpBH0gFfOJM7zYxtZCC9tftKVM0upID9pBylE=;
	b=OWwqBZQ0iHL1aD8lJBL4w6BKayqZRYasSDdwIBo9PaVW5GTjjYs2vmjPU63RmRQ2uDJp
	 8e+zA+b68BZ2Dh4K4RmD6EdipSUnyxeg7/fDKIsCSHr0DPn/ZgnO+1S/o7M8iCDjzv2tM
	 3mveSEJmeBP7Bcc0Vc9tosrqku9L2uw3I05aCM6CBLNc74s03oS5RF7O4GWA2SJ+RvZ/T
	 N7CrHjYnQTntoHGjB/7HpkZYMXQL/creHeXUeiaH61PnhffzbakXT2/lVSEqEs+06G0KT
	 EF+IompLYgqCRdmou0tlxXYho5eA81nSXAEz86NYXMASsbGzlBxJ6+vthGvC8RzuV3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QOnfenqt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2A9606A32E
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QOnfenqt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA4F1F01829;
	Thu, 29 Oct 2026 02:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239389;
	bh=J3FncaVpBH0gFfOJM7zYxtZCC9tftKVM0upID9pBylE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOnfenqtbmeQRnDPNB+rbLY/PeEQPd21Tg14pdSPwLUfO6Ldey8k+0AVSqWMC0MWc
	 RwpA7xr5CUWB0rgI18ulouq40eMU9pafzPUJkU0IwR3OH6gOfF28kwFMAku9sEoyMp
	 NI9Q1BVpr+1v5puyUDMwyk/hhPdddd/Ydchdrdbj72rmfvSE/IAUS2h/JVpz42i1iL
	 UZwirXvDxUi5VpJ5RIWg4H0mi4XwYJTXYDjN8lAK7KO0pYGThIoMVCEC25T+78ZSuC
	 9GjYACveEePBl3SDXbC71ZNfrIjQ4Pt3soXfkZe6ve5di8FCzCP2jS3vSvsJDJvL5j
	 3ZCGzY6G2EyVw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH] scsi: core: Document the role of scsi_done()
Date: Wed, 28 Oct 2026 22:02:46 -0400
Message-ID: <179323465373.491807.11484714107070458544.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <6edb00749da7a5ce9b7752d389ad2ed5a38776e4.1792022610.git.bvanassche@acm.org>
References: <6edb00749da7a5ce9b7752d389ad2ed5a38776e4.1792022610.git.bvanassche@acm.org>
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

On Wed, 14 Oct 2026 17:05:10 -0700, Bart Van Assche wrote:

> Document the role of scsi_done() and also how it deals with commands owned
> by the SCSI error handler.

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: core: Document the role of scsi_done()
      https://git.kernel.org/mkp/scsi/c/cfb7224381c9

-- 
Martin K. Petersen
