From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Thu, 03 Feb 2005 11:05:32 +0100
Message-ID: <1107425132.4278.99.camel@laptopd505.fenrus.org>
References: <001001c508d9$d97a17f0$9300a8c0@erich2003>
	 <20050202180817.47db64c2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from canuck.infradead.org ([205.233.218.70]:1295 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S262705AbVBCKFl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2005 05:05:41 -0500
In-Reply-To: <20050202180817.47db64c2.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: erich <erich@areca.com.tw>, linux-scsi@vger.kernel.org

On Wed, 2005-02-02 at 18:08 -0800, Andrew Morton wrote:
> "erich" <erich@areca.com.tw> wrote:
> >
> > I have contact with Andrew Morton about ARECA RAID Linux scsi driver release
> >  issue.
> >  I hope this package is as look like a Linux driver.
> 
> No, it doesn't look anything like a Linux driver :(
> 
> I fed the patch through scripts/Lindent.  There's a copy at
> http://www.zip.com.au/~akpm/linux/patches/stuff/areca-raid-linux-scsi-driver.patch.
>  I'll include it -mm kernels.
> 
> >From a very quick look, I'd say that the driver needs quite a bit of work:

It is nice to see vendors submitting drivers for their hardware; this
one does need some more work though to look like a linux driver

more work items:
* needs to use list.h lists not open coded ones
* uses wrong locking for the scsi layer (eg ->done should be called  
  without locks)
* ULONG and simliar typedefs.. does this driver come from windows ?
  typedef uint32_t ULONG, *PULONG;
  is just not a good idea.
* lots and lots of ifdefs that are done wrongly; eg if you need to do
   version ifdefs.. do them right ;(
example: 
arcmsr_doInterrupt()
is ifdefd needlessly/wrongly



