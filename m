Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4BDC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 15:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348307AbiDKPzS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 11:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiDKPzR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 11:55:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDA12ED4C
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 08:53:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 39F7B68AA6; Mon, 11 Apr 2022 17:52:59 +0200 (CEST)
Date:   Mon, 11 Apr 2022 17:52:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: Re: [PATCH v2 0/6] scsi: fix scsi_cmd::cmd_len
Message-ID: <20220411155258.GA25715@lst.de>
References: <20220410173652.313016-1-dgilbert@interlog.com> <20220411050325.GA13927@lst.de> <aa2a08cc-ba98-b538-2448-d528e8eef917@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa2a08cc-ba98-b538-2448-d528e8eef917@interlog.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 11, 2022 at 11:06:17AM -0400, Douglas Gilbert wrote:
> On 2022-04-11 01:03, Christoph Hellwig wrote:
>> This still misses any good explanation of why we want all this.
>
> Advantages:
>    - undoes regression in ce70fd9a551af, that is:
>        - cdb_len > 32 no longer allowed (visible to the user space), undone

What exact regression causes this for real users and no just people
playing around with scsi_debug?

>        - but we still have this one:
>            - prior to lk5.18 sizeof(scsi_cmnd::cmnd) is that of a
>              pointer but >= lk5.18 sizeof(scsi_cmnd::cmnd) is 32 (or 16)

Please check the total size of struct scsi_cmnd, which is what really
matters.

>    - makes all scsi_cmnd objects 16 bytes smaller

Do we have data why this matters?

>    - hides the poorly named dtor for scsi_cmnd objects (blk_mq_free_request)
>      within a more intuitively named inline: scsi_free_cmnd

I don't think this is in any way poorly named.

> Disadvantages:
>     - burdens each access to a CDB with (scsi_cmnd::flags & SCMD_LONG_CDB)
>       check
>     - LLDs that want to fetch 32 byte CDBs (or longer) need to use the
>       scsi_cmnd_get_cdb() access function. For CDB lengths <= 16 bytes
>       they can continue to access scsi_cmnd::cmnd directly

It adds back the dynamic allocation for 32-byte CDBs that we got rid of.
It also breaks all LLDS actually using 32-byte CDBS currently as far as
I can tell.
