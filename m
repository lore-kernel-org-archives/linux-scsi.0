Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F03FC64EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 04:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCJEoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 23:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCJEoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 23:44:22 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C781A10110D
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 20:44:20 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C11205C0211;
        Thu,  9 Mar 2023 23:44:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 09 Mar 2023 23:44:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1678423457; x=1678509857; bh=B3OpBAyY5etpq
        tlrK+hmth+OrqOhuhxbOeNfn3oaUOQ=; b=Mu/PRsedG3yVMcmRl39QEXK1jt8ws
        UHdFYKWhRoP5sOixTVSfb1zUoySq74JlHrtH4cSGTQ+Gds+fQqZ1LFzkRzk5GMxq
        b1bCAr5OSivyU2JhvmZooIxYrGKW0LpIvT4PTKSx2r6Jjtdll72gCC/M2mKZl4lC
        Jmwl96gyN+PAqv8IU82eIOvrDBSIKhuGAwMYZRvWh2IfX/FOVfOpginLINHWjr+8
        ceSf8pKoe1jFE62iwEkvioyYArtpeYYT31JgS+3KeUkZE4J7/jJ6otatXQ9pJ0Y+
        LJAemdcQX6DmHS/+xoVrfBBQh2NPTi3jmGLO2Ami7Q7FuSzuOZ3zwV76g==
X-ME-Sender: <xms:obUKZBadOo43cik3fFNOZO2Nm9tjCqWkqIS_mHX--imk01koRxpgwA>
    <xme:obUKZIbCVGQAcmnZTHb9utFFDJdVg63HrYutwLemLXhmeyZ3mITYm8UxJxUOG8ZzP
    UTwQ05r09eHVXukRBA>
X-ME-Received: <xmr:obUKZD-Pw11l83KTKAz_dtTWTI_xIHw4nJhwzfY_ELWDoCKAS-mzvIGrM3FQqU8O9dJU98eeQUqHCDlv3rla4SZ4tV_1fHqI4Gc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddujedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:obUKZPoD7pNhFFDIkFbtR3GEcyv4hzw5_H7Ve84wQk0HMIRPBBIAKQ>
    <xmx:obUKZMoRpoYLCKAoLV_Kl9xF39pFw6Oq-V260hW9L_YHJEU6iIkhIA>
    <xmx:obUKZFSrz5uFqJ1elt8YL8X_jAqmsEZwqn52dIvOGztZ6mi_MakoxA>
    <xmx:obUKZD3OcUXncU4MsHT6iimrLN6UaJDmXsK9woWq9C4Ggn7c2Adn1g>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Mar 2023 23:44:15 -0500 (EST)
Date:   Fri, 10 Mar 2023 15:46:59 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 51/82] scsi: mac_scsi: Declare SCSI host template
 const
In-Reply-To: <20230309192614.2240602-52-bvanassche@acm.org>
Message-ID: <ad89ffce-8cb0-a7b1-887c-2c513e7ea5b2@linux-m68k.org>
References: <20230309192614.2240602-1-bvanassche@acm.org> <20230309192614.2240602-52-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Mar 2023, Bart Van Assche wrote:

> Make it explicit that the SCSI host template is not modified.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/mac_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index 2e511697fce3..1d13f1ebc094 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -422,7 +422,7 @@ static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
>  #define DRV_MODULE_NAME         "mac_scsi"
>  #define PFX                     DRV_MODULE_NAME ": "
>  
> -static struct scsi_host_template mac_scsi_template = {
> +struct scsi_host_template mac_scsi_template = {
>  	.module			= THIS_MODULE,
>  	.proc_name		= DRV_MODULE_NAME,
>  	.name			= "Macintosh NCR5380 SCSI",
> 

I think something went wrong there. No change is needed for 
mac_scsi_template as it can't be made const.
