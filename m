From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] FC transport & lpfc : Avoid device offline cases by stalling
 aborts until device unblocked
Date: Tue, 07 Feb 2006 09:41:20 -0500
Message-ID: <43E8B190.2030008@emulex.com>
References: <20060206191101.77227.qmail@web31809.mail.mud.yahoo.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61401 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S965106AbWBGOlY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 09:41:24 -0500
In-Reply-To: <20060206191101.77227.qmail@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


> Is it possible that you add dev_loss_tmo to the scsi_dev timeout?
> Say scsi_dev->timeout = dev_loss_tmo + X seconds?

No. This would imply setting it in slave_configure, and which means commands
artificially have a longer timeout at all times, not just when we're in a
loss of connectivity.

I had considered having eh_timed_out return a time adder, so we timeout once
rather than periodically based on the io timeout value. However, the
calculations to come up with how much time remains on the dev_loss_tmo value,
coupled with adding a return value to this function, didn't seem worth it.

-- james s
