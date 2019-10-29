Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EEECA9EC2
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 02:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA21C20862
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 02:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iWqIr28E";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XyngsHL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbfJ2COc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 22:14:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49012 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbfJ2COc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 22:14:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3EB676032D; Tue, 29 Oct 2019 02:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572315271;
        bh=mM+8iA4RCQ/3hHjKmFsx3ITFIQk6Ug1K0cEpK7e2uWE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iWqIr28Ex9TnplfbvamCnn7+4QboVgJkFcyEPJhmcxGWkpzrjwWpq/fqReUSZFP76
         mf7HsLWrapY5HxyeItpgy2UAQwg3nEoxJKjKF2JiT2mHtJprXATqpv3E+abZCY2odo
         ERRqU2V/UNBnHBoL/2ZDVOA4O1SDa7LAF1yamRUc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 67C116032D;
        Tue, 29 Oct 2019 02:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572315270;
        bh=mM+8iA4RCQ/3hHjKmFsx3ITFIQk6Ug1K0cEpK7e2uWE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XyngsHL5oH8sUvUQBv4U21wQB4g9pOhsl3g8zuJ+QgeFuOyulOzs5bFZ+e6g6Obv0
         mJ4KPqSlQe1SINQBFHsPviCmtawLOqlp/0CKpa21AKYghIHGIqXv64L9jXApYIF1Xr
         2wXQCXk8NEFHev0PQ15t9pWSXRUMrFOCbTzgWjBg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Oct 2019 10:14:30 +0800
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/5] scsi: Adjust DBD setting in mode sense for caching
 mode page per LLD
In-Reply-To: <0ca52845-10ec-3310-83f7-81bdb635ec12@acm.org>
References: <1572234608-32654-1-git-send-email-cang@codeaurora.org>
 <1572234608-32654-2-git-send-email-cang@codeaurora.org>
 <0ca52845-10ec-3310-83f7-81bdb635ec12@acm.org>
Message-ID: <ecb93b31aaee952e94b31331c6025eda@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-28 22:58, Bart Van Assche wrote:
> On 10/27/19 8:50 PM, Can Guo wrote:
>> Host sends MODE_SENSE_10 with caching mode page, to check if the 
>> device
>> supports the cache feature.
>> Some LLD standards requires DBD field to be set to 1.
> 
> Which LLD standard are you referring to? Please mention at least one
> name of such a standard in the patch description.
> 

Hi Bart, Thank you for your review.

The LLD standard here is UFS. I will update the commit message and 
re-upload it later.

Thanks,

Can Guo

>> Change-Id: I0c8752c1888654942d6d7e6e0f6dc197033ac326
> 
> Change-IDs should be left out from upstream patches. Does the presence
> of this ID mean that this patch has not been verified with checkpatch?
> From the checkpatch source code:
> 
> # Check for unwanted Gerrit info
> if ($in_commit_log && $line =~ /^\s*change-id:/i) {
> 	ERROR("GERRIT_CHANGE_ID",
> 	      "Remove Gerrit Change-Id's before submitting upstream.\n"\
> 		 . $herecurr);
> }
> 

Sorry, forgot to remove the change-id.

>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index aab4ed8..6d8194f 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2629,6 +2629,7 @@ static int sd_try_rc16_first(struct scsi_device 
>> *sdp)
>>   {
>>   	int len = 0, res;
>>   	struct scsi_device *sdp = sdkp->device;
>> +	struct Scsi_Host *host = sdp->host;
>>     	int dbd;
>>   	int modepage;
>> @@ -2660,7 +2661,10 @@ static int sd_try_rc16_first(struct scsi_device 
>> *sdp)
>>   		dbd = 8;
>>   	} else {
>>   		modepage = 8;
>> -		dbd = 0;
>> +		if (host->set_dbd_for_caching)
>> +			dbd = 8;
>> +		else
>> +			dbd = 0;
>>   	}
>>     	/* cautiously ask */
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 2c3f0c5..3900987 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -650,6 +650,12 @@ struct Scsi_Host {
>>   	unsigned no_scsi2_lun_in_cdb:1;
>>     	/*
>> +	 * Set "DBD" field in mode_sense caching mode page in case it is
>> +	 * mandatory by LLD standard.
>> +	 */
>> +	unsigned set_dbd_for_caching:1;
>> +
>> +	/*
>>   	 * Optional work queue to be utilized by the transport
>>   	 */
>>   	char work_q_name[20];
> 
> Since this patch by itself has no effect, please resubmit this patch
> together with the LLD patch that sets set_dbd_for_caching.
> 
> Thanks,
> 
> Bart.
