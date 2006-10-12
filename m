From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] SCSI/qla2xxx: handle sysfs errors
Date: Thu, 12 Oct 2006 10:31:38 -0700
Message-ID: <20061012173138.GC4296@andrew-vasquezs-computer.local>
References: <20061012014538.GA12894@havoc.gtf.org> <20061012165734.GG3638@andrew-vasquezs-computer.local> <452E7966.7030206@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53124 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1750806AbWJLRbm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 13:31:42 -0400
Content-Disposition: inline
In-Reply-To: <452E7966.7030206@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, 12 Oct 2006, Jeff Garzik wrote:

> Andrew Vasquez wrote:
> >NACK, please don't do this.  SYSFS entries, albiet important, aren't
> >necessarilly critical to a functioning driver.  I'd rather the driver
> >not error out.
> 
> As discussed before, the only errors thrown are either ENOMEM or EFAULT, 
> both of which are quite serious.

Absolutely.  But, given the relatively late-stage initialization of
these attributes (it's the last thing that gets done before probe()
completes)-- the driver has already allocated (successfully) memory,
intialized hardware and (possibly) presented storage, the complete
unwinding, seems over-kill.

> >Here's what I had stewing to address the must_check directives and
> >qla2xxx:
> 
> If you're gonna change it that much, might as well use attribute groups.

sysfs_create_group() and friends don't appear to support
binary attributes.
