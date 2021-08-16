Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0B6C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 11:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 712CF61C11
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 11:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbhHPLLl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 07:11:41 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55558 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhHPLLl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 07:11:41 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1CB761FE29;
        Mon, 16 Aug 2021 11:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629112269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQLCqoGLB8wD1bVQrV6+hI3/ERfrf7diJmaBFIK3Mxc=;
        b=eHIT7Ra3TM9AadU2N5MuKKXo/XPyyQ8s1CIenv8Tg/g0hsC/szJJm6cQ+eojl7GVX3jbij
        7j34TZlWYl8l9HrQ32MfGBaVnK6l2SyIk7ZmslSvyM3kdMgBCuIjTbZ02PiWfI5qOdeRHu
        EvgJfF7WAr9lK6eP3K/3CIKo6O8eWm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629112269;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQLCqoGLB8wD1bVQrV6+hI3/ERfrf7diJmaBFIK3Mxc=;
        b=+v/pI8gcnihBHzcGSdhfSlXQyhwfHwBUGNDOv1USO0a7L4eBehsNS7asOC82Oj385Pbj38
        OHQAkt6n4B+MRlCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F1BB913B0A;
        Mon, 16 Aug 2021 11:11:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id URAYOsxHGmEXYwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 16 Aug 2021 11:11:08 +0000
Subject: Re: [PATCH 2/3] scsi: fnic: Stop setting scsi_cmnd.tag
To:     John Garry <john.garry@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <1628862553-179450-3-git-send-email-john.garry@huawei.com>
 <3e5d1bd4-cee9-7fd0-93a4-58d808e198f6@acm.org>
 <20210814073948.GA21536@lst.de>
 <b6216e3f-5339-18e4-ca31-61c7968efbb1@suse.de>
 <2e6dd74f-bd5a-22b8-f20b-d4b54fc4ade3@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9ec48220-68aa-e2d1-5555-d7307e29260d@suse.de>
Date:   Mon, 16 Aug 2021 13:11:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2e6dd74f-bd5a-22b8-f20b-d4b54fc4ade3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/21 12:00 PM, John Garry wrote:
> On 14/08/2021 13:35, Hannes Reinecke wrote:
>> On 8/14/21 9:39 AM, Christoph Hellwig wrote:
>>> On Fri, Aug 13, 2021 at 08:17:45PM -0700, Bart Van Assche wrote:
>>>> On 8/13/21 6:49 AM, John Garry wrote:
>>>>> It is never read. Setting it and the request tag seems dodgy
>>>>> anyway.
>>>>
>>>> This is done because there is code in the SCSI error handler that may
>>>> allocate a SCSI command without allocating a tag. See also
>>>> scsi_ioctl_reset().
> 
> Right, so we just get a loan of the tag of a real request. fnic driver
> comment:
> 
> "Really should fix the midlayer to pass in a proper request for ioctls..."
> 
>>>
>>> Yes.  Hannes had a great series to stop passing the pointless scsi_cmnd
>>> to the reset methods.  Hannes, any chance you coul look into
>>> resurrecting that?
>>>
>> Sure.
> 
> The latest iteration of that series - at v7 - still passed that fake
> SCSI command to the reset method, and the reset method allocated the
> internal command.
> 
> So will we change change scsi_ioctl_reset() to allocate an internal
> command, rather than the LLDD?
> 
Nah, Christoph was talking about my patch series to revamp the SCSI
error handler.
With that one we'll be passing the respective objects to the SCSI EH
functions (ie struct scsi_device for eh_device_reset()), doing away with
the need to allocate an internal command for ioctl reset.
Currently revamping the patchset, should be ready later this week.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
