Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C07A15FA66;
	Thu, 11 Jul 2024 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720721495; cv=none; b=iEGYzeb0OE0Hf2ASU7+EOP4GQDhtHh4mROPkRJDviJyGuldRyEYP3kUabyAAEOJ0RafLuiW+Ml5alKc+m6mzOge/BKsxuBX8q7fdO9CMlCtwdXEx66Nni9VPNEDsbD1j1ff20wi9Pb0d9j4HgqOeWGPkIRa56Q7xOj9HRhkQvkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720721495; c=relaxed/simple;
	bh=D8KXz0KQ+pzJQS4KY5WsXaRKj8NOEBdzjNRJQhwI3B0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m9W0iUjTivzpd1Z65Tt6ELoBTdvhKHcWQW4wbohKrkd/nlU7auAlSlma2tqlexreDBMGmeKNh5d2zZF+rZ3wmukXTYkvRHoxBy9avVADjrl3EmLqg0PxGQJ46Yhf8jf9qpCQEaxbAg09XshWACapSu63Woidv9rrXK/QP4XHHOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=XKTLokDu; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=XKTLokDu; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="XKTLokDu";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="XKTLokDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1720721493;
	bh=D8KXz0KQ+pzJQS4KY5WsXaRKj8NOEBdzjNRJQhwI3B0=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=XKTLokDutR8hbmQT5uAtnbZbNH1A6gbZX8Uo62VWIr9kumwsV7vFDZP8D5IcuQk60
	 igmVk9woierzQbxIRGNeeKxoeIbjUlMQrOjPDNx4P0yvBPiqgcb1CP2AGR6cc/sVKL
	 +YLjBxwT0znDdmW3w/za5xyIuaxbMD+obR+IAsrA=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8AF9612860F0;
	Thu, 11 Jul 2024 14:11:33 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id L-3pakZQG7d3; Thu, 11 Jul 2024 14:11:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1720721493;
	bh=D8KXz0KQ+pzJQS4KY5WsXaRKj8NOEBdzjNRJQhwI3B0=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=XKTLokDutR8hbmQT5uAtnbZbNH1A6gbZX8Uo62VWIr9kumwsV7vFDZP8D5IcuQk60
	 igmVk9woierzQbxIRGNeeKxoeIbjUlMQrOjPDNx4P0yvBPiqgcb1CP2AGR6cc/sVKL
	 +YLjBxwT0znDdmW3w/za5xyIuaxbMD+obR+IAsrA=
Received: from [10.106.168.49] (unknown [167.220.104.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id F213812860AA;
	Thu, 11 Jul 2024 14:11:32 -0400 (EDT)
Message-ID: <a9632309e6b5df95c7359ec9623bb1b95f764eb4.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: megaraid_sas: struct MR_HOST_DEVICE_LIST: Replace
 1-element array with flexible array
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kees Cook <kees@kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S
	 <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil
	 <chandrakanth.patil@broadcom.com>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Date: Thu, 11 Jul 2024 11:11:31 -0700
In-Reply-To: <20240711155841.work.839-kees@kernel.org>
References: <20240711155841.work.839-kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2024-07-11 at 08:58 -0700, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> struct MR_HOST_DEVICE_LIST with a modern flexible array.
> 
> One binary difference appears in megasas_host_device_list_query():
> 
>         struct MR_HOST_DEVICE_LIST *ci;
>         ...
>         ci = instance->host_device_list_buf;
>         ...
>         memset(ci, 0, sizeof(*ci));
> 
> The memset() clears only the non-flexible array fields. Looking at
> the rest of the function, this appears to be fine: firmware is using
> this region to communicate with the kernel, so it likely never made
> sense to clear the first MR_HOST_DEVICE_LIST_ENTRY.

That's not necessarily a safe assumption: older qlogic for instance
uses zeroing an entry to stop the card mailbox processing.  Looking at
the driver, I think you're right: it's only used for card to host
communication, so clearing it is irrelevant, but it could be relevant
if it were also used for host to card communication.

Regards,

James

