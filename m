Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4886208D0
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 04:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728447233; cv=none; b=QWxsHrULAEAxo7Szo8uLkz3JkCHcHWEKHO9Fg7+c46yfD7zTXDay2lwx0VvhwF2i1EyGHpsjKdkKDYEwWgq/67/cAamPfNnqj75cxnTQfE3qoi9aUcV5tPwY98kjUuiRzcqzyzRAuEOObFtqu2DY5g1dNb/cnw6ONSJxznOrIjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728447233; c=relaxed/simple;
	bh=hQ98A6oH2x0aXD4f639AMcATG+fxSzlO6F5g74bElGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sF58yYUg5Q6O6r2SNBjOOo55SGDiPKsOeXI3lqhwErmj+BaU9dn+Q28b8d8y1cROux23MzmGdZTwRPoMPZzaaOtCtZDhqvTMxyuINQREsqpoF3FKDA+gPWfHkZuXu3n7sSJZOPdFliYaqZD/YqPxIzD7eK2flmv3DFYN/GOYEFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCExZexk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCExZexk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDDCC4CECD;
	Wed,  9 Oct 2024 04:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728447233;
	bh=hQ98A6oH2x0aXD4f639AMcATG+fxSzlO6F5g74bElGc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NCExZexkBzJGwcTwXX4hRphYlBDHuFnvTnlQLDQwdZF5x83gHYmL5rPxDLKN5pdY2
	 MzSOBn8z0nfGVI7C4wdWubgoT8gw9g3hOkTgLwosllOOdcnT4nDlkMvqjYoJlZgaYV
	 w/EHX48zf8B+YEMeCAbST+QFDG4+Vv4M7QsPfge8S6xlZiAraheP3Po3nHyDhRw7Nd
	 TKAYdnGfw3i25uECor0b8YZqek/hIWCBfWm6mQlkrCJ+vZeHUHDhavFcqxcxDg4Rhz
	 X498Dcmm9Fofw0Vi99AUaYBiC1oWxvt4xmyBUFwtci0x40jG9ufw/nVvL82KJ785LK
	 qSmjuBCM8XbvQ==
Message-ID: <e7067f1e-a3ed-4110-970c-bc55f707c6e3@kernel.org>
Date: Wed, 9 Oct 2024 13:13:47 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] scsi: Rename .device_configure() into
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
 Oliver Neukum <oneukum@suse.com>, Hannes Reinecke <hare@suse.de>,
 John Garry <john.g.garry@oracle.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>
References: <20241008205139.3743722-1-bvanassche@acm.org>
 <20241008205139.3743722-4-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241008205139.3743722-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 05:50, Bart Van Assche wrote:
> Improve naming consistency with the .sdev_prep() and .sdev_destroy()
> methods by renaming .device_configure() into .sdev_configure().
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org> # for the ATA changes
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
