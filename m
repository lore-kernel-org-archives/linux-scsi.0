From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/6] libata: Signal that our SATL supports WRITE SAME(16)
 with UNMAP
Date: Mon, 23 Aug 2010 14:22:24 -0400
Message-ID: <4C72BC60.4090705@interlog.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com> <1282232941-9910-2-git-send-email-martin.petersen@oracle.com> <4C723215.3080507@kernel.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C723215.3080507@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 10-08-23 04:32 AM, Tejun Heo wrote:
> On 08/19/2010 05:48 PM, Martin K. Petersen wrote:
>> Until now identifying that a device supports WRITE SAME(16) with the
>> UNMAP bit set has been black magic.  Implement support for the new (SBC3
>> r24) Thin Provisioning VPD page and the TPWS bit.
>>
>> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>
>> ---
>>   drivers/ata/libata-scsi.c |   13 +++++++++++++
>>   1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index a54273d..e280ae6 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -2001,6 +2001,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
>>   		0x89,	/* page 0x89, ata info page */
>>   		0xb0,	/* page 0xb0, block limits page */
>>   		0xb1,	/* page 0xb1, block device characteristics page */
>> +		0xb2,	/* page 0xb2, thin provisioning page */
>>   	};
>>
>>   	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
>> @@ -2172,6 +2173,15 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
>>   	return 0;
>>   }
>>
>> +static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
>> +{
>> +	rbuf[1] = 0xb1;
>> +	rbuf[3] = 0x3c;
>> +	rbuf[5] = 1<<  6;	/* TPWS */
>
> I would love a bit more documentation here.

Yes, that style comes from my code in scsi_debug and
some of my utilities. Recently I added some more
documentation, just prior the the function:

/* SCSI Thin Provisioning VPD page: SBC-3 rev 22 or later */

I see no point in commenting the individual code lines.
Just follow that reference ...

And when I do then I see that rbuf[3] should be 4 (not 0x3c)
unless the DP bit is set.

Doug Gilbert


