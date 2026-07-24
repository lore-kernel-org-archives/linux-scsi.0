Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E6E2931C1;
	Fri, 24 Jul 2026 00:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784854263; cv=none; b=eZhiNcKoASGGaw/n8P+lMN9ieXDC5n2DkmFp0xQm3yfyl6LL6P1ZbQI+pFgw8dY02VgeopA0nigBoYT2n17A1Ld6XasIUfhdscp3ruBZZrMx3s3NBD7uXw/jT30SI2727bDMRwILObz5S1fr/CyeUYsLnet19aStBmhCtqIEHeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784854263; c=relaxed/simple;
	bh=lMByLnd/nJjAlNjTHVRp8sZ9sr1cj8yRGnTJU2SomW8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J7ZXg4d4m8/0om0oWcfY9pf1Jwt52sdFOXhbXmW8SLUeA6BZrj1hzdUokSwWNVlRHRlOIPmGsQwpYRC8Vgge2rpAIpsdG8S8s4do93YAj+KYJueMl+EZWFXQhTIH8sVrIFmcczFVAcUtcRFXbA2Uuc6jDYBeSobZlKRVjNud2po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=kqrwcGNf; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="kqrwcGNf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=RY
	LVKbRdDI9zaPvhqlqlCNMCmXZFALvjMsBxM4+Kvu0=; b=kqrwcGNfd8EvH417CQ
	6gOhHCg3eRbLX7lwlZs7HX3Co0Z8AucCgjo7bRYn8e/ZZmNfDnpV+J1Ax1IjWsNW
	Fb/KzplUEwv3ykF+m8foXaVVKrmuzlxDWBGASOpk4SWiZCQaW0VpzM482da+GZn3
	YSs74W/DjjgiK8q1OrctAHIwQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3n0CEtmJqcWWgLA--.22864S2;
	Fri, 24 Jul 2026 08:49:09 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: csander@purestorage.com
Cc: James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com,
	rc@rexion.ai,
	axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough command setup
Date: Fri, 24 Jul 2026 08:49:07 +0800
Message-Id: <20260724004907.2742329-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CADUfDZpAW261MhFJg434=4nZFMD7mV=LL7F-ZiAWPa7dYvGpcQ@mail.gmail.com>
References: <20260720032338.461681-1-yangxiuwei@kylinos.cn> <20260720032338.461681-2-yangxiuwei@kylinos.cn> <CADUfDZpAW261MhFJg434=4nZFMD7mV=LL7F-ZiAWPa7dYvGpcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n0CEtmJqcWWgLA--.22864S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF17AF1fZw45uF1fWw4kZwb_yoWxKFXE9r
	9xtrZ5Xan5GF129a1xKFnIyFZ7tryYvF18Jw1rur97Zry7Ja4fGws3Xrs5Cr47CwsYvrsx
	Ary8Z3ykt390qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREo7KPUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QgDk2pitohWrAAA39

Hi Caleb,

On Thu, Jul 23, 2026 at 09:56:08AM -0700, Caleb Sander Mateos wrote:
> cmd->max_response_len is passed through here, shouldn't it be accessed
> using READ_ONCE() too? Omitting READ_ONCE() only seems safe for values
> that are ignored (except for a possible check that they match a fixed
> value).
>
> Ditto for cmd->timeout_ms later in this function.

timeout_ms is the example Jens already called out as not mattering if
userspace rewrites the SQE:

  https://lore.kernel.org/r/55f36cc5-a013-4960-8787-fbdf4b4d0c20@kernel.dk

max_response_len is similar here: we clamp with
min(..., SCSI_SENSE_BUFFERSIZE), so it cannot overflow the sense
buffer. Same idea for response.

Thanks,
Yang Xiuwei

