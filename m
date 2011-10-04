From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [RFT PATCH] libsas: fix port->dev_list locking
Date: Tue, 4 Oct 2011 16:27:05 +0800
Message-ID: <9300BC58D1EA4424882767F97B8C6063@usish.com.cn>
References: <20110922050125.32188.27056.stgit@localhost6.localdomain6> <1317575933.5067.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:37653 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1JDI0o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2011 04:26:44 -0400
In-Reply-To: <1317575933.5067.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, 'Xiangliang Yu' <yuxiangl@marvell.com>, 'Mark Salyzyn' <msalyzyn@us.xyratex.com>, 'Christoph Hellwig' <hch@lst.de>, 'Luben Tuikov' <ltuikov@yahoo.com>

> 
> On Wed, 2011-09-21 at 22:05 -0700, Dan Williams wrote:
> > port->dev_list maintains a list of devices attached to a given sas root
port.
> > It needs to be mutated under a lock as contexts outside of the
> > single-threaded-libsas-workqueue access the list via
> sas_find_dev_by_rphy().
> > Fixup locations where the list was being mutated without a lock.
> >
> > This is a follow-up to commit 5911e963 "[SCSI] libsas: remove expander
> > from dev list on error", where Luben noted [1]:
> >
> >     > 2/ We have unlocked list manipulations in
sas_ex_discover_end_dev(),
> >     > sas_unregister_common_dev(), and sas_ex_discover_end_dev()
> >
> >     Yes, I can see that and that is very unfortunate.
> >
> > [1]: http://marc.info/?l=linux-scsi&m=131480962006471&w=2
> 
> Since this call for testing was issued 11 days ago, did anyone actually
> test this patch?
> 
> James
> 
[Jack Wang] Hi James,
I do preliminary test, and it works fine.

