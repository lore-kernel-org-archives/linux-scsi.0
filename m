From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] - mptfusion - adding back the spin locks in eh handle
  rs
Date: Thu, 23 Jun 2005 19:18:26 -0400
Message-ID: <42BB4342.5060704@pobox.com>
References: <91888D455306F94EBD4D168954A9457C02DD8E97@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:38333 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262606AbVFWXSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 19:18:34 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C02DD8E97@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, linux scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Moore, Eric Dean wrote:
> Luben
> 
> Ok - So you agree that completing Task management request
> in the same context as the eh threads is the way to go, right?
> 
> Because that is what this LLD is doing.  Have you had
> a chance to look at our code?
> 
> That previous patch submitted by Jeff(I guess) was removing code which
> enabled interrupts.  My patch was restoring it back to previous
> working code which doesn't hang the driver.

What was broken?

MPT abort handler would release the spinlock at the beginning, and 
reacquire it at the end, essentially reversing the spinlocks in the old 
spinlocked EH code.

	Jeff



