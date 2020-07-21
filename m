Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2781C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C50152080D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgGUGi4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 02:38:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:43924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgGUGiz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jul 2020 02:38:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 46337ACDB;
        Tue, 21 Jul 2020 06:39:00 +0000 (UTC)
Subject: Re: [PATCH v2 24/24] scsi: aic7xxx: aic79xx_osm: Remove set but
 unused variabes 'saved_scsiid' and 'saved_modes'
To:     jejb@linux.ibm.com, Lee Jones <lee.jones@linaro.org>
Cc:     martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200713080001.128044-1-lee.jones@linaro.org>
 <20200713080001.128044-25-lee.jones@linaro.org>
 <559e47de-fa26-9ae5-a3c5-4adeae606309@suse.de>
 <1594741430.4545.15.camel@linux.ibm.com> <20200714213951.GL1398296@dell>
 <1594767794.14804.21.camel@linux.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6cc1f2fe-ae61-2a54-89df-35d994dc388b@suse.de>
Date:   Tue, 21 Jul 2020 08:38:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594767794.14804.21.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/15/20 1:03 AM, James Bottomley wrote:
> On Tue, 2020-07-14 at 22:39 +0100, Lee Jones wrote:
>> On Tue, 14 Jul 2020, James Bottomley wrote:
>>
>>> On Tue, 2020-07-14 at 09:46 +0200, Hannes Reinecke wrote:
>>>> On 7/13/20 10:00 AM, Lee Jones wrote:
>>>>> Haven't been used since 2006.
>>>>>
>>>>> Fixes the following W=1 kernel build warning(s):
>>>>>
>>>>>   drivers/scsi/aic7xxx/aic79xx_osm.c: In function
>>>>> ‘ahd_linux_queue_abort_cmd’:
>>>>>   drivers/scsi/aic7xxx/aic79xx_osm.c:2155:17: warning: variable
>>>>> ‘saved_modes’ set but not used [-Wunused-but-set-variable]
>>>>>   drivers/scsi/aic7xxx/aic79xx_osm.c:2148:9: warning: variable
>>>>> ‘saved_scsiid’ set but not used [-Wunused-but-set-variable]
>>>>>
>>>>> Cc: Hannes Reinecke <hare@suse.com>
>>>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>>> ---
>>>>>   drivers/scsi/aic7xxx/aic79xx_osm.c | 4 ----
>>>>>   1 file changed, 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c
>>>>> b/drivers/scsi/aic7xxx/aic79xx_osm.c
>>>>> index 3782a20d58885..140c4e74ddd7e 100644
>>>>> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
>>>>> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
>>>>> @@ -2141,14 +2141,12 @@ ahd_linux_queue_abort_cmd(struct
>>>>> scsi_cmnd
>>>>> *cmd)
>>>>>   	u_int  saved_scbptr;
>>>>>   	u_int  active_scbptr;
>>>>>   	u_int  last_phase;
>>>>> -	u_int  saved_scsiid;
>>>>>   	u_int  cdb_byte;
>>>>>   	int    retval;
>>>>>   	int    was_paused;
>>>>>   	int    paused;
>>>>>   	int    wait;
>>>>>   	int    disconnected;
>>>>> -	ahd_mode_state saved_modes;
>>>>>   	unsigned long flags;
>>>>>   
>>>>>   	pending_scb = NULL;
>>>>> @@ -2239,7 +2237,6 @@ ahd_linux_queue_abort_cmd(struct
>>>>> scsi_cmnd
>>>>> *cmd)
>>>>>   		goto done;
>>>>>   	}
>>>>>   
>>>>> -	saved_modes = ahd_save_modes(ahd);
>>>>>   	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
>>>>>   	last_phase = ahd_inb(ahd, LASTPHASE);
>>>>>   	saved_scbptr = ahd_get_scbptr(ahd);
>>>>> @@ -2257,7 +2254,6 @@ ahd_linux_queue_abort_cmd(struct
>>>>> scsi_cmnd
>>>>> *cmd)
>>>>>   	 * passed in command.  That command is currently
>>>>> active on
>>>>> the
>>>>>   	 * bus or is in the disconnected state.
>>>>>   	 */
>>>>> -	saved_scsiid = ahd_inb(ahd, SAVED_SCSIID);
>>>>>   	if (last_phase != P_BUSFREE
>>>>>   	    && SCB_GET_TAG(pending_scb) == active_scbptr) {
>>>>>   
>>>>>
>>>>
>>>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>>>
>>> Hey, you don't get to do that ... I asked you to figure out why
>>> we're missing an ahd_restore_modes().  Removing the
>>> ahd_save_modes() is cosmetic: it gets rid of a warning but doesn't
>>> fix the problem.  I'd rather keep the warning until the problem is
>>> fixed and the problem is we need a mode save/restore around the
>>> ahd_set_modes() which is only partially implemented in this
>>> function.
>>
>> I had a look.  Traced it back to the dawn of time (time == Git), then
>> delved even further back by downloading and trawling through ~10-15
>> tarballs.  It looks as though drivers/scsi/aic7xxx/aic79xx_osm.c was
>> upstreamed in v2.5.60, nearly 20 years ago.  'saved_modes' has been
>> unused since at least then.  If no one has complained in 2 decades,
>> I'd say it probably isn't an issue worth perusing.
> 
> Well, we have what looks like a fix now.  The reason it matters is that
>   if the bus is not in AHD_MODE_SCSI when the routine is called, it ends
> up being in a wrong state when the routine exits, so you abort one
> command and screw up another.  Ultimately I bet escalation to bus reset
> fixes it, so everything appears to work, but it might have worked a lot
> better if the original mode were restored.
> 
> This is error handling code, so most installations run just fine
> without ever invoking it.
> 
And since you mention it, it might also explain why every time this 
routine got invoked it failed to fixup anything and got escalated to bus 
reset.
(And yes, I _did_ have some customer issues with aic79xx EH escalations 
over the years).

Testing will be tricky, though, as you'd have to inject timeouts onto 
the parallel bus or device.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
