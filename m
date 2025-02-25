Received: from 002.mia.mailroute.net (002.mia.mailroute.net [199.89.3.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B668DF59;
	Tue, 25 Feb 2025 20:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740516855; cv=none; b=Lu9hjCI2pqjw9OA+PsBlO+MZhlqkrkuAnpb/pYl2bfBiMu3PoFEE5MtnD46s1k+23T7ACaL7dTm/qos+cgipAnqJpB/1vxC9eITKqSrEoSTPXPZ+BGO5YVznGlEO+PqX40vz5fFszSABy9pAEyrwfGxk48BWAyYHYWLwA9GBmPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740516855; c=relaxed/simple;
	bh=j2hSm2QLiEOVRpX5JUZPeCRyeTIcZJd+VXnUgGlRuTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dv0oyqS6nLl7DvbJOB60kj8FDiilSXzNiBhNJrVE8+2y8P6Rwdmc94RrKyOSXEIFoQzTbIWIQEbZw9s7WuzQbZxo+a8t0NydNeibMQ12RyYN4yo3cua1apOhRjf9kva6GjOx2CEVk3xiRkEmjTnrzIPkrgBv6Cyc/IPY0InHvm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=STurWg5u; arc=none smtp.client-ip=199.89.3.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="STurWg5u"
Received: from localhost (localhost [127.0.0.1])
	by 002.mia.mailroute.net (Postfix) with ESMTP id 4Z2VFp0fVXzm99Q0;
	Tue, 25 Feb 2025 20:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740516844; x=1743108845; bh=r0d7msr0P1Uqc0s7qkp17urM
	K2JA7UQCFlXZAxWSBNQ=; b=STurWg5uWy/gugOhVSX36XlTUucaqH91PwFlnKo6
	/eE1lzvCwI0CIUEbki8hP+Bk3lSdXJv0Thxdi6H9KFqtAmOrum7t3SsAFm2Hhg5u
	K2Z4CNkIn8BddzcM/7UxZZF6ReHcGBDQ8AgcrKk0z1Y4h+5r79FhzB+jPzHGula1
	rhtOT7pyI4gePvOuRgg98Kk+8H1ewgDQC6rWtVzecJQmMGgjquEo3BX6Bvcz6qua
	0G4Ixv1cTieUKXEXgaeSJ41POEvY+UnEfCozObDJf0nI1wEpmwpt3ohs3PFogJND
	nK/n59XouqNwJ2NACvn2UB050RM1bYGwlHcOHsGwfw0mmQ==
X-Virus-Scanned: by MailRoute
Received: from 002.mia.mailroute.net ([127.0.0.1])
 by localhost (002.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iuL_-AOuM5LA; Tue, 25 Feb 2025 20:54:04 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 002.mia.mailroute.net (Postfix) with ESMTPSA id 4Z2VFk4cqZzlvRmj;
	Tue, 25 Feb 2025 20:54:02 +0000 (UTC)
Message-ID: <3b6cca0d-7aa5-43b6-8f4a-429f17558121@acm.org>
Date: Tue, 25 Feb 2025 12:54:01 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks
 with "use_192_bytes_for_3f" attribute
To: WangYuli <wangyuli@uniontech.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stern@rowland.harvard.edu, zhanjun@uniontech.com, niecheng1@uniontech.com,
 guanwentao@uniontech.com, chenlinxuan@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
References: <ADB8844D07D40320+20250224034832.40529-1-wangyuli@uniontech.com>
 <ad1ba59a-3a67-4b3c-a05d-c4e56405cc19@acm.org>
 <0A01BD2F489C764A+647ab6a7-35e5-4aa4-b8d1-c177be1724c6@uniontech.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0A01BD2F489C764A+647ab6a7-35e5-4aa4-b8d1-c177be1724c6@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/25/25 5:11 AM, WangYuli wrote:
> Disks have the attribute use_192_bytes_for_3f, which means that disks
 > only accept MODE SENSE transfer lengths of 192 bytes>
> However, when lshw sends MODE SENSE command to disks,
> use_192_bytes_for_3f will not be considered, which will cause some
> disks with use_192_bytes_for_3f to be unusable
> 
> To solve this problem, it is necessary to determine whether the
> device has the use_192_bytes_for_3f attribute at the scsi level. If
> the device has use_192_bytes_for_3f, when lshw or other applications
 > send MODE SENSE command through ioctl, the command with the data
 > length field of 0xff needs to be filtered out to avoid device
 > abnormality.
Has it been considered to truncate the MODE SENSE buffer to 192 bytes
instead of rejecting the MODE SENSE command?

Thanks,

Bart.
