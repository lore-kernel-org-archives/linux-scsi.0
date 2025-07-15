Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660341A8412
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 02:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752546189; cv=none; b=YbEzxSgkertFWk09Od5Tlp4F42/EChVOvPhqueXU40Neyio8xMtMa/daoouOiUxOnerS8OcKNGfvcKpGHtcZJR00ZaaBGghk1UzvSkcKkwz5pPlVjWZEQYjQ+5d8lkfMPowZs4MK1K+BhiPalM+jWWs0P/kyR+7XCj552pHIAGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752546189; c=relaxed/simple;
	bh=ICCDaw3F3G3n4zB3kn1ylHHNAT2pO+AZyKE5FyIHUvk=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=GzIjpFiw3WqVZR8IaL8CfI8NaCtctfHZIOfvjChmaMhWsa6YwP1EcB89KUuJbtWwEmW592NqfQRh7LAGVVOu9OXD/wf1PvWbt7S0nra6USxEfm+9olRuTBMSyjs/r7k+AFWLdt8zpa1PFFSr5oGHil5OOa5bMHO1p3n7VyZRYr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=W17al+bM; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W17al+bM"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250715022304epoutp0351a4a0da104bc19d4a1c3f858300cf8a~SS3geg8je1933619336epoutp03q
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 02:23:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250715022304epoutp0351a4a0da104bc19d4a1c3f858300cf8a~SS3geg8je1933619336epoutp03q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752546184;
	bh=bas5xIrmDXvLqW7AI3jY+fD/5VPBr845IirbpbtOrPY=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=W17al+bMSnamLcbCy+4LS+hfdKhINF1y6jky2qYIA81Npm1caQzka3spyOUrKXM7k
	 ylVmQZp0JzLyuxENFgycY+TYxzaNqvE1eVG0RtZL48MskVXGpj+ekploGGKZDnh4Wa
	 mohjJUN7gUVr9EjGZHa4VOW4fZaKuAbdWwiuPvfg=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20250715022303epcas1p319fc5c5ce97f8865348e1639f13ce5d3~SS3f7hgbX0718807188epcas1p3_;
	Tue, 15 Jul 2025 02:23:03 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.38.250]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bh2zC2Gmvz3hhTB; Tue, 15 Jul
	2025 02:23:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250715022302epcas1p1973875e4f5f755ed3db47ea98c2b3a1a~SS3ejGcMk1723017230epcas1p1V;
	Tue, 15 Jul 2025 02:23:02 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250715022302epsmtip244c81c4691a2c6da3cb512eec29e14e4~SS3eaA9o31720917209epsmtip2i;
	Tue, 15 Jul 2025 02:23:02 +0000 (GMT)
From: =?UTF-8?B?7J207Iq57Z2s?= <sh043.lee@samsung.com>
To: "'Bean Huo'" <huobean@gmail.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <sdriver.sec@samsung.com>
In-Reply-To: <b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
Subject: RE: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Date: Tue, 15 Jul 2025 11:23:01 +0900
Message-ID: <000901dbf52f$63a69090$2af3b1b0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH3aHPkcZ8xP3B7R0c5EXGU8cAQqgKwpSsnAUiyhkKz27bdAA==
Content-Language: ko
X-CMS-MailID: 20250715022302epcas1p1973875e4f5f755ed3db47ea98c2b3a1a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b
References: <CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
	<20250714090617.9212-1-sh043.lee@samsung.com>
	<b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>

