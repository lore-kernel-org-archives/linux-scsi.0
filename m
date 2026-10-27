Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093759;
	b=CJnNugBcK9gukNeeU7v80Ryq4ucpPEssSseLWyrGYQLD/CysKx/Ienic4zNbkbNQGO8E
	 5FnQ38ZIEWv2Zs8JN80gANHIdvKP335MDgYKw3t0sir8MmzcDN9eQHhrSHHbnRypsjCnp
	 3w8ZvVl3uKU2CYqnCuwfRFh2Lraa6oZqgsJ+8zTZ1HJkWHq2HdCIR8wwwQAgaoxY5ky8+
	 YbKuI3bDkLXmc28MStfZ0wfHSHcOhgKJNXQE8wNiAzY3YP84Oz2tAxjrcYS+2c2QfRn5p
	 4RxUy22Q5GH2yC/FBqUzdLsO5HGla2VK0sVpyxnYjK9kfcpgl93SNUbFlU8txZ2A3kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093759;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=7pfwiZQ1QMUC3lRm80MKhMN/yJv3QIp3Bl6CJz+OVbQ=;
	b=XWu3e8XlqvUryJLCYuX85Kf8znrJ1i+5lZvE6IGbE/cLGBc44eqV5T5eRhbQKPipYxjl
	 /3XxWeeTv9qNx4+15Eb3JCMDwbsGJwR7b12KuvR42tYJuxFu14ehED3ZxFnqck4r/9Em3
	 N5Q4zODlynYthXezro1pFADAvRCbyDIv64INk5KZPV4j/IEYfk3UWyQaycUSBuzJKaIg9
	 me0iUrtUI+kdCjXwZgYj08lC3ZuweepCd39nDsYxBuofLkRUrssuqYqlQX3NWHIuwlD/3
	 jMiJWKz7m6gfDONOqipkVJr8NcA/v/7j9Pp1wUrwE5ooB2wBjypbD1CE23EmSHHbUAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dtW0xXrW;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E90606A31A;
	Tue, 27 Oct 2026 09:35:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68E90606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dtW0xXrW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=7p
	fwiZQ1QMUC3lRm80MKhMN/yJv3QIp3Bl6CJz+OVbQ=; b=dtW0xXrWYN3Yw8gcEw
	2932+o0gvyWdZNQKkjT3Err0PtvWoBi8uV29130TVlg1/NEEwLEfM8yf+a5UsZDA
	A2mWLMDEwdJWtB6v5CG/Gcw2tQtvtUHv/OL3t1CY3tJLQKenUqtMwJ1o9Eexg/Xt
	nbobo0iuQ6UYvi+GGukMEVBVM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgD3n4FgcOBqzyd0CA--.7090S2;
	Tue, 27 Oct 2026 17:35:30 +0800 (CST)
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
Date: Tue, 27 Oct 2026 17:35:28 +0800
Message-Id: <20261027093528.477408-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026094010.1324076-1-yangxiuwei@kylinos.cn>
References: <cover.1793003363.git.x-professor@outlook.com> <8f30e238d2b169702308303687e9504c7513ecc8.1793003363.git.x-professor@outlook.com> <20261026094010.1324076-1-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:PCgvCgD3n4FgcOBqzyd0CA--.7090S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUY5r4UUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gIHl2rgcGLCDwAA3t

Hi Yingjie,

On Mon, 26 Oct 2026, Yang Xiuwei wrote:
> Tested in a VM: INQUIRY batch latency went from 30us to 42us with this
> allocation.

For reference: scsi_mq_init_request() already allocates sense_buffer
from scsi_sense_cache. A second buffer from that cache, bsg_sense, can
hold the copy.

Thanks,
Yang Xiuwei

