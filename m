From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [scott.bailey@eds.com: Bug#527265:
	linux-image-2.6.29-1-alpha-smp: detached firmware qlogic/1040.bin fails to
	load for qla1280]
Date: Wed, 06 May 2009 14:44:30 +0000
Message-ID: <1241621070.3322.17.camel@mulgrave.int.hansenpartnership.com>
References: <20090506141912.GA31614@baikonur.stro.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57665 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbZEFOoc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 10:44:32 -0400
In-Reply-To: <20090506141912.GA31614@baikonur.stro.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: maximilian attems <max@stro.at>
Cc: linux-scsi@vger.kernel.org, "R. Scott Bailey" <scott.bailey@eds.com>, 527265@bugs.debian.org

On Wed, 2009-05-06 at 16:19 +0200, maximilian attems wrote:
>  [4194023.390744] ------------[ cut here ]------------
>  [4194023.448362] WARNING: at /build/buildd-linux-2.6_2.6.29-3-alpha-bvFcox/linux-2.6-2.6.29/debian/build/source_alpha_none/kernel/so

Is there any way we can get what that file and line actually is?  It
looks like the kernel build hasn't truncated the path name to top of
tree for some reason (did you build with non standard options)?

I suspect it might just be a lockdep error about calling request
firmware with interrupts disabled.

Could you also check to see you have this fix in your kernel:

commit 0ce49d6da993adf8b17b7f3ed9805ade14a6a6f3
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Wed Apr 8 01:22:36 2009 -0700

    qla1280: Fix off-by-some error in firmware loading.

James


