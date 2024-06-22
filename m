Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5590D14A0AD;
	Sat, 22 Jun 2024 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719055536; cv=none; b=IctOnz6h7jjir9Ooes2JjXxrwya7vzyxhjM7RXNqIPrIM9B/BF03rOZ2plJHSJn/VPUcfBnRQ5QfaHja/6pm/ovx6DNc1etIw8tqDPnf7S0yQcXD2JCmAsRNvy1zQWfYBdJtVVUzprImmWQGFvWiTL6JXoOGOfphfGKsnkJOoZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719055536; c=relaxed/simple;
	bh=GPT/1XPLpKB4VBYT5uBKjq0mIBQxVbyimoECNzXCIoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnMJ3or0+m2U0rK+Bf1TJEQvAt/Bm4N4/0LqXxHeNNOyQwnX5fExY/R/FY7lFCpYWhjBQ7BcNtuH+xUf0xGHHj/RGG0n5EIk+cBeWX3ZzXepQDa7hbyrU2jcVgdVC83AyjE7JCDl/ny8brict+nnWC0qFnfyyrhHHZKFyhkhLEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lD5dOve+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lD5dOve+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CD9C3277B;
	Sat, 22 Jun 2024 11:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719055535;
	bh=GPT/1XPLpKB4VBYT5uBKjq0mIBQxVbyimoECNzXCIoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lD5dOve+oE0ytmDKM58eSpn8ka1uH3p36wgKghcYko9h5ZEI4YIo2rIzd8QQtvZ9L
	 HDEl83z2Id8E8QFGFIdJ/FrW1lt8E0OKdSBucTASK64ilhET/UXDmsmbWdNv/nAHL8
	 wO9rH/7b6EFB9wKRrM51oKmM8bOR7xfNj8+fFVuCn48zNtvdT9cUhsdbSZEd7QR9qC
	 QsQBu7ikt2yV0tfGLNH9gMEF5OmktyznFK09BRbBI0Ucb/px75F+Am4AEi+zFetDaA
	 kYK1i4APg3yU+UmCiVr1EtzV0m868Y/GVEt3dmVAKBtgr1xoxmCe0Tk8zwBZvW8RWr
	 erw+wDg2pvNDw==
Date: Sat, 22 Jun 2024 13:25:29 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Yihang Li <liyihang9@huawei.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	john.g.garry@oracle.com, yanaijie@huawei.com,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	linuxarm@huawei.com, chenxiang66@hisilicon.com,
	prime.zeng@huawei.com
Subject: Re: [bug report] scsi: SATA devices missing after FLR is triggered
 during HBA suspended
Message-ID: <Zna0qRpV3V6aVLZD@ryzen.lan>
References: <20240618132900.2731301-1-liyihang9@huawei.com>
 <0c5e14eb-5560-48cb-9086-6ad9c3970427@kernel.org>
 <f27d6fa7-3088-0e60-043e-e71232066b12@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27d6fa7-3088-0e60-043e-e71232066b12@huawei.com>

Hello Yihang,

On Sat, Jun 22, 2024 at 11:31:29AM +0800, Yihang Li wrote:
> 
> The issue 1:
> a. Suspend all disks on controller B.
> b. Suspend controller B.
> c. Trigger the PCI FLR on controller B through sysfs.
> d. The SATA disks connected to controller B is disabled by libata layer.

While I'm currently not planning on debugging this myself,
I'm quite sure that you would facilitate debugging by actually
providing the exact commands used in steps a-d.


Kind regards,
Niklas
