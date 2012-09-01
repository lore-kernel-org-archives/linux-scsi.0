From: Stefan Ring <stefanrin@gmail.com>
Subject: Re: [resend PATCH] =?utf-8?b?c2NzaV9yZW1vdmVfdGFyZ2V0Og==?= fix softlockup regression on hot remove
Date: Sat, 1 Sep 2012 16:01:39 +0000 (UTC)
Message-ID: <loom.20120901T175838-180@post.gmane.org>
References: <20120829051119.26395.15980.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41782 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab2IAQFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Sep 2012 12:05:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1T7qBz-0007Ql-Nq
	for linux-scsi@vger.kernel.org; Sat, 01 Sep 2012 18:05:03 +0200
Received: from chello084113150185.1.13.vie.surfer.at ([84.113.152.185])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 01 Sep 2012 18:05:03 +0200
Received: from stefanrin by chello084113150185.1.13.vie.surfer.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 01 Sep 2012 18:05:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dan Williams <djbw <at> fb.com> writes:

> John reports:
>  BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
>  [..]
> 
> ...introduced by commit 3b661a9 "[SCSI] fix hot unplug vs async scan race".
> 
> Don't restart lookup of more stargets in the multi-target case, just
> arrange to traverse the list once, on the assumption that new targets
> are always added at the end.  There is no guarantee that the target will
> change state in scsi_target_reap() so we can end up spinning if we
> restart.

Patch works for me.

See also <https://bugzilla.redhat.com/show_bug.cgi?id=848425> for
"hardware-less" reproduction instructions.

