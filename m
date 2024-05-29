Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D8116F0D5;
	Wed, 29 May 2024 08:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716971008; cv=none; b=PnOX03HfLdTg+sG5TBaO3SUtjR8mFDpIuszMEfiTaY5ZpVkNCtDOpnjDXHxxbXkBfZEacRy/e4/3Y9rGcHqyHwlSU3CDcqRboaYRXuFYIl0LZQahK9EiKYsSWUxWkiL/ZefKWJDzSl/D6eaZN5pm9hHYmOL2LW/coTlG9aB5yqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716971008; c=relaxed/simple;
	bh=UnLzeIpjO2H8DXobwx0iVT/QPf6bQElmv5UNVtEUT0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DrskT0SVbS0xGSMsyPaDOZ00ch58MzdYtfgt3OZ7DL0xXJ3uyD6xJKdKngvTDrQNbmoQCteI3iAzOrXcu1cGc46FnArgmPzrc70ykxkRSp32j36m+bZRLuuo4eCLpR9XizVNb45fC3c71hVktk7vgafafyjZcqjMiNExEuYYxDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6oJdroe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6oJdroe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C398C2BD10;
	Wed, 29 May 2024 08:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716971008;
	bh=UnLzeIpjO2H8DXobwx0iVT/QPf6bQElmv5UNVtEUT0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O6oJdroelTELWIStQcjdZBa8C9t0BA8C42VKn5vNrwvO9ZdR3rUrwH3ZLwjFFK0Oe
	 HhiPBOH2XVUERxnnGQ6s891sk9q1DG/PnFL0LkBDnOMmP+BS9Xidu7ZeyiJobkI7Mc
	 aurytkNHgMhSMIO6KEtPbr+B/Lm3Ypkam7hGJBLyD18GZpSe9Cj5EF1Kb2puX7kRs5
	 KKnc0fqXHQGePuNkSVkdaId1TdYlGbhhiavhXQgTW+r4g12/5y6OeB3rzT9MZESuNJ
	 vPo1fpxXY6E38PJ/CvZgo2QxoMoClT9dhzC5WZl2dJPLzL0U0DaPQ4DmDMx98s5JET
	 LA3uCxbs7kWag==
Message-ID: <5e23755e-2473-46e3-98c4-1a1e3fb8bfdb@kernel.org>
Date: Wed, 29 May 2024 17:23:25 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] sd: convert to the atomic queue limits API
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-10-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Assign all queue limits through a local queue_limits variable and
> queue_limits_commit_update so that we can't race updating them from
> multiple places, and free the queue when updating them so that

s/free/freeze

> in-progress I/O submissions don't see half-updated limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With the above fixed, looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

