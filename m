From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for LBA48 devices
Date: Fri, 12 Aug 2016 16:17:05 +0800
Message-ID: <CAGnHSE=fMOs7Z40CWukaKQXeqgfFNvxEjno=FstFV1ayAEepfQ@mail.gmail.com>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
 <10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
 <20160810041042.GH25053@mtj.duckdns.org> <CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
 <yq1twesq8lm.fsf@sermon.lab.mkp.net> <CAGnHSEn3pXR33Ju+mr0DYdE0G7kNhxNCbvocX1pZXvYfxx5+3A@mail.gmail.com>
 <yq1mvkipwx5.fsf@sermon.lab.mkp.net> <CAGnHSEm0mGPG_y2a7hmCzQkwYE23Srozrm6eSPX8a3Q9a0y+7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35350 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbcHLIRH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2016 04:17:07 -0400
In-Reply-To: <CAGnHSEm0mGPG_y2a7hmCzQkwYE23Srozrm6eSPX8a3Q9a0y+7A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, jmoyer@redhat.com, axboe@fb.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

On 12 August 2016 at 13:18, Tom Yan <tom.ty89@gmail.com> wrote:
> On 12 August 2016 at 10:01, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>
>> Again, the point of max_hw_sectors and max_dev_sectors is to enforce the
>> hard limits of controller and device respectively. Nothing else.
>>
>
> Sounds like libata-scsi is doing something wrong then. It should not
> set max_hw_sectors to dev->max_sectors that is set by libata-core:
>
>> blk_queue_max_hw_sectors(q, dev->max_sectors);

Though we'll still have to "abuse" max_hw_sectors for ATAPI class
devices, since neither the SATL or sr cares about VPD. The only
devices that need ATA_HORKAGE_MAX_SEC_LBA48 are ATAPI devices as well.

>
> but instead it should report it as Maximum Transfer Length and let sd
> set it as max_dev_sectors:
>
>> put_unaligned_be32(dev->max_sectors, &rbuf[8]);
>
> While max_hw_sectors will be left untouched (in the case of AHCI, for
> example, since its SCSI host template does not have max_sectors set;
> so max_hw_sectors will be SCSI_DEFAULT_MAX_SECTORS).
>
> Although that means setting dev->max_sectors to a value larger than
> 1024 will probably be a no-op, if that's really an issue, we should
> have the host templates in libata updated.
>
> Make sense?
