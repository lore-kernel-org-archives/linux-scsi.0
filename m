From: Andy Warner <andyw@pobox.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Wed, 4 Oct 2006 14:31:54 -0500
Message-ID: <20061004143154.A29888@florence.linkmargin.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com> <20061004132929.A29689@florence.linkmargin.com> <452415AE.7030202@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:19645 "EHLO
	ms-smtp-01.rdc-kc.rr.com") by vger.kernel.org with ESMTP
	id S1751084AbWJDUcE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 16:32:04 -0400
Content-Disposition: inline
In-Reply-To: <452415AE.7030202@us.ibm.com>; from djwong@us.ibm.com on Wed, Oct 04, 2006 at 01:12:30PM -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andy Warner <andyw@pobox.com>, Muli Ben-Yehuda <muli@il.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Darrick J. Wong wrote:
> Andy Warner wrote:
> 
> > So you are seeing legitimate REQ_TASK_ABORT values, but need to look
> > at the remaining data to see what the chip is trying to tell you.
> > For REQ_TASK_ABORT, status_block[1..2] is the transaction context,
> > and status_block[3] is the reason (TC_NO_ERROR etc from aic94xx_sas.h)
> 
> Funny, I've been trying to write at least a REQ_TASK_ABORT handler all
> week.  I'm having a bit of trouble using the transaction context...
> mostly because the value I'm getting doesn't correspond to any ascb.
> Assuming, of course, that ascb->scb->header.index/ascb->tc_index are
> indeed transaction contexts.

Check you're actually getting REQ_TASK_ABORT, and not
REQ_DEVICE_RESET or SIGNAL_NCQ_ERROR, where the same
field is a connection handle, and not a transaction
context.
-- 
andyw@pobox.com

Andy Warner		Voice: (612) 801-8549	Fax: (208) 575-5634
