Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61446C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 16:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3393E206A4
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 16:00:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Q3p0TgL6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgFKQAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 12:00:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29837 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbgFKQAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 12:00:20 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200611160015epoutp01de6b5d15e16571c0da05bbe3d388a263~XiKBUoT6C0727407274epoutp01a
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2020 16:00:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200611160015epoutp01de6b5d15e16571c0da05bbe3d388a263~XiKBUoT6C0727407274epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591891215;
        bh=lecpeXImpb7oYqdTcuwiJXcwT0dC2y4CVUjku+eEK2o=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Q3p0TgL6mZ+qoz4DqGitOxsjRt73QmN+AeJwwthj7VJS8mTYF/GSpivzWCowcxulO
         VuOhwzJvh1fBCwDMDuzv3wtYQgv9Q35pkPi/Y2lDPwHPCjg/9PrzbsP6dlJYl5ig6+
         muE8zX8DeRtiJ0JkoYegg0cvTOyGTso+m7IGu/5M=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200611160014epcas5p2cf01d6925ec5a1c4491c2f5383e3fdce~XiKAghsTR1795317953epcas5p2B;
        Thu, 11 Jun 2020 16:00:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.CA.09703.E0552EE5; Fri, 12 Jun 2020 01:00:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200611160013epcas5p241dfad1ab048179f76324609210b49ba~XiJ-5GbkG2347623476epcas5p2J;
        Thu, 11 Jun 2020 16:00:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200611160013epsmtrp1e1195a5568cc94834aeadd4bc6c66fea~XiJ-4SUhE0974309743epsmtrp1Z;
        Thu, 11 Jun 2020 16:00:13 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-18-5ee2550ef572
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CE.D0.08303.D0552EE5; Fri, 12 Jun 2020 01:00:13 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200611160010epsmtip11aab600accbbb5d0f1b4b09c08572726~XiJ870pby0165601656epsmtip16;
        Thu, 11 Jun 2020 16:00:10 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Winkler, Tomas'" <tomas.winkler@intel.com>,
        "'Bean Huo'" <huobean@gmail.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <bvanassche@acm.org>, <cang@codeaurora.org>,
        <ebiggers@kernel.org>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <bd961d352864412381ca551512ea759e@intel.com>
Subject: RE: [PATCH v3 2/2] scsi: ufs: remove wrapper function
 ufshcd_setup_clocks()
