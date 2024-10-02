Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA19219C55B
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908631; cv=none; b=Jl9pLDhIbc4uqYR/IBJfL+MXNd9+4YjaIjuYfvOykvTYhPjMRfyuSkI9wXVVBckSU8P9fq4jjANiBlWA0bbr0fhomgFg7lgXEdMaldhml4Ihj52ExO8DHX+9S2cLLUnckQr6vzI5Z23I38blLd9Qj2/H/9xuQpkgzEEdZepsHOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908631; c=relaxed/simple;
	bh=cKkrQddCrk2qI/AHiqd0pNeZ13L42DdPBzzHZtWLgMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iXBIfDwgDH4V78kqtDIYcqP9V6xpjP6pzT8ejwtct5H84hGaBD8ifrHKL6TXMVqg8f+yIvwSkevdec4lqAyul49dzAKXmp4/uCaUDW6M2vUPuUzmeoiLvkE9MB6dT6uIpVPg9mu7N9tTBRa5OdR6V+EalkoFAgiAcLFrTL2Lnw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAkoME5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAkoME5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DECC4CEC2;
	Wed,  2 Oct 2024 22:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908631;
	bh=cKkrQddCrk2qI/AHiqd0pNeZ13L42DdPBzzHZtWLgMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BAkoME5ejyI7tcsNBILBrT1WpuaF07HFeIeX4N+ch9y7o3RzuVsTKOCu8KO8/6BT0
	 HbdjnJgnG91cAxzjsTsIKwIZ/pF7SDOULw1eSDXicmuS89bGL/tkoca2p1tkx7Shv9
	 JirSzVt/hFUvBYeVqNhjzscBZ+Akbd/lsvIzCFpOEv75kqGYgB1230+ymwOkCHz7QU
	 lUuKcXEkdIjxwIrSTaQUqwUb/1eLdJCslxt+owPVxau7snW5ZW/X1q5nfL0FQSyvxc
	 RAL+aFLhEMTxaMA2JAmrXexAFzGl1VnaNprhZwawmCVIrfMmjIE3uAbyar2fE6K6lJ
	 DfEBQeVXwWcWA==
Message-ID: <760414b2-3fec-473a-bb1a-56619c18ecdc@kernel.org>
Date: Thu, 3 Oct 2024 07:37:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/11] scsi: Convert SCSI drivers to .sdev_configure()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Geoff Levand <geoff@infradead.org>,
 Khalid Aziz <khalid@gonehiking.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Steffen Maier <maier@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Adam Radford
 <aradford@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
 Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
 Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com, Don Brace <don.brace@microchip.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>, Nilesh Javali
 <njavali@marvell.com>, Karan Tilak Kumar <kartilak@cisco.com>,
 Sesidhar Baddela <sebaddel@cisco.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 ching Huang <ching2048@areca.com.tw>, Bjorn Helgaas <bhelgaas@google.com>,
 Soumya Negi <soumya.negi97@gmail.com>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-10-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-10-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:34, Bart Van Assche wrote:
> The only difference between the .sdev_configure() and .slave_configure()
> methods is that the former accepts an additional 'limits' argument.
> Convert all SCSI drivers that define a .slave_configure() method to
> .sdev_configure(). This patch prepares for removing the
> .slave_configure() method. No functionality has been changed.
> 
> Acked-by: Geoff Levand <geoff@infradead.org> # for ps3rom
> Acked-by: Khalid Aziz <khalid@gonehiking.org> # for the BusLogic driver
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
