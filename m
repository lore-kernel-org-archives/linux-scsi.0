Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82548322E
	for <linux-scsi@vger.kernel.org>; Mon,  4 Aug 2025 00:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754265949; cv=none; b=YBK64gbId8gPisG2UpvLehNx5BzrSBq0k2RdR54T+0AJlh3bSvkTclRaRV3N85d2vgkWXy7Fs/FvkyBUc6hroFJFgCYqnJyS7CUJhIeuoZqMCCif2TsGo3hEFI2rZIdtixAWwbSdsfOSchyCXNzP5m1i0YbJ3LEjUaIiOmlmNWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754265949; c=relaxed/simple;
	bh=o8s/BaWTitSdrtymPBSb6fQ3vlCnXQ9YXfiEMhxqllQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cUgdqJyYUj7Vr9bUyYlwJs3bI4+k+KAGcK3+c19y9v7kOqcBmrzs4AfYdJVD1q+lu8pTI1ph3SFOfJvibMYzpRZSsB8HiAoxTV//I7hRsVmwbkEaw4d0yDTpRtAYOCesZrX/gDRiD++M21w9zeNrlCtazBt1+yook2sknJvw3Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAt+8ifx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAt+8ifx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173C7C4CEFA;
	Mon,  4 Aug 2025 00:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754265949;
	bh=o8s/BaWTitSdrtymPBSb6fQ3vlCnXQ9YXfiEMhxqllQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EAt+8ifx+bxTSkK7uCSbU0ONWNEO1m7DStLp+llgwnrLq55ZXcRINrTX9LWJ8/Rz2
	 DAoB22A1NW1Jt9ROhnnLHNQNx6B+6I0upcHriJW43TmftR//iPbuuWVRqUqnYM0K1E
	 4en9vuKcDzdYOVg4AhSd25bA3dcTWfN3Px37ebpNX2VMGDcqVu4+XT5Bhgg9A9KdZd
	 4wqdv/7catVwpkQ9riYnWke4g6k1G/sjHwWjdUViJUKv7rodz7pvSQkOmSS7jplKeP
	 TGrPCLlA/DmReVVdSpqPpJk2twqUSegGEVyy4RID1QBMOjZDhbye02E1v7/F1lg0wE
	 7y5+E0u9YIh0Q==
Message-ID: <860d3c16-64cb-409e-8c4c-67335a85db0c@kernel.org>
Date: Mon, 4 Aug 2025 09:03:15 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
To: Igor Pylypiv <ipylypiv@google.com>
Cc: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Terrence Adams <tadamsjr@google.com>, linux-scsi@vger.kernel.org
References: <20250717165606.3099208-2-cassel@kernel.org>
 <aHlpNRsPbmrTgv0O@google.com>
 <a09dea31-0de3-4859-95d9-2d83fc1ccc73@kernel.org>
 <aHrLBPunX8Fuv1zz@google.com>
 <70d2f593-3121-4684-8632-6a4ea1dc72ea@kernel.org>
 <5056b88b-0f42-4a02-906f-197492d76827@kernel.org>
 <aIAEdNN88utN4sQJ@google.com>
 <72881ac7-f276-49d6-8918-a81d41502d11@kernel.org>
 <aI5ZeAweRWKQmLPU@google.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aI5ZeAweRWKQmLPU@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/3/25 3:31 AM, Igor Pylypiv wrote:
> Hi Damien,
> 
> Do you happen to have any updates regarding this crash?

No updates yet. Been busy with other things (merge window, regressions...)
Will try to get this fixed ASAP.

-- 
Damien Le Moal
Western Digital Research
