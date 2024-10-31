Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBE516BE1C
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730393042; cv=none; b=bovfCyTOTknk6/r77HGpy1527Wb58lPbsosm+hj6d8TxPPtTYhj/UPrmrFusxO/l5Qj9K2GfD3lONFnA/oejBKWMAoamO56aeaKk8OwqFb+Nlvt8bU82NnxXwTt1ftDvRp+YGpqh6Hi5aySNyYkLqYIFbbD/zpYTAnqPLpUj9Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730393042; c=relaxed/simple;
	bh=rh9tjKxiW79rwh2W6VcVxS4QP4aEGxGU6lihUwrCoo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1M5WazByVpFlGLxmVd9v62ejgl+nfKDUUBV53iQDlR9oRm57cbi5PXHRrMB9r1e0fTub7TfXe8ab9ausbzzE9tFKDtOJbTCmOITiAivy1P1Cj4z5f6vjqqMFDHdGPrKJ8Mjv0FBQF3praPo9yLGl+ZKWYh7UX7kcr19p3cTHXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GmS+2f4w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GmS+2f4w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730393039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iAeVnnysFr5QrWRKjtoCrwKhtIjFBKqF7Mv2CH2NgYo=;
	b=GmS+2f4wVc/iAuHBfd7j/wG1esurB0wnjxWJNmnqr4b9DEeiTPMfMad+lqzsV5/1jeZqsu
	ZSZhFZXY91gjU0h1QyTDK4esZWBPL4X3FR317UvAcpSxvh3ZOgSJaNkn735o2oBSkCP57O
	Y+e/J2xsG5enxcHegf/UmaXS0mVmYRY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-n5kopPkZP2OT391AHvjCdQ-1; Thu,
 31 Oct 2024 12:43:56 -0400
X-MC-Unique: n5kopPkZP2OT391AHvjCdQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8123A195608B;
	Thu, 31 Oct 2024 16:43:54 +0000 (UTC)
Received: from [10.22.88.108] (unknown [10.22.88.108])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6707D1956052;
	Thu, 31 Oct 2024 16:43:52 +0000 (UTC)
Message-ID: <7c363313-f7cd-43d2-a080-81a58a37a603@redhat.com>
Date: Thu, 31 Oct 2024 12:43:51 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: st: clear pos_unknown when the por ua is
 expected
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>, loberman@redhat.com
References: <20241031010032.117296-1-jmeneghi@redhat.com>
 <20241031010032.117296-4-jmeneghi@redhat.com>
 <3BCF79DE-1CF8-436D-A611-24387F976F68@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <3BCF79DE-1CF8-436D-A611-24387F976F68@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


On 10/31/24 10:17, "Kai Mäkisara (Kolumbus)" wrote:
> On 31. Oct 2024, at 3.00, John Meneghini <jmeneghi@redhat.com> wrote:
>>
>> From: Kai Makisara <kai.makisara@kolumbus.fi>
>>
> 
> The patch in this message is a WIP patch discussed in Bugzilla. It is not
> meant to be submitted as such. (In addition to changes, it contains a bug
> fix not related to the changes.) Those interested in the progress can look
> at the Bugzilla entry shown below.

Agreed.

>> Fixes: 3d882cca73be ("scsi: st: Fix input/output error on empty drive reset")
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219419
>> Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> I have NOT signed of this patch.

Sorry, I added this because I wanted to publish the changes and checkpatch.pl was complaining that your name wasn't contained in 
the signed-off.

>> Tested-by: John Meneghini <jmeneghi@redhat.com>
> 
> John has done extensive tests to see if the patch works.

Yes, please see the bugzilla for more information.

/John

