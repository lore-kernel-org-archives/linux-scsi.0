From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] Load goes up very high when we traverse the large tree
Date: Thu, 25 Feb 2010 13:34:31 GMT
Message-ID: <201002251334.o1PDYVQH009582@demeter.kernel.org>
References: <bug-15341-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54674 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab0BYNec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 08:34:32 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1PDYVAo009583
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2010 13:34:31 GMT
In-Reply-To: <bug-15341-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15341





--- Comment #15 from Jens Axboe <axboe@kernel.dk>  2010-02-25 13:34:23 ---
OK, that's good at least. We need to do something about 2.6.32, though. If you
are willing to try and bisect the problem, it would be much appreciated.
Checking revisions between 2.6.31 and 2.6.32 for CFQ, there are only 12 of
them. So you would not need to compile and check more than 4 kernels.

The way you would do this, is git clone Linus -git tree:

$ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
$ git checkout v2.6.32

Start the bisect testing:

$ git bisect start block/cfq-iosched.c
$ git bisect good v2.6.31
$ git bisect bad v2.6.32

Now copy in your .config and run make oldconfig and compile the kernel+modules
like you always do. Boot and test the kernel. Lets assume this first test is
good, you'd then cd back into your source directory and do:

$ git bisect good

which would hand you a new revision to build, boot, and test. Likewise, if the
resulting kernel image didn't work well, you would run

$ git bisect bad

instead. You repeat this until git tells you what the bad revision was. And
then you post that here :-)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
