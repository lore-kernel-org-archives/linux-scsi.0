Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7B613E6A4;
	Mon, 25 Mar 2024 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711351222; cv=none; b=unnvQDR5oo52QkkQWZXB0CgcP0qCvPvo2vqAnGvR/R31t0VUxs9WkcxpFOY7LOVG5znTSHQ/C6twcgDReXuEllO/uZ3savUNJ/+M5xc/NA6PeBVlr/svu9EUK9Rw4MVRJfWMbK8/pFo9xLUsJB4q7jtP1u8Iyhk9Smawetfmy3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711351222; c=relaxed/simple;
	bh=iKh5Cg64Ms9blQ0EGs0buI8MPJmgJshCkJoiOFuZjCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WP0DC1pIj9RphIZps8+JAnlRIeU9BxtuYQRLbs+ebayiFG/k9FXm/K6Knrf9KNAZCY/cU5Oh9PgxqKZKOjHSKvfbNTf5j6vNTAFoBOt+fBcKwGczxSqlbnGJ1Sy5nIeTgUityhb5oCCpSbx1O7LNd97mEf868kSUAcsdEW+0jGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5g4IRlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5g4IRlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E96C433F1;
	Mon, 25 Mar 2024 07:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711351222;
	bh=iKh5Cg64Ms9blQ0EGs0buI8MPJmgJshCkJoiOFuZjCw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R5g4IRlbC3SQUy3oJQhy12g0ig8AMW6UJl/f2arqHlczHRcHtU8gu2SJbj+5ZdowF
	 R+jGsPmodQRNt2yOG5jbDjnbwb87PbQJEhD/cKHk7fDfiJGYGSseTvTAGn7Cput2/q
	 PJGaRsdwPO2AOrWtER6gIi2A/1bIgNC0YQwbFkiTxhpZ6AA+253s7Ef972ItbX+oJl
	 Ri47A8l8xXTwaQy7UjWN/9cmZuKHOfaCr80usQWXJwKa9EvVLXxjZ0KA6aXXWKgKx5
	 Il+wi2wm3ZvgtFidAI3IF8LdofY/fOmXBbsIEwVSsibb45xMgRXdwnLq2ZLPw4vqK4
	 SgtIgD5jmnLyA==
Message-ID: <be1655f7-3ae0-4a5a-ac35-95e9c7d2da02@kernel.org>
Date: Mon, 25 Mar 2024 16:20:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
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
 <20240324235448.2039074-5-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Turn __scsi_init_queue into scsi_init_limits which initializes
> queue_limits structure that can be passed to blk_mq_alloc_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

