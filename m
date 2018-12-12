From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] scsi: ufs: add real time/inline crypto support to
 UFS HCD
Date: Tue, 11 Dec 2018 23:40:17 -0800
Message-ID: <20181212074017.GA19904@infradead.org>
References: <20181211094910.GA28288@lvlogina.cadence.com>
 <20181211140643.GA6576@infradead.org>
 <CO2PR07MB24692595C49430F56CE5DAC2C1A60@CO2PR07MB2469.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CO2PR07MB24692595C49430F56CE5DAC2C1A60@CO2PR07MB2469.namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parshuram Raju Thombare <pthombar@cadence.com>
Cc: Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>, jbacik@fb.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 11, 2018 at 06:22:27PM +0000, Parshuram Raju Thombare wrote:
> One reason of using device mapper here is to use existing tools like
> 'dmsetup', otherwise some user space application is needed and may be
> some changes in block layer to pass the crypto information (crypto
> algorithm, key etc) till ufs driver.

Yes, so what?  We also don't use dmsetup to set up TCG OPAL based
encryption either.

> Another reason is supporting multiple UFS devices. I think, as you said
> UFS crypto support can be added by some change in ufs driver and block
> layer glue. But to support multiple UFS crypto devices having different
> crypto configs (crypto algorithms, key size etc), crypto context need to
> be saved per crypto device which may need some changes in block layer code.

I don't think we need device mapper for that.  We can hav the crypto
state hanging off the ufs host, or request_queue if we decide to
implement it generic in the block layer.
