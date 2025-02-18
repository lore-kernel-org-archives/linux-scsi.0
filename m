Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEB618CC15;
	Tue, 18 Feb 2025 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739902307; cv=none; b=g6R3k+tMlNXnG0a6NzzRSEJNDqSU0hIAy70GR8xrRd8nQePJyHlvZvf9b3/2p7XY1YfYYFV05MP56PNZ/Hzd+JdLX5v3IYxazOx1oqJIFtLltelItPoxppf7cjSdjmGrO0BSNZU4dwM+bZiQQPC/vKfav5kBDEQEQezaTlotKW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739902307; c=relaxed/simple;
	bh=RmK+sM1fIn4q659XBikH3ksVr9Po6MXHDQIlxxHTrRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R/aLQQGc0foEMQjoHPMRELMQsHz/o9HaRvg5UWpNIU7LfwzQao13aUtSc2M1ZiTEpoDpIvJ+xjAv4EhbIX0ERozAqH90G4aPW070qRQnOEOXXOgJeeDO895oybklShN5i7YwOmUQg/AsWk0bxTApXzxGUWGoeihIalCCyRQOpoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aEuCrB1f; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aEuCrB1f"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Yy6zh36n0zm0ytf;
	Tue, 18 Feb 2025 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739902302; x=1742494303; bh=D3fg9/FhRNXoopcFC00LwGSs
	wRIqL9uglMvEe/X7NYI=; b=aEuCrB1fqMFywbjAFSjY3bzUo6y1gmcc77jH1vKN
	45oDHbzOdJ1mLUqEzOkzDws2+Z1osAzX1FCAnqgFhTlVXyqfW3pt+L8+4/Dzwk7M
	OsKMKCk0BFq/C2f1WaLoy4IJvx922+w2EKk79cF4OTzwqmZ4DI9dn0h3SoRLvpWg
	ovVmQAMv9ny5DqeL61lUULY4E3tllIfUmonrOGS0ndQVMgO0O0CKwKRTCyHAwG1B
	lHcHvSaKMKpeskyrF8Lx8uj3+R3SN/2/HPdYDgxsbm/Uo9Fk5zXlCtLEavSbG5ij
	b8vemfg4Z824EizfjF418XElz9C2hqry7owwWjYRSPma5A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hzXxISCs6VtB; Tue, 18 Feb 2025 18:11:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Yy6zX6kLyzm0ysh;
	Tue, 18 Feb 2025 18:11:35 +0000 (UTC)
Message-ID: <01bf49ea-8461-4961-bc9f-893ce59a3d2a@acm.org>
Date: Tue, 18 Feb 2025 10:11:34 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: hpsa: Remove deprecated and unnecessary
 strncpy()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Don Brace <don.brace@microchip.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>,
 David Laight <david.laight.linux@gmail.com>, storagedev@microchip.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250214114302.86001-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250214114302.86001-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 3:43 AM, Thorsten Blum wrote:
> While replacing strncpy() with strscpy(), Bart Van Assche pointed out
> that the code occurs inside sysfs write callbacks, which already uses
> NUL-terminated strings. This allows the string to be passed directly to
> sscanf() without requiring a temporary copy.
> 
> Remove the deprecated and unnecessary strncpy() and the corresponding
> local variables, and pass the buffer buf directly to sscanf().
> 
> Replace sscanf() with kstrtoint() to silence checkpatch warnings.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
