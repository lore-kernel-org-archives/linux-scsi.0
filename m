From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] kill aac_io_done
Date: Mon, 11 Oct 2004 12:07:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B2FC33F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:60602 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269043AbUJKQIC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 12:08:02 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi <linux-scsi@vger.kernel.org>

The host lock around scsi_done() was there *before* I started
maintaining this driver. I believe the reasoning could be as simple as
`we had an io_request_lock there, so we should need a host_lock for the
same reasons'. I believe this locking is a legacy of code prior to
2.1.95 though...

Before I can be comfortable removing this in Adaptec's code base
(supporting Linux variants from 2.4.2 to 2.6.8.1), I would need to know
the reasoning for this lock for all the Linux Distributions. I have to
support RH7, for instance, because we have some test groups using this
as the basis for their manufacturing testing tools. Confirmation that it
became unnecessary at some specific version without doubt would be nice.
Do we have a historian that knows this? Also, in Adaptec's code base,
because of debugging needs, the aac_io_done routine is a common point
for instrumentation. The code change places a burden on future debugging
(but I have already accepted that I am maintaining a branch forever for
purposes of debugging, investigation and a seed for the scsi_list
driver).

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Mark Haverkamp [mailto:markh@osdl.org] 
Sent: Monday, October 11, 2004 11:49 AM
To: Christoph Hellwig
Cc: Salyzyn, Mark; jejb@steeleye.com; linux-scsi
Subject: Re: [PATCH] kill aac_io_done

On Sat, 2004-10-09 at 06:46, Christoph Hellwig wrote:
> there's not need anymore to take the host lock before calling ->done

I have wondered about this.  Was the host lock needed at one time in the
past?

Mark.

> 

-- 
Mark Haverkamp <markh@osdl.org>

