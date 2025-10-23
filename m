Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B70E3128A1
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761237130; cv=none; b=bbcyTNhCdCkU1Ix3+CqZYQ2HdQsFYXXQsdFyX54pwinDWCU5Rfg9H0aQaRfj3TiTQclwC1okBoEdsFcP4OIvG94w1lp/l+y+bDaOPdcZ5y3bY/BIpvB0jVw5X2kmdquM6NnBsMKwisL3inbs35r9GeE0Z7nZKf+B0Cb7to1btDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761237130; c=relaxed/simple;
	bh=svPoPjIXG6Hm0BhQYxXqL4/PJ+2uQ894/Jo28S8A250=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RfuMQSvyriMDFuaXQ/IFXWVMtVf7h9IzTAIaTfkXcICUnB4eKumKxLSfup0KVJMbV4EHJmlFkDHsV8shICSOKJtVtQoWAf7QKUVtawHzoQg0ELyJphW73IIE9XQImJuS5++7iv9luUzoul3mzRmPFkk41UWTM7RThm5O+PO9geI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QQ+Xhp7H; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QQ+Xhp7H"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4css4m0xvnzlsxCT;
	Thu, 23 Oct 2025 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761237126; x=1763829127; bh=TCOsu4KmM0GKedbpoe9iLWc4
	a4kdeC/SH1fAM+UbD5I=; b=QQ+Xhp7Hm+versZxaltPQGjMjZ8jeMRUjyqq+xv4
	SlPX9cbtzjtNunQP3LSx6ihQPZxjmi6sxZyNcEsZaNqcsA3KCdzPC/PGBk1lXNIX
	GdJqtrIHeXtpf2/rJGoJYQxYl4UWg1VbGSoh0YdV0hGoDd+kkB+7u3z4HIO7Puk7
	B+r5ecWKtNkzjLgVmFW/wENkvZRmccEwqb8oFYcYUO4yt3K0PUAQkhDHstMyYYEm
	nEkoz1NmOpHQ/YQZ7FUYZZxMVFj8KgvhyhNdr4GXEtsJ9BrVD/WPsEMVYNPTOr7A
	XbHuvxyg0QnJHZ2y5TXfTALQ+qamqWE6uaypw16igeFElA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zBDSYBxLJ_ez; Thu, 23 Oct 2025 16:32:06 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4css4d5VXGzlsxFZ;
	Thu, 23 Oct 2025 16:32:01 +0000 (UTC)
Message-ID: <024aea4e-ad9e-4781-94d7-b9f8379b1673@acm.org>
Date: Thu, 23 Oct 2025 09:32:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
 <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
 <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
 <2427124a-24ae-4a49-a26b-5d1fd7fa3948@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2427124a-24ae-4a49-a26b-5d1fd7fa3948@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/25 1:31 AM, John Garry wrote:
> Good, so do you know which other drivers need to be fixed? I saw the 
> advansys driver mentioned. I can look at sending a fix for that.

The advansys driver is the only driver of which I could determine
quickly that it needs to be fixed. There may be other drivers that
need to be fixed but I'm not sure of this.

Bart.
