Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4C217CA0E
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 23:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358035; cv=none; b=TjB+9G/50GhIoJGb5XT4LmmsXEX/ZH4vqRHq9ThhqJTbqFmyIEh4HKFvmt4iZeSQRS78209cZsYkaaIIQiQtcZ2yk4zBYjN0jfQSIGv8SxZNVeNd54IthvT+Dgizm/99fAs1AOqM4mLtwY+jt7xITk17IooUIkE5fl3UiNWUpjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358035; c=relaxed/simple;
	bh=MZiZsle9fXRDGVCUOjJ7Ze1U/N6GrHIKKuOpUBETtSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Mm+cw1V9CZH7JP8XMtCK1DyE9Oy2U1Gn4Q7zgEVK62wGYrOpOcwVOYya9Ml9sjuNKp4wldL0sORPVwAbpdzpUjgJ/Q40IYdbGLooKR7KEJXqP1bYDnLD8H/03GhDlbrpf995qcnoJzlq1N/XoaSGqN/ljLLxGR5WOGVMn7ZlR4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tXGOKVOa; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tXGOKVOa"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W81FY0H5Qz6CmQyM;
	Tue, 25 Jun 2024 23:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719358032; x=1721950033; bh=MZiZsle9fXRDGVCUOjJ7Ze1U
	/N6GrHIKKuOpUBETtSE=; b=tXGOKVOaXXIjcZ9Qvb0QshsQH9eAYYQecgGPiN1v
	TVaQaCXvcY325K6bXgvv6mYjV4g/VWxrZAO71ERoAiqmOMCEhg1ptdCHHEW/L/yk
	eRUZ/cCWFSk7+3xK5dkpYdTjpF8AT7pfx/z59ER84GT+S9GX3+AwDUHhntDlNBxI
	P6BgS5iOSs+gaOod1c6VaBmK+4gmUge7ehdizs79s91/CsPdYI/r9PMnxQloz1V4
	zz7OwoTSH5XWI/Qo39NRoPAjZosgQU6epsmF/e+0VNRJm3jzeW/ZeT3BJqAwrKjR
	FLzDs/QvcL7o9B6ez1XsmbISC1RXCWYtBDBuTvQi3OOivw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EEqh1aBnpIrh; Tue, 25 Jun 2024 23:27:12 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W81FW62gMz6CmR43;
	Tue, 25 Jun 2024 23:27:11 +0000 (UTC)
Message-ID: <1ac9f910-c361-44eb-9fa8-d587a8796980@acm.org>
Date: Tue, 25 Jun 2024 16:27:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: lpfc: Simplify minimum value calculations in
 lpfc_init and lpfc_nvme
To: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>, linux-scsi@vger.kernel.org
References: <20240625165643.1310399-1-prabhakar.pujeri@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240625165643.1310399-1-prabhakar.pujeri@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/24 9:56 AM, Prabhakar Pujeri wrote:
> This patch simplifies the calculation of minimum values in the
> lpfc_sli4_driver_resource_setup and lpfc_nvme_prep_io_cmd functions
> by using the min macro. This change improves code readability and
> maintainability.

How has this patch been generated? If it has been generated with a
Coccinelle script, please include that script in the patch description.

Bart.
