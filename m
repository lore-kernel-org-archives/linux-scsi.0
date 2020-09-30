Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAD5C4727F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 11:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576F6207FB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 11:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgI3Luq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 07:50:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:34548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3Luq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 07:50:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8C88CAC97;
        Wed, 30 Sep 2020 11:50:45 +0000 (UTC)
Subject: Re: [PATCH v2 8/8] lpfc: Added support to handle marginal state
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-9-git-send-email-muneendra.kumar@broadcom.com>
 <a0fb7bae-b6e7-8f28-f45f-0453311f383e@suse.de>
 <ce3d51fbc3fe51b29e82f6a3e317388b@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dbda3941-727b-293f-97f8-4c67342c7920@suse.de>
Date:   Wed, 30 Sep 2020 13:50:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ce3d51fbc3fe51b29e82f6a3e317388b@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/20 1:33 PM, Muneendra Kumar M wrote:
> Hi Hannes,
> Thanks for the input.
> 
>>> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
>>> @@ -4526,6 +4526,12 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct
>>> scsi_cmnd *cmnd)
>>>    		cmnd->result = err;
>>>    		goto out_fail_command;
>>>    	}
>>> +
>>> +	/*
>>> +	 * If port state is marginal
>>> +	 * Set the SCMD_NORETRIES_ABORT bit in scmd->state
>>> +	 */
>>> +	fc_rport_chkmarginal_set_noretries(rport, cmnd);
>>>    	ndlp = rdata->pnode;
>>>
>>>    	if ((scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) &&
>>>
>> This really should be moved into the transport class; fc_block_rport()
>> would be an ideal place for it.
> 
> [Muneendra]Correct me if I didn't understand correctly.
> As fc_block_rport cannot take arg of scsi_cmd can we add it as part of
> fc_block_scsi_eh ?
> 
Ah, right.
Actually I meant 'fc_remote_port_chkready()'.
That doesnt' take an scmd as argument, but I don't see why we can't 
modify it to have an additonal 'sdev' parameter...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
