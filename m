From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Patch added to scsi-rc-fixes-2.6:  [SCSI] host lock push-down
Date: Wed, 10 Nov 2010 18:28:01 -0500
Message-ID: <4CDB2A81.5030100@garzik.org>
References: <201011102240.oAAMe86a001486@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45492 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab0KJX2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 18:28:11 -0500
In-Reply-To: <201011102240.oAAMe86a001486@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, LKML <linux-kernel@vger.kernel.org>

On 11/10/2010 05:40 PM, James Bottomley wrote:
> Your commit:
>
>      [SCSI] host lock push-down
>
>      Move the mid-layer's ->queuecommand() invocation from being locked
>      with the host lock to being unlocked to facilitate speeding up the
>      critical path for drivers who don't need this lock taken anyway.
>
>      The patch below presents a simple SCSI host lock push-down as an
>      equivalent transformation.  No locking or other behavior should change
>      with this patch.  All existing bugs and locking orders are preserved.
>
>      Minimal code disturbance was attempted with this change.  Most drivers
>      needed only two one-line modifications for their host lock push-down.
>
>      Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
>      Signed-off-by: James Bottomley<James.Bottomley@suse.de>
>
> has been added to the upstream SCSI tree
> You can find it here:

No comments on renaming ->queuecommand to something else?

The consequences are rather dire if this goes unnoticed, yes?

	Jeff


In http://marc.info/?l=linux-ide&m=128891665713984&w=2 I wrote:
> An alternate arrangement, not presented by this patch, might
> be preferred:  in order to make it clear that queuecommand
> locking has changed, one could s/queuecommand/queuecommand_nl/ in
> Scsi_Host_Template, in order to guarantee that drivers are either
> (a) upgraded or (b) broken at compile time.  Compile-time detection of
> new locking may be desirable, and I'll volunteer to change my patch to
> do that, if community members prefer that route instead of below.

