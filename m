Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA29E386;
	Thu, 28 Mar 2024 06:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711608858; cv=none; b=MH/e9Wd3RvfRe8DpsqkiWSw9cVpI2uVP6l4+cGPcHRr/x2UIczEsgbMahbA/JYuzOkP6NdgVSpH2ZbEBYQCC19NGPtqYNIkQ1FRuWk0nrMdQTe5hyvaDk7uQVsoDOcMakASTRCI+qlmme4nUdhnLnonQMSDxCyPHlv8X5+iXICE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711608858; c=relaxed/simple;
	bh=xvZg4ZS3GQW8DLAdIOJnu8XNRSmySRYLVwW4qbjaq30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nvb+IgDEpp9ZeyzWIhgN+1J6MzPJLX6vyKcefn00OX4o3z7S5hAKjHfTb/fMrU38m+cbvK5tADB8fnAGDWFn32NZCF6SbPCxRRsVohjzVFXLU5pB/xUMQzU0gKc/bD1oBG+Noc3d7yCiwJMeNcnvSNUeOMiSOpL2MHSNxBu1wxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nC7KVS/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nC7KVS/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98B7C433F1;
	Thu, 28 Mar 2024 06:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711608857;
	bh=xvZg4ZS3GQW8DLAdIOJnu8XNRSmySRYLVwW4qbjaq30=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nC7KVS/2XGbuejz+ysCGa6NCJu/m75fpumVAGLsBNtFznjDkmA5j6pYMFDPHd3T9r
	 cX+dLKY0Yjwb1Qf6HQnpgz61yq83/FDLnlwki+npUuJ1VvWNgOmC4EUCErM+UbDa0S
	 66m8nas66bytJKKqDyjSIaxHKnyJTYB/c6rz1cJIXyjILxRYNpmRzuJjCJnHDnKaEI
	 JPmpaQV01eZRXgUsQxzS3Ur5Jh5m97wuoTNWowYYFcFdPFBOfnw3fvyLLZPBzvfKpL
	 0V453cljW6VuJ/ILjQw5JgJHI0a6Jy62DQUZ+dQtDNhmkk6pvBTUZtMZDlSVdUxqn4
	 vR7aR8T+R5suQ==
Message-ID: <141e580e-e465-472f-88a3-c97f2a6ce615@kernel.org>
Date: Thu, 28 Mar 2024 15:54:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/30] block: Do not special-case plugging of zone
 write operations
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-31-dlemoal@kernel.org> <20240328045430.GN14113@lst.de>
 <6035bad8-b157-4705-8ec1-80cc003fa646@kernel.org>
 <20240328065138.GA17890@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240328065138.GA17890@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 15:51, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 03:43:02PM +0900, Damien Le Moal wrote:
>> That is indeed not great, but irrelevant for zone writes as the regular BIO plug
>> is after the zone write plugging. So the regular BIO plug can only see at most
>> one write request per zone. Even if that order changes, that will not result in
>> unaligned write errors like before. But the reordering may still be bad for
>> performance though, especially on HDD, so yes, we should definitely look into this.
> 
> Irrelevant is not how I would frame it.  Yes, it will not affect
> correctness.  But it will affect performance not just for the write
> itself, but also in the long run as it affects the on-disk extent
> layout.

Agreed.

-- 
Damien Le Moal
Western Digital Research

