From: Eric Farman <farman@linux.vnet.ibm.com>
Subject: Re: [PATCH] virtio_scsi: Reject commands when virtqueue is broken
Date: Thu, 12 Jan 2017 08:28:42 -0500
Message-ID: <aa461af2-6fc2-9ece-3b8f-9b6e07268c2f@linux.vnet.ibm.com>
References: <1484172122-18882-1-git-send-email-farman@linux.vnet.ibm.com>
 <1484172122-18882-2-git-send-email-farman@linux.vnet.ibm.com>
 <20170112031159.GD26504@lemon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751339AbdALN2s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 08:28:48 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v0CDO67N039012
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 08:28:47 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27x9h8b0ts-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 08:28:47 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <farman@linux.vnet.ibm.com>;
        Thu, 12 Jan 2017 08:28:46 -0500
In-Reply-To: <20170112031159.GD26504@lemon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com



On 01/11/2017 10:11 PM, Fam Zheng wrote:
> On Wed, 01/11 17:02, Eric Farman wrote:
>> In the case of a graceful set of detaches, where the virtio-scsi-ccw
>> disk is removed from the guest prior to the controller, the guest
>> behaves quite normally.  Specifically, the detach gets us into
>> sd_sync_cache to issue a Synchronize Cache(10) command, which
>> immediately fails (and is retried a couple of times) because the
>> device has been removed.  Later, the removal of the controller
>> sees two CRWs presented, but there's no further indication of the
>> removal from the guest viewpoint.
>>
>>  [   17.217458] sd 0:0:0:0: [sda] Synchronizing SCSI cache
>>  [   17.219257] sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>  [   21.449400] crw_info : CRW reports slct=0, oflw=0, chn=1, rsc=3, anc=0, erc=4, rsid=2
>>  [   21.449406] crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=3, anc=0, erc=4, rsid=0
>>
>> However, on s390, the SCSI disks can be removed "by surprise" when
>> an entire controller (host) is removed and all associated disks
>> are removed via the loop in scsi_forget_host.  The same call to
>> sd_sync_cache is made, but because the controller has already
>> been removed, the Synchronize Cache(10) command is neither issued
>> (and then failed) nor rejected.
>>
>> That the I/O isn't returned means the guest cannot have other devices
>> added nor removed, and other tasks (such as shutdown or reboot) issued
>> by the guest will not complete either.  The virtio ring has already
>> been marked as broken (via virtio_break_device in virtio_ccw_remove),
>> but we still attempt to queue the command only to have it remain there.
>> The calling sequence provides a bit of distinction for us:
>>
>>   virtscsi_queuecommand()
>>    -> virtscsi_kick_cmd()
>>     -> virtscsi_add_cmd()
>>      -> virtqueue_add_sgs()
>>       -> virtqueue_add()
>>          if success
>>            return 0
>>          elseif vq->broken or vring_mapping_error()
>>            return -EIO
>>          else
>>            return -ENOSPC
>>
>> A return of ENOSPC is generally a temporary condition, so returning
>> "host busy" from virtscsi_queuecommand makes sense here, to have it
>> redriven in a moment or two.  But the EIO return code is more of a
>> permanent error and so it would be wise to return the I/O itself and
>> allow the calling thread to finish gracefully.  The result is these
>> four kernel messages in the guest (the fourth one does not occur
>> prior to this patch):
>>
>>  [   22.921562] crw_info : CRW reports slct=0, oflw=0, chn=1, rsc=3, anc=0, erc=4, rsid=2
>>  [   22.921580] crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=3, anc=0, erc=4, rsid=0
>>  [   22.921978] sd 0:0:0:0: [sda] Synchronizing SCSI cache
>>  [   22.921993] sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>
>> I opted to fill in the same response data that is returned from the
>> more graceful device detach, where the disk device is removed prior
>> to the controller device.
>>
>> Signed-off-by: Eric Farman <farman@linux.vnet.ibm.com>
>> ---
>>  drivers/scsi/virtio_scsi.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index ec91bd0..78d50ca 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -535,6 +535,7 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
>>  	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
>>  	int req_size;
>> +	int ret;
>>
>>  	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
>>
>> @@ -562,8 +563,13 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>>  		req_size = sizeof(cmd->req.cmd);
>>  	}
>>
>> -	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd)) != 0)
>> +	ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
>> +	if (ret == -EIO) {
>> +		cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
>> +		virtscsi_complete_cmd(vscsi, cmd);
>
> Is this safe? Calling virtscsi_complete_cmd requires vq_lock but we don't seem
> to have it here.

Hrm...  Didn't notice that, and can't speak to its safety.  I had a bit 
of an I/O workload going to other disks, and things seemed okay, but it 
was by no means an exhaustive test.

I can't use virtscsi_vq_done, which normally handles that 
acquire/release.  It calls virtqueue_get_buf prior to calling 
virtscsi_complete_cmd, which returns NULL because the virtqueue is 
broken.    Thus, no call to virtscsi_complete_cmd.

Can I mock up a wrapping routine that only handles the lock and 
complete_cmd call, and ignore the virtqueue components that 
virtscsi_vq_done does?  Or do I need to consider that somehow despite it 
all being broken?

Eric

>
> Fam
>
>> +	} else if (ret != 0) {
>>  		return SCSI_MLQUEUE_HOST_BUSY;
>> +	}
>>  	return 0;
>>  }
>

