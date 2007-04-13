From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [PATCH 1/1] cciss: include scsi/scsi.h unconditionally
Date: Fri, 13 Apr 2007 23:48:28 +0100
Message-ID: <558F4D473FD7FE419B019232BF2D37B40B247B@G3W0634.americas.hpqcorp.net>
References: <20070413142312.GA24021@quandary.cca.cpqcorp.net> <20070413143413.6b9ac0e7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:46856 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965654AbXDMWt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Apr 2007 18:49:26 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, james.bottomley@steeleye.com


Andrew Morton [mailto:akpm@linux-foundation.org] wrote:

> On Fri, 13 Apr 2007 09:23:12 -0500
> Stephen Cameron <steve.cameron@hp.com> wrote:
>
> > Make cciss unconditionally include scsi/scsi.h
> 
> For what reason?

Because the use of:

        case SCSI_IOCTL_GET_IDLUN:
        case SCSI_IOCTL_GET_BUS_NUMBER:


At first, I thought the solution should be make
cciss dependent on CONFIG_SCSI.  Then James Bottomley
convinced me otherwise, and my first instinct was just
to comment out those cases above, since they fall through
to a default case anyway.  Then Christoph Hellwig commented
that with CONFIG_SCSI, we picked up scsi/scsi.h which made
it compile, but only accidentally.  So then I thought to 
include scsi/scsi.h unconditionally.  If it would be preferable
to just comment out those cases and let the default case
handle it, that's fine be me too.

-- steve
