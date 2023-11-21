Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="SVzrg7aw";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="SVzrg7aw"
X-Greylist: delayed 1148 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Nov 2023 05:24:32 PST
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF2C1BB
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 05:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1700573071;
	bh=zHVa6TgmeEIa5hCpVQ2RQXQWaW6nx8j+kjLrRzPe6G4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=SVzrg7awuV1GduNbgqQarxTnW5KgYcDgH9cx2BrZNyOFY3k23zTXp8FKQRhlGt0TQ
	 rfuIXNLm1OFiz8UCwOipQUbTwggRmEW9pnKRvUSnijMw965vJD+mGAdkaseq1FwasB
	 NWfayYiVtbGZAlraPAejXVM2uxk7mXckGqCiH5WE=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 70AF91286AFC;
	Tue, 21 Nov 2023 08:24:31 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id xq1xGrkGsroK; Tue, 21 Nov 2023 08:24:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1700573071;
	bh=zHVa6TgmeEIa5hCpVQ2RQXQWaW6nx8j+kjLrRzPe6G4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=SVzrg7awuV1GduNbgqQarxTnW5KgYcDgH9cx2BrZNyOFY3k23zTXp8FKQRhlGt0TQ
	 rfuIXNLm1OFiz8UCwOipQUbTwggRmEW9pnKRvUSnijMw965vJD+mGAdkaseq1FwasB
	 NWfayYiVtbGZAlraPAejXVM2uxk7mXckGqCiH5WE=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E7BFE1286AF5;
	Tue, 21 Nov 2023 08:24:29 -0500 (EST)
Message-ID: <18ad94304843f720004d9663cdda9e6297558609.camel@HansenPartnership.com>
Subject: Re: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter
 abort request after update to linux 6.4.0
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org, 
 pheidologeton@protonmail.com, maokaman@gmail.com,
 sagar.biradar@microchip.com,  info@webix.ws, bobinium@thoughtsfactory.net,
 joop.boonen@netapp.com,  leyyyyy@gmail.com, kernel@roadkil.net
Cc: John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>
Date: Tue, 21 Nov 2023 08:24:27 -0500
In-Reply-To: <bug-217599-11613-KqMMkRHrKc@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
	 <bug-217599-11613-KqMMkRHrKc@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-11-21 at 09:54 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217599
> 
> --- Comment #29 from The Linux kernel's regression tracker (Thorsten
> Leemhuis) (regressions@leemhuis.info) ---
> TWIMC, I raised the issue once more in a mail to the people that
> should handle this:
> https://lore.kernel.org/regressions/c6ff53dc-a001-48ee-8559-b69be8e4db81@leemhuis.info/T/#u

Switching to email since the bugzilla seems to have stalled.  The
kernel lists will discard text/html email, so if you have email
problems, you can reply by using bugzilla.

Firstly, can as many reporters as possible check to see if reverting
this commit:

https://github.com/torvalds/linux/commit/9dc704dcc09eae7d21b5da0615eb2ed79278f63e

Fixes your problem with an upstream kernel?

Secondly, John Garry asked if you could provide:

> Is there a full kernel log for this hanging system?
> 
> I can only see snippets in the ticket.
> 
> And what does /sys/class/scsi_host/host*/nr_hw_queues show?

Regards,

James

