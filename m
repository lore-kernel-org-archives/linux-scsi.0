Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F4644CADE
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932027; cv=none; b=ZWWz2kF/XQWeFAARnhPxPsQqDY2Sleq7/oa5rEnioinkuwJPsZIPSK5hTpLFt64GuTYID81aeS4TiPq8afqZVJVLVlnJsVphdivp8oK9PvhIjAvxYbCwbxXMbbD6ZIzbFn7+uswO4jTZ/8MBKHerR9BtMEL5abCfs5VgWRsCK0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932027; c=relaxed/simple;
	bh=Trj2B0C0vhyuuxG7vqzXl/HLWte8qR1IqFFOF3ZZe0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pv7+ksN40rT+0oHB9dvOl6wFERqq2E0JuKTCnJXKIMAEyEPNMB8NFU/3FOBVxe/iuKYG2De2MItayy8rgiZLq3OrM1wZ9osxv79M+bpc6CJNmBfGxD8E3skhWx0jPI03304HCWgv03I9BHF+4RchyJPUOQk9WYw0v6sSp6VnCuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ElDD962R; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ElDD962R"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dwZqY0WXbz1XM0ns;
	Tue, 20 Jan 2026 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768932023; x=1771524024; bh=4YrbLo9R/1vV9KkIgKQqYztb
	OuhTf+UrYGwLrKl3pSo=; b=ElDD962RqkdZGEY3PfIIpeTIgZmzNW1EelSrbIsm
	iS+xG0WPs+yNRWEgXcNLudGto/9CNmkF7EmugHP+4abSPjVJuV+bU74Pv3vQwEZn
	eRF8+I/y0lurKizWO1LCHK1w8e/wrXI/ZFSg+s6pdUQv5HM3eW6w6hgd5qETi2dg
	Lz2OglwFFocfslMVZvVtb4tFH85L4yP/yLHGVVM1xCCvnmVQubpuAFtWKIJ5oro5
	ul/4niZCUEKoOdG+LvEgG9COw6mSCNQ5XWic+8wlLBx/6Bpp0uSJDKdDMA8RXY9H
	YYJ0vFUrn0FtrTMxJKkFbmk/R3TWCBEWo1nPePa1zuoipg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gRdspKV7TBcW; Tue, 20 Jan 2026 18:00:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dwZqV3bs7z1XM0nq;
	Tue, 20 Jan 2026 18:00:21 +0000 (UTC)
Message-ID: <03cfe069-fa2d-42c9-bb29-5bbee63f3e6e@acm.org>
Date: Tue, 20 Jan 2026 10:00:21 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Change the return type of the .queuecommand()
 callback
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
References: <20260115210357.2501991-1-bvanassche@acm.org>
 <yq1ecnoj1wr.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1ecnoj1wr.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 1/16/26 8:32 PM, Martin K. Petersen wrote:
> In file included from drivers/scsi/pcmcia/aha152x_core.c:3:
> ./drivers/scsi/aha152x.c:927:28: error: return type is an incomplete ty=
pe
>    927 | static enum scsi_qc_status aha152x_internal_queue(struct scsi_=
cmnd *SCpnt,
>        |                            ^~~~~~~~~~~~~~~~~~~~~~
> In file included from ./drivers/scsi/aha152x.c:247:
> ./drivers/scsi/aha152x.c: In function =E2=80=98aha152x_internal_queue=E2=
=80=99:
> ./include/scsi/scsi.h:111:34: error: =E2=80=98return=E2=80=99 with a va=
lue, in function returning void [-Wreturn-mismatch]
> [...]

Hi Martin,

Thanks for having reported this. Unfortunately I haven't been able to
reproduce this build failure. My script for rebuilding all SCSI drivers
builds the PCMCIA AHA152X driver fine for the x86-32 architecture
(https://github.com/bvanassche/build-scsi-drivers). Can you please share
the kernel configuration file and the architecture for which the above
build failure has been observed?

Thanks,

Bart.


