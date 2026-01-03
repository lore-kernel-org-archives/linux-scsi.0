Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245F11F4631;
	Sat,  3 Jan 2026 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767444866; cv=none; b=fZ6aBMJlMX8j3itFzMaV4Y4RSBmc8b+LM+3hJKGRRKaDlqMM/TIJDn2cAf0ul0W4/iK40bc3tl3BVs8INUpHn1f80A5+8E92pirTlbaVJSxr6RIftGFzt00ps/fWMDZ0GkeQl8LhtVA6xx8EPxyb0IXIkuLc73viPOzMp4Lptyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767444866; c=relaxed/simple;
	bh=BSfWgisULhkV2rSmRnxMhWRPsoxT+Te3B4ksg/psv8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KV01mdAXAYGY2OipMEYnvVdxD3W36sg9/9gqdZ90rJGS22NyrWVUUkikPco7e8tR5pxn7jajcx8w+BOx/Ee4vsSC8g6ve19gcsbri3wYPg63q3Uh+GYkt6q/gRZk+wpeChrdaM9oNncyqY0xR+CeDE7yaCNvcLitVIGEOsWKIPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=ClMA4flu; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="ClMA4flu"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f5c789fe;
	Sat, 3 Jan 2026 20:54:18 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: markus.elfring@web.de
Cc: James.Bottomley@HansenPartnership.com,
	jianhao.xu@seu.edu.cn,
	justin.tee@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	paul.ely@broadcom.com,
	zilin@seu.edu.cn
Subject: Re: [v3 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
Date: Sat,  3 Jan 2026 12:54:18 +0000
Message-Id: <20260103125418.179210-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <4e57c44b-24e9-408a-8458-845b0b9fbbde@web.de>
References: <4e57c44b-24e9-408a-8458-845b0b9fbbde@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b83ec47b003a1kunmf2f18023264bf5
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHR4ZVkofTUlKQhpOT05JS1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJNS0pVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=ClMA4fluOQ5YpVwrcL6RQe/HAzA8qIhuHiSRQ1O+tF8lTEMK4UUapk1QwMTjPc2ToTjzSKDBRy6s0yU+at5RCn/N7x9XW5FGsiH3rRo8bwm2lbd9fLSX6rRlxWiGpgQXLflmvIiiCA63Yc0gkxivJhB2BsMJDkmMJ15SVRuNFyY=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=xkgUGvsi8UXAgpUWuqvHPCw4/z2eAbZw9otWDTVp5/Y=;
	h=date:mime-version:subject:message-id:from;

On Wed, Dec 31, 2025 at 05:33:32PM +0100, Markus Elfring wrote:
> …
> > These issues were identified during static analysis.
> 
> How do you think about to share further information according to
> your source code analysis approach?
> 
> Regards,
> Markus

Hi Markus,

Thank you for your inquiry.

I believe the commit messages in each individual patch within this series 
already provide a clear and specific description of the identified issues 
and the analysis of the failure paths.

Best regards,
Zilin Guan
