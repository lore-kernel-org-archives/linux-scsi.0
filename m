From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Thu, 07 Nov 2013 07:42:49 +0100
Message-ID: <527B3669.307@suse.de>
References: <1383635145-112651-1-git-send-email-hare@suse.de> <1383635145-112651-3-git-send-email-hare@suse.de> <527944BF.9000507@cs.wisc.edu> <20131106144713.GA26551@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236Ab3KGGm4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Nov 2013 01:42:56 -0500
In-Reply-To: <20131106144713.GA26551@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 11/06/2013 03:47 PM, Christoph Hellwig wrote:
> On Tue, Nov 05, 2013 at 11:19:27AM -0800, Mike Christie wrote:
>>> +	scmd->eh_eflags |=3D SCSI_EH_ABORT_SCHEDULED;
>>> +	SCSI_LOG_ERROR_RECOVERY(3,
>>> +		scmd_printk(KERN_INFO, scmd,
>>> +			    "scmd %p abort scheduled\n", scmd));
>>> +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
>>> +	return SUCCESS;
>>> +}
>>
>> Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM set?
>=20
> That's probably required, I can think of all kinds of issues otherwis=
e.
>=20
> Not in this patch series, but in the near future it might make sense=20
> to convert the whole EH thread to that workqueue.
>=20
And given the recent issues we had with RT scheduling I guess this
is the way to go.

_After_ this patchset gets in, that is ...

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
