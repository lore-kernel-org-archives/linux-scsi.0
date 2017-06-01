From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 14/23] scsi: hisi_sas: add v3 cq interrupt handler
Date: Thu, 1 Jun 2017 11:36:55 +0100
Message-ID: <04821e06-7541-1861-d52b-4df869570ca7@huawei.com>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
 <1496241195-217678-15-git-send-email-john.garry@huawei.com>
 <20170601054147.GB4743@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170601054147.GB4743@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 01/06/2017 06:41, Christoph Hellwig wrote:
>> +	case SAS_PROTOCOL_SSP:
>> +	{
>> +		unsigned char op = task->ssp_task.cmd->cmnd[0];
>> +
>> +		if (op == READ_6 || op == WRITE_6 ||
>> +			op == READ_10 || op == WRITE_10 ||
>> +			op == READ_12 || op == WRITE_12 ||
>> +			op == READ_16 || op == WRITE_16)
>> +			return true;
>> +		break;
>> +	}
>
> Wee. why do you care?  >

In the command completion code we need to check for abnormal completion 
due to underflow, but ignore it when it occurs in some commands, like 
inquiry. This is why we check for rw command - it is equivalent to !inquiry.

I'll see if we can change the check to explicitly ignore certain 
commands which complete abnormally with underflow.

>What about 32-byte CDs or things like Write Same?
>

You're talking about VARIABLE_LENGTH_CMD (opcode 0x7f) for 32-byte CDs, 
right?

I need to check on WRITE SAME.

> .
>

Thanks,
John
