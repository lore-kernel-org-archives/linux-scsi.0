From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH RESEND] scsi: Add STARGET_CREATED_REMOVE state to
 scsi_target_state
Date: Wed, 28 Jun 2017 09:38:15 +0200
Message-ID: <20170628073815.GA4185@linux-x5ow.site>
References: <1498589758-31473-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751048AbdF1HiU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 03:38:20 -0400
Content-Disposition: inline
In-Reply-To: <1498589758-31473-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Tue, Jun 27, 2017 at 02:55:58PM -0400, Ewan Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> The addition of the STARGET_REMOVE state had the side effect of
> introducing a race condition that can cause a crash.
> 
> scsi_target_reap_ref_release() checks the starget->state to
> see if it still in STARGET_CREATED, and if so, skips calling
> transport_remove_device() and device_del(), because the starget->state
> is only set to STARGET_RUNNING after scsi_target_add() has called
> device_add() and transport_add_device().
> 
> However, if an rport loss occurs while a target is being scanned,
> it can happen that scsi_remove_target() will be called while the
> starget is still in the STARGET_CREATED state.  In this case, the
> starget->state will be set to STARGET_REMOVE, and as a result,
> scsi_target_reap_ref_release() will take the wrong path.  The end
> result is a panic:

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Although we've been tampering with the target removal code for quite some
time now, so I really have the gut feeling we haven't really fixed the
root cause yet.

I once tried building a regression test for this (with qemu hot plugging UAS
devices) but that didn't really go far. Maybe we should add a scsi_target
to scsi_debug and add some methods to toggle remove it again. Just to have
a sensible unit test for that code path.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
