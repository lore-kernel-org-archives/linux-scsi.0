Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24682D63FF
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759773307; cv=none; b=jg/pHX7J09117fzjboEsKUCSQKlWDTihUlcfL/X/Flqrc+stGnDJk41nX15wdycGmwfso9byr3LMRUFHfE9OYfiQeiI2BLxpAXOlNAMDvJK+4s1sNW5nBBjz/VbWsFZ08SMPXr9Wre9l5oMMhuyvlxclKFGhLGW1F9KB/LW38uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759773307; c=relaxed/simple;
	bh=CZCwboed76fnJKRYE18NOd2YUTxPoQ+YCmow6gYAbfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qpeMs+rf7WY3epOwB8Rc1yX/vCKqjzl9KAWr/+5Kzy8e9N2/nfS0LMn/7B8yFhxEDGKKQObnZ1xIqJNPrSM8C1TCNuGF9Pnr97lDn0bJtFhz7A0WBzU+A5Ea10Z/nssEksvO0CqUoyF/I1dpVtjXkkjGhYR/oMdYrAtuVmi2lAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2y8WbyqL; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2y8WbyqL"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cgRkC1jZLzlgqVp;
	Mon,  6 Oct 2025 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759773297; x=1762365298; bh=YzONJwU+rBqt7goyFkIsg4ge
	fYjnPUqpNMBbxM9Lo5E=; b=2y8WbyqL+1V4tDHsWG+0cCryokrrwPgiicqAXys6
	epg4JUgIQjgG/+GTSPPaV5tKfuY9DD+BvzhgT+TecXLAMELG4abLbu+m+b50OO2j
	+sk00pbGPJHgsNgvFojbMXZ2SL4dLgxsoBcIxrLnYvoR7EM3Ak5xN3N03Zc7obX/
	3VtBZ7VgJKHStIIrVAoWidvEmiP7OoQN/BBqjY2k+TytBchJ0QZgv8yIiVBN9qoi
	TL42ISTRFDKRnmRl3Ho0eQvGUuDa8mPF+tX2/j+veI/LnVsnrcDxcd82ex98ynMk
	B9qBgGBBQRGjWjwozcx36mRiPGitWyXpAOE1zkqOmLJq+g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E9eN2VH3uEWU; Mon,  6 Oct 2025 17:54:57 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cgRk61TYrzlgqV0;
	Mon,  6 Oct 2025 17:54:52 +0000 (UTC)
Message-ID: <3afd179d-e04d-4265-bfe8-652ac33ad58e@acm.org>
Date: Mon, 6 Oct 2025 10:54:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] scsi: sd: Do not retry ASC 0x3a in
 read_capacity_10() with any ASCQ
To: Ewan Milne <emilne@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, dgilbert@interlog.com, hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-3-emilne@redhat.com>
 <8f250e77-5069-416d-9389-9c3e99535dbc@kernel.org>
 <CAGtn9rkZX-C7DgaMCABsF66RVGomQeK1RyRW5knLPsPEzvajOA@mail.gmail.com>
 <4a5394d5-6608-4a81-8f8d-006ea2bdcd61@acm.org>
 <CAGtn9rkS9v=Y2x2Pt6ex-kM4iShGNe-jJHRk1zFOTHWKonwoFQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAGtn9rkS9v=Y2x2Pt6ex-kM4iShGNe-jJHRk1zFOTHWKonwoFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/25 11:40 AM, Ewan Milne wrote:
> Martin, please add:
> 
> Fixes: 0f11328f2f466 ("scsi: sd: Have midlayer retry read_capacity_10() errors")

Ewan, please rebase, retest and repost this patch series with the above
tag added after the merge window has closed. Kernel v6.17 was released
eight days ago. Hence, the merge window is still open. See also
https://lore.kernel.org/lkml/CAHk-=wiX38oG6=xFBNLO0pnjqHfxzjd6-1kZ5Nv9HfqNC2PoFA@mail.gmail.com/

Thanks,

Bart.
