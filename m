From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V2 4/8] block: null_blk: introduce module parameter of
 'g_global_tags'
Date: Mon, 5 Feb 2018 20:26:33 +0000
Message-ID: <892b0510b3254668a1a1e5c5fb2f84c2@microsemi.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180205152035.15016-5-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> This patch introduces the parameter of 'g_global_tags' so that we can
> test this feature by null_blk easiy.
>=20
> Not see obvious performance drop with global_tags when the whole hw
> depth is kept as same:
>=20
> 1) no 'global_tags', each hw queue depth is 1, and 4 hw queues
> modprobe null_blk queue_mode=3D2 nr_devices=3D4 shared_tags=3D1 global_ta=
gs=3D0
> submit_queues=3D4 hw_queue_depth=3D1
>=20
> 2) 'global_tags', global hw queue depth is 4, and 4 hw queues
> modprobe null_blk queue_mode=3D2 nr_devices=3D4 shared_tags=3D1 global_ta=
gs=3D1
> submit_queues=3D4 hw_queue_depth=3D4
>=20
> 3) fio test done in above two settings:
>    fio --bs=3D4k --size=3D512G  --rw=3Drandread --norandommap --direct=3D=
1 --
> ioengine=3Dlibaio --iodepth=3D4 --runtime=3D$RUNTIME --group_reporting=3D=
1  --
> name=3Dnullb0 --filename=3D/dev/nullb0 --name=3Dnullb1 --filename=3D/dev/=
nullb1 --
> name=3Dnullb2 --filename=3D/dev/nullb2 --name=3Dnullb3 --filename=3D/dev/=
nullb3
>=20
> 1M IOPS can be reached in both above tests which is done in one VM.
>=20
I am getting 1.1M IOPS for both cases.

Tested-by: Don Brace <don.brace@microsemi.com>
