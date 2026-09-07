Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235B3149C7B;
	Mon,  7 Sep 2026 02:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749928; cv=none; b=Ks9ZeeiPlRNTPCuxxjLi0GlBx867zFqUaTe/NvACLGVRaA1kyjYpxgSaaw//8NyrSRSiH2GtYYAD6kdRk083JWmWy72UxsikUvk9Sr5asijUnWKRHw5nTOWa/lqecCzwG605sjk1CIb57Tf9T+RTyLxdTFaqkEOoKp5Wjwc+zH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749928; c=relaxed/simple;
	bh=Fpgtyj1uB9O3r3YPwb4PQ/gUcPWQV2kTsv+GZvGrb2s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JpuBWtCFqqHg5LsFxeNe+qZNhdHAamZVHn2UpZxVMFouqlWX6e3JcyONx2kN9qYqtDRZZAADcIAuON2g5fPIzWoQItOv0+yKftUalJTi3PxesW2gWPPZFzUWF4ghFeMD08Z359zreNBGGhf0jaRAlhNsZpLVWvCbpAtBVJmwkeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrDKMQJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrDKMQJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C4B1F00A3A;
	Mon,  7 Sep 2026 02:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749927;
	bh=i8rsNsrOHa/e3Bodq3vOiEIQepJw3UWDKzvf7NUUSUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PrDKMQJJCKNKReFVC29NhlsrV05L3/AHcBhD+OOXHtX0LFpTUthCDLKlb1cTaA1NF
	 i90fe3EiBVYrK+ikbPRZim6wI2wen2mNjj6VjU18+hIVtnVPfLTygMK3btO7gbobuw
	 KTGsbP3Skf9vInMpcOf2vdd3xpmtdemGhNNxPfkA4hn5VhDrmpDF9mgAR3ODFOMkij
	 ql2oiZGLYXnLr5lrBYhmOp7cuJSRN62SFqFxaXR+DQjd4j4iQZAIFSkym6Rp/9F7Km
	 VXpiYaofUhemIUf9eZnT+NZvi3yMcHQJRc9AT4s0dp09BZTa+5LmydlfTudNC7H1Lk
	 EgIHDEPNcazhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260907024343.1046387-20-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:58:46 +0000
Message-Id: <20260907025846.71C4B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] DMA mapping leaked in tw_scsi_queue_lck() error path
--

commit b708e74640568d14bdef5d71bbb322063ecd2eb1
Author: Damien Le Moal <dlemoal@kernel.org>
Date:   Mon Sep 7 02:43:22 2026 +0000

    scsi: 3w-xxxx: use 16-bits defined sense codes
   =20
    Modify the function tw_scsi_queue_lck() of the 3w-xxxx driver to use
    scsi_set_sense() and replace the hard-coded additional sense codes and
    additional sense code qualifiers with the enum values defined in
    include/scsi/scsi_sense.h. This helps with code clarity as the sense co=
des
    being processed are easier to test and self-documented.

> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index 7f7bf5b5640de..11326465abb64 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -1977,7 +1977,8 @@ static enum scsi_qc_status tw_scsi_queue_lck(struct=
 scsi_cmnd *SCpnt)
>  		printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_=
dev->host->host_no, *command);
>  		tw_dev->state[request_id] =3D TW_S_COMPLETED;
>  		tw_state_request_finish(tw_dev, request_id);
> -		scsi_build_sense(SCpnt, 1, ILLEGAL_REQUEST, 0x20, 0);
> +		scsi_set_sense(SCpnt, 1, ILLEGAL_REQUEST,
> +			       INVALID_COMMAND_OP_CODE);
>  		done(SCpnt);
>  		retval =3D 0;
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but does the error handling block
immediately following this switch statement leak a DMA mapping?

In tw_scsiop_read_write(), the command's SG list is mapped for DMA using
scsi_dma_map():

        use_sg =3D scsi_dma_map(srb);
        if (use_sg <=3D 0)
                return 1;

Immediately following this, the code checks if the command packet's physical
address is 0. Since physical address 0 is valid on some architectures, a
hardware allocation at slot 0 triggers an abort where the function returns 1
without unmapping the DMA:

        command_que_value =3D tw_dev->command_packet_physical_address[reque=
st_id];
        if (command_que_value =3D=3D 0) {
                dprintk(KERN_WARNING "3w-xxxx: tw_scsiop_read_write(): Bad =
command packet physical address.\n");
                return 1;
        }

When tw_scsiop_read_write() returns 1, tw_scsi_queue_lck() enters its error
handling block right after the switch statement:

        if (retval) {
                tw_dev->state[request_id] =3D TW_S_COMPLETED;
                tw_state_request_finish(tw_dev, request_id);
                SCpnt->result =3D (DID_ERROR << 16);
                done(SCpnt);
                retval =3D 0;
        }

Since scsi_dma_unmap(SCpnt) is never called before completing the command,
does this continuously leak IOMMU space or bounce buffers for every
read/write request routed to slot 0? Could this exhaustion cause
subsequent DMA mappings to fail across the system, leading to I/O hangs
or kernel crashes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D19
