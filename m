Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977421;
	b=YBev9PXSuRd6im9D72BnvFNPUNG8ParV+Fhq3AlVM1xelLLFcU46DlE0FMwLG1K14iEi
	 HR85i7vU8gJSIrv9PMhxs7z3F+1WrNOJug3CY1Vuggzpfp1OCnOSc0hL+m5Ho1yONngEy
	 0KkAA2S8r5by9edyC++ygeWl904/kmkuAzbEbt7OBccIguZtEDq7rfh/0sb8SA2ZeemoF
	 siGXjAoU2oLommPK8oDynJGdHGULqBhp32sD7MTXQ4Ph1Oy4/PUWABSB6iptaON6c86Bx
	 WrJr9uFgX0F3jtdFAYvS0uPlVRVUxdUxR1R2UosErIlvv4MjESU6grpUhLUOUQWyxEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=+gTPs2gIcbJEREtIe8DXIYHJes4gsHULFHdrFUgIMCU=;
	b=amwr5dlX+bnyyh+2mPO8MPug/5RcMRHEozMaZEnusUdwuD8NAWVBO5X1VLU+zT5LLjUk
	 n8FA+TDxcJfYEMqgmBs0jR668GaP/1C55MoDeNgbqSway2V8Ye556GOaDLBENItMFK42j
	 UNgHZwgxvAG6ENi0AF7lk44UpbGRvJDaMSkHQHl5nj7kTNIyvSiz0vtQZpIoug0Me370g
	 y1No9P1+yZH+kpE550eVtx/1NsU+uNW/UgKXI5rGlMHzgxbWF3jtT8A2ovy3IGQsAVtMf
	 kYxFP401TPHbAUnm8rgPEsBQVlQHOdf25ryHbesLd/Bj0EALurDH2jn1dJh5l4H4WvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibUa44CP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA55606A337;
	Wed, 18 Nov 2026 04:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibUa44CP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43241F000C5;
	Wed, 18 Nov 2026 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977421;
	bh=+gTPs2gIcbJEREtIe8DXIYHJes4gsHULFHdrFUgIMCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibUa44CP1nZO8V2a0bM73em8R/F0LIGwvnDAYU7y9GE3zxNN/vGLb5f8grThc/vqd
	 vA8RImNDI0kh9qh1kg9h5JNX5hUNQk3Z512gHRbTISICqj7owIEoFshstKdTmWh58t
	 lm4C+L5Ev+4JjbTiHLNywzPjhFdS5NbY+3MhvWGZ+rqDCaHXEvfFwJKHKLDysnI6sy
	 ILplUJb7z5GWoColahhgre1Aa41xH3O1Bhp67VADDFiSlUKxNfvyB8eC7Wl1QgG9mG
	 LYyWwQDnKnwipGV5cxiqGMfAVMlAPfeZWsxyN5cjQJVx6gpyKYQpJ+MCdW2vX3aEkI
	 k51hj2Quc+nnA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Jesse Taube <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nimal Prabudoss I <nprabudo@redhat.com>,
	jmeneghi@redhat.com,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-ETH-Storage-Upstream@marvell.com
Subject: Re: [PATCH] scsi: qedf: Remove unesseary function call
Date: Tue, 17 Nov 2026 23:50:11 -0500
Message-ID: <179485091819.1479907.5322794943255337313.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261029160443.904468-1-jtaubepe@redhat.com>
References: <20261029160443.904468-1-jtaubepe@redhat.com>
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

On Thu, 29 Oct 2026 12:04:43 -0400, Jesse Taube wrote:

> The result of `skb_transport_header` was unused. Calling this function
> warned when `skb_transport_header_was_set` returned false causing a
> panic on debug kernels.

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: qedf: Remove unesseary function call
      https://git.kernel.org/mkp/scsi/c/dd86dc1d86c8

-- 
Martin K. Petersen