Date:   Thu, 11 Jun 2020 21:30:08 +0530
Message-ID: <002301d64009$644364f0$2cca2ed0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIGk+PiZ8drLgZOsw/xGQ6ddVivTgFx7cslAKce2n0BM0uD76hYhuuA
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7bCmui5f6KM4g5/bFC32tp1gt3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8XaPX+YLeacbWCyWHRjG5PF5V1z2Cy6r+9gs1h+/B+TxdKtNxkt
        PvTUOfB6XL7i7XG5r5fJY+esu+wei/e8ZPLYtKqTzWPCogOMHi0n97N4fF/fwebx8ektFo/P
        m+Q82g90MwVwR3HZpKTmZJalFunbJXBlTPvSwlwwTb9iy2L+BsYpal2MnBwSAiYSKyd+Yuti
        5OIQEtjNKNFzaDsrSEJI4BOjxIafGRD2Z0aJyTt9YRqmtfdCNexilJiwdDEbRNEbRonXa2xA
        bDYBXYkdi9vAikQEtjFJXP9/A2wqs4CDxMkHO5hAbE4BS4mLC5rA4sICYRKLnz5gB7FZBFQl
        DrYdZASxeYFq3rbvYIewBSVOznzCAjFHXmL72znMEBcpSPx8ugxsjoiAm8TVLfehasQljv7s
        YQY5QkLgBYdE48e97BANLhLXt95jgbCFJV4d3wIVl5J42d8GZHMA2dkSPbuMIcI1EkvnHYMq
        t5c4cGUOC0gJs4CmxPpd+hCr+CR6fz9hgujklehoE4KoVpVofncVqlNaYmJ3NytEiYfE8ofK
        ExgVZyH5axaSv2YhuX8Wwq4FjCyrGCVTC4pz01OLTQuM8lLL9YoTc4tL89L1kvNzNzGCU56W
        1w7Ghw8+6B1iZOJgPMQowcGsJMIrKP4wTog3JbGyKrUoP76oNCe1+BCjNAeLkjiv0o8zcUIC
        6YklqdmpqQWpRTBZJg5OqQamXOf4Jft4RJZwVchbCHRYvj1ddMGySflxQviM6rnrV5xJuPRF
        RaA5OLpQw3r13X1TpuVc1qsSE3BzXKVcMUFcJ3OWifH3cMZNwYdTrzRutVepb0lb+bHy7/Wb
        vEyiMV1Kql75jYZ9HzIKm/YX+t9cdu+XltY/0c873Exy3m7Wu/N3+ooFTcetnNr32Jj7TWIP
        iGbf4P06a9a3dweP6G/ikwiKNbbQvHaGf8bU4hwJuTd7lztYbFNKlGo48dRo/fHZIfbe29mt
        HZQnpQu3qDzc9ks/4ssqfgtm57yXTAmHLblvL3p/slBY99Du/7euVsuWHOt75iZpX/jKJI71
        /aoC8Qe17eoeiSdK/u9lZVNiKc5INNRiLipOBADccktB6AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWy7bCSnC5v6KM4g9tbTSz2tp1gt3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8XaPX+YLeacbWCyWHRjG5PF5V1z2Cy6r+9gs1h+/B+TxdKtNxkt
        PvTUOfB6XL7i7XG5r5fJY+esu+wei/e8ZPLYtKqTzWPCogOMHi0n97N4fF/fwebx8ektFo/P
        m+Q82g90MwVwR3HZpKTmZJalFunbJXBlTPvSwlwwTb9iy2L+BsYpal2MnBwSAiYS09p72boY
        uTiEBHYwSiw+NZcdIiEtcX3jBChbWGLlv+fsEEWvGCVan31kBEmwCehK7FjcxgZiiwgcYpLY
        tyOni5GDg1nASWLPzSSI+geMEu8/tYDVcwpYSlxc0MQKYgsLhEjsabnJAmKzCKhKHGw7CFbD
        C1Tztn0HO4QtKHFy5hMWiJl6Em0bwUqYBeQltr+dwwxxm4LEz6fLWCFOcJO4uuU+C0SNuMTR
        nz3MExiFZyGZNAth0iwkk2Yh6VjAyLKKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4
        erW0djDuWfVB7xAjEwfjIUYJDmYlEV5B8YdxQrwpiZVVqUX58UWlOanFhxilOViUxHm/zloY
        JySQnliSmp2aWpBaBJNl4uCUamDS8zqTq/a4cxanXvoOOZauNzJ9iuGWpVeq7rlr36p4G+qw
        5P3NbcazEy+qrQwzm+AwxSq70zWJ95CUXo27n9WrN3VMvS+X8/LGbKx4Pcs1hvvQih9Tfp8v
        OnlF4L6QUJpm3SU+PctNe/33bj5xnnPPU/WrGjPTvc4qxy3859CYEte6LfDZ0ju7ZwYIlW/R
        tfpqsz1NwfZEyvcS48935/IatS7qbdx75qqumMXJib6WT3eueiaw1qugd9kK6wusTzXP9vdY
        3f/2l/3wvN+5l7J3Skq94WqbqiO+aVX5L43qV0nPD/pc+/7Y5vpbSZbKf+pLelyeVpyyryxZ
        UrqgSejHASf3PTZr9ntHqfU+07JXYinOSDTUYi4qTgQA/1CyTU0DAAA=
X-CMS-MailID: 20200611160013epcas5p241dfad1ab048179f76324609210b49ba
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200606232833epcas5p4252a12cb9eba59ca867c48c16b1e950c
References: <20200605200520.20831-1-huobean@gmail.com>
        <20200605200520.20831-3-huobean@gmail.com>
        <CGME20200606232833epcas5p4252a12cb9eba59ca867c48c16b1e950c@epcas5p4.samsung.com>
        <bd961d352864412381ca551512ea759e@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

> -----Original Message-----
> From: Winkler, Tomas <tomas.winkler@intel.com>
> Sent: 07 June 2020 04:58
> To: Bean Huo <huobean@gmail.com>; alim.akhtar@samsung.com;
> avri.altman@wdc.com; asutoshd@codeaurora.org; jejb@linux.ibm.com;
> martin.petersen@oracle.com; stanley.chu@mediatek.com;
> beanhuo@micron.com; bvanassche@acm.org; cang@codeaurora.org;
> ebiggers@kernel.org
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH v3 2/2] scsi: ufs: remove wrapper function
> ufshcd_setup_clocks()
> 
> 
> >
> > From: Bean Huo <beanhuo@micron.com>
> >
> > The static function ufshcd_setup_clocks() is just a wrapper around
> > __ufshcd_setup_clocks(), remove it. Rename original function wrapped
> > __ufshcd_setup_clocks() to new ufshcd_setup_clocks().
> 
> Not sure about this change, we have only one call with skip_ref_clock set
to
> true, the original code actually make sense from readability stand point.
> 
I do agree with Tomas, it easy to read and understand the original code.
Thanks

