From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600aacraidPERC 3/Di Container goes offline
Date: Tue, 23 Nov 2004 16:50:19 -0600
Message-ID: <20041123225019.GD30452@lists.us.dell.com>
References: <60807403EABEB443939A5A7AA8A7458B694F38@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:33965 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261608AbUKWWuY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 17:50:24 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B694F38@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Ryan Anderson <ryan@autoweb.net>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Tue, Nov 23, 2004 at 05:27:36PM -0500, Salyzyn, Mark wrote:
> Yes, somewhat irrelevant. The firmware engineer that made the changes
> has not had recent contact with me, so I am not sure what he did when he
> went to 6092.

The firmware architecture is cooperative multitasking, meaning one
process must explicitly yield to allow another task to run.  The
firmware flush buffer routine could run for a very long time,
preventing further I/Os from being accepted by the card from the OS,
and preventing I/O completion to the OS.  The change for build 6092
was to explicitly yield the flush buffer routine after flushing some
buffers to allow other firmware processes to be scheduled.  This
alleviates the failure scenario that we could reproduce in our lab,
and allows the controller read and write caches to be re-enabled via
the command line tool.

It appears that Ryan has a different failure scenario that this fix
doesn't address.  Ryan, please try disabling your controller read and
write caches via afacli and see if that helps.  Also, if you haven't
already, please call Dell Tech Support and make sure they file an
incident report, collect as much data as they can (afacli diag dump in
particular) about the failure, and maybe, just maybe, it can get
reproduced in an environment we can debug and fix it.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
