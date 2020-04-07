Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24F7C2BB55
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 783802076E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Jl8BqXl7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgDGQCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 12:02:46 -0400
Received: from mout.gmx.net ([212.227.17.20]:49349 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbgDGQCp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 12:02:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1586275336;
        bh=MjED2rL8qFcaewF1yuTCY8oY81g21cBSfIGHWAJZhMU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Jl8BqXl73a3riwsYbnv+x7UmfvkDw9tKZL2TNz/DJ0vFDfMaN2+x19lbN9xx87+lC
         3+ZL2kMK+WiwDySFJZjTn3TmI3NAhZWNhxh0yMPypCuDv1dcm6cPNINx9XNyuxNGul
         rH8nkZklPVh2RmUjRZp9o9qblbOHX95hYR+B1LCE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from lenovo-laptop ([82.19.195.159]) by mail.gmx.com (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N1wll-1jB2250hY1-012FWj; Tue, 07
 Apr 2020 18:02:16 +0200
Date:   Tue, 7 Apr 2020 17:02:13 +0100
From:   Alex Dewar <alex.dewar@gmx.co.uk>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Allison Randal <allison@lohutok.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Chaitra Basappa <chaitra.basappa@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Richard Fontana <rfontana@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, aacraid@microsemi.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Remove unnecessary calls to memset after
 dma_alloc_coherent
Message-ID: <20200407160213.qh64de6ebrj7qkmx@lenovo-laptop>
References: <e2401a31-e9fd-e849-e27c-6e079f5556d2@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e2401a31-e9fd-e849-e27c-6e079f5556d2@web.de>
X-Provags-ID: V03:K1:d/rbaoVneuFo0laPsfO0MaLfxIn2+jKJUs/i7ZOLORm+LfbBtQT
 ESuMc1oTz+fMZ0oStoWZwfeViYqrbeO1LXx1GGgpaEVPnqsXdzsBP1CCn5fNSGlUyZljOui
 I7fgj9QWPd7jJBqYvNLWXFsWvl2e2GA/b/izskTEJrxpVWWfI/dvT66HeAuXqJJEoWAwBWc
 jebJmfW9Kw6uZBru7hWMA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:U2Pjpg2Ki7w=:xq6163nCcOwVZqGtXA1HMf
 19/Gs5h+3UI36/aBiaBU1kuksy+wup06rLtbVmc5WwxmfLOYa99iZHzKR77kev6SwPaMOnf/5
 gyQJ2ZHoFnzVuAkgIB4AA0Ddz+Egx6RS7JGbLkoEmd6dDu1KnS5TAEDxko2eNMA/EojMz/Rq8
 nEBeKbpf0mtSuVqb5v3BM4IqKZ8IGWRUhSs7U9OYEXUS2TLPUWLZ6eGeT+J0WSJo8ZL4sEVYq
 lMmuzOXowBoWvVsv8G6jGuvzupEfa1iEb8CVK5FIXTcP+GmbLrqNKyoI2mFt9IFAbhjpPm92s
 JoWRcvh4wpQAeDq/0cs7PycSMpvvSVM1MxkylDZaeVr+8uBaqbhc9sAy8JlBlJeEAF+u1TDIJ
 YvZ7vttcV/EiFjAi1RSy4MM4WbTATmAS5TK2XvKM2kq3RzLJDaZQ9R9Ih5b6/ln83Gmun3Bwj
 w917gxTNOlglO8uETEOIRSydDoio5a0xWEZz7jELD/+xPPDP8lRqfl9Io/7f3Y3UhjksL+EMG
 Ear5+fdik64Jksxf89roRGribeIswgpWy3uRU4aeQL8rNqJZPRlxnoiGdaTDowt4zYG2v4v+X
 y8sxAZq1dRQWSQEjq1V0u5ckgIDkKlfJeivxKd/K2mWLlO0OCnCYyKcIBpHZI3BCDgyqTCRGw
 GviZQW73dh2jkjG/xyanglkDtGbqy4dYjOb8XFSZS9w+cN5tx7gkz5P4RvStdA63mfV9tiLhQ
 Ub5RUHfXr9E9bNmYwRSBdlF1PGkEkAY765SL3J4PFJqeKVs00z0SRSdL3AJPZg7YlUDIwrdMp
 M4/KAFkk50NkU/AmGF8ROcfm858qfZtYTaN6ZPqF1uSYXu2D6nOMKE3e3tiyTjfannSXer6hw
 ysT9Hwdl/g46QipspSaTNFAZUsW/P+8V4mjOdzi3vzx9wv82cHpJAaClCqHAZv4ZWJN338IFw
 Nkgspk0qtotriu5gwEaJsm6l1wZYIXQurHkHXl5qRWVtVrKDBHM5VkcrERXbDdVqPrlAqmPPm
 b4RsFafzc8NkynJrJhD60LW4E6cli01gC5F9gGfd6yeFGheimpNcUtqtoP8OAge2GnpH+ohne
 3R/CqDXTi26RVR9IzGv2uAsfSRWiYhY9yaitv/VIiqPai8vxdHCTK4BJ6YUkO3EQq/sz9/qfi
 +afwyyOiaN+FTiEEN/FgmPUa14e6fuJ08jHShjGl8Vmhflh8gMXL8/SXk01mM8856ZH1uP1v7
 YUw3hrs2eYKFne8Sc
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 04, 2020 at 01:14:52PM +0200, Markus Elfring wrote:
> > dma_alloc_coherent() now zeroes memory after allocation, so additional
> > calls to memset() afterwards are unnecessary. Remove them.
>
> I suggest to reconsider the distribution of recipients also for this pat=
ch
> according to the fields =E2=80=9CCc=E2=80=9D and =E2=80=9CTo=E2=80=9D.

Thanks. I'll do this in a v2/RESEND.
>
>
> =E2=80=A6
> > +++ b/drivers/scsi/dpt_i2o.c
> =E2=80=A6
> > @@ -3067,13 +3064,12 @@ static int adpt_i2o_build_sys_table(void)
> >  	sys_tbl_len =3D sizeof(struct i2o_sys_tbl) +	// Header + IOPs
> >  				(hba_count) * sizeof(struct i2o_sys_tbl_entry);
> >
> > -	sys_tbl =3D dma_alloc_coherent(&pHba->pDev->dev,
> > -				sys_tbl_len, &sys_tbl_pa, GFP_KERNEL);
> > +	sys_tbl =3D dma_alloc_coherent(&pHba->pDev->dev, sys_tbl_len,
> > +				     &sys_tbl_pa, GFP_KERNEL);
> >  	if (!sys_tbl) {
> =E2=80=A6
> > +++ b/drivers/scsi/mvsas/mv_init.c
> > @@ -244,28 +244,22 @@ static int mvs_alloc(struct mvs_info *mvi, struc=
t Scsi_Host *shost)
> =E2=80=A6
> > -	mvi->slot =3D dma_alloc_coherent(mvi->dev,
> > -				       sizeof(*mvi->slot) * slot_nr,
> > +	mvi->slot =3D dma_alloc_coherent(mvi->dev, sizeof(*mvi->slot) * slot=
_nr,
> >  				       &mvi->slot_dma, GFP_KERNEL);
> >  	if (!mvi->slot)
> =E2=80=A6
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -79,7 +79,7 @@ qla24xx_process_abts(struct scsi_qla_host *vha, void=
 *pkt)
> >  	    (uint8_t *)abts, sizeof(*abts));
> >
> >  	rsp_els =3D dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_els), &dm=
a,
> > -	    GFP_KERNEL);
> > +				     GFP_KERNEL);
> >  	if (!rsp_els) {
> =E2=80=A6
> > +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> > @@ -4887,15 +4887,13 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t=
 *vha)
> >  	    "Entered %s.\n", __func__);
> >
> >  	els_cmd_map =3D dma_alloc_coherent(&ha->pdev->dev, ELS_CMD_MAP_SIZE,
> > -	    &els_cmd_map_dma, GFP_KERNEL);
> > +					 &els_cmd_map_dma, GFP_KERNEL);
> >  	if (!els_cmd_map) {
> =E2=80=A6
>
> I find it safer to integrate such source code reformattings by
> another update step which will be separated from the proposed deletion
> of unwanted function calls.

Good point. This whitespace was autoformatted by Coccinelle, probably
due to my bad SmPL skills.

Best,
Alex


>
> Regards,
> Markus
