Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3124218755F
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 16:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717087117; cv=none; b=DQEoBvrea6n2WV9BKqKc99FU0sVXTwPB+SRN3rGTCmA+Fbo0CPJ4xWuM+QxbbA8w7IMvE2w7MANOfR99efIs9JuSSrjI83OkLttN2OYSW+0wDZMonOfZMlPlO7NugccltUkJYzfj6sqBumtmVfdB0uSi45z0J78lyvOJqGQMwOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717087117; c=relaxed/simple;
	bh=6UtMqZpRNWrL3nIFw/8T90/lJaugYzl4/vUkUamCx6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sXrGM2pwSTV4k5VTeUbmNY7K2DQg6ZrPpImO/HjSDQ4VHNSYlAkA8H/sWKv3+kiDGjBxbAMI4Tb03bth6zu4RIULNJpitNvJt6E0KRBdQZyc/TWEXGf/mTyp7g0uioyQ4hh5q5ij/JMHrtSPqmjxUuazS5JC7rddcf3C5loH0QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=T+th69ew; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="T+th69ew"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqsQ33frXz6Cnk9B;
	Thu, 30 May 2024 16:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717087113; x=1719679114; bh=L4KgsKEoMkfQae9uN7DEOpgQ
	XdnbFIWdit3iB443Eos=; b=T+th69ew5077bgJyeu3AbDPtvaUi2ZCyZhbEDTVq
	JafqdrBY3w4Sp6hhHv548y7BsNVSb3RhjEFpK7jk6/qpc9E6kNaa2kJXjXIYTq27
	61MV0tcf6cjY1VmQ/zE4Crc9EmofMjg6+Ofc9F2hGd+ErlopKi/VZ+7hJrM5IAko
	+FI0Fe/XDZux4/yMJKwf6jmC+pODZEVvvx4Tavs7gleABbiCRoE/wKGMckB0v29J
	OWr7zu3lNml/bcS7vWAVu9WjBxiBMrjgzdPOGKsX11ChhSif/EajtCkRKiNZK/Wv
	pySDhnmm8FZcUNZpl/d5S2yjnhViMddR1FKYSndwElVn4A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mtbJFbr7QAxl; Thu, 30 May 2024 16:38:33 +0000 (UTC)
Received: from [100.125.73.196] (unknown [104.132.0.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqsQ13Lxqz6Cnk97;
	Thu, 30 May 2024 16:38:33 +0000 (UTC)
Message-ID: <effa6f38-50a0-4760-bcf6-71bdfac24ea6@acm.org>
Date: Thu, 30 May 2024 09:38:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] USB flash drive unusable with constant resets, since
 commit 4f53138fff
To: Joao Machado <jocrismachado@gmail.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 regressions@lists.linux.dev
References: <CACLx9VdpUanftfPo2jVAqXdcWe8Y43MsDeZmMPooTzVaVJAh2w@mail.gmail.com>
 <493e6372-cb4d-4f1f-9803-17d37a0fcbc4@acm.org>
 <CACLx9VdOeY6ZXEwGp-FOQY5VKJzgN6jJZQMhOdY9WnQjm07KSA@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CACLx9VdOeY6ZXEwGp-FOQY5VKJzgN6jJZQMhOdY9WnQjm07KSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/24 02:46, Joao Machado wrote:
> Tried the patch over commit 1613e604df0. Issue persists.
> Attached git and journal logs - notice here usb is using xhci_hcd 
> instead of ehci-pci, but this is because it's a different 
> computer/environment than the one originally reported.

Thank you for having shared the systemd journal. In that journal I found
the following:

May 30 10:23:56 archlinux kernel: scsi 6:0:0:0: bflags = 0x0
May 30 10:23:56 archlinux kernel: scsi 6:0:0:0: Direct-Access 
Kingston DataTraveler G2  1.00 PQ: 0 ANSI: 2

This is unexpected. It seems like the new entry in
scsi_static_device_list is being ignored?

+       {"Kingston", "DataTraveler G2", NULL, BLIST_SKIP_IO_HINTS},

Thanks,

Bart.