> -----Original Message-----
> From: Bean Huo <huobean=40gmail.com>
> Sent: Monday, July 14, 2025 8:21 PM
> To: Seunghui Lee <sh043.lee=40samsung.com>; alim.akhtar=40samsung.com;
> avri.altman=40wdc.com; bvanassche=40acm.org;
> James.Bottomley=40HansenPartnership.com; martin.petersen=40oracle.com; li=
nux-
> scsi=40vger.kernel.org; sdriver.sec=40samsung.com
> Subject: Re: =5BPATCH=5D ufs: core: Use link recovery when the h8 exit fa=
ilure
> during runtime resume
>=20
> On Mon, 2025-07-14 at 18:06 +0900, Seunghui Lee wrote:
> > If the h8 exit fails during runtime resume process, the runtime thread
> > enters runtime suspend immediately and the error handler operates at
> > the same time.
> > It becomes stuck and cannot be recovered through the error handler.
> > To fix this, use link recovery instead of the error handler.
> >
> > Signed-off-by: Seunghui Lee <sh043.lee=40samsung.com>
> > ---
> >  drivers/ufs/core/ufshcd.c =7C 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 50adfb8b335b..dc2845c32d72 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > =40=40 -4340,7 +4340,7 =40=40 static int ufshcd_uic_pwr_ctrl(struct ufs=
_hba
> > *hba, struct uic_command *cmd)
> >         hba->uic_async_done =3D NULL;
> >         if (reenable_intr)
> >                 ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
> > -       if (ret) =7B
> > +       if (ret && =21hba->pm_op_in_progress) =7B
> >                 ufshcd_set_link_broken(hba);
> >                 ufshcd_schedule_eh_work(hba);
> >         =7D
> > =40=40 -4348,6 +4348,14 =40=40 static int ufshcd_uic_pwr_ctrl(struct uf=
s_hba
> > *hba, struct uic_command *cmd)
> >         spin_unlock_irqrestore(hba->host->host_lock, flags);
> >         mutex_unlock(&hba->uic_cmd_mutex);
> >
> > +       /*
> > +        * If the h8 exit fails during the runtime resume process,
> > +        * it becomes stuck and cannot be recovered through the error
> handler.
> > +        * To fix this, use link recovery instead of the error handler.
> > +        */
> > +       if (ret && hba->pm_op_in_progress)
> > +               ret =3D ufshcd_link_recovery(hba);
> > +
> >         return ret;
> >  =7D
> >
> I have one queston:
>=20
> In the error handler, if the link is broken(set by
> ufshcd_set_link_broken()), then in ufshcd_err_handler(), will
> ufshcd_reset_and_restore(hba), does not this work?
>=20
>=20
> Kind regards,
> Bean
>=20


Unfortunately, it doesn't work.
Please refer to the below log.

=5B  310.118416=5D =5B4:    kworker/4:4:  786=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_uic_hibern8_exit: hibern8 exit failed. ret =3D -110
=5B  310.118423=5D =5B4:    kworker/4:4:  786=5D ufshcd-qcom 1d84000.ufshc:=
 __ufshcd_wl_resume: hibern8 exit failed -110

=5B  310.118424=5D =5B0:  kworker/u32:0:   12=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0=
; saved_err =3D 0; saved_uic_err =3D 0; force_reset =3D 0; link is broken

=5B  310.119046=5D =5B4:    kworker/4:4:  786=5D ufs_device_wlun 0:0:0:4948=
8: ufshcd_wl_runtime_resume failed: -110
=5B  310.119051=5D =5B4:    kworker/4:4:  786=5D ufs_device_wlun 0:0:0:4948=
8: ufshcd_wl_runtime_resume: 560926us, pwr_mode(1), link state(3)
-> ufshcd_wl_runtime_resume failed done.
   -> ufshcd_rpm_get_sync() in ufshcd_err_handling_prepare()

=5B  310.119104=5D =5B4:    kworker/4:4:  786=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_runtime_suspend start.
-> ufshcd_runtime_suspend()
   -> ufshcd_suspend()
      -> ufshcd_disable_irq() / ufshcd_setup_clocks( , false) / ufshcd_vreg=
