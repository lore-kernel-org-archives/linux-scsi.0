Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0698D12C803;
	Mon, 25 Mar 2024 07:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711352552; cv=none; b=Y+2/AhImVefBJ+pB6nKu3ya9ZdamuUaujI/JuACWE6yvmZpnL0CwcRX37Kjgk2hDKuncTtmmzx1jyB0JvuFOx+cscCRsC6NNVe4kPaqHlJJxUBng82Lmkg8n9FsJCnGuRTjh3g7uF8gWlZuWdDkl2I2R8fPzMywwJ3PzXmUdY0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711352552; c=relaxed/simple;
	bh=PaOjeQTXUXH777uBTd4u+MGPOvH/o5CMLR9zmwwiBA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pp3e1vbvesJKO/tg6DLvPZOtazew3atXDPWz9aC53utFbhaJdc92y7pDFF6LKkLkyEgivQPItScXJ92WfOfthzajHpUbFrkTXrXy9ocKCTqfeF48WnDYauJ8Cj+K8lEEFUoIMGj9Fx6u5V9Wi2qgqhcYHln31GK8tMsxpacRzRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdrhBYjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdrhBYjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E6DC433C7;
	Mon, 25 Mar 2024 07:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711352551;
	bh=PaOjeQTXUXH777uBTd4u+MGPOvH/o5CMLR9zmwwiBA4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fdrhBYjw4ZVoAUM+x22ymswLZNuB+SbbktMfqfO2jFo9PIK80AEkOIyExpihGVFWU
	 Odo3YBJ35G4cUg6YhtoN8ytWnhDUpPUsdDIVWr8T20kxA810Z/bM55neRmDF1sfDw+
	 YiTzYI3rZmD3wwgBQanYwOvtDlVFfkaHkWxgxQ7TSF3Hhe+yunwsn44IlDENTaUgTV
	 7V46nbOTHgr9oRkGSrJMSO3lZEC41ee5FCIy7NfU9cEAVzPD+Z52f7dPLvJJhjj2+f
	 282g3aaOZL4fYVw+3cSJK90pPDz01OT3WTZOIYXkzvUhnAy7j3jZP0N+roxy0kuLx7
	 a5/ZCCphW6ULw==
Message-ID: <4f9b30f2-2351-4d58-b368-46c65288aef9@kernel.org>
Date: Mon, 25 Mar 2024 16:42:24 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/23] hptiop: switch to using ->device_configure
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
 <20240324235448.2039074-15-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-15-hch@lst.de>
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

