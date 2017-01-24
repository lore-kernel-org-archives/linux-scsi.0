From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 15/16] block: split scsi_request out of struct request
Date: Tue, 24 Jan 2017 00:33:13 +0000
Message-ID: <1485217979.2825.20.camel@sandisk.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
         <1485185361-29786-16-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr710065.outbound.protection.outlook.com ([40.107.71.65]:38304
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750715AbdAXAdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 19:33:22 -0500
In-Reply-To: <1485185361-29786-16-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <DE07B1801DA8AA49951F536F7A0BF03B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>

On Mon, 2017-01-23 at 16:29 +0100, Christoph Hellwig wrote:
> @@ -251,11 +251,13 @@ static int __scsi_execute(struct scsi_device *sdev,=
 const unsigned char *cmd,
> =A0=A0=A0=A0=A0=A0=A0=A0 * is invalid.=A0 Prevent the garbage from being =
misinterpreted
> =A0=A0=A0=A0=A0=A0=A0=A0 * and prevent security leaks by zeroing out the =
excess data.
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0if (unlikely(req->resid_len > 0 && req->resid_len <=
=3D bufflen))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memset(buffer + (bufflen - =
req->resid_len), 0, req->resid_len);
> +=A0=A0=A0=A0=A0=A0=A0if (unlikely(rq->resid_len > 0 && rq->resid_len <=
=3D bufflen))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memset(buffer + (bufflen - =
rq->resid_len), 0, rq->resid_len);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (resid)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*resid =3D req->resid_len;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*resid =3D rq->resid_len;
> +=A0=A0=A0=A0=A0=A0=A0if (rq->sense_len)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memcpy(sense, rq->sense, SC=
SI_SENSE_BUFFERSIZE);
> =A0=A0=A0=A0=A0=A0=A0=A0ret =3D req->errors;
> =A0 out:
> =A0=A0=A0=A0=A0=A0=A0=A0blk_put_request(req);

Hello Christoph,

Do we perhaps need a check before the above memcpy() call whether or not
sense =3D=3D NULL?

Thanks,

Bart.=
