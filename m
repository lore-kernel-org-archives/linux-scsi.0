From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Wed, 2 Mar 2005 10:39:54 -0800
Message-ID: <OFC9C7B502.5FE48110-ON85256FB8.0065678F-88256FB8.00662EA7@us.ibm.com>
References: <422599BE.9020008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e2.ny.us.ibm.com ([32.97.182.142]:62917 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262220AbVCBSj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2005 13:39:57 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j22IduaW022708
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 13:39:56 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j22IduLP059114
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 13:39:56 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j22IdtWO010806
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 13:39:56 -0500
In-Reply-To: <422599BE.9020008@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Arjan van de Ven <arjan@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

>Bryan Henderson wrote:
>>>You want to *use* the kernel pagecache as much as you can.
>> 
>> 
>> No, I really don't.  Not always.  I can think of only 2 reasons to 
>> maximize my use of the kernel pagecache: 1) saves me duplicating code; 
2) 
>> allows me to share resources (memory and disk bandwidth come to mind) 
with 
>> others in the same Linux system fairly.  There are many cases where 
those 
>> two benefits are outweighed by the benefits of using some other cache. 
If 
>> you're thinking of other benefits of using the pagecache, let's hear 
them.
>
>You forgot the third reason (benefit), though it doesn't directly 
>related to the page cache: read ahead. It greatly influences on the 
>performance and a direct I/O application has to reimplement this logic, 
>which generally isn't straightforward task.

Actually, that's the first reason I gave.  The readahead that the page 
cache does can be duplicated, and sometimes far exceeded, by a special 
purpose user space cache.  As you say, it isn't straightforward, so saving 
that duplication is a good reason to use the page cache.

Using the page cache is clearly better than using no cache at all (we're 
including readahead and writebehind buffers in the term "cache") in nearly 
all cases.

