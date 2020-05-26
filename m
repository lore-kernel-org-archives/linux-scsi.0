Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE05BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 07:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD1132070A
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 07:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgEZHY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 03:24:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:55194 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgEZHY4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 May 2020 03:24:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4408EAEA2;
        Tue, 26 May 2020 07:24:57 +0000 (UTC)
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
To:     dgilbert@interlog.com, Matthew Wilcox <willy@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
 <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
 <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
 <20200525174052.GD17206@bombadil.infradead.org>
 <f11f3d83-19a5-7a2a-bf14-917536514f68@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4d026d56-5859-965c-4813-99539ede1309@suse.de>
Date:   Tue, 26 May 2020 09:24:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f11f3d83-19a5-7a2a-bf14-917536514f68@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/26/20 4:01 AM, Douglas Gilbert wrote:
[ .. ]
> 
> Attached is a UML (like) class diagram for folks to kick around. It handles
> u32 values for the host, channel and target_id level and u64 at the lun
> (leaf) level, via a bit of hackery, even on 32 bit machines. So the object
> tree is built on the diagonal, with the multiplicity coming from xarray
> members (attributes). The arrowed lines show inheritance, with
> struct device being the base class aka superclass (one could argue
> otherwise). The "transport_class_<n>"s are added as needed by SCSI
> transports such as SAS and iSCSI.
> 
> And it uses native xarray indexes up to 2**32 - 1. So it meets all the
> constraints we have currently.
> 
> Plus, based on the answers I get from above questions, in the
> scsi_lu_low32 class I would like to add another xarray, that holds
> bitsets rather than pointers. Each bitset holds amongst other things
> the 9 scsi_device states. That way you could iterate through all
> LU devices looking for an uncommon state _without_ dereferencing
> pointers to any sdev_s that are bypassed. And if xarray is cache
> efficient in storing its data, then it would be much faster. The
> same thing (i.e. bitset xarray) could be done in scsi_channel, for
> starget states.
> 
> Finally, for efficient xarray use, every object needs to be able to
> get to its parent (or at least, its "collection") quickly as that is
> where all xarray operations take place. And by efficient I do _not_
> mean calling dev_to_shost(starget->dev.parent) when we built the
> object hierarchy and _know_ where its "shost" is.
> 
I would kill the 'channel' object, and use a combined 'channel':'target' 
index for the scsi target. The 'channel' really is only a number, and
doesn't have an object on its own.
And for the LUN numbers I doubt we need to have two lookup arrays; one
32bit array would be sufficient to hold basically _all_ installations
I've seen so far (I've yet to come across on installation using more 
than two LUN levels).
What we could to is use the index into REPORT LUNs as the array index;
things might shuffle around there if someone remaps devices, but that's
a tough one even nowadays.

Lemme see...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
