From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Wed, 12 Feb 2014 08:49:32 +0100
Message-ID: <52FB278C.6090503@suse.de>
References: <1384173897-103836-1-git-send-email-hare@suse.de> <1384173897-103836-3-git-send-email-hare@suse.de> <20140211140148.GA1897@infradead.org> <52FA33B6.9010501@suse.de> <20140212074524.GA4529@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaBLHte (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 02:49:34 -0500
In-Reply-To: <20140212074524.GA4529@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 02/12/2014 08:45 AM, Christoph Hellwig wrote:
> On Tue, Feb 11, 2014 at 03:29:10PM +0100, Hannes Reinecke wrote:
>> Well, _actually_ the cancel_delayed_work should be pointless; I've
>> just added it as a terminal measure here.
>> (It'd actually be an idea to insert a BUG_ON() here ...)
>>
>> Thing is whenever the eh_timeout thingie kicks in we most definitely
>> know there's a command in flight, and hence scsi_command_put()
>> should _never_ be called.
>> Only after eh_abort has finished the command will be returned via
>> scsi_command_put(), but then eh_abort is done for, too, and no item
>> should remain in the workqueue.
>=20
> The issue I saw actually was with a different workqueue, sorry for th=
e
> noise.  I have to say I really hate the generic workqueue workers whi=
ch
> make it almost impossible to debug issues before they hit the actual
> worker function..
>=20
Oh, workqueues are fun, no doubt.

_Especially_ when some poor deluded soul executes I/O from userspace
tasks running with RT priorities.

Handling that properly would be a fitting subject for LSF ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
