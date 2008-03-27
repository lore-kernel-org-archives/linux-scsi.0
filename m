From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH 7/9][RESEND] mvsas: get phy info.
Date: Thu, 27 Mar 2008 10:04:49 -0700
Message-ID: <da824cf30803271004i64a785afn6c0030984dca96eb@mail.gmail.com>
References: <47EB44E5.9080204@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:43688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbYC0REz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 13:04:55 -0400
Received: from zps76.corp.google.com (zps76.corp.google.com [172.25.146.76])
	by smtp-out.google.com with ESMTP id m2RH4pRh017378
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2008 10:04:51 -0700
Received: from wf-out-1314.google.com (wfg23.prod.google.com [10.142.7.23])
	by zps76.corp.google.com with ESMTP id m2RH4ojm010771
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2008 10:04:50 -0700
Received: by wf-out-1314.google.com with SMTP id 23so4337041wfg.21
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2008 10:04:50 -0700 (PDT)
In-Reply-To: <47EB44E5.9080204@marvell.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, jeff@garzik.org

On Wed, Mar 26, 2008 at 11:55 PM, Ke Wei <kewei@marvell.com> wrote:
> removed unused code and attached SATA address makes use of port id.
>  enable HBA interrupt after calling sas_register_ha();

just one small nit and one question.

...
>  @@ -2837,20 +2812,34 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
>                         } else {
>                                 dev_printk(KERN_DEBUG, &pdev->dev,
>                                         "No sig fis\n");
>  +                               phy->phy_type &= ~(PORT_TYPE_SATA);

shouldn't need '()'s around the constant.

>  +                               goto out_done;
>                         }
>                 }
>  +               tmp64 = cpu_to_be64(phy->att_dev_sas_addr);
>  +               memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);

Why does this need to be a memcpy and not just a simple store operation?
Is it misaligned? (even if it is, the kernel will deal with it. It
just won't be fast.)

hth,
grant
