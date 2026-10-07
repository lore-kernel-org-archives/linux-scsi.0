Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31C62D2381
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 20:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791403739; cv=none; b=XZP/aaa2WCTaQyxIATDGEJpSJkzY/eWvdd2qJEv3WWlU0EdxCcJf0BsuWUqoai92grkYcMlTBVuqF/hnArqOfVHa/j9fMMNmAKKE9Dp/j4BJwss1f+nCTgtHQHi94CSyvuursyzgpJMvP4IvCRZttpzOC8CSZrFyjXflZasSjkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791403739; c=relaxed/simple;
	bh=5VANaEcL5Kzz00z+EXdJnhrvS99SoSmid+KbtSDTuVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cZrsCCOEVlOUu9QhixogEGBgsnNKQ/xeAFJVsVzisWf16kdw+YiygPBoSXns6volKviLrNZT/xTO8QXPPFu5ooErhxd9h1VB/ksxDwywMqAzrlAU/dk3ju+gwJZPqpvMaVTzTsSRp/JuZcqxwydi1C85IgO2NUlxORCNaLI4b7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eMlgsKFx; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eMlgsKFx"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j0PMs30Pjzlfvps;
	Wed,  7 Oct 2026 20:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791403734; x=1793995735; bh=OZ6MZk+U1NsvasI4OJzZui42
	/A2T1vQUg9tAEeTZkwM=; b=eMlgsKFxNFSSeWsRl5BI1OyNzvAPoxmLjl0US4pF
	Qw+7gRCT1QDipLbu46aq+UjNCLEH00F6VcVefM3C6FsPy1+R3IF/wtd+FwVdkIMM
	bUm705PUkfX8NpAEM9kHle65a3xeveGjDgqQzCmdDrhImC3bVxByzB+mwBg8n8PE
	1i1ngCD3CbkWBPIMnVIQbyQ3R8iTz19MrPzi/BYaiG1Y6eoWLNReI2k5iLM5OvQ3
	K/XQCAtzHhzS58Uffxt7DASUY/cgU2y61koZOTlpQzmM3dvkjVY81C1zsWALfOBv
	ygUmltyqdINUQw9arb42iSLRCVe0IJBL9OfLva4R4eicTg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xgCCdk-FBHZD; Wed,  7 Oct 2026 20:08:54 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:d224:603c:1a28:dc62] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j0PMn6ckzzlfvpb;
	Wed,  7 Oct 2026 20:08:53 +0000 (UTC)
Message-ID: <2dbc5f92-10b1-4265-b08f-86b7c49b85b7@acm.org>
Date: Wed, 7 Oct 2026 13:08:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/8] scsi: scsi_debug: Split resp_write_dt0()
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
References: <cover.1791349129.git.bvanassche@acm.org>
 <cd2d03eef52045b8a94c7c11644c3676f91b105f.1791349129.git.bvanassche@acm.org>
 <20261007131218.GC30647@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261007131218.GC30647@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/26 6:12 AM, Christoph Hellwig wrote:
> On Tue, Oct 06, 2026 at 10:07:27PM -0700, Bart Van Assche wrote:
>> + * Returns 0 upon success or -1 with *scsi_status set to a SCSI status code upon
> 
> Overly long line.

Hi Christoph,

This line should be exactly 80 columns wide. Is that too wide? I'm fine 
with reformatting this comment but I'm surprised to read that 80 columns
is too wide?

Thanks,

Bart.
