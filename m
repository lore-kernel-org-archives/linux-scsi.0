Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA8380C
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 14:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GuU/ci4v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703169228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XS1e0/Pk60QK5A5wljprGtJUe3LIxzDIJASNLzakDq4=;
	b=GuU/ci4veVSOiY5/AR4bld8q8FOeE0KsrDrokgNmn82f8XJZoFPEjUgVOjtCgBoxgDKfso
	wdJ0vM2yG6MT+k0dNjiprlPmdWuT/HzBFhwoVkrPOooLLupSd8sRQ4+qFq2TuvRYXqZkPB
	zfu+yRK27ggaaxl9FRbTDiUnZb5OXBY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-kWvXkKBcNsytNQ2IBV6oQg-1; Thu, 21 Dec 2023 09:33:46 -0500
X-MC-Unique: kWvXkKBcNsytNQ2IBV6oQg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B002C185A781;
	Thu, 21 Dec 2023 14:33:45 +0000 (UTC)
Received: from [10.22.9.14] (unknown [10.22.9.14])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 372B8492BC6;
	Thu, 21 Dec 2023 14:33:45 +0000 (UTC)
Message-ID: <c9f7d912-d19e-484b-837e-b07171979eef@redhat.com>
Date: Thu, 21 Dec 2023 09:33:44 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [EXT] Re: [PATCH] cnic: change __GFP_COMP allocation method
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>, gregkh@linuxfoundation.org
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "lduncan@suse.com" <lduncan@suse.com>, "cleech@redhat.com"
 <cleech@redhat.com>, "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>,
 GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Nilesh Javali <njavali@marvell.com>
References: <20231219055514.12324-1-njavali@marvell.com>
 <ZYExB52f/iDzD8xL@infradead.org>
 <CO6PR18MB4500F0DCD64925A775A45F2DAF97A@CO6PR18MB4500.namprd18.prod.outlook.com>
 <ZYPfr5G2j2VWUmfR@infradead.org>
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <ZYPfr5G2j2VWUmfR@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Including Greg.

On 12/21/23 01:48, Christoph Hellwig wrote:
> On Tue, Dec 19, 2023 at 06:16:38AM +0000, Nilesh Javali wrote:
>> If you are referring to the series proposed by Chris Leech, then this had
>> objections. And that was the reason to look for an alternative method for
>> coherent DMA mapping.
>>
>> [PATCH 0/3] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
> 
> Yes.  Well, Greg (rightly) dislikes what the iscsi drivers have been
> doing.  But we're stuck supporting them, so I see no way around that.

If this is true then can we reconsider Chris's patches.

Red Hat has multiple enterprise customers who are relying on this driver and we need to keep it running - at least till the end 
of RHEL 9.  We can try and drop support for bnx2/cnic in RHEL 10 but RHEL 9 is in the middle of its life cycle and a failure to 
address this issue is causing many problems as we attempt to keep RHEL 9 current with what's upstream.

Greg, can we please take Chris's patches upstream?

https://lore.kernel.org/netdev/20230929170023.1020032-3-cleech@redhat.com/

/John

