Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196547;
	b=n6YukrkXYgYpyfr0/UzDjp6/pk8RXl7WHFz5AJm9y0Ih/2Rhq3mz++sngAyMV6fnOtV8
	 cM2RHbH/cLepa9mDFXSYc0AS+MBhKMygZx4MzXtBFnUkVk0nsFosQnsL4le7G/RAloCfa
	 CD9Y2x7G6fL8smhnXCYTXbDJm4lmOv51A/jyxrEzrBBh3RnxNUUfwTWrYSjQ6esGmdUcO
	 56gndTRfkIFjtNubhwcjTL4+KuyQA4YOY2uuaH9JZyNNQ6YnEPalYcUKpTTmBieW4B9nf
	 IL0L24Utgn35PKcc27SoNLBI67cy2IO+uE5kgHXnM6LCsemxnyfd3eZOSlZXIfxnecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=HNLod2hZEboIzJXIG19qQfClFNwElzpw9hdf82Khkx8=;
	b=gj98tiLL1Y8N3W2A89K9Phq7lJbmwYJj3Gknn5l3ukxReWmEAgEN1273/GooV1/HGlyg
	 diiNO+O56eNkswuU+k0+GOGIouuGxq6L02eMY+yI35qU1hL9Wgd/detCVWCHLVmSliRm0
	 jY8kmeR79LjwT2P0z6Qg5MO5zCiR++MKK3DSv4NgxNHLFV50jNtcVKwrd/Ga/41ZYBHsI
	 5J5AdcV/KOZwSmFjuOHMx9e1SS4507Nn6s55ACtvO6Bld0/g/MNHwPcHLeEKUjQWnFQpO
	 7GDRQGy/aUa7cKkfYIfM5GAe5DthtvZA0tiaz+acoomGHqbPyCouEED13Z/sl4Kowpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EcnSbapW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65D5606EE83;
	Mon,  9 Nov 2026 03:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EcnSbapW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C5A1F008BE;
	Mon,  9 Nov 2026 03:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196546;
	bh=HNLod2hZEboIzJXIG19qQfClFNwElzpw9hdf82Khkx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcnSbapWZ5JERryt9CMEi0Q2d7x4rWETYQRj7UaspBhxiFQ4PR3padwS/0a8L1nn/
	 Jc7BLt1EqmW+vBscWmo+phJ++FOuBtLmqHZ7CbYOUHCgdFWCgfO5Nx7oGqUk2kTPOz
	 bZhq6K6RRjZut88C/IPdNLFNlwHqIjLCAaIZ7ffTswUF7kqnPMiZY6XkuDSHckIpUp
	 5TCBcAFQApbilagABGqGCd8Mnhao5uzrM14i+6tzVgRVrZ2eFsbtbOGEjfpZ53Df22
	 boIsMRr5G+C5dz4rTk7Qq2Po6SCOucp7aDCMcQGFDhmRB/8TVap0tRUEPhQwJU275i
	 feVC3VNDz9fNA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Praneeth Balasubramanian <praneethb2002@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Praneeth Balasubramanian <praneeth@ucsb.edu>,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Check for existing sessions only after authentication
Date: Sun,  8 Nov 2026 22:55:27 -0500
Message-ID: <179419615240.1941224.6979160897922012460.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029205456.1211532-1-praneethb2002@gmail.com>
References: <20261029205456.1211532-1-praneethb2002@gmail.com>
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

On Thu, 29 Oct 2026 13:54:56 -0700, Praneeth Balasubramanian wrote:

> In the operational-negotiation path (CSG=1),
> iscsi_target_handle_csg_one() calls
> iscsi_target_check_for_existing_instances() before
> iscsi_conn_authenticated(). An initiator can therefore send a first
> Login PDU with CSG=1, TSIH=0 and no CHAP exchange, carrying the
> InitiatorName and ISID of an existing session. The target reinstates
> that session, which tears down the legitimate initiator's connection.
> Only afterwards does it reject the login with AUTH_FAILED.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: Check for existing sessions only after authentication
      https://git.kernel.org/mkp/scsi/c/48d3b732e5ad

-- 
Martin K. Petersen
