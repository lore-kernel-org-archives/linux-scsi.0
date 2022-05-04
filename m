Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D80C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 01:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242666AbiEDBOY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 21:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245067AbiEDBNv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 21:13:51 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00B24348C
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 18:10:10 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 04558320090D;
        Tue,  3 May 2022 21:10:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 03 May 2022 21:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651626607; x=
        1651713007; bh=KnLM2eMwoGznwvjz4VGg1u92xntCjY3JXBr7b5wJ334=; b=H
        sD6JdxkCvPO/fl8H1WgVNnNwv4jssvbL7cBrbS+JwHvzJ/2ct1fJxzB8J5YRGC9k
        elmU2RDAALxIpiw8T9lXbJr8vEyqxHK05gkkoYm63rheC58gwAGJvWFSio3lMWEh
        No4OlL/+fGlo6nP/hDrP0XkVYG7ln/wq/c2mr1YOScfIrBVMxL6tflSmionRMDbi
        3dcMSRtGulXQl6AcSXiQ3uZfCEYzrTRMtFCLhsRSZdvN+77GC29WrVjFUqhjJKnB
        rNt1mkfHj7fiF1rukuLPo9eq2W2CvFEcXVkOkdq8vIwkRV+2e7J0ryrcMVRK1CNf
        hY42OCNGLSnXuZUnUZoTw==
X-ME-Sender: <xms:b9JxYrSsI5QuzVsbDqDsoLqE_vbLAS-uV8w50TEffP9bNpEU28RtLg>
    <xme:b9JxYsxcQLbJsteH6NIF1kWedOIAgMxF41okj9Dpzg87vlmihM9FQ9XRuWDBMrZdq
    Mr3Rd6StU2_HijruG4>
X-ME-Received: <xmr:b9JxYg0jN9gFoq4PAxswopWIrAHs7Gi1KZfzbyAJIuBaAkwa-l6cE1Vs9mLxdNn6iYj8GRHVVLDPR68fG70gw777kqpSwtF4Nso>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepleeuheelheekgfeuvedtveetjeekhfffkeeffffftdfgjeevkeegfedvueeh
    ueelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfh
    hthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:b9JxYrAG13PsgwlXJUYKL3SxXD3FnFE0qpyuEjT5sCBe8hCoHiMStw>
    <xmx:b9JxYki9E4lEIg1xlhD_OI3cx5-8vgOps9T3RN9xkw5FCXZkoJMlKw>
    <xmx:b9JxYvrjvIi2ckbVLy_rz9GkA2YGrcaQLA4kQIodysCpYUpdWt_s7g>
    <xmx:b9JxYnsrTr5pttDJv3P2km8KGXv6H_cqRhCReGhlfqzJ7YrU-dgJoQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 May 2022 21:10:04 -0400 (EDT)
Date:   Wed, 4 May 2022 11:10:07 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 15/24] aic7xxx: do not reference scsi command when
 resetting device
In-Reply-To: <20220503200704.88003-16-hare@suse.de>
Message-ID: <871ed691-8c55-1c1e-507b-b8b77cfe326@linux-m68k.org>
References: <20220503200704.88003-1-hare@suse.de> <20220503200704.88003-16-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

On Tue, 3 May 2022, Hannes Reinecke wrote:

