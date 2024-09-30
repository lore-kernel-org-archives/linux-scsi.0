Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5E3194082
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 21:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727730614; cv=none; b=TydsnBgqTaTO1/xbaMPIYwNmSV1Z3b95+zkm/P6BlbcJMEFHFadyKDpyihbe2LwKGbzayWiykRFg3hP6+1NON7BTkB3BDnbH0GiT0NAwH+3UC+z3yL5afEdLeoreoDy4i4Iko0t0BgJreVQFpsbI+X2rUBlKHVPDYoL1gj82bF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727730614; c=relaxed/simple;
	bh=iwz7kemd+ZPql3tKiWSktvluu+eu322I6g1O3slEyr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jzgdfSFCDQ1FojsL8UXcflc93S5nJ7Q53cHDea6V+m4jJDZ3OBs9UX3aq7ipYbT58UOlkdLoI5otssPNpyvoXqLT+CY057Rf+uEer8dy0RaIKdNRiBbbUgkbaNyilgoil1sSIak/VR2pIUi47TmQbbnUJt8/UfRqWebXrLGpKLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NlhpFs45; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NlhpFs45"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XHYcg6Zrbz6ClY9c;
	Mon, 30 Sep 2024 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727730608; x=1730322609; bh=yqO416bKuFNx8F28Jg5MaNcL
	TM2CBjhUt96S3yowCB0=; b=NlhpFs45m2osyZypt2oX+wXqTnF3eVdUHPLC+DJR
	x0IHRFCV9bUEpMVMDzK8a8JFuXqSoyNb1GvDMFUKy7vfmudl4woF3UWfEryM5nG0
	9VVoQL7010CnxXhjlp5mLiQYdQbL7mvWEADkJVUe98o38g79NNNfH6nCaCSVycSE
	N+PQMLEXbjqSHRsVefwrTL7Lv18oKrCRkf+OmLKDB1HkPAIy7YMPxQREfaiHriEM
	GVi7cy7bVLpY0Zkuom0zqdglTGqinIsGGqLn67ld9X6OzL3ewyr61q4FvO1WKwS8
	h3jNyKXv2ZCzZDZavU3vdDaPAkjDK2F7ki26G3Wj1TPBOA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4cyX0mBVQ_c6; Mon, 30 Sep 2024 21:10:08 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XHYcb6CT3z6ClY9b;
	Mon, 30 Sep 2024 21:10:07 +0000 (UTC)
Message-ID: <0c044232-e36c-4c0b-a87d-4be25bd737cf@acm.org>
Date: Mon, 30 Sep 2024 14:10:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: Rename .slave_alloc() and .slave_destroy()
To: Matthew Wilcox <willy@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-2-bvanassche@acm.org>
 <ZvsQ310JHWHJAv7l@casper.infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZvsQ310JHWHJAv7l@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 1:58 PM, Matthew Wilcox wrote:
> On Mon, Sep 30, 2024 at 01:18:47PM -0700, Bart Van Assche wrote:
>> There is agreement that the word "slave" should not be used in Linux
>> kernel source code. Hence this patch that renames .slave_alloc() into
>> .device_alloc() and .slave_destroy() into .device_destroy() in the SCSI
>> core, SCSI drivers, ATA drivers and also in the SCSI documentation.
>> Do not modify Documentation/scsi/ChangeLog.lpfc. No functionality has
>> been changed.
>>
>> This patch has been created as follows:
>> * Change the text "slave_alloc" into "device_alloc" in all source files
>>    except in the LPFC driver changelog.
>> * Change the text "slave_destroy" into "device_destroy" in all source
>>    files except in the LPFC driver changelog.
> 
> I still like my names better:
> 
> https://lore.kernel.org/linux-scsi/20200706193920.6897-1-willy@infradead.org/

The names used in this patch series are the names proposed by Christoph
Hellwig. Christoph, do you agree with the names proposed by Matthew?
 From his cover letter:

   scsi: Rename slave_alloc to sdev_prep
   scsi: Rename slave_destroy to sdev_destroy
   scsi: Rename slave_configure to sdev_configure

Thanks,

Bart.
