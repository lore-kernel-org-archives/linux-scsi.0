Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085F713957E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 02:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759716400; cv=none; b=RnAQ90GrsXX+7GGMoyAU3PxyRJHWi4UgsOhqepDAAcuc9LybYZugfaZTnwtZT/g+Y4giWhEwe3uY4CWsWXSshx51tecbvPkrYTAItEzTS0k5pQeldb8j7tz5yZaibGjbwiEQcl7IcEGjJkUXCugpAnLZ0eZQ1SrguWUUFdjkZRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759716400; c=relaxed/simple;
	bh=7hhBbvUAAcJoiyBsUy2AI/C8h0ldRQ2/7bS7cELBxg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oc9NY1q1OC+kRYHp06O1lYqg9rmPxMbWXxCEojJXc9IbGShBefLzqpwltW0ZA9MmK47Czjx8rhGaK59o1s1Eet310GzOHXPm3vPeAgG+nr6IOQc8fy+timO1YGPtE3vacw4uATLOUXU9W0OLvwAmtNOKeP2TZOfja9Z+cu34RlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ky309Pyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ky309Pyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE8DC4CEF4;
	Mon,  6 Oct 2025 02:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759716399;
	bh=7hhBbvUAAcJoiyBsUy2AI/C8h0ldRQ2/7bS7cELBxg8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ky309PytZCn0jM3xvclsoz+Xsg+EVpRllmoy8Q5MpDnP/nO9BsxZjg89zxHXrSIAG
	 m1V+mzMpB5aySfUEIBzF1OwRmV20RVj741MtepW3Fa4SOM9NSAqPPl+mrL+ncYzyf7
	 NEthjWAGiz/cWbPdUOJiD8VLXcw/42wESGNIft24bam9TblhLz2qtKVOPSuWd0ZVGK
	 cDRqj6qNMvne6rNlwJWsS1k2jdOmGF4AZgHvLUZk+Xa2A9F8qwW8CBeqs5l6CHcvhW
	 s7G0OzAoFJa5eULOBgv0TTRPYPJiq2yMuJUojS3haMHbkYNSbBH8wQbgQ+feAJNdQC
	 HrqWbA9XNnCBg==
Message-ID: <5d8e0f98-5750-4036-898d-eba509b0b6a0@kernel.org>
Date: Mon, 6 Oct 2025 11:06:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/9] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-7-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-7-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
> and can extract invalid (e.g. zero) data when a malfunctioning device does
> not actually transfer any data, but returns a good status otherwise.
> Check for this and retry the command.  Log a message and return -EINVAL if
> we can't get the capacity information.
> 
> We encountered a device that did this once but returned good data afterwards.
> 
> See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for INQUIRY")
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
