Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C079C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 02:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32A32368A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 02:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbhANC7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:59:40 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:56256 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbhANC7j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 21:59:39 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 79DF72EA00F;
        Wed, 13 Jan 2021 21:58:58 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 5rXEq1ltfbW9; Wed, 13 Jan 2021 21:45:41 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id A88882EA00E;
        Wed, 13 Jan 2021 21:58:57 -0500 (EST)
Subject: Re: [PATCH v13 44/45] sg: [RFC] add blk_poll support
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-45-dgilbert@interlog.com>
Message-ID: <e6f5fda6-9fca-6981-fe67-9b11bbf0bb49@interlog.com>
Date:   Wed, 13 Jan 2021 21:58:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210113224526.861000-45-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-13 5:45 p.m., Douglas Gilbert wrote:
> The support is added via the new SGV4_FLAG_HIPRI command flag which
> causes REQ_HIPRI to be set on the request. Before waiting on an
> inflight request, it is checked to see if it has SGV4_FLAG_HIPRI,
> and if so blk_poll() is called instead of the wait. In situations
> where only the file descriptor is known (e.g. sg_poll() and
> ioctl(SG_GET_NUM_WAITING)) all inflight requests associated with
> the file descriptor that have SGV4_FLAG_HIPRI set, have sg_poll()

s/have sg_poll/have blk_poll/

> called on them.
> 
> Note that the implementation of blk_poll() calls mq_poll() in the
> LLD associated with the request. Then for any request found to be
> ready, blk_poll() invokes the scsi_done() callback. So this means
> if blk_poll() returns 1 then sg_rq_end_io() has already been
> called for the polled request.

<snip>
