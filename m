From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 15/16] block: split scsi_request out of struct request
Date: Tue, 24 Jan 2017 16:31:13 +0000
Message-ID: <1485275452.2715.1.camel@sandisk.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
         <1485185361-29786-16-git-send-email-hch@lst.de>
         <1485217979.2825.20.camel@sandisk.com> <20170124080906.GA17018@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170124080906.GA17018@lst.de>
Content-Language: en-US
Content-ID: <EABAE667807EDF4AAF19379711328B3A@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-01-24 at 09:09 +0100, hch@lst.de wrote:
> On Tue, Jan 24, 2017 at 12:33:13AM +0000, Bart Van Assche wrote:
> > Do we perhaps need a check before the above memcpy() call whether or no=
t
> > sense =3D=3D NULL?
>=20
> Yes, probably.  I didn't think of the case where the caller wouldn't
> pass a sense buffer.  Just curious, what's the callstack that caused
> this?

Hello Christoph,

The call stack was as follows:
* __scsi_execute()
* scsi_execute_req_flags()
* scsi_vpd_inquiry()
* scsi_attach_vpd()
* scsi_probe_and_add_lun()
* __scsi_add_device()
* ata_scsi_scan_host()
* async_port_probe()
* async_run_entry_fn()
* process_one_work()
* worker_thread()
* kthread()

Bart.=
