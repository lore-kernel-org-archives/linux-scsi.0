Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350C13DDCA;
	Fri,  7 Jun 2024 21:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717795789; cv=none; b=tb9u4PPn4LVbT4R6FkeflrheLj7O98b993Lfd2Z5N8I1TAOJJYmdKt5xynsJz4aEEXSICASryHDcMtmSoGs2hCvuiwaA+bc1hPXYhzsPGfnbg31PqBVgl9IBmMJC1ay2Sn8gwctaJDw+BPRSUYgirLsO4gp5d/QyziAczaJvrLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717795789; c=relaxed/simple;
	bh=BD6C7RGIySDycV3VOFofM/oOyCmF2oRQdSxxLDvhJLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=usaPQ3jmc11un0FpnFfzpHxXCh+s1Q6de2aFvAtLEZihVjde0JjWEF+qKPSiwc3EaIna+UqsYaVbwyBU5ZngtF1vT2r7S7XshtURDF56fUWYff3yBxGB8yzQ/CvdC4ZRd5cpiQrIVCCgvtYOdf2Vjbt5nbgM9x6tx4SEqgB29ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UJQUsZ4E; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UJQUsZ4E"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VwvVF0StDzlgMVV;
	Fri,  7 Jun 2024 21:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717795779; x=1720387780; bh=dOqV0Zj1nEd5xA4S2ZVm1Cy6
	7s32aCVWuWcttCEhZhI=; b=UJQUsZ4ENM1uDK1vXAL7HVwnCK7xYicvRTMXS3++
	0NFQUzl9EUmbr1+6kGhCp54Btd7AgPknMTKsQOJ7nI8JfZ/yaRcIQYTI4F1KfhWD
	nl4/G1i4UCqwviEPG/wr0ImYQz62f4mCH0r8GNZ3yciseME7zG+u+CPhbbEkYLEv
	J1qakVm8wKsShqT8/jFJkuCxMkm8N+JOTERCYbSKT70555HwPbWIe8XXNMDBuHs/
	JZT9VqqNFMoGNtltAO2mA2oMv0Dl1J7peCjDqTbUJtj8GeaZ0vrsO2tJvvpAXEh/
	RLbBpKpZS15atZxtZgVCqWfcqjSoVFbOl4S2Hyb3FOA07g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LVCG6pZ04S09; Fri,  7 Jun 2024 21:29:39 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VwvV95vpVzlgMVS;
	Fri,  7 Jun 2024 21:29:37 +0000 (UTC)
Message-ID: <c93837d8-ae64-4e44-9f45-e6d82a74325c@acm.org>
Date: Fri, 7 Jun 2024 15:29:35 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Do not query the IO hints for a particular
 USB device
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Joao Machado <jocrismachado@gmail.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240607011651.1618706-1-bvanassche@acm.org>
 <DM6PR04MB6575388630C92A1AD4591C6CFCFB2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575388630C92A1AD4591C6CFCFB2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/24 00:29, Avri Altman wrote:
> The comment above __initdata say:
> "...
> * Do not add to this list, use the command line or proc interface to add
>   * to the scsi_dev_info_list. This table will eventually go away.
> ..."

Is that comment perhaps incorrect? That comment was added before 2005 (I do
not have access to the kernel history before 2005). Since 2005, 84 entries
have been added in the scsi_dev_info_list:

$ git log -p 1da177e4c3f4.. drivers/scsi/scsi_devinfo.c | grep '^+.*, BLIST_' | wc
84

Thanks,

Bart.
