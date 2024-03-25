Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD347F7C0;
	Mon, 25 Mar 2024 07:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711352054; cv=none; b=Qmw0KDfmEFEYZyKIrmzxbsabdJKWrbeBD4or/Gh6B4/LwzDgXisgh2Fowm4jIken1KNOpzVgpW4kv2eahEMTU5KpOcudGOQoUcRekgyLjbysATu5BP0sT1tVXKCYySHgVM2gDnByf4xeW2tMX1D5IFeoQiaYdUGxkae4XqXQiqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711352054; c=relaxed/simple;
	bh=GYfhhQCI0HEBDSAfk3WZNrC6oWQDTVD8vAnkwEiPM7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SDTdsTkUnzyXG5SWucVrooaE0C6xuGTyXUre0S2qiBjG4KRhwoOZ01GHeAGiniCqkhxBYOy6s1rBmVKNCJR1guMbViBWEpAhaGRtxWcttYMg86G+cD4bLoaAg5DfcHMNZTNMdYm+8BfAbfB865GkeOKT8NN9XIL/XUPWxvUviMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxcVi03w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxcVi03w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85F7C433F1;
	Mon, 25 Mar 2024 07:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711352053;
	bh=GYfhhQCI0HEBDSAfk3WZNrC6oWQDTVD8vAnkwEiPM7Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WxcVi03wKqjeMHplvNl2L/OTj6Ipo7kIQD6J8p+TCNpgVHDS41sUtFUM2Nv2hYn/T
	 m/f6G0u1t6S5w0EvmrRn4NOSQCAZxVof9Ep9NBPYTv0eioG+enhIsugaDYYIYvEvMB
	 QimR5yeASB63ej7Irbm+CykIdHGB9C3wZecYv2PM6/gdsJkqTiKjQi+DFpJX6kdkky
	 etsunOc1chgeDpiCUuXQ6IabxV1XoMfI5LpfvXk2U9aH62yq5rIwrvsmdqipBPLIay
	 8QcBB5A3FWC6FSwDd1Cv9sLJzr0a4X6E05DpEgjivEQ+R9e8pJ+1+8y3Pea3SQ2wic
	 OQLq724QFfrWw==
Message-ID: <942dc890-9a1d-4008-944d-816f7a7c470b@kernel.org>
Date: Mon, 25 Mar 2024 16:34:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/23] scsi: use the atomic queue limits API in
 scsi_add_lun
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
 <20240324235448.2039074-10-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Switch scsi_add_lun to use the atomic queue limits API to update the
> max_hw_sectors for devices with quirks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

