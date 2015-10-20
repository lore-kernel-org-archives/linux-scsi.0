From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS framework
Date: Tue, 20 Oct 2015 10:40:52 +0200
Message-ID: <8738374.sFXdg3OStu@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <4269975.xfCo9ut8KK@wuerfel> <56250473.9090700@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:50716 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbJTIlF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2015 04:41:05 -0400
In-Reply-To: <56250473.9090700@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de

On Monday 19 October 2015 15:55:47 John Garry wrote:
> > Do you mean these members?
> >
> >> +       wq->event = PHYUP;
> >> +       wq->hisi_hba = hisi_hba;
> >> +       wq->phy_no = phy_no;
> >
> Yes, these are the members I was referring to. However there is also an 
> element "data" in hisi_sas_wq. This is used in control phy as follows:
> int hisi_sas_control_phy(struct asd_sas_phy *sas_phy,
>                         enum phy_func func,
>                         void *funcdata)
> {
>         ...
>         wq->event = CONTROL_PHY;
>         wq->data = func;
>         ...
>         INIT_WORK(&wq->work_struct, hisi_sas_wq_process);
>         queue_work(hisi_hba->wq, &wq->work_struct);
> }
> 
> void hisi_sas_wq_process(struct work_struct *work)
> {
>         struct hisi_sas_wq *wq =
>                 container_of(work, struct hisi_sas_wq, work_struct);
>         switch (wq->event) {
>         case CONTROL_PHY:
>                 hisi_sas_control_phy_work(hisi_hba, wq->data, phy_no);
> }
> 
> static void hisi_sas_control_phy_work(struct hisi_hba *hisi_hba,
>                                 int func,
>                                 int phy_no)
> {
>         switch (func) {
>         case PHY_FUNC_HARD_RESET:
>                 hard_phy_reset_v1_hw(hisi_hba, phy_no)

Ok.

> > Sorry for being unclear, I implied getting rid of them, by having a
> > work queue per phy. You can create a structure for each phy like
> >
> >       struct hisi_sas_phy {
> >               struct hisi_sas *dev; /* pointer to the device */
> >               unsigned int phy_no;
> >               struct work_struct phyup_work;
> >       };
> >
> > There are probably other things you can put into the same structure.
> > When the phy is brought up, you then just start the phyup work for
> > that phy, which can retrieve its hisi_sas_phy structure from the
> > work_struct pointer, and from there get to the device.
> >
> We could create a work_struct for each event, which would be fine.

Yes, that would be the normal way to do it. You initialize the work
structures from the initial probe function to have the right callbacks,
and then you just queue the right one when you need to defer an event.

 How many different events are there?

> However we would sometimes still need some way of passing data to the 
> event, like the phy control example.

Do you mean the 'int func' argument to hisi_sas_control_phy_work?
It sounds like that would again just be more different work_structs.

At some point that might get silly (having 10 or more work structs
per phy), but then you could restructure the code to use something
other that work queues to get from interrupt context to process
context, e.g. a threaded interrupt handler.

Note that the current code is not only unusual but also fragile
because you rely on GFP_ATOMIC memory allocations from the interrupt
handler, and they tend to eventually fail.

	Arnd
