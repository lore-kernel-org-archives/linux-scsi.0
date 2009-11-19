From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH V2] libata: add TRIM support
Date: Wed, 18 Nov 2009 22:36:52 -0500
Message-ID: <4B04BD54.7020203@rtr.ca>
References: <20091117150047.GB10748@infradead.org> <4B031D2F.7030004@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B031D2F.7030004@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> On 11/17/2009 10:00 AM, Christoph Hellwig wrote:
>> Add support for the ATA TRIM command in libata.  We translate a WRITE 
>> SAME 16
>> command with the unmap bit set into an ATA TRIM command and export enough
>> information in READ CAPACITY 16 and the block limits EVPD page so that 
>> the new
>> SCSI layer discard support will driver this for us.
>>
>> Note that I hardcode the WRITE_SAME_16 opcode for now as the patch to 
>> introduce
>> the symbolic is not in 2.6.32 yet but only in the SCSI tree - as soon 
>> as it is
>> merged we can fix it up to properly use the symbolic name.
>>
>> Signed-off-by: Christoph Hellwig<hch@lst.de>
> 
> Looks good to me....  will apply to libata-dev.git#upstream soonish
..

Just make sure that no filesystem tries to use it by default.
The performance penalty from this is absolutely massive.

At least until the interface can do multiple trim ranges
per single trim command.

Cheers
