Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CDFCA9ECB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 00:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595B32083E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 00:18:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BbhYRAwW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JxCrruKd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfKAASS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 20:18:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbfKAASS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 20:18:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1B15960A96; Fri,  1 Nov 2019 00:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572567498;
        bh=rrKhKmeW7vI4vqSW4GX5bA8V0NngHAe0nA8L0Lpuxoo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BbhYRAwWqNTNNcpoujF5p5ib38RAG+ksieaG7qHohUcXauKOy2qu7ETAIBXYnHIiz
         wxD7wFO3ptNdP/+5lFWHUa0vsvFKvoLl0rn3R2M9RQYg4dl12+wJl21Wi0bjWPnDhV
         S0Z12o3xaHm6MtIJdiXzoGBjAFqf39WJ2uX79uBc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 2F0B860208;
        Fri,  1 Nov 2019 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572567497;
        bh=rrKhKmeW7vI4vqSW4GX5bA8V0NngHAe0nA8L0Lpuxoo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JxCrruKdcnnExenW7QLW6SYkAob/HnfjCjyOqZnlseyaj8ZlNcVXbVCOeGPhlzi8r
         hK9qo/3Pln5gARgq9wIzMijo1vaUZfpBmZB0j01P2uf49MafGPDvhCTN/eaW7lO/5R
         7cWIHwj8NFtf0ciKW+S3jZQEjoBAvbHgy+7aaRTA=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 01 Nov 2019 08:18:17 +0800
From:   cang@codeaurora.org
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] scsi: Adjust DBD setting in mode sense for caching
 mode page per LLD
In-Reply-To: <6bda63c6-4bcf-b7ad-f552-4c72ba0b9024@android.com>
References: <1572318655-28772-1-git-send-email-cang@codeaurora.org>
 <1572318655-28772-2-git-send-email-cang@codeaurora.org>
 <fd78538f-8e5f-2e5f-0107-a8bc284d037d@android.com>
 <6bda63c6-4bcf-b7ad-f552-4c72ba0b9024@android.com>
Message-ID: <904e0c27ce60c91f3c6447bd9ac3dae9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-31 23:40, Mark Salyzyn wrote:
> On 10/31/19 8:20 AM, Mark Salyzyn wrote:
>> On 10/28/19 8:10 PM, Can Guo wrote:
>>> Host sends MODE_SENSE_10 with caching mode page, to check if the 
>>> device
>>> supports the cache feature.
>>> UFS JEDEC standards require DBD field to be set to 1.
>>> 
>>> This patch allows LLD to define the setting of DBD if required.
>>> 
>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>> ---
>>>   drivers/scsi/sd.c        | 6 +++++-
>>>   include/scsi/scsi_host.h | 6 ++++++
>>>   2 files changed, 11 insertions(+), 1 deletion(-)
>>> 
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index aab4ed8..6d8194f 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -2629,6 +2629,7 @@ static int sd_try_rc16_first(struct scsi_device 
>>> *sdp)
>>>   {
>>>       int len = 0, res;
>>>       struct scsi_device *sdp = sdkp->device;
>>> +    struct Scsi_Host *host = sdp->host;
>> variable locality
>>>       int dbd;
>>>       int modepage;
>>> @@ -2660,7 +2661,10 @@ static int sd_try_rc16_first(struct 
>>> scsi_device *sdp)
>>>           dbd = 8;
>>>       } else {
>>>           modepage = 8;
>>> -        dbd = 0;
>>> +        if (host->set_dbd_for_caching)
>>> +            dbd = 8;
>>> +        else
>>> +            dbd = 0;
>>>       }
>> 
>> This simplifies to:
>> 
>> -   } else if (sdp->type == TYPE_RBC) {
>> 
>> +    } else if (sdp->type == TYPE_RBC || 
>> sdp->host->set_dbd_for_caching) {
> 
> IDK what happened with my mailer sending out an older infant copy
> (blame on fumble fingers). My final copy was instead the
> simplification:
> 
> +    dbd = sdp->host->set_dbd_for_caching ? 8 : 0;

Thank you for your review.

Regards,
Can Guo

