Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE6A30C144
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 04:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782274599; cv=none; b=Y92CtW7elmDcAuOaXM+UkCr0WgSl6L3a6AN4UH5T1xt8C4iqy4eLJhBo43EJkDiQzCX9+wke81Y7LKtGPbrHxciQ7PNwpe/ZBXmKAQaC7OqIr1niqFOXhKv7pTcO2wr7Ws2vlBnQbMSvq/QSVh8FZ96/K45JIhqLDCeZAOHD+jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782274599; c=relaxed/simple;
	bh=Lc26KowJlK3e/jAywrrZ3UUhy70I+NCKhEk/sENq78o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=iZOg7UXCociP2nAsz45K5fVX4AtlQ67mtfOmG+eHAGpqJaxtTdnDjNmVCGtYXDA2qVogioZqfWuWKDD+0LsZpbITfGmTI7vDxd/bHu8OY7wtMBhepZZ/7eUi+uiKFy5ifP64+BY1J1Ft23/52lg/RIP39roJjUDGEXb3sTo+htM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZzPTJxSA; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZzPTJxSA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=Lc26KowJlK3e/jAywrrZ3UUhy70I+NCKhEk/sENq78o=; b=Z
	zPTJxSAphWRAL6kiPi1iU+WGv3LgO0vRJOzZDAF7fEGUJLkeQf1h4ZjvmIMeb2hw
	7+meo6FFHy3b/DXgjc7cWoOJzBnH8Fcl7Rz6R2cOookA6jJgrIGtBBVpheKdhR9x
	pyuBXuBSvgTUNjNKMzIXOKpsUrok4iO+ZoOkqptoN0=
Received: from haoxiang_li2024$163.com ( [36.112.3.223] ) by
 ajax-webmail-wmsvr-40-108 (Coremail) ; Wed, 24 Jun 2026 12:16:20 +0800
 (CST)
Date: Wed, 24 Jun 2026 12:16:20 +0800 (CST)
From: haoxiang_li2024  <haoxiang_li2024@163.com>
To: "Daniel Wagner" <dwagner@suse.de>
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re:Re: [PATCH] scsi: elx: efct: Fix IO leak on unsupported
 additional CDB
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260403(27802f6d) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <947fd1e6-cbf0-4b2e-a0c7-9d4bda439ff2@flourine.local>
References: <20260622075844.832871-1-haoxiang_li2024@163.com>
 <20260622081220.9D0B71F000E9@smtp.kernel.org>
 <947fd1e6-cbf0-4b2e-a0c7-9d4bda439ff2@flourine.local>
X-NTES-SC: AL_Qu2TAP6cu00j5iKZYukfmUwSj+s8WsO0vf4i245fO5B+jCLpyzEDYXpkLHTOzeC2LxuSuwqcbydQy+9XTK1GRYsko+89fU4V09dpWRxhCieCeg==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <59cce810.3e4f.19ef7d7df07.Coremail.haoxiang_li2024@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bCgvCgDX3wIUWjtqbqgPAA--.1208W
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7RQFc2o7WhSnFAAA3j
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpBdCAyMDI2LTA2LTIyIDE2OjQzOjA0LCAiRGFuaWVsIFdhZ25lciIgPGR3YWduZXJAc3VzZS5k
ZT4gd3JvdGU6Cj5JbmRlZWQsIHRoZSBjYWxsc2l0ZSBuZWVkcyB0byBoYW5kbGUgdGhlIGVycm9y
IGNvZGUgcmV0dXJuIGJ5Cj5lZmN0X2Rpc3BhdGNoX2ZjcF9jbWQgYW5kIG5vdCBqdXN0IGJsaW5k
bHkgZW5xdWV1ZSB0aGUgaW8uCgpBZ3JlZWQuIFRoYXQgaXMgYSBzZXBhcmF0ZSBwcmUtZXhpc3Rp
bmcgaXNzdWU6IGVmY3RfZGlzcGF0Y2hfZnJhbWUoKQpzaG91bGQgaGFuZGxlIHRoZSByZXR1cm4g
dmFsdWUgZnJvbSBlZmN0X2Rpc3BhdGNoX2ZjcF9jbWQoKSwgYmVjYXVzZQp0aGUgU0VORF9GUkFN
RSBwYXRoIG1heSBjb25zdW1lIHNlcSBhbmQgZnJlZSBpdCBhc3luY2hyb25vdXNseS4KCiBUaGlz
IHBhdGNoIGZpeGVzIGEgZGlmZmVyZW50IHBhdGgsIHdoZXJlIHVuc3VwcG9ydGVkIGFkZGl0aW9u
YWwgQ0RCCiByZXR1cm5zIGFmdGVyIGVmY3RfaW8gYWxsb2NhdGlvbiBhbmQgYmVmb3JlIHRoZSBJ
TyBpcyBoYW5kZWQgb2ZmLiBJIGNhbgogc2VuZCBhIHNlcGFyYXRlIGZvbGxvdy11cCBwYXRjaCBm
b3IgdGhlIHNlcXVlbmNlIG93bmVyc2hpcCBpc3N1ZS4KClRoYW5rcywKSGFveGlhbmcK
