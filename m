Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8863FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 23:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ECD761107
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 23:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242952AbhIUAAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 20:00:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33229 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239514AbhITX6J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Sep 2021 19:58:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 939B25C00DF;
        Mon, 20 Sep 2021 19:56:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 20 Sep 2021 19:56:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kEcYYW
        e7Fo4F3ypOF0RisLR7B9ji3PdFfB/b9jqi6Xg=; b=B5AzkoiJg/YgLkdds0E0RT
        jxD+1aLa8nBSN8d2vtwjlYlebFb7SYzGfHyDpuPinKAPHRF2E5bvawpTes/e5p4Q
        TDTxfz95FNJ14Mirg8NaB/0K+Vhe7dV7uKZ54uY7pi4WAI1oMA5fxy/WGBZc42uS
        jjIprygfFk3yBe81qlX0LJ7U5wPqMjsSryhaO6S/GUxXHDoWJd7R0SaX/dP0TbkM
        e2VNvn0Sxu7nqVJwAcF2APLHkLK2L1x9YW28KyDjiW8M5PWooci8Gm6YZVhQbu41
        Ju4lYzrdUZCo5HC7ccmAVsi+m2IqG05ujpiUuTqHNBTbq9w+tAFYdEVfjpymKfiQ
        ==
X-ME-Sender: <xms:th9JYVG3a7SjmU06wBsE1ucbszwuJglwQlh475joJELPjllKcADz0w>
    <xme:th9JYaXvMR2axcz5CBP4Ixd5mjT8Dfmuxn6U4WCfWxPRYClTHRMh3KQ0IY0M2tQXN
    pRW9IHD8I3QyJkemoM>
X-ME-Received: <xmr:th9JYXKfDUWaZuVV2kXKwPtegxBUCGZWavbZyCBdjN6VaD2KE1xaB3ELxIAUK8rO21OZWzLGI8CKAMtisk4XVmSv6Wn9loY9apXhkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeifedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepffduhfegfedvieetudfgleeugeehkeekfeevfffhieevteelvdfhtdevffet
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfh
    hthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:th9JYbG7CMIIdEQLoX8y_Nrjn9VDiZn4wQJyp8OHNCPSWU4e_1gh4Q>
    <xmx:th9JYbW0yDeTaAkc3w-v7rxRUP4KTpUCqRGh9YBnpWwpg5omhKw7lQ>
    <xmx:th9JYWMrkiAzhKHHBJByPem2p5VJL490E79yH1Nn2ektg6wdtFKRBw>
    <xmx:uB9JYdKS6cJTI8rjy22Rq8q2-Zim6Cq0vqLc4lz0Y9DWE2zfPfTVLw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Sep 2021 19:56:36 -0400 (EDT)
Date:   Tue, 21 Sep 2021 09:56:29 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Tong Zhang <ztong0001@gmail.com>
cc:     Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: dc395: fix error case unwinding
In-Reply-To: <20210907040702.1846409-1-ztong0001@gmail.com>
Message-ID: <a68837f4-1ff7-76d5-7a68-80d2c0dbd95e@linux-m68k.org>
References: <20210907040702.1846409-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Mon, 6 Sep 2021, Tong Zhang wrote:

> dc395x_init_one()->adapter_init() might fail. In this case, the acb
> is already clean up by adapter_init(), no need to do that in
> adapter_uninit(acb) again.
> 
> [    1.252251] dc395x: adapter init failed
> [    1.254900] RIP: 0010:adapter_uninit+0x94/0x170 [dc395x]
> [    1.260307] Call Trace:
> [    1.260442]  dc395x_init_one.cold+0x72a/0x9bb [dc395x]
> 
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>

Reviewed-by: Finn Thain <fthain@linux-m68k.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

> ---
>  drivers/scsi/dc395x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 24c7cefb0b78..1c79e6c27163 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -4618,6 +4618,7 @@ static int dc395x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
>  	/* initialise the adapter and everything we need */
>   	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
>  		dprintkl(KERN_INFO, "adapter init failed\n");
> +		acb = NULL;
>  		goto fail;
>  	}
>  
> 
