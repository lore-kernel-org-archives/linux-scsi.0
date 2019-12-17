Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4DBC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 00:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8D6F24655
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 00:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="FbimDjNU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfLQAuQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 19:50:16 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:26388 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727569AbfLQAuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 19:50:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576543815; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=qLNr/gHCAFeczYVPQATrRfokdlGVpsfEFr/rEsngAro=;
 b=FbimDjNUVnBbnY+p7ZHU24MzZ+remt7fYn5j1OUZGzHTAxNtaE3/Kj/yQ8DiuS9q9mZkE95d
 PaMDT2YFsv4DiJItDWNE1Z3P10Uv1KssrtaC/yRTmG7s3UF51UiV1VwvY8y9id8i8zLd1/V/
 ac5PBIby/41EK49ZKCOK9nk23eA=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df82641.7f84f811cf10-smtp-out-n02;
 Tue, 17 Dec 2019 00:50:09 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C7E1FC447A2; Tue, 17 Dec 2019 00:50:09 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF84DC433CB;
        Tue, 17 Dec 2019 00:50:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 17 Dec 2019 08:50:08 +0800
From:   cang@codeaurora.org
To:     Greg KH <gregkh@linuxfoundation.org>
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
In-Reply-To: <20191216180502.GA2404915@kroah.com>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <cd6dc7c90d43b8ca8254a43da48334fc@codeaurora.org>
 <20191216180502.GA2404915@kroah.com>
Message-ID: <bd900a0b3fdb8dd8b2cdb42a039f938b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-17 02:05, Greg KH wrote:
> On Mon, Dec 16, 2019 at 10:31:29PM +0800, cang@codeaurora.org wrote:
>> On 2019-12-15 02:32, Bart Van Assche wrote:
>> > On 12/14/19 8:03 AM, Can Guo wrote:
>> > > In ufshcd_remove(), after SCSI host is removed, put it once so that
>> > > its
>> > > resources can be released.
>> > >
>> > > Signed-off-by: Can Guo <cang@codeaurora.org>
>> > >
>> > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > > index b5966fa..a86b0fd 100644
>> > > --- a/drivers/scsi/ufs/ufshcd.c
>> > > +++ b/drivers/scsi/ufs/ufshcd.c
>> > > @@ -8251,6 +8251,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>> > >   	ufs_bsg_remove(hba);
>> > >   	ufs_sysfs_remove_nodes(hba->dev);
>> > >   	scsi_remove_host(hba->host);
>> > > +	scsi_host_put(hba->host);
>> > >   	/* disable interrupts */
>> > >   	ufshcd_disable_intr(hba, hba->intr_mask);
>> > >   	ufshcd_hba_stop(hba, true);
>> >
>> > Hi Can,
>> >
>> > The UFS driver may queue work asynchronously and that asynchronous
>> > work may refer to the SCSI host, e.g. ufshcd_err_handler(). Is it
>> > guaranteed that all that asynchronous work has finished before
>> > scsi_host_put() is called?
>> >
>> > Thanks,
>> >
>> > Bart.
>> 
>> Hi Bart,
>> 
>> As SCSI host is allocated in ufshcd_platform_init() during platform
>> drive probe, it is much more appropriate if platform driver calls
>> ufshcd_dealloc_host() in their own drv->remove() path. How do you
>> think if I change it as below? If it is OK to you, please ignore my
>> previous mails.
>> 
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 3d4582e..ea45756 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -3239,6 +3239,7 @@ static int ufs_qcom_remove(struct 
>> platform_device
>> *pdev)
>> 
>>         pm_runtime_get_sync(&(pdev)->dev);
>>         ufshcd_remove(hba);
>> +       ufshcd_dealloc_host(hba);
>>         return 0;
>>  }
> 
> Wait, why is this a platform device?  Don't you hang off of a pci
> device?  Or am I missing something earlier in this patchset?
> 
> thanks,
> 
> greg k-h

Hi Greg,

I am not saying someone is a platform device here. My point is
whoever allocates the SCSI host in its drv->probe(), should
de-allocate it in its own drv->remove(), just like what ufshcd-pci.c
does.

Thanks,

Can Guo.
