Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED79F32C8B
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 00:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721696268; cv=none; b=IHZruprjzIBx+AL0O8GC3iXpLORzsp+al/t1xfyyZxyZdU3uc08Oi0kuAWqCH99/J7k9YaE6gqaZLEWmmKpLwBE4Zcu2fdPgP1FaiLUPcIG7JRLv+PdDC8Zjaq8dU46MO9cSjoB1Wxi51XMw9C70zAVWwkfw2onElWO9NGBMD4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721696268; c=relaxed/simple;
	bh=3VEjd7LaJZoYp/S3giHhwb98IfC7EgJ37JUV99/SK+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qTBLrrPmsiZxZUVgsOOlpt99XL5a2FEN9V9lnqHggYV3Ae1rpNKO+Qu9IcMwASQ+jbMdmtd5ZjhksLA8YMNSlL5rEimODxCFS7i4Xpj/E8ABLwG4Cm714Qb1n76gcKgwv9GSkWq88wE81xDxsZG8vrEt2UzCKDX3r5/41d1sIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQ5PO5A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQ5PO5A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B9DC4AF0D;
	Tue, 23 Jul 2024 00:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721696267;
	bh=3VEjd7LaJZoYp/S3giHhwb98IfC7EgJ37JUV99/SK+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qQ5PO5A4XX62LdMe2Bux167cAdVMsj6er5CVOjyVo4KfzFCFgnK0vKlv7U60nLA2Y
	 o1uORzInHxlRDk2yLDHF3MYlaOSkYzZTYjaM8zaHhqbDAsxFeQyTJrZ7nRz03XqPXi
	 I/2mAMUdy+sBdF/v783xWaLbqeRp5LZ5KXMHG0X4DcH8+qzV8RYXxkPQrKpOjXo3xQ
	 rxk56N1lWPuinSeb0WF9yF4jXt64gnrn7u/sF+iwLYKxUFJkbA++IZF4Spbzk4FaLN
	 45nQq9YydzS+9It6knbky12mol756eVk8IUFFNC5RaT8V1Rv+J5DdzQyKLOgmaO1yG
	 iLr0eQWUV+Q+g==
Message-ID: <aaad1a19-c68b-4269-a69a-039af87df019@kernel.org>
Date: Tue, 23 Jul 2024 09:57:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] scsi: Check the SPC version in sd_read_cpr
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Yohan Joung <jyh429@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 Yohan Joung <yohan.joung@sk.com>
References: <20240720150039.843-1-yohan.joung@sk.com>
 <yq1v80xc57l.fsf@ca-mkp.ca.oracle.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <yq1v80xc57l.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/23/24 09:49, Martin K. Petersen wrote:
> 
> Yohan,
> 
>> Add SPC version verification to avoid unnecessary inquiry command
> 
> Are you experiencing an actual error condition as a result of this
> INQUIRY operation?
> 
> Devices often adopt new protocol features prior to the spec being
> finalized. Therefore we generally use INQUIRY to discover capabilities
> rather than relying on the reported spec compliance.
> 
>> +	/* Support for CPR was defined in SPC-5. */
>> +	if (sdev->scsi_level < SCSI_SPC_5)
>> +		return;
>> +
> 
> I'm OK with the change but I'll defer to Damien as to whether this is an
> acceptable heuristic.

If this is solving an issue with an ATA device managed by libata, we can handle
that in libata. Otherwise, if this is an ATA device connected to a SAS HBA or a
SAS drive, then the issue could be with the HBA.

I missed this patch so I am not aware of the actual issue this is trying to solve...

-- 
Damien Le Moal
Western Digital Research

