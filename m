From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Has anyone seen this?
Date: Tue, 14 Apr 2015 11:14:29 -0700
Message-ID: <1429035269.2209.41.camel@HansenPartnership.com>
References: <552D45B5.1040801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47825 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbbDNSOb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2015 14:14:31 -0400
In-Reply-To: <552D45B5.1040801@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2015-04-14 at 19:52 +0300, Sagi Grimberg wrote:
> When I set up a DIX enabled device for the first time (say
> scsi_debug) it all works, but when I remove it
> and set it up again I get the below crash:
> 
> Reproducer:
> $modprobe scsi_debug dif=1 dix=1
> $modprobe -r scsi_debug
> $modprobe scsi_debug dif=1 dix=1
> 
> It seems that somehow bdi_destroy() is not
> invoked for DIX...

That implies a refcount imbalance on the block queue.  Either from a
stray get (which looks impossible, because we only do queue gets and
puts in two places) or because there's an outstanding request, or
because there's an imbalance higher up.

Could you instrument and check we call
scsi_device_dev_release_usercontext() for the device (that should do the
final put).  If that's not happening, then we have an imbalance on the
scsi device itself.

Thanks,

James


