From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: out of range LBA using sg_raw
Date: Wed, 8 Mar 2017 22:19:58 +0530
Message-ID: <07493b3c3da0b19a9fa96899cad640f3@mail.gmail.com>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
 <20170308151113.GB27450@infradead.org> <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
 <yq1y3wfhgpn.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1y3wfhgpn.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, March 08, 2017 10:03 PM
> To: Kashyap Desai
> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: Re: out of range LBA using sg_raw
>
> >>>>> "Kashyap" == Kashyap Desai <kashyap.desai@broadcom.com> writes:
>
> Kashyap,
>
> Kashyap> I am just curious to know how badly we have to scrutinize each
> Kashyap> packet before sending to Fast Path as we are in IO path and
> Kashyap> recommend only important checks to be added.
>
> As Christoph pointed out, when the fast path is in use you assume the
role of
> the SCSI device. And therefore it is your responsibility to ensure that
the VD's
> capacity and other relevant constraints are being honored. Just like the
MR
> firmware and any attached disks would.

Martin -

Agree on this point. I am planning to study all possible such sanity in
driver for VD and not trying to fix one specific scenario as described
here.
Do you think fix  in this area is good  for kernel-stable as well  OR just
keep in linux-next as it is not so severe considering real time exposure ?
Trying to understand priority and severity of this issue.

>
> It is a feature that there is no sanity checking in the sg interface.
> The intent is to be able to pass through commands directly to a device
and
> have the device act upon them. Including fail them if they don't make
any
> sense.

Understood as sg_raw is not design to sanity check.

>
> PS. I'm really no fan of the fast path. It's super messy to have the VD
layout
> handled in two different places.
>
> --
> Martin K. Petersen	Oracle Linux Engineering
