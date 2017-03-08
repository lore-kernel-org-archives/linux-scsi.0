From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: out of range LBA using sg_raw
Date: Wed, 8 Mar 2017 21:29:28 +0530
Message-ID: <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com> <20170308151113.GB27450@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170308151113.GB27450@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, March 08, 2017 8:41 PM
> To: Kashyap Desai
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: out of range LBA using sg_raw
>
> Hi Kashyap,
>
> for SG_IO passthrough requests we can't validate command validity for
> commands as the block layer treats them as opaque.  The SCSI device
> implementation needs to handle incorrect parameter to be robust.
>
> For your fast path bypass the megaraid driver assumes part of the SCSI
device
> implementation, so it will have to check for validity.

Thanks Chris. It is understood to have sanity in driver, but how critical
such checks where SG_IO type interface send pass-through request. ?
Are you suggesting as good to have sanity or very important as there may
be a real-time exposure other than SG_IO interface ? I am confused over
must or good to have check.
Also one more fault I can generate using below sg_raw command -

"sg_raw -r 32k /dev/sdx 28 00 01 4f ff ff 00 00 08 00"

Provide more scsi data length compare to actual SG buffer. Do you suggest
such SG_IO interface vulnerability is good to be captured in driver.

I am just curious to know how badly we have to scrutinize each packet
before sending to Fast Path  as we are in IO path and recommend only
important checks to be added.

Thanks, Kashyap
