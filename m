From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND PATCH] mptsas: Fixed code to check whether the LU type
 is SSC or not for SILI bit in READ_6 and READ_16 CDB
Date: Tue, 06 Mar 2012 18:43:20 -0600
Message-ID: <1331081000.3226.37.camel@dabdike.int.hansenpartnership.com>
References: <201203060645.q266jR8Y026994@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43602 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756654Ab2CGAnW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 19:43:22 -0500
In-Reply-To: <201203060645.q266jR8Y026994@milmhbs0.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nagalakshmi.nandigama@lsi.com
Cc: stable@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2012-03-06 at 12:16 +0530, nagalakshmi.nandigama@lsi.com wrote:
> This SILI bit (suppress incorrect length indicator) is defined only for SSC
> READ(6) and READ(16) commands. For other device types bit is part of LBA

This isn't right ... it is for READ(6) but it's FUA_NV for
READ(10,12,16) on block devices.

> field. In the current implementation, it is not checked whether the logical
> unit is a SSC device.
> 
> 
> Added code for checking the LU type is SSC for SILI bit in READ_6 and READ_16 CDB 

I still don't have a description of what you think the actual bug is.

I think the problem is that strict block length checking is accidentally
turned off if FUA_NV is set on a block device (which currently doesn't
happen in practise ... nor do we ever really use READ_6 for block
devices) ... is that it?

James


