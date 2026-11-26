Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664104;
	b=a6f4DD3wPQUC+Av2tCc5RSJJP8UwjHLARwTZ4ihWPo1IuHGKoScvpGH4YDiRTy3zzKhx
	 9Nm3vXq3QWXcTiM0mmTBoCk8obz5DVbxU2GwKt0AQa1g29jEJYSuL0aVQYaK7kksrq6hN
	 4vsw+82s2OA5++rpIedwn2KhPP+Hz87NHFwpSbpL1NHrdxvw+IOTmFDgVIrZA29BF3IKz
	 c+zkkVYeoX3Yev9AzamcsDoznBVFfxmw6cX6CKew8NNXn+wF6anLldD78J0FiGNgw6qNL
	 QKgZjVkPTsJNn9J8QgpGnVqYd9KTFoe5Er2Y3FiGv0kzSMSsfyEoK8UtiFLv9y9iFOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SNzlUXCzS73GDExImdsElyfHed5Slh8u+Lp1Xic81rY=;
	b=jdZBC8jsftKrSRP2VJ+rXEgG7rPVt64CPRj3DytY2j/3TtkVE1ax1vH8bupWvdtHK9O5
	 jaPAH6SkYJRuMGeFzonJ8pduEgV8fH0s7RNcCaRGb6+d3y5JkRwQPBlJwWHFyny2hEMcS
	 JWTcIb6s9NpWJTy+Q+V7JA28D8fwUnES5kGJlpWJtRoFxVc01C3oWaryTOsdLRFpa6gsI
	 oDEohzRBhWxvlV9jK/58PyG2ZsV1L8Py1i3WJGJSsBIadC+R5nX4CkB/Ff6moP0t814u1
	 PFt+Jf9b13S3mPsKglDFHsAFRzstmt8kUv2nlTeAXHEKOjbM6tjTgqn51ikrXiZ9elA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KPJ8Nrdm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DD2606A33F;
	Thu, 26 Nov 2026 03:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KPJ8Nrdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94E31F000C0;
	Thu, 26 Nov 2026 03:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664104;
	bh=SNzlUXCzS73GDExImdsElyfHed5Slh8u+Lp1Xic81rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPJ8Nrdmrnkz1OgebsRqZEZwUwQxi85b9NgfNuFyukoGdkCI/VDOMs3+f2N319NgX
	 gFYJDfE6V42UBsM3OUuN2rQaha64aXFKv8fxQypKwECfir1o3rk1s/86YkbZr5VaaD
	 lZp08PXwajOg0U1BvIRZd8OEUhCwGUMV53UHi6X3sPgr1IWCe42yA2AwFT7SX/IPUW
	 u7HBfe7xN/zAhU55GkyU4yfGGY/vvB+/lUcIkJkvxMPwXL6ZBmDwgPuq0pO9PSnUfc
	 aRL+/3rCyyrRJ6bNV3T74cTzHfo17khc7Hb/DMP1pZ+z9n/x6QJFhEJv+Ai1sxC2t6
	 JWdFr9bQj66WQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	Tim Douglas <me@timdoug.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: esp_scsi: report the residual byte count
Date: Wed, 25 Nov 2026 22:34:49 -0500
Message-ID: <179566062770.467514.1547216328115232639.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118003746.61659-1-me@timdoug.com>
References: <20261118003746.61659-1-me@timdoug.com>
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

On Tue, 17 Nov 2026 19:37:46 -0500, Tim Douglas wrote:

> The ESP core tracks the number of bytes left to transfer in tot_residue
> but does not report that count to the SCSI midlayer. As a result, SG_IO
> returns a residual of zero even when a target transfers fewer bytes than
> requested, as can happen with INQUIRY and MODE SENSE.
> 
> Report tot_residue with scsi_set_resid() when a command with a data
> buffer completes with DID_OK. Initialize the scatterlist DMA length
> on the identity-mapped PIO/pseudo-DMA path so the residual starts
> from the buffer length on architectures with a separate DMA length.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: esp_scsi: report the residual byte count
      https://git.kernel.org/mkp/scsi/c/235a12231735

-- 
Martin K. Petersen
