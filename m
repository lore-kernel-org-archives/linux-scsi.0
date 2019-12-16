Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF20C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 18:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 309B8206E0
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 18:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="SvBhIWUe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BLMVqORe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfLPSWL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 13:22:11 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:46655 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732160AbfLPSV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 13:21:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5FB283338;
        Mon, 16 Dec 2019 13:21:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 16 Dec 2019 13:21:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=O
        9KZEvUpFXncIH94Knnxniibj3heNmy7V3nd1J3VERM=; b=SvBhIWUe/V3wGngKR
        aVLH+4eb/yehmeU3Z5t2cfVO5yTOjZWOJ8iTjEuLFcrp6C+Ve8a+9N5aiL2Ytnk1
        WNamFozI/YCVeSzEwpmg5bpvzbWbY0jWW85HkXCLmaEsWnWdKjkxtUTwHHCcJ3mF
        UNB07fbsk6ed38UHwOP1AXXd2nH6yqk/qtxJdOKXmxr99OLebpyGtENMUKOzle3R
        apIGxt3njtTMeqsEM2k6ddww6Zw+gRbizIpGt9qfxyipyekjXRXglBDPlvcGDfrh
        Lm6ontrQn3a/TXPB34QiHziAdrYnxDEhbE82ZPVK5NPUiV3FyxdsR57CuemW1ZzC
        +3+SA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=O9KZEvUpFXncIH94Knnxniibj3heNmy7V3nd1J3VE
        RM=; b=BLMVqOReRV4/BfImfG6xp9BloG9FkVfDh8LrxrQzF9VoYdQ9/fOfujqh+
        6l4O2NrKl7jprwtyoI4AzqtzK3RKFMks7bQ4Jg1m7NQDkoEKAVA3Xq8oHMF17GOc
        SsIHJ1gzuFxByaj7ZDW4GQu5r2MscmiuAT4KtgIIq7HZBgk5lGxomuMY6mTRcDVh
        kBIGpTQGsJp9JTaBKIkRhXu2+cr5l7AsW4kqn/a7MOihe18KjwN1D3AksAGiHP1j
        BzvCIeAsHw0D6rgE06UCZjjtRNu09bw5cFuZhkKSG5qxDc7jT36fVfnur4U/ziNo
        l1SQamV3ks2NpUdVBuACVjCFb1nyw==
X-ME-Sender: <xms:Rcv3XexTS_-WLsGxP1hTKHxJP9I6Ezub2DCYTnp3gUwFfSlhyHmbqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddthedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Rcv3XYLJ3d7IoCc0VW7CldZ2stYBhKt36vH2ydVPBGaXGu8_yEa09w>
    <xmx:Rcv3XZYMJ1PjRfPhUQWvbJSx6nLqBodsiM3IARStb_u4qpG0xrSjKQ>
    <xmx:Rcv3XVx9ScZPO5SBJ7vjQoIbYwW-x3gXvy_VjPbTQJDPkYb7KoCyLg>
    <xmx:Rsv3Xbsakt5YFcNo1bCqFfJIcw155lJq1xBVnUEm9MC5Xuf5DLT_Bg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B0A8680062;
        Mon, 16 Dec 2019 13:21:56 -0500 (EST)
Date:   Mon, 16 Dec 2019 19:06:56 +0100
From:   Greg KH <greg@kroah.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     cang@codeaurora.org, Bjorn Andersson <bjorn.andersson@linaro.org>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
Message-ID: <20191216180656.GB2404915@kroah.com>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
 <5691bfa1-42e5-3c5f-2497-590bcc0cb2b1@acm.org>
 <926dd55d8d0dc762b1f6461495fc747a@codeaurora.org>
 <62933901-fcdf-b5ae-431d-e1fbfc897128@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62933901-fcdf-b5ae-431d-e1fbfc897128@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 16, 2019 at 09:22:21AM -0800, Bart Van Assche wrote:
> On 12/15/19 8:36 PM, cang@codeaurora.org wrote:
> > On 2019-12-16 05:49, Bart Van Assche wrote:
> > > On 2019-12-11 22:37, Bjorn Andersson wrote:
> > > > It's the asymmetry that I don't like.
> > > > 
> > > > Perhaps if you instead make ufshcd platform_device_register_data() the
> > > > bsg device you would solve the probe ordering, the remove will be
> > > > symmetric and module autoloading will work as well (although then you
> > > > need a MODULE_ALIAS of platform:device-name).
> > > 
> > > Hi Bjorn,
> > > 
> > > From Documentation/driver-api/driver-model/platform.rst:
> > > "Platform devices are devices that typically appear as autonomous
> > > entities in the system. This includes legacy port-based devices and
> > > host bridges to peripheral buses, and most controllers integrated
> > > into system-on-chip platforms.  What they usually have in common
> > > is direct addressing from a CPU bus.  Rarely, a platform_device will
> > > be connected through a segment of some other kind of bus; but its
> > > registers will still be directly addressable."
> > > 
> > > Do you agree that the above description is not a good match for the
> > > ufs-bsg kernel module?
> > 
> > I missed this one.
> > How about making it a plain device and add it from ufs driver?
> 
> Hi Can,
> 
> Since the ufs_bsg kernel module already creates one device node under
> /dev/bsg for each UFS host I don't think that we need to create any
> additional device nodes for ufs-bsg devices. My proposal is to modify the
> original patch 2/3 from this series as follows:
> * Use module_init() instead of late_initcall_sync().
> * Remove the ufshcd_get_hba_list_lock() and
>   ufshcd_put_hba_list_unlock() functions.
> * Implement a notification mechanism in the UFS core that invokes a
>   callback function after an UFS host has been created and also after an
>   UFS host has been removed.

You want to be a bus and have a device on it.

> * Register for these notifications from inside the ufs-bsg driver.

You want to be a bus.

> * During registration for notifications, invoke the UFS host creation
>   callback function for all known UFS hosts.

You want to be a bus.

> * If the UFS core is unloaded, invoke the UFS host removal callback
>   function for all known UFS hosts.

Again, a bus would do all of this for you "for free", right?

Take a look at the crazy "virtual bus" code that the RDMA people are
proposing if you want to try to use something like that, or just take
200 lines of code and be your own bus and devices that hang off of it.
That sounds exactly what you are looking for here.

> I think there are several examples of similar notification mechanisms in the
> Linux kernel, e.g. the probe and remove callback functions in struct
> pci_driver.

Look, a bus!  :)

thanks,

greg k-h
