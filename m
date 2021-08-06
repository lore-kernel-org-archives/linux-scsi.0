Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192E9C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 08:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3FB161052
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 08:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhHFIgN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 04:36:13 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44414 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhHFIgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 04:36:12 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6CFCB1FEB5;
        Fri,  6 Aug 2021 08:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628238956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p1CWzLZt/NtYjFo2iHfGLdoJ9qlVnFGVOJD1asTKnq0=;
        b=Yu7SCPunAYBQ5d43ZsS00RiquxT58S0Dmyk9HIdcTV+n3XNP2u15b/Bk45ML2wFZOqIEk/
        KGrsXsk2oj5KxCzcVb4Xgk1aEZbkqLh5EVKyauIDEM+VxfrCGweVNaPo2YNHt8dh8VCCd4
        aij2ZJxOxK30ajvFV2F96FN981vH39Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628238956;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p1CWzLZt/NtYjFo2iHfGLdoJ9qlVnFGVOJD1asTKnq0=;
        b=4ghKdO5GtZ1ybrj9kGkL8tCpMEDjDVtOqqECyCP61n4W1uXcGjjUahdLI3YG9EVfOQLoFl
        xqgDvABozA2ftuBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 54D1C13A6A;
        Fri,  6 Aug 2021 08:35:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1wr6E2z0DGG6YgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 06 Aug 2021 08:35:56 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <yq18s1ffdz7.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB7081398426CA28606DC39491E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 0/4] Initial support for multi-actuator HDDs
Message-ID: <c3a28f3f-52c4-e7bc-8bd7-bec2feae25fa@suse.de>
Date:   Fri, 6 Aug 2021 10:35:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB7081398426CA28606DC39491E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 6:05 AM, Damien Le Moal wrote:
> On 2021/08/06 12:42, Martin K. Petersen wrote:
>>
>> Damien,
>>
>>> Single LUN multi-actuator hard-disks are cappable to seek and execute
>>> multiple commands in parallel. This capability is exposed to the host
>>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
>>> Each positioning range describes the contiguous set of LBAs that an
>>> actuator serves.
>>
>> I have to say that I prefer the multi-LUN model.
> 
> It is certainly easier: nothing to do :)
> SATA, as usual, makes things harder...
> 
>>
>>> The first patch adds the block layer plumbing to expose concurrent
>>> sector ranges of the device through sysfs as a sub-directory of the
>>> device sysfs queue directory.
>>
>> So how do you envision this range reporting should work when putting
>> DM/MD on top of a multi-actuator disk?
> 
> The ranges are attached to the device request queue. So the DM/MD target driver
> can use that information from the underlying devices for whatever possible
> optimization. For the logical device exposed by the target driver, the ranges
> are not limits so they are not inherited. As is, right now, DM target devices
> will not show any range information for the logical devices they create, even if
> the underlying devices have multiple ranges.
> 
> The DM/MD target driver is free to set any range information pertinent to the
> target. E.g. dm-liear could set the range information corresponding to sector
> chunks from different devices used to build the dm-linear device.
> 
And indeed, that would be the easiest consumer.
One 'just' needs to have a simple script converting the sysfs ranges
into the corresponding dm-linear table definitions, and create one DM
device for each range.
That would simulate the multi-LUN approach.
Not sure if that would warrant a 'real' DM target, seeing that it's
fully scriptable.

>> And even without multi-actuator drives, how would you express concurrent
>> ranges on a DM/MD device sitting on top of a several single-actuator
>> devices?
> 
> Similar comment as above: it is up to the DM/MD target driver to decide if range
> information can be useful. For dm-linear, there are obvious cases where it is.
> Ex: 2 single actuator drives concatenated together can generate 2 ranges
> similarly to a real split-actuator disk. Expressing the chunks of a dm-linear
> setup as ranges may not always be possible though, that is, if we keep the
> assumption that a range is independent from others in terms of command
> execution. Ex: a dm-linear setup that shuffles a drive LBA mapping (high to low
> and low to high) has no business showing sector ranges.
> 
>> While I appreciate that it is easy to just export what the hardware
>> reports in sysfs, I also think we should consider how filesystems would
>> use that information. And how things would work outside of the simple
>> fs-on-top-of-multi-actuator-drive case.
> 
> Without any change anywhere in existing code (kernel and applications using raw
> disk accesses), things will just work as is. The multi/split actuator drive will
> behave as a single actuator drive, even for commands spanning range boundaries.
> Your guess on potential IOPS gains is as good as mine in this case. Performance
> will totally depend on the workload but will not be worse than an equivalent
> single actuator disk.
> 
> FS block allocators can definitely use the range information to distribute
> writes among actuators. For reads, well, gains will depend on the workload,
> obviously, but optimizations at the block IO scheduler level can improve things
> too, especially if the drive is being used at a QD beyond its capability (that
> is, requests are accumulated in the IO scheduler).
> 
> Similar write optimization can be achieved by applications using block device
> files directly. This series is intended for this case for now. FS and bloc IO
> scheduler optimization can be added later.
> 
> 
Rumours have it that Paolo Valente is working on adapting BFQ to utilize
the range information for better actuator utilisation.
And eventually one should modify filesystem utilities like xfs to adapt
the metadata layout to multi-actuator drives.

The _real_ fun starts once the HDD manufactures starts putting out
multi-actuator SMR drives :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
