From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Sun, 12 Jan 2014 13:49:36 +0200
Message-ID: <52D28150.8090908@dev.mellanox.co.il>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-8-git-send-email-nab@daterainc.com>	<52CE78EB.60108@mellanox.com>	<1389334891.5567.373.camel@haakon3.risingtidesystems.com>	<52D04F1A.2000808@redhat.com> <yq1eh4fr2ee.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35914 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaALLtl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 06:49:41 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so2825086eak.39
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 03:49:40 -0800 (PST)
In-Reply-To: <yq1eh4fr2ee.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>

On 1/10/2014 10:46 PM, Martin K. Petersen wrote:
>>>>>> "Andy" == Andy Grover <agrover@redhat.com> writes:
> Andy> Yes, don't you need FORMAT UNIT because protection information is
> Andy> going to mean the pi-enabled lun will need to report less blocks?
>
> Modern disk drives won't shrink when you reformat them with PI. This is
> a result of an IDEMA agreement about LBA counts.
>
> And if you create a 10GB PI LUN on an array you'll get 10GB for data.
>
> Andy> The ramdisk backstore changes in this series allocate extra space
> Andy> for PI info, but my understanding was that especially for
> Andy> emulation with block and fileio backstores, everything needs to go
> Andy> in the same amount of space.
>
> For both file and block I'd recommend we store the PI in a separate
> block device or file unless the backing device is PI-capable.
>
> Andy> Furthermore, if we want PI info stored along with the blocks, then
> Andy> block and fileio backstore formats are no longer going to be 1:1
> Andy> -- requiring offset calculations, non-aligned read-modify-write,
> Andy> and all that unpleasantness to be handled?
>
> I only think interleaved makes sense if you're passing the PI through
> instead of emulating.
>

I agree, I implemented interleaved mode just as a proof of concept that 
our HW can perform offload in that manner.
I assume we can stick with non-interleaved, although it can be added as 
a user option.

Sagi.
