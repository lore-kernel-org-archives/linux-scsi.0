Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C71B45D925
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580802; cv=none; b=KVK34hX7L3xo4lWHTb1GSx/VcQ/7bnXHOFPtqS/FNxLgxy/Q1NLM5ggpiEhzNv0fSCIR/uSiWoOag5hM9d7PU0J14NDOakOFTiFBCWsR2xq8D94ywTkQYpw6QLjpn3iikBkk1SonQTehXsnNvxyqdhDb8oVMI7oIk1lZUvH+iaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580802; c=relaxed/simple;
	bh=ZZUxAbY3WA+8LOEIeXXnwr7nNklSU1Wys8TWacffCWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kr7NLh6UA6CipdO5zavwXOQDWKJ9Vn+eSuNaM6HNMfegjWQPwAze/mDo2o7PU++OlvrzVXN6DDGIcfxYFOL2xV0fGoULiq2UBfJmlsCEyTkYrmop+Ls/FmNTU6fE/6KYNjzCEDTRtaaqxnoDo38SACh0ofO3yufStKTNiA9d8/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oOL489eq; arc=none smtp.client-ip=91.218.175.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oOL489eq"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZZUxAbY3WA+8LOEIeXXnwr7nNklSU1Wys8TWacffCWA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790580794; v=1; x=1791185594;
 b=oOL489eqygU2z+wtt3HTPyNuGpeYGCvxksl9O0sV+wihc4BHLvGgevtH7qiayMxnMPnpGUV3
 SnzpSP/zmtL87hMIZGM6cRDzFetEPfhLVmDftPm4bnfA6fybj/gMc/BZHG8wEPJeuKu1+ZdZ38o
 5/f3vBkYO6F5mA/ZIaccS4Ek=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id e5a1b785caa96e46;
	Mon, 28 Sep 2026 07:33:04 +0000
X-Mizu-Trace-ID: e5a1b785caa96e46
X-Migadu-Flow: FLOW_OUT
Message-ID: <d20de353-1967-4077-bbc1-66c89679ef2c@linux.dev>
Date: Mon, 28 Sep 2026 08:33:02 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix scsi_done() documentation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>, Jonathan Corbet <corbet@lwn.net>
References: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 19:08, Bart Van Assche wrote:
> Commit 11b68e36b167 ("scsi: core: Call scsi_done directly") changed
> scsi_done from a function pointer member into a regular function.
> 
> Replace all references to the scsi_done function pointer member
> with references to the scsi_done() function.
> 
> Cc: John Garry<john.garry@linux.dev>
> Cc: Hannes Reinecke<hare@kernel.org>
> Cc: Damien Le Moal<dlemoal@kernel.org>
> Cc: Jonathan Corbet<corbet@lwn.net>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>


Looks ok. I guess that there is other misinformation in this doc, but I 
didn't check.

Reviewed-by: John Garry <john.garry@linux.dev>
