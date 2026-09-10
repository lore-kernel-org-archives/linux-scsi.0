Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6FA47D440
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 13:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046939; cv=none; b=AS/phFCDSCdZPM8+//rUASvKydgabN30+81eeKXDUrCGdeVeEAFfIch925Hg8YMH3XCF/a8kJoeq+4/Tr4EZXTgpAidaJ/bU/6n8awimzT2uWHB0T4Ny3PglOE86K3uMs6FFfPQXfXqd04SnXKsz6yOFl6VcE1DcYrNf8nN7WbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046939; c=relaxed/simple;
	bh=6bHrzkwjGLDM0rn4hiEHId6tUhLQPFDL/kpUQ4aebo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=INbGa/oCWfZqg6LKr8Wa+uiWZW6P0Kx/2d4v9qGro/5F3Btx3HXs/rOMnNzDDPlBL+vQkJ8GNX21YZbEfZ+pQB+O1EDaWoGK5pnBIkO0+Ye2+95IrWDtnj5VXfzRfC25dwx81oZr3DyvrMalEORjr4D6QYCNZt950q5+EZSaLTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0LOZlOcM; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0LOZlOcM"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hgdmg0jxPzlfvqM;
	Thu, 10 Sep 2026 13:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789046927; x=1791638928; bh=C1YJtxOPeJxlilqWaRZ7kRE2
	tqIDEnRNLyks9DC8EtM=; b=0LOZlOcMvM3rNWvCPPu0k6MGBtjZQdOWW05dZahl
	suRLnahOdRK2s0fNnYi1Gj1VuopxJbwn+cZiETdjrJgLlYolstdUbU6dog46K2TV
	APvzLVVCAfXo4lkYZBTpT43YcWTvIZHeOiTrlqYI5r3ZRC5DWv1x+Da9EV0jkZDR
	j5uH8S+OEs5g0nroqiSOIfewFHO1N91qNXkadNykYWNpOyA/sU6KOvBP41Jm2fq1
	QYnNaYkEdObG/KNwbtTDRs2XtYGkLfMM2W5FXHkTz8emBfUZQ8p+E0+ghCaVfxTC
	pW6JPDuWilS1oIRMP/NJ9b1y/oetwvyaB+aypjcyfPJIlA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id eSgsbZXX6s3Q; Thu, 10 Sep 2026 13:28:47 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hgdmY5W6yzlfvpH;
	Thu, 10 Sep 2026 13:28:45 +0000 (UTC)
Message-ID: <26af649e-20bd-4caf-8409-1db757b585c8@acm.org>
Date: Thu, 10 Sep 2026 06:28:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: core: Eliminate
 scsi_log_{reserve,release}_buffer()
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1788198780.git.bvanassche@acm.org>
 <c575754856db35fe70aa7a09f1c75b7efdf118fd.1788198780.git.bvanassche@acm.org>
 <f53edf7b-fc80-4815-a884-f03a25ab0527@suse.de>
 <10c53a10-e553-4aef-8438-2ad1dbfc8993@acm.org>
 <97644265-c807-412f-92a8-7866f5ae9b50@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <97644265-c807-412f-92a8-7866f5ae9b50@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/26 3:45 AM, Hannes Reinecke wrote:
> But in removing scsi_log we're back to square one, namely that we
> cannot assemble a single line of logging with several calls
> (eg as required when dumping a hex buffer or a SCSI command).

This patch uses %*ph to dump hex buffers. No temporary buffers are
required to dump a hex buffer. The temporary buffers introduced by
this patch are as follows:

+	char opcode_name[64];
+	char sense_hdr[64];
+	char extd_sense[96];
+	char mlret_buf[32];
+	char hb_buf[40];

Personally I prefer the introduction of these temporary buffers rather
than making every sdev_prefix_printk() call perform a fixed-size
GFP_ATOMIC allocation. This patch eliminates the risk of log line
suppression because of GFP_ATOMIC memory allocation failure and also
eliminates the 128 byte line limit length.

Thanks,

Bart.
