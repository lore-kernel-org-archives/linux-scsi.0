From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v5 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Tue, 25 Apr 2017 22:06:24 +0000
Message-ID: <1493157983.2628.24.camel@sandisk.com>
References: <20170425203745.19946-1-bart.vanassche@sandisk.com>
         <20170425203745.19946-11-bart.vanassche@sandisk.com>
         <20170425213956.GD6361@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170425213956.GD6361@vader>
Content-Language: en-US
Content-ID: <129C9A9C107CC8469DF773751F3E326F@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "osandov@osandov.com" <osandov@osandov.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.com" <hare@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-04-25 at 14:39 -0700, Omar Sandoval wrote:
> On Tue, Apr 25, 2017 at 01:37:45PM -0700, Bart Van Assche wrote:
> > Show the SCSI CDB, .eh_eflags and .result for pending SCSI commands
> > in /sys/kernel/debug/block/*/mq/*/dispatch and */rq_list.
>=20
> Only thing I noticed was that the only other caller I see has buf[70].
> No idea if that's a meaningful number. For the sake of this not getting
> bike-shedded to death,

Neither length is sufficient to avoid truncation of e.g. ATA pass-through
commands or commands with variable length CDBs. However, from the point of
view of debugging queue lockups the most useful information in a SCSI
command are the first two bytes of the CDB. The chosen buffer length is
definitely enough to make sure that these two bytes will be reported.

Bart.=
