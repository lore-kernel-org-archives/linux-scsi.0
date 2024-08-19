Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BDF4965C
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 17:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724087330; cv=none; b=LHAxKyrglKUHpwYUcR60etrN0ULLNHnkVYUlTt/hxpkM+CIoj5P/TWCkRIHbC3Q8DJ1ornVUqQkHU9yFN95bGBmRGgrHck2iRIIAs7Ifxm7S46jB8z9PV55/0i+91M+iYgdqmQhfu2NBjBEoqOhTHrBZk/46xR5FhJ1qBcXrL2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724087330; c=relaxed/simple;
	bh=0onCOUMScemJeHnAoY2Vy0iIiis5jwaKP9kdlYmYHo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c9ITDkG5rexnTBkbWGFCT4FOEU/dI+jUvlL29mYbIGmcJAapuKz9WxD4SB8HUwsUw2J0NGdJjJ2suAz8Pg/S1Usua8S+qvsIReYfXOkh4pPgqbQGPyM4ugDsZjd62pQoe/Yi4z6jALAmx8Zc+LUEeW5Wul7p5YxykQD+1kVOYUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dHVOJIc4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dHVOJIc4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WnfFQ5XzKz6ClY8x;
	Mon, 19 Aug 2024 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724087320; x=1726679321; bh=3nX76XWWvf8qKh5I6q7vTXLV
	xE8btNKbRdnMvpS/1C4=; b=dHVOJIc4mlJhBHOpmBUgHfw7zlZX7NeM2kuMCnDi
	iYfzxQMV+9D+am8ge/oFtRbDrNpQU9gZIdmMIniY9QGwuKz2nmuvTrUZyioQFAMi
	YiJC4o+qK0nuAz15lyAIEzUTsuefFp6WAgYxhSa9ZiQikxEiAIehCblrM7DrzyYP
	KC5RgBZz7kAgH+NgBHPqx3y69zAmh/dUqCialKYgJpU98w74qHjSXVh/BH1JFQO1
	5T5RydnEXK5TH9zfra+UTNL2p7jhE/uQQLlNxwtWNFplhqlZkaEdgdNjPEZuDqsA
	XQhqA3Qx394tutN18bcuazGThVFJrqVu0D23KFde28vh5w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8-mcrIfnHj_u; Mon, 19 Aug 2024 17:08:40 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WnfFL4zjTz6ClY8s;
	Mon, 19 Aug 2024 17:08:38 +0000 (UTC)
Message-ID: <01880e15-56d6-432b-8441-974ef56935fe@acm.org>
Date: Mon, 19 Aug 2024 10:08:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/18] scsi: mptfusion: Simplify the alloc*_workqueue()
 invocations
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
References: <20240816215605.36240-1-bvanassche@acm.org>
 <20240816215605.36240-3-bvanassche@acm.org>
 <c1d0468d-eaf0-46c2-ba62-846ffdae6993@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c1d0468d-eaf0-46c2-ba62-846ffdae6993@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/24 4:51 PM, Damien Le Moal wrote:
> On 8/17/24 06:55, Bart Van Assche wrote:
>> Let alloc*_workqueue() format the workqueue names instead of calling
>> snprintf() explicitly.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> In patch 1, you have all the changes for removing the use of
> create_singlethread_workqueue() in a single patch, touching different drivers.
> But the series has 17 more patches to further cleanup the workqueue API use in
> various drivers. So why not have the changes in patch 1 split into these
> different driver patches with a title like "Cleanup and simplify workqueue API
> use" ? That would make reviewing easier I think and avoid having the patch 2-17
> changing again code that was changed in patch 1...

Hi Damien,

Thanks for having taken a look at this patch series. Would splitting
patch 01/18 really help? Splitting that patch would make the description
of the split patches longer than the actual code changes. That might
annoy other reviewers. Additionally, isn't typical that Coccinelle
patches are applied tree-wide instead of one driver at a time? A few
examples:
* 795f90c6f13c ("sysctl: treewide: constify argument
                  ctl_table_root::permissions(table)").
* e8058a49e67f ("netlink: introduce type-checking attribute iteration").

Thanks,

Bart.

