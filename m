Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5BEC2D0C3
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 18:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F33206EC
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 18:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576520531;
	bh=xQzuAvHqF81ZrpOZLPBMiu7ImwxVFZWyQDejleoc3Ls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FulZQLgfbYCeis1CgkIA8VkLoKF6IBtD6X06Zo7BGo9uC0UWhCxyP5X7/YYOm6RUn
	 M63aXiXCJHfAZu0JzJRXspAASHsJ3Dlg+zV+7zfcck61Z/fOTDH//cfk8CjE8lmFIA
	 wmQBZv5qhsKuxYLoS/vQmbWI8KOvXSum+y4Ld5xY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbfLPSV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 13:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732153AbfLPSVy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 13:21:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5619206EC;
        Mon, 16 Dec 2019 18:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520514;
        bh=xQzuAvHqF81ZrpOZLPBMiu7ImwxVFZWyQDejleoc3Ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gwEIDApfZaMAlUG1g/t+VDDlL1gLqUSxCofBdyeR3Nc/y+pJw2/yXDA/YSKru86KG
         O7/jK3JqilSdrreqY+IWFaXQHdInExRczu5l9e8i0uhIXqseI3dObWtgda6GmuacDF
         iVd6EjYl470l7Z2N6mqnkH6GCLdWKOC+xYfARg9U=
Date:   Mon, 16 Dec 2019 19:05:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cang@codeaurora.org
Cc:     Bart Van Assche <bvanassche@acm.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: ufs: Put SCSI host after remove it
Message-ID: <20191216180502.GA2404915@kroah.com>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <cd6dc7c90d43b8ca8254a43da48334fc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd6dc7c90d43b8ca8254a43da48334fc@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 16, 2019 at 10:31:29PM +0800, cang@codeaurora.org wrote:
> On 2019-12-15 02:32, Bart Van Assche wrote:
> > On 12/14/19 8:03 AM, Can Guo wrote:
> > > In ufshcd_remove(), after SCSI host is removed, put it once so that
> > > its
> > > resources can be released.
> > > 
> > > Signed-off-by: Can Guo <cang@codeaurora.org>
> > > 
> > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > index b5966fa..a86b0fd 100644
> > > --- a/drivers/scsi/ufs/ufshcd.c
> > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > @@ -8251,6 +8251,7 @@ void ufshcd_remove(struct ufs_hba *hba)
> > >   	ufs_bsg_remove(hba);
> > >   	ufs_sysfs_remove_nodes(hba->dev);
> > >   	scsi_remove_host(hba->host);
> > > +	scsi_host_put(hba->host);
> > >   	/* disable interrupts */
> > >   	ufshcd_disable_intr(hba, hba->intr_mask);
> > >   	ufshcd_hba_stop(hba, true);
> > 
> > Hi Can,
> > 
> > The UFS driver may queue work asynchronously and that asynchronous
> > work may refer to the SCSI host, e.g. ufshcd_err_handler(). Is it
> > guaranteed that all that asynchronous work has finished before
> > scsi_host_put() is called?
> > 
> > Thanks,
> > 
> > Bart.
> 
> Hi Bart,
> 
> As SCSI host is allocated in ufshcd_platform_init() during platform
> drive probe, it is much more appropriate if platform driver calls
> ufshcd_dealloc_host() in their own drv->remove() path. How do you
> think if I change it as below? If it is OK to you, please ignore my
> previous mails.
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 3d4582e..ea45756 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -3239,6 +3239,7 @@ static int ufs_qcom_remove(struct platform_device
> *pdev)
> 
>         pm_runtime_get_sync(&(pdev)->dev);
>         ufshcd_remove(hba);
> +       ufshcd_dealloc_host(hba);
>         return 0;
>  }

Wait, why is this a platform device?  Don't you hang off of a pci
device?  Or am I missing something earlier in this patchset?

thanks,

greg k-h
