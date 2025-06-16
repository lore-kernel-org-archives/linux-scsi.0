Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA39A1BC3F
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 14:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750084566; cv=none; b=fg979gVdxUWpoiAcUgUlc9f04iHauVrD3kpRg3cy0qk5VaXmgI8mjbfxDHvhIsnJ8iBkWNz13uetVTWLdNLyLCKFDo0ayjofYJXHHjJzcZxS0rCRbmncDqeaBJd1UwwpHyf0aIv6k2oiXe30+NTz75PWh/NPkLGwlZaxaGwsEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750084566; c=relaxed/simple;
	bh=lkkn5j7H4sLb0NDyrQUhe3JZh/b0R5tBG6NCHDSKDxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hVQxeACB9qtFlLyuGmYdjF6tNyEHLnVQNbtB/NXeL6BbesjZ4sjCF4ViRk/wy5XVdEI9JZ3UdKqXO5YFvTt6AsZK1vufbmVng2/IPrRcGT+xmypCBcnG2A/SaX7TVyrkA0sY/B8sIMlgBXYewXPGfl13OuAN6uBigTttw/Eqt4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4J4Rtgu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4J4Rtgu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750084563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8P6C3VOyWCSr/Pw6J8JHTXM1e6kPxEGsyDCYoqRWzKY=;
	b=N4J4RtguSJeYPdptpQdXF4/nGxmbRdw453KpfUgTJeFIj5MsAdDmXrsK3OwlhEIqL/F03y
	A7qZW68KRwRtA6gCFeuKI9IHu3c42pWgFv8mRh710mIWxsqtdI9jirb/WZ0P0I4i/zulGb
	veCzvv/7xqHsGQJ7E5jJjF1iK9mTvD4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-A0YSDCDRPDWKqA_PIVDCKg-1; Mon,
 16 Jun 2025 10:35:46 -0400
X-MC-Unique: A0YSDCDRPDWKqA_PIVDCKg-1
X-Mimecast-MFC-AGG-ID: A0YSDCDRPDWKqA_PIVDCKg_1750084543
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 660351809C82;
	Mon, 16 Jun 2025 14:35:43 +0000 (UTC)
Received: from [10.22.64.24] (unknown [10.22.64.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68AEE195608F;
	Mon, 16 Jun 2025 14:35:40 +0000 (UTC)
Message-ID: <6cf23067-de70-45b9-ad83-90e96c5ea189@redhat.com>
Date: Mon, 16 Jun 2025 10:35:39 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link
 down
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
 "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>
Cc: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
 "Dhanraj Jhawar (djhawar)" <djhawar@cisco.com>,
 "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
 "Masa Kai (mkai2)" <mkai2@cisco.com>,
 "Satish Kharat (satishkh)" <satishkh@cisco.com>,
 "Arun Easi (aeasi)" <aeasi@cisco.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "revers@redhat.com" <revers@redhat.com>,
 "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20250612221805.4066-1-kartilak@cisco.com>
 <20250612221805.4066-4-kartilak@cisco.com>
 <7a33bd90-7f1b-49ad-b24c-1808073f7f5e@redhat.com>
 <SJ0PR11MB589646EBDF785F570E35E774C377A@SJ0PR11MB5896.namprd11.prod.outlook.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <SJ0PR11MB589646EBDF785F570E35E774C377A@SJ0PR11MB5896.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Sounds good to me. Please make these changes in your v5 patch series and I'll approve.

/John

On 6/13/25 5:59 PM, Karan Tilak Kumar (kartilak) wrote:
> On Friday, June 13, 2025 1:29 PM, John Meneghini <jmeneghi@redhat.com> wrote:
>>
>> Hi Karan.
>>
>> You've got two patches in this series with the same Fixes: tag.
>>
>> [PATCH v4 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
>> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
>>
>> [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
>> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
>>
>> both of these patches modify the same file:
>>
>> drivers/scsi/fnic/fdls_disc.c
>>
>> So I recommend you squash patch 4/5 and patch 2/5 into one.
>>
>> Thanks,
>>
>> /John
> 
> Thanks for your proposal, John.
> 
> I'm a bit hesitant to squash them into one since each patch fixes unrelated bugs.
> The reason they have the same fixes tag is because we found two separate issues in the same commit.
> 
> I get your concern, however. What do you think about the following?
> 
> Move this patch to the beginning and increment driver version to 1.8.0.1:
> [PATCH v4 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
> 
> Move this patch to the next and increment driver version to 1.8.0.2:
> [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
> 
> Move this patch to the next:
> [PATCH v4 3/5] scsi: fnic: Add and improve logs in FDMI and FDMI ABTS paths
> 
> Ideally, I would have liked to squash this above patch with the first patch in this series, since it's easier to debug if and when an issue occurs in that path.
> I separated them since it would be easier to review. I could add a Fixes tag here as well, but I'm not sure about that since they are just log messages,
> and they are not really fixes.
> 
> Move this patch to the end:
> [PATCH v4 1/5] scsi: fnic: Set appropriate logging level for log message
> 
> Regards,
> Karan
> 

