From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] zfcp: convert the zfcp_erp thread to the kthread api
Date: Mon, 30 Oct 2006 10:55:50 +0100
Message-ID: <20061030105550.18cdc98c@gondolin.boeblingen.de.ibm.com>
References: <200610271138.50201.swen@vnet.ibm.com>
	<20061029222656.GB8494@osiris.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:57836 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP id S965467AbWJ3IzM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 03:55:12 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.8/8.13.8) with ESMTP id k9U8tAxW038746
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 08:55:10 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9U8w15W2506774
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 09:58:01 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9U8t9eF010986
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 09:55:10 +0100
In-Reply-To: <20061029222656.GB8494@osiris.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Sun, 29 Oct 2006 23:26:56 +0100,
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> What could happen:
> - code is in erp thread loop before down_interruptible(erp_ready_sem)
> - thread should be killed: somebody calls kthread_stop() hence
>   kthread_should_stop() gets true. But since the thread is not sleeping
>   (yet) there is no need to wake it. So kthread_stop() just waits.
> - erp thread comes to down_interruptible(erp_ready_sem) and sleeps.
> - the only "up" that would wake up the erp_thread comes after your
>   kthread_stop() which is waits that the thread terminates -> deadlock.

Grmpf, you're right. And even checking kthread_should_stop()
immediately before going to sleep would be racy. We need to up() after
we set should_stop and wait afterwards... Please drop this patch for
now until I have time to sort it out.

-- 
Cornelia Huck
Linux for zSeries Developer
Tel.: +49-7031-16-4837, Mail: cornelia.huck@de.ibm.com
