From: Hannes Reinecke <hare@suse.de>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Sat, 11 Jun 2016 12:01:38 +0200
Message-ID: <575BE182.5010304@suse.de>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com> <yq160tgfoqr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbcFKKBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2016 06:01:42 -0400
In-Reply-To: <yq160tgfoqr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

On 06/11/2016 04:22 AM, Martin K. Petersen wrote:
>>>>>> "Mike" =3D=3D Mike Snitzer <snitzer@redhat.com> writes:
>
>>> When checking a cloned request there is no need to check the overal=
l
>>> request size; this won't have changed even when resubmitting to
>>> another queue.  Without this patch ppc64le on ibmvfc fails to boot.
>
> Why is the number of sectors in the request bigger than the queue lim=
it?
>
Because we're checking the wrong limit.
blk_queue_get_max_sectors() is checking limits.max_sectors(), but the=20
requests are already fully formed and can extend up to=20
limits.max_hw_sectors().

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
