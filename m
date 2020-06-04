Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE055C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 16:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C121B20738
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 16:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgFDQP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 12:15:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:56810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbgFDQP7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jun 2020 12:15:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8581CB24B;
        Thu,  4 Jun 2020 16:16:01 +0000 (UTC)
Subject: Re: RFC: split struct scsi_device in two
To:     dgilbert@interlog.com,
        SCSI development list <linux-scsi@vger.kernel.org>
References: <5bcc1fee-e221-e54a-d754-d04a2e6fda33@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ff06002f-6615-6ce7-8a23-994555e7e6f5@suse.de>
Date:   Thu, 4 Jun 2020 18:15:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5bcc1fee-e221-e54a-d754-d04a2e6fda33@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/4/20 6:08 PM, Douglas Gilbert wrote:
> The scsi_device structure seems to be carrying around a lot of baggage.
> Assuming the object needs to be present on the SCSI fast path then
> making it smaller will help in fitting one or several of them in cache
> lines.
> 
> Now the effort to use xarrays is helping, but only in the order 32 bytes
> at the moment. Currently we have pointers to the standard inquiry response
> and several VPD pages with more VPD pages to come, I suspect.
> 
> So what about having a secondary scsi_device object (with a more
> descriptive name) for all those parts of the currect scsi_device
> object that aren't needed for the fast path? The secondary object
> could be created in scsi_alloc_sdev() and pointed to by the
> primary object (and vice versa). Then adding more context info
> (e.g. more VPD pages) will not burden the fast path.
> 
> sizeof(struct scsi_device)=1976 bytes!
> 
> Comments?
> 
Not sure if that's worth it.

What is far more pressing is a _real_ scsi device rescan, ie the 
possibility of the scsi device changing its inquiry data upon rescan.
At this time the inquiry data is essentially frozen, and the only way to 
handle this is to remove the device and rescan everything
(scsi-rescan-bus.sh -r ...).
It would far better if we could just issue a rescan and the scsi core 
would detect the change internally without the need to recreate the 
object itself.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
