Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5407C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 16:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C07D8206DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 16:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgFEQuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:50:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:41808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgFEQuN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 Jun 2020 12:50:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 53E13AD2C;
        Fri,  5 Jun 2020 16:50:15 +0000 (UTC)
Subject: Re: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs
To:     Don.Brace@microchip.com, martin.petersen@oracle.com
Cc:     hch@lst.de, james.bottomley@hansenpartnership.com,
        john.garry@huawei.com, ming.lei@redhat.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org
References: <20200430131904.5847-1-hare@suse.de>
 <SN6PR11MB2848512EB578D01F981F8705E1860@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1331858c-6111-aab3-ad6e-16e27661a35c@suse.de>
Date:   Fri, 5 Jun 2020 18:50:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848512EB578D01F981F8705E1860@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/20 5:32 PM, Don.Brace@microchip.com wrote:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git reserved-tags.v3
> 
> As usual, comments and reviews are welcome.
> 
> I cloned your tree and ran some tests using hpsa.
> 
> I used 3 SATA HBA disks, 3 SAS HBA disks, 2 LOGICAL VOLUMES using HDDs, and 2 LOGICAL VOLUMES using SDDs for ioaccel path.
> 
> I have an IO stress test that does mkfs, mount/umount, fio, and fsck to the above volumes while doing sg_reset opeations in parallel.
> 
> The stress test has survived 2 full days of testing.
> 
> However, my insmod/rmmod test causes a kernel panic.
> 
> Not sure why yet. I had re-cloned yesterday an d the panic is still there.
> 
> Earlier kernel versions do not panic on rmmod.
> 
> --
> 2.16.4
> 
Ah, right. Of course.

Should be fixed with this patch:\

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fdc291c47b9b..87469908524c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1885,9 +1885,9 @@ void scsi_forget_host(struct Scsi_Host *shost)
                 goto restart;
         }
         /* Remove virtual device last, might be needed to send commands */
+       spin_unlock_irqrestore(shost->host_lock, flags);
         if (virtual_sdev)
                 __scsi_remove_device(virtual_sdev);
-       spin_unlock_irqrestore(shost->host_lock, flags);
  }

  /**

Can you test with that?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
