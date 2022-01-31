Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3FBC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 22:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiAaWjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:39:39 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:51895 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234386AbiAaWjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 17:39:39 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 4CBA23201F4E;
        Mon, 31 Jan 2022 17:39:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 31 Jan 2022 17:39:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/8EmfSqmsfyNQCo3V
        oI1/sSW41d6SJ7d8EH9C1o0+NA=; b=AgvRDdToIKq54R8bKDMkF5TEjU8BQVUvd
        zjNjDqBcwqXc2D5OKaE0xse2LTl89ybugoRjSoTdMF/CrCL2TvKjnPFlz7Kji4/5
        gvxozjT98KG5SBv9LMLSWRdMlUfStaXEmWl4vIjAdFODJmP59eALz8lXskPtOZJ+
        6uvxXmttcAFyzYnhPIUK1It0+SnHT1iJoobQIgyheybwRo+CzeZ/Vokv7KM1+B9V
        +yxs87n9LKztH8FHrNXUcwZP0xw9FE/PEkpmj4E78G/klyDcNbMfUm6kCMcjY1sG
        Wlu0CLTB4CS6c31nXe5ciuCrZrJVdldcf8L4SecMSzwzmFEd9SnxQ==
X-ME-Sender: <xms:KWX4Yck3zdiN5C58iitdBOBVXDJAJROWg9ubwiJWqQ0BU9OV8kJIew>
    <xme:KWX4Yb1ywbK2wz5z6alPXPPND2hKjsjQcRHgfOYU8G-hlJoyo747C2V-2NmyvBY18
    KIMyY7G9gZrmpoeE9g>
X-ME-Received: <xmr:KWX4YaoAEI1uvqnat2awyxRZpDghSLVwMReICmoYDpnNTWo8EJdxG9hGDvHzkU8zm3Nqw7rJN5NFfl5xRmHlxS73kcHlnijNK0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgedvucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfvhhgrihhn
    uceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvghrnh
    epffduhfegfedvieetudfgleeugeehkeekfeevfffhieevteelvdfhtdevffetuedunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthhgrih
    hnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:KWX4YYlwBL6yzsu6GBwoP-2-LNBMx2PdZVjw5pCT0R75dpPgwX9ecw>
    <xmx:KWX4Ya3Ejq1HVCnu5Rm6wkgERbrKv21r0Dn03ARQ6SaKuBSf35zBEA>
    <xmx:KWX4YfvH3wCBRNdky2ZpqcfyU_9hcc6dmrFRY2QP5nMdyImFtFnXjg>
    <xmx:KWX4YdSvzC0nuEROrpvd_BvqUvguQsTt_H4ANT-m9bOLwOJa6W9_Vg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Jan 2022 17:39:34 -0500 (EST)
Date:   Tue, 1 Feb 2022 09:39:30 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 05/44] NCR5380: Move the SCSI pointer to private command
 data
In-Reply-To: <20220128221909.8141-6-bvanassche@acm.org>
Message-ID: <f8dc3a5f-55a7-6cc-b210-d0cd1b7a96c2@linux-m68k.org>
References: <20220128221909.8141-1-bvanassche@acm.org> <20220128221909.8141-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Jan 2022, Bart Van Assche wrote:

> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index 845bd2423e66..adaf131aea4d 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -227,9 +227,17 @@ struct NCR5380_hostdata {
>  };
>  
>  struct NCR5380_cmd {
> +	struct scsi_pointer scsi_pointer;
>  	struct list_head list;
>  };
>  
> +static inline struct scsi_pointer *NCR5380_scsi_pointer(struct scsi_cmnd *cmd)
> +{
> +	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
> +
> +	return &ncmd->scsi_pointer;
> +}
> +
>  #define NCR5380_PIO_CHUNK_SIZE		256
>  
>  /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */

I think this patch series is a good idea but poorly executed.

Firstly, scsi_pointer has long been the name of a struct. It's confusing 
to see that name re-used for variables and functions. Moreover, it was 
always a lousy name (for anything).

Regarding code style, this is legacy code i.e. it pre-dates the ban on 
mixed letter case. (I'm using the word legacy after the dictionary 
definition and not as a kind of weasel word intended to mean deprecated.)

Mixed case names like "BAZ5000_cmd" would be frowned upon for new code but 
this is not new code. So why not just use the name SCp for variables which 
serve the same purpose that the SCp struct did?

IOW, I would prefer to read the following, because SCp presumably means 
"Scsi Command Private data" whereas "scsi_pointer" means nothing to me.

--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -227,9 +227,17 @@ struct NCR5380_hostdata {
 };
   
 struct NCR5380_cmd {
+     struct scsi_pointer SCp;
      struct list_head list;
 };
   
+static inline struct scsi_pointer *NCR5380_to_SCp(struct scsi_cmnd *cmd)
+{
+     struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+     
+     return &ncmd->SCp;
+}
+ 
 #define NCR5380_PIO_CHUNK_SIZE               256
 
 /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index e9d0d99abc86..61fd3244a4ce 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -538,7 +538,8 @@ static int falcon_classify_cmd(struct scsi_cmnd *cmd)
 static int atari_scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                    struct scsi_cmnd *cmd)
 {
-       int wanted_len = cmd->SCp.this_residual;
+       struct scsi_pointer *SCp = NCR5380_to_SCp(cmd);
+       int wanted_len = SCp->this_residual;
        int possible_len, limit;
 
        if (wanted_len < DMA_MIN_SIZE)
@@ -610,7 +611,8 @@ static int atari_scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
        }
 
        /* Last step: apply the hard limit on DMA transfers */
-       limit = (atari_dma_buffer && !STRAM_ADDR(virt_to_phys(cmd->SCp.ptr))) ?
+       limit = (atari_dma_buffer && !STRAM_ADDR(virt_to_phys(SCp->ptr))) ?
                    STRAM_BUFFER_SIZE : 255*512;
        if (possible_len > limit)
                possible_len = limit;
