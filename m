Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15E0C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8148E61182
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhD0IVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:21:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:34322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhD0IVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:21:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CCEEAB001;
        Tue, 27 Apr 2021 08:21:04 +0000 (UTC)
To:     Martin Wilck <martin.wilck@suse.com>,
        "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
        "Ulrich.Windl@rz.uni-regensburg.de" 
        <Ulrich.Windl@rz.uni-regensburg.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        Hannes Reinecke <hare@suse.com>, "hch@lst.de" <hch@lst.de>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
 <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
 <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
 <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
 <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
 <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
 <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
 <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
 <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
 <b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
 <15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
Message-ID: <2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
Date:   Tue, 27 Apr 2021 10:21:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/27/21 10:10 AM, Martin Wilck wrote:
> On Tue, 2021-04-27 at 13:48 +1000, Erwin van Londen wrote:
>>>
>>> Wrt 1), we can only hope that it's the case. But 2) and 3) need work,
>>> afaics.
>>>
>> In my view the WWID should never change. 
> 
> In an ideal world, perhaps not. But in the dm-multipath realm, we know
> that WWID changes can happen with certain storage arrays. See 
> https://listman.redhat.com/archives/dm-devel/2021-February/msg00116.html 
> and follow-ups, for example.
> 
And it's actually something which might happen quite easily.
The storage array can unmap a LUN, delete it, create a new one, and map
that one into the same LUN number than the old one.
If we didn't do I/O during that interval upon the next I/O we will be
getting the dreaded 'Power-On/Reset' sense code.
_And nothing else_, due to the arcane rules for sense code generation in
SAM.
But we end up with a completely different device.

The only way out of it is to do a rescan for every POR sense code, and
disable the device eg via DID_NO_CONNECT whenever we find that the
identification has changed. We already have a copy of the original VPD
page 0x83 at hand, so that should be reasonably easy.

I had a rather lengthy discussion with Fred Knight @ NetApp about
Power-On/Reset handling, what with him complaining that we don't handle
is correctly. So this really is something we should be looking into,
even independently of multipathing.

But actually I like the idea from Martin Petersen to expose the parsed
VPD identifiers to sysfs; that would allow us to drop sg_inq completely
from the udev rules.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
