From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Is it time to kill ide-scsi.c?
Date: Sun, 08 Jul 2007 15:39:02 +0300
Message-ID: <4690DAE6.8040404@panasas.com>
References: <468BBCC0.3010007@panasas.com> <468D83A8.2060804@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4651 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751022AbXGHMj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jul 2007 08:39:27 -0400
In-Reply-To: <468D83A8.2060804@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Jeff Garzik wrote:
> Boaz Harrosh wrote:
>>  I have attempted (below) to convert ide-scsi to the new data
>>  accessors and cleanup the !use_sg code paths. Inspecting
>>  the code I can see places that still assume scsi_cmnd->request_buffer
>>  is a linear char pointer. Though I admit this assumption is hidden
>>  behind a flag "test_bit(PC_TRANSFORM, &pc->flags)". Is this an indication
>>  that this drivers no longer works? What is needed in order to kill this
>>  driver? If no killing is done than please accepted below patch.
>>
>>  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/ide-scsi.c |   48 ++++++++++++++++++++++++++++------------------
>>  1 files changed, 29 insertions(+), 19 deletions(-)
> 
> This is a very popular driver for some configurations.  I know many 
> people that used this for their ATAPI driver, rather than 
> ide-{cdrom,floppy,...}
> 
> 	Jeff
> 
> 
> 
Two questions than
1. All these users, don't they have a new solution with PATA drivers
or that is only for new HW/chipsets?

2. Do you know who is the maintainer of this driver? Because if it is
still needed, than my patch must be accepted. And I think my added BUG()
only does it good.

Thanks
Boaz
