Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EB02C08C5;
	Thu, 31 Jul 2025 11:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753962309; cv=none; b=X//N3dtW7wngzT/DITIniXsrMxKmdqOph4x7xW3DbTEZq9qNQQLY8nzEjkgsfKVw2dvy8eTsAwF3i3IY9LcIpDdAy5qgVKaikCfX0/Lh8Fn/GTy+A+O3tXANptqsab7tmU1mnO6VQq8b2qRQLHqwto82Rdey3e7ybLx8V1DKr+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753962309; c=relaxed/simple;
	bh=SguFdk2eBqdAr2jhUDgHv976RQ3g1gWDOYH1bMqzvLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6jx5mAEyBCgTQD28QZh4XIjJ8ynD+X2jVMCnCENTRfObu3hPKjtcZ/W4n2RV/LxLt1xinPZqaOGjdL+/Iyjdy7cU3LvOZumsIEgr3/iv62lGFLNsukjqWBZ2ehbaLiHgr0evuUT2j5W3NzA4ICRQQ1inqg2SbeES0Zyf6ej6kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 5157F4694D;
	Thu, 31 Jul 2025 13:44:57 +0200 (CEST)
Message-ID: <6d2573a6-b6e8-4c3b-be9d-344b30ed5399@proxmox.com>
Date: Thu, 31 Jul 2025 13:44:56 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Diangang Li <lidiangang@bytedance.com>
Cc: Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
 Mira Limbeck <m.limbeck@proxmox.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
 <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
 <20250731113806.GA93929@bytedance.com>
Content-Language: en-US
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <20250731113806.GA93929@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1753962284538

Hi Diangang,

On 31/07/2025 13:38, Diangang Li wrote:
> On Wed, Apr 30, 2025 at 02:13:53PM +0200, Friedrich Weber wrote:
>> Hi,
>>
>> One of our users reports that, in their setup, hotplugging new disks doesn't
>> work anymore with recent kernels (details below). The issue appeared somewhere
>> between kernels 6.4 and 6.5, and they bisected the change to this patch:
> 
> Hi Friedrich,
> 
> I would like to confirm the hotplugging method used here. Is it the logical operation using the following commands:
> 
> - echo 1 > /sys/block/sdX/device/delete
> - echo - - - > /sys/class/scsi_host/host5/scan
> 
> or does it refer to physical hotplugging (physically removing and reinserting the drive)?
> 
> I have tested both the 3008 and 9500 HBAs using the delete and scan method, and both worked fine.

Thanks for testing the "logical" hotplugging! However, I did use
"hotplug" to mean physical hotplugging here (inserting a drive that was
previously not attached).

