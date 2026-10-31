Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410309;
	b=U+8pLI9FZ1sv9ASdVpSvU3P+MBiIo/l60/P7KhrW0wI4Z0h9mL3AcTTYfWvNRAes8uBa
	 fi7c+9cLpkTyxJqHcYwFQQFQbvYl19PU+o+euDlp7HBa6EhkWlmvcqTI1sG7Npk9U6W7j
	 V+9Dm28RHjmt4EachLhv7QqGZRqyP+TJXtRY4tVRPGMXCd2yEgvQPBsRvraw2Cb+OQVnr
	 dTiRE4H0sC9M2n713QSCwrcL3scAl1K6aRR4lrjY6qSlqPFhPoI64V8h3slwHYsjzvODd
	 /Svfon3yJJ8LOKVs8W6oWyuXRrV/pNp6a0+hqOCyWUgj+5yFLCmQSNdXAZMpKO70t5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410309;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TGo6sltIvptXhhkRSMpFXewk/1vuYw/aLsLlDrg7iDA=;
	b=ltxA7/ttW33RTBl8uedps9fcTAOQA4h920FkukLOsoHH5RgFkOXdk4sa6k1beMn23hdt
	 T+aFWR+FKjeeHKvkXEhybnFUQIof/TOlA0VJT6cBXsLoT/SSwBOx11/4AMIoPGKhx++To
	 +l3mP7tuNt03pyfuxjXkljIVH1Yt0B9JfhZL/HcUE2e50rejoXnMzPO9fj4xWpX3g8WG9
	 emE+v+I2Pe9la9qxniLF3rRcAGBBqNmvKWeA/wcs1kCXvYOweFdItmgTNaPjdSVJIa9yx
	 7t2dgxLo+9ZQsKSkeTHscSlBYcW8olOewJWarD+dKkDZvLebh5AieDC1k/mUqp6WZ3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JOwAAhJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77056606A31A;
	Sat, 31 Oct 2026 01:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JOwAAhJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDEB1F00A16;
	Sat, 31 Oct 2026 01:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410309;
	bh=TGo6sltIvptXhhkRSMpFXewk/1vuYw/aLsLlDrg7iDA=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=JOwAAhJ/EHJ0Y6RPINf6yjfJIjTUUCwi9O8gwNMBZopNFcm2y/k6tqxaNF1po73Vi
	 zrEV1q6tMlfGEJgY1PQ5zot6R8+T59VnRafnxk9+Ou9so7aDgEwNP8vkYBL9zppwcA
	 I3Fhw32LuEvhagpBcSuJ9JzULPrQs/vPXXwD7rh5K/R8ng45OOl+y6Gz0MbLdGo+5g
	 poaYUb0nv2tA6MKJhpm/1fbL+PqcR6HEnUitWxguUQbZkDWzjul8ZVEfPYjr3TmqHJ
	 sShbvyoEPJVDL/8XB/bYA9ZEIou1GocTyeL/XaApMAoUXuFEGExburGe4lyBy9RwDB
	 0zX4A4GSxvgjg==
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,  Paul Ely
 <paul.ely@broadcom.com>,  hare@suse.de,  msmurthy@linux.ibm.com
Subject: Re: [PATCH v2] scsi: lpfc: Fix race conditions in ELS retry
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <29073ebc-b616-475b-bc05-384da09fbb54@linux.ibm.com>
Message-ID: <yq15wyi3bf8.fsf@mail.kernel.org>
References: <29073ebc-b616-475b-bc05-384da09fbb54@linux.ibm.com>
Date: Fri, 30 Oct 2026 21:31:47 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Kyle,

> This patch addresses a race condition in the lpfc driver's ELS retry
> event handling that can lead to a use-after-free in the
> lpfc_cancel_retry_delay_tmo(), where the NLP_DELAY_TMO flag is cleared
> before acquiring the lock to check if the retry event is queued. This
> creates a window where the timer can be rescheduled and fire, causing
> both the cancel path and the worker thread to release the same=20
> reference, resulting in a double-put and use-after-free.

AI review commentary:

- **High:** the worker clears `evt_arg1` after unlocking, potentially
    erasing a requeued event=E2=80=99s payload and causing a NULL dereferen=
ce.
    Capture and clear it under `hbalock` during dequeue.

- **Low:** missing Fixes tag for `e47c9093531d`.

The mailbox is also line-wrapped and fails `git apply --check`.

Please fix, thanks!

--=20
Martin K. Petersen
