From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Questions about scsi.c
Date: Thu, 25 Oct 2007 13:49:26 -0700
Message-ID: <20071025134926.4d209584.rdunlap@xenotime.net>
References: <200710250606.03301.rob@landley.net>
	<200710251325.37586.rob@landley.net>
	<20071025103241.546b35ec.rdunlap@xenotime.net>
	<200710251640.35758.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:44814 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762849AbXJYUta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 16:49:30 -0400
Received: from midway.site ([71.117.233.180]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2007 13:49:27 -0700
In-Reply-To: <200710251640.35758.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org, jgarzik <jgarzik@pobox.com>

On Thu, 25 Oct 2007 16:40:35 -0500 Rob Landley wrote:

> On Thursday 25 October 2007 12:32:41 pm Randy Dunlap wrote:
> > > Entirely possible I'm doing something wrong:
> > >
> > >    <sect1 id="scsi_device.h">
> > >       <title>include/scsi/scsi_device.h</title>
> > >       <para>
> > >       </para>
> > > !Einclude/scsi/scsi_device.h
> > >     </sect1>
> >
> > !E is for exported symbols and that file has none.
> > USe !I instead.
> 
> So how do I handle a case like drivers/ata/libata-core.c which has 
> EXPORT_SYMBOL() calls for functions that live in (and are documented in) 
> other files, such as ata_scsi_ioctl() in drivers/ata/libata-scsi.c?

I don't see ata_scsi_ioctl() documented at all.  Are you looking at
a newer tree than I am?  (i'm using 2.6.24-rc1)

Long-term answer is that we prefer EXPORT_SYMBOL() to be used
just under the function that is being exported.  In this case,
the maintainer may be disagreeing with that.  [cc-ed]

Short-term answer is to use !Isource_filename_where_kernel_doc_is
as though it's not EXPORTed.  I think.

---
~Randy