_set_lpm() / ufshcd_hba_vreg_set_lpm()
=5B  310.119111=5DI=5B0:  kworker/u32:0:   12=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_check_errors: Auto Hibern8 Exit failed - status: 0x00000020, upmcrs=
: 0x00000001
=5B  310.119119=5DI=5B0:  kworker/u32:0:   12=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_check_errors: saved_err 0x20 saved_uic_err 0x0
<snip>
=5B  310.119162=5D =5B4:    kworker/4:4:  786=5D  gcc_ufs_mem_phy_gdsc: gen=
pd_power_off
=5B  310.119167=5D =5B4:    kworker/4:4:  786=5D CPU: 4 UID: 0 PID: 786 Com=
m: kworker/4:4 Tainted: G        W  O       6.12.23-android16-5-31706220-ud=
-abogki31706220-4k =231 5bbb440b8bd7ff2d31dd25fab2106d21aa9b6357
=5B  310.119176=5D =5B4:    kworker/4:4:  786=5D Tainted: =5BW=5D=3DWARN, =
=5BO=5D=3DOOT_MODULE
=5B  310.119179=5D =5B4:    kworker/4:4:  786=5D Hardware name: Samsung M2Q=
 PROJECT (board-id,05) (DT)
=5B  310.119183=5D =5B4:    kworker/4:4:  786=5D Workqueue: pm pm_runtime_w=
ork
=5B  310.119189=5D =5B4:    kworker/4:4:  786=5D=20
=5B  310.119192=5D =5B4:    kworker/4:4:  786=5D Call trace:
=5B  310.119195=5D =5B4:    kworker/4:4:  786=5D  dump_backtrace+0xec/0x128
=5B  310.119205=5D =5B4:    kworker/4:4:  786=5D  show_stack+0x18/0x28
=5B  310.119212=5D =5B4:    kworker/4:4:  786=5D  dump_stack_lvl+0x40/0x88
=5B  310.119219=5D =5B4:    kworker/4:4:  786=5D  dump_stack+0x18/0x24
=5B  310.119226=5D =5B4:    kworker/4:4:  786=5D  genpd_power_off+0x304/0x3=
08
=5B  310.119232=5D =5B4:    kworker/4:4:  786=5D  genpd_runtime_suspend+0x2=
60/0x38c
=5B  310.119238=5D =5B4:    kworker/4:4:  786=5D  __rpm_callback+0x94/0x390
=5B  310.119242=5D =5B4:    kworker/4:4:  786=5D  rpm_suspend+0x284/0x640
=5B  310.119249=5D =5B4:    kworker/4:4:  786=5D  rpm_idle+0x58/0x37c
=5B  310.119255=5D =5B4:    kworker/4:4:  786=5D  __pm_runtime_idle+0x60/0x=
150
=5B  310.119262=5D =5B4:    kworker/4:4:  786=5D  ufs_qcom_phy_qmp_v4_power=
_control+0x144/0x15c =5Bphy_qcom_ufs_qmp_v4_canoe f98acc73ebd0cc2fea7bd12b5=
74d8fd77ee19353=5D
=5B  310.119276=5D =5B4:    kworker/4:4:  786=5D  ufs_qcom_phy_power_off+0x=
44/0x308 =5Bphy_qcom_ufs b7bbd5d6bbe64d4ff5f3e89a124ca991f7c4f08a=5D
=5B  310.119291=5D =5B4:    kworker/4:4:  786=5D  phy_power_off+0x58/0xdc
=5B  310.119300=5D =5B4:    kworker/4:4:  786=5D  ufs_qcom_setup_clocks+0x3=
f4/0x7e8 =5Bufs_qcom 01a09a66f1eae71e0199ddd5861db80b7fe6c630=5D
=5B  310.119341=5D =5B4:    kworker/4:4:  786=5D  ufshcd_setup_clocks+0x74/=
0x3d8
=5B  310.119351=5D =5B4:    kworker/4:4:  786=5D  ufshcd_suspend+0x48/0x160
=5B  310.119357=5D =5B4:    kworker/4:4:  786=5D  ufshcd_runtime_suspend+0x=
70/0x1b8
=5B  310.119363=5D =5B4:    kworker/4:4:  786=5D  pm_generic_runtime_suspen=
d+0x40/0x58
=5B  310.119369=5D =5B4:    kworker/4:4:  786=5D  genpd_runtime_suspend+0x1=
28/0x38c
=5B  310.119375=5D =5B4:    kworker/4:4:  786=5D  __rpm_callback+0x94/0x390
=5B  310.119378=5D =5B4:    kworker/4:4:  786=5D  rpm_suspend+0x2a4/0x640
=5B  310.119385=5D =5B4:    kworker/4:4:  786=5D  pm_runtime_work+0x8c/0xa8
=5B  310.119389=5D =5B4:    kworker/4:4:  786=5D  process_scheduled_works+0=
x1c4/0x45c
=5B  310.119394=5D =5B4:    kworker/4:4:  786=5D  worker_thread+0x32c/0x3e8
=5B  310.119399=5D =5B4:    kworker/4:4:  786=5D  kthread+0x11c/0x1b0
=5B  310.119405=5D =5B4:    kworker/4:4:  786=5D  ret_from_fork+0x10/0x20

