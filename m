From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
Date: Thu, 13 Dec 2018 13:11:58 -0700
Message-ID: <6309baec-bb1f-4986-6872-a70047fbc469@kernel.dk>
References: <20181211095027.GA3316@lvlogina.cadence.com>
 <20181211181647.GC221175@gmail.com>
 <CO2PR07MB2469AD9C0A121EBF94129A11C1A70@CO2PR07MB2469.namprd07.prod.outlook.com>
 <BD7FB879CC136E419544C8E2AE7B9C30227EE5@IN01WEMBXA.internal.synopsys.com>
 <fb17d794-c682-3261-cbad-94ce4c14eea1@kernel.dk>
 <BD7FB879CC136E419544C8E2AE7B9C30227F0B@IN01WEMBXA.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BD7FB879CC136E419544C8E2AE7B9C30227F0B@IN01WEMBXA.internal.synopsys.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ladvine D Almeida <ladvine.dalmeida@synopsys.com>, Parshuram Raju Thombare <pthombar@cadence.com>, Eric Biggers <ebiggers@kernel.org>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Douglas <adouglas@cadence.com>, Janek Kotas <jank@cadence.com>, Rafal Ciepiela <rafalc@cadence.com>, AnilKumar
List-Id: linux-scsi@vger.kernel.org

On 12/13/18 1:04 PM, Ladvine D Almeida wrote:
> On 13/12/18 7:42 PM, Jens Axboe wrote:
>> On 12/13/18 12:39 PM, Ladvine D Almeida wrote:
>>> Suggest to take a look into the article https://urldefense.proofpoint.com/v2/url?u=https-3A__lwn.net_Articles_717754&d=DwICaQ&c=DPL6_X_6JkXFx7AXWqB0tg&r=z00zRD9ARrwHpe-XSl1OtUp1uNKGYoXI1G2DhOaDDBI&m=-pGzV3wdSje337vKOYoYB6NgU_DGDmQvfQ9egLDRYNQ&s=c4FXsrwD0BLAjE4UC47R2ngLnx_DP5jiOr0dtZ7tGsw&e=
>>> My real concern is how to achieve it without any modifications to the
>>> bio.(because key slot information has to finally reach the target block
>>> device)
>>
>> Guys, you both need to edit when you reply, wading through 650 lines of
>> text to get to this...
> Jens, Thanks for your reply. I will take care of it next time onwards. :-)
> 
>>
>> You obviously can't modify the bio if you don't own it, but you could
>> clone it and then you have storage in ->bi_private.
>>
> 
> I agree. I can clone the bio in the crypto target and use bi_private.
> But, when i finally submit the bio and it reaches the target block
> device, the information stored in bi_private is lost.

I don't follow, what do you mean it's lost? It's persistent from
bio setup to end_io time.

-- 
Jens Axboe
