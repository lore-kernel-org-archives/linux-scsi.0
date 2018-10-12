From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Fri, 12 Oct 2018 11:47:05 +0100
Message-ID: <e771c366-2824-8774-4c90-9906992ee813@huawei.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq18t354532.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/10/2018 02:58, Martin K. Petersen wrote:
>
> John,
>

Hi Martin,

>> However it does block us in future from enabling SCSI MQ in the driver.
>
> We're going to remove the legacy I/O path so I'm not particularly keen
> on merging something that's going in the opposite direction.

What I really meant was that we cannot expose multiple queues to upper 
layer, and nothing related to legacy IO path.

>
>> This is because the IPTT index must be a unique value per HBA. However,
>> if we switched to SCSI MQ, the block layer tag becomes unique per queue,
>> and not per HBA.
>
> That doesn't sound right.
>

Again, my wording my probably was not accurate. I meant that rq tag is 
not unqiue across all hw queues.

As I mentioned in the thread that spawned from this, we actually can't 
expose multiple hw queues at the moment. And, if we did, we find a 
performance drop due to having to go back to manage this IPTT internally.

So how to handle? We're going to continue to work towards exposing 
multiple queues to upper layer, but for the moment I think patch 6/7 is 
a good change.

Please let me know.

Thanks,
John
