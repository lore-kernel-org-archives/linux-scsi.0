From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS framework
Date: Fri, 16 Oct 2015 14:55:38 +0200
Message-ID: <3757591.KXgD8p0a1E@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-14-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56551 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbbJPM4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2015 08:56:10 -0400
In-Reply-To: <1444663237-238302-14-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de

On Monday 12 October 2015 23:20:25 John Garry wrote:
> @@ -804,6 +818,16 @@ static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
>                 phy->identify.target_port_protocols =
>                         SAS_PROTOCOL_SMP;
>  
> +       wq = kmalloc(sizeof(*wq), GFP_ATOMIC);
> +       if (!wq)
> +               goto end;
> +
> +       wq->event = PHYUP;
> +       wq->hisi_hba = hisi_hba;
> +       wq->phy_no = phy_no;
> +
> +       INIT_WORK(&wq->work_struct, hisi_sas_wq_process);
> +       queue_work(hisi_hba->wq, &wq->work_struct);
>  
>  end:
>         hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
> 

While rereading some other parts of the code, I stumbled over this piece.
You should generally not allocate work structs dynamically. Why not embed
the work struct inside of the phy structure and then just queue that?

	Arnd
