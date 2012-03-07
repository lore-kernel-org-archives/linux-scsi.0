From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
Date: Wed, 7 Mar 2012 12:25:47 -0500
Message-ID: <A54D4229-0971-4325-8495-AF0AD6B06E38@xyratex.com>
References: <4f4a4580.aa3a440a.34c7.2776@mx.google.com> <4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn> <D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com> <00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com> <4F5785A9.2040707@bfs.de> <2E1367F2-077A-4654-8932-4FDAEE56240B@xyratex.com> <CAOD=uF67VkUnqYQQpgP=+0ndw-x+c1uWqN3-JUAVN24bgV2c=w@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:38672 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756625Ab2CGRZ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2012 12:25:56 -0500
In-Reply-To: <CAOD=uF67VkUnqYQQpgP=+0ndw-x+c1uWqN3-JUAVN24bgV2c=w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, wharms@bfs.de, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Jack Wang <jack_wang@usish.com>

ACK

Sincerely -- Mark Salyzyn

On Mar 7, 2012, at 12:24 PM, santosh prasad nayak wrote:

> Following the are the changes as suggested by you. Please let me know
> if anymore changes are required
> so that I can send a formal patch for it.  The below patch is just for
> review not a formal one.
> 
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 597593b..3976fab 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3150,7 +3150,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_info
> *pm8001_ha, void *piomb)
>        struct fw_control_ex    fw_control_context;
>        struct fw_flash_Update_resp *ppayload =
>                (struct fw_flash_Update_resp *)(piomb + 4);
> -       u32 tag = ppayload->tag;
> +       u32 tag = le32_to_cpu(ppayload->tag);
>        struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
>        status = le32_to_cpu(ppayload->status);
>        memcpy(&fw_control_context,
> @@ -3496,8 +3496,8 @@ static int mpi_hw_event(struct pm8001_hba_info
> *pm8001_ha, void* piomb)
>  */
> static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
> {
> -       u32 pHeader = (u32)*(u32 *)piomb;
> -       u8 opc = (u8)(pHeader & 0xFFF);
> +       __le32 pHeader = (__le32)*(__le32 *)piomb;
> +       u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
> 
>        PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
> index 1a4611e..d437309 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -599,7 +599,7 @@ struct fw_flash_Update_req {
>  *
>  */
> struct fw_flash_Update_resp {
> -       dma_addr_t      tag;
> +       __le32  tag;
>        __le32  status;
>        u32     reserved[13];
> } __attribute__((packed, aligned(4)));
> 
> 
> 
> 
> 
> Regards
> Santosh
