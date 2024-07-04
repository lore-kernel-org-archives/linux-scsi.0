Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8094518637;
	Thu,  4 Jul 2024 10:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720087363; cv=none; b=m5kiGRMVG4Dob1XoL5oQUBSxMHYRQ0+s9IFqSBYoyYqOHKETwFUKoUpjb4Ukn/Hfi+i37A+Yi/HnnlT80aEzaQKxaGXZkRyQ3Z8fysbejqZn4Na3wLthvZs9d1iZ5aec/yvbg5rZ2lvQyl/tLnD8gNH86ksfEm/umM18U9yawB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720087363; c=relaxed/simple;
	bh=zp+09GYfSGBnAdWrCJ8xdF8ztB0EzczqTKtEHYTDfJg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=knei8J6uXHdojF8bNQZnImmH7pJWnflayNSENFKxKnA6eMhakjVUMGY286ZimOVCg3bZaLigwmNAhlp5KJ0cdNLQKSWtnoVnFKaygektbgV628uZvrzr4gs6zydeRuW0xeNYTs5dr/myqrNLHvK4ruIG0a+iJGRSZPKEkuaPTTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f73nBPE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f73nBPE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40430C3277B;
	Thu,  4 Jul 2024 10:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720087363;
	bh=zp+09GYfSGBnAdWrCJ8xdF8ztB0EzczqTKtEHYTDfJg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=f73nBPE46ZS874nUtNgj2BE24XMOk9BUODo/U1JAX/vKd7r4/xso4gBhmNswZcejq
	 jasTNJgsgmf4dJkrASKI+Gpd7WQpa6er/GnY/+qfi/da1gJqPV/nolf6hkR4PPywCP
	 cxKu+dMQfYv/PQ9BNEVDJ6261X4+6Jo/Rae1Tan3ysey0AWOei0Ajdy9xaL8s0H8G+
	 0qykS/bDiHQTaxN8cMQXoRnOFr2pGmiWSaqSiHcFyTn80tXVGO7x6xzPIo26/KXyo1
	 rXvLltPHUAHa1i386V+4OPg2K4wCTWjQHIf9uyP0sQsWPxcMWcLqnbOS7WW3jsxDAK
	 mI6u99Zq0kQrA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>, 
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Subject: Re: [PATCH v4 0/9] ata,libsas: Assign the unique id used for
 printing earlier
Message-Id: <172008736094.754155.9837088933275782567.b4-ty@kernel.org>
Date: Thu, 04 Jul 2024 12:02:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0

On Wed, 03 Jul 2024 20:44:17 +0200, Niklas Cassel wrote:
> This series moves the assignment of ap->print_id, which is used as a
> unique id for each port, earlier, such that we can use the ata_port_*
> print functions even before the ata_host has been registered.
> 
> While the patch series was orginally meant to simply assign a unique
> id used for printing earlier (ap->print_id), it has since grown to
> also include cleanups related to ata_port_alloc() (since ap->print_id
> is now assigned in ata_port_alloc()).
> 
> [...]

Applied to libata/linux.git (for-6.11), thanks!

[1/9] ata,scsi: Remove wrappers ata_sas_tport_{add,delete}()
      https://git.kernel.org/libata/linux/c/c10bc561
[2/9] ata: libata: Remove unused function declaration for ata_scsi_detect()
      https://git.kernel.org/libata/linux/c/2199d6ff
[3/9] ata: libata-core: Remove support for decreasing the number of ports
      https://git.kernel.org/libata/linux/c/23262cce
[4/9] ata: libata-sata: Remove superfluous assignment in ata_sas_port_alloc()
      https://git.kernel.org/libata/linux/c/6933eb8e
[5/9] ata: libata-core: Remove local_port_no struct member
      https://git.kernel.org/libata/linux/c/1dd63a6b
[6/9] ata: libata: Assign print_id at port allocation time
      https://git.kernel.org/libata/linux/c/1c1fbb86
[7/9] ata: libata-core: Reuse available ata_port print_ids
      https://git.kernel.org/libata/linux/c/1228713c
[8/9] ata,scsi: Remove wrapper ata_sas_port_alloc()
      https://git.kernel.org/libata/linux/c/0d3603ac
[9/9] ata: ahci: Add debug print for external port
      https://git.kernel.org/libata/linux/c/f97106b1

Kind regards,
Niklas

