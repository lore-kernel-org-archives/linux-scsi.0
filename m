From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Tue, 11 Jul 2017 15:46:53 +0000
Message-ID: <1499788012.2586.12.camel@wdc.com>
References: <20170616082755.22832-1-hch@lst.de>
         <1499701840.3555.7.camel@wdc.com>
         <e3c07504-8538-f2f3-003a-01b72e0c07c6@huawei.com>
         <1499779970.3345.1.camel@wdc.com>
         <4cf7ed21-7cf4-a91a-8beb-ba5f92e4eaaf@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23754 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933520AbdGKPq4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 11:46:56 -0400
In-Reply-To: <4cf7ed21-7cf4-a91a-8beb-ba5f92e4eaaf@huawei.com>
Content-Language: en-US
Content-ID: <A4E997D4D6AD274A8D03DDECBA94438D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "linuxarm@huawei.com" <linuxarm@huawei.com>

On Tue, 2017-07-11 at 15:14 +0100, John Garry wrote:
> On 11/07/2017 14:32, Bart Van Assche wrote:
> > On Tue, 2017-07-11 at 11:22 +0100, John Garry wrote:
> > > On 10/07/2017 16:50, Bart Van Assche wrote:
> > > > Since a fix for the performance regression triggered by this patch =
will be upstream
> > > > soon (see also https://git.kernel.org/pub/scm/linux/kernel/git/axbo=
e/linux-block.git/commit/?h=3Dfor-linus&id=3D32825c45ff8f4cce937ab85b030dc6=
93ceb1aa0a):
> > > >=20
> > >=20
> > > FYI, on linux-next 20170711 (which now includes the above patch Bart
> > > mentioned) we see a large performance regression on hisi_sas (LLDD do=
es
> > > not config shost for mq).
> > >=20
> > > fio read mode iops goes from ~833K (scsi_mod.use_blk_mq=3Dn on cmdlin=
e) to
> > > ~320K
> >=20
> > Hello John,
> >=20
> > Thanks for the feedback. Is the kernel config with which these measurem=
ents
> > were performed available somewhere?
>=20
> It is the default arm64 defconfig with the following changes:
> CONFIG_ARM_SMMU_V3=3Dn
> CONFIG_9P_FS=3Dn
>=20
> We were getting a compile error in the 9p fs code, so disabled it.=20
> Turning on the IOMMU drops performance across the board for our=20
> platform, so just disabling it for the test.

Hello John,

What block driver controls the block device for which the performance regre=
ssion
has been observed? How many hardware queues were created by that block driv=
er
(see also /sys/block/*/mq/...)? I'm asking this because the number of hardw=
are
queues controls which I/O scheduler is selected as default. From block/elev=
ator.c:

		if (q->mq_ops) {
			if (q->nr_hw_queues =3D=3D 1)
				e =3D elevator_get("mq-deadline", false);
			if (!e)
				return 0;
		} else
			e =3D elevator_get(CONFIG_DEFAULT_IOSCHED, false);

Bart.=
