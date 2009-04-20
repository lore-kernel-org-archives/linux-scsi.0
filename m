From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ipr: RESEND: fix PCI permanent error handler
Date: Mon, 20 Apr 2009 16:13:49 -0400
Message-ID: <1240258429.3315.60.camel@mulgrave.int.hansenpartnership.com>
References: <1240246790.7458.112.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48154 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149AbZDTUNw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 16:13:52 -0400
In-Reply-To: <1240246790.7458.112.camel@zeppelin.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2009-04-20 at 13:59 -0300, Kleber S. Souza wrote:
> From: Brian King <brking@linux.vnet.ibm.com>
> 
> The ipr driver can hang if it encounters enough PCI errors
> to trigger the permanent error handler. The driver will attempt
> to initiate a "bringdown" of the adapter and fail all pending
> ops back. However, this bringdown is unlike any other bringdown
> of the adapter in the code as the driver. In this code path we
> end up failing back ops with allow_cmds still set to 1. This results
> in some commands, the HCAM commands in particular, getting immediately
> re-issued to the adapter on the done call, which results in
> an infinite loop in ipr_fail_all_ops. Fix this by setting allow_cmds
> to zero in this path. 
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> Signed-off-by: Kleber S. Souza <klebers@linux.vnet.ibm.com>

OK, now I'm really confused.  Originally this patch was your From: but
had a Brian signoff.  I asked if it shouldn't be acked by him instead
and he responded "correct".

Now you've sent the patch as being his original authorship ... whose
patch is this?

James


