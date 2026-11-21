Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795229832;
	b=V+UZpdFyQRgsUmY9+3C1htqi1YmDhdnAkS/h9fCJqDEoUw6/860LR5zFuvPG1mJaJ6+D
	 aepQJT6HzCM7zQpgR/VTVWuFjEMvIlzK0Z/lqTYiExYG7qZpgTdvE+QwZgiquQMmw5vKU
	 wAkKec4b8n4N43gGeNZEZ4ikuDfBiHoyhTn3q8S+F7y8W1AiMxaImTRRqRZhbXHIg7i4s
	 aAk7wYtWOE59YBlwuCPY567eS9eUA90YyMDNwgcOGKjV547cil0LSMO41A5kYHGFZYFB/
	 oDBrc+9dIwM6IrL4+coTdii/ERIwg7tPt8skwzbKZP84aVgg3Djg5XEIlUhnF7ie8rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795229832;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=IOVeMD6HfGZ7JHM2W+bcqXoEk7mbXK7Fu9/QARslgbA=;
	b=TRtlUAfJMxZr+qH9CnEt1JfU44jBCOLnsh0XzxULaZrn2YoNhnsSGFKLfAkYVaTSAY/9
	 q+LWa/okeoQA29T6Zz3FTD9KPcZ+pMOrYHZ7AjNQ57clvepAJBhEGwgsteTh3FoiLORNw
	 onz4t1yLDYM7CRug9v/C/0pQyrUVUNEs6CmSmFZ9F5VinxT2fPiavJYLJdUQ72whPVY9M
	 NLiVTsL3EpFxeWMqVpXGuyrUWC6qOlu9Mk0jb2bHqhJJDxF+PKFSTnitamTeboYVOOn16
	 NJlHn+aKMWk0EA2cKDk1tdJ7R/SIlmx0+43yHZJNnmKDV5QuZmdPa1zBmRhS9W2duyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I5Ha6tjo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8A7606A6AE;
	Sat, 21 Nov 2026 02:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I5Ha6tjo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDBE1F000C0;
	Sat, 21 Nov 2026 02:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795229832;
	bh=IOVeMD6HfGZ7JHM2W+bcqXoEk7mbXK7Fu9/QARslgbA=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=I5Ha6tjoLUkjtWeT73APcmFxrU5eTuS16yP0wFEcOFm90wLtBmHppnGh/sttCb6PI
	 eeAeHnTv+rv+uSn0nevhqR/lDexQ6jm9nDJMkaUGjjYC4Ce6Yy20Dx5O6ihLm4pPsD
	 nsyiXJS++cOoWIiZowQ7323h6pKF7ZtYV9YZ3wVEl8GTseIBGfE0TLm7Shhnnre3US
	 phijU3m1naeFDXpxJNRC6cgnzlwrCjT1xNIL4O/QggyYTmnMMg9AtfBstwNTcz4VG6
	 /OdKFZPw3Ar0qVc1Cw9aHeKVvMvuSdzHMMqoLE8Ip+fjU2QV4Scv7pMvlmKAqhZU9h
	 h5M3Zjpz7d9RA==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,  linux-block@vger.kernel.org,  Christoph
 Hellwig <hch@lst.de>,  linux-scsi@vger.kernel.org,  "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 13/13] scsi: sd: fail read commands to offline zones
 early
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261120210651.580511-14-dlemoal@kernel.org>
Message-ID: <yq1eccenb7s.fsf@mail.kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
	<20261120210651.580511-14-dlemoal@kernel.org>
Date: Fri, 20 Nov 2026 21:57:10 -0500
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

> Issuing read commands to offline zones of a ZBC disk will result in
> failures. So do not issue such command and fail them early in
> sd_setup_read_write_cmnd(). This change also checks write commands,
> which is fine but should actually never happen as the block layer zone
> write plugging code already fails write BIOs to offline zones early in
> the submission path.

Reviewed-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
