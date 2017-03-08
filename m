From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: out of range LBA using sg_raw
Date: Wed, 08 Mar 2017 11:32:36 -0500
Message-ID: <yq1y3wfhgpn.fsf@oracle.com>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
        <20170308151113.GB27450@infradead.org>
        <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com> (Kashyap
        Desai's message of "Wed, 8 Mar 2017 21:29:28 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Kashyap" == Kashyap Desai <kashyap.desai@broadcom.com> writes:

Kashyap,

Kashyap> I am just curious to know how badly we have to scrutinize each
Kashyap> packet before sending to Fast Path as we are in IO path and
Kashyap> recommend only important checks to be added.

As Christoph pointed out, when the fast path is in use you assume the
role of the SCSI device. And therefore it is your responsibility to
ensure that the VD's capacity and other relevant constraints are being
honored. Just like the MR firmware and any attached disks would.

It is a feature that there is no sanity checking in the sg interface.
The intent is to be able to pass through commands directly to a device
and have the device act upon them. Including fail them if they don't
make any sense.

PS. I'm really no fan of the fast path. It's super messy to have the VD
layout handled in two different places.

-- 
Martin K. Petersen	Oracle Linux Engineering
