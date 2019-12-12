Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FB6C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC17227BF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:45:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eqmoKdoc";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Dfv/wf4u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbfLLQpu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 11:45:50 -0500
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:57118
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729101AbfLLQpu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Dec 2019 11:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576169149;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=dMWFqUj597OGNQyE6eCSrcQ6gjogdNfAxXsK5ao5IKc=;
        b=eqmoKdocYDAw+g413RVy4yGWfUpgo9J2oyjSG3JRQZGbVGjKhk7xetaogySXKgwg
        6rt3kRnEt2m8AdkC1aICilRdZ/zxZmWNoybIpZraKiMlVyb4vVbHHM/bLbMz9RYRny6
        s7+bqCJcxD53SeGkApXj5pvyUQLLo4RovUwbGbhI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576169149;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=dMWFqUj597OGNQyE6eCSrcQ6gjogdNfAxXsK5ao5IKc=;
        b=Dfv/wf4uRqlKx3xKOpvY1Y4SSD/7SLo43F9PdPCCeNN1xLCV+K2YyxjhXkbwIFBh
        GL3c1iPX3a/PppvC6yk46LXc+yQm+BFnB9h8uw7QdFAkjG4QRw637OYdPD9gUde8TV8
        WoyKQvxgkI4pOkJxsuXgX/vILFZMJTa2VNTO6FQQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 12 Dec 2019 16:45:49 +0000
