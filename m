Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA37C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 22:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiAaWqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:46:11 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:55585 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229870AbiAaWqK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 17:46:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E4DA4320157F;
        Mon, 31 Jan 2022 17:46:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 31 Jan 2022 17:46:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xnO7MpxS5kw0NEx/J
        v9loL7S9u2FAsl+pHT+s814Kzw=; b=nipNWD6L+cRREmZYrCMOoByA0aYSeiD+R
        3bdhWfxkWlisenJ7K94CJ+xnBbkuWdwxuuB9Bave1XeoUHap1T1A/AdwQBPUZoAQ
        MVhMyFoeWBj54wqtu0ICqNQ3gDSyBIftUYrFnoSj7OK289SD1I2lktN2x6yzV9ww
        HlAMeuMdygTIc4VSLpv82LfAX34yESpKUGqBTX7T2/jIyBWXz/JyDgp/3CbDkAFy
        ximmZucG0UhFJ8sjldA5DgVeTk7BPwNjZ/LwdPUsmdebTP7mBvprkZ3uzEezcvEU
        2go1B9El9HSwzJqKEk5i3IKO1VN04WCf7Iau04dMbyi2IaZfHVY0A==
X-ME-Sender: <xms:sWb4YXNv843b8AtvpzQwUFmvan7JDwSMP7uRXiDnHW9T2O8_QQ06hA>
    <xme:sWb4YR_iweZTKYH72bvPbcZLX6SasUVLSAoO2FnwpazGN2uzbd9J0qyVfZuemtoPS
    H13H75a1SMmYpWw8NI>
X-ME-Received: <xmr:sWb4YWR5qb8Um6tZOGSLuA2Y3qDy85WXp2arRGN3tDpuXvhALj_kKBY_4ooD70LEjJXQUmnPQfcyJdvOciaxnYJ8MlWusO7g_xQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgedvgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffudfhgeefvdeitedugfelueegheekkeefveffhfeiveetledvhfdtveffteeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:sWb4YbvzS8Pm5MuAw3mx8bWQELJXCsq8S7kz9A5pId2NmKyrq-TWqg>
    <xmx:sWb4YfeM-Hpoy45GVPFEvU3w-rKWGxlM_L7C6GNLgAoj2AQ2WMVCVQ>
    <xmx:sWb4YX2LFFFtD1nikOwC2fquWm1PEFArRAt5zDEAS5MTRsJUymNM1Q>
    <xmx:sWb4YXGbidN8mh98NPE2yiCjQ6LZ_PN3gXcJFUwQjKkoBJNy_AXsAw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Jan 2022 17:46:07 -0500 (EST)
Date:   Tue, 1 Feb 2022 09:46:04 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 16/44] esp_scsi: Stop using the SCSI pointer
In-Reply-To: <20220128221909.8141-17-bvanassche@acm.org>
Message-ID: <a33be8ce-6f5d-6b97-2b69-3f3326c51b1f@linux-m68k.org>
References: <20220128221909.8141-1-bvanassche@acm.org> <20220128221909.8141-17-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Jan 2022, Bart Van Assche wrote:

> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
> from struct scsi_cmnd.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/esp_scsi.c | 1 +
>  drivers/scsi/esp_scsi.h | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 57787537285a..9dfdca5b31e7 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2678,6 +2678,7 @@ struct scsi_host_template scsi_esp_template = {
>  	.sg_tablesize		= SG_ALL,
>  	.max_sectors		= 0xffff,
>  	.skip_settle_delay	= 1,
> +	.cmd_size		= sizeof(struct esp_cmd_priv),
>  };
>  EXPORT_SYMBOL(scsi_esp_template);
>  
> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> index 446a3d18c022..c73760d3cf83 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -262,7 +262,8 @@ struct esp_cmd_priv {
>  	struct scatterlist	*cur_sg;
>  	int			tot_residue;
>  };
> -#define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
> +
> +#define ESP_CMD_PRIV(cmd)	((struct esp_cmd_priv *)scsi_cmd_priv(cmd))
>  
>  /* NOTE: this enum is ordered based on chip features! */
>  enum esp_rev {
> 

After that, you're free to do this:

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index bb88995a12c7..4934a5490716 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2746,9 +2746,6 @@ static struct spi_function_template esp_transport_ops = {
 
 static int __init esp_init(void)
 {
-	BUILD_BUG_ON(sizeof(struct scsi_pointer) <
-		     sizeof(struct esp_cmd_priv));
-
 	esp_transport_template = spi_attach_transport(&esp_transport_ops);
 	if (!esp_transport_template)
 		return -ENODEV;
