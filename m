From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Tue, 17 Aug 2004 14:18:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41224BD9.9060808@adaptec.com>
References: <0E3FA95632D6D047BA649F95DAB60E5704DE66BB@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:14284 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268379AbUHQSSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 14:18:06 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704DE66BB@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, fukuchi.masao@jp.fujitsu.com

Moore, Eric Dean wrote:
> Ok - your proposed change will Opps the driver.
> 
> Sequence to oops:
> 1.SCSI midlayer detects command timeout and issue abort
> message to fusion MPT driver.
> 2.Fusion MPT driver issues abort message to IOC and returns
> SCSI midlayer with FAILED status.
> 3.SCSI midlayer gives up the operation and call
> scsi_release_buffers()to free buffers; this
> routine does "cmd->request_buffer=NULL;"
> 4.Fusion MPT driver initiates IOC reset and calls
> mptscsih_flush_running_cmds() to cancel SCSI command.
> 5.Oops - occurs when calling pci_unmap_sg when request_buffer=NULL.

Points 2 and 4 -- once ABORT TASK is sent, the device server
should NOT return status of the aborted task, regardless
of the service response of the TMF. (SAM, 7.2)

			Luben


> 
> The current fix testing for scsi_device_online
> was provided last April by Fukuchi Masao.
> 
> Eric Moore
> 
> 
> On Tuesday, August 17, 2004 10:17 AM, Christoph Hellwig wrote:
>  >
>  > stop fusion from leaking dma maps when the device has been offlined
>  >
>  >
>  > --- 1.13/drivers/message/fusion/linux_compat.h       
>  > 2004-06-23 16:48:43 +02:00
>  > +++ edited/drivers/message/fusion/linux_compat.h     
>  > 2004-08-17 20:09:21 +02:00
>  > @@ -3,16 +3,4 @@
>  >  #ifndef FUSION_LINUX_COMPAT_H
>  >  #define FUSION_LINUX_COMPAT_H
>  > 
>  > -#include <linux/version.h>
>  > -#include <scsi/scsi_device.h>
>  > -
>  > -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
>  > -static int inline scsi_device_online(struct scsi_device *sdev)
>  > -{
>  > -     return sdev->online;
>  > -}
>  > -#endif
>  > -
>  > -
>  > -/*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
>  > -=-=-=-=-=-=-=-=*/
>  >  #endif /* _LINUX_COMPAT_H */
>  > ===== drivers/message/fusion/mptscsih.c 1.45 vs edited =====
>  > --- 1.45/drivers/message/fusion/mptscsih.c    2004-08-03
>  > 01:01:01 +02:00
>  > +++ edited/drivers/message/fusion/mptscsih.c  2004-08-17
>  > 20:02:54 +02:00
>  > @@ -1019,19 +1019,18 @@
>  >                        * Do OS callback
>  >                        * Free driver resources (chain, msg buffers)
>  >                        */
>  > -                     if (scsi_device_online(SCpnt->device)) {
>  > -                             if (SCpnt->use_sg) {
>  > -                                     pci_unmap_sg(ioc->pcidev,
>  > -                                             (struct
>  > scatterlist *) SCpnt->request_buffer,
>  > -                                             SCpnt->use_sg,
>  > -                                            
>  > SCpnt->sc_data_direction);
>  > -                             } else if (SCpnt->request_bufflen) {
>  > -                                     pci_unmap_single(ioc->pcidev,
>  > -                                             SCpnt->SCp.dma_handle,
>  > -                                             SCpnt->request_bufflen,
>  > -                                            
>  > SCpnt->sc_data_direction);
>  > -                             }
>  > +                     if (SCpnt->use_sg) {
>  > +                             pci_unmap_sg(ioc->pcidev,
>  > +                                     (struct scatterlist *)
>  > SCpnt->request_buffer,
>  > +                                     SCpnt->use_sg,
>  > +                                     SCpnt->sc_data_direction);
>  > +                     } else if (SCpnt->request_bufflen) {
>  > +                             pci_unmap_single(ioc->pcidev,
>  > +                                     SCpnt->SCp.dma_handle,
>  > +                                     SCpnt->request_bufflen,
>  > +                                     SCpnt->sc_data_direction);
>  >                       }
>  > +
>  >                       SCpnt->result = DID_RESET << 16;
>  >                       SCpnt->host_scribble = NULL;
>  > 
>  > -
>  > To unsubscribe from this list: send the line "unsubscribe
>  > linux-scsi" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

