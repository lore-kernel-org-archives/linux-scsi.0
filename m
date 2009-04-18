From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ipr: fix PCI permanent error handler
Date: Fri, 17 Apr 2009 22:06:26 -0400
Message-ID: <1240020386.5763.3.camel@mulgrave>
References: <1239918093.6371.197.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60934 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbZDRDuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2009 23:50:20 -0400
In-Reply-To: <1239918093.6371.197.camel@zeppelin.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2009-04-16 at 18:41 -0300, Kleber Sacilotto de Souza wrote:
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
> Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

This signoff chain isn't right ... signoffs are supposed to document the
hands through which this patch has patched.  I take it this should be
acked-by Brian King instead?

James


