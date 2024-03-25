Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E272C12C7F5;
	Mon, 25 Mar 2024 07:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711352522; cv=none; b=XsupVVtlkyVaKQbRmsDY/DGmNmo/dQ0Fdq7WAG1fBFWdEWYU6w9D7QZt0dBq6sD/3UVSyIzvoLKw+hGgxjYjbd30dtaLCMs8SxZKP8G5/dufs8XSEt4BcSy7WBt9AiBshLVGbztAM2RxqnoGwqo2StmHyI5w63nRMsVPwscPFrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711352522; c=relaxed/simple;
	bh=PaOjeQTXUXH777uBTd4u+MGPOvH/o5CMLR9zmwwiBA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cPQJBboMCpy5VTGQxNjk/qwMQmZBwjQte92MFDoCqlIU3U3u2DTJBDmOIQLUoDJ/6+mOrSC2k7dNh8fepi1tPr71bQBIV+9gfUpJJEWL6gPN5mK9FP4yBJeIOqBY+4Urpt3+vsWb1+sgZUhO1iVNCEiYyEE58ddrFb/Dl4TmxuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QD2XDsoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QD2XDsoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3A3C433C7;
	Mon, 25 Mar 2024 07:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711352521;
	bh=PaOjeQTXUXH777uBTd4u+MGPOvH/o5CMLR9zmwwiBA4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QD2XDsoQGpVuSTvv+e3Da8vgz8WLcdNZqyaoRkf0n0vdI9DUScnaVWCaBORHrx/ny
	 J1r+ZAxqGdOGPxgcKv3CJ+TLReWTqfVVzFJKi9BU7C58D3kyPfagimqpeosT0+Qamy
	 iI4ErhyjoKoDSSSsrii6bEyCpOP5VVqqECs77tOXJa1ojdVkmKuBWJSbLKRlPC9wwg
	 bjMM6i80BomW1y877IGdPr2qC2c7aHaCOaTUSdoc4f4DzgkkxuoE5rXUbOwLVJMb5V
	 FZvPvFSWqcd8Prx8z3kpg1fw7VvjSmplMVdvytHYyCn0+Eg/5FfWdJgqWMtinM0kF1
	 LoWCsry9WouRg==
Message-ID: <794533b4-19d7-4682-ad5f-9b19568420c3@kernel.org>
Date: Mon, 25 Mar 2024 16:41:55 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/23] sbp2: switch to using ->device_configure
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
 <20240324235448.2039074-14-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-14-hch@lst.de>
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

