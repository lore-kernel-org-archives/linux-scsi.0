Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDC8379C57;
	Wed,  7 Oct 2026 02:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791340744; cv=none; b=cXcUtOu1mF7U4YMxpcTioE5TpHJqdnd+zxN3O0/9USGBtAQkOZw4wI81WhidRz44ocuI5qLjwrfkzpR7Mu9HN6kNZTY73t9eXXbUC8mYCXsFX55wE8v5PLoCJEzvXlU9GZVkh4C8Q1sOS4XzaZI/r1rA4urxiHwjjiXeVowlPYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791340744; c=relaxed/simple;
	bh=i4UhY2qc9M17skJLr2fYEhO7HgzEu4FqpkX+EObdfv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8yhbCr8GuPG5LY63M1TX/i8TKsEpwd3gOl6nk8gH/dHNmuuKoKKmO+7VnTNPGA3txKNunKwaaEZWh/IUhnClFEBAV1/DJ7hpgvFWO1tkfJhZ/YFj5IP2pfLo3b9Vxafm6yd9pqGLR29WjYTN8gRInpBK3E0WW0hSg8VTUaYAJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=YgHsxKna; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="YgHsxKna"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791340739;
	bh=i4UhY2qc9M17skJLr2fYEhO7HgzEu4FqpkX+EObdfv8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YgHsxKnasRd7H0CpqYyXJ2t2JsxMaAbLGaNBbj1kT/tPqv0fLoPlSmaRUAMPIjQSv
	 7uSVD8CPhGvoSZL8LI7EA6qhXqQlZJXfE2Jv2totHyfrlbVyQBYo7J/wHwq4CsFh5q
	 ejMNELudOhGYu/vewT4pGwG5bkrgiBzZGc0iR/Qw=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id F0CC0BD05A;
	Wed,  7 Oct 2026 02:38:58 +0000 (UTC)
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 52C8F5FBAF;
	Wed,  7 Oct 2026 03:38:58 +0100 (BST)
Message-ID: <d9b7bfbe-d0d3-4513-a1ff-330a6b660093@philpem.me.uk>
Date: Wed, 7 Oct 2026 03:38:57 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/11] ata: libata-scsi: convert dev->sdev to per-LUN
 array
To: sashiko-reviews@lists.linux.dev
Cc: cassel@kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org,
 linux-ide@vger.kernel.org
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
 <20261006234202.1139018-8-philpem@philpem.me.uk>
 <sashiko-outbox-162543@kernel.org>
Content-Language: en-GB
From: Phil Pemberton <philpem@philpem.me.uk>
In-Reply-To: <sashiko-outbox-162543@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/10/2026 00:58, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] ata: UAF in ata_acpi_uevent() accessing freed scsi_device kobject

This is pre-existing. I've prepared a separate fix which should resolve 
this issue and will submit it separately.

> - [Medium] of: memory leak in ata_scsi_assign_ofnode() due to missing of_node_put()

Pre-existing again. I think this is also best handled as a separate 
independent fix.

> - [Medium] ata: libata-zpodd: stale from_notify flag in zpodd_wake_dev() causes unintended tray ejection

Noted, fixed in my local v10, will wait for other reviewers' comments.

> - [Medium] ata: redundant scsi_resume_device() calls on already-resumed LUNs due to shared device flag

Noted and fixed as above


-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk/
