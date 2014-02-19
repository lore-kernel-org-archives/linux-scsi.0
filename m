From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/16] scsi_dh_alua: Make stpg synchronous
Date: Wed, 19 Feb 2014 09:09:29 +0100
Message-ID: <530466B9.3060903@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-5-git-send-email-hare@suse.de> <52F435B3.3090600@cs.wisc.edu> <52F43CD7.5050900@cs.wisc.edu> <52FB9353.7040807@suse.de> <52FB9D20.5060900@cs.wisc.edu> <52FBA0D3.50907@cs.wisc.edu> <52FBAFDE.4060104@cs.wisc.edu> <52FC90F6.7020005@suse.de> <52FDFFF8.8030507@acm.org> <52FE5EA5.3020905@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaBSIJb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Feb 2014 03:09:31 -0500
In-Reply-To: <52FE5EA5.3020905@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/14/2014 07:21 PM, Mike Christie wrote:
> On 2/14/14 5:37 AM, Bart Van Assche wrote:
[ .. ]
>> I think this will only be sufficient if there are more CPU threads
>> available than the number of LUNs for which an STPG has to be issued=
=2E
>=20
> Ah shoot, you reminded me of some other issue. With the above
> command we only can do 1 unit of work at a time. With the
> alloc_workqueue example I sent in the other mail, I think it would
> create a new problem.
>=20
> alloc_workqueue with max_active=3D0 looks like it has the wq code
> dynamically create worker threads as needed, so with that we could
> end up with a lot of threads and can failover lots of devices (512
> with the current max) in parallel. The threads will even get reaped
> when they are not needed. However, trying to create lots of threads
> at failover time might have issues, and in general creating 32 or 64
> threads or more is probably not something we want to do.

Another followup: Mike is, as usual, right.
I need to use 'alloc_workqueue' to be able to have more than one
worker at a time.
And also Bart is right in that it makes sense to have STPG run
asynchronously.

However, in doing so I'll be bunching together STPG activations from
several request_queues, and will be deferring I/O on those
queues during STPG update.
So to avoid stalled I/O I'll need to kick each of the queues again
after STPG is finished, right?

Hmm. Let's see how this will look like.

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