=5B  310.120394=5D =5B0:  kworker/u32:0:   12=5D  gcc_ufs_mem_phy_gdsc: gen=
pd_power_on
=5B  310.120398=5D =5B0:  kworker/u32:0:   12=5D CPU: 0 UID: 0 PID: 12 Comm=
: kworker/u32:0 Tainted: G        W  O       6.12.23-android16-5-31706220-u=
d-abogki31706220-4k =231 5bbb440b8bd7ff2d31dd25fab2106d21aa9b6357
=5B  310.120408=5D =5B0:  kworker/u32:0:   12=5D Tainted: =5BW=5D=3DWARN, =
=5BO=5D=3DOOT_MODULE
=5B  310.120410=5D =5B0:  kworker/u32:0:   12=5D Hardware name: Samsung M2Q=
 PROJECT (board-id,05) (DT)
=5B  310.120413=5D =5B0:  kworker/u32:0:   12=5D Workqueue: ufs_eh_wq_0 ufs=
hcd_err_handler
=5B  310.120423=5D =5B0:  kworker/u32:0:   12=5D Call trace:
=5B  310.120426=5D =5B0:  kworker/u32:0:   12=5D  dump_backtrace+0xec/0x128
=5B  310.120435=5D =5B0:  kworker/u32:0:   12=5D  show_stack+0x18/0x28
=5B  310.120442=5D =5B0:  kworker/u32:0:   12=5D  dump_stack_lvl+0x40/0x88
=5B  310.120448=5D =5B0:  kworker/u32:0:   12=5D  dump_stack+0x18/0x24
=5B  310.120455=5D =5B0:  kworker/u32:0:   12=5D  genpd_power_on+0x34c/0x3b=
0
=5B  310.120463=5D =5B0:  kworker/u32:0:   12=5D  genpd_runtime_resume+0x16=
c/0x43c
=5B  310.120469=5D =5B0:  kworker/u32:0:   12=5D  __rpm_callback+0x94/0x390
=5B  310.120473=5D =5B0:  kworker/u32:0:   12=5D  rpm_resume+0x3bc/0x5a8
=5B  310.120480=5D =5B0:  kworker/u32:0:   12=5D  __pm_runtime_resume+0x48/=
0x8c
=5B  310.120487=5D =5B0:  kworker/u32:0:   12=5D  ufs_qcom_phy_qmp_v4_power=
_control+0x34/0x15c =5Bphy_qcom_ufs_qmp_v4_canoe f98acc73ebd0cc2fea7bd12b57=
4d8fd77ee19353=5D
=5B  310.120497=5D =5B0:  kworker/u32:0:   12=5D  ufs_qcom_phy_power_on+0x1=
3c/0x79c =5Bphy_qcom_ufs b7bbd5d6bbe64d4ff5f3e89a124ca991f7c4f08a=5D
=5B  310.120512=5D =5B0:  kworker/u32:0:   12=5D  phy_power_on+0x9c/0x124
=5B  310.120520=5D =5B0:  kworker/u32:0:   12=5D  ufs_qcom_setup_clocks+0xb=
4/0x7e8 =5Bufs_qcom 01a09a66f1eae71e0199ddd5861db80b7fe6c630=5D
=5B  310.120560=5D =5B0:  kworker/u32:0:   12=5D  ufshcd_setup_clocks+0x150=
/0x3d8
=5B  310.120567=5D =5B0:  kworker/u32:0:   12=5D  ufshcd_err_handler+0x42c/=
0xd20
=5B  310.120574=5D =5B0:  kworker/u32:0:   12=5D  process_scheduled_works+0=
x1c4/0x45c
=5B  310.120579=5D =5B0:  kworker/u32:0:   12=5D  worker_thread+0x32c/0x3e8
=5B  310.120584=5D =5B0:  kworker/u32:0:   12=5D  kthread+0x11c/0x1b0
=5B  310.120590=5D =5B0:  kworker/u32:0:   12=5D  ret_from_fork+0x10/0x20
-> ufshcd_err_handler()
   -> ufshcd_err_handling_prepare()
      -> ufshcd_setup_clocks( , true)

