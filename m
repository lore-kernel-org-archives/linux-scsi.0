Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617243F23CA
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 16:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772123743; cv=none; b=JcPjBEmLWhAwLgug5Os4514foXRTxJPngLQWCZpIaaAvCbnr7nkLMPAFyqKaPeLTE3t7bVqxuI0Agzm287drtgqm3EjBlec1zkyBKwDZ7Irh0Ax0vHWMJq0nAzFhWhPRWD9Rf0WdfcJgFOr/AD5JjvIJtbrfxRUQhRlxWzzomew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772123743; c=relaxed/simple;
	bh=GP535zZasOECq/AEw3+UTl2twtAnAjD24IqZAtqGjuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=krU2twW+FLpmeYetD0GBe60F2XZTFceJydIaeF74dV6FjRyhpmfWhxntBsDYQZUWG4VEtBjaktrBgkTX1xHMt/FVsM0/RpTxE1Fonh/EfLg4OYwIg8VYn2nBk85FL33HQaSPCVjRtv2ilgwIMwa9IICHwC7bpwJAi5yiHL6DrpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bCgsN5cD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bCgsN5cD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772123741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SsBdkNgdY8o4f3ZKswpTJzrG/sFi18dzucDnk4F4sHo=;
	b=bCgsN5cD45uMAnlffM1p950ldS3xe/zkVLw65DChHqZAQ4/4og6Yiyv6k3YQKd3ios+Ebw
	i7MB/54W5YKzwOm/p/wp9mT9vHDH8eTCaAOe/O8kLSU8FplMZ6AcVqAhBfE84pxahRFRHo
	yvbBbmLPg+EP1gU24jRHqP8FHWqrRhM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-147-Gnn-uyuBO168zBSSxnrCZw-1; Thu,
 26 Feb 2026 11:35:35 -0500
X-MC-Unique: Gnn-uyuBO168zBSSxnrCZw-1
X-Mimecast-MFC-AGG-ID: Gnn-uyuBO168zBSSxnrCZw_1772123733
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7AAC41831358;
	Thu, 26 Feb 2026 16:35:20 +0000 (UTC)
Received: from [10.22.65.209] (unknown [10.22.65.209])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D7E3F1800677;
	Thu, 26 Feb 2026 16:35:16 +0000 (UTC)
Message-ID: <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
Date: Thu, 26 Feb 2026 11:35:15 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during async
 scan
To: Maurizio Lombardi <mlombard@arkamax.eu>, Keith Busch <kbusch@kernel.org>,
 Maurizio Lombardi <mlombard@redhat.com>
Cc: hch@lst.de, hare@suse.de, chaitanyak@nvidia.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
 James.Bottomley@hansenpartnership.com, emilne@redhat.com, bgurney@redhat.com
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp> <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


On 2/26/26 3:07 AM, Maurizio Lombardi wrote:
> On Wed Feb 25, 2026 at 10:41 PM CET, Keith Busch wrote:
>> On Wed, Feb 25, 2026 at 05:12:00PM +0100, Maurizio Lombardi wrote:
>>> The NVMe fully asynchronous namespace scanning introduced in
>>> commit 4e893ca81170 ("nvme-core: scan namespaces asynchronously")
>>> significantly improved discovery times. However, it also introduced
>>> non-deterministic ordering for namespace registration.
>>>
>>> While kernel device names (/dev/nvmeXnY) are not guaranteed to be stable
>>> across reboots, this unpredictable ordering has caused considerable user
>>> confusion and has been perceived as a regression, leading to multiple bug
>>> reports.
>>
>> The nvme-pci driver also probes the controllers asynchronously, which
>> can also create non-determinisitic names. Is that part not a problem?
> 
> Potentially, it is. The difference is that so far no one ever complained
> about it, while with namespace async scanning we immediately received regression
> reports, to the point we had to revert the changes and restore the
> sequential namespaces scan in RHEL.

It's worse than this.  Yes, in RHEL we carry out of tree patches to tun off the async scanning with SCSI,
and we reverted this async namespace scanning patch in NVMe.

We had to do this because, as soon as we turned these async scanning mechanisms on, we immediately
received customer escalations. Customer were not able to upgrade their systems. We have customer issues
and complaints open about this and we see this async namespace scanning as a barrier to adoption with NVMEe -
especially with NVME-OF which tends to have many more Namespaces than PCIe.

We've talked about this at LSF/MM - more than once - and several solutions have been proposed in the past,
but nothing ever happened.

And yes, the PCIe async discovery stuff does cause some problems.  The difference is: the PCIe bus configuration does
not change nearly as often as, e.g., the nvme namespace configuration in a fabric, so customers don't notice the changing pci ids.
Unless some one is going lots of hot unplugging and plugging with their PCI bus, the PCI ids typically don't change at all.

So from boot to boot, pci id don't usually change.  This async namespace scanning causes the namespace ids to change with every reboot, especially on
a system with 100's of nvme-of namespaces.

So, we really need this change, or something like this, to be accepted upstream.

/John

