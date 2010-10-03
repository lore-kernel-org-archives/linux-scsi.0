From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 19642] New: 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: Sun, 03 Oct 2010 13:53:26 -0500
Message-ID: <1286132006.2984.32.camel@mulgrave.site>
References: <bug-19642-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34634 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab0JCSxc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Oct 2010 14:53:32 -0400
In-Reply-To: <bug-19642-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Sun, 2010-10-03 at 18:37 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=19642
> 
>            Summary: 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.36-rc6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org

I think this is wrong.

>         ReportedBy: maciej.rutecki@gmail.com
>                 CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
>                     linux@horizon.com
>         Regression: Yes
> 
> 
> Subject    : 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
> Submitter  : "George Spelvin" <linux@horizon.com>
> Date       : 2010-09-30 21:10
> Message-ID : 20100930211006.27449.qmail@science.horizon.com
> References : http://marc.info/?l=linux-kernel&m=128588102620299&w=2

That looks like a zero length barrier send down to SCSI with the RW flag
set (hence we try to map a buffer that has nothing to map).  I cc'd
dm-devel to see what their opinion is.

James

