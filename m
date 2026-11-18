Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977375;
	b=QyUpL09G3ttFf3gqj6De2ss7VsSXQHkZ4y+dyUhHsQtVa9QkpmXqojJrcqNaH5OvaDqB
	 Zr0+17Fekd2Fz/ERnYQJQmn/3rErzqHr5eYUKAQ0LYcH1IRggZ5FOSjZBSkuL/KV72n6H
	 qQ8HPFn4NTIpQbVM/DY/LxxlA1HjllYOiskixBvCp/5CvGKME4zWX4XUB/UTh0RcbH5Er
	 UF1PFf/FebfFAMyUwgNf8m+k/GynbIY3MeY7ADosqb691QQb1EKZESh9p5ey76jSXPSxl
	 VgFkRSlqeSW1T+ok3z4KMQZkQA5ty/E+hy5ApmAl2a6N3F1/gvd3BvtKvR4K9HxDgng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LSYBzu3WzxYwZFW+agUt6ozNBAbIN82n1qHNnQDIvNg=;
	b=Mn/wTqVYpBpiDnm751JBbSxHzkST7LELSqRbMqhtp2zSUJ+8zTJ1EnUZzZfkOeKO8IJS
	 EIrsCxDVEg9UAQ7kgNK5WjDVSNRJyOLSMkM66wB/WBA7FB0DqLUmDNuHSlRSO5CA6EXjR
	 UsCr1Y38wbj18aRPCpv1m3JcfAkwFYElQuc+686NmKRRLeE189HCRQYr+2owIMyL3uqqy
	 lO6TdTaoVY3KfnWlFC3jx001GQozX6mZCwZ3IuTtvZ6GzxPngdLwv07NDR6xUt/uvl8UP
	 Pe0shce3P0uv5TwHmgO1K1G3nTykyjksOL+VOvW+cw9DZsdZu6xyfuo/s7O1hA+4sjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qdzvfc9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0674606A33F;
	Wed, 18 Nov 2026 04:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qdzvfc9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046591F000C9;
	Wed, 18 Nov 2026 04:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977375;
	bh=LSYBzu3WzxYwZFW+agUt6ozNBAbIN82n1qHNnQDIvNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qdzvfc9jhQj8G2GdqvR36YQfrFxPPNuip1dU9JjrPLQvrIkqj7yRGjoBzsdoaGDtq
	 YQ7cWrzNVoHhsLuv3+9jaCFBlkiwuMzOzV9+KkcC5UWSjCfbijxiRARSWxMabHVBWF
	 PC0AKCEaH3SKVDQ9a8au7aVxditDZY3fnRRbC9SG2gzUnTwQDxWfdiWfvUx8tDFv1c
	 PHyIQuyKT7e4KJglrVl2hSvKkqx/Y9w8/+XZaW9ziBa9b5ZXeTVNRDMP7Dwtxuij/1
	 CK0FPpIuxedoiGp3D5xZ+rx4krIUOAI49kcEvWUHtfCjs/oMDw5YBy03TqROoFem9Y
	 XaM+VgeKBrMRg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Laurence Oberman <loberman@redhat.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	Mira Limbeck <m.limbeck@proxmox.com>,
	Chandrakanth Patil <chanpati@redhat.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix off-by-one in NVMe PRP list transfer size limit
Date: Tue, 17 Nov 2026 23:49:23 -0500
Message-ID: <179497726111.2093762.8341844612167289010.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113145047.623807-1-loberman@redhat.com>
References: <20261113145047.623807-1-loberman@redhat.com>
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

On Fri, 13 Nov 2026 09:50:46 -0500, Laurence Oberman wrote:

> Commit 04631f55afc5 ("scsi: mpt3sas: Limit NVMe request size to 2 MiB")
> capped max_hw_sectors at 2 MiB on the basis that the 4 KiB PRP list
> buffer holds 512 entries. That does not account for how
> base_make_prp_nvme() fills the buffer:
> 
>  - PRP1 is placed in the main message frame and covers the first,
>    possibly partial, page of the transfer.
>  - When the list reaches the last 8-byte slot of the page, that slot
>    is used for a chain pointer, so only 511 data PRPs fit.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Fix off-by-one in NVMe PRP list transfer size limit
      https://git.kernel.org/mkp/scsi/c/dd6ff53a2706

-- 
Martin K. Petersen
