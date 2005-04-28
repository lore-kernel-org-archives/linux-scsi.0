From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [Question] Does the kernel ignore errors writng to disk?
Date: Thu, 28 Apr 2005 11:14:53 -0700
Message-ID: <OFDD96A309.D5D89999-ON88256FF1.0062E298-88256FF1.00645C51@us.ibm.com>
References: <1114700283.24687.193.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:3242 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262215AbVD1SP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 14:15:29 -0400
In-Reply-To: <1114700283.24687.193.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: brace@hp.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, mike.miller@hp.com

>See man fsync
>and also O_DIRECT if you need specific "to disk" support

Probably the most common way to get the simple but slow write function 
where the write() call actually writes to stable storage, and fails if it 
can't, is the O_SYNC open flag.

But even that, in some versions of Linux, can miss write errors.  It's not 
easy for Linux to catch them because the code that sees the I/O fail 
doesn't know if it's part of some synchronous procedure where the user 
will eventually find out about the error or the more common case where the 
application has optimistically walked away and nothing can be done but 
write off the loss.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
