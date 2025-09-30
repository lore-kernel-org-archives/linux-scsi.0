Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D534283FEB
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 10:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227461; cv=none; b=YlcSW39BxXvd50BZ1sZzC7EX0r+dhXmYGNUo/NgTBzDwIIyLARru2slHN+AbfaSCHDSBxybYzjGskdrAJ4UMrLEe65f2OP2eB0L1hsR1RecXOtd+6H80E1VlgzILxOg1LziAIDqmvz942ohyEe0ru/5Tbl92l3uiwkVkFmWCbJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227461; c=relaxed/simple;
	bh=OgxsNCOG0Jgve0lCwcvadpF3pnhXsGtnVRE0S+mZi5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AkBmois65VFwVfezoemI6jTMiww2XLc276S1mCRQ32NTD91xZUskKxBDRgV9WLzxowcuVYEY1j8GdfIP8M89St++b1Z2nunkCkvSVP2fmklAeieFi7XhlC6+5S1rYAbTLmeSsB53uOBC3wE1a4+qjzPi2S6p1fU7DSYPLsyv6Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EN3IiMfw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EN3IiMfw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759227459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdJuTKOf/1oQDjnzdAFIGDSMiQQ/LUgyrgeX0PFVxss=;
	b=EN3IiMfw2zu8IYtzdi/vqLFf+Fu/KyRpLXVxYDMdA2sNeVOGFHHMmkg33/+e2EADXIkRC8
	OLU+C2Z1Z83jvOngXGk9/jg8O7jzv0NCNiM7CQ3PbvwdL4mR6qjtXNvkDpddSkSitGyJX/
	nVu7K8SJDsQL+WwBkapGM7jmlYTd2BY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-J7GdcnEpOwauqhdqpvL-Gg-1; Tue,
 30 Sep 2025 06:17:35 -0400
X-MC-Unique: J7GdcnEpOwauqhdqpvL-Gg-1
X-Mimecast-MFC-AGG-ID: J7GdcnEpOwauqhdqpvL-Gg_1759227454
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A90951800378;
	Tue, 30 Sep 2025 10:17:33 +0000 (UTC)
Received: from [10.44.33.194] (unknown [10.44.33.194])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D16A2180035E;
	Tue, 30 Sep 2025 10:17:27 +0000 (UTC)
Message-ID: <eed2bd71-4938-47c9-a0b3-6d24f06a7361@redhat.com>
Date: Tue, 30 Sep 2025 06:17:26 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/11] scsi: scsi_transport_fc: add
 fc_host_fpin_set_nvme_rport_marginal()
To: Justin Tee <justintee8345@gmail.com>
Cc: hare@suse.de, kbusch@kernel.org, martin.petersen@oracle.com,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com,
 gustavoars@kernel.org, hch@lst.de, Justin Tee <justin.tee@broadcom.com>,
 james.smart@broadcom.com, kees@kernel.org, linux-hardening@vger.kernel.org,
 njavali@marvell.com, sagi@grimberg.me
References: <20250926000200.837025-1-jmeneghi@redhat.com>
 <20250926000200.837025-8-jmeneghi@redhat.com>
 <CABPRKS9SkaGZjC_vEy-YdgYELffGLvub7DTFGCYXFW68ObWqYg@mail.gmail.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <CABPRKS9SkaGZjC_vEy-YdgYELffGLvub7DTFGCYXFW68ObWqYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


On 9/29/25 1:45 PM, Justin Tee wrote:
> Hi John,
> 
>> +       u64 local_wwpn = fc_host_port_name(shost);
> If CONFIG_NVME_FC is not enabled, then the u64 local_wwpn variables
> aren’t used anywhere.

Oops.  Thanks I will fix this in my V11 patch series.

/John
  

