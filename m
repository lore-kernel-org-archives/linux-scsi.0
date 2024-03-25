Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F2D12BEB7;
	Mon, 25 Mar 2024 07:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711352485; cv=none; b=a0VNcFbWTQKhMwcJGNrocA935XyTAtWIaa3lyi2TA0/WCE5LUJDa+6qtt77tToIIh7S4J9QYtvNKjm/XJJ4taZb1Dr14a+7p7bdEf+z5F3bg4AXlm/ugAdEC6dcyk86rVCd/G9k8QzNBCawXtAJtT3jwL3hpkNApTDxYlT+T3PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711352485; c=relaxed/simple;
	bh=PaOjeQTXUXH777uBTd4u+MGPOvH/o5CMLR9zmwwiBA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AG2xB600jQlml+j3TEgcI8beBNZxdnaLYXuXP7U92ofElIHMrXZxCMmNVTYVzF+bJU1nTT8ozR6JkkccSmQ7DDItPJlJKNX5xI5cqW0vH6NaJS3k4IY+/7yFwB1rRTTyiy27OxUQJf5o26E11OIXXxpeaD5vN82nCpWNyzHpjA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUQCtc4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUQCtc4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D2DC433C7;
	Mon, 25 Mar 2024 07:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711352485;
	bh=PaOjeQTXUXH777uBTd4u+MGPOvH/o5CMLR9zmwwiBA4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jUQCtc4+99JJBf4KiYXqgHSnqGbKtWO2F3eDQObnbRVLVH3L6SA7JVXD8VuG4dPW+
	 JG0oxQEoo+lFF0BIOqX9/txggXEueMRPhvBjTdhVmyqeK3FA3A0WMW2FgIdvb38+MW
	 HGi9UXjAw/EvJHGsg9ctp+ksfDNwKK5wDkGTQoBR7qjP6+QCMPRdoII7HIuDVNv46B
	 dLqz1Jv3D5d9yaAuCmopm+nWiRNFcSB//NYEfuRzyHg0IXw/Y+ZeAz6mzFeGK4Vt2y
	 K7A8t7TTZquOBBWgJ2PYjBXWh+5kgOjMXy453NOxQitsLuWhRGLR8Kx//Xdtb6t7O/
	 nazjXSK4iYNwQ==
Message-ID: <b55b31ef-05ca-4487-ae7d-6d107c84f76c@kernel.org>
Date: Mon, 25 Mar 2024 16:41:18 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/23] mpt3sas: switch to using ->device_configure
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
 mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-13-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

