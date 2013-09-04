From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Wed, 04 Sep 2013 09:02:31 +0200
Message-ID: <5226DB07.40001@suse.de>
References: <1378105985-79686-1-git-send-email-hare@suse.de> <1378105985-79686-4-git-send-email-hare@suse.de> <52248882.7060109@acm.org> <52248E6C.2060105@suse.de> <5225A83A.7090700@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762016Ab3IDHCg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Sep 2013 03:02:36 -0400
In-Reply-To: <5225A83A.7090700@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>, Mike Christie <michaelc@cs.wisc.edu>

On 09/03/2013 11:13 AM, Bart Van Assche wrote:
> On 09/02/13 15:11, Hannes Reinecke wrote:
>> On 09/02/2013 02:45 PM, Bart Van Assche wrote:
>>> This patch adds several new calls to LLD EH handlers. Is it
>>> guaranteed that these will only be invoked before scsi_remove_host(=
)
>>> has finished ? For more background information, see also "[PATCH]
>>> Make scsi_remove_host() wait until error handling finished"
>>> (http://thread.gmane.org/gmane.linux.scsi/82572/focus=3D82779).
>>>
>> Well, that depends how scsi_remove_host() handles outstanding
>> commands. What happens if you call scsi_remove_host() and there is
>> still I/O in flight? I would assume that any HBA would have to kill
>> any outstanding I/O prior to calling scsi_remove_host() (FC most
>> certainly does this).
>> Which would mean that it'll have to wait for scsi_put_command() to
>> be called for all outstanding commands. And as scsi_put_command()
>> will be called only _after_ our routine runs (see the reasoning
>> above) we should be safe.
>=20
> Hello Hannes,
>=20
> Since fc_remove_host() has to be invoked before scsi_remove_host()
> and since fc_remove_host() changes the port state into
> FC_PORTSTATE_DELETED this means that fc_remote_port_chkready() will
> return DID_NO_CONNECT while scsi_remove_host() is in progress. I
> think this prevents that the SYNCHRONIZE CACHE command submitted by
> sd_remove() reaches SCSI disks over FC since sd_remove() is invoked
> from inside scsi_remove_host(). The SRP transport patch I had posted
> recently makes sure that the SYNCHRONIZE CACHE command submitted by
> sd_remove() reaches the target SCSI disk. This makes me wonder what
> the correct behavior is for SCSI transport drivers - disabling I/O
> before scsi_remove_host() starts or ensuring that I/O is still
> possible while scsi_remove_host() is in progress ? I think the call
> chain is as follows: scsi_remove_host() -> device_del() ->
> bus_remove_device() -> device_release_driver() ->
> __device_release_driver() -> sd_remove() -> sd_shutdown() ->
> sd_sync_cache().
>=20

The actual call chain is
scsi_remove_host() -> scsi_forget_host() -> __scsi_remove_device()
-> device_del() etc.

What's important here is that __scsi_remove_device() sets the state
'SDEV_DEL' and calls blk_cleanup_queue().

So after __scsi_remove_device() no further I/O is possible.
However, prior to setting SDEV_DEL I/O should be perfectly okay, so
one would assume that the SYNCHRONIZE CACHE command should be sent
to the device. USB most certainly does it.

A safe practice, however, would be to ensure that no _other_ I/O can
be sent to the device, ie that all I/O coming in via the request
queue or ioctl should be short-circuited and never hit the device at
all. That's what fc_remote_port_chkready() does.

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
