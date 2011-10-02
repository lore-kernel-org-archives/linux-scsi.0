From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFT PATCH] libsas: fix port->dev_list locking
Date: Sun, 02 Oct 2011 12:18:53 -0500
Message-ID: <1317575933.5067.7.camel@dabdike.int.hansenpartnership.com>
References: <20110922050125.32188.27056.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57778 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596Ab1JBRS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Oct 2011 13:18:56 -0400
In-Reply-To: <20110922050125.32188.27056.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>, Mark Salyzyn <msalyzyn@us.xyratex.com>, Christoph Hellwig <hch@lst.de>, Luben Tuikov <ltuikov@yahoo.com>, Jack Wang <jack_wang@usish.com>

On Wed, 2011-09-21 at 22:05 -0700, Dan Williams wrote:
> port->dev_list maintains a list of devices attached to a given sas root port.
> It needs to be mutated under a lock as contexts outside of the
> single-threaded-libsas-workqueue access the list via sas_find_dev_by_rphy().
> Fixup locations where the list was being mutated without a lock.
> 
> This is a follow-up to commit 5911e963 "[SCSI] libsas: remove expander
> from dev list on error", where Luben noted [1]:
> 
>     > 2/ We have unlocked list manipulations in sas_ex_discover_end_dev(),
>     > sas_unregister_common_dev(), and sas_ex_discover_end_dev()
> 
>     Yes, I can see that and that is very unfortunate.
> 
> [1]: http://marc.info/?l=linux-scsi&m=131480962006471&w=2

Since this call for testing was issued 11 days ago, did anyone actually
test this patch?

James


