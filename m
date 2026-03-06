Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49121D5141;
	Fri,  6 Mar 2026 03:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772766302; cv=none; b=gKaD3VbACygEBFTx+ZC+scFXOSDXfOg3ecrHqEGPxOg4flyb9hBGkIJ8p27MsV0Ef4Tdvk4JMcKkn873wTxtIAw9mnpQ549Wd7ykZsUmMMexA/5YJSfh1quIDmoP59L2LGckAZn6bgPjn8859FGBSfeVOwvNEvgG/qPrNE8HD78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772766302; c=relaxed/simple;
	bh=otj5c3pqSWfgdGpwf97o8EpSqH/cu8ZuKua9Qo1pOCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AFhmEnxKOwshetSL05fhS0pZ45FCCDiHr1JzWpf+LNikIn39timpYJnDs0xrspO0u3Q3Bfcmpi6Ir6188c6KrxJ3i4Bjr1tq+R0AMkHwzDf7tZU2G4sD1D7gUw5Q6NT2h3NNcHPllQE2jg/YFlgN5mY6VZfpSoslAN3Clw7nXt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XLUsdVLk; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XLUsdVLk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=3D
	K/adoQANkoJkYrQIQCRgvvchadBWXhwSEVNNeebro=; b=XLUsdVLkVqCOjDtJzO
	Ont2ZAPghiLspURyRIy8Y7pkn4Ukum2mKK2k1e66RLo4/IXj8wBmPs/tLBeiaGJu
	se/UrczYjIfSjSnUl/i1YvQ9NQ1nXSQ/S+fGNsDvCnzHSx9kIQ+bbeLlFW/0Mjom
	aSxO4pHbsa+qmufVcSzhUEQYs=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnnzwORKppBGGbQg--.56949S2;
	Fri, 06 Mar 2026 11:03:43 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: bvanassche@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	yangxiuwei@kylinos.cn,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] bsg: add io_uring command support to generic layer
Date: Fri,  6 Mar 2026 11:03:41 +0800
Message-Id: <20260306030341.83253-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <072ec437-c324-472c-9fed-f9b2c6e69233@acm.org>
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn> <20260305012857.2136525-1-yangxiuwei@kylinos.cn> <20260305012857.2136525-3-yangxiuwei@kylinos.cn> <072ec437-c324-472c-9fed-f9b2c6e69233@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnnzwORKppBGGbQg--.56949S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUogAwDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6g8ZqWmqRA9C7AAA3z

On 2026-03-05 15:17, Bart Van Assche wrote:
> Please order declarations from longest to shortest.

Done. Will reorder variable declarations from longest to shortest.

> The traditional Linux kernel coding style is to return early in case of
> an error. For the above code that means writing it as follows:
> 
> 	if (!bd->uring_cmd_fn)
> 		return -EOPNOTSUPP;
> 
> 	return bd->uring_cmd_fn(q, ioucmd, issue_flags, open_for_write);

Done. Will use early return style for error handling.

Will include these changes in v7.

Best regards,
Yang Xiuwei

