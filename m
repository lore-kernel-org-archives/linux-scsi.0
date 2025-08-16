Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D0EC133
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 00:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755304954; cv=none; b=KqkF9xPyC4oaCC5qe/mdnhufmuFvuES8ps43vXCC+BELqhn8e0g73WgJVnl4AesqAX7Y+Xg7PLxlZO4Z50gOk99i0ObD9xsPGhNdK/9vlriWqAsncCVWyRGjS4JLFTwQiBwWTqTyAjW8/ohHk9YaUEFpQwR5eCvptTwheu2i5SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755304954; c=relaxed/simple;
	bh=gnfYzxcIQFPulF1J3vBdgC7u2fzQGkuNnNJXINCyvvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NzCJcGMbLT/+3xV8CLnG8/ti1V+8zTJiOEMQtTeFdrrJUXjpabCFY03iuub4Sgb9MA88v55HqmPGZRSGqb548URzoDP6jucChSCdlWLutWpsxBuogmCPSiI/BNDm6aW8I5NF1ZP9EjrK6bNf4byp+H2LcbnhARhlxmt/KYfoqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXUkOTeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXUkOTeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBEBC4CEEB;
	Sat, 16 Aug 2025 00:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755304954;
	bh=gnfYzxcIQFPulF1J3vBdgC7u2fzQGkuNnNJXINCyvvQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oXUkOTeMwO0Xk4bcUeFD+9rkggdh/YQRR6vKstUla/7Gwp7PWWrnumM0v5y7lG1es
	 QchMcesjCgbu8gIPXqEt1YhQ72QzMZP3UTlfvHOfppQd2bCI77nL510OjRG588vxZG
	 c8QIzhqWrQKifHrNVp9B99oCP28R40/OhinZf3ApNLaTTO3gekDs70AiUDOWMzvcPJ
	 R90P1BsBjVW2h9fqTmACZ9rFHRAWbkhBblhbXhYOjYQCQYPsfR0d9k+lg8QjJHkuby
	 UMpDb3s3ryKT76tVr0Lm3yeNPEfNmaveTqXQ94HR4uFYBqbA0G49CMMljXne8WRAF1
	 FJWmqiVshqdrw==
Message-ID: <1b764459-791c-410b-adb3-bbea8a43cd29@kernel.org>
Date: Sat, 16 Aug 2025 09:42:32 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/8] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-4-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250815211525.1524254-4-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 06:15, Ewan D. Milne wrote:
> This has read_capacity_16 have scsi-ml retry errors instead of driving
> them itself.
> 
> There are 2 behavior changes with this patch:
> 1. There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs since the block layer waits/retries for us. For possible
> memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
> retrying will probably not help.
> 2. For the specific UAs we checked for and retried, we would get
> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
> from the main loop's retries. Each UA now gets
> READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
> retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
> is already 10 and is not based on anything specific like a spec or
> device, so the extra 3 we got from the main loop was probably just an
> accident and is not going to help.
> 
> Original patch by Mike Christie <michael.christie@oracle.com> modified
> based upon review comments for an earlier version of this patch.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
