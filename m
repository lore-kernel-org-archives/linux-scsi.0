Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16333C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 20:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B664164F61
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 20:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhBBUtZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:49:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:45704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231343AbhBBUtX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 15:49:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612298917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0AiDbdfvkfioMr2lwDiljufHKju9PMRRBj3UXL4HZ2U=;
        b=nrHj8GcFkfQdsyTjYI9IYx075zehjRRb2DXRpxDq3ytCLklOvbtmSrfVn19cgn+YQEDsV5
        gGoCiQfdpGlSJM/Rf5vy9pzevfhcegcFgJ0VSaBKkhyWNPocsxt/Du5/OSa7qsio6tD5RT
        uwCioXQBLJZsz6w/zguP5+ISrtZhzXE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EFC5BAC55;
        Tue,  2 Feb 2021 20:48:36 +0000 (UTC)
Message-ID: <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
From:   Martin Wilck <mwilck@suse.com>
To:     Don.Brace@microchip.com, john.garry@huawei.com,
        buczek@molgen.mpg.de, martin.petersen@oracle.com,
        ming.lei@redhat.com
Cc:     jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, hare@suse.de,
        Kevin.Barnett@microchip.com, pmenzel@molgen.mpg.de, hare@suse.com
Date:   Tue, 02 Feb 2021 21:48:35 +0100
In-Reply-To: <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210120184548.20219-1-mwilck@suse.com>
         <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
         <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
         <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
         <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
         <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
         <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-02-02 at 20:04 +0000, Don.Brace@microchip.com wrote:
> -----Original Message-----
> From: John Garry [mailto:john.garry@huawei.com] 
> Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count
> early
> 
> 
> Confirmed my suspicions - it looks like the host is sent more
> commands than it can handle. We would need many disks to see this
> issue though, which you have.
> 
> So for stable kernels, 6eb045e092ef is not in 5.4 . Next is 5.10, and
> I suppose it could be simply fixed by setting .host_tagset in scsi
> host template there.
> 
> Thanks,
> John
> --
> Don: Even though this works for current kernels, what would chances
> of this getting back-ported to 5.9 or even further?
> 
> Otherwise the original patch smartpqi_fix_host_qdepth_limit would
> correct this issue for older kernels.

True. However this is 5.12 material, so we shouldn't be bothered by
that here. For 5.5 up to 5.9, you need a workaround. But I'm unsure
whether smartpqi_fix_host_qdepth_limit would be the solution.
You could simply divide can_queue by nr_hw_queues, as suggested before,
or even simpler, set nr_hw_queues = 1.

How much performance would that cost you?

Distribution kernels would be yet another issue, distros can backport
host_tagset and get rid of the issue.

Regards
Martin









