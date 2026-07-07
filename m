Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1CE18FDDE;
	Tue,  7 Jul 2026 01:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783386761; cv=none; b=S3l2gbMSvlZjhSorIC5QQQ4YRUKKXTLTj9T+JXQ1Y246mH2hyf9XGNfl8+LCn4eynVqh6RF11gzuydixqsySHgjiUGKuB1dgAo/E3SsfTkuclimIP3GO/UfiCiJf/NSiW2GA8HiMqiDlj0nA6dHpyIAChTARc4cccCg/N+iO04k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783386761; c=relaxed/simple;
	bh=Oa58u2MEFM17e6mdrEnFTSH0F2mIknYamCu58oZtmWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JVt8F44b5lYAvGYex1JNw5BMakuI7e5rDxFmpieJ0nPxagrOP8SGaeaDPDcuNlhgWu96X1Gn4LXUuTOi01Dc7PgQGvoFd4B2Z1mmP+TZ+3NEGKnL9jgWDCpVVpXWnPbZeoYemXt12T74jRtQzpdyrqy27sqIbrxzf7f9Cet8Suc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqV/Etli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqV/Etli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BB71F000E9;
	Tue,  7 Jul 2026 01:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783386760;
	bh=Bpr94blKxteo8hypXiKiHMmG4NpkfXoLHUxXUd6dXlE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aqV/EtlifybphsGTzPN4XSgCiBcycrTeTLlWNLVUrKOrd09ebjJiXqQ0Cmjv2hygY
	 6g4hqp4xh5cumNqeNUmmRJa0ZWUkraM+OAK1+9cZSEjECKmtIDOXt+7/aq2eUHmiND
	 6QZJnGmOlaJ82h/7L8lLDDrT+J6h86c00nbiHrhwdQFlD9joO+tW7amMONpy/FUiBY
	 3p/wOqNIS9XBnud3q9ZptwP7wDH4S4YIt01VfDJdWuNXL50hchTL7d17v8JemjVgEa
	 imy618oWv77Eqtu/Ke81Pcg2XDYrPhz4go4uBzfqxcNJYXwDAFusW0siencRO1Qo7u
	 m+3dp0r6bKQ8w==
Message-ID: <7368b556-b874-4d90-87de-44d7f0d3dc31@kernel.org>
Date: Tue, 7 Jul 2026 10:12:34 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] ata: don't store pci_device_id
To: Gary Guo <gary@garyguo.net>, Bjorn Helgaas <bhelgaas@google.com>,
 Zhenzhong Duan <zhenzhong.duan@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Niklas Cassel <cassel@kernel.org>, GOTO Masanori <gotom@debian.or.jp>,
 YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Vaibhav Gupta <vaibhavgupta40@gmail.com>,
 Jens Taprogge <jens.taprogge@taprogge.org>, Ido Schimmel
 <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 David Airlie <airlied@redhat.com>
Cc: linux-pci@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, industrypack-devel@lists.sourceforge.net,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-1-2d48fc025acc@garyguo.net>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260706-pci_id_fix-v3-1-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/6/26 23:11, Gary Guo wrote:
> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. All information apart from driver_data can be easily
> retrieved from pci_dev, so just store driver_data.
> 
> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Looks good, but please change the commit title to:

ata: ata_generic: don't store pci_device_id

With that,

Acked-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
