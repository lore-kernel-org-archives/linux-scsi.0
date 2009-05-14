From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/5] mvsas: optimization of code
Date: Thu, 14 May 2009 00:41:23 -0400
Message-ID: <4A0BA0F3.1040906@garzik.org>
References: <20090511172530.GB9720@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51329 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZENEl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 00:41:26 -0400
In-Reply-To: <20090511172530.GB9720@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com

Andy Yan wrote:
>>From 698781e21a8595159a84a8c91b6bfa26d1a99108 Mon Sep 17 00:00:00 2001
> From: Andy Yan <ayan@marvell.com>
> Date: Mon, 11 May 2009 22:19:25 +0800
> Subject: [PATCH 5/5] mvsas: optimization of code
> 
> Using sticky field to improve retrieve performance.
> 
> Signed-off-by: Ying Chu <jasonchu@marvell.com>
> Signed-off-by: Andy Yan <ayan@marvell.com>
> Signed-off-by: Ke Wei <kewei@marvell.com>

Please revise this patch, to remove all C casts from a void pointer.

Separately, please submit a patch #6 that audits the rest of the driver, 
and removes all casts to or from a void pointer.

Rationale:  Standard kernel policy.  Casts to/from void* are

	- unnecessary

	- may hide bugs, if a mistake is made when changing
	  the underlying C type.

The Linux kernel does its best to be "type aware", and we rely heavily 
on the compiler to warn us of potential problems.


