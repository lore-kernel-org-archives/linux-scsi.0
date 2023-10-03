Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A855E776D4
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 00:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjJCAca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 20:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjJCAc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 20:32:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D4EA1;
        Mon,  2 Oct 2023 17:32:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABBFC433C7;
        Tue,  3 Oct 2023 00:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696293146;
        bh=VeFD+uu6j4ka+2nUcArP6O3Vu/j9vqO8BeQ+fjqBsHw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=D06qbyAJ81FOehMqXUecu4o8n7gtS0gQXAX313K4a3qbnmNYUsAT+nvREQHNQNK3x
         dMdyS+1nEnb1GPQevOlgUDs0kQi/RbqS5OAxDcJ2QvuDZ8prDH8rr9fGwKojktOVjS
         ugJy1hRB3cVqjiR6q28i1s0ome6fb2BHHs3kjM7d02WgES0/WTCUWAIK+1VakNNZGd
         coY8crxZ19xS/lryKCJm7uHhme1+GOc+kXsClOwyL2Uas4dfkjYszRt9/gtd0x1PFr
         DN5uZYHkIRJyo9ukS7A4R0mbtqKa33Y7P92kIJ4vwCaRJexpEruqTG2gCWDhm6HjB/
         z5aeXb7EWXrew==
Message-ID: <5f6d22f5-3be0-4499-3c7a-354005b22e42@kernel.org>
Date:   Tue, 3 Oct 2023 09:32:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v8 00/23] Fix libata suspend/resume handling and code
 cleanup
To:     Phillip Susi <phill@thesusis.net>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <874jj8sia5.fsf@vps.thesusis.net>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <874jj8sia5.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/23 08:39, Phillip Susi wrote:
> 
> I went to test these patches tonight and it looks like Linus already
> merged them ( or mostly? ).  I enabled runtime pm on the scsi target and
> the ata port, and the disk spins down and the port does too.
> 
> I noticed though, that when entering system suspend, a disk that has
> already been runtime suspended is resumed only to immediately be
> suspended again before the system suspend.  That shouldn't happen should
> it?

Indeed. Will look at this. Geert also reported seeing an issue with resume (one
time only, so I suspect there is still a race with libata-eh). So looks like
something is still missing.

-- 
Damien Le Moal
Western Digital Research

