Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA86405C48;
	Wed, 23 Sep 2026 17:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182959; cv=none; b=RbA21x0oTA93PUifX9jxiIwwBAyShSD8HrlyXFLr5eAayuMcR7vyBJUbF1V5RQqt8DFMByUzvvgT8uHJw2wzD7Z5sxY2TznSlRQH7k9ABi2e3u+97N9/mFCmL3qTnHlz+T0cNz0wMpbWM7iUIBl7yy/TYjLNO2ZDMsdNjjcpc6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182959; c=relaxed/simple;
	bh=CiZcvTp4q6wH+BFb6UpEonI9xx1+tZM/W29dmbDZ/pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHGz/LYFPhFwxRtN8mEdMGFuhnWBtCQ/Dh3U9bmKkD/mTA66hCv6+XZCWoVxkaiu+shdYWbZbP/pwK4jKJfKcJehAVByevRMdvIPRqfhj3BxnHOOUem/DIDUkwdfNu1nrK+yPaqdAy7Uu7qBRzweu6oqIL+ahTEhkKwv6gjiBcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vj7eoB/o; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vj7eoB/o"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hqjvJ4r4cz1XM5kW;
	Wed, 23 Sep 2026 17:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790182950; x=1792774951; bh=KODQ/iyEJtmKrlLKC5Skjq6V
	/sYOTxKM/rK6b7Jk3so=; b=vj7eoB/o8g2DjS2hqJMHbo7uz1WfJpOhqcFA+U+t
	U+pMokluh22Myl64aICdS3xjay5qf4ya/FdqI2r/HvXgWZnDRVjGzxl2DQ7MP04A
	g+KsTQp1sSpCuAJeDWiwuUnvJFsGts6WB30QZTw4r1LetKFhOut4V08ghReIqWG/
	n2S6QSXOkrAUnBSxO3fSgDNhciRfF90fcLUgoFEfVr/nGy0qvw07KO6wDP+e/5U2
	Q7ahwC3Gc4a3xeSQcGOLm4LHIwC09ZgXNuBWF24KTx4tfJ/PEkJs13GD+sYB+e2K
	cSOBlaJ3Exj4CDDl8HSdQ4qieJjK/H93j8V1wmByTotB/Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HpdO0jrWo_Ja; Wed, 23 Sep 2026 17:02:30 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hqjv66TYdz1XM4Sx;
	Wed, 23 Sep 2026 17:02:26 +0000 (UTC)
Message-ID: <eac2f886-61af-4b3e-b237-88d59cc4eab3@acm.org>
Date: Wed, 23 Sep 2026 10:02:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
To: Stanley Jhu <stanleyjhu@google.com>, Peter Wang <peter.wang@mediatek.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
 linux-kernel@vger.kernel.org
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
 <20260918143809.3034592-1-stanleyjhu@google.com>
 <20260918143809.3034592-3-stanleyjhu@google.com>
 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
 <20260920135014.3528082-1-stanleyjhu@google.com>
 <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
 <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
 <df31eb82-7211-415a-9ec1-53ecbc3e39b0@acm.org>
 <f116f82d28f7af4cfca76adf5cff6093fdf393a2.camel@mediatek.com>
 <CAE14pdfbxX7BWzKg9z7ytB9rZPAp40ipXk8NPOdAp2Jv7eq6Xw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAE14pdfbxX7BWzKg9z7ytB9rZPAp40ipXk8NPOdAp2Jv7eq6Xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/26 4:18 AM, Stanley Jhu wrote:
> Would DID_RESET be a better fit after a controller reset (including
> ufshcd_eh_timed_out() right after ufshcd_link_recovery()), similar
> to mpi3mr_flush_scmd() and mpt3sas's _scsih_flush_running_cmds()?
> It reports what the driver actually knows at that point without
> pulling the command into the SCSI error handler.

Calling scsi_done() from a .eh_host_reset_handler() implementation is
not allowed because calling scsi_done() for a command that is on the
SCSI error handler list corrupts that list. One of the functions called
by scsi_done() is scsi_complete(). From that function:

	INIT_LIST_HEAD(&cmd->eh_entry);

This corrupts the command lists maintained by the SCSI error handler,
e.g. work_q and done_q.

Bart.
