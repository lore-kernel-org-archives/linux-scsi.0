Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD08B3C73E4;
	Wed, 11 Mar 2026 09:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773219754; cv=none; b=QE3knk74k5TwTM63onJb4b6J0Z3sAtbhGbJEWqeBwDy9C40cBHNwZqdtFWZoQAlPwo34Q9UZ6pFmntV4NamcVjpQTa+Pk99binzkLam1xF6r//NuH1CFbbRct6qM6Ha2pCo9tQ7KcuxW5sKkmKluX8dzcJWKSo+6bKsdVhgYL7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773219754; c=relaxed/simple;
	bh=jIs1IR+nAIAo0v4hnk+3f8YoL3lzNXLtYM7TSazbQF4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=oidOrQG0V62He9SdPFh7KtYMGOxqSNPsQ9IYKYhKnzT2+QiOx32+5WVy+YO6nJ+fL5YXb2DeNgrzgZjJxolUMCr/kLwRUe737uY7TuHbOvsRZnOjQlYuLKhh33/RDi64lZ815bcFJoP4HvkiOlFlbW4Dnf8O4G6R22/z4c3dogo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 7f0d0655 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 11 Mar 2026 10:02:21 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Mar 2026 10:02:21 +0100
Message-Id: <DGZTXRKSHBPC.2B318HF53ZRSN@arkamax.eu>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "nbd@other.debian.org" <nbd@other.debian.org>, "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>
Subject: Re: blktests failures with v7.0-rc1 kernel
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Maurizio Lombardi" <mlombard@arkamax.eu>, "Yi Zhang"
 <yi.zhang@redhat.com>, "Shinichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
X-Mailer: aerc 0.21.0
References: <aZ_-cH8euZLySxdD@shinmob>
 <CAHj4cs8mzSZez+n2qLu5931YAuQ4=RxNt6D6YJCsMEwGrm4UtA@mail.gmail.com>
 <DGZRYXTKC049.1I6QFQSMSD88H@arkamax.eu>
In-Reply-To: <DGZRYXTKC049.1I6QFQSMSD88H@arkamax.eu>

On Wed Mar 11, 2026 at 8:29 AM CET, Maurizio Lombardi wrote:
> On Wed Mar 11, 2026 at 1:35 AM CET, Yi Zhang wrote:
>
> If nvmet_rdma_rw_ctx_init() fails, shouldn't it call
> nvmet_req_free_sgls() before returning an error?

Possible fix, not tested:

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 2d6eb89f98af..79ae743bb405 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -892,7 +892,7 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_r=
sp *rsp,

 	ret =3D nvmet_rdma_rw_ctx_init(rsp, addr, key, &sig_attrs);
 	if (unlikely(ret < 0))
-		goto error_out;
+		goto error_free_sgl;
 	rsp->n_rdma +=3D ret;

 	if (invalidate)
@@ -900,6 +900,8 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_r=
sp *rsp,

 	return 0;

+error_free_sgl:
+	nvmet_req_free_sgls(&rsp->req);
 error_out:
 	rsp->req.transfer_len =3D 0;
 	return NVME_SC_INTERNAL;

Maurizio
