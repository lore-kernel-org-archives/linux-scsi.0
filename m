Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACD51DFDB8
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2024 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734103716; cv=none; b=aY1kZmanKNyrdpoq2sGTtelPwpi/0J8pN+L9x0/8bXaaXvHKr7W6mtm4Z/qRExaiedNVhQo14hnO/JTVMorh/Z0D0iZpWRZ3UFbOhwFEkF5kZwdqjiTlWbeSGd9nBPU9ewrZjzf8EQB9N0sQYRAvfNv2rHcszr4BqwyquQL327s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734103716; c=relaxed/simple;
	bh=l1evNP20wmM4EbJK6FvzZuCAdPCZb7XzheNuh31wE/k=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=knLu+UqQdFF5jij5XS5XVTvFU8dbd5PuXDFvyIIKyrZ1sF5sBcsRqu2bJk/VQF8UlO8Xaq2xwV1EOQI2jm4lallMwlqAU3Z/YUiOLYfLiKuDxqtSaAjE88hWqhavEFjqMRbGB1zdwZ0RqYfTzH/WzCgEL0SFK9mkMmFzjH/Hdf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DD/X4RLp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DD/X4RLp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734103713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SBc/VbDOQTKd3cVXdHs4WGgfRbvsMNSvGOMZYEnsvog=;
	b=DD/X4RLpg22/pQ0yQEXjpgO3Sej5F/HAVqZGywbiBJrtjF6hfNgH6HxQOgRqYrfAvK5OR2
	QkhDU24sjsLb5Ers7WPHjJT1rQl7vy7oLKSoKb42Rg4rF7plY9fW9TEB+5HL/AV21r8cve
	9HW7wzl3C1IU0G+PDtUKZd2wjtIhktw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-xxcSivu7MyuUnOqLRiYZPA-1; Fri,
 13 Dec 2024 10:28:31 -0500
X-MC-Unique: xxcSivu7MyuUnOqLRiYZPA-1
X-Mimecast-MFC-AGG-ID: xxcSivu7MyuUnOqLRiYZPA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D5691954224;
	Fri, 13 Dec 2024 15:28:30 +0000 (UTC)
Received: from [10.22.64.187] (unknown [10.22.64.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7CF4F1956052;
	Fri, 13 Dec 2024 15:28:27 +0000 (UTC)
Message-ID: <f42c28f2-0141-47a9-a65a-df7de9f00e7f@redhat.com>
Date: Fri, 13 Dec 2024 10:28:27 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
From: John Meneghini <jmeneghi@redhat.com>
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>, loberman@redhat.com
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
 <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
 <46598e48-26a8-4062-afb1-677ff7295335@redhat.com>
Content-Language: en-US
Organization: RHEL Core Storge Team
In-Reply-To: <46598e48-26a8-4062-afb1-677ff7295335@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 12/13/24 10:09, John Meneghini wrote:
>>  previously suspected that the first POR UA is caught by scsi scanning when it issues
>> MAINTENANCE_IN to get the supported opcodes. This happens when scanning calls
>> scsi_cdl_check(). However, this function does not do anything if Scsi level is less than
>> SPC-5 (ANSi 7). Scsi_debug claims SPC-5 and so scsi_cdl_check() gets the UA
>> before the st device exists. Your drive probably is reporting a level less than SPC-5
>> and so the UA is not received by the scanning code.
> 
> No, I don't have a problem with the tape drive. Everything works correctly with the tape drive.  You can see the test results 
> log for my latest test with the tape drive at:

Sorry, I misunderstood your comment.  Yes, the tape device I am using for testing is reporting SPC-3.

[root@to-be-determined tape_tests]# sg_inq /dev/nst0
standard INQUIRY:
   PQual=0  PDT=1  RMB=1  LU_CONG=0  hot_pluggable=0  version=0x05  [SPC-3]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
   SCCS=0  ACC=0  TPGS=1  3PC=0  Protect=0  [BQue=0]
   EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=1
   [SPI: Clocking=0x0  QAS=0  IUS=0]
     length=96 (0x60)   Peripheral device type: tape
  Vendor identification: QUANTUM
  Product identification: ULTRIUM 4
  Product revision level: U53F

So you are saying this this issue of the mid layer not reporting the first POR UA would be seen if my tape drive were in SPC-5 
device.

/John

