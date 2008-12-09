From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] remove ide-scsi
Date: Tue, 09 Dec 2008 15:07:34 -0500
Message-ID: <493ED006.7020201@garzik.org>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	 <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna>	 <200812062241.35601.bzolnier@gmail.com>	 <20081206222423.04aada70@lxorguk.ukuu.org.uk>	 <493B022B.3050406@ru.mvista.com> <493B0A8E.7000506@garzik.org>	 <493B0DF2.4090901@ru.mvista.com> <493B0F36.6030509@garzik.org> <86802c440812061936v4629857ehbd2705e389e4378b@mail.gmail.com> <493B4E52.6080905@garzik.org> <493ECE2D.8080404@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493ECE2D.8080404@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Yinghai Lu <yinghai@kernel.org>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?UTF-8?B?RGFuIE5vw6k=?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>> Yinghai Lu wrote:
>>> On Sat, Dec 6, 2008 at 3:48 PM, Jeff Garzik <jeff@garzik.org> wrote:
> ..
>>> interesting, so will get /dev/ada instead of /dev/sda?
>>
>> That is an interesting question.  The easiest thing is to allocate a 
>> new 32-bit block major.  But the more compatible (and more 
>> controversial) solution is to allocate from the SCSI disk blkmajor space.
> ..
> 
> Perhaps "sdx" and "scdx" should simply be redefined as "System disk"
> and "System CD", and moved under block layer ownership from SCSI ?

Yes, precisely.  SCSI and libata (and others) would allocate disk/MMC 
majors from the block layer.

The biggest problem with this plan is that it introduces a mismatch in 
ioctl capabilities, a behavior change from the current situation where 
SCSI exports SCSI_IOCTL_SEND_COMMAND in addition to the more universal 
SG_IO.  Installers and existing clients may rely on this portion of the 
Linux application ABI.

	Jeff



