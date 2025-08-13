Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA947260D
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097589; cv=none; b=rgQmzCDGFW38V4f/ttrhEgxUcJe0IZ0upg35QGKst9QdbpLzDfpcia3SlMF/5EL+cr39cC6CvHMPZ7Voiyh3fMbeN2b+lJen4f58jEMha5iDLafSHqlevNOenpfXFSRNLVMO0BmcnxKjhtFksKSIZvytlxVChe+GHBRTAe9/Rwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097589; c=relaxed/simple;
	bh=qDMRHNVvRLDBWH1dmcHoB3W/+uUST5LqQrVmiX5Av68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dBVhHL/PJSRJDCNAn6DEhWZCzW4XKVq2xtlmnX3iCmd7yrRXxfTrP3cPonSFSup2umEzbd1V4CoNpIgei3B8dIuHUU23G1YvSzKsrh30YqGVROA3R2PtgO4Bbb8lA7QGhCk1NplRfpA0oZlG51Z139l2NK9gqQKA8CYIlza/FDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BlRoTJ/h; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BlRoTJ/h"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c2BXf3y0NzlvWj8;
	Wed, 13 Aug 2025 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755097585; x=1757689586; bh=x9HRLuGzYN9xXFUEQ9mNaBQt
	dTpsHQMEzxVRswydgnM=; b=BlRoTJ/hVPVtpAREr3ATIxZNCwYjperOPjGgGsaW
	S80ty0GN/7bwL8cUe20GIiYN+YHLnNSmV8VnI+rxK2GNTlqQniVUZW1tLXbFGTV4
	TIYne9+lfhbRJtuQTKFLhX2MHHZkzF39etizB2Vpz5zROznUDtFgbhfGv/+Cix6m
	rGynyMX5jZ9gpwQR+GEGI0eXzQh0m+bDDBy5eUoTJX3+K/4n4tpBk0mx8KL3BWwF
	rBOh5l/3mdE08mMi4aXxTCPVAgzyhZnKOUhn8JN3jmgd6Cdbx+BlSKz/Yi4K2ThN
	INNRVVEzZ4uBrhtZX4T/4JGGkYjLiQ56PZJKJ4Y/DQXRiQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fKPq8ZGh6e9c; Wed, 13 Aug 2025 15:06:25 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c2BXZ5rl7zlgqy6;
	Wed, 13 Aug 2025 15:06:21 +0000 (UTC)
Message-ID: <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
Date: Wed, 13 Aug 2025 08:06:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250811173634.514041-1-bvanassche@acm.org>
 <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/25 2:49 AM, John Garry wrote:
> what is the baseline for this series? It does not apply to v6.17-rc1 or 
> mkp-scsi 6.18 queue.

Hi John,

The baseline for this series is Martin's mkp-scsi/for-next branch with
this patch series applied on top: "[PATCH 0/4] UFS driver bug fixes"
(https://lore.kernel.org/linux-scsi/20250811154711.394297-1-bvanassche@acm.org/).

See also https://github.com/bvanassche/linux/tree/ufs-lrbp-as-priv-data.

Thanks,

Bart.
