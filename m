Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260782E9EBA
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2025 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752245618; cv=none; b=dWJVV/mKLPU1txWNFogOl1HuiN0YDbUHsh/FF8dwSYXizWbBXpsucKLgLrcfkpG87OdjijcUeMekMBV0pH1n8SND7fJxFvpo+Bh49SFpliHk5GcK8+StJEVZKmNpv31v3mQUAMUg/Wee3cD8qY6MPrIXsK2IckD+RFHewaQog8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752245618; c=relaxed/simple;
	bh=F3ARErHmMmdAFOGWG+QlczUzdcSNO3JkAl/vm3E4rfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rsi3jfcvxqwh48R14RaO9gnwhFdy7gzei+xZ7KTqI1Y+h+vdtE6RJx1gP/sHu/TEZ0prR1Cm9YnLDX1tpBXHonrP3Guq8kzqhIpc2cy46wJhBhgviKc6lEtDhaReJp2JxUzJPEqPTRX58fOZq2CjsP8z+xHAtxuifPTK3BOEWhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L+sLVqy+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+sLVqy+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752245616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0IyO+0PgVVEuhA/+ft9xr/Zox0Dy2nwPZuB71xE9fB8=;
	b=L+sLVqy+C2OMALvIIOIe6x+3XRkqdp7nDR7Ysy2WyWd8OCMNPO/J7ih/oaLqR0R5MMGZqA
	F/oQnM7Nv9ls/wrlLVqncbphEHe6zG9cJy4JMZHsZmZt4ArXLx3hGYYUMXpA7ksQmuoLdY
	Xs19ZqgQ+/ZMlxbNS2eaABKJLbEfMuk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-RffQQwO2OBOf4hwzgpwDVg-1; Fri,
 11 Jul 2025 10:53:33 -0400
X-MC-Unique: RffQQwO2OBOf4hwzgpwDVg-1
X-Mimecast-MFC-AGG-ID: RffQQwO2OBOf4hwzgpwDVg_1752245611
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E9F318011CD;
	Fri, 11 Jul 2025 14:53:29 +0000 (UTC)
Received: from [10.22.88.94] (unknown [10.22.88.94])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7ACE19560A3;
	Fri, 11 Jul 2025 14:53:24 +0000 (UTC)
Message-ID: <694235ed-f714-41b1-b9d2-46a314d6a97f@redhat.com>
Date: Fri, 11 Jul 2025 10:53:23 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/8] nvme-multipath: queue-depth support for marginal
 paths
To: Muneendra Kumar <muneendra.kumar@broadcom.com>, bgurney@redhat.com
Cc: axboe@kernel.dk, dick.kennedy@broadcom.com, hare@suse.de, hch@lst.de,
 james.smart@broadcom.com, kbusch@kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, njavali@marvell.com, sagi@grimberg.me,
 muneendra737@gmail.com
References: <20250624202020.42612-1-bgurney@redhat.com>
 <20250711025925.1831977-1-muneendra.kumar@broadcom.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250711025925.1831977-1-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40


On 7/10/25 10:59 PM, Muneendra Kumar wrote:
> Correct me if iam wrong.
>>> . In the case where
>>> all paths are marginal and no optimized or non-optimized path is
>>> found, we fall back to __nvme_find_path which selects the best marginal path
> 
> With the current patch __nvme_find_path will allways picks the path from non-optimized path ?

Not necessarily. I think it all comes down the this code:

                switch (ns->ana_state) {
                 case NVME_ANA_OPTIMIZED:
                         if (!nvme_ctrl_is_marginal(ns->ctrl)) {
                                 if (distance < found_distance) {
                                         found_distance = distance;
                                         found = ns;
                                 }
                                 break;
                         }
                         fallthrough;
                 case NVME_ANA_NONOPTIMIZED:
                         if (distance < fallback_distance) {
                                 fallback_distance = distance;
                                 fallback = ns;
                         }
                         break;

Any NVME_ANA_OPTIMIZED path that is marginal becomes a part of the fallback ns algorithm.

In the case where there is at least one NVME_ANA_OPTIMIZED path, it works correctly.  You will always find the NVME_ANA_OPTIMIZED
path.  In the case there there are no NVME_ANA_OPTIMIZED paths it turns in to kind of a crap shoot. You end up with the first fallback
ns that's found.  That could be an NVME_ANA_OPTIMIZED path or an NVME_ANA_NONOPTIMIZED path.  It all depends upon how the head->list is
sorted and if there are any disabled paths.

In our testing I've seen that this sometimes selects the NVME_ANA_OPTIMIZED path and sometimes the NVME_ANA_NONOPTIMIZED path.

In the simple test case, when the first two paths are optimized, and only one is marginal, this algorithm always selects the NVME_ANA_NONOPTIMIZED path.

It's only the more complicated test when all NVME_ANA_NONOPTIMIZED paths are marginal that I see some unpredictability.

/John


