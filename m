Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2553142AA5
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 00:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755305981; cv=none; b=HxT1qvri0Lht1spgYY2i/gk+pApBuJ48VwXU0vIy3kmWwbGoYIZ6LhKuRxaQqZYq8gwz4MWpFnGrW6G6UrajER9kX2HqOg1efzeliOw219PjqK2JrcQFAknNySEG8pBw8c6VEo3V3OO+iZwSv2FQw/8uJ68l1solpUrukcYWYkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755305981; c=relaxed/simple;
	bh=qk8t1kyH6fz1dLfyDV4SGYYLojkNv94+BzvFaML0HN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bsPHawzK5rJ39ZME+tHbcARBMoYXHMssIQ6aAIpzkLuK/Mreit70ufVtnkDnL3vNrcVmNI8Q6KIVrwr+nN53l/8EEFg/XAiH5nN43xzPdYJWWTFwza3e16/l2SrWUUpopOJ68jAARoTAnxCpYpjVzSz4dAm87evgefc/uIr5AaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bn6/hlX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bn6/hlX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CC3C4CEEB;
	Sat, 16 Aug 2025 00:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755305980;
	bh=qk8t1kyH6fz1dLfyDV4SGYYLojkNv94+BzvFaML0HN0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bn6/hlX+as8y9czsjVaqqGKqsvn7Cm3b56EpDQ6vSZRYY7qe7yDz5Q2BYzzcOC9bP
	 h7SpXLj4LlsWAYosSVHhouqGv8798LexHse7OSD7NAg3hcAtjcx6I13DHHdF9a/4Oi
	 I4UOvmIM/Dcq7kitnqa5GeSGyj1OxJyfqpCbvY3JDbgIUIQegmkkCwuOxWWIta4V20
	 9qeXJyi20vZuf9pCnklQIPfXm5PdxqZydzRpXgm4/h/WMFUJLgUZ3Irh3kgzpBoU7d
	 f1qXp/6bK7B7X0onucRIak9RMOcj2E344IOQXIUk0/KBRUkBAp5rXoN+xjINED+pRt
	 MWQeCimKWYbjA==
Message-ID: <cdd74665-9ab0-47d1-bc6b-f9ea731fefc9@kernel.org>
Date: Sat, 16 Aug 2025 09:59:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/8] scsi: scsi_debug: Add option to suppress returned
 data but return good status
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-9-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250815211525.1524254-9-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 06:15, Ewan D. Milne wrote:
> This is used to test the earlier read_capacity_10()/16() retry patch.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Looks OK, but it would be nice to be able to suppress the data only for the
first X commands, so that the retires can be exercised with a success in them
instead of all of them failing to give data.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
