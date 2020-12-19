Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D49C4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 07:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1EF023BE2
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 07:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgLSHws (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 02:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgLSHwr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Dec 2020 02:52:47 -0500
Date:   Sat, 19 Dec 2020 08:52:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608364327;
        bh=LosQleLwVUVFjt5QY+Uyi+t7QKCQXWEOOOe/fukzRmk=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=qiTPukJ6AGxGHuIMkJMTlssLWL6yyGr7J+NfD96qy+Twnl6c2vp/wdDz2Ohl11/5U
         Ab1uWhoXQ46O/oDGkzKeV3TrcTQvLa+fzhYpA+o0PmfRJluAnRkrt51q6kfawRl2wZ
         2uT+RYAFFhTjT7BUN2TPiOzxAPmTNGv8DQXuDaEg=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v15 1/3] scsi: ufs: Introduce HPB feature
Message-ID: <X92xI1Atgcd7z8e0@kroah.com>
References: <20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d@epcms2p6>
 <CGME20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d@epcms2p8>
 <20201219033039epcms2p849fa40807c1a10934a57a0c28fc356be@epcms2p8>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219033039epcms2p849fa40807c1a10934a57a0c28fc356be@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Dec 19, 2020 at 12:30:39PM +0900, Daejun Park wrote:
> @@ -323,6 +325,8 @@ static struct attribute *ufs_sysfs_device_descriptor[] = {
>  	&dev_attr_number_of_secure_wpa.attr,
>  	&dev_attr_psa_max_data_size.attr,
>  	&dev_attr_psa_state_timeout.attr,
> +	&dev_attr_hpb_version.attr,
> +	&dev_attr_hpb_control.attr,
>  	&dev_attr_ext_feature_sup.attr,
>  	&dev_attr_wb_presv_us_en.attr,
>  	&dev_attr_wb_type.attr,

I thought I said this before, but you are adding new sysfs files, with
no Documentation/ABI/ update which is not allowed.

Please fix up.

thanks,

greg k-h
