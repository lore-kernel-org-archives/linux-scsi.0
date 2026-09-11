Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCEE453A25;
	Fri, 11 Sep 2026 16:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789143510; cv=none; b=YP9jN95/mZaqA6rJFtQsmBCmX8xchLJcA1gJeQdo8lU+vH6q2m1QMeu+rUtFP04eFjCE/cZYKUSf1aVTwE+Y1HG6YbMPZr86cyDTjyQYQPLrV5X5LmKKzgeHOo9QBTCnGn8W94i8skGS32WWvQrwQmxVgLx0Kw2+89isSLqdtLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789143510; c=relaxed/simple;
	bh=OYo0bQpI/TLTUyEkq1F1G6boQhb8xAOprc5TLcsLvxs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Og/gRRIzNdF6oY7PuAf+fognu7IxMieGa5ozX4quU0SsuE7fpWzIvd+KqMHESewGa7JM0f6o6ugOH5v7nc0LQhdPs5Js+Uwb59Q+Bft+m0bnG61LPL3ksl1MhG4hYhPiDEe2gla7gXQaVmfqAvojbB2UH7szlpiiYMoWL9bhu6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfch13M/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfch13M/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2905E1F000FF;
	Fri, 11 Sep 2026 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789143508;
	bh=OYo0bQpI/TLTUyEkq1F1G6boQhb8xAOprc5TLcsLvxs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dfch13M/FMkxbaJHXQK6R7mQEil0sxGLN5ZjPXKFFJMOKQCJximGHs51k8iixCJUa
	 VE02yeIoy5UucaJ1C+dr2Gyp75zHobmVLYV25pTWx8Juth3/uxXovo4dZgh77oSeC4
	 bjnYmPT6gQRV9tIXwx8tM5iCdU3vw3hMhhirGLJfvoCT22a9OKWVSJoaW1VkpdBmNO
	 JrcuItboN0zki2KC/kvoKqGVtzDbKAU0oqvQNYvjPsVz+BUtYEfOLJsEyc7M7eyaLc
	 4yxu91MzAtGA2zh1lAWssnThAXEwRbGFPSDb8s/eeaU+mEkt4N/jbFMHatByZf8yLA
	 Ny7eBWBHr/43Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Jaemyung Lee via B4 Relay <devnull+jaemyung.lee.samsung.com@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Daniel
 Almeida <daniel.almeida@collabora.com>, Tamir Duberstein
 <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Onur
 =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, Jaemyung Lee <jaemyung.lee@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
In-Reply-To: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
Date: Fri, 11 Sep 2026 18:18:13 +0200
Message-ID: <87pkyjvk1m.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jaemyung Lee via B4 Relay <devnull+jaemyung.lee.samsung.com@kernel.org>
writes:

> From: Jaemyung Lee <jaemyung.lee@samsung.com>
>
> Add a Rust UFS host controller driver that exposes UFS logical units as
> native blk-mq block devices without depending on the SCSI midlayer.

Seems like we forgot some Cc's, so:

Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>

Best regards,
Andreas Hindborg


