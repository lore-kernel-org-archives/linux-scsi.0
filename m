Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239400;
	b=lTEbYfiJlDYSAgmqt4xEIuZUVBW3YbWiJTQNO0MCnezs6MlN1+zwqM5OyAuSoVxdGrmL
	 rv/zJG28UyLOpXE86fc3WTFnl1zrZFlzBCJTVipPt/B2dwLcRlcKTl0y4CHAzG3rIgBYt
	 k1KuX5Mskx6wE+NRRlHxcGxTaESoFF3knTMI7o3uL9ZBBdkIIrra7w1XJdBadqk6kAYCL
	 uy3bupx9OMhHdPXNFbBBelJwWFQK2q0rFm+ZE8k0Kqnrbk3sjqKrZQpzs9zVdk6IAcrWx
	 /aTXIs1VMrOdJgp0fzJUlVJi6DCtp1qstKugOjk2WaKH8YJ9LXzzXBcgz1Zpeixb1/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=OXZ2nMw2QvCsPhRJaNF75Fm4QR+1vjQ7FHpNFPm6Kt8=;
	b=S1oxeB+sTQ/Dp/mzAXckQrfAeW9WrqmjbZmg5pk8rHtruqUDeaRQYD3PCtH19uaeb52L
	 LwJhdDF/ayVmtKg5zh9ZW+ftxaLfdvKoeNaIGmrfNZZibBJ//nTb1OnB5iGyZDDWnzTRW
	 LP6aGHAhg1rbAS9fUujs3KxvOEpXfTUV6h+ZI7RsbpXAdHaZML5IDBihiFeDRsu5VU7yC
	 U7dHrfSO7IexzIWxxzVhsrHafMmwOC6w2INjHyI+4AVG2WOJenzF8x7JG2+eYBGPquK9E
	 4u2ibSyOVRoF1Z4dj9meWZ1VR4HI1PjOu6TctW4/bbck+I9sg5Iy3Hty3yUROVzb2VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YVheD+PD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7B1606A320
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YVheD+PD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4391F01825;
	Thu, 29 Oct 2026 02:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239399;
	bh=OXZ2nMw2QvCsPhRJaNF75Fm4QR+1vjQ7FHpNFPm6Kt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVheD+PDxVOjBGFPTNskJbc06xwuFqYTSOpaoaIDIqqlNeJ4zdxet5hT3Othx9uZT
	 OUTUVniUQkZX0O3UIC6iUn9wufMHCF6ESd2vcwPXLXl0aVHrZ4IC3Y3gxHor7gSCS2
	 m+r6sttVEsN5OrF+dqaZna/HXAaZDNdRq452Hx+C4oYGCbcLSt/5cyWyFvlHm5ltzy
	 8raQPm3eer+A6LPPSGVnhkMhN1YVtRjg8qvJ1gRNCh+teDRaG/5TlTvdFD70O682qm
	 5GeStJ1tHCT7ujjK2yz89OTJd6D3uCqUaaeSVpyYFVwJUGTx8mUKKyWSqS7uaGymgI
	 ZRqhSdJ/zmZXg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	lduncan@suse.com,
	Chris Leech <cleech@redhat.com>,
	michael.christie@oracle.com,
	James Bottomley <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: libiscsi_tcp: prevent R2T range check overflow
Date: Wed, 28 Oct 2026 22:02:54 -0400
Message-ID: <179323465384.491807.7402430226621105635.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com>
References: <DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com>
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

On Mon, 19 Oct 2026 21:30:33 +0000, Ratnaker Gautam wrote:

> An iSCSI target controls the R2T data offset and length as 32-bit
> values. Adding them before comparing the result with the SCSI data
> buffer length can wrap. An R2T with offset 1 and length U32_MAX then
> passes the check for a 4096-byte write.
> 
> The transmit path treats the wrapped range as valid, exhausts the
> command scatterlist, and dereferences the NULL next entry in
> iscsi_tcp_segment_done().
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: libiscsi_tcp: prevent R2T range check overflow
      https://git.kernel.org/mkp/scsi/c/eb7aa7fd673f

-- 
Martin K. Petersen
