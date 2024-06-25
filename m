Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0887745018;
	Tue, 25 Jun 2024 02:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719283837; cv=none; b=Yrn81m+fEI8Z71CCqk/Auvmu0oUsnJZpeJlGPceUTB1i+L2lKtro7F3lyz5QSu9a5Luyx+bQIlTRSSJxgkJi/yc6PXoyiKzXuXX6EwHVxJwY7QL5hH4YZi/hI0P+ZtdFOc02KFmdXZBlo0zGo0SdNEz3dyVPKW07zHpHBoBB4Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719283837; c=relaxed/simple;
	bh=olk5qCDKotJRX59pkazCBRw6sKMlzkoth15iji93iYM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PlVyKMaGAFZ88QiOra6mqfYUPu7sdmSvGOrgQeFp0cL2wulyPxHl0RcpBt9w+aoDxxdg3VmBTsD/vTSD/I5BgI3GsSa/OkfzN+mJ0XFiXGi8AEHNQrWJTjXxAN+rFd0htwaEEOTzyJvQdU2QSD4k+Gs2PpSNH9f+pa0iQWc7iAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=VLlndhrN; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=VLlndhrN; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="VLlndhrN";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="VLlndhrN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1719283833;
	bh=olk5qCDKotJRX59pkazCBRw6sKMlzkoth15iji93iYM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=VLlndhrNnPukg3SsOn5SgRbahzucm+gWt1toMpNaZ+8WMvGLGRMFPLCDOGdHNcxf0
	 WumDPY/re+7pML8FGBjxL43S7FsvxtnJzT/6A7Mn5fl1QHm4TujsYbuFFYtN/SeMjv
	 E6FwA4NtVlo6Ly5ugxyfmBS92+XyxddecC7DR4CU=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 993C31286300;
	Mon, 24 Jun 2024 22:50:33 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id BHYxdbBEdiSZ; Mon, 24 Jun 2024 22:50:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1719283833;
	bh=olk5qCDKotJRX59pkazCBRw6sKMlzkoth15iji93iYM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=VLlndhrNnPukg3SsOn5SgRbahzucm+gWt1toMpNaZ+8WMvGLGRMFPLCDOGdHNcxf0
	 WumDPY/re+7pML8FGBjxL43S7FsvxtnJzT/6A7Mn5fl1QHm4TujsYbuFFYtN/SeMjv
	 E6FwA4NtVlo6Ly5ugxyfmBS92+XyxddecC7DR4CU=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C7B891280728;
	Mon, 24 Jun 2024 22:50:32 -0400 (EDT)
Message-ID: <9c7de7b8536b56a2bc118044f5f547b94c087321.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi:Replace printk and WARN_ON with WARN macro
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>,
 linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Date: Mon, 24 Jun 2024 22:50:31 -0400
In-Reply-To: <20240624173205.1227297-1-prabhakar.pujeri@gmail.com>
References: <20240624173205.1227297-1-prabhakar.pujeri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-06-24 at 13:32 -0400, Prabhakar Pujeri wrote:
> This patch modifies the error handling in the SCSI library and Initio
> SCSI driver by replacing the combination of printk and WARN_ON macros
> with the WARN macro for better consistency and readability.

Although this patch does exactly what it says, we have a problem
applying it in that the initio driver is now so old that almost no-one
has hardware for it.  As a result we're very reluctant to touch this
driver for anything other than critical fixes in case we accidentally
break it and no-one notices for months.

Regards,

James Bottomley

