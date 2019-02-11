From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [PATCH 1/6] scsi: hisi_sas: Add support for DIX feature for v3 hw
Date: Mon, 11 Feb 2019 19:36:01 +0800
Message-ID: <53c516cc-cce3-a3e1-718f-6fc465b6e401@hisilicon.com>
References: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
 <1549450376-114929-2-git-send-email-john.garry@huawei.com>
 <yq1zhr5vpos.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zhr5vpos.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

ÔÚ 2019/2/9 7:13, Martin K. Petersen Ð´µÀ:
> John,
>
> Just noticed this while inspecting the resulting complete diff:
>
>>   static u32 get_prot_chk_msk_v3_hw(struct scsi_cmnd *scsi_cmnd)
>>   {
>>   	unsigned char prot_flags = scsi_cmnd->prot_flags;
>>   
>> -	if (prot_flags & SCSI_PROT_TRANSFER_PI) {
>> -		if (prot_flags & SCSI_PROT_REF_CHECK)
>> -			return 0xc << 16;
>> -		return 0xfc << 16;
>> -	}
>> -	return 0;
>> +	if (prot_flags & SCSI_PROT_REF_CHECK)
>> +		return T10_CHK_APP_TAG_MSK;
> Polarity is a bit unclear here. Is this statement disabling checking of
> the app tag?

Yes, disabling checking of app tag.
For here, 1'b0 presents the related byte in DIF will be checked, and 
1'b1 presents the related byte in DIF will not be checked.


>
>> +	return T10_CHK_REF_TAG_MSK | T10_CHK_APP_TAG_MSK;
>>   }
