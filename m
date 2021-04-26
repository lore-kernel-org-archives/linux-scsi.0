Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FAAC43461
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 07:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FEB6611CA
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 07:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhDZHbf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 03:31:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:51118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhDZHbe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 03:31:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3D5ECB00D;
        Mon, 26 Apr 2021 07:30:52 +0000 (UTC)
Subject: Re: [PATCH 0/5] scsi: fnic: use blk_mq_tagset_busy_iter() to walk
 scsi commands
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210421075543.1919826-1-ming.lei@redhat.com>
 <d251c21e-dd3e-979a-1c90-1f94b042e83c@suse.de> <YIC+ieKIKovpwptY@T590>
 <YIGFfScR3ZBluX01@T590>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <0e4449f0-db4f-6127-a548-c2c841dca49e@suse.de>
Date:   Mon, 26 Apr 2021 09:30:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIGFfScR3ZBluX01@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 4:17 PM, Ming Lei wrote:
> On Thu, Apr 22, 2021 at 08:08:41AM +0800, Ming Lei wrote:
>> On Wed, Apr 21, 2021 at 10:14:56PM +0200, Hannes Reinecke wrote:
>>> On 4/21/21 9:55 AM, Ming Lei wrote:
>>>> Hello Guys,
>>>>
>>>> fnic uses the following way to walk scsi commands in failure handling,
>>>> which is obvious wrong, because caller of scsi_host_find_tag has to
>>>> guarantee that the tag is active.
>>>>
>>>>          for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
>>>> 				...
>>>>                  sc = scsi_host_find_tag(fnic->lport->host, tag);
>>>> 				...
>>>> 		}
>>>>
>>>> Fix the issue by using blk_mq_tagset_busy_iter() to walk
>>>> request/scsi_command.
>>>>
>>>> thanks,
>>>> Ming
>>>>
>>>>
>>>> Ming Lei (5):
>>>>    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
>>>>      fnic_terminate_rport_io
>>>>    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
>>>>      fnic_clean_pending_aborts
>>>>    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
>>>>      fnic_cleanup_io
>>>>    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
>>>>      fnic_rport_exch_reset
>>>>    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
>>>>      fnic_is_abts_pending
>>>>
>>>>   drivers/scsi/fnic/fnic_scsi.c | 933 ++++++++++++++++++----------------
>>>>   1 file changed, 493 insertions(+), 440 deletions(-)
>>>>
>>>> Cc: Satish Kharat <satishkh@cisco.com>
>>>> Cc: Karan Tilak Kumar <kartilak@cisco.com>
>>>> Cc: David Jeffery <djeffery@redhat.com>
>>>>
>>> Well, this is actually not that easy for fnic.
>>> Problem is the reset hack hch put in some time ago (cf
>>> fnic_host_start_tag()), which will cause any TMF to use a tag which is _not_
>>> visible to the busy iter.
>>
>> 'git grep -n fnic_host_start_tag ./' shows nothing.
>>
>>> That will cause the iter to miss any TMF, with unpredictable results if a
>>> TMF is running at the same time than, say, a link bounce.
>>
>> Wrt. linus tree or next tree, I don't see any issue wrt. your concern.
>>
>>>
>>> I have folded this as part of my patchset for reserved commands in SCSI;
>>> that way fnic can use 'normal' tags for TMFs, which are then visible to the
>>> busy iter and life's good.
>>
>> No, this fix is one bug fix, which can't depend on your reserved
>> command in SCSI, and they need to be backported to stable tree too.
> 
> Hi Hannes,
> 
> We have customers report on this issue, could you please let us know
> if you will post out one bug-fix only version?
> 
And so have we, and indeed we have the same bug reports.
So I'll be splitting off those patches and send it as a stand-alone
patchset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
