From: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] git scsi misc include fix
Date: Mon, 15 Oct 2007 17:08:42 -0700
Message-ID: <20071015170842.9cfe4846.pj@sgi.com>
References: <20071014053508.30836.69658.sendpatchset@jackhammer.engr.sgi.com>
	<1192491330.14524.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52864 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756077AbXJPAIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 20:08:45 -0400
In-Reply-To: <1192491330.14524.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@linux-foundation.org, willy@linux.intel.com, linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

James wrote:
> The requirement for struct scatterlist is the same
> before and after the gid scsi-misc patch. 

Not so.  The git-scsi-misc.patch in 2.6.23-mm1 clearly adds the line:

    struct scatterlist sense_sgl;

as part of the added struct scsi_eh_save in scsi/scsi_eh.h.

This bit me while I was doing a bisection on 2.6.23-mm1, for another
problem, in git-sched, which is discussed in the lkml thread:

    git-sched patch won't boot on SN arch, 2.6.23-mm1

This is using sn2_defconfig.  The full 2.6.23-mm1 patch set builds ok,
because another patch, git-block.patch as I recall, includes
scatterlist.h some other way, but for the following range of patches in
2.6.23-mm1, on the configuration sn2_defconfig, the build is broken,
due to 'struct scatterlist' being an incomplete type:

    git-scsi-misc.patch
    git-scsi-misc-include-fix.patch
    git-scsi-misc-fixup.patch
    qla2xxx-printk-fixes.patch
    pci-error-recovery-symbios-scsi-base-support.patch
    pci-error-recovery-symbios-scsi-first-failure.patch
    nsp32_restart_autoscsi-remove-error-check.patch
    scsi-send-media-state-change-modification-events.patch
    scsi-early-detection-of-medium-not-present-updated.patch
    mptbase-reset-ioc-initiator-during-pci-resume.patch
    scsi-use-notifier-chain-for-asynchronous-event.patch
    initio-fix-conflict-when-loading-driver.patch
    git-block.patch

> it should also fail with vanilla 2.6.23

I don't know about the vanilla 2.6.23 case.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
