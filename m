Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AE2C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F5861103
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhDZPoK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:44:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:36804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhDZPoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 11:44:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1E17FABB1;
        Mon, 26 Apr 2021 15:43:27 +0000 (UTC)
Subject: Re: [PATCH 14/39] NCR5380: Fold SCSI message ABORT onto DID_ABORT
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-15-hare@suse.de> <20210426152329.GF25615@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <1d1f8968-dda3-8b2c-fc85-33aed78a6d4c@suse.de>
Date:   Mon, 26 Apr 2021 17:43:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210426152329.GF25615@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 5:23 PM, Christoph Hellwig wrote:
> On Fri, Apr 23, 2021 at 01:39:19PM +0200, Hannes Reinecke wrote:
>> The message byte can take only two values, COMMAND_COMPLETE and ABORT.
>> So we can easily map ABORT to DID_ABORT and do not set the message byte.
> 
> The real question is rather: did anyone care about the message byte,
> and why can't this assignment be dropped entirely?
> 
We need to handle this to be compatible with current SCSI EH. There we do

if (msg_byte(scmd->result) != COMMAND_COMPLETE)
    return FAILED;

And as it's extremely hard to validate the various stages which the
driver can find itself I couldn't exclude that the ABORT message never
ended up present by the time the command completed.
Hence I'd opted for the careful approach and mapped it to DID_ABORT;
that way I'm sure I don't mess up SCSI EH.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
