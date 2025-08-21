Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F1F2E1F02
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755791687; cv=none; b=bJaP7GOF8Fwah5DG9lIY5IADsbfA1K7WaIdSU5Mnf4AcYklOUDGXSxb2aieiWg5npjMED91C5Ehql4C5Zv9+xwydLgFG2BSkYu05ouV5n+PL1BqYwAz+utliFSWqngXYex+gzzyVNSbNXSAKDun+0ZxvXr39SEkaZN4SpTo7XEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755791687; c=relaxed/simple;
	bh=OLNVwL82Xi8KJgcx26c429GmirRggnUat2++83qs53U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YRDOpbt9/zsBSXOk2nqI6KV2L/60jbEwacI6e9TDksRUK2s8lmfGQw48J3O8v7oVg0kExkBS7AbXA45kFo030Ozh9R1d6UzVwmBwuTshKi4KplK8TO2hb5jy6oA1Nhdp1Yfa9XEvT7zL8hjIdCJ/ZInIIJEc7jh3cpfmBusr2rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QvecMpXS; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QvecMpXS"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c77Dh3r4xzm0yQF;
	Thu, 21 Aug 2025 15:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755791683; x=1758383684; bh=5N3MV1KxfQpsEBXk6fetnj97
	/s3Yi/K0ZEE7X1JY5x4=; b=QvecMpXShbuB8g9q9yauUMxGxdKntQcT/ilkrZBi
	EeWxpynA3r9LEC8yhF6Tve/U4Sxl5BA1NpEy+JtqgBZa0T9xras6/Z04KKIO5yIj
	pIZiKPeIo68ha/mHVjjFqdWpDFD9FGNAIOtp2Bq6tpcgYTKAgIs3SP1fmSCMfRNX
	T4O2Y2EpRics1yQKNiNUV1VnNMEWUyyytK+cWILEjnh6rdRAj/V7y75xjYI6oTZY
	a7HVyypy2X90dvd6xrynA4CpWPmZfRiOw+Eldv36820x0DhTkzl3yqVI+p78fsjJ
	d3Gr6btXgqiGKCKO3GtHGrH8fNmz4xKdnZuyGtMJ91EmKw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zximmsy1NVmq; Thu, 21 Aug 2025 15:54:43 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c77DV6GZLzm174J;
	Thu, 21 Aug 2025 15:54:33 +0000 (UTC)
Message-ID: <3a0c9dcb-71b9-4d58-bca1-53018248b018@acm.org>
Date: Thu, 21 Aug 2025 08:54:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
 <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
 <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
 <004de5e3-ad51-4a49-b7c7-e418587d3ef7@suse.de>
 <3a1f6959-8d74-4bb9-8e4b-31b5105734f9@acm.org>
 <36c7bf20-7dd4-4e19-8bc0-461a9f8a4228@suse.de>
 <58622f7d-a075-40b8-a2ea-190058d2737e@acm.org>
 <66a096d7-8ed1-4a08-a207-533f945f6784@suse.de>
 <0acda254-32a6-405b-a2d0-eef2401dbd83@acm.org>
 <76de3bab-edf5-43eb-a5d6-28dcced2130a@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <76de3bab-edf5-43eb-a5d6-28dcced2130a@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/25 11:42 PM, Hannes Reinecke wrote:
> Ah. But then you can allocate two separate queues & tagsets, one for
> TMFs and one for 'normal' commands (like NVMe does it).

Agreed.

> Then you wouldn't need reserved commands at all; they only make sense
> if TMFs and commands share the same tagspace.

That's wrong. There are other use cases for reserved commands, e.g. a
SCSI LLD driver allocating and submitting a SCSI or non-SCSI command to
the storage controller.

Here is an overview of the types of commands submitted by the UFS driver
to a UFS host controller:
* Task management functions. As explained in the previous email, TMFs
   have their own tag space that is separate from SCSI and non-SCSI
   commands.
* SCSI commands that are the result of a block layer request having been
   translated into a SCSI command, e.g. to implement filesystem I/O.
* SCSI passthrough commands submitted through the SG I/O interface.
* SCSI commands allocated and submitted by the SCSI core, e.g. the
   INQUIRY and MODE SELECT commands.
* SCSI commands allocated by the UFS driver, e.g. START STOP UNIT to
   change the power mode of the UFS device during runtime and system-wide
   power transitions.
* non-SCSI UPIU commands allocated by the UFS driver to perform tasks
   supported by the UFS standard that fall outside the scope of the
   SCSI standard, e.g. to query the supported queue depth or to interact
   with the real-time clock in the UFS device.
* non-SCSI UPIU commands submitted through the BSG interface.

The upstream UFS driver implements its own mechanism for reserving a tag
for non-SCSI UPIU commands (hba->reserved_slot). This patch series
converts that mechanism into allocating a reserved tag
(BLK_MQ_REQ_RESERVED).

Bart.
