Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBEB19C578
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908561; cv=none; b=SP016d8TdSP/1BpYCOzxQtFxNXqVBpe7yNs83oJ54CDd57R//C644FrUYgBPExY6apSF6OtwqnwUTZzhVv6dMCqvE/dovXcPqJcC5eaNzyk8y4yX1/bCwh34OVzoRHYGQ00AIO2zuwuzRBcILyfT//lR11myDv4LAfLg3ThvcKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908561; c=relaxed/simple;
	bh=N7c2ccrT3xIU4LhPSJKYlI0XNhQw/buHcuuWAEgsXMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AfkukjEc4eqN4hVVHVHdLzcCC3HzXgUh9k9pOvatsDaw4Say4yA71aPX2aT+3t2szWkVmwaIqA9us74xVvzw7K/Z5thZQIA8zVC/mtSLqDSdOu270p2p5Iyjp0pgqBNWzfXx1ljiYLkOXVzVAciTg5yIcG2vOtqqlWJeDKzo/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=og3UZhT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="og3UZhT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DEBC4CEC5;
	Wed,  2 Oct 2024 22:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908561;
	bh=N7c2ccrT3xIU4LhPSJKYlI0XNhQw/buHcuuWAEgsXMc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=og3UZhT+nQY5u3FrmDfFm9VKo4PinH/wiHwHB0XWo8a5Mr928R8GVSdS8veFGFmVI
	 Cs3eCLTmNJVKhNy4PzQ+f5IIhzcc9WQnGBhCJIvKDX9a5E9mlPi9x7WwVnvhiFclTH
	 QR2OKMN3t0C9Rf3Yq5ClrPyV533rokxd9iABXHGw5O2rJAoTR8V6mcWGR5+t5xiYhh
	 4FGeXgBJdICg6UTqLOecHn1QU/lh7Eq5Mcy/LmWlk/adsqtaTuTSOV1lmBd4rrN9Lj
	 7606ZgR7pRjCgh78SwgR5CcdPmmwNevnx5INPVck3sMY3dSRw70IRttZp+QiczrYd8
	 OpS9eR89+Bz4A==
Message-ID: <4bacb773-bf8b-4275-8411-a31b8796d779@kernel.org>
Date: Thu, 3 Oct 2024 07:35:56 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/11] scsi: Rename .device_configure() into
 .sdev_configure()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Niklas Cassel <cassel@kernel.org>, Takashi Sakamoto
 <o-takashi@sakamocchi.jp>, Yihang Li <liyihang9@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Brian King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>,
 Chris Leech <cleech@redhat.com>, Mike Christie
 <michael.christie@oracle.com>, Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Oliver Neukum <oneukum@suse.com>, John Garry <john.g.garry@oracle.com>,
 Hannes Reinecke <hare@suse.de>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-9-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:34, Bart Van Assche wrote:
> Improve naming consistency with the .sdev_prep() and .sdev_destroy()
> methods by renaming .device_configure() into .sdev_configure().
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good to me.

For the ATA bits:

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
