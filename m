From: Bin Wu <wu.wubin@huawei.com>
Subject: Re: [Xen-devel] [PATCH] xen_pvscsi: reclaim the ring request when
 mapping data failed
Date: Tue, 12 Jul 2016 08:29:41 +0800
Message-ID: <578439F5.4090400@huawei.com>
References: <578309AE.1080704@huawei.com> <578367E8.2050601@suse.com>
 <57836BF4.9090000@citrix.com> <57836CB5.90401@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:40897 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbcGLAb3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2016 20:31:29 -0400
In-Reply-To: <57836CB5.90401@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>, boris.ostrovsky@oracle.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2016/7/11 17:53, Juergen Gross wrote:
> On 11/07/16 11:50, David Vrabel wrote:
>> On 11/07/16 10:33, Juergen Gross wrote:
>>> On 11/07/16 04:51, Bin Wu wrote:
>>>> During scsi command queueing, if mapping data fails, we need to
>>>> reclaim the failed request. Otherwise, the garbage request will
>>>> be pushed into the ring for the backend to work.
>>> Well spotted. There is another instance of this problem in
>>> scsifront_action_handler(). Would you mind correcting this one, too?
>> Would it make more sense to advance req_prod_pvt only if the request has
>> been successfully created?
> Yeah, probably as the first action in scsifront_do_request().
>
>
> Juergen
ok, I will send a new patch : )
>
>> David
>>
>>>> Signed-off-by: Bin Wu <wu.wubin@huawei.com>
>>>> ---
>>>>   drivers/scsi/xen-scsifront.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
>>>> index 9dc8687..655163d 100644
>>>> --- a/drivers/scsi/xen-scsifront.c
>>>> +++ b/drivers/scsi/xen-scsifront.c
>>>> @@ -565,6 +565,7 @@ static int scsifront_queuecommand(struct Scsi_Host
>>>> *shost,
>>>>       err = map_data_for_request(info, sc, ring_req, shadow);
>>>>       if (err < 0) {
>>>>           pr_debug("%s: err %d\n", __func__, err);
>>>> +        info->ring.req_prod_pvt--;
>>>>           scsifront_put_rqid(info, rqid);
>>>>           scsifront_return(info);
>>>>           spin_unlock_irqrestore(shost->host_lock, flags);
>>>
>>> _______________________________________________
>>> Xen-devel mailing list
>>> Xen-devel@lists.xen.org
>>> https://lists.xen.org/xen-devel
>>>
>>
>
> .
>


