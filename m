Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCCC26CE0F
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758807625; cv=none; b=jsxBsPYY2CQs1x26kT5KPNOjEk0jhuoqgVS+RybZXn6eljRPr+W3DRGT3vN/Hj/7yye/LJlKcxAS+yh/e042Yt/uy8SiATBZuTet8Elprvpqj82WKYeT+zaZQwX5gQ0ooXD7ptlAnwmimJFc71yuXLLzV0i2l9+gDzT4LI054+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758807625; c=relaxed/simple;
	bh=MsToDH6hP+40tbkyOnlWGZFZ1tvFz3QF4jZUvbvJ12Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dSE1xXjLyj9SAQjdGLlRYSTCC3bNyG/MimkTsljjBVmknbWz1UOkcpEtFtAQ4a3va0PauUXkNRoGMPa3ArccTHQc/qdx8jUgg/01/jKqvmbej1B3+1obBXyTg8E3RnvyhuzxNLrEykxaG/qxPLlxqOA+I6FLkYX9fjZzGMsI7m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=zE6RtRID; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="zE6RtRID"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id 1hO6v1FOtaPqL1mCtvJpFc; Thu, 25 Sep 2025 13:40:23 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 1mBOvANUBFT7u1mBPvp98F; Thu, 25 Sep 2025 13:38:51 +0000
X-Authority-Analysis: v=2.4 cv=Du5W+H/+ c=1 sm=1 tr=0 ts=68d545eb
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=TDP2S4RWD7HzL5QBIXWMeQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=EiXV_-hVxRXBCySLXD0A:9 a=QEXdDO2ut3YA:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=K+YFgHQ4Teu+XFPGZnoAo5eSaI9P010gBxD5eRvHMl0=; b=zE6RtRIDyskQpB2rC8J2HUJRt3
	0rf5pvzUTlL/0cddhj0NBkyikRRNVt2mWt9BISx7pi9FSBKp8mlDTVc8m5LqSe9LCg+8N+MlsFtK0
	gDFm/JzNfnl3sVM+6C9sx8eNUOEKLYrI9FwJgBxcn/Otlmqnc7a3ka1U/EUn4Mu5dk9nXbU0UzdE+
	d16AIdF+hZSHh813AgTs6oSslctOxH8Wu170MwJiAj55HXHFDOhLFrnY64jWvXJILu21PSG7Bw96o
	fqAMce73RnLKB4GN64vNWTNSnsf0AcjorNgGQukD94upszLkA3I8zt1b2hpGVKfuDv15ti5pG7y3I
	dbI8M6sw==;
Received: from [83.214.222.209] (port=38970 helo=[192.168.1.104])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1v1mBL-00000003y5E-2EC2;
	Thu, 25 Sep 2025 08:38:47 -0500
Message-ID: <fcdb0a83-3b1c-42bd-b58b-b501cfbf27fa@embeddedor.com>
Date: Thu, 25 Sep 2025 15:38:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: qla2xxx: Fix memcpy() field-spanning write
 issue"
To: John Meneghini <jmeneghi@redhat.com>, martin.petersen@oracle.com
Cc: axboe@kernel.dk, bgurney@redhat.com, emilne@redhat.com,
 gustavoars@kernel.org, hare@suse.de, hch@lst.de, james.smart@broadcom.com,
 kbusch@kernel.org, kees@kernel.org, linux-hardening@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 njavali@marvell.com, sagi@grimberg.me
References: <yq1zfajqpec.fsf@ca-mkp.ca.oracle.com>
 <20250925130729.776904-1-jmeneghi@redhat.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20250925130729.776904-1-jmeneghi@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 83.214.222.209
X-Source-L: No
X-Exim-ID: 1v1mBL-00000003y5E-2EC2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.104]) [83.214.222.209]:38970
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHWac3ByO6uXzoTLRUaKc6KioFKqmZv/wrLP/TfAQTByQp3tHLHAfgjm+Cd33oIExUcSjME37otp6W98UEe3IcYUoGmeK7w3ks/IZnDfMKptKyqyX6m2
 Q9NmNX0kbySKxdgs3ACQGpWBAfHDZaIHFZlILx9f99o5fdNvrDbVIlDjUFTH56lZiPiI4LKaPlkCfBa0hT8RmBhMd7iMsoYCJ3Oa1/ySOSKw6HJdIThkUWxP



On 9/25/25 15:07, John Meneghini wrote:
> This reverts commit 6f4b10226b6b1e7d1ff3cdb006cf0f6da6eed71e.
> 
> We've been testing this patch and it turns out there is a significant
> bug here. This leaks memory and causes a driver hang.
> 
> Link:
> https://lore.kernel.org/linux-scsi/yq1zfajqpec.fsf@ca-mkp.ca.oracle.com/

Thanks for the report. I wonder if you have any logs or something I could
look at to figure out what's going on.

Bryan,

Could you please share how this patch[1] was tested?

Thanks
-Gustavo

[1] https://lore.kernel.org/linux-scsi/20250813200744.17975-10-bgurney@redhat.com/

