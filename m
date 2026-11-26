Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664102;
	b=ty/7K7Ba2KMNefdYdv/EETsgft3eFKzGU0eS9D1rpn63JRnmN/ICfjPyW+4izbaOB2gT
	 G+07HWxKi8y7xA/qdUd8I5VSk17iRkXKFV1F3QmC9AodMcpVkTmUFUC/RjrxxbNL5I5WL
	 LotuPoo/EEWujsFEhUd75OGhPq7igr3ptWQ9KdvGoL2xCgy68jF5Yb1lYm+JBrsXRM+O+
	 Lpj0Ps/IIXksz64yOx7fj5o/BVYr9qL6XQdVz32pDl26laz2ZNeQOtGG4kCVkcu81rqVq
	 UBhBzNXKv2TWoLbCJhY+SP5vRCW9liLSafGCtdOqxiqZ6Zr8o6K22tSYhEZJl/W9Sqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=43myYpFDcE6Nm0OZu/naIjBnJGdG7mrmhVh4UgjE0YU=;
	b=AQxLNOCGMNtsjWSi9IeheGCvaWaDsTMS93IhWYUzAAb2CfNbyAhbMundc2ePubSFjHW/
	 7J07DKRxb9v6/sW8xo/Bf/xCayrd310yatCF26VK0MoGwwSDKWG0mwUnKPh5JHIwMeeYr
	 sbFQMLI3eGtUkgELbP+1SAUMifYQWu3Qh7USRBSCZaRnG3YMIxgqwaSi10nXemDdUGacF
	 fEcUsTnbxI0GzBNiArs3VAsi0QnnetHVSPBnI0PlFW8UycnhRPUFq/rJSv0rLo7as11ju
	 1zozs40jMqc/9UzFdLapnEiVsZhL9MWm8SHOh1NpaAHPnuTy/Nom1bkitHC05UQTZyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cNo0Jakd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511DD606A31E;
	Thu, 26 Nov 2026 03:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cNo0Jakd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5CB1F000C6;
	Thu, 26 Nov 2026 03:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664101;
	bh=43myYpFDcE6Nm0OZu/naIjBnJGdG7mrmhVh4UgjE0YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNo0JakdsYxgEyaXOA+V5I452lCmbgnjkS+wqYhIRxWzA2NOLfBvku8Irqzwb9fv0
	 iHaIMml7ipZ9q6PdMM70Vy0xW+tdpUA0b3wTyyRb848OwhtjjfLwQODF1gKU64uMH5
	 kq9EIpiSHS+NovYEE9BH1IxyP3MafQ0K0eHi9ySn3bQT9X+lMTsgmcZR8dgaevDhBv
	 MrdDNm48AqT1aEBxHabeKzeU1QNoBB+dSYuSE7CKu+CTDvwFqOlm0QMGlPL6ieOaHC
	 AV390IBTE95rND0CrEq3EtlD/HF5bsj22zv+Uf6GVTUv+Z6YPLofSOJSEDDiVDDu4X
	 hrHHosgLLXYAg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Ian Rogers <irogers@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Elkin Cruz <elkin@google.com>
Subject: Re: [PATCH] scsi: lpfc: Fix format string and OOB copy in lpfc_read_object()
Date: Wed, 25 Nov 2026 22:34:47 -0500
Message-ID: <179566062793.467514.2121267056315343510.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119170500.1514537-1-irogers@google.com>
References: <20261119170500.1514537-1-irogers@google.com>
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

On Thu, 19 Nov 2026 09:05:00 -0800, Ian Rogers wrote:

> In lpfc_read_object(), rd_object_name is a 26-element u32 array (104
> bytes, LPFC_OBJ_NAME_SZ) populated from rdobject via scnprintf() without a
> "%s" format string, and then copied to the SLI-4 mailbox request with:
> 
> 	for (j = 0; j < strlen(rdobject); j++)
> 		read_object->u.request.rd_object_name[j] =
> 			cpu_to_le32(rd_object_name[j]);
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix format string and OOB copy in lpfc_read_object()
      https://git.kernel.org/mkp/scsi/c/1f4c50b5d04b

-- 
Martin K. Petersen
