Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007700;
	b=f2ubfFHTk/Hwk2HneJ6ycjw9JAkiDusp/QLI+fHymAIQBLE0I0rub1P6DZ5X6PQUIc0v
	 SHkvXzUok2ILJsm5YvEpSd5OogAnzfanwo8a2i1wH0DLKcZvawpY003PY1Erou/603FXL
	 ti27bxiiGZkYimgKo6OLMO9spN/DeZ83IuEN+E6oJi8ZkGkAMMydbpUOeSWSn6APOKG6X
	 ST6No4HwFBiZw1slX9NakCSHrfOhkKEduPKdcbq42vEzhvH9gDbAy3nFskPARTyPcLPmo
	 vQfM8TgSJnp4CY47tFVbEGyg3G0D3OUeTJGOBxYkX/Wyg/b3t6IgCwrwKY8Lhj9zhGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007700;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=JgiWxZmRIHTWEjiXSDwq0C9oBBVSA5xc05w3DSwHI58=;
	b=yhAGSdvcFDlJkeJsn05xl6QwN2YLChtLr4vq7Ai93p9ZxJhGcJoma+C9oAnqqPMsq4qp
	 No841WEWRdn1ABwtzHv4alsvT1oOjYHxUjQveGi5Gv5npHh0DHttpepsD6UHGAg619E9n
	 7TkKl7Ark8yh5iqf2wnNuo/knMsgYS/i/8gSj6c31DAiW15eUTuhR2Z3nM9tsiqRG3OXZ
	 Fc/SZf7lO31gNTYARUYsIR61xBtt8bUiMn+7TPSOErTWfSC7PdQsAgJP5enyJZREW3wwF
	 NLmO/aamkeor47Ug/8HVtU006RfXgKxO16em2F/UrdXeinNDgZrn+X/FCfw77to7Lgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=YXC0Ropa;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02424606A33C;
	Mon, 26 Oct 2026 09:41:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02424606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=YXC0Ropa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Jg
	iWxZmRIHTWEjiXSDwq0C9oBBVSA5xc05w3DSwHI58=; b=YXC0RopaQByhhsrR8l
	bq9vFwEWO27+xAG/HZDxga++ggErN5QV3kZV7sM9YWZN8Fvo5SdB1OBnYZBuDG/W
	7FpSvDpWDrIxH60ca0I8BJo3vN/NHakcpdw7+Efl4XrXqmw9qBMDtniuhUKJq60x
	zIQUqQq5zi6pbgQ1MFDqKwabM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD337_7H99qxoxSCg--.51708S2;
	Mon, 26 Oct 2026 17:40:11 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: x-professor@outlook.com
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] scsi: bsg: release io_uring requests in end-I/O
Date: Mon, 26 Oct 2026 17:40:10 +0800
Message-Id: <20261026094010.1324076-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <8f30e238d2b169702308303687e9504c7513ecc8.1793003363.git.x-professor@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com> <8f30e238d2b169702308303687e9504c7513ecc8.1793003363.git.x-professor@outlook.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD337_7H99qxoxSCg--.51708S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUYc_TUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6huYKWrfH-uF4gAA32

Hi Yingjie,

On Mon, 26 Oct 2026, Yingjie Wang wrote:
> +		pdu->sense_buffer = kmalloc(pdu->max_response_len,
> +					    gfp_mask | __GFP_ACCOUNT);

Tested in a VM: INQUIRY batch latency went from 30us to 42us with this
allocation.

The long tag hold is IORING_SETUP_DEFER_TASKRUN. Returning -EOPNOTSUPP
for that flag seems like a compromise. I'd like to hear what others
think.

Thanks,
Yang Xiuwei

