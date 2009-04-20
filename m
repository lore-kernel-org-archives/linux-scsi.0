From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: fix PCI permanent error handler
Date: Mon, 20 Apr 2009 09:35:44 -0500
Message-ID: <49EC8840.70100@linux.vnet.ibm.com>
References: <1239918093.6371.197.camel@zeppelin.austin.ibm.com> <1240020386.5763.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33446 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbZDTOf7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 10:35:59 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3KEboT8032694
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 10:37:50 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3KEZwUb194356
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 10:35:58 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3KEZv1d002704
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 10:35:58 -0400
In-Reply-To: <1240020386.5763.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2009-04-16 at 18:41 -0300, Kleber Sacilotto de Souza wrote:
>> The ipr driver can hang if it encounters enough PCI errors
>> to trigger the permanent error handler. The driver will attempt
>> to initiate a "bringdown" of the adapter and fail all pending
>> ops back. However, this bringdown is unlike any other bringdown
>> of the adapter in the code as the driver. In this code path we
>> end up failing back ops with allow_cmds still set to 1. This results
>> in some commands, the HCAM commands in particular, getting immediately
>> re-issued to the adapter on the done call, which results in
>> an infinite loop in ipr_fail_all_ops. Fix this by setting allow_cmds
>> to zero in this path. 
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
> 
> This signoff chain isn't right ... signoffs are supposed to document the
> hands through which this patch has patched.  I take it this should be
> acked-by Brian King instead?

Correct.


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


