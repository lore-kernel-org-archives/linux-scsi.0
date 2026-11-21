Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231507;
	b=r2CUoCv4oJp4l3lH+I1zKl5QUkP7lNJfuz/Nkip3hxxs9bpWSZNH8eJ6J3eHfaBlowDl
	 3c3Fc7j3fkbi6fTdoofq+btje844drwxWCLTLIxehFO83Fbt7kC2Vyoaju4WdIC6taUPL
	 L9N6XdUuKtP22cgRGciqEvi7Hsi8zmbKbt1B45y6j7OS5p95FqZCNBljG9PKa0q4kWJKp
	 OEFQD+1APfnW6HZq7dCvQzWCU/ehM3JAXNJ5t6HtylXtCyhppiQhPC4cMb/GrTYenXKvo
	 CDFK5q5A++spLj20/sncQfKMcK3pRAG6JGhSK2XEjeMJHMlR0Q9IKXVryc5pQk19YDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7ElCoO/c/pEcUZpeQuAv5csB+KztHEVsCcAnqZZm1G8=;
	b=B+7B3iLxUewuB2nllJb/jUIbCGv83mvoIS9WTgSEXcfSrf01WP7PKdnqBEpmacxO5xdy
	 hg4Ii8S78jGs1jLwYC5i3l6LQsbQH7BirwIkRmh62tCdDHEyHIo+UakpjV7uNtUBZ1VMS
	 FGfinFuE2TYpYNGv59/0aN5ekBlIrLoj+8lk29YVApfeB42FIL/tTWd1LaHXxEhsWFhah
	 vtCARDE6Iws2Yq2358wfVz7eXtkyOMufjquNtOfPDDz1Dm2GkuCqoD7xvzVqfF7AlfTbe
	 SVCccJBomVxIrP8AUWrjjhqdGbBX3dFjK5HDSX3HEC20XwhsqPIuOsUClqu5ZpXdZLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JIuzgqJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAE2606A6BE;
	Sat, 21 Nov 2026 03:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JIuzgqJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D541F000D4;
	Sat, 21 Nov 2026 03:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231506;
	bh=7ElCoO/c/pEcUZpeQuAv5csB+KztHEVsCcAnqZZm1G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIuzgqJZf6cMRoto2yhyF0++LTVZ8orX3rZgn5s4NBl3Oz2MK6moFLqmDNADtFwaP
	 agY/GM+WXvyfLfQZqXgObFazjx2TVQaPS6ZZeTP2+pMTFoinvIBP5YtzwreFnQfMSx
	 DW6wA9/zsgYK7k70q6ylcUNunR+/3pYcfXCGrZKbEW8B+BIIJUr1InZq22Mn1OHlMQ
	 Q9WgCphRe+dNX2UZtymmW90H/L7fIAww/Gqo3BSjBwsch/NViGNJHsIhen/xDZzXRM
	 xVYKOyB3RNaLgEC5KDDV1PF/Ro+JTC9WFoA6akiX7RTV5A5FB+XKKeXH5RurLy2fKa
	 9kpK9vfZ/fTPw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: yong liu <pkfxxxing@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: Re: [PATCH v2] scsi: target: Disable protection processing for zero-block commands
Date: Fri, 20 Nov 2026 22:24:52 -0500
Message-ID: <179523145635.420187.12410606192780745246.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261111030544.1216434-1-pkfxxxing@gmail.com>
References: <20261111030544.1216434-1-pkfxxxing@gmail.com>
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

On Wed, 11 Nov 2026 11:05:43 +0800, yong liu wrote:

> A READ(10) with its TRANSFER LENGTH field set to zero on a PI-enabled
> LUN can select TARGET_PROT_DIN_STRIP while leaving cmd->prot_length at
> zero. transport_generic_new_cmd() then allocates an empty protection
> scatterlist, causing a target-side Oops, which can also lead to
> use-after-free during subsequent iSCSI connection cleanup. A logged-in
> iSCSI initiator can trigger this on a FILEIO LUN with protection
> information enabled.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: target: Disable protection processing for zero-block commands
      https://git.kernel.org/mkp/scsi/c/6b745a4ae88a

-- 
Martin K. Petersen
