Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F73C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 02:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9E8561183
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 02:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhJTC6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 22:58:21 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58299 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhJTC6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 22:58:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BFCC5C017F;
        Tue, 19 Oct 2021 22:56:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 19 Oct 2021 22:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LihapO
        JibDbKgLkQmgNkWazXnPD8ZgMdnaTNuIUHFRs=; b=frUlDL3DosxQwPSQ8/7ay8
        WKCJEK0QPY99n9VH44MeU+p1SRwVXnT5A7sGYrwXjTpYD5zWMryZUkSFNTUt0d9t
        VMoLthBqdNE/0FuqdZegbVZUDJAq4sBtBxknW5iiG0sZ8j9rQ+bRF+jxFqgX3+NA
        gj/pxD8I8mhl9A5TWMb486LluQn5fscRS8A0Wx7m+i2JLjoJ9onI/ysFRfb75saV
        ZbeEdSAXNw41lBQSH1kHuMEPaJPXxEAvojrTHiVKGJcrpQlUPNP+T5OxDPr268ks
        cLTxLwpjfGc25heDthImrIgoRltI1XkQSH3ls8BcuhjnApJo2XuJD8hk5Wz1TAKQ
        ==
X-ME-Sender: <xms:RoVvYRsgcHjssvl02MUsub05kEv5OcMg0QemnC8H6li-j7DyLGt0Fg>
    <xme:RoVvYacJcE91VUgmTkEQvZPUifylzNiK69B_9y7YqhYUwREGOa0JFDDT3y1jUJj1N
    2hwgqhRyaGW-vS99yI>
X-ME-Received: <xmr:RoVvYUx-tCqX0rhLfka6h3ztfoZGHO0hSY4oWTIQzvrmlKsPT8vhE-ehfCYuA1-WVzmg7vAuAhCKL4yN6mY6S3na91--Tos6hf8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepffduhfegfedvieetudfgleeugeehkeekfeevfffhieevteelvdfhtdevffet
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfh
    hthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:RoVvYYN6RfOt3jLCxR1Gl2ybjuoAoFZDQw3AViAdqaFCfmUxunUipg>
    <xmx:RoVvYR-grsflt_Eeg-1cJ70rOjDbWg82xcyxlf_2jpyjMkhXfEMc8g>
    <xmx:RoVvYYWjsOgx8MDNWd4XCoGrD83UKwavBZjFB7bq33eHtgbLelrzcA>
    <xmx:R4VvYRzCYcwzAZyCGVi68zz2BHWL2Wtik8W3r-tw-VSXdglVptYjiw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 22:56:04 -0400 (EDT)
Date:   Wed, 20 Oct 2021 13:56:11 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     James Bottomley <jejb@linux.ibm.com>
cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_mbox: return -ENOMEM on megaraid_init_mbox()
 allocation failure
In-Reply-To: <2482854e18365087266c2f0907c1bbfd42bd2731.camel@linux.ibm.com>
Message-ID: <c1a6e7f3-d62f-5c5e-b3ef-2320339e142a@linux-m68k.org>
References: <1634640800-22502-1-git-send-email-jiapeng.chong@linux.alibaba.com> <2482854e18365087266c2f0907c1bbfd42bd2731.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Oct 2021, James Bottomley wrote:

> On Tue, 2021-10-19 at 18:53 +0800, Jiapeng Chong wrote:
> > From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> > 
> > Fixes the following smatch warning:
> > 
> > drivers/scsi/megaraid/megaraid_mbox.c:715 megaraid_init_mbox() warn:
> > returning -1 instead of -ENOMEM is sloppy.
> 
> Why is this a problem?  megaraid_init_mbox() is called using this
> pattern:
> 
> 	// Start the mailbox based controller
> 	if (megaraid_init_mbox(adapter) != 0) {
> 		con_log(CL_ANN, (KERN_WARNING
> 			"megaraid: mailbox adapter did not initialize\n"));
> 
> 		goto out_free_adapter;
> 	}
> 
> So the only meaningful returns are 0 on success and anything else
> (although megaraid uses -1 for this) on failure. 

I think you're arguing for a bool (?)

Smatch apparently did not think of that -- probably needs a holiday.

> Since -1 is the conventional failure return, why alter that to something 
> different that still won't be printed or acted on?  And worse still, if 
> we make this change, it will likely excite other static checkers to 
> complain we're losing error information ...
> 

... and arguably they would be correct.
