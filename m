From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19642] 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: Sun, 3 Oct 2010 18:54:04 GMT
Message-ID: <201010031854.o93Is4D1002062@demeter1.kernel.org>
References: <bug-19642-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45232 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab0JCSyG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2010 14:54:06 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o93Is4xq002063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 3 Oct 2010 18:54:05 GMT
In-Reply-To: <bug-19642-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=19642





--- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-10-03 18:53:57 ---
Reply-To: James.Bottomley@suse.de

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

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
