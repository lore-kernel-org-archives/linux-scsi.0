Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D29C3A589
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 15:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C1E206BB
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 15:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfHTP1Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 11:27:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730023AbfHTP1Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Aug 2019 11:27:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4A02518C8909;
        Tue, 20 Aug 2019 15:27:23 +0000 (UTC)
Received: from [10.10.123.202] (ovpn-123-202.rdu2.redhat.com [10.10.123.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62DF06060D;
        Tue, 20 Aug 2019 15:27:22 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] scsi: target/tcm_loop: ignore already deleted scsi
 device
To:     Bart Van Assche <bvanassche@acm.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
 <1973f310-ad00-ff88-fe08-a31f81dc5c33@acm.org>
Cc:     Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5D5C1159.4030507@redhat.com>
Date:   Tue, 20 Aug 2019 10:27:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <1973f310-ad00-ff88-fe08-a31f81dc5c33@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 20 Aug 2019 15:27:23 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/20/2019 09:02 AM, Bart Van Assche wrote:
> On 8/20/19 2:04 AM, Naohiro Aota wrote:
>> If there is no corresponding scsi_device for a LUN,
>> tcm_loop_port_unlink() complains that it "Unable to locate struct
>> scsi_device for " the device and keep %tl_tpg_port_count as is. However,
>> such situation is legal when we delete a SCSI device using
>> /sys/class/scsi_device/${lun}/device/delete. We can safely ignore the
>> missing SCSI device case here.
>>
>> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
>> ---
>>   drivers/target/loopback/tcm_loop.c | 18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/target/loopback/tcm_loop.c
>> b/drivers/target/loopback/tcm_loop.c
>> index 3305b47fdf53..0942f3bd7eec 100644
>> --- a/drivers/target/loopback/tcm_loop.c
>> +++ b/drivers/target/loopback/tcm_loop.c
>> @@ -654,16 +654,16 @@ static void tcm_loop_port_unlink(
>>         sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
>>                   se_lun->unpacked_lun);
>> -    if (!sd) {
>> -        pr_err("Unable to locate struct scsi_device for %d:%d:%llu\n",
>> -               0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
>> -        return;
>> +    if (sd) {
>> +        /*
>> +         * Remove Linux/SCSI struct scsi_device by HCTL
>> +         */
>> +        scsi_remove_device(sd);
>> +        scsi_device_put(sd);
>> +    } else {
>> +        pr_debug("Unable to locate struct scsi_device for %d:%d:%llu\n",
>> +             0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
>>       }
>> -    /*
>> -     * Remove Linux/SCSI struct scsi_device by HCTL
>> -     */
>> -    scsi_remove_device(sd);
>> -    scsi_device_put(sd);
>>         atomic_dec_mb(&tl_tpg->tl_tpg_port_count);
> 
> The above patch looks wrong to me. I think this patch does not fix the
> reference leak present in the current code. Have you considered to
> modify tcm_loop_port_link() such that it saves the pointer returned by
> scsi_add_device() and to use that pointer in tcm_loop_port_unlink()?
> 

Are you guys talking about different issues?

tcm loop does not take a reference to the scsi_device at creation/link
time then need to release at removal/unlink time. The above
scsi_device_put is for the successful scsi_device_lookup call. tcm loop
works like a scsi host driver that does its own scanning via
scsi_add_device (maybe similar to scsi drivers that are raid cards).
Like other host drivers it does not take a reference to the device when
it is added and relies on scsi-ml to handle all that for it before doing
operations like queuecommand.

The leak is if you removed the scsi_device via the scsi ml sysfs
interface then there is no way to completely unlink the lio port because
if scsi_device_lookup fails we return from the function and do not do
not release our refcount on the tl_tpg_port_count.


