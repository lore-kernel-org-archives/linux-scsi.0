Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183B221F15;
	Mon,  9 Feb 2026 21:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770672985; cv=none; b=Vi4kv1zu2xOc3PYuX31Z4MgIF7gGYkn4kCrGw6GC7SO21pnngYiDK7uI7VCTWPJN0pmJweUyc2CwINUBdAR52GRTOJeJltWYOl0Zi7zHcw1iQ5XJ+Hws+VGQgGKcmhOL2J7TMEbF7bYsak0U+WMo1Tbae7zO+WyvRSEu32/lZnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770672985; c=relaxed/simple;
	bh=jTpHRWXLKADaCcdOS0gmLU82/TZfD7343vnIweWl5Dw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r292etXqM9NgyLdkpHSPYu9vgaIT2kE3xIwgcH+xiepryD2fkuc3/wsz798nCQuW+Nyq9yXSOl2Va/OCfnqaV5B6SHzOyX1tR9AC6k/8qmP5jxfVmHhxG4+9yCe/sK6HAEY/OOYyF3GWPAXG0Glv944gUte2isP+0iIpXDHAvnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xoc7jq88; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xoc7jq88"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f8ygX30ymzlqk1x;
	Mon,  9 Feb 2026 21:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1770672982; x=1773264983; bh=+ceHgo4rHLsoobHje1I4r3rR
	aYRInZ5qSR48Qykdvy4=; b=xoc7jq883cAxyb8Qx3k362oXMPsE8QtWsxubxit+
	dhZoDNAnsDjqw7mxCFmAftDIayzHF697uvYQlqaZOfTfW2jMH4LvZwv1Ns3bw9in
	wCNpzKM6JAboki+fBGx7Ol/kuGLCKzfGPAZt8hNX7Gojzk+43J6MAjXcyXyLG9F3
	xN2Z0MZjeDAn6ARRdv0l1tp2kwnd6rD+k4LsdlhAlY1XOgkzqFUGs6TiCEZc/hLW
	SyeO0qmejsCR1DNn2SpGtbTAmDPc37lwhOGQa0VMhDvyBiK+ammncULr/4TvjKTk
	mw13iZmKK9K0iLJX778zB+X3P+Y4keZHbOxxuOdWpklOxg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pjzuwakazej5; Mon,  9 Feb 2026 21:36:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f8ygT55lfzlqk3L;
	Mon,  9 Feb 2026 21:36:21 +0000 (UTC)
Message-ID: <c9ed39db-810b-482f-9b68-803cf34554b6@acm.org>
Date: Mon, 9 Feb 2026 13:36:20 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
To: Igor Pylypiv <ipylypiv@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260209212151.342151-1-ipylypiv@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260209212151.342151-1-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/9/26 1:21 PM, Igor Pylypiv wrote:
> Add a 'serial' sysfs attribute for SCSI and SATA devices. This attribute
> exposes the Unit Serial Number, which is derived from the Device
> Identification Vital Product Data (VPD) page 0x80.
> 
> Whitespace is stripped from the retrieved serial number to handle
> the different alignment (right-aligned for SCSI, potentially
> left-aligned for SATA). As noted in SAT-5 10.5.3, "Although SPC-5 defines
> the PRODUCT SERIAL NUMBER field as right-aligned, ACS-5 does not require
> its SERIAL NUMBER field to be right-aligned. Therefore, right-alignment
> of the PRODUCT SERIAL NUMBER field for the translation is not assured."
> 
> This attribute is used by tools such as lsblk to display the serial
> number of block devices.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
