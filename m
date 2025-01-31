Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313A114C5AA
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jan 2025 19:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738352939; cv=none; b=I2Es5wM4qddNxLlAtdQXwFm+ytYkbKF2LcmmpWKEFgi11OdAfx5OZioUrbIXtzurjq6fBZlxLzfXHsjf16zUDx2wG0gRJrIlu1uOz/KqKGnUbSfkq0RQAAXFJLytvvS9pbQsuda46qW21t4ra3MkXNuTTXFz4Qe7785p9pHkss0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738352939; c=relaxed/simple;
	bh=A/lsH702vJwZ1OfbXK8wfA9R+6WLoHWWvDiF8lWt2qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BrMHjPab79Jqgn8lCG5+ft+eo8DMruwrMMqYTzqKqnnrp/yGtVMUyHOuKDHHejwYv3Ycyr0F1zIiUPxrf9qVibi65D09J9KNhpItiLUcxE61BWizdMEPeburCkUfByWrG3mAhE+yKr+Q6E6/RhqWZpkRqP2iA0oUBmfG4bwrdLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TXWcXpeD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TXWcXpeD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738352936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A/lsH702vJwZ1OfbXK8wfA9R+6WLoHWWvDiF8lWt2qs=;
	b=TXWcXpeDJbSPq9dwHe3ZgxIC7EJiT4at1ncNqg/M8qWkS4b7PbaM5QPJX3WHOzO4aACbZb
	OrzRdDnuLXIkVVlo7HSoU9oWu2llBzm5cGtny3CnoNUt+wNUQK311vtKcyHLJmCRl8yv9i
	8zdf/+FxV3/AzIBSa/Efc7XZ1+Naloo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-OhB0R1rzOIKccmNZP9ou1Q-1; Fri,
 31 Jan 2025 14:48:55 -0500
X-MC-Unique: OhB0R1rzOIKccmNZP9ou1Q-1
X-Mimecast-MFC-AGG-ID: OhB0R1rzOIKccmNZP9ou1Q
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1060E19560AB;
	Fri, 31 Jan 2025 19:48:54 +0000 (UTC)
Received: from [10.22.80.94] (unknown [10.22.80.94])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B0EAE18008F0;
	Fri, 31 Jan 2025 19:48:52 +0000 (UTC)
Message-ID: <077ae4ca-e301-4b7c-b664-4b34941048ea@redhat.com>
Date: Fri, 31 Jan 2025 14:48:51 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] scsi: st: Add sysfs file reset_blocked
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 loberman@redhat.com
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
 <20250120194925.44432-5-Kai.Makisara@kolumbus.fi>
 <84a38d69-7ee7-4faa-82c6-38db2408f823@redhat.com>
 <E86C013A-4C12-43E2-829D-7023F377A6B6@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <E86C013A-4C12-43E2-829D-7023F377A6B6@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 1/31/25 5:49 AM, "Kai Mäkisara (Kolumbus)" wrote:
> Combining the above and your suggestion, what about "position_lost_in_reset"
> or "pos_lost_in_reset"? (Whatever the name is, the user should check what
> has really happened. The name should point to the correct direction,
> but it should be short enough.)

I like it!

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

