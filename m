From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v4 4/5] scsi: hisi_sas: Add support for DIF feature for v3
 hw
Date: Mon, 17 Dec 2018 14:51:36 +0000
Message-ID: <afb32599-9b81-9d56-3ae7-2797992353a1@huawei.com>
References: <1544103284-100497-1-git-send-email-john.garry@huawei.com>
 <1544103284-100497-5-git-send-email-john.garry@huawei.com>
 <yq1o99qgobi.fsf@oracle.com>
 <4752be71-f39c-ac55-0e51-36c146108a38@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4752be71-f39c-ac55-0e51-36c146108a38@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 13/12/2018 13:35, John Garry wrote:
>
>>
>> to set your controller flags.
>>
>> +        if (prot_op == SCSI_PROT_WRITE_INSERT) {
>> +            unsigned int interval = scsi_prot_interval(scsi_cmnd);
>> +            unsigned int ilog2_interval = ilog2(interval);
>> +
>> +            len = (task->total_xfer_len >> ilog2_interval) * 8;
>>
>> scsi_transfer_length(struct scsi_cmnd *scmd)
>
> ok

Hi Martin,

We have an issue with using scsi_transfer_length().

As I understand, for our controller we need to set the host structure 
data transfer size to the size of data to write to the disk for WRITE 
type command, and at size of info received to host memory for READ type 
command. As such, for READ STRIP, we only want the SCSI buf len, and not 
the scsi buf len and PI (this is what scsi_transfer_length() provides).

Thanks,
John
