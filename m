From: Brad Campbell <brad@wasp.net.au>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 20:37:55 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412E11E3.9050207@wasp.net.au>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wasp.net.au ([203.190.192.17]:59533 "EHLO wasp.net.au")
	by vger.kernel.org with ESMTP id S269162AbUHZQhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 12:37:19 -0400
In-Reply-To: <8746466a0408260852205a7842@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: Dave <dave.jiang@gmail.com>
Cc: linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>

Dave wrote:
> On Thu, 26 Aug 2004 19:20:09 +0400, Brad Campbell <brad@wasp.net.au> wrote:
> 
>>G'day all,
>>
>>Hot on the trail of this libata oddity.
>>
>>
>>ATA_MAX_SECTORS == 200.
>>
>>Should then the scsi layer be able to do this and queue 1/2 a Meg in a single request?
>>
>>Am I looking at something completely weird? Is the block layer doing something I should know about?
>>Can SATA transfers handle 1024 sectors in one go? Will Batman make it out of the cave alive?
> 
> 
> That is decimal 200, not hex 200. Technically with ATA (or SATA)
> drives you can bump it to 0x100 (256). That is the limitation of LBA28
> drives. With LBA48 drives you can do 0xffff (64k) sectors per request
> I believe.

G'day Dave,

Thanks for the reply.

In theory I guess 0xffff sectors is possible. Over here, I'm getting requests of more than 256 
sectors intermittently locking up my SATA->PATA converters if run on a via sata interface (On a 
promise interface it's not a problem)

I also note than in sata_sil there is a workaround for Seagate drives that knocks max_sectors back 
to 15. Is the md driver going to circumvent that also and lock up those interfaces?

I realise that 200 is decimal, my question was more how are requests of 1024 sectors making it to 
the driver when the driver has a max_sector value of 200?

I'm only seeing sectors > 200 when the request comes from md, thus my cc'ing it to the raid list to 
see if anyone there has any idea.

Regards,
Brad (Getting warmer)