> When sending a device reset we should not take a reference to the
> scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c | 102 +++++++++++++++--------------
>  1 file changed, 54 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index 05591650f89f..596d5870b024 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -366,7 +366,8 @@ static void ahc_linux_queue_cmd_complete(struct ahc_softc *ahc,
>  					 struct scsi_cmnd *cmd);
>  static void ahc_linux_freeze_simq(struct ahc_softc *ahc);
>  static void ahc_linux_release_simq(struct ahc_softc *ahc);
> -static int  ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag);
> +static int  ahc_linux_queue_recovery_cmd(struct scsi_device *sdev,
> +					 struct scsi_cmnd *cmd);
>  static void ahc_linux_initialize_scsi_bus(struct ahc_softc *ahc);
>  static u_int ahc_linux_user_tagdepth(struct ahc_softc *ahc,
>  				     struct ahc_devinfo *devinfo);
> @@ -728,7 +729,7 @@ ahc_linux_abort(struct scsi_cmnd *cmd)
>  {
>  	int error;
>  
> -	error = ahc_linux_queue_recovery_cmd(cmd, SCB_ABORT);
> +	error = ahc_linux_queue_recovery_cmd(cmd->device, cmd);
>  	if (error != SUCCESS)
>  		printk("aic7xxx_abort returns 0x%x\n", error);
>  	return (error);
> @@ -742,7 +743,7 @@ ahc_linux_dev_reset(struct scsi_cmnd *cmd)
>  {
>  	int error;
>  
> -	error = ahc_linux_queue_recovery_cmd(cmd, SCB_DEVICE_RESET);
> +	error = ahc_linux_queue_recovery_cmd(cmd->device, NULL);
>  	if (error != SUCCESS)
>  		printk("aic7xxx_dev_reset returns 0x%x\n", error);
>  	return (error);
> @@ -2036,11 +2037,12 @@ ahc_linux_release_simq(struct ahc_softc *ahc)
>  }
>  
>  static int
> -ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
> +ahc_linux_queue_recovery_cmd(struct scsi_device *sdev,
> +			     struct scsi_cmnd *cmd)
>  {
>  	struct ahc_softc *ahc;
>  	struct ahc_linux_device *dev;
> -	struct scb *pending_scb;
> +	struct scb *pending_scb = NULL, *scb;
>  	u_int  saved_scbptr;
>  	u_int  active_scb_index;
>  	u_int  last_phase;
> @@ -2053,18 +2055,19 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
>  	int    disconnected;
>  	unsigned long flags;
>  
> -	pending_scb = NULL;
>  	paused = FALSE;
>  	wait = FALSE;
> -	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
> +	ahc = *(struct ahc_softc **)sdev->host->hostdata;
>  
> -	scmd_printk(KERN_INFO, cmd, "Attempting to queue a%s message\n",
> -	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
> +	sdev_printk(KERN_INFO, sdev, "Attempting to queue a%s message\n",
> +	       cmd ? "n ABORT" : " TARGET RESET");
>  
> -	printk("CDB:");
> -	for (cdb_byte = 0; cdb_byte < cmd->cmd_len; cdb_byte++)
> -		printk(" 0x%x", cmd->cmnd[cdb_byte]);
> -	printk("\n");
> +	if (cmd) {
> +		printk("CDB:");
> +		for (cdb_byte = 0; cdb_byte < cmd->cmd_len; cdb_byte++)
> +			printk(" 0x%x", cmd->cmnd[cdb_byte]);
> +		printk("\n");
> +	}
>  
>  	ahc_lock(ahc, &flags);
>  
> @@ -2075,7 +2078,7 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
>  	 * at all, and the system wanted us to just abort the
>  	 * command, return success.
>  	 */
> -	dev = scsi_transport_device_data(cmd->device);
> +	dev = scsi_transport_device_data(sdev);
>  
>  	if (dev == NULL) {
>  		/*
> @@ -2083,13 +2086,12 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
>  		 * so we must not still own the command.
>  		 */
>  		printk("%s:%d:%d:%d: Is not an active device\n",
> -		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
> -		       (u8)cmd->device->lun);
> +		       ahc_name(ahc), sdev->channel, sdev->id, (u8)sdev->lun);
>  		retval = SUCCESS;
>  		goto no_cmd;
>  	}
>  
> -	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
> +	if (cmd && (dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
>  	 && ahc_search_untagged_queues(ahc, cmd, cmd->device->id,
>  				       cmd->device->channel + 'A',
>  				       (u8)cmd->device->lun,
> @@ -2104,25 +2106,28 @@ ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
>  	/*
>  	 * See if we can find a matching cmd in the pending list.
>  	 */
> -	LIST_FOREACH(pending_scb, &ahc->pending_scbs, pending_links) {
> -		if (pending_scb->io_ctx == cmd)
> +	LIST_FOREACH(scb, &ahc->pending_scbs, pending_links) {
> +		if (cmd && scb->io_ctx == cmd) {
> +			pending_scb = scb;
>  			break;
> +		}
>  	}
>  
> -	if (pending_scb == NULL && flag == SCB_DEVICE_RESET) {
> -
> +	if (!cmd) {
>  		/* Any SCB for this device will do for a target reset */
> -		LIST_FOREACH(pending_scb, &ahc->pending_scbs, pending_links) {
> -			if (ahc_match_scb(ahc, pending_scb, scmd_id(cmd),
> -					  scmd_channel(cmd) + 'A',
> +		LIST_FOREACH(scb, &ahc->pending_scbs, pending_links) {
> +			if (ahc_match_scb(ahc, scb, sdev->id,
> +					  sdev->channel + 'A',
>  					  CAM_LUN_WILDCARD,
> -					  SCB_LIST_NULL, ROLE_INITIATOR))
> +					  SCB_LIST_NULL, ROLE_INITIATOR)) {
> +				pending_scb = scb;
>  				break;
> +			}
>  		}
>  	}
>  

A minor style criticism. Wouldn't that be better written as,

if (cmd) {
        LIST_FOREACH (...)
                ...
} else {
        LIST_FOREACH (...)  
                ...
}

rather than,

LIST_FOREACH (...)
        if (cmd && ...)
                ...
if (!cmd)
        LIST_FOREACH (...)
                ...
