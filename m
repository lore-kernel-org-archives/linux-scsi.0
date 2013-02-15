From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SG_SCSI_RESET ioctl: add no_escalate values
Date: Fri, 15 Feb 2013 15:48:35 -0600
Message-ID: <511EAD33.7000901@cs.wisc.edu>
References: <511E8EF7.3010004@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60157 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab3BOVso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 16:48:44 -0500
In-Reply-To: <511E8EF7.3010004@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Jeremy Linton <jlinton@tributary.com>

On 02/15/2013 01:39 PM, Douglas Gilbert wrote:
> Further to the thread titled: "[PATCH] SG_SCSI_RESET ioctl should
> only perform requested operation" by Jeremy Linton a patch
> is presented that adds "no_escalate" versions to the existing
> ioctl. This should not break any existing code.
> 
> This patches applies to lk 3.7.7 and lk 3.8.0-rc7 . I will extend
> sg_reset in the sg3_utils package to use it.
> 
> ChangeLog:
>   - modify SG_SCSI_RESET ioctl so the SG_SCSI_RESET_NO_ESCALATE
>     value may be added to the existing values. If so the existing
>     device->target->bus->host escalation does not occur.
>   - modify scsi_reset_provider() in the scsi_error.c file in a
>     similar way to support this new functionality.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Some drivers rely on more invasive eh callbacks to be called if they
return FAILED in a eh callbacks. Is there a way for drivers to tell
scsi-ml it needs the old behavior?
