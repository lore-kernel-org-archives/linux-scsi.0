Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB8B13C8E1
	for <linux-scsi@vger.kernel.org>; Thu,  1 Aug 2024 18:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722535239; cv=none; b=EwFjkp8Cz6KlN4QqpT92NdMLgthlPwAHzs3o7qN06CTKz1N67W6blgnzjQfgUnsy9SesxkJK/l8ap5JrlYPxeYKbLBVCtZcbbAMtuDCKGkDipwInFhONTRj0B8mQf4xIcQ3n6+v4rw7WU9A4sIeb007k5IQQK3AcZ6GQarFHXPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722535239; c=relaxed/simple;
	bh=uTj32CvJ+Y0avd3Z7RStpdoxJAuCXarjDkDqVozncZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZjVDAmb0obApDgykqc4eAowLqdcRLaSmnbmCzO3GVO5AHE/B0DoJESLsSDcND38DAMxOAFwTZX9/iKTytFTjwneIBwOG3tz3Pa0ZnKxoDYLKULO8mY/jdAFcltw9bx6nYz0jZDniiz5bXCGzZp9b/fIFTNL4qWkJnu3VZtTr8vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LxcYaJ3A; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LxcYaJ3A"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WZcFc6G9Hz6ClY9F;
	Thu,  1 Aug 2024 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722535234; x=1725127235; bh=uTj32CvJ+Y0avd3Z7RStpdox
	JAuCXarjDkDqVozncZY=; b=LxcYaJ3AxGAV4cJCrOr8RMzV29MV+Z+5439GLGUS
	+mWoBNoPW7SniIvxGHuyEFbRHYZjCazhWoaPWMQHqS5gG09X6fskHyJ/qT8CsgU9
	cowS5xhig1+FW+S142UghObY0KM+Sv9JMoiHmUP5amMZVIxNummQwwWR0XIyb8Rg
	mlutuSQ5Fg0bYMuo+NEAfpyS81N0sriPhJvfdUzFMBbOkz5BsJainVgkMc7usYuo
	CDhzlWw93++wE13jkYcbov+h/hfRfB36xqNEr924KgDfL433v8zyQaDp1lQW8WPD
	vCbZzCrZIM8YwfungKCwiUkgJUITOm30HuBWkjKW8714pw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id utgs7AOLoFK8; Thu,  1 Aug 2024 18:00:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WZcFX2VNQz6ClY9C;
	Thu,  1 Aug 2024 18:00:31 +0000 (UTC)
Message-ID: <3c638f00-63aa-45c1-b07e-34252956960c@acm.org>
Date: Thu, 1 Aug 2024 11:00:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: Retrying SCSI pass-through commands
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
 <5090f92c-096d-4cbf-95f4-af25b50243bc@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5090f92c-096d-4cbf-95f4-af25b50243bc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/24 12:04 AM, Damien Le Moal wrote:
> Another thing: may be check scsi_check_passthrough(). See the call to that in
> scsi_execute_cmd() and how it is used to drive retry of the command. Tweaking
> that may be what you need for your UFS device problem ?

My understanding is that making scsi_check_passthrough() retry commands would
require modifying all scsi_execute_cmd() callers. If the scsi_exec_args.
failures pointer is NULL, the scsi_check_passthrough() function does not
trigger a retry. If scsi_noretry_cmd() is modified, none of the
scsi_execute_cmd() callers have to be modified.

Thanks,

Bart.

