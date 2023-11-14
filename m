Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8102FC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 08:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjKNIBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 03:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbjKNIBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 03:01:49 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0355A19E
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2023 00:01:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 400D71F86B;
        Tue, 14 Nov 2023 08:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1699948904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fRb20s3+gC7sKhI9wrt24xagf7v8nQR7M1KtkG+k7Y=;
        b=hooYga/FKZfzBInMBfXz0JoLrioU81Uq6VVxz/26JTlERD5OST5dDhmtMyaw5amSxyHa7+
        vzMOfxJdIBkXqQnp4aVRX+37XqUjYyn8Zls2766RWFwGf6qldhYAw1keBbu2Q2yZq3ocq9
        /GJAh0HSi26XEeVmGGL2qtyoDKTDbKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1699948904;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fRb20s3+gC7sKhI9wrt24xagf7v8nQR7M1KtkG+k7Y=;
        b=tF6hxHY5M6MuLIfl1xTAw89FxGz1kActpJMH/4LiOWFBW0G3xRTY8VEuhPxYLNGO7y69El
        jhbwQdKO2xxNMRAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E4A6313460;
        Tue, 14 Nov 2023 08:01:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 73jGNWcpU2VnYwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Nov 2023 08:01:43 +0000
Message-ID: <a5df8cc9-34c4-4448-817f-0f61f4a493de@suse.de>
Date:   Tue, 14 Nov 2023 09:01:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/16] fnic: allocate device reset command on the fly
Content-Language: en-US
To:     "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Dhanraj Jhawar (djhawar)" <djhawar@cisco.com>,
        "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
        "Masa Kai (mkai2)" <mkai2@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>
References: <20231023091507.120828-1-hare@suse.de>
 <20231023091507.120828-14-hare@suse.de> <20231024065427.GD9847@lst.de>
 <SJ0PR11MB589682551110734A017D19C3C3AAA@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58960463A1A9D634BE8D2A62C3B2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <SJ0PR11MB58960463A1A9D634BE8D2A62C3B2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/23 03:29, Karan Tilak Kumar (kartilak) wrote:
> On Monday, November 6, 2023 11:42 AM, Karan Tilak Kumar (kartilak) wrote:
>>
>> On Monday, October 23, 2023 11:54 PM, Christoph Hellwig <hch@lst.de> wrote:
>>>
>>> Adding the fnic maintainers as they are probably most qualified to review and test this.
>>>
>>> On Mon, Oct 23, 2023 at 11:15:04AM +0200, Hannes Reinecke wrote:
>>>> Allocate a reset command on the fly instead of relying on using the
>>>> command which triggered the device failure.
>>>> This might fail if all available tags are busy, but in that case
>>>> it'll be safer to fall back to host reset anyway.
>>>>
>>
>> Thanks for this fix, Hannes.
>> I'm working on integrating these changes and testing them.
>> I'll get back to you about this.
>>
> 
> I integrated your patch set using "b4 shazam" and built all the changes to do some dev testing.
> I instrumented the code to do the following:
> 
> - After one million IOs, drop one IO response.
> - This will trigger an abort. Drop that abort response.
> - This will trigger a device reset. I'm seeing that the tag here is 0xFFFFFFFF (SCSI_NO_TAG).
> 
> This tag fails the out-of-range tag check and escalates to host reset.
> I've been able to repro this three times with the same result.
> 
> The expectation with this test case is that the device reset should go through successfully without escalating to host reset.
> 
Thanks for the report.
Certainly not what was intended with the patch. Can you try with this 
patch on top:

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 8909cf09cf9e..50eea6d2344a 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2210,7 +2210,7 @@ int fnic_device_reset(struct scsi_device *sdev)

         req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
                                  BLK_MQ_REQ_NOWAIT);
-       if (!req) {
+       if (IS_ERR(req)) {
                 /*
                  * Request allocation might fail, indicating that
                  * all tags are busy.
@@ -2221,7 +2221,8 @@ int fnic_device_reset(struct scsi_device *sdev)
                  * to host reset anyway.
                  */
                 FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host,
-                             "Device reset allocation failed, all tags 
busy\n");
+                             "Device reset allocation failed with %d\n",
+                             PTR_ERR(req));
                 return ret;
         }

(The first hunk is actually a bugfix, and will be included with
the next submission anyway.)
Please enable fnic debug during testing and send me the logs.
It _might_ be that this is actually by design, as we will be
failing if all tags are busy (ie if the error is EWOULDBLOCK).
But if we get EAGAIN it means that the queue is blocked and
we'll need to investigate.

Thanks for your help here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

