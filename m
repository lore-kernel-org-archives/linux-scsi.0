From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] scsi_debug: fix sleep in invalid context
Date: Thu, 9 Jun 2016 15:18:47 +1000
Message-ID: <5758FC37.2000801@interlog.com>
References: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
 <20160607115525.GA30861@infradead.org> <5757C1F3.2070607@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:35797 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbcFIFS5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2016 01:18:57 -0400
In-Reply-To: <5757C1F3.2070607@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com

On 2016-06-08 04:57 PM, Douglas Gilbert wrote:
> On 2016-06-07 09:55 PM, Christoph Hellwig wrote:
>>> +static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
>>> +                  int arr_len, unsigned int off_dst)
>>> +{
>>> +    int act_len, n;
>>> +    struct scsi_data_buffer *sdb = scsi_in(scp);
>>> +    off_t skip = off_dst;
>>
>> Why off_t which is a signed value instead of the unsigned in passed in?
>
> Because off_t is the type of the last argument to sg_pcopy_from_buffer()
> which is where the off_dst value goes. So there is potentially a size
> of integer change plus signedness, IMO best expressed by defining a
> new auto variable. I notice some projects have a uoff_t typedef for
> offsets that make no sense when negative (like this case), but not the
> Linux kernel.
>
>>> +#define RL_BUCKET_ELEMS 8
>>> +
>>>   /* Even though each pseudo target has a REPORT LUNS "well known logical unit"
>>>    * (W-LUN), the normal Linux scanning logic does not associate it with a
>>>    * device (e.g. /dev/sg7). The following magic will make that association:
>>> @@ -3285,12 +3315,14 @@ static int resp_report_luns(struct scsi_cmnd *scp,
>>>       unsigned char select_report;
>>>       u64 lun;
>>>       struct scsi_lun *lun_p;
>>> -    u8 *arr;
>>> +    u8 arr[RL_BUCKET_ELEMS * sizeof(struct scsi_lun)];
>>
>> just use an on-stack array of type struct scsi_lun here, e.g.:
>>
>>     struct scsi_lun arr[RL_BUCKET_ELEMS];
>>
>> Which you can then use directly instead of lun_p later, but which can
>> also be passed p_fill_from_dev_buffer as that takes a void pointer.
>
> Can do.

When I looked at doing this, it's not that simple. The first 8 byte
"slot" is not a LUN, it's the response header, which just happens
to be 8 bytes long. That is the reason for the comment above that loop:
   /* loops rely on sizeof response header same as sizeof lun (both 8) */

So IMO: 'struct scsi_lun arr[RL_BUCKET_ELEMS];' will work but
is deceptive. IMO the v2 patch should stand, unless someone has an
alternate patch. The original patch is also fine. This is a bug
fix, not a new feature.

Doug Gilbert


