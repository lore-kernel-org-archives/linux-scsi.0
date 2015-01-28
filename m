From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 08/17] ibmvscsi: Fix bidi command test
Date: Wed, 28 Jan 2015 08:57:17 +0100
Message-ID: <54C8965D.2040008@sandisk.com>
References: <54C2390A.3000700@sandisk.com> <54C23A2F.1090005@sandisk.com>
 <54C80CE8.40506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:50344
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933372AbbA1Uby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2015 15:31:54 -0500
In-Reply-To: <54C80CE8.40506@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>

On 01/27/15 23:11, Tyrel Datwyler wrote:
> On 01/23/2015 04:10 AM, Bart Van Assche wrote:
>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Cc: Brian King <brking@linux.vnet.ibm.com>
>> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> index acea5d6..cf26b33 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> @@ -765,16 +765,18 @@ static int map_data_for_srp_cmd(struct scsi_cmnd *cmd,
>>  				struct srp_event_struct *evt_struct,
>>  				struct srp_cmd *srp_cmd, struct device *dev)
>>  {
>> +	if (scsi_bidi_cmnd(cmd)) {
>> +		sdev_printk(KERN_ERR, cmd->device,
>> +			    "Bidirectional commands are not yet supported\n");
>> +		return 0;
>> +	}
>> +
> 
> Is there a particular problem this solves, or is this simply a change to
> use the bidi API in place of checking sc_data_direction for
> DMA_BIDIRECTIONAL?
> 
> -Tyrel
> 
>>  	switch (cmd->sc_data_direction) {
>>  	case DMA_FROM_DEVICE:
>>  	case DMA_TO_DEVICE:
>>  		break;
>>  	case DMA_NONE:
>>  		return 1;
>> -	case DMA_BIDIRECTIONAL:
>> -		sdev_printk(KERN_ERR, cmd->device,
>> -			    "Can't map DMA_BIDIRECTIONAL to read/write\n");
>> -		return 0;
>>  	default:
>>  		sdev_printk(KERN_ERR, cmd->device,
>>  			    "Unknown data direction 0x%02x; can't map!\n",
>>

Hello Tyrel,

Since the ibmvscsi driver does not set QUEUE_FLAG_BIDI neither the code
under "case DMA_BIDIRECTIONAL" nor the code under "if
(scsi_bidi_cmnd(cmd))" is ever executed. The only reason why I proposed
this change is to avoid that an author of another SCSI LLD driver would
use the code that compares sc_data_direction with DMA_BIDIRECTIONAL as
an example.

BTW, had you already noticed that Christoph Hellwig proposed to modify
the SCSI core such that sc_data_direction is set to DMA_BIDIRECTIONAL
for bidi commands ? I'd like to rework this patch series accordingly.
With that approach no changes are necessary in the ibmvscsi driver.

Bart.


