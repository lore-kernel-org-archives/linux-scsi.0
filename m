From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v2 PATCH 0/19] A kernel-level configfs enabled generic
	target engine for Linux v2.6.32
Date: Fri, 18 Sep 2009 19:07:08 -0700
Message-ID: <1253326028.4498.194.camel@haakon2.linux-iscsi.org>
References: <1253311656.4498.143.camel@haakon2.linux-iscsi.org>
	 <1253322925.6699.8.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.206.160]:40147 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754227AbZISCHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 22:07:07 -0400
In-Reply-To: <1253322925.6699.8.camel@desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>

On Fri, 2009-09-18 at 18:15 -0700, Daniel Walker wrote:
> On Fri, 2009-09-18 at 15:07 -0700, Nicholas A. Bellinger wrote:
> > Greetings all,
> > 
> > This is the second round of request for comments for TCM/ConfigFS v3.2
> > from lio-core-2.6.git.
> > Thanks to the folks who made comments, and I again invite people to
> > take a look and make
> > recommendations on how the code can be futher improved to use the best
> > available upstream
> > interfaces.
> 
> There are still a couple of minor checkpatch errors in the series, but
> it's nothing you would need to resubmit because of ..
> 
> In patch 2 the following are fixable,
> 
> ERROR: return is not a function, parentheses are not required
> #3401: FILE: include/target/configfs_macros.h:104:
> +       return((ci) ? container_of(to_config_group(ci), struct _item,   \
> 
> ERROR: trailing whitespace
> #3438: FILE: include/target/configfs_macros.h:141:
> +CONFIGFS_EATTR_OPS_STORE(_name, _item);^I$
> 
> 
> and in Patch 18, and 19 there are a couple more whitespace related
> errors you could fix..
> 

Ok, commited these checkpatch fixes:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=65808529e0ed76308842c87faccf4526fa8bb13d

Also, it looks like configfs_macros.h is triggering the same checkpatch
false-positive as target_core_configfs.c:

configfs_macros.h:138: ERROR: Macros with multiple statements should be enclosed in a do - while loop
configfs_macros.h:143: ERROR: Macros with multiple statements should be enclosed in a do - while loop

This is the case where macros with multiple statements exist containing
function defintions, which obviously cannot be included in a do {} while
loop.

Thanks Daniel,

--nab


> Daniel
> 


