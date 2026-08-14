Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341083D45E6
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786720220; cv=none; b=ouSIbVK/atZ11xXnHqODGTrP6TlozSX2EELCmJhhZZtrknEt/WoF1baC0EITPPxjpOr8Zb+w5iNwxK+xgy+bBRm72rlqF9hm0YwgFW3x+wQTkPpPpIcwUZCSPYRDivPxyj3sWSgSVyebioRkBXpMHIUUH46y/U8upFOJi2iqaew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786720220; c=relaxed/simple;
	bh=aY70QCxUdQ0hzm74LlvRBUgc9sJqiCBiI8yiOJz0QD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OTCHRcYZ2eiDxxVwRETD1/y0o2N8hmV2w+520Wk1PZAhGldnzeIv3Sa8X+ckfNHl74pUHBBQ2RQlaVloVfPxbQh3IY6wGnP4FdUOdbeZNj4MNn0qrAnoeGJ8f3oU/V+o4yH0cynxa84c00G02bHbbkhR53t8WHhThsB0gA4HdW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GBULrIvt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBULrIvt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786720217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1GRrOlyN9nkOUdimeoCQpzY7og1lchpuM501N4iN80=;
	b=GBULrIvt6FT9uNqWQX0Mk1mncAuV2m6qhWzxFBETIDb6cBJ5CN1h+5yfVMQ/JafFabtMLj
	RnrrwTFa6NcHT+rrfL82+pl8oPdrNsp1pKCe/juzMe/2hOtKCBDWboWf4alBq7PcPSv1Xo
	zid35UZmRPNw6GwhwpdZgnDbClzP6Tg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-DvatqclWMhiECNPA0A51Jg-1; Fri,
 14 Aug 2026 11:10:13 -0400
X-MC-Unique: DvatqclWMhiECNPA0A51Jg-1
X-Mimecast-MFC-AGG-ID: DvatqclWMhiECNPA0A51Jg_1786720212
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 969F8195608D;
	Fri, 14 Aug 2026 15:10:11 +0000 (UTC)
Received: from [10.22.64.139] (unknown [10.22.64.139])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 62CE830001A2;
	Fri, 14 Aug 2026 15:10:09 +0000 (UTC)
Message-ID: <3ca229d2-aaa3-46e0-8714-21cd67810153@redhat.com>
Date: Fri, 14 Aug 2026 11:10:08 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH blktests 2/2] nvme/070: Test multipath and marginal ports
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Jesse Taube <jtaubepe@redhat.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 Daniel Wagner <dwagner@suse.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20260812174503.3705830-1-jtaubepe@redhat.com>
 <20260812174503.3705830-3-jtaubepe@redhat.com> <an78AkXI1SUHXBwg@shinmob>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <an78AkXI1SUHXBwg@shinmob>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 8/14/26 07:47, Shin'ichiro Kawasaki wrote:
> On Aug 12, 2026 / 13:45, Jesse Taube wrote:
>> Add tests/nvme/070 to test various multipath and marginal port
>> scenarios, while confirming the port useage and state. This test is
>> intended to emulate receiving an FPIN event in a multipath environment.
> 
> The test contents are comprehensive, which looks good to me. 
>>
>> Suggested-by: John Meneghini <jmeneghi@redhat.com>

Please remove the above line.

>> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>

Co-authored-by: John Menehgini <jmeneghi@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>

I've tested these patches and they work.

Tested-by: John Meneghini <jmeneghi@redhat.com>

Note: These patches require the kernel changes introduced by the "FPIN Link integrity handling" patches[1],
and they should not be merged until the kernel patches are merged.

[1] https://lore.kernel.org/linux-scsi/20260814063616.GA9231@lst.de/T/#m1e8c728cf2dcdfd70d1b50a2fc2f278ea0832c36


>> diff --git a/tests/nvme/070 b/tests/nvme/070
>> new file mode 100755
>> index 0000000..a8002f8
>> --- /dev/null
>> +++ b/tests/nvme/070
>> @@ -0,0 +1,521 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-3.0+
>> +# Copyright (C) 2024 John Meneghini <jmeneghi@redhat.com>
> 
> This patch's author is Jesse, which looks inconstent with the copyright above.
> Also, please reconfirm the copyright year 2024. Should it be "2026" or

Yes, this is because the original version of this script was authored by me.

Jesse took my first version and greatly improved it.  She got it working.
> 
> When I ran this test case on the kernel without the patch series
> "nvme-fc: FPIN link integrity handling", this test case just failed.
> I think it should be skipped if the kernel does not have set_marginal_rport
> sysfs attribute. I suggest to add the check below:

Good suggestion.

>         if [[ ! -w /sys/class/fcloop/ctl/set_marginal_rport ]]; then
>                 SKIP_REASONS+=("fcloop does not support set_marginal_rport")
>                 return 1
>         fi
> 

/John


