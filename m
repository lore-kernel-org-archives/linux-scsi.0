From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 3/3] qla2xxx: Run queuecommand outside the host_lock
Date: Fri, 1 Apr 2011 21:31:24 -0600
Message-ID: <20110402033123.GB7286@parisc-linux.org>
References: <20110401202209.GN4183@linux.intel.com> <5E4F49720D0BAD499EE1F01232234BA8728A7B1A4F@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33731 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1DBDbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2011 23:31:25 -0400
Content-Disposition: inline
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA8728A7B1A4F@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhu Iyengar <madhu.iyengar@qlogic.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Apr 01, 2011 at 02:33:08PM -0700, Madhu Iyengar wrote:
> Mathew,
> 
> We submitted the host_lock related changes earlier, and the changes were accepted and went into the 2.6.38-rc6 (or round-about that timeframe) upstream kernel.
> 
> Here's the patch in that sequence we submitted earlier (which is now in the upstream/scsi stream):
> http://marc.info/?l=linux-scsi&m=129850384318495&w=2

Ah, cool.  You missed a step though:

	scsi_qla_host_t *vha = shost_priv(cmd->device->host);

That can just be:

	scsi_qla_host_t *vha = shost_priv(host);

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
