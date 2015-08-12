From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 2/7] megaraid_sas : Support for max_io_size 1MB
Date: Wed, 12 Aug 2015 11:39:12 +0530
Message-ID: <71e5118ad7612c601cef07c5696340d9@mail.gmail.com>
References: <201508071230.t77CU8bl021114@palmhbs0.lsi.com> <yq1d1yte07y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34374 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269AbbHLGJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 02:09:16 -0400
Received: by labd1 with SMTP id d1so3603133lab.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 23:09:14 -0700 (PDT)
In-Reply-To: <yq1d1yte07y.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, August 12, 2015 7:29 AM
> To: Sumit.Saxena@avagotech.com
> Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
> martin.petersen@oracle.com; hch@infradead.org; jbottomley@parallels.com;
> kashyap.desai@avagotech.com; kiran-kumar.kasturi@avagotech.com;
> uday.lingala@avagotech.com
> Subject: Re: [PATCH 2/7] megaraid_sas : Support for max_io_size 1MB
>
>
> Sumit,
>
> @@ -1239,7 +1239,9 @@ union megasas_sgl_frame {  typedef union
> _MFI_CAPABILITIES {
>  	struct {
>  #if   defined(__BIG_ENDIAN_BITFIELD)
> -		u32     reserved:25;
> +		u32     reserved:23;
> +		u32     support_ext_io_size:1;
> +		u32	support_ext_queue_depth:1;
>  		u32     security_protocol_cmds_fw:1;
>  		u32     support_core_affinity:1;
>  		u32     support_ndrive_r1_lb:1;
> @@ -1255,7 +1257,9 @@ typedef union _MFI_CAPABILITIES {
>  		u32     support_ndrive_r1_lb:1;
>  		u32     support_core_affinity:1;
>  		u32     security_protocol_cmds_fw:1;
> -		u32     reserved:25;
> +		u32	support_ext_queue_depth:1;
> +		u32     support_ext_io_size:1;
> +		u32     reserved:23;
>  #endif
>  	} mfi_capabilities;
>  	__le32		reg;
>
> Mystery field: support_ext_queue_depth.

This is added to keep driver and firmware API naming in sync, will create
separate patch for syncing drivers and firmware APIs changes.
>
> -	fusion->sg_dma_pool = pci_pool_create("megasas sg pool fusion",
> -					      instance->pdev,
> -					      total_sz_chain_frame, 4,
> -					      0);
> +	fusion->sg_dma_pool = pci_pool_create("sg_pool_fusion", instance-
> >pdev,
> +						instance-
> >max_chain_frame_sz,
> +						4, 0);
> +
>
> Why rename the pools? I don't particularly mind but megasas is probably
more
> descriptive for most users than fusion is.
There are two types of controllers megasas drivers support- 1)MFI
controllers 2)Fusion controllers so used "fusion" name here.
>
> @@ -1096,15 +1093,40 @@ megasas_init_adapter_fusion(struct
> megasas_instance *instance)
>  		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE *
>  		 (max_cmd + 1)); /* Extra 1 for SMID 0 */
>
> +	scratch_pad_2 = readl(&instance->reg_set->outbound_scratch_pad_2);
>
> scratch_pad_2 sounds like a pretty temporary thing rather than an
officially
> exported interface. But I guess that's what it's called.
Correct.
>
> +	/* If scratch_pad_2 & MEGASAS_MAX_CHAIN_SIZE_UNITS_MASK is set,
> +	 * Firmware support extended IO chain frame which is 4 time more
>
> Nitpick: s/time/times/
Will rectify this:)
>
> +	if (scratch_pad_2 & MEGASAS_MAX_CHAIN_SIZE_UNITS_MASK)
> +		instance->max_chain_frame_sz =
> +			((scratch_pad_2 & MEGASAS_MAX_CHAIN_SIZE_MASK)
> >> 5)
> +					* MEGASAS_1MB_IO;
>
> Magic number 5. Please define MEGASAS_MAX_CHAIN_SHIFT and use that.
Agree..will do this.
>
> @@ -117,7 +121,9 @@ struct RAID_CONTEXT {
>  	u8      numSGE;
>  	__le16	configSeqNum;
>  	u8      spanArm;
> -	u8      resvd2[3];
> +	u8      priority;
> +	u8	numSGEExt;	/* 0x1E 1M IO support */
> +	u8      resvd2;		/* 0x1F */
>  };
>
> Mystery priority addition.
Again this is to keep driver and firmware APIs in sync and will do all
such changes in separate patch.
>
> --
> Martin K. Petersen	Oracle Linux Engineering
