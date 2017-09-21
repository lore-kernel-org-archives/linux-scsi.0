From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V3 4/9] pm80xx : tag allocation for phy control request.
Date: Thu, 21 Sep 2017 10:09:17 +0200
Message-ID: <CAMGffE=vppsHXuhs-oDEE2byLK5eTbQksNB_VocenTzjxs564A@mail.gmail.com>
References: <20170919171004.10331-5-Viswas.G@microsemi.com> <201709202301.kp97QgzH%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:43032 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdIUIJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2017 04:09:39 -0400
Received: by mail-qt0-f179.google.com with SMTP id i50so5175173qtf.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 01:09:38 -0700 (PDT)
In-Reply-To: <201709202301.kp97QgzH%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: Viswas G <Viswas.G@microsemi.com>, kbuild-all@01.org, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Sep 20, 2017 at 5:18 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Viswas,
>
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on v4.14-rc1 next-20170920]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Viswas-G/pm80xx-updates/=
20170920-202506
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-=
next
> config: x86_64-randconfig-a0-09202136 (attached as .config)
> compiler: gcc-4.4 (Debian 4.4.7-8) 4.4.7
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Dx86_64
>
> All warnings (new ones prefixed by >>):
>
>    drivers/scsi/pm8001/pm80xx_hwi.c: In function 'pm80xx_chip_phy_ctl_req=
':
>>> drivers/scsi/pm8001/pm80xx_hwi.c:4507: warning: unused variable 'ret'
>
> vim +/ret +4507 drivers/scsi/pm8001/pm80xx_hwi.c

Indeed, ret is unused, Viswas, could you send a update patch to fix
the warning in this patch and patch5.

Thanks
>
> f5860992d Sakthivel K 2013-04-17  4492
> f5860992d Sakthivel K 2013-04-17  4493  /**
> f5860992d Sakthivel K 2013-04-17  4494   * pm80xx_chip_phy_ctl_req - supp=
ort the local phy operation
> f5860992d Sakthivel K 2013-04-17  4495   * @pm8001_ha: our hba card infor=
mation.
> f5860992d Sakthivel K 2013-04-17  4496   * @num: the inbound queue number
> f5860992d Sakthivel K 2013-04-17  4497   * @phy_id: the phy id which we w=
anted to operate
> f5860992d Sakthivel K 2013-04-17  4498   * @phy_op:
> f5860992d Sakthivel K 2013-04-17  4499   */
> f5860992d Sakthivel K 2013-04-17  4500  static int pm80xx_chip_phy_ctl_re=
q(struct pm8001_hba_info *pm8001_ha,
> f5860992d Sakthivel K 2013-04-17  4501          u32 phyId, u32 phy_op)
> f5860992d Sakthivel K 2013-04-17  4502  {
> 18e9bdf60 Viswas G    2017-09-19  4503          u32 tag;
> 18e9bdf60 Viswas G    2017-09-19  4504          int rc;
> f5860992d Sakthivel K 2013-04-17  4505          struct local_phy_ctl_req =
payload;
> f5860992d Sakthivel K 2013-04-17  4506          struct inbound_queue_tabl=
e *circularQ;
> f5860992d Sakthivel K 2013-04-17 @4507          int ret;
> f5860992d Sakthivel K 2013-04-17  4508          u32 opc =3D OPC_INB_LOCAL=
_PHY_CONTROL;
> f5860992d Sakthivel K 2013-04-17  4509          memset(&payload, 0, sizeo=
f(payload));
> 18e9bdf60 Viswas G    2017-09-19  4510          rc =3D pm8001_tag_alloc(p=
m8001_ha, &tag);
> 18e9bdf60 Viswas G    2017-09-19  4511          if (rc)
> 18e9bdf60 Viswas G    2017-09-19  4512                  return rc;
> f5860992d Sakthivel K 2013-04-17  4513          circularQ =3D &pm8001_ha-=
>inbnd_q_tbl[0];
> 18e9bdf60 Viswas G    2017-09-19  4514          payload.tag =3D cpu_to_le=
32(tag);
> f5860992d Sakthivel K 2013-04-17  4515          payload.phyop_phyid =3D
> f5860992d Sakthivel K 2013-04-17  4516                  cpu_to_le32(((phy=
_op & 0xFF) << 8) | (phyId & 0xFF));
> 18e9bdf60 Viswas G    2017-09-19  4517          return pm8001_mpi_build_c=
md(pm8001_ha, circularQ, opc, &payload, 0);
> f5860992d Sakthivel K 2013-04-17  4518  }
> f5860992d Sakthivel K 2013-04-17  4519
>
> :::::: The code at line 4507 was first introduced by commit
> :::::: f5860992db55c9e36b0f120dff73f0c34abe510d [SCSI] pm80xx: Added SPCv=
/ve specific hardware functionalities and relevant changes in common files
>
> :::::: TO: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> :::::: CC: James Bottomley <JBottomley@Parallels.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Ce=
nter
> https://lists.01.org/pipermail/kbuild-all                   Intel Corpora=
tion



--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
