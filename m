From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsis: Fix max transfer length
Date: Wed, 11 Jan 2017 13:26:24 -0600
Message-ID: <10f184b0-e15d-afdf-2e1e-4ffdd36a5e72@linux.vnet.ibm.com>
References: <1484157759-61200-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1484161010.2619.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1484161010.2619.16.camel@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1/11/17 12:57 PM, Bart Van Assche wrote:

> On Wed, 2017-01-11 at 12:02 -0600, Bryant G. Ly wrote:
>> Current code incorrectly calculates the max transfer length, since
>> it is assuming a 4k page table, but ppc64 all run on 64k page tables.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Steven Royer <seroyer@linux.vnet.ibm.com>
>> Tested-by: Steven Royer <seroyer@linux.vnet.ibm.com>
>> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
>> ---
>>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
>> b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
>> index 8fb5c54..792a8bd 100644
>> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
>> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
>> @@ -1443,7 +1443,7 @@ static long ibmvscsis_adapter_info(struct scsi_info
>> *vscsi,
>>   	info->mad_version = cpu_to_be32(MAD_VERSION_1);
>>   	info->os_type = cpu_to_be32(LINUX);
>>   	memset(&info->port_max_txu[0], 0, sizeof(info->port_max_txu));
>> -	info->port_max_txu[0] = cpu_to_be32(128 * PAGE_SIZE);
>> +	info->port_max_txu[0] = cpu_to_be32(16 * PAGE_SIZE);
>>   
>>   	dma_wmb();
>>   	rc = h_copy_rdma(sizeof(*info), vscsi->dds.window[LOCAL].liobn,
> Hello Bryant,
>
> The old limit was intended to be 128 * 4 KB = 512 KB. The new limit is 16 *
> 64 KB = 1024 KB. Is that intended?
>
> Do I understand correctly that the max_txu value is independent of the page
> size? If so, have you considered to introduce a #define for the max_mtu
> value that specifies max_mtu as a number instead of as a multiple of the
> page size? At least in the SLES 10 SP3 ibmvscsis.c code max_mtu was not
> defined as a multiple of the page size.
>
Hi Bart,

Thanks for the review. You are correct, max_txu is independent of the 
page size.
A define is probably best.

The reason for this is people who are using tcmu-runner, they have a max 
transfer
length of 1024KB, so if you exceed this value, then commands will fail. 
Thus to prevent
people from experiencing this issue, we are going to limit our driver to 
that cap.

The "allowed values" from a typical AIX disk can go all the way up to 
16MB. Typically
the max values do default at 512KB though.

-Bryant.
