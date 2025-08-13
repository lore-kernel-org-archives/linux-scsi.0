Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D989233711
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755098647; cv=none; b=dytBIvCZrqg3QYUNBqMSL74XPPjouT3XLw57quTbT2icL0MAmMji44Kln1kDfM3ghDw31GyWT1tNzv7c34YyowTOoboRzk/JHIkrEV8pisMLjcvFKx8tuP9+6aHvC9m98rdHLR7KgT4g6ormmXANucz4Ous4pmkcW8pSglBSqYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755098647; c=relaxed/simple;
	bh=1aAe9ddOFDXLUDYbXhbJX1sNq15vlrpe2ywss7qrn3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BMViKZvUsTUfHXfNe/7/6S7zEXvDJlTM7YQep85BMv40ul8nasARinnxHAtPVAQVBQ+QFbwCpi1wsu/xxWw4CiWoKD587wmJRYWtcUd7DGfXsHzS1izxbYYbqKO/s6WFbJiaGPrbbfkWQtQuE1m3Ay1DSmm2z19a8WD1u7aIbAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bp3ayXOb; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bp3ayXOb"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c2Bx03xvCzlgqy6;
	Wed, 13 Aug 2025 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755098643; x=1757690644; bh=3uPDQkd1lnJYjiGYjx4Y3I8c
	WT/mn4JJFz3JpGKWB/s=; b=bp3ayXObgl1WTdMOzK/M0lXMYbECpluJbjHXLdKO
	HMX94tEnQslKcQ8PkD7LUN2tP1hx13AvVRRFHg43esatbFYnZPlazM0pdiO7IjcZ
	2Pu7YI5zvXqt4hayqa/JVr+Wk+nwMZwx/8mXbGjqZz5QlqRAXb8SpasPpvw832Oy
	L/siRovVUarHn9KQeGCTZDA9KhliEvm13XfJe9hcCcy5unq4KLWPFJeAbVpi+hpu
	lV2y0VJv1N4zHtO/6ziIrEV6VsqeKj1K5z1bVy05dF8O/gvLsR/AfvxLZ2VolAdj
	y0yCK+3sfBKvPuHtIzAp6gf35UCpxAM6TSU2/WEuzTyZ4Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EKGophcjYLbt; Wed, 13 Aug 2025 15:24:03 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c2Bww1Fcrzlgqxf;
	Wed, 13 Aug 2025 15:23:59 +0000 (UTC)
Message-ID: <26558c0b-d793-4804-a60e-a21ab7116d1a@acm.org>
Date: Wed, 13 Aug 2025 08:23:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] scsi: core: Introduce
 scsi_host_update_can_queue()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-6-bvanassche@acm.org>
 <b65c0887-82da-42c7-b6dd-4a42d593fb69@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b65c0887-82da-42c7-b6dd-4a42d593fb69@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/25 2:47 AM, John Garry wrote:
> On 11/08/2025 18:34, Bart Van Assche wrote:
>> If a SCSI driver must use reserved commands to discover the supported
>> queue depth then the queue depth must be initialized to a small value and
>> must be changed after the queue depth has been queried. Support such SCSI
>> drivers by introducing the function scsi_host_update_can_queue().
> 
> why can you not just query this before allocating the shost via a direct 
> HW access?

Hi John,

Hasn't that already been explained in the above patch description?

The only way to discover the maximum queue depth supported by the UFS
device (bQueueDepth parameter) is by sending a QUERY REQUEST / STANDARD
READ REQUEST to the UFS device. The current approach in the UFS driver
is to reserve one command slot for device management commands, not to
make that command slot visible to the SCSI core and also to have code
for sending and completing device management commands that duplicates
some block layer and SCSI core code.

In this patch series the choice has been made not to duplicate any SCSI
core / block layer core code. Hence, the SCSI host is allocated first
and the QUERY REQUEST is allocated as a reserved command. Existing SCSI
core functionality is used for submitting that reserved command and also
for handling timeouts. Hence the need for the
scsi_host_update_can_queue() function.

As one can see this approach allows to remove a significant amount of
code in patch 30/30: the entire ufshcd_wait_for_dev_cmd() function is
removed.

Thanks,

Bart.
