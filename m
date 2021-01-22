Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E038C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 00:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C5A423A5E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 00:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbhAVAPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 19:15:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:46580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbhAVAPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 19:15:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611274464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MItRsCGJp16QrZvw3B4KwEgPlJ4YNLlvqdE/Z/iA5Rc=;
        b=aQ12UDYzxEmOVn3RQL0Bwus/qvLmg5Gp219fCm8vRuDxRZTneDgfRJVseVNis/J4whkqeI
        nBnbIZKGqX0W4zup6y0Puwg3wVQcqj0SKs8Xo11MVd+9pYwJpNP9fGMtb/aazYFqmLxmms
        bN4PI4YqFrfRs0UXrU/4nJV2yHAzH0g=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B58F6AC45;
        Fri, 22 Jan 2021 00:14:24 +0000 (UTC)
Message-ID: <5a5ac22d5bc36b8e743e5e609411aa0b64490718.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
From:   Martin Wilck <mwilck@suse.com>
To:     Donald Buczek <buczek@molgen.mpg.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        John Garry <john.garry@huawei.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Fri, 22 Jan 2021 01:14:23 +0100
In-Reply-To: <166f7a2e10f27647aee5d62e31a074af982b52e8.camel@suse.com>
References: <20210120184548.20219-1-mwilck@suse.com>
         <936ea886-e7ae-c3c5-1bab-911754050fff@molgen.mpg.de>
         <166f7a2e10f27647aee5d62e31a074af982b52e8.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-01-21 at 11:05 +0100, Martin Wilck wrote:
> On Thu, 2021-01-21 at 10:07 +0100, Donald Buczek wrote:
> > 
> > Unfortunately, this patch (on top of 6eb045e092ef) did not fix the
> > problem. Same error (""controller is offline: status code
> > 0x6100c"")

Rethinking, this patch couldn't have fixed your problem. I apologize
for the dumb suggestion.

However, I still believe I had a point in that patch, and would like to
ask the experts for an opinion.

Assume no commands in flight (busy == 0), host_blocked == 2, and that
two CPUs enter scsi_host_queue_ready() at the same time. Before
6eb045e092ef, it was impossible that the function returned 1 on either
CPU in this situation.

CPU 1                              CPU 2

scsi_host_queue_ready              scsi_host_queue_ready
   host_busy = 1                      host_busy = 2
      (busy = 0)                         (busy = 1)
   host_blocked = 1                   goto starved
   goto out_dec                       add sdev to starved list
   host_busy = 1                      host_busy = 0
   return 0                           return 0
                                      
With 6eb045e092ef (and without my patch), the result could be:

CPU 1                              CPU 2

scsi_host_queue_ready              scsi_host_queue_ready
  read scsi_host_busy() = 0          read scsi_host_busy() = 0
  host_blocked = 1                   host_blocked = 0
  goto out_dec                       remove sdev from starved list
  return 0                           set SCMD_STATE_INFLIGHT 
                                       (host_busy = 1)
                                     return 1
  
So now, one command can be sent, and the host is unblocked. A very
different outcome than before. Was this intentional?

Thanks
Martin



