Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F87C248898
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 21:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763759739; cv=none; b=tMpADx48teZRoc6g4XpvukqQB7ncp5+Cm/aL8nznEfoHBQGkuFyZSBtwnhrk++lgGhm3odgCcLh4Q8EfRLWbRCd4u30Z+1d1DIl7QqtQfYpFhpCxjDLTvJMjb6XilEwuyf3zJtcB7k5um9ghl2viAfggx6fVhE979pt0xWLcg7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763759739; c=relaxed/simple;
	bh=2MNy0VmNJfSti00EJ50FvK6jl0458uWjIYAYCpGadK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iB0zdjJJHaEamiiGSOMcHxXmJI7JA0c3wezkkyZr6y3K11EJRxHrHHd0agxNf0HS++qCoiKfYJdJo2VJCnmaQ2TsVUluT3JdBlFzPAE/V1l2UQeMTmoYAh/zUWN7kxdcE9zhISDtXLJxpWl/YMqivp6BhaAeZCuOL0qNTBwtO7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zLoITvD3; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zLoITvD3"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dCp0T1ph5zltJ27;
	Fri, 21 Nov 2025 21:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763759735; x=1766351736; bh=jSxN3/RY7hTOI4Vt/gqQLkLg
	xJz6oxwP0bb0E20K1QU=; b=zLoITvD3EZfiJ6zghfku7wc+RlvsDPrqVmI+kAZf
	Hbvj03TVbTWOUMsnvzTpmhyw83bbZ/TY5dUhcN+Kdb83tuqro3yCrfi552SOvylo
	1/bnkd9GsShSoL4armKKxzcsd/+SRJP86G3azj2Ppx54eKDZdO/RSVCE8oj8DXmG
	5tElC3e1AU1PQWeG69VR0TjT30LAVFl1vWvgLfIBuvj/WfeFb5ujNgkwtkNjdZR8
	UqmgcDvrju7vITBudW8Fwuaiz/EF99e4o1yAow3JXfpCgFIUNewBosXcKs/88+PY
	ZJ7PQeVvkZUs7+UK9W3bCugNJYrW1Kupdte+VzdVY53XXA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Gs-_6q4Eo8rp; Fri, 21 Nov 2025 21:15:35 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dCp0K2zPkzlv76N;
	Fri, 21 Nov 2025 21:15:28 +0000 (UTC)
Message-ID: <47d33069-90a0-4da7-beb2-349a164c5d3e@acm.org>
Date: Fri, 21 Nov 2025 13:15:27 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bvanassche:block-scsi-iops] [scsi] fb5a7f1b2b:
 INFO:task_blocked_for_more_than#seconds
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 linux-scsi@vger.kernel.org
References: <202511201331.ab9300d2-lkp@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <202511201331.ab9300d2-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/25 9:59 PM, kernel test robot wrote:
> kernel test robot noticed "INFO:task_blocked_for_more_than#seconds" on:
> 
> commit: fb5a7f1b2bb3442ab270404463be4f0d7578295f ("scsi: core: Improve IOPS in case of host-wide tags")
> https://github.com/bvanassche/linux block-scsi-iops
> 
> in testcase: boot

The root cause of this hang has been identified and a fix has been
pushed out to https://github.com/bvanassche/linux block-scsi-iops.
Let's see whether the kernel test robot is happy with the new
implementation :-)

Bart.
