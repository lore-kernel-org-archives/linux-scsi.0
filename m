From: Paul Jackson <pj@sgi.com>
Subject: Re: [patch 2/7] git scsi misc include fix
Date: Tue, 16 Oct 2007 15:04:35 -0700
Message-ID: <20071016150435.e2c6e158.pj@sgi.com>
References: <200710162128.l9GLSKUF018167@imap1.linux-foundation.org>
	<20071016143353.9a9b6ea6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56815 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935846AbXJPWEq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 18:04:46 -0400
In-Reply-To: <20071016143353.9a9b6ea6.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Randy wrote:
> >  #include <linux/scatterlist.h>
> >  
> >  #include <scsi/scsi_cmnd.h>
> > +#include <linux/scatterlist.h>
> >  struct scsi_device;
> >  struct Scsi_Host;
> 
> It's 3 lines above the patch line....

Ah - you mean scatterlist.h is now included twice - yup.

First I noticed that scsi_eh.h needed this scatterlist.h include and
sent this patch to akpm.  Then James noticed that my patch just added
scatterlist.h to scsi_eh.h, without removing it from the other .c file
where it was no longer needed, so he sent along a patch that did both -
removing the one include and adding the other.  His patch added the
first scatterlist.h include above, and my earlier patch added the
second.

Now we have both scatterlist.h includes here.

I guess I'll leave it up to James to send along a third patch someday,
that removes one of these includes.

Sharp eyes, Randy - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
