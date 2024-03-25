Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74156139566;
	Mon, 25 Mar 2024 07:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711352984; cv=none; b=j2/IuGCw9ErJagaWQHBkP7dFLUm+ot1hPauUZVO/TF7LQPEXM1lo/USV0QMrAQstPMmLm9U4Nb0VlKqxiZcHVUWmvGR9RCjVXY+zFjVD2Fj2/d/uGDpzeeEq/dDIRuPfkqwPQO7Q5/PkaE29T6cPe8HwfEBKplpsOLQHR8Yut14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711352984; c=relaxed/simple;
	bh=g2liTy/svI2y0Rrkakwfy55aiwUTTTcX59UpQY/YMaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tnfudbBn4WmcIVURCxwFuw8izpVPgE/LLW4Ab+gKwkl+vJ6Ioe46MCTTneLFtNPRTn2I9cF9ph4QsMK9M7vTgfSXCQ4Dqvk8+mpeo3HMtGeGe9v9iVZWX+r/70hitF9ve6EEPFp++LZtHmUHLE2vHukiT8saMWQ7if8WFadL9e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IeufiVsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IeufiVsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F84EC433C7;
	Mon, 25 Mar 2024 07:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711352984;
	bh=g2liTy/svI2y0Rrkakwfy55aiwUTTTcX59UpQY/YMaw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IeufiVsALvz53psJC6ITZ6ifsETNmPoVX/uAnTIUE/Pah8LhpTpG385nM/7PMPwb7
	 ehPwFUI1cNbpCmGoU92fKINkuggZXn0DK41CKRNyZtCQC9IzHbPHM6bj/XAT1DUzc4
	 ZFKAfc//meUhUtHSTSr3tg5pYtdKG68HB5GwDLRVN/5mEUk93qn7/xoLtCGWuTYqZ/
	 R+Z2QWCeMAJnx0NWECYY8pglW0fA9Q3e+fdR7Okt2n9+ALDR10JN8N/x36Au5u5UYf
	 SZmj41muOkcGDpxXDdipCmomvYgtG/asN7MUcjOc7l20qj7NRHR+KVLnJxHoEG8/UA
	 aoo0BC8h3XwBA==
Message-ID: <b1dba4fa-5a5d-443c-aae3-e8e5aea3eafe@kernel.org>
Date: Mon, 25 Mar 2024 16:49:36 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/23] sata_nv: switch to using ->device_configure
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
 <20240324235448.2039074-19-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-19-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

