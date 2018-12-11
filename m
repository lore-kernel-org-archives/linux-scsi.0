From: Parshuram Raju Thombare <pthombar@cadence.com>
Subject: RE: [PATCH 0/2] scsi: ufs: add real time/inline crypto support to UFS
 HCD
Date: Tue, 11 Dec 2018 18:22:27 +0000
Message-ID: <CO2PR07MB24692595C49430F56CE5DAC2C1A60@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <20181211094910.GA28288@lvlogina.cadence.com>
 <20181211140643.GA6576@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181211140643.GA6576@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>, "jbacik@fb.com" <jbacik@fb.com>, michaelcallahan@fb.c
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

Thank you for comments.
My comments are inline below.

Regards,
Parshuram Thombare

>-----Original Message-----
>From: Christoph Hellwig <hch@infradead.org>
>Sent: Tuesday, December 11, 2018 7:37 PM
>To: Parshuram Raju Thombare <pthombar@cadence.com>
>Cc: axboe@kernel.dk; vinholikatti@gmail.com; jejb@linux.vnet.ibm.com;
>martin.petersen@oracle.com; mchehab+samsung@kernel.org;
>gregkh@linuxfoundation.org; davem@davemloft.net; akpm@linux-
>foundation.org; nicolas.ferre@microchip.com; arnd@arndb.de; linux-
>kernel@vger.kernel.org; linux-block@vger.kernel.org; linux-
>scsi@vger.kernel.org; tj@kernel.org; jbacik@fb.com; michaelcallahan@fb.com=
;
>snitzer@redhat.com; osandov@fb.com; keith.busch@intel.com;
>ming.lei@redhat.com; shli@fb.com; dennisszhou@gmail.com; Alan Douglas
><adouglas@cadence.com>; Janek Kotas <jank@cadence.com>; Rafal Ciepiela
><rafalc@cadence.com>
>Subject: Re: [PATCH 0/2] scsi: ufs: add real time/inline crypto support to=
 UFS HCD
>
>EXTERNAL MAIL
>
>
>Patch 1 is missing in your series.
>
>But even without looking at it I think your design doesn't make a whole lo=
t of
>sense.  If the encryption is implemented in the ufs driver you should not =
need
>device mapper support for it, just ufs driver support and maybe a little b=
lock layer
>glue.
[PATCH 1/2]  does nothing more than adding variable in 'struct bio'.=20
Here is link of it.
https://lkml.org/lkml/2018/12/11/193
One reason of using device mapper here is to use existing tools like 'dmset=
up', otherwise=20
some user space application is needed and may be some changes in block laye=
r to=20
pass the crypto information (crypto algorithm, key etc) till ufs driver.
Another reason is supporting multiple UFS devices. I think, as you said UFS=
 crypto support
can be added by some change in ufs driver and block layer glue. But to supp=
ort
multiple UFS crypto devices having different crypto configs (crypto algorit=
hms, key size etc),
crypto context need to be saved per crypto device which may need some chang=
es in block layer code.
