Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664109;
	b=iwGCUjKSiRiBUVZa+bJOjli07++kxuJj8j+Cx0reDKhYuIH4uGyIJquklf0R+aHfcrrU
	 ivo9cfTWIJswtg0eog/a02yJRWFEsJwRMGFu3KeZEhux2RJ7iqAc7hRe+o+aMR6rXZzXu
	 QIzXV6EwkVPrVRn3E/lyZ7fGGwQLFfJ5PpNFGIbjDTjEyzt9OX5bDiWrOacvRHB4ie/DY
	 NZOROLPGw7fyjyPBc8+yMkezcZIogdamWHg25zNUhlfPLdrD5EQwQz6c0O8s7/CUUoWnC
	 p1JHEJ3JpOQO1JbFqhFKXX/mciIDP281pM1/wErobJFdn6OODaZjkuLhhlNMdV36RHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=9FuC6cjcUD9SZ5hGP6b5qTpxCjh2S9d+MKe0M7AsBVE=;
	b=dxd7K5kwg12O0nUqwKGPceZEEWPyOQU1up+GjSYZ2dXuawkY3/Wqs43Syq7YMEPx8dp3
	 vb3xS5Rr/+KwYGvqZTzR7kOqOh/2leeRIInOu4MKr8n5bMsLujZDtsC9oYpfOqSPm/tAY
	 NiP6jitDfj6O5skTTm4C6hv2DLKQGEWQUiPihGyVSffbxQl8GZQwUgs0ULG5J2nYi47Iq
	 V3LX+C7mpSzVdIdWMNcSPyLVYFVXdSGj5L8PVl4RmbJJwgaV2nlImqEQr/jaCRGqCNag1
	 cynHfdZtNYwY5S+ZJrZDtP+5+7qMWNfW6cEXjkkYqACsNupaBIADPoltxDVZPWFJSxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E4P6ZkgN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B68606A334
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 03:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E4P6ZkgN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64A01F000D2;
	Thu, 26 Nov 2026 03:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664108;
	bh=9FuC6cjcUD9SZ5hGP6b5qTpxCjh2S9d+MKe0M7AsBVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4P6ZkgN+GEyD6iXtJ3GREyedogzgNNjP8eKZUW+QiFL3ldO/aihvN8zG9flJOPPZ
	 hKXeSx/ldHboPg+HtujG8oDRYIZyE4FicaE2d/0W2mEXGnv11x+Vu2i4wvQesCWPpU
	 w6DRgtchZYgmje6ZCDKBE6pkngW40dJiSFMLKSIAkEukeWsrUMesH/pq7g2AlI5vNi
	 pqPEaQKSTYWxFQQKKjMDRkEMm1heGZrh2el2CvhH7nTYw2fGchmmlBpsqdOeNbpuKm
	 rwv6j0DbXEoRkJ33R2GCyCWeN5q6jeeGdkBsSDHbCy+YrOvrqmWKn/3waFSpnbaCxe
	 /AJJjR4tD+3UA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com
Subject: Re: [PATCH v2 00/20] scsi: mpi3mr: Fix issues reported by Sashiko
Date: Wed, 25 Nov 2026 22:34:51 -0500
Message-ID: <179566062796.467514.18370732548470297743.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
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

On Thu, 19 Nov 2026 12:41:12 +0530, Ranjan Kumar wrote:

> Fixes for issues in the mpi3mr driver reported by Sashiko.
> 
> Changes since v1:
> - Patch 14: Fixed the block_io count left raised when the last LUN is
>   removed during the command, and the use after free of the SCSI target.
>   Both were reported by Sashiko on v1.
> - Patch 15: Reworked on top of patch 14 and documented the new member,
>   as reported by Sashiko on v1.
> - Patch 16: Documented the new lock, as reported by Sashiko on v1.
> - Dropped patch 17 ("scsi: mpi3mr: Reject a too small reply size when
>   enabling log data"). It is not needed because
>   commit e550f2b2b4aa ("scsi: mpi3mr: Validate reply frame size bounds")
>   already rejects a reply frame smaller than 64 bytes.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[01/20] scsi: mpi3mr: Fix out-of-bounds read of the BSG request
        https://git.kernel.org/mkp/scsi/c/fb7673d1037d
[02/20] scsi: mpi3mr: Fix integer wrap in BSG buffer entry lengths
        https://git.kernel.org/mkp/scsi/c/3f00e31b1e94
[03/20] scsi: mpi3mr: Remove redundant BSG buffer length checks
        https://git.kernel.org/mkp/scsi/c/e25ad58db1e3
[04/20] scsi: mpi3mr: Fix PRP list leak in BSG passthrough
        https://git.kernel.org/mkp/scsi/c/213282fa70bd
[05/20] scsi: mpi3mr: Fix reposting of invalid reply address on the admin queue
        https://git.kernel.org/mkp/scsi/c/39bed42d2f0a
[06/20] scsi: mpi3mr: Fix endianness of device handles in BSG requests
        https://git.kernel.org/mkp/scsi/c/aa1db329a26a
[07/20] scsi: mpi3mr: Fix integer overflow in the HDB upload bounds check
        https://git.kernel.org/mkp/scsi/c/2057dfcc96c0
[08/20] scsi: mpi3mr: Fix integer overflow in the log data size calculation
        https://git.kernel.org/mkp/scsi/c/ac7df6cdd998
[09/20] scsi: mpi3mr: Queue DEVICE_INFO_CHANGED events to the bottom half again
        https://git.kernel.org/mkp/scsi/c/e9642e4dc551
[10/20] scsi: mpi3mr: Fix target device reference leaks
        https://git.kernel.org/mkp/scsi/c/0f94a44009c0
[11/20] scsi: mpi3mr: Fix the 32 bit shift when building the phy mask
        https://git.kernel.org/mkp/scsi/c/7a94105f9408
[12/20] scsi: mpi3mr: Fix empty device list race in the all targets query
        https://git.kernel.org/mkp/scsi/c/2d6e97aabc30
[13/20] scsi: mpi3mr: Fix the lowest phy number for phys 32 and above
        https://git.kernel.org/mkp/scsi/c/83d010edd8df
[14/20] scsi: mpi3mr: Fix target private data use after free in BSG passthrough
        https://git.kernel.org/mkp/scsi/c/85abd02a51c7
[15/20] scsi: mpi3mr: Fix block_io accounting when a target is re-created during BSG
        https://git.kernel.org/mkp/scsi/c/572eaf1f4249
[16/20] scsi: mpi3mr: Fix sense buffer use after free on BSG command completion
        https://git.kernel.org/mkp/scsi/c/dcc72f9dbaaa
[17/20] scsi: mpi3mr: Fix partly written and lost entries in the log data buffer
        https://git.kernel.org/mkp/scsi/c/93b373f0d4e0
[18/20] scsi: mpi3mr: Fix byte order handling in the NVMe passthrough commands
        https://git.kernel.org/mkp/scsi/c/b02157ba7c1f
[19/20] scsi: mpi3mr: Fix byte order of the BSG status reply
        https://git.kernel.org/mkp/scsi/c/3ffd4ddbc011
[20/20] scsi: mpi3mr: Use the correct conversion for the diag buffer post request
        https://git.kernel.org/mkp/scsi/c/4028e065184b

-- 
Martin K. Petersen
