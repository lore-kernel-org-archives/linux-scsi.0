From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Mon, 17 Jun 2013 09:14:56 +0200
Message-ID: <51BEB770.9030305@suse.de>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org> <51BA20ED.6040200@mellanox.com> <51BB1857.7040802@acm.org> <51BB5A04.3080901@mellanox.com> <51BC3945.9030900@acm.org> <51BEAA40.9070908@suse.de> <51BEB4FF.9000607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab3FQHO7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jun 2013 03:14:59 -0400
In-Reply-To: <51BEB4FF.9000607@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vu Pham <vuhuong@mellanox.com>, Roland Dreier <roland@kernel.org>, David Dillow <dillowda@ornl.gov>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On 06/17/2013 09:04 AM, Bart Van Assche wrote:
> On 06/17/13 08:18, Hannes Reinecke wrote:
>> On 06/15/2013 11:52 AM, Bart Van Assche wrote:
[ .. ]
>>>
>>> I think the advantage of multipathd recognizing the SDEV_BLOCK stat=
e
>>> before the fast_io_fail_tmo timer has expired is important.
>>> Multipathd does not queue I/O to paths that are in the SDEV_BLOCK
>>> state so setting that state helps I/O to fail over more quickly,
>>> especially for large values of fast_io_fail_tmo.
>>>
>> Sadly it doesn't work that way.
>>
>> SDEV_BLOCK will instruct multipath to not queue _new_ I/Os to the
>> path, but there still will be I/O queued on that path.
>> For these multipath _has_ to wait for I/O completion.
>> And as it turns out, in most cases the application itself will wait
>> for completion on these I/O before continue sending more I/O.
>> So in effect multipath would queue new I/O to other paths, but won't
>> _receive_ new I/O as the upper layers are still waiting for
>> completion of the queued I/O.
>>
>> The only way to excite fast failover with multipathing is to set
>> fast_io_fail to a _LOW_ value (eg 5 seconds), as this will terminate
>> the outstanding I/Os.
>>
>> Large values of fast_io_fail will almost guarantee sluggish I/O
>> failover.
>=20
> Hello Hannes,
>=20
> I agree that the value of fast_io_fail_tmo should be kept small.
> Although as you explained changing the SCSI device state into
> SDEV_BLOCK doesn't help for I/O that has already been queued on a
> failed path, I think it's still useful for I/O that is queued after
> the fast_io_fail timer has been started and before that timer has
> expired.
>=20
Why, but of course.

The typical scenario would be:
-> detect link-loss
-> call scsi_block_request()
-> start dev_loss_tmo and fast_io_fail_tmo

-> When fast_io_fail_tmo triggers:
   -> Abort all outstanding requests

-> When dev_loss_tmo triggers:
   -> Abort all outstanding requests
   -> Remove/disable the I_T nexus
   -> call scsi_unblock_request()

However, if and whether multipath detects SDEV_BLOCK doesn't
guarantee a fast failover; in fact is was only added rather recently
as it's not a big win in most cases.

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
