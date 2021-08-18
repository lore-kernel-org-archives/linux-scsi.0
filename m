Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DDAC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 00:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B4CD60524
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 00:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhHRAod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 20:44:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55167 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232410AbhHRAoc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 20:44:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1DD195C0195;
        Tue, 17 Aug 2021 20:43:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Aug 2021 20:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+9vzpR
        oyZYdbcdERhUDRnK1qYWVHC5w+FAXnup9Ypkc=; b=DpoUnowHtiSnva0s2nILJQ
        AyU2gjFUCUieyxiXcCljsnzv4Qqtv3RTZwhAkXZv2xTYZz6nXucvhFLN8IAqculR
        f+seuG7BkkYXqJjs43mUvjkleYW99uTtSTwAB30jdkSDkWJdKVWyTHITyGLQP3VL
        ieSCqRcBTxT8Mw74gP6Yj2j/cQBb7lDEkSOp0UoiyX2m4dTRImXayz17vvDK1tkO
        US2mNnY8/LplaxORWPh0/vZDth2LReWGoFq8/YLV8wYfV4elXOouzUtthabQMK7M
        t+HUBgZD7WHAz3cC4jqx+oqYSdfflacwK7R0IN6lG3FyYQFiarljrzKcP8ZzJyww
        ==
X-ME-Sender: <xms:zFccYQ-1lzNhuENknEM59rCEyWy0EUZWWTa-kpE_HGMu9O2u7A3ZEQ>
    <xme:zFccYYutDXg75thovb2eZjAac8hcWmvqkkN6DxwOk2UxCV1UsmuIlyMg6KSWrsMBa
    Yu_Zb_3l9prIqiw4yk>
X-ME-Received: <xmr:zFccYWAeQuXkA_aK0Ujigra2L1ojI3lx3emjnKwCQ6ArWEflEjeXGhMLSuhSRdwxH4I6dj-TrZ87LmLoFRz2jTTuG37HJG03_IPdew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleeggdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffudfhgeefvdeitedugfelueegheekkeefveffhfeiveetledvhfdtveffteeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:zFccYQeb1Il66PSTCezjjh49mYdMcD6HVNZpZnvEjZaQi3V3k4EXXg>
    <xmx:zFccYVMQhuttP6jRm_btyIpVrGwLgifMu9LY9jJk7e6iaMI0E-E3hw>
    <xmx:zFccYakhKkLRfWsCHMIyEBpguocnRcimsfddy2jkLMTiRIlETSbVNg>
    <xmx:zlccYWqza2xzN1T7FxfQy0gYRECfNAiYN5_yd82mfLXTQJcpaQTeag>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Aug 2021 20:43:53 -0400 (EDT)
Date:   Wed, 18 Aug 2021 10:43:48 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 37/51] aha152x: look for stuck command when resetting
 device
In-Reply-To: <20210817091456.73342-38-hare@suse.de>
Message-ID: <3170bee-8c89-973a-e2fc-a076af228585@linux-m68k.org>
References: <20210817091456.73342-1-hare@suse.de> <20210817091456.73342-38-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 17 Aug 2021, Hannes Reinecke wrote:

> From: Hannes Reinecke <hare@suse.com>
> 
> The LLDD needs a command to send the reset with, so look at the
> list of outstanding commands to get one.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aha152x.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index 6fbdb6f3c996..3f96b38b7b56 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -1045,24 +1045,28 @@ static int aha152x_abort(struct scsi_cmnd *SCpnt)
>   */
>  static int aha152x_device_reset(struct scsi_cmnd * SCpnt)
>  {
> -	struct Scsi_Host *shpnt = SCpnt->device->host;
> +	struct scsi_device *sdev = SCpnt->device;
> +	struct Scsi_Host *shpnt = sdev->host;
>  	DECLARE_COMPLETION(done);
>  	int ret, issued, disconnected;
> -	unsigned char old_cmd_len = SCpnt->cmd_len;
> +	unsigned char old_cmd_len;
>  	unsigned long flags;
>  	unsigned long timeleft;
>  
> -	if(CURRENT_SC==SCpnt) {
> -		scmd_printk(KERN_ERR, SCpnt, "cannot reset current device\n");
> -		return FAILED;
> -	}
> -
>  	DO_LOCK(flags);
> -	issued       = remove_SC(&ISSUE_SC, SCpnt) == NULL;
> -	disconnected = issued && remove_SC(&DISCONNECTED_SC, SCpnt);
> +	/* Look for the stuck command */
> +	SCpnt = remove_lun_SC(&ISSUE_SC, sdev->id, sdev->lun);
> +	if (SCpnt)
> +		issued = 1;
> +	else
> +		SCpnt = remove_lun_SC(&DISCONNECTED_SC, sdev->id, sdev->lun);
> +	if (!issued && SCpnt)
> +		disconnected = 1;

It looks like 'issued' is left uninitialized in the !SCpnt case. Similar 
problem for 'disconnected'. Personally, I prefer the original style for 
being more readable i.e. unconditional assignments.

Also, it looks like you've added some logic bugs. The values of 
'disconnected' and 'issued' have been changed here such that commands 
never issued will now end up on the DISCONNECTED_SC list, and commands 
that were issued already will now end up on the ISSUE_SC list.

>  	DO_UNLOCK(flags);
> -
> -	SCpnt->cmd_len         = 0;
> +	if (!SCpnt)
> +		return FAILED;

If a command was removed from a list, it used to get re-added in the 
FAILED case (later on). If you 'return' here, that won't happen and EH 
escallation won't lead to free_hard_reset_SCs(). That looks like a memory 
leak.

> +	old_cmd_len = SCpnt->cmd_len;
> +	SCpnt->cmd_len = 0;
>  
>  	aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
>  
> 
