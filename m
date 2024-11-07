Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41D9212EF9;
	Thu,  7 Nov 2024 14:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730989979; cv=none; b=HXnlPYZBTemnT/j/Dq7eRA8E9ufUFO3XHGxZ+46gwyrv8tOLRwhqEZ6E62/w2rjLOLuOusX0DgpGZ87XuWocm8MxsVK/R2N583YAfW129uL282RHIzvImO1XoTvIIso0ywaryCcenKGneTtthMJnN6RqNUhz7/+87+BR5126bzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730989979; c=relaxed/simple;
	bh=Z3+zd1AF7jv9N9TXPDOkFMx7gdtgHAKbmQWI6UUUfFQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bwGMJgIwbTQejymh2NmwqPxWuF2AcL+wl8mj0uzr4gD4nn3vmac+aDymfFQ2nG+UlY68k4iG1SnccPdqVBYeBP/Djgr4zmU5o13DoAQtWJKavKHDqjJJXxDebFMbC3oW4XdBXBeqLMd+YW5hmV3Ap6zdHQmNmWRSZ6lir9jXNkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=FchbBPjb; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=FchbBPjb; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="FchbBPjb";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="FchbBPjb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1730989976;
	bh=Z3+zd1AF7jv9N9TXPDOkFMx7gdtgHAKbmQWI6UUUfFQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=FchbBPjbrglgS90uDIo2w9cLyce0tEWEyCoPB5dLU3PLbHXqDqPIucHVkNSqlm3Sh
	 /x3bXXbsxWytiGdcqT5KZq4Nb54WhtAoAV0Zm1zUIdEem/MCfFd5d7xKHf3sQcR5WO
	 oAJI+dMpphFgj9t+R5St2oAE8moDSznKAYFHHbh0=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 815961286F67;
	Thu, 07 Nov 2024 09:32:56 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id g_y-6ENM4dOl; Thu,  7 Nov 2024 09:32:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1730989976;
	bh=Z3+zd1AF7jv9N9TXPDOkFMx7gdtgHAKbmQWI6UUUfFQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=FchbBPjbrglgS90uDIo2w9cLyce0tEWEyCoPB5dLU3PLbHXqDqPIucHVkNSqlm3Sh
	 /x3bXXbsxWytiGdcqT5KZq4Nb54WhtAoAV0Zm1zUIdEem/MCfFd5d7xKHf3sQcR5WO
	 oAJI+dMpphFgj9t+R5St2oAE8moDSznKAYFHHbh0=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id A19401286F64;
	Thu, 07 Nov 2024 09:32:55 -0500 (EST)
Message-ID: <646143dcb1fc2abe8b53172bb8ac24fe54246dda.camel@HansenPartnership.com>
Subject: Re: [PATCH v2] [SCSI] esas2r: fix possible array out-of-bounds
 caused by bad DMA value in esas2r_process_vda_ioctl()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Qiu-ji Chen <chenqiuji666@gmail.com>, linuxdrivers@attotech.com, 
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, stable@vger.kernel.org
Date: Thu, 07 Nov 2024 09:32:52 -0500
In-Reply-To: <20241107141647.760771-1-chenqiuji666@gmail.com>
References: <20241107141647.760771-1-chenqiuji666@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-11-07 at 22:16 +0800, Qiu-ji Chen wrote:
> In line 1854 of the file esas2r_ioctl.c, the function 
> esas2r_process_vda_ioctl() is called with the parameter vi being
> assigned the value of a->vda_buffer. On line 1892, a->vda_buffer is
> stored in DMA memory with the statement a->vda_buffer =
> dma_alloc_coherent(&a->pcid->dev, ..., indicating that the 
> parameter vi passed to the function is also stored in DMA memory.
> This suggests that the parameter vi could be altered at any time by
> malicious hardware.

Absent a specific threat (such as TPM with an interposer) this isn't a
vector the kernel protects against (we have to believe what hardware
says unless we know it to be specifically buggy about something). 
However, even supposing a PCI Interposer were considered a threat, the
answer now is hardware based: SPDM/PCI-IDE.

Regards,

James

