From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi-mq performance check
Date: Fri, 18 Dec 2015 16:08:24 +0100
Message-ID: <56742168.6030200@suse.de>
References: <56741F04.3070506@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbbLRPI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 10:08:26 -0500
In-Reply-To: <56741F04.3070506@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, bart.vanassche@sandisk.com, hch@infradead.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/18/2015 03:58 PM, John Garry wrote:
> Hi,
>
> I have started to enable scsi-mq on the HiSilicon SAS driver.
>
> Are there hints/checks I should use to make sure it is configured
> correctly/optimally? In my initial testing I have seen some
> performance improvements, but none like what I have seen in
> presentations.
>
The whole thing is build around having symmetric submit and receive=20
queues, so that we can tack a send/receive queue pair to the same=20
CPU. With that we can ensure that we don't have any cache=20
invalidation, as the request is already in the cache for that CPU=20
when the completion is recieved. _And_ we can get rid of most=20
spinlocks as other CPUs cannot access our request.

So make sure to have the submit and receive queues properly done,=20
and ensure you don't have any global resources within your driver=20
which needs to be locked. Or move access to those resources out of=20
the fast path.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
