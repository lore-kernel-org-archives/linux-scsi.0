From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 1 Mar 2005 10:24:34 -0800
Message-ID: <OF00F39C19.AE2C12A8-ON88256FB7.00641755-88256FB7.0065149B@us.ibm.com>
References: <20050301183549J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e6.ny.us.ibm.com ([32.97.182.146]:30155 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262010AbVCASYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 13:24:14 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j21IOEWZ021115
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 13:24:14 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j21IODk0068102
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 13:24:13 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j21IODPg000575
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2005 13:24:13 -0500
In-Reply-To: <20050301183549J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arjan@infradead.org, iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

One thing that's implicit in your reasons for wanting to be in the kernel 
is that you've chosen to exploit the kernel's page cache.  As a user of 
the page cache, you have more control from inside the kernel than from 
user space.  The page cache was designed to be fundamentally invisible to 
user space.

A pure user space implementation of an ISCSI target would use process 
virtual memory for a cache and manage it itself.  It would access the 
storage with direct I/O.  It looks to me like this is aimed at a 
single-application Linux system (the whole system is just an ISCSI 
target), which means there's not much need for a kernel to manage shared 
resources.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
