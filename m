From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] scsi: mark expected switch fall-throughs
Date: Fri, 12 Oct 2018 14:26:58 +0200
Message-ID: <84512689-d898-e670-075d-509bbff20423@embeddedor.com>
References: <20181003145535.GA24941@embeddedor.com>
 <yq18t352o9l.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq18t352o9l.fsf@oracle.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Willem Riede <osst@riede.org>, =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, osst-users@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

On 10/11/18 4:47 AM, Martin K. Petersen wrote:
> 
> Hi Gustavo,
> 
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
> 
> I'm not entirely convinced that all these identified fall through cases
> are intentional. From a quick glance, some of them look like bugs...
> 

I took a second look at this and, certainly, the one below looks more like a
bug. The rest seem to be false positives.

Also, notice that this code has been there since 2005. So, that's why I was
inclined to think that all of them are false positives.

>> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
>> index bd6ac6b..8e1c45d 100644
>> --- a/drivers/scsi/ips.c
>> +++ b/drivers/scsi/ips.c
>> @@ -3485,6 +3485,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
>>  
>>  		case START_STOP:
>>  			scb->scsi_cmd->result = DID_OK << 16;
>> +			/* fall through */

If you confirm this is an actual bug, I can send a separate fix.

>>  
>>  		case TEST_UNIT_READY:
>>  		case INQUIRY:
> 

Thanks for the feedback.
--
Gustavo
