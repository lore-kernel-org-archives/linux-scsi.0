From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: blk-mq: remove the error argument to blk_mq_complete_request
Date: Tue, 18 Apr 2017 22:50:18 +0000
Message-ID: <1492555816.2689.20.camel@sandisk.com>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
         <20170418155229.5977-16-hch@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2842 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdDRWuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 18:50:22 -0400
In-Reply-To: <20170418155229.5977-16-hch@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <3EECDC48C4D82149A0C82A3ED9F3A01A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, 2017-04-18 at 08:52 -0700, Christoph Hellwig wrote:
> Now that we always have a ->complete callback we can remove the direct
> call to blk_mq_end_request, as well as the error argument to
> blk_mq_complete_request.

Hello Christoph,

Please add a runtime check that issues a warning early if a .complete
callback function is missing.

Are you sure that all blk-mq drivers have a .complete callback? In the
request-errors branch of your block git tree I found the following:

static const struct blk_mq_ops rbd_mq_ops =3D {
	.queue_rq	=3D rbd_queue_rq,
	.init_request	=3D rbd_init_request,
};

static const struct blk_mq_ops ubiblock_mq_ops =3D {
	.queue_rq=A0=A0=A0=A0=A0=A0=A0=3D ubiblock_queue_rq,
	.init_request	=3D ubiblock_init_request,
};

Thanks,

Bart.=
