From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Fri, 29 Jul 2016 08:28:11 +0200
Message-ID: <56b894fa-828c-d63b-deda-7188398a1542@suse.de>
References: <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com> <20160725212325.GA23961@redhat.com>
 <1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
 <20160726011607.GA77078@redhat.com> <20160727200939.GA82654@redhat.com>
 <dd513a39-eb62-cc3c-d214-e4eca5e65a4e@sandisk.com>
 <20160728133346.GA12272@redhat.com>
 <67c286b3-d3c9-9074-2c1a-e90383511fc6@sandisk.com>
 <20160728154022.GA12911@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbcG2G2N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2016 02:28:13 -0400
In-Reply-To: <20160728154022.GA12911@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/28/2016 05:40 PM, Mike Snitzer wrote:
> On Thu, Jul 28 2016 at 11:23am -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>=20
>> On 07/28/2016 06:33 AM, Mike Snitzer wrote:
[ .. ]
>=20
> Reality is I just need a testbed to reproduce.  This back and forth
> isn't really helping us converge on _why_ must_push_back() is returni=
ng
> false for your case.  I need to know what exactly is causing that met=
hod
> to return false in your case.
>=20
> As is, hard to see why blk-mq vs .request_fn interface for DM mpath
> device would cause must_push_back() to return false vs true.
>=20
I wonder if that isn't the same issue I've seen (and tried to discuss a=
t
LSF), hitting the printk in  blk_cloned_rq_check_limits().
If I would hazard a guess I'd say that the queue limits become
temporarily invalidated during failover, and we're managing to submit a=
n
I/O at just that time.

I am currently working on getting FCoE to run over virtio; if that work=
s
we should be a good synthetic testbed for reproducing.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
