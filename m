From: Alex Aizman <itn780@yahoo.com>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator for Linux
Date: Wed, 09 Mar 2005 18:09:45 -0800
Message-ID: <422FAC69.1040206@yahoo.com>
References: <OF44130B14.D1B3F38E-ON85256FBF.0068AD48-88256FBF.006AACD8@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from smtp107.mail.sc5.yahoo.com ([66.163.169.227]:7299 "HELO
	smtp107.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261466AbVCJCKY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 21:10:24 -0500
In-Reply-To: <OF44130B14.D1B3F38E-ON85256FBF.0068AD48-88256FBF.006AACD8@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Matt Mackall <mpm@selenic.com>

Bryan Henderson wrote:

>Its fundamental to Unix architecture that user programs sit above the 
>kernel and get services from the kernel, and turning that on its head so 
>that the kernel depends on a user space program to do something as 
>fundamental as a pageout can't come to any good.  
>
Agreed.

>Even if we're able to 
>identify every assumption in Linux design that's being broken and patch it 
>up with something like mlockall, tomorrow someone will change something, 
>using his vast experience with engineering user space programs, and break 
>it again.
>  
>
In the same vein can quote Murphy's laws here, like "things get worse 
under pressure", etc. Specifics, please!

>Maybe a more important point is that to the extent that you make a user 
>space process a proxy of the kernel, you lose all those advantages that 
>are supposed to come with user space engineering:  you can now totally 
>hose your system by making a mistake in the code; you have to be 
>intimately familiar with kernel internals to get the code right, etc.
>
>mlockall is meant to provide performance characteristics to a user space 
>process.  If it can be used to create resource ordering correctness, it's 
>an accident.
>
>Syslog is one of those things you're not supposed to have to think about. 
>If every time you issue a message you have to visualize the entire syslog 
>system with all of its options to know if you've broken something, the 
>simplicity of user space is gone.
>  
>

The issue with syslog is clear, we are looking into implementation options.

>I would think as a basic design principle that if kernel code ever has to 
>wait for a user process to do something, 
>

Open-iSCSI is designed for this to never happen. The user/kernel 
interface (see include/iscsi_if.h) is non-blocking. Once the transport 
connection gets established (by the user) and handed over to the kernel 
(to transport block data), the rest data path happens without user 
interaction. Command level error processing is done by the kernel part, 
_no_ dependency here. Connection-level error processing is _delegated_ 
to the user, kernel does not block - it just expects the "higher" 
authority to make the decision wrt faulty connection.


>it should do it high in a system 
>call, in user context, interruptibly, etc.  I don't know if it's possible 
>to arrange to have the ISCSI initiator waiting there, but I think it's the 
>only way having a user space process can do what it's supposed to do.
>
>  
>
I also don't know whether it is possible (but I know that if it were 
possible it would by quite ugly); the main thing however is - this is 
not what's happening.

>I'd like to remind everyone that user space processes aside, there's still 
>a basic ISCSI initiator resource inversion that needs to be fixed to avoid 
>deadlock:
>
>ISCSI initiator driver sits below the memory pool
>  (I..e a pageout involving ISCSI might be prerequisite to getting memory)
>Socket layer sits below ISCSI
>  (ISCSI initiator driver relies on socket services)
>Memory pool sits below socket layer
>  (socket layer allocates memory from the main pool)
>
>One might say as long as that's there, close is good enough on the user 
>space initiator component.
>
>--
>Bryan Henderson                               San Jose California
>IBM Almaden Research Center                   Filesystems
>
>  
>

Alex
