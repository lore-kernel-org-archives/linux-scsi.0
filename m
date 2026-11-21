Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795229505;
	b=IYgpMqVI+D734YxiGz5t8yTnW8h8U4SglPRqT5qbuupmAArn7b+Q2jVh0ooTE1+aVKn5
	 3WI3tNb/47OEHQwML8hh+iLbN4eeqF3uLfI3J43dqi9vf2jf4wi7htUbvGDkEs9MtSSHm
	 /PRUGyCePnVxH6Gcnk5rHy6thGzDlzz4zHIjVBPCPChxxkEavByxrJ8v1F0Qf4qwEe4qd
	 HJVt1sEmblzS9njGcETeSKN00g4Zh/Usbr2y3dOQoptHRku2sOy/TMt8GZgytrozLzuns
	 cUD31priJtmJKXcXUl86YDMRoOk/B3YThCWnToJwsxRMreK1SQTx3PtcoArlkKU5JyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795229505;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=Rj19iv7+f7HTCZWf1azUlL1U4VfnUOK85/rjqAj+Vuo=;
	b=N9Rf1YUhrMfRu0kd6C/7pB+oUQrHshsyzGnf+l0RGYwjMUJZExgdJnR1qR0b/bCPjQfB
	 GhI0900v8MuPE5HHoBSGzqXsytKNumpPohJtzaZrHKS/GZfnFzXgMGV4MVi4j1j5snQNL
	 4m3Ymp2toEZS7LWCEDV/+v1GHX/Y6eTdgEE/lpNNz8r6zOgYBMVYs3DGz+uCOabkaHwyQ
	 85YPh8jfUbNU0B2MlVFX7LVpdg2hopDL1+aPfLgO1OWCyDA/0bumRP5SmxIedQ1VpDanC
	 /PVDIfxE4NrTzFAdpOCEddyCq1qyqn6KuKX9eUGJcuNGCvFjIIyBp4yMRniYOQwsrjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVGilBYY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B18A606A69D;
	Sat, 21 Nov 2026 02:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVGilBYY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D321F000C6;
	Sat, 21 Nov 2026 02:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795229504;
	bh=Rj19iv7+f7HTCZWf1azUlL1U4VfnUOK85/rjqAj+Vuo=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=PVGilBYYoLE4sItOB+S1ez2VI1QfcGvycR7Wm3AznGWbUqW5HBhxpk/zfSeDrrH5U
	 z8u9w2j3FR4G4EeS0CyNZjLymDUJwUStCFky1CM3GpkhPuW1aRb9TQPYC2XttAHRN0
	 wsqBsNPnWYjO1yZrTyrQ5/QKwKjUOJJPhQj0Qw8Zy7S1dz2ZKIAYW7N9lulWDTRH35
	 ydl8g/BIFZt8fslUUrQeYSDEjQwn+oXDf8utklgm363Kh1OG7fQ2y77UQz7qOMa4MX
	 Ew+3Azlxn+hQuEbiJQdKljEULBhfz3+93b9Vn5OFK/GKXGsfwIK/xuFTgUYICY/7cB
	 ibHsiPmJShVUg==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,  linux-block@vger.kernel.org,  Christoph
 Hellwig <hch@lst.de>,  linux-scsi@vger.kernel.org,  "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 04/13] block: introduce storage element management
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261120210651.580511-5-dlemoal@kernel.org>
Message-ID: <yq17bi6oq1e.fsf@mail.kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
	<20261120210651.580511-5-dlemoal@kernel.org>
Date: Fri, 20 Nov 2026 21:51:43 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Damien,

> Recent SCSI (SBC) and ATA (ACS) standards define the storage element
> depopulation feature. This feature is intended for managing hard-disks
> heads, either combined read-write heads or pairs of read and write heads,
> allowing to keep disks with defective heads longer in production by
> allowing "depopulating" (removing) defective heads.

Reviewed-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
