From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] st: Take additional queue ref in st_probe
Date: Mon, 04 Mar 2013 13:13:31 -0500
Message-ID: <1362420811.18372.143.camel@localhost.localdomain>
References: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623Ab3CDSNi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Mar 2013 13:13:38 -0500
In-Reply-To: <alpine.DEB.2.02.1303041101450.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Mon, 2013-03-04 at 11:14 -0500, Joe Lawrence wrote:
> These changes were applied to scsi.git, branch "misc".  This patch
> fixes a reference count bug in the SCSI tape driver which can be
> reproduced with the following:
> 
> * Boot with slub_debug=FZPU, tape drive attached
> * echo 1 > /sys/devices/... tape device pci path .../remove
> * Wait for device removal
> * echo 1 > /sys/kernel/slab/blkdev_queue/validate
> * Slub debug complains about corrupted poison pattern

The incorrect reference count fixed by this patch is almost certainly
responsible for OOPSes seen with tape devices connected using zfcp
on the s390x architecture due to a use-after-free.  I was able to
reproduce the problem with scsi_debug ptype=1 and slub_debug enabled.
So, st device support is broken.  With the patch, the problem no longer
appears.

-Ewan <emilne@redhat.com>



