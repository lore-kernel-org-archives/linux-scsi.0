From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH] [SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue
Date: Thu, 22 Mar 2012 23:28:52 +0800
Message-ID: <CAF1ivSbT2dCaOwcpRXS4AjJCu1y-iApNHtUepof30pk5d=KKFA@mail.gmail.com>
References: <1332395550.3793.58.camel@minggr>
	<4F6B0BE7.8050707@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60530 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892Ab2CVP2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2012 11:28:53 -0400
In-Reply-To: <4F6B0BE7.8050707@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, Mar 22, 2012 at 7:24 PM, Sergei Shtylyov <sshtylyov@mvista.com>=
 wrote:
> Hello.
>
>
> On 22-03-2012 9:52, Lin Ming wrote:
>
>> Currently, __scsi_alloc_queue uses SCSI host's parent device
>> as DMA device to set segment boundary. But the parent device may not
>> refer to the DMA device. For example, for ATA disk, SCSI host's pare=
nt
>> device now refers to ATA port.
>
>
>> Since commit d139b9b([SCSI] scsi_lib_dma: fix bug with dma maps on
>> nested scsi objects), a new field Scsi_Host->dma_device was introduc=
ed
>
>
> =A0 Only the field is named 'dma_dev', isn't it?

Yes, my typo.

>
>
>> to refer to the real DMA device.
>
>
>> Use ->dma_device in __scsi_alloc_queue to correctly set segment
>> boundary.
>
>
>> And use scsi_add_host_with_dma in ata_scsi_add_hosts to pass in the
>> correct DMA device.
>
>
> =A0 Perhaps this should be split into two patches.

Good idea.

Will split and resend.

Thanks,
Lin Ming

>
>
>> Bug report: http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D=
2
>
>
>> Reported-and-tested-by: J=F6rg Sommer<joerg@alea.gnuu.de>
>> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
>
> [...]
>
>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index f85cfa6..486088b 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1642,7 +1642,7 @@ struct request_queue *__scsi_alloc_queue(struc=
t
>> Scsi_Host *shost,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 request_fn_proc *request_fn)
>> =A0{
>> =A0 =A0 =A0 =A0struct request_queue *q;
>> - =A0 =A0 =A0 struct device *dev =3D shost->shost_gendev.parent;
>> + =A0 =A0 =A0 struct device *dev =3D shost->dma_dev;
>>
>> =A0 =A0 =A0 =A0q =3D blk_init_queue(request_fn, NULL);
>> =A0 =A0 =A0 =A0if (!q)
>
>
> WBR, Sergei
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
