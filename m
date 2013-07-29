From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Mon, 29 Jul 2013 09:28:42 +0200
Message-ID: <51F619AA.1020704@suse.de>
References: <20130719003034.GG28005@kernel.dk> <1374195825.7397.997.camel@haakon3.risingtidesystems.com> <1374215660.7397.1041.camel@haakon3.risingtidesystems.com> <1374248000.2266.20.camel@dabdike> <1374267684.7397.1058.camel@haakon3.risingtidesystems.com> <1374296162.7397.1098.camel@haakon3.risingtidesystems.com> <20130722150359.GA16564@dhcp-26-207.brq.redhat.com> <1374527436.7397.1145.camel@haakon3.risingtidesystems.com> <20130725101641.GB31994@dhcp-26-207.brq.redhat.com> <1374790082.7397.1411.camel@haakon3.risingtidesystems.com> <20130726020928.GL29296@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130726020928.GL29296@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Alexander Gordeev <agordeev@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/26/2013 04:09 AM, Jens Axboe wrote:
> On Thu, Jul 25 2013, Nicholas A. Bellinger wrote:
>> On Thu, 2013-07-25 at 12:16 +0200, Alexander Gordeev wrote:
>>> On Mon, Jul 22, 2013 at 02:10:36PM -0700, Nicholas A. Bellinger wro=
te:
>>>> Np.  FYI, you'll want to use the latest commit e7827b351 HEAD from
>>>> target-pending/scsi-mq, which now has functioning scsi-generic sup=
port.
>>>
>>> Survives a boot, a kernel build and the build's result :)
>>
>> Great.  Thanks for the feedback Alexander!
>>
>> So the next step on my end is to enable -mq for ahci, and verify ini=
tial
>> correctness using QEMU/KVM hardware emulation.
>>
>> Btw, I've been looking at enabling the SHT->cmd_size for struct
>> ata_queued_cmd descriptor pre-allocation, but AFAICT these descripto=
rs
>> are already all pre-allocated by libata and obtained via ata_qc_new(=
) ->
>> __ata_qc_from_tag() during ata_scsi_queuecmd().
>=20
> Might still not be a bad idea to do it:
>=20
> - Cleans up a driver, getting rid of the need to alloc, maintain, and
>   free those structures.
>=20
> - Should be some cache locality benefits to having it all sequential.
>=20
>> So that said, with the struct request + struct scsi_cmnd pre-allocat=
ions
>> already provided by blk-mq -> scsi-mq code, all memory allocations
>> should have already been eliminated from I/O fast path.
>=20
> Nice!
>=20
Hmm.

I'm trying to work out if it would be possible to move multipath
handling over to scsi-mq.
However, when doing so I would need to reconfigure 'nr_hw_queues' on
the fly. Now with all the static cmd preallocation going on this is
going to be tricky.

This leaves me with two choices:
- Tear down the command pool altogether whenever I need to
  reconfigure the device (which is going to be painful)
- Allocate some max nr_hw_queues, and mark the superfluous
  ones as 'unused' or something. Seeing the a sane max nr_hw_queues
  will be possibly the number of cpus this might end up hogging
  quite some memory.

Would you accept patches moving the static command allocation over
to pools or is this a desired feature?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
