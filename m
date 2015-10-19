From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS framework
Date: Mon, 19 Oct 2015 16:26:38 +0200
Message-ID: <4269975.xfCo9ut8KK@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <6858991.h0xpYFqkjM@wuerfel> <5624FA23.1050502@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5624FA23.1050502@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Monday 19 October 2015 15:11:47 John Garry wrote:
> On 16/10/2015 14:36, Arnd Bergmann wrote:
> > On Friday 16 October 2015 14:29:55 John Garry wrote:
> >>
> >> It could be considered.
> >>
> >> A potential issue I see is with hisi_sas_control_phy() for
> >> PHY_FUNC_HARD_RESET: this allocates a hisi_sas_wq struct and processes
> >> the reset in the queue work. When we re-enable the phy for the reset,
> >> the phyup irq will want to use the same hisi_sas_wq struct which may be
> >> in use.
> >>
> >> hisi_sas_control_phy() is added in 23/35.
> >
> > I'd have to review more closely, but I think that's fine, as this
> > is how most work queues are used: you can queue the same function
> > multiple times, and it's guaranteed to run at least once after
> > the last queue, so if you queue it while it's already running,
> > it will be called again, otherwise it won't.
> >
> In the scenario I described the issue is not that the second call to 
> queue the work function is lost. The problem is that when we setup the 
> second call we may overwrite elements of the phy's hisi_sas_wq struct 
> which may be still being referenced in the work function for the first call.

Do you mean these members?

> +       wq->event = PHYUP;
> +       wq->hisi_hba = hisi_hba;
> +       wq->phy_no = phy_no;

Sorry for being unclear, I implied getting rid of them, by having a
work queue per phy. You can create a structure for each phy like

	struct hisi_sas_phy {
		struct hisi_sas *dev; /* pointer to the device */
		unsigned int phy_no;
		struct work_struct phyup_work;
	};

There are probably other things you can put into the same structure.
When the phy is brought up, you then just start the phyup work for
that phy, which can retrieve its hisi_sas_phy structure from the
work_struct pointer, and from there get to the device.

	Arnd
