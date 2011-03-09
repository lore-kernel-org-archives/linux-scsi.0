From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mptfusion: fix msgContext in mptctl_hp_hostinfo
Date: Wed, 9 Mar 2011 18:26:03 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED7113046A8@inbmail01.lsi.com>
References: <4D763934.2050901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:50139 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406Ab1CIMzO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2011 07:55:14 -0500
In-Reply-To: <4D763934.2050901@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "djeffery@redhat.com" <djeffery@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

James, This patch looks valid fix. Please consider this as an ACKed by me.

~ Kashyap

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, March 08, 2011 7:42 PM
> To: linux-scsi@vger.kernel.org
> Cc: djeffery@redhat.com; Desai, Kashyap
> Subject: [PATCH] mptfusion: fix msgContext in mptctl_hp_hostinfo
> 
> Hi,
> 
> without this patch the istwiRWRequest->MsgContext is always set to
> zero,
> this patch saves the MsgContext in a msgcontext variable and then
> restores
> the value.
> Thanks to  <mailto:djeffery@redhat.com>David Jeffery who found the
> issue and did the analysis.
> 
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> 
> diff --git a/drivers/message/fusion/mptctl.c
> b/drivers/message/fusion/mptctl.c
> index 4dbe546..43c0749 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -2423,9 +2423,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned
> int data_size)
>  	int			rc, cim_rev;
>  	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
>  	MPT_FRAME_HDR		*mf = NULL;
> -	MPIHeader_t		*mpi_hdr;
>  	unsigned long		timeleft;
>  	int			retval;
> +	u32			msgcontext;
> 
>  	/* Reset long to int. Should affect IA64 and SPARC only
>  	 */
> @@ -2572,11 +2572,11 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned
> int data_size)
>  	}
> 
>  	IstwiRWRequest = (ToolboxIstwiReadWriteRequest_t *)mf;
> -	mpi_hdr = (MPIHeader_t *) mf;
> +	msgcontext = IstwiRWRequest->MsgContext;
>  	memset(IstwiRWRequest,0,sizeof(ToolboxIstwiReadWriteRequest_t));
> +	IstwiRWRequest->MsgContext = msgcontext;
>  	IstwiRWRequest->Function = MPI_FUNCTION_TOOLBOX;
>  	IstwiRWRequest->Tool = MPI_TOOLBOX_ISTWI_READ_WRITE_TOOL;
> -	IstwiRWRequest->MsgContext = mpi_hdr->MsgContext;
>  	IstwiRWRequest->Flags = MPI_TB_ISTWI_FLAGS_READ;
>  	IstwiRWRequest->NumAddressBytes = 0x01;
>  	IstwiRWRequest->DataLength = cpu_to_le16(0x04);
> 
> 
> 