> >
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 32 ++++++++++++--------------------
> >  1 file changed, 12 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index ec4f55211648..531d0b7878db 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -215,9 +215,7 @@ static int ufshcd_eh_host_reset_handler(struct
> > scsi_cmnd *cmd);  static int ufshcd_clear_tm_cmd(struct ufs_hba *hba,
> > int tag);  static void ufshcd_hba_exit(struct ufs_hba *hba);  static
> > int ufshcd_probe_hba(struct ufs_hba *hba, bool async); -static int
> > __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
> > -				 bool skip_ref_clk);
> > -static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
> > +static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on, bool
> > +skip_ref_clk);
> >  static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);  static
> > inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
> > static int ufshcd_host_reset_and_restore(struct ufs_hba *hba); @@
> > -1497,7 +1495,7 @@ static void ufshcd_ungate_work(struct work_struct
> *work)
> >  	}
> >
> >  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> > -	ufshcd_setup_clocks(hba, true);
> > +	ufshcd_setup_clocks(hba, true, false);
> >
> >  	ufshcd_enable_irq(hba);
> >
> > @@ -1655,10 +1653,10 @@ static void ufshcd_gate_work(struct
> > work_struct
> > *work)
> >  	ufshcd_disable_irq(hba);
> >
> >  	if (!ufshcd_is_link_active(hba))
> > -		ufshcd_setup_clocks(hba, false);
> > +		ufshcd_setup_clocks(hba, false, false);
> >  	else
> >  		/* If link is active, device ref_clk can't be switched off
*/
> > -		__ufshcd_setup_clocks(hba, false, true);
> > +		ufshcd_setup_clocks(hba, false, true);
> >
> >  	/*
> >  	 * In case you are here to cancel this work the gating state @@ -
> > 7683,8 +7681,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
> >  	return 0;
> >  }
> >
> > -static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
> > -					bool skip_ref_clk)
> > +static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on, bool
> > +skip_ref_clk)
> >  {
> >  	int ret = 0;
> >  	struct ufs_clk_info *clki;
> > @@ -7747,11 +7744,6 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> > *hba, bool on,
> >  	return ret;
> >  }
> >
> > -static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on) -{
> > -	return  __ufshcd_setup_clocks(hba, on, false);
> > -}
> > -
> >  static int ufshcd_init_clocks(struct ufs_hba *hba)  {
> >  	int ret = 0;
> > @@ -7858,7 +7850,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
> >  	if (err)
> >  		goto out_disable_hba_vreg;
> >
> > -	err = ufshcd_setup_clocks(hba, true);
> > +	err = ufshcd_setup_clocks(hba, true, false);
> >  	if (err)
> >  		goto out_disable_hba_vreg;
> >
> > @@ -7880,7 +7872,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
> >  out_disable_vreg:
> >  	ufshcd_setup_vreg(hba, false);
> >  out_disable_clks:
> > -	ufshcd_setup_clocks(hba, false);
> > +	ufshcd_setup_clocks(hba, false, false);
> >  out_disable_hba_vreg:
> >  	ufshcd_setup_hba_vreg(hba, false);
> >  out:
> > @@ -7896,7 +7888,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
> >  		if (ufshcd_is_clkscaling_supported(hba))
> >  			if (hba->devfreq)
> >  				ufshcd_suspend_clkscaling(hba);
> > -		ufshcd_setup_clocks(hba, false);
> > +		ufshcd_setup_clocks(hba, false, false);
> >  		ufshcd_setup_hba_vreg(hba, false);
> >  		hba->is_powered = false;
> >  		ufs_put_device_desc(hba);
> > @@ -8259,10 +8251,10 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >  	ufshcd_disable_irq(hba);
> >
> >  	if (!ufshcd_is_link_active(hba))
> > -		ufshcd_setup_clocks(hba, false);
> > +		ufshcd_setup_clocks(hba, false, false);
> >  	else
> >  		/* If link is active, device ref_clk can't be switched off
*/
> > -		__ufshcd_setup_clocks(hba, false, true);
> > +		ufshcd_setup_clocks(hba, false, true);
> >
> >  	hba->clk_gating.state = CLKS_OFF;
> >  	trace_ufshcd_clk_gating(dev_name(hba->dev), hba-
> > >clk_gating.state); @@ -8321,7 +8313,7 @@ static int
> > >ufshcd_resume(struct
> > ufs_hba *hba, enum ufs_pm_op pm_op)
> >
> >  	ufshcd_hba_vreg_set_hpm(hba);
> >  	/* Make sure clocks are enabled before accessing controller */
> > -	ret = ufshcd_setup_clocks(hba, true);
> > +	ret = ufshcd_setup_clocks(hba, true, false);
> >  	if (ret)
> >  		goto out;
> >
> > @@ -8404,7 +8396,7 @@ static int ufshcd_resume(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >  	ufshcd_disable_irq(hba);
> >  	if (hba->clk_scaling.is_allowed)
> >  		ufshcd_suspend_clkscaling(hba);
> > -	ufshcd_setup_clocks(hba, false);
> > +	ufshcd_setup_clocks(hba, false, false);
> >  out:
> >  	hba->pm_op_in_progress = 0;
> >  	if (ret)
> > --
> > 2.17.1


