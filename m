From: Drew Winstel <raw@dslr.net>
Subject: Re: ATA Write Error and Time-out Notification in User Space
Date: Tue, 20 Dec 2005 18:31:38 -0600
Message-ID: <200512201831.38592.raw@dslr.net>
References: <BAY101-F33B48301330A7FFF7849A4DF3E0@phx.gbl> <1135119036.25010.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dslreports.com ([209.123.192.187]:1691 "EHLO mail.dslr.net")
	by vger.kernel.org with ESMTP id S932153AbVLUAbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2005 19:31:50 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.dslr.net (Postfix) with ESMTP id 565DE43727
	for <linux-scsi@vger.kernel.org>; Tue, 20 Dec 2005 19:31:44 -0500 (EST)
Received: from mail.dslr.net ([127.0.0.1])
 by localhost (coral.dslreports.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 14526-07 for <linux-scsi@vger.kernel.org>;
 Tue, 20 Dec 2005 19:31:44 -0500 (EST)
In-Reply-To: <1135119036.25010.21.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, John Treubig <jtreubig@hotmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Alan,

On Tuesday, December 20, 2005 16:50, Alan Cox wrote:
> On Maw, 2005-12-20 at 15:55 -0600, John Treubig wrote:
> > Where would I look in the LibATA/SCSI chain to permit Write Error and
> > Time-out notification to be passed back to user space without hanging the
> > system?
>
> Some background first:
>
> The 2.6 block layer can generally handle passing errors back up. It has
> a load of problems with EOF on media that is variable size but block
> that need fixing but the fundamental errors get back to the block layer.
>
> Unfortunately although they get back to the block request the full error
> is not propogated further up the stack. Thats actually tricky for the
> general file system case as I/O as asynchronous to the actual file
> system accesses and we may even hit errors on pages we didn't actually
> need.
>
> One result of that is that on write errors we generally mark a volume
> offline and processes accessing it get stuck.
>

With the application that John is using (namely, it delivers reads and writes 
directly to the drive via various SG ioctls), the file system is not an 
issue, hence wanting the errors to be returned to userspace.  

I presume this means that John would have to look at the block level error 
handling as opposed to the SCSI level?

<snip>

Drew
