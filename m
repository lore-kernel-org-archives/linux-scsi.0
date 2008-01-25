From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Fri, 25 Jan 2008 09:38:12 -0800
Message-ID: <da824cf30801250938m23be1596wee1071f43300392e@mail.gmail.com>
References: <20080122151857.GA8680@ubuntu.domain>
	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
	 <4796BB5A.9090003@garzik.org>
	 <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
	 <479727D5.8060901@garzik.org>
	 <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:28248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbYAYRiU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2008 12:38:20 -0500
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id m0PHcEAd008665
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2008 17:38:15 GMT
Received: from rv-out-0910.google.com (rvbg11.prod.google.com [10.140.83.11])
	by zps77.corp.google.com with ESMTP id m0PHcD27010183
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2008 09:38:14 -0800
Received: by rv-out-0910.google.com with SMTP id g11so563491rvb.57
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2008 09:38:13 -0800 (PST)
In-Reply-To: <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

On Jan 25, 2008 8:43 AM, Ke Wei <kewei.mv@gmail.com> wrote:
> The attached is Marvell 6440 SAS/SATA driver. I will try to send email
> by git-send-email.
>

Sorry, just saw some more issues in
+static void mvs_hba_interrupt_enable(struct mvs_info *mvi, int enable)

Three comments here:
1) This routine is slightly misnamed since it can both enable and disable
    the interrupt. I _suggest_ to not pass in "enable" parameter and add a
    mvs_hba_interrupt_disable() to deal with (2) and (3) below.

2) On interrupt disable, MMIO write posting _could_ be a problem here.
   ie interrupts could be generated after calling this routine since it doesn't
   force the MMIO write to the PCI device with an MMIO read.
   (For more info on this see chapter 4 of
http://iou.parisc-linux.org/ols_2002/ )

3) Even after fixing (2), interrupts can already be in-flight and not
yet delivered.
    Higher level code needs to make sure it can tolerate a "late arriving" IRQ.
    One MMIO read should mostly solve this for MSI but not for Line-based IRQ.
   (MMIO Read-return will flush inflight MSI).

hth,
grant
