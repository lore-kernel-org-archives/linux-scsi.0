Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28FEEC2
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 02:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721700538; cv=none; b=mk8YktnxRjY7K2MMWQKxDAtrqsAgvmX0Pbb12UIsoaPTRwcBoWDXhiBy0+nBzlBfpAaaGyh3VJRMtbRW2JDQWUr8bBppKj+BqzlJ/8QB4sL+2whphb4xfj5jHzkEskJmSmLAOuGwGgie1T+UTdth4ucLt6TwuN3g5sp+rehJUdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721700538; c=relaxed/simple;
	bh=v+RzrPEOPibGHZuVYPTkp62QYS5GwJbx2umk8z20/gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KFIBStITd56EhgsLxXSf1tTDWlerWxlKCFSFUJb0WsTbJs+ZRrPOp2eNcMVHF1EIS1OycqN8mOjiJw5kCy5AEH6UDUA11DLJOcIOTL3AKUx+wflD9EfDjZXbbJIanz4IGdizIJuDezwaJrm855iL0FW7ASRlLB6xyf8+UzdJjGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpVyuXK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpVyuXK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F8FC116B1;
	Tue, 23 Jul 2024 02:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721700537;
	bh=v+RzrPEOPibGHZuVYPTkp62QYS5GwJbx2umk8z20/gk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XpVyuXK00JmguVa7K4PEEBBwgserz/qYrzHWz/UYTOAIKeyU0qnpXjfjMDlXNiXx0
	 YErxWjyYuP2DCue6q59rbc/mnI/Sl+86yBgVAy7JmAhFjjLspnlYHFFlzupGEB8rjE
	 fKB9Z7BHRc4NzCl00/waXHWIRLYQKt7Uq85BMMSOhKyBYY2vLrlLLTj5WW6JtQtz22
	 kGYimMbEvO5M3mhJKpx+vA3FqSjZuYsVBKPi6gp3cZCv2tN4HAyPqCIJ/iIanfdThg
	 8tGL7tZ4BQaMEDAnh1F/yCrKVYESKEAOY0Jh7s9uX/mWxszjbEZvaOr1mW9AP0/Zyc
	 KZ71ZaO/Dn+tA==
Message-ID: <fba33a47-807c-44ce-b433-82444bc1b115@kernel.org>
Date: Tue, 23 Jul 2024 11:08:55 +0900
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

By the way, that may not be adequate as ATA devices that implement CPR may
advertise an ACS version that does not translate to SPC-5, which is exactly the
point you said.

-- 
Damien Le Moal
Western Digital Research

