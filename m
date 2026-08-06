Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB5E341ABB;
	Thu,  6 Aug 2026 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786036536; cv=none; b=tXdIR6HoAvX9RQVmNBc8PY/Imyxaui2SbnCvFZ7EF7f/mRCSjiNHWLXJSRvT7kYdskBREwA0psSAkZSC4PLX2KHfTpwEsO0jlFyBIO6CqVJnx/6pCdUPHJ0/Q7NFAJ1iUZ/tI6IxjxncUP0BDsqvLD+EvU3N0cf9XYWvaiqdNPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786036536; c=relaxed/simple;
	bh=znK2/4lOEkttR/ynwvj8ugpg+t3k+UoZj77xbbcF6Rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PCd4bFEDv0Kwkhfm++hyvDTjr9JHa0ZVix07ePd5OUz0/PHFm2aHt5jLqZB+RFcmNzsGDUDPuybEHlXomHgrzJap0AKOZkJ3hfUwsBjrBlkb/j6ZXMszoPzbJl6Mx509BtLDMZ7LPQUe7C0AlVyVAK3dDnsAxC9xDL/8Nqtp37Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fWfd1pY8; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fWfd1pY8"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hGDSQ5ZWJz1XM6JY;
	Thu,  6 Aug 2026 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786036529; x=1788628530; bh=oZXhusvsNiVTw2LNWdGhAncH
	7EziQoLQLzjFcfA1dQk=; b=fWfd1pY8EngREmKrsn1S8hNEj7f0sqM7rlcwqbUk
	Grko2xpUnW/70erJE/bEDvBjLhZV81wgTuWUyPjvAx1h5f5roRtsMCAllwG1Ol+8
	/ZTQ142f+jOnBM88ZLCYthJLY6Yupea0wr6pZp5+GMDiGlfif6xz9YiVqdlQ6QOB
	wM+Wf9hEBJzzfolsv8WfK5/I1OIHZO7nuE4d5Q+Ut2oUZ97hDVIETpVTIq7NZH1e
	rJij7FW+iu+cRjT4Z3juRluW+YAfZ9CJVmMXM9H4yVUAvZz861nKdtW2s1vsdX8n
	XZdg3xAS6j5VwgUP6NC02L3/WPwlqI+4j6YwFFEonqWKDw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fKxYKzoNdV_x; Thu,  6 Aug 2026 17:15:29 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hGDSG5l6bz1XM31H;
	Thu,  6 Aug 2026 17:15:26 +0000 (UTC)
Message-ID: <9d9092bc-6bf0-4afb-9d1a-5ee16c9c501e@acm.org>
Date: Thu, 6 Aug 2026 10:15:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Drop Scsi_Host.default_lock
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
 John Garry <john.garry@linux.dev>
References: <20260806113958.3127942-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260806113958.3127942-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/26 4:39 AM, John Garry wrote:
 > Getting the address of embedded host_lock structure just requires adding
 > a fixed offset value to the shost pointer. However, getting the value of
 > the host_lock pointer requires loading from a fixed offset to the shost
 > pointer. The latter should be very slightly slower, which is relevant as
 > this lock is used a lot throughout the core code and drivers.

Hmm ... SCSI drivers for which performance matters shouldn't use the 
SCSI host lock in their hot path.

 > @Bart, Can you kindly build test this? s390 and sh were causing some 
build
 > issues for me. Thanks

This patch passes my build tests, but an update for the references to
default_lock in the Documentation/ directory is missing.

Otherwise this patch looks good to me. So with or without the
Documentation/ update, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
