Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A27DC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 15:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0935023135
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 15:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597073929;
	bh=ymggXvQMYTuMlvb7REMGaGjoHB0LOXnlg1VMPd0fUPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aSSwIDZYMviD9GrB1fLGdN5SK0+2W0S8d/VXwBbSJ1NnNL1Q6qEk8LjEP9EnN77ur
	 d1/T17d3UXVeFTRZxoZ1ORJHQUIKkGQyZ/zp6LG2EiFYNECfxq0WYtpvC3LIKCDlMC
	 HnuYxR3mueb2ASlZeRrvGa/UPQSk7j+qqfzKu+k4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgHJPiq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 11:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgHJPin (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 11:38:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FA4D22D6F;
        Mon, 10 Aug 2020 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073923;
        bh=ymggXvQMYTuMlvb7REMGaGjoHB0LOXnlg1VMPd0fUPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gqSdXHM81gwbzXzR3XVYr5Cv+R1XKxsB0Haq0sLcU11okQ/SfDFLepmttZBjNBRI2
         sJqCnW2gXGPrpEQeQ4uA6hzCEITw02Wz/B5xg8mRxj58Gcj49fcoo4GoZDCWd6aA+G
         RTRqaZuEkc70RUANlwkxqSbzHWGUoSIzKPAJXLxE=
Date:   Mon, 10 Aug 2020 17:38:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avi Shchislowski <Avi.Shchislowski@wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Message-ID: <20200810153835.GA4169109@kroah.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
 <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
 <4174fcf4-73ec-8e3f-90a5-1e7584e3e2d0@acm.org>
 <SN6PR04MB3872FBE1EAE3578BFD2601189A7F0@SN6PR04MB3872.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR04MB3872FBE1EAE3578BFD2601189A7F0@SN6PR04MB3872.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 16, 2020 at 10:00:57AM +0000, Avi Shchislowski wrote:
> 
> 
> > -----Original Message-----
> > From: Bart Van Assche <bvanassche@acm.org>
> > Sent: Thursday, July 16, 2020 4:42 AM
> > To: Avi Shchislowski <Avi.Shchislowski@wdc.com>;
> > daejun7.park@samsung.com; Avri Altman <Avri.Altman@wdc.com>;
> > jejb@linux.ibm.com; martin.petersen@oracle.com; asutoshd@codeaurora.org;
> > beanhuo@micron.com; stanley.chu@mediatek.com; cang@codeaurora.org;
> > tomas.winkler@intel.com; ALIM AKHTAR <alim.akhtar@samsung.com>
> > Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Sang-yoon Oh
> > <sangyoon.oh@samsung.com>; Sung-Jun Park
> > <sungjun07.park@samsung.com>; yongmyung lee
> > <ymhungry.lee@samsung.com>; Jinyoung CHOI <j-
> > young.choi@samsung.com>; Adel Choi <adel.choi@samsung.com>; BoRam
> > Shin <boram.shin@samsung.com>
> > Subject: Re: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
> > 
> > CAUTION: This email originated from outside of Western Digital. Do not click on
> > links or open attachments unless you recognize the sender and know that the
> > content is safe.
> > 
> > 
> > On 2020-07-15 11:34, Avi Shchislowski wrote:
> > > My name is Avi Shchislowski, I am managing the WDC's Linux Host R&D team
> > in which Avri is a member of.
> > > As the review process of HPB is progressing very constructively, we are getting
> > more and more requests from OEMs, Inquiring about HPB in general, and host
> > control mode in particular.
> > >
> > > Their main concern is that HPB will make it to 5.9 merge window, but the host
> > control mode patches will not.
> > > Thus, because of recent Google's GKI, the next Android LTS might not include
> > HPB with host control mode.
> > >
> > > Aside of those requests, initial host control mode testing are showing
> > promising prospective with respect of performance gain.
> > >
> > > What would be, in your opinion, the best policy that host control mode is
> > included in next Android LTS?
> > 
> > Hi Avi,
> > 
> > Are you perhaps referring to the HPB patch series that has already been posted?
> > Although I'm not sure of this, I think that the SCSI maintainer expects more
> > Reviewed-by: and Tested-by: tags. Has anyone from WDC already taken the
> > time to review and/or test this patch series?
> > 
> > Thanks,
> > 
> > Bart.
> 
> Yes, I am referring to the current proposal which I am replying to:
> [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support This proposal does not contains host mode, hence our customers concern.
> What would be, in your opinion, the best policy that host control mode is included in next Android LTS  assuming it will be based on kernel v5.9 ?

To come back to this statement, as I keep seeing it in odd places...

I have never said that the next LTS kernel would be 5.9, where did you
get that from?  I am pretty sure that Google is also not saying that
either.

Work to get the feature accepted properly, do not worry about cramming
anything into any kernel just because it might be a LTS release.  That
causes problems that we have had in the past, and one would hope that we
would have learned from our mistakes.

thanks,

greg k-h
