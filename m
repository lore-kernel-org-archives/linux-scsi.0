From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator for Linux
Date: Wed, 9 Mar 2005 11:29:03 -0800
Message-ID: <OF44130B14.D1B3F38E-ON85256FBF.0068AD48-88256FBF.006AACD8@us.ibm.com>
References: <422E96D9.6090202@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46724 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262189AbVCIT3F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 14:29:05 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j29JT5xI015739
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 14:29:05 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j29JT5nA075232
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 14:29:05 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j29JT4Zc009619
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 14:29:04 -0500
Received: from d01ml604.pok.ibm.com (d01ml604.pok.ibm.com [9.56.227.90])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j29JT4eG009616
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 14:29:04 -0500
In-Reply-To: <422E96D9.6090202@yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: linux-scsi@vger.kernel.org, Matt Mackall <mpm@selenic.com>

>The 
>short and long of it: the problem can be solved, and it will. Couple 
>simple things we already do: mlockall() to keep the daemon un-swapped, 
>and also looking into potential dependency created by syslog (there's 
>one for 2.4 kernel, not sure if this is an issue for 2.6).

I think it's probably possible and good to do most of this complex stuff 
in user space, but it looks to me like it's going down exactly the wrong 
road.

Its fundamental to Unix architecture that user programs sit above the 
kernel and get services from the kernel, and turning that on its head so 
that the kernel depends on a user space program to do something as 
fundamental as a pageout can't come to any good.  Even if we're able to 
identify every assumption in Linux design that's being broken and patch it 
up with something like mlockall, tomorrow someone will change something, 
using his vast experience with engineering user space programs, and break 
it again.

Maybe a more important point is that to the extent that you make a user 
space process a proxy of the kernel, you lose all those advantages that 
are supposed to come with user space engineering:  you can now totally 
hose your system by making a mistake in the code; you have to be 
intimately familiar with kernel internals to get the code right, etc.

mlockall is meant to provide performance characteristics to a user space 
process.  If it can be used to create resource ordering correctness, it's 
an accident.

Syslog is one of those things you're not supposed to have to think about. 
If every time you issue a message you have to visualize the entire syslog 
system with all of its options to know if you've broken something, the 
simplicity of user space is gone.

I would think as a basic design principle that if kernel code ever has to 
wait for a user process to do something, it should do it high in a system 
call, in user context, interruptibly, etc.  I don't know if it's possible 
to arrange to have the ISCSI initiator waiting there, but I think it's the 
only way having a user space process can do what it's supposed to do.


I'd like to remind everyone that user space processes aside, there's still 
a basic ISCSI initiator resource inversion that needs to be fixed to avoid 
deadlock:

ISCSI initiator driver sits below the memory pool
  (I..e a pageout involving ISCSI might be prerequisite to getting memory)
Socket layer sits below ISCSI
  (ISCSI initiator driver relies on socket services)
Memory pool sits below socket layer
  (socket layer allocates memory from the main pool)

One might say as long as that's there, close is good enough on the user 
space initiator component.

--
Bryan Henderson                               San Jose California
IBM Almaden Research Center                   Filesystems