=5B  310.122158=5D =5B4:    kworker/4:4:  786=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_runtime_suspend: 3056us, pwr_mode(1), link state(3)
-> ufshcd_runtime_suspend done.

=5B  310.122187=5D =5B4:    kworker/4:4:  786=5D  gcc_ufs_phy_gdsc: genpd_p=
ower_off
=5B  310.122191=5D =5B4:    kworker/4:4:  786=5D CPU: 4 UID: 0 PID: 786 Com=
m: kworker/4:4 Tainted: G        W  O       6.12.23-android16-5-31706220-ud=
-abogki31706220-4k =231 5bbb440b8bd7ff2d31dd25fab2106d21aa9b6357
=5B  310.122198=5D =5B4:    kworker/4:4:  786=5D Tainted: =5BW=5D=3DWARN, =
=5BO=5D=3DOOT_MODULE
=5B  310.122200=5D =5B4:    kworker/4:4:  786=5D Hardware name: Samsung M2Q=
 PROJECT (board-id,05) (DT)
=5B  310.122203=5D =5B4:    kworker/4:4:  786=5D Workqueue: pm pm_runtime_w=
ork
=5B  310.122208=5D =5B4:    kworker/4:4:  786=5D Call trace:
=5B  310.122210=5D =5B4:    kworker/4:4:  786=5D  dump_backtrace+0xec/0x128
=5B  310.122218=5D =5B4:    kworker/4:4:  786=5D  show_stack+0x18/0x28
=5B  310.122225=5D =5B4:    kworker/4:4:  786=5D  dump_stack_lvl+0x40/0x88
=5B  310.122231=5D =5B4:    kworker/4:4:  786=5D  dump_stack+0x18/0x24
=5B  310.122238=5D =5B4:    kworker/4:4:  786=5D  genpd_power_off+0x304/0x3=
08
=5B  310.122244=5D =5B4:    kworker/4:4:  786=5D  genpd_runtime_suspend+0x2=
60/0x38c
=5B  310.122249=5D =5B4:    kworker/4:4:  786=5D  __rpm_callback+0x94/0x390
=5B  310.122253=5D =5B4:    kworker/4:4:  786=5D  rpm_suspend+0x2a4/0x640
=5B  310.122260=5D =5B4:    kworker/4:4:  786=5D  pm_runtime_work+0x8c/0xa8
=5B  310.122263=5D =5B4:    kworker/4:4:  786=5D  process_scheduled_works+0=
x1c4/0x45c
=5B  310.122268=5D =5B4:    kworker/4:4:  786=5D  worker_thread+0x32c/0x3e8
=5B  310.122272=5D =5B4:    kworker/4:4:  786=5D  kthread+0x11c/0x1b0
=5B  310.122279=5D =5B4:    kworker/4:4:  786=5D  ret_from_fork+0x10/0x20

