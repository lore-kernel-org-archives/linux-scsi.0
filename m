Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA1F303A07
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 19:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758655301; cv=none; b=Ee+96RSyMaum1PJ358uKNMb06f8QPH5bFOjC/8XF70nqa6mI6dtB7J3vIT4tyvKdJregw2hvauG7+ecZblBmgU5tEcuehjwgppHvHksjvX9sKI7isj8vbUkavXd4dv+fMbV4Vfo+HpuIEIcO3bP2l7UnLukpzYs5tUQkx6k+Pk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758655301; c=relaxed/simple;
	bh=DO9251kpRP85N0JORlgoNWu8iQh2/lRh0KiC2mV9grU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JNPY+MqqAJ04IeVDYsLDe8OAhVHovzEZCYptuDkgBfvYwUZ9TUpXmxvGrUW8ty+2ow2RBGA3Ji2074o1RvTQUcBJK41qxwuHJSk7qczrqlBmNTFeVtrTjM+dezaHUiK5eDdF+4GXWB4Z4DHokKhcxDT19aCXmFBXvs0tLDaEXHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YhhRIq1p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YhhRIq1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758655297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xl7UyYqk9Vb6Zxi8T4sES16fmcCIjyttGOTxSZhU4nY=;
	b=YhhRIq1pGVk9hMXw+a0LAgLwALB/npmjSB/k573MpRHJa5pNjBIWR+oD4HBFMzwyiOzBCw
	oHU5vGOMtUUVrBcgMb2c36iz4M0B2hGj6aIfri5LvYdQ19nT5DX3XFeI+z1zA04b3neYrH
	LyCfEPngB+L63BWoLSHzQb+QchouRwU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-8HdHTSfQMHOU2C0oO_HfiQ-1; Tue,
 23 Sep 2025 15:21:34 -0400
X-MC-Unique: 8HdHTSfQMHOU2C0oO_HfiQ-1
X-Mimecast-MFC-AGG-ID: 8HdHTSfQMHOU2C0oO_HfiQ_1758655292
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70CCA195608A;
	Tue, 23 Sep 2025 19:21:32 +0000 (UTC)
Received: from [10.22.81.200] (unknown [10.22.81.200])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE10D18003FC;
	Tue, 23 Sep 2025 19:21:28 +0000 (UTC)
Message-ID: <513ae24d-fe17-4dd1-a226-4c699e94c0e3@redhat.com>
Date: Tue, 23 Sep 2025 15:21:27 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v9 0/8] nvme-fc: FPIN link integrity handling
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, axboe@kernel.dk, Bryan Gurney <bgurney@redhat.com>
Cc: james.smart@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, hare@suse.de, linux-hardening@vger.kernel.org,
 kees@kernel.org, gustavoars@kernel.org, emilne@redhat.com
References: <20250813200744.17975-1-bgurney@redhat.com>
 <175613417235.1984137.13827666752970522478.b4-ty@oracle.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <175613417235.1984137.13827666752970522478.b4-ty@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hey Martin.

We've been testing this patch and it turns out there is a significant bug here.

This bug causes a call trace and a driver hang.

I suggest you remove this from scsi-queue and let us fix it.

/John

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 253f802605d6..44e9f7df8db2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6459,9 +6459,10 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
  void
  qla24xx_free_purex_item(struct purex_item *item)
  {
-       if (item == &item->vha->default_item) {
-               memset(&item->vha->default_item, 0, sizeof(struct purex_item));
-               memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
+       scsi_qla_host_t *base_vha = item->vha;
+       if (item == &base_vha->default_item) {
+               memset(&base_vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
+               memset(&base_vha->default_item, 0, sizeof(struct purex_item));
         } else
                 kfree(item);
  }


On 8/25/25 10:33 PM, Martin K. Petersen wrote:
> On Wed, 13 Aug 2025 16:07:35 -0400, Bryan Gurney wrote:
> 
>> FPIN LI (link integrity) messages are received when the attached
>> fabric detects hardware errors. In response to these messages I/O
>> should be directed away from the affected ports, and only used
>> if the 'optimized' paths are unavailable.
>> Upon port reset the paths should be put back in service as the
>> affected hardware might have been replaced.
>> This patch adds a new controller flag 'NVME_CTRL_MARGINAL'
>> which will be checked during multipath path selection, causing the
>> path to be skipped when checking for 'optimized' paths. If no
>> optimized paths are available the 'marginal' paths are considered
>> for path selection alongside the 'non-optimized' paths.
>> It also introduces a new nvme-fc callback 'nvme_fc_fpin_rcv()' to
>> evaluate the FPIN LI TLV payload and set the 'marginal' state on
>> all affected rports.
>>
>> [...]
> 
> Applied to 6.18/scsi-queue, thanks!
> 
> [9/9] scsi: qla2xxx: Fix memcpy field-spanning write issue
>        https://git.kernel.org/mkp/scsi/c/6f4b10226b6b
> 

