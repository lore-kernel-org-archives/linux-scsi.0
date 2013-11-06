From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Wed, 06 Nov 2013 07:48:46 +0100
Message-ID: <5279E64E.8040005@suse.de>
References: <1383635145-112651-1-git-send-email-hare@suse.de> <1383635145-112651-3-git-send-email-hare@suse.de> <527944BF.9000507@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3KFGsv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Nov 2013 01:48:51 -0500
In-Reply-To: <527944BF.9000507@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 11/05/2013 08:19 PM, Mike Christie wrote:
> On 11/04/2013 11:05 PM, Hannes Reinecke wrote:
>> +
>> +	scmd->eh_eflags |=3D SCSI_EH_ABORT_SCHEDULED;
>> +	SCSI_LOG_ERROR_RECOVERY(3,
>> +		scmd_printk(KERN_INFO, scmd,
>> +			    "scmd %p abort scheduled\n", scmd));
>> +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
>> +	return SUCCESS;
>> +}
>=20
> Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM set?
>=20
Errm. Yes, why?

I must admit I'm not _that_ familiar with workqueues ...
Care to explain?

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