=5B  313.197378=5D =5B4:  kworker/u32:0:   12=5D ufs_qcom_phy_qmp_v4_canoe =
1d80000.ufsphy_mem: ufs_qcom_phy_qmp_v4_is_pcs_ready: poll for pcs failed e=
rr =3D -110
=5B  313.197398=5D =5B4:  kworker/u32:0:   12=5D ufshcd-qcom 1d84000.ufshc:=
 ufs_qcom_power_up_sequence: Failed to calibrate PHY -110
=5B  313.255403=5D =5B0:  kworker/u32:0:   12=5D ufshcd-qcom 1d84000.ufshc:=
 Controller enable failed



To fix this, I've tried two more things.

1> The error handler waits until ufshcd_runtime_suspend done.
-> It doesn't work, either.

--- a/common/drivers/ufs/core/ufshcd.c
+++ b/common/drivers/ufs/core/ufshcd.c
=40=40 -6551,6 +6551,11 =40=40 static void ufshcd_err_handling_prepare(stru=
ct ufs_hba *hba)
            hba->is_sys_suspended) =7B
                enum ufs_pm_op pm_op;
=20
+               while (=21pm_runtime_status_suspended(hba->dev)) =7B
+                       dev_err(hba->dev, =22%s: waiting for complete suspe=
nd=5Cn=22, __func__);
+                       msleep(10);
+               =7D
+
                /*
                 * Don't assume anything of resume, if
                 * resume fails, irq and clocks can be OFF, and powers


=5B  335.876451=5D =5B0:    kworker/0:3:  713=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_uic_hibern8_exit: hibern8 exit failed. ret =3D -110
=5B  335.876456=5D =5B0:    kworker/0:3:  713=5D ufshcd-qcom 1d84000.ufshc:=
 __ufshcd_wl_resume: hibern8 exit failed -110

=5B  335.876460=5D =5B4:  kworker/u32:2:   88=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0=
; saved_err =3D 0; saved_uic_err =3D 0; force_reset =3D 0; link is broken

=5B  335.877072=5D =5B0:    kworker/0:3:  713=5D ufs_device_wlun 0:0:0:4948=
8: ufshcd_wl_runtime_resume failed: -110
=5B  335.877076=5D =5B0:    kworker/0:3:  713=5D ufs_device_wlun 0:0:0:4948=
8: ufshcd_wl_runtime_resume: 544445us, pwr_mode(1), link state(3)
-> ufshcd_wl_runtime_resume failed done.
   -> ufshcd_rpm_get_sync() in ufshcd_err_handling_prepare()

=5B  335.877112=5D =5B4:  kworker/u32:2:   88=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_err_handling_prepare: waiting for complete suspend
-> wait until ufshcd_runtime_suspend done.

=5B  335.877123=5D =5B0:    kworker/0:3:  713=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_runtime_suspend start.
=5B  335.879805=5D =5B0:    kworker/0:3:  713=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_runtime_suspend: 2685us, pwr_mode(1), link state(3)

=5B  337.950174=5D =5B4:  kworker/u32:2:   88=5D ufshcd-qcom 1d84000.ufshc:=
 ESI configured
=5B  337.950302=5D =5B4:  kworker/u32:2:   88=5D ufshcd-qcom 1d84000.ufshc:=
 MCQ configured, nr_queues=3D9, io_queues=3D8, read_queue=3D0, poll_queues=
=3D1, queue_depth=3D64
-> ufshcd_reset_and_restore() works well.

=5B  337.970178=5D =5B0:  kworker/u32:2:   88=5D ufs_device_wlun 0:0:0:4948=
8: runtime PM trying to activate child device 0:0:0:49488 but parent (targe=
t0:0:0) is not active
-> ufschd_recover_pm_err()
   -> Because of this error, pm_request_resume doesn't call here.

=5B  337.970212=5D =5B0:  kworker/u32:2:   88=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_err_handler finished; HBA state operational



2> if eh_in_progress, err EBUSY return in ufshcd_runtime_suspend to guarant=
ee the error handling done.
-> It doesn't work as well.

--- a/common/drivers/ufs/core/ufshcd.c
+++ b/common/drivers/ufs/core/ufshcd.c
=40=40 -10371,6 +10371,9 =40=40 int ufshcd_runtime_suspend(struct device *d=
ev)
        int ret;
        ktime_t start =3D ktime_get();
=20
+       if (ufshcd_eh_in_progress(hba))
+               return -EBUSY;
+
        ret =3D ufshcd_suspend(hba);
=20
        trace_ufshcd_runtime_suspend(hba, ret,

=5B   63.010841=5D =5B4:    kworker/4:0:   52=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_uic_hibern8_exit: hibern8 exit failed. ret =3D -110
=5B   63.010844=5D =5B4:    kworker/4:0:   52=5D ufshcd-qcom 1d84000.ufshc:=
 __ufshcd_wl_resume: hibern8 exit failed -110

=5B   63.010845=5D =5B0: kworker/u32:10:13604=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0=
; saved_err =3D 0; saved_uic_err =3D 0; force_reset =3D 0; link is broken

=5B   63.011430=5D =5B4:    kworker/4:0:   52=5D ufs_device_wlun 0:0:0:4948=
8: ufshcd_wl_runtime_resume failed: -110
=5B   63.011433=5D =5B4:    kworker/4:0:   52=5D ufs_device_wlun 0:0:0:4948=
8: ufshcd_wl_runtime_resume: 574917us, pwr_mode(1), link state(3)
-> ufshcd_wl_runtime_resume failed done.
   -> ufshcd_rpm_get_sync() in ufshcd_err_handling_prepare()

=5B   63.011457=5D =5B4:    kworker/4:0:   52=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_runtime_suspend: eh_in_progress
-> EBUSY return in ufshcd_runtime_suspend due to eh_in_progress

=5B   63.011464=5DI=5B0: kworker/u32:10:13604=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_check_errors: Auto Hibern8 Exit failed - status: 0x00000020, upmcrs=
: 0x00000001
=5B   63.011468=5DI=5B0: kworker/u32:10:13604=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_check_errors: saved_err 0x20 saved_uic_err 0x0

=5B   63.039824=5D =5B0: kworker/u32:10:13604=5D ufshcd-qcom 1d84000.ufshc:=
 ufs_qcom_device_reset: Waiting for device internal cache flush

=5B   65.084604=5D =5B0: kworker/u32:10:13604=5D ufshcd-qcom 1d84000.ufshc:=
 ESI configured
=5B   65.084728=5D =5B0: kworker/u32:10:13604=5D ufshcd-qcom 1d84000.ufshc:=
 MCQ configured, nr_queues=3D9, io_queues=3D8, read_queue=3D0, poll_queues=
=3D1, queue_depth=3D64
-> ufshcd_reset_and_restore() works well.

=5B   65.105186=5D =5B1: kworker/u32:10:13604=5D ufs_device_wlun 0:0:0:4948=
8: runtime PM trying to activate child device 0:0:0:49488 but parent (targe=
t0:0:0) is not active
-> ufschd_recover_pm_err()
   -> Because of this error, pm_request_resume doesn't call here.
  =20
=5B   65.105305=5D =5B1: kworker/u32:10:13604=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_err_handler finished; HBA state operational
=5B   65.105310=5D =5B1: kworker/u32:10:13604=5D ufshcd-qcom 1d84000.ufshc:=
 ufshcd_err_handler started; HBA state operational; powered 1; shutting dow=
n 0; saved_err =3D 0; saved_uic_err =3D 0; force_reset =3D 0

