Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E33DC3524A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 06:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FAD12086A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 06:28:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="sGNPlcdI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBDG2b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:28:31 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:19073 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbgBDG2a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 01:28:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580797709; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=+hoX44i3CFQrj6wb5kYegFGpcc1xGahWSjifEiJeY60=;
 b=sGNPlcdI2Ed4QfgoD7C1/kUDWz6PvZQQAcaIAw67g11ne/3ldqSNiDlVYN/Sce9Xi5r+TS+5
 iCaUGWXEjR06cb/go+EsdmckZJialqBC/oIlRKIDyFZg9LvKHdQfWjbRgIcXUvkq6p8ZecXs
 eS3h6a2ph8bxj+WyhDtg4R4anq4=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e390f0c.7f99b9c4b768-smtp-out-n03;
 Tue, 04 Feb 2020 06:28:28 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1321FC447A5; Tue,  4 Feb 2020 06:28:25 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ED653C433CB;
        Tue,  4 Feb 2020 06:28:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 04 Feb 2020 14:28:24 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Sayali Lokhande <sayalil@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/8] scsi: ufs: Flush exception event before suspend
In-Reply-To: <12716695-d9a3-a40c-e563-fa0365183b0e@acm.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-2-git-send-email-cang@codeaurora.org>
 <525e4f67-f471-54a6-aaea-b3772a550af1@acm.org>
 <82723efc44714e8677505cb7999d3fd5@codeaurora.org>
 <12716695-d9a3-a40c-e563-fa0365183b0e@acm.org>
Message-ID: <4f9017b412139762fdda8c8d1741ae7b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-04 11:12, Bart Van Assche wrote:
> On 2020-02-02 22:23, Can Guo wrote:
>> On 2020-01-26 11:29, Bart Van Assche wrote:
>>> On 2020-01-22 23:25, Can Guo wrote:
>>>>              break;
>>>>          case UPIU_TRANSACTION_REJECT_UPIU:
>>>>              /* TODO: handle Reject UPIU Response */
>>>> @@ -5215,7 +5222,14 @@ static void
>>>> ufshcd_exception_event_handler(struct work_struct *work)
>>>> 
>>>>  out:
>>>>      scsi_unblock_requests(hba->host);
>>>> -    pm_runtime_put_sync(hba->dev);
>>>> +    /*
>>>> +     * pm_runtime_get_noresume is called while scheduling
>>>> +     * eeh_work to avoid suspend racing with exception work.
>>>> +     * Hence decrement usage counter using pm_runtime_put_noidle
>>>> +     * to allow suspend on completion of exception event handler.
>>>> +     */
>>>> +    pm_runtime_put_noidle(hba->dev);
>>>> +    pm_runtime_put(hba->dev);
>>>>      return;
>>>>  }
>>>> 
>>>> @@ -7901,6 +7915,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
>>>> enum ufs_pm_op pm_op)
>>>>              goto enable_gating;
>>>>      }
>>>> 
>>>> +    flush_work(&hba->eeh_work);
>>>>      ret = ufshcd_link_state_transition(hba, req_link_state, 1);
>>>>      if (ret)
>>>>          goto set_dev_active;
>>> 
>>> I think this patch introduces a new race condition, namely the 
>>> following:
>>> - ufshcd_slave_destroy() tests pm_op_in_progress and reads the value
>>>   zero from that variable.
>>> - ufshcd_suspend() sets hba->pm_op_in_progress to one.
>>> - ufshcd_slave_destroy() calls schedule_work().
>>> 
>>> How about fixing this race condition by calling
>>> pm_runtime_get_noresume() before checking pm_op_in_progress and by
>>> reallowing resume if no work is scheduled?
>> 
>> If you apply this patch, you will find the change is not in
>> ufshcd_slave_destroy(), but in ufshcd_transfer_rsp_status().
>> So the racing you mentioned above does not exist.
> 
> Hi Can,
> 
> Apparently I got a function name wrong. Can the following race 
> condition
> happen:
> - ufshcd_transfer_rsp_status() tests pm_op_in_progress and reads the
>   value zero from that variable.
> - ufshcd_suspend() sets hba->pm_op_in_progress to one.
> - ufshcd_suspend() calls flush_work(&hba->eeh_work).
> - ufshcd_transfer_rsp_status() calls schedule_work(&hba->eeh_work).
> 
> Thanks,
> 
> Bart.

Hi Bart,

The sequence you mentioned is not possible.

In normal cases, before ufshcd_transfer_rsp_status() returns,
ufshcd_suspend() would not be called (unless you intentionally call
ufshcd_suspend() to screw it). Because ufshcd_transfer_rsp_status() is
called from __ufshcd_transfer_req_compl(), which is being used by either
UFS IRQ handler or err handler. Meanwhile, in 
__ufshcd_transfer_req_compl(),
scsi_done() is called only after ufshcd_transfer_rsp_status() returns. 
When
we are here, it means UFS driver is still handling requests/tasks, so 
suspend
would not kick start at this moment, either runtime suspend or system 
suspend.

And this is why below lines work, calling pm_runtime_get_noresume() 
within
ufshcd_transfer_rsp_status() can prevent runtime suspend from happening
after we leave ufshcd_transfer_rsp_status().

+                if (schedule_work(&hba->eeh_work))
+                    pm_runtime_get_noresume(hba->dev);

Thanks,

Can Guo.
