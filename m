Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFF91CEADB
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 21:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744925165; cv=none; b=rE8zBVjChIBztMn2oYIgWeYY+TXhYLrL2axjT511JJholaDiK+RyJv2uEurh27yikpi2Hi5WfYMnEdCW+mHyqOSXjC+ci4RSz0udE3QKgs6yV5QtTk3rIphptzWWIQ0yiQtgOuA7cYwG7nwcwOx27oQ4UaJi+PIHRe+r8v0Sots=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744925165; c=relaxed/simple;
	bh=coXTKkcEvOHp6UILIw+eppzpDfkhgSitfvHn4R/p7Q0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NBl08wsDrTuqft8rKv0BwMvR1X2Z27Q9whgOQVvZwBDUKVnJ9gdb+wfuEURojXuy7yV6na5VZXGafdWq0mNhAyFj4cq3ii6VuQJkiKYpyancm/S8T6ZMy7uoa9vQtOVtG1ONw9SP6z4dteJqga9slmL2/UmR9nPHVbaJ1wyqrJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lwLsYVon; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lwLsYVon"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZdrY15HxNzm0yt6;
	Thu, 17 Apr 2025 21:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744925156; x=1747517157; bh=fQtchBF+n3xn+xwm1l/Jqepl
	zoUv2u/cyq2CZv559No=; b=lwLsYVonLml7jNbDfpzYBUaieSXEO/TcKPwploFI
	nPCUsnYvJX7Iq7PyGkOD2NP13kyJ3EQLS7PuNxlnbslJqi89FuYBUONtdgFire/X
	Hc/JlFb/6WrD8gPEbA7ICj290VAfp14Onsw9wtURxJTDw/2tdvzwKTgIBnJoP9mv
	dH8JaxiI5jPQO3N+VpgEHhCXiLFjRviz+zp0Krg1hVxC6Jb9KRskTJdXoXj66Xf7
	lNfx/aO3g2ukGbCFLyAe2efEyynDKYfHF18ChxDgaFvnVn3b4d6jjK6xwj5X6XTI
	/QZN6xefZs0/KIBQu3kiHPaaiSLvnloZrL9ueupPkxw8EA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3gFSecqmYJh0; Thu, 17 Apr 2025 21:25:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZdrXx4BfJzm0yTh;
	Thu, 17 Apr 2025 21:25:52 +0000 (UTC)
Message-ID: <959ed10a-27e4-4c63-b9bd-58fefc5c4775@acm.org>
Date: Thu, 17 Apr 2025 14:25:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
 <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
 <d6b35769-e5f7-4174-b581-f6555aec1d4e@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d6b35769-e5f7-4174-b581-f6555aec1d4e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 12:16 AM, John Garry wrote:
> I'm not sure how that will look, but my preference is to fully implement 
> reserved tags support which can be used by all SCSI LLDs.

Hi John,

I'm working on an implementation of this approach but it will take until
next month until I will have the time to post a patch series that
implements this approach.

Bart.