From:   cang@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
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
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
In-Reply-To: <20191212063703.GC415177@yoga>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
Message-ID: <0101016efb009269-0de7af38-196d-4a10-8c06-3ca91d2c9177-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.12-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-12 14:37, Bjorn Andersson wrote:
> On Wed 11 Dec 22:01 PST 2019, cang@codeaurora.org wrote:
> 
>> On 2019-12-12 12:53, Bjorn Andersson wrote:
>> > On Wed 11 Dec 00:49 PST 2019, Can Guo wrote:
>> >
>> > > In order to improve the flexibility of ufs-bsg, modulizing it is a
>> > > good
>> > > choice. This change introduces tristate to ufs-bsg to allow users
>> > > compile
>> > > it as an external module.
>> >
>> > Can you please elaborate on what this "flexibility" is and why it's a
>> > good thing?
>> >
>> 
>> ufs-bsg is a helpful gadget for debug/test purpose. But neither
>> disabling it nor enabling it is the best way on a commercialized
>> device. Disabling it means we cannot use it, while enabling it
>> by default will expose all the DEVM/UIC/TM interfaces to user space,
>> which is not "safe" on a commercialized device to let users play with 
>> it.
>> Making it a module can resolve this, because only vendors can install 
>> it
>> as they have the root permissions.
>> 
>> > >
>> > > Signed-off-by: Can Guo <cang@codeaurora.org>
>> > > ---
>> > >  drivers/scsi/ufs/Kconfig   |  3 ++-
>> > >  drivers/scsi/ufs/Makefile  |  2 +-
>> > >  drivers/scsi/ufs/ufs_bsg.c | 49
>> > > +++++++++++++++++++++++++++++++++++++++++++---
>> > >  drivers/scsi/ufs/ufs_bsg.h |  8 --------
>> > >  drivers/scsi/ufs/ufshcd.c  | 36 ++++++++++++++++++++++++++++++----
>> > >  drivers/scsi/ufs/ufshcd.h  |  7 ++++++-
>> > >  6 files changed, 87 insertions(+), 18 deletions(-)
>> > >
>> > > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>> > > index d14c224..72620ce 100644
>> > > --- a/drivers/scsi/ufs/Kconfig
>> > > +++ b/drivers/scsi/ufs/Kconfig
>> > > @@ -38,6 +38,7 @@ config SCSI_UFSHCD
>> > >  	select PM_DEVFREQ
>> > >  	select DEVFREQ_GOV_SIMPLE_ONDEMAND
>> > >  	select NLS
>> > > +	select BLK_DEV_BSGLIB
>> >
>> > Why is this needed?
>> >
>> 
>> Because ufshcd.c needs to call some funcs defined in bsg lib.
>> 
>> > >  	---help---
>> > >  	This selects the support for UFS devices in Linux, say Y and make
>> > >  	  sure that you know the name of your UFS host adapter (the card
>> > > @@ -143,7 +144,7 @@ config SCSI_UFS_TI_J721E
>> > >  	  If unsure, say N.
>> > >
>> > >  config SCSI_UFS_BSG
>> > > -	bool "Universal Flash Storage BSG device node"
>> > > +	tristate "Universal Flash Storage BSG device node"
>> > >  	depends on SCSI_UFSHCD
>> > >  	select BLK_DEV_BSGLIB
>> > >  	help
>> > > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
>> > > index 94c6c5d..904eff1 100644
>> > > --- a/drivers/scsi/ufs/Makefile
>> > > +++ b/drivers/scsi/ufs/Makefile
>> > > @@ -6,7 +6,7 @@ obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
>> > >  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>> > >  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>> > >  ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
>> > > -ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
>> > > +obj-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
>> > >  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>> > >  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>> > >  obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
>> > > diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
>> > > index 3a2e68f..302222f 100644
>> > > --- a/drivers/scsi/ufs/ufs_bsg.c
>> > > +++ b/drivers/scsi/ufs/ufs_bsg.c
>> > > @@ -164,13 +164,15 @@ static int ufs_bsg_request(struct bsg_job *job)
>> > >   */
>> > >  void ufs_bsg_remove(struct ufs_hba *hba)
>> > >  {
>> > > -	struct device *bsg_dev = &hba->bsg_dev;
>> > > +	struct device *bsg_dev = hba->bsg_dev;
>> > >
>> > >  	if (!hba->bsg_queue)
>> > >  		return;
>> > >
>> > >  	bsg_remove_queue(hba->bsg_queue);
>> > >
>> > > +	hba->bsg_dev = NULL;
>> > > +	hba->bsg_queue = NULL;
>> > >  	device_del(bsg_dev);
>> > >  	put_device(bsg_dev);
>> > >  }
>> > > @@ -178,6 +180,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
>> > >  static inline void ufs_bsg_node_release(struct device *dev)
>> > >  {
>> > >  	put_device(dev->parent);
>> > > +	kfree(dev);
>> > >  }
>> > >
>> > >  /**
>> > > @@ -186,14 +189,19 @@ static inline void ufs_bsg_node_release(struct
>> > > device *dev)
>> > >   *
>> > >   * Called during initial loading of the driver, and before
>> > > scsi_scan_host.
>> > >   */
>> > > -int ufs_bsg_probe(struct ufs_hba *hba)
>> > > +static int ufs_bsg_probe(struct ufs_hba *hba)
>> > >  {
>> > > -	struct device *bsg_dev = &hba->bsg_dev;
>> > > +	struct device *bsg_dev;
>> > >  	struct Scsi_Host *shost = hba->host;
>> > >  	struct device *parent = &shost->shost_gendev;
>> > >  	struct request_queue *q;
>> > >  	int ret;
>> > >
>> > > +	bsg_dev = kzalloc(sizeof(*bsg_dev), GFP_KERNEL);
>> > > +	if (!bsg_dev)
>> > > +		return -ENOMEM;
>> > > +
>> > > +	hba->bsg_dev = bsg_dev;
>> > >  	device_initialize(bsg_dev);
>> > >
>> > >  	bsg_dev->parent = get_device(parent);
>> > > @@ -217,6 +225,41 @@ int ufs_bsg_probe(struct ufs_hba *hba)
>> > >
>> > >  out:
>> > >  	dev_err(bsg_dev, "fail to initialize a bsg dev %d\n",
>> > > shost->host_no);
>> > > +	hba->bsg_dev = NULL;
>> > >  	put_device(bsg_dev);
>> > >  	return ret;
>> > >  }
>> > > +
>> > > +static int __init ufs_bsg_init(void)
>> > > +{
>> > > +	struct list_head *hba_list = NULL;
>> > > +	struct ufs_hba *hba;
>> > > +	int ret = 0;
>> > > +
>> > > +	ufshcd_get_hba_list_lock(&hba_list);
>> > > +	list_for_each_entry(hba, hba_list, list) {
>> > > +		ret = ufs_bsg_probe(hba);
>> > > +		if (ret)
>> > > +			break;
>> > > +	}
>> >
>> > So what happens if I go CONFIG_SCSI_UFS_BSG=y and
>> > CONFIG_SCSI_UFS_QCOM=y?
>> >
>> > Wouldn't that mean that ufs_bsg_init() is called before ufshcd_init()
>> > has added the controller to the list? And even in the even that they are
>> > both =m, what happens if they are invoked in the "wrong" order?
>> >
>> 
>> In the case that CONFIG_SCSI_UFS_BSG=y and CONFIG_SCSI_UFS_QCOM=y,
>> I give late_initcall_sync(ufs_bsg_init) to make sure ufs_bsg_init
>> is invoked only after platform driver is probed. I tested this 
>> combination.
>> 
>> In the case that both of them are "m", installing ufs-bsg before 
>> ufs-qcom
>> is installed would have no effect as ufs_hba_list is empty, which is
>> expected.
> 
> Why is it the expected behavior that bsg may or may not probe depending
> on the driver load order and potentially timing of the initialization.
> 
>> And in real cases, as the UFS is the boot device, UFS driver will 
>> always
>> be probed during bootup.
>> 
> 
> The UFS driver will load and probe because it's mentioned in the
> devicetree, but if either the ufs drivers or any of its dependencies
> (phy, resets, clocks, etc) are built as modules it might very well
> finish probing after lateinitcall.
> 
> So in the even that the bsg is =y and any of these drivers are =m, or 
> if
> you're having bad luck with your timing, the list will be empty.
> 
> As described below, if bsg=m, then there's nothing that will load the
> module and the bsg will not probe...
> 
> [..]
>> > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> [..]
>> > >  void ufshcd_remove(struct ufs_hba *hba)
>> > >  {
>> > > -	ufs_bsg_remove(hba);
>> > > +	struct device *bsg_dev = hba->bsg_dev;
>> > > +
>> > > +	mutex_lock(&ufs_hba_list_lock);
>> > > +	list_del(&hba->list);
>> > > +	if (hba->bsg_queue) {
>> > > +		bsg_remove_queue(hba->bsg_queue);
>> > > +		device_del(bsg_dev);
>> >
>> > Am I reading this correct in that you probe the bsg_dev form initcall
>> > and you delete it as the ufshcd instance is removed? That's not okay.
>> >
>> > Regards,
>> > Bjorn
>> >
>> 
>> If ufshcd is removed, its ufs-bsg, if exists, should also be removed.
>> Could you please enlighten me a better way to do this? Thanks.
>> 
> 
> It's the asymmetry that I don't like.
> 
> Perhaps if you instead make ufshcd platform_device_register_data() the
> bsg device you would solve the probe ordering, the remove will be
> symmetric and module autoloading will work as well (although then you
> need a MODULE_ALIAS of platform:device-name).
> 
> Regards,
> Bjorn

Thanks for the suggestion! I didn't even think about this before. I
will go with the platform_device_register_data() way, it will be much
easier. After I get my new patchset tested I will upload it for review.

Best Regards,
Can Guo.
