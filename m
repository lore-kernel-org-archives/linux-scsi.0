From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH v1] lpfc 8.3.37: Remove redundant NULL check before kfree
Date: Thu, 7 Mar 2013 13:05:59 -0500
Message-ID: <5138D707.8060904@emulex.com>
References: <1362600754-6139-1-git-send-email-s.syam@samsung.com> <2b628a59-616e-40c9-b5c4-a9899ae38b80@CMEXHTCAS2.ad.emulex.com> <94D0CD8314A33A4D9D801C0FE68B402950DA4F5D@G9W0745.americas.hpqcorp.net>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:3453 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3CGSGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 13:06:03 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950DA4F5D@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "syamsidhardh@gmail.com" <syamsidhardh@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Syam Sidhardhan <s.syam@samsung.com>

I don't disagree.    My intent would be it is all one way - with my 
leaning toward being explicit.  Unfortunately, it's a low priority task.

-- james s


On 3/6/2013 6:32 PM, Elliott, Robert (Server Storage) wrote:
> If the other approach is taken, then not all kfree() calls are protected by a NULL check.
>
> One example in lpfc_els.c (from 3.7-rc5):
> 	if (!pbuflist || !pbuflist->virt)
> 		goto els_iocb_free_pbuf_exit;
> ...
> els_iocb_free_pbuf_exit:
> 	if (expectRsp)
> 		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
> 	kfree(pbuflist);
>
>
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of James Smart
>> Sent: Wednesday, 06 March, 2013 3:10 PM
>> To: syamsidhardh@gmail.com
>> Cc: linux-scsi@vger.kernel.org; JBottomley@parallels.com; Syam Sidhardhan;
>> Smart, James
>> Subject: Re: [PATCH v1] lpfc 8.3.37: Remove redundant NULL check before
>> kfree
>>
>> Syam,
>>
>> Thank you for the patch - it is valid.
>>
>> However, I prefer not to merge this.  I would rather force the coder to
>> think about the pointer value explicitly rather than depending on the
>> convenience/one line optimization.  We've had errors in the past covered
>> up by this gracious behavior.  Additionally, we have coders that work on
>> linux and vmware, and the semantics of the kfree() routine differ.   For
>> now, I'd prefer to stay as is and force good habits.
>>
>> -- james s
>>
>>
>> On 3/6/2013 3:12 PM, syamsidhardh@gmail.com wrote:
>>> From: Syam Sidhardhan <s.syam@samsung.com>
>>>
>>> kfree on NULL pointer is a no-op.
>>>
>>> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
>>> ---
>>> v1-> Corrected the from address.
>>>
>>>    drivers/scsi/lpfc/lpfc_bsg.c |    3 +--
>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
>>> index 32d5683..2166097 100644
>>> --- a/drivers/scsi/lpfc/lpfc_bsg.c
>>> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
>>> @@ -1129,8 +1129,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
>>>    	return 0; /* call job done later */
>>>
>>>    job_error:
>>> -	if (dd_data != NULL)
>>> -		kfree(dd_data);
>>> +	kfree(dd_data);
>>>
>>>    	job->dd_data = NULL;
>>>    	return rc;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

