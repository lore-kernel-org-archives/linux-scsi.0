From: Eric Farman <farman@linux.vnet.ibm.com>
Subject: Re: [PATCH] virtio_scsi: Reject commands when virtqueue is broken
Date: Thu, 12 Jan 2017 09:02:06 -0500
Message-ID: <3519648c-3cbb-90fc-e584-f0ce5af9b8fd@linux.vnet.ibm.com>
References: <1484172122-18882-1-git-send-email-farman@linux.vnet.ibm.com>
 <1484172122-18882-2-git-send-email-farman@linux.vnet.ibm.com>
 <20170112031159.GD26504@lemon>
 <aa461af2-6fc2-9ece-3b8f-9b6e07268c2f@linux.vnet.ibm.com>
 <20170112134555.GF26504@lemon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750887AbdALOCN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 09:02:13 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v0CDvfwS113437
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 09:02:12 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27x7mhrymw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 09:02:12 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <farman@linux.vnet.ibm.com>;
        Thu, 12 Jan 2017 07:02:11 -0700
In-Reply-To: <20170112134555.GF26504@lemon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com



On 01/12/2017 08:45 AM, Fam Zheng wrote:
> On Thu, 01/12 08:28, Eric Farman wrote:
>>>> -	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd)) != 0)
>>>> +	ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
>>>> +	if (ret == -EIO) {
>>>> +		cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
>>>> +		virtscsi_complete_cmd(vscsi, cmd);
>>>
>>> Is this safe? Calling virtscsi_complete_cmd requires vq_lock but we don't seem
>>> to have it here.
>>
>> Hrm...  Didn't notice that, and can't speak to its safety.  I had a bit of
>> an I/O workload going to other disks, and things seemed okay, but it was by
>> no means an exhaustive test.
>>
>> I can't use virtscsi_vq_done, which normally handles that acquire/release.
>> It calls virtqueue_get_buf prior to calling virtscsi_complete_cmd, which
>> returns NULL because the virtqueue is broken.    Thus, no call to
>> virtscsi_complete_cmd.
>>
>> Can I mock up a wrapping routine that only handles the lock and complete_cmd
>> call, and ignore the virtqueue components that virtscsi_vq_done does?
>
> That sounds good to me, taking the vq_lock here around the call to
> virtscsi_complete_cmd, just like virtscsi_kick_cmd().

Okay, working up a v2 today.  Thanks!

Eric

>
> Fam
>
>>
>> Eric
>>
>>>
>>> Fam
>>>
>>>> +	} else if (ret != 0) {
>>>>  		return SCSI_MLQUEUE_HOST_BUSY;
>>>> +	}
>>>>  	return 0;
>>>>  }
>>>
>>
>

