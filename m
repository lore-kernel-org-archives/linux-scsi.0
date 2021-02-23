Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70472C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1463764E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhBWIcZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:32:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54910 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhBWIcY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:32:24 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210223083140epoutp017cf4b463690bce83d8eee7bf6bbe058a~mU0uMlAvY0749507495epoutp01K
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 08:31:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210223083140epoutp017cf4b463690bce83d8eee7bf6bbe058a~mU0uMlAvY0749507495epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614069100;
        bh=1/pRHhEL8CQg0TPcJNwdiaN15d7s/a7wGGkcUD5R8S0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=gcmPm9UMxw5RxZHnq/Yd/B51/TtPyh9BEp9XvCwTl0TbaHdX5STvk9j3b+6auS8sR
         4jQkvUaVBpcGbS91HUahGNpeyMXx+gp4woMzxyI2RCK0Op1p4UG3XjGdMTnir3ynVq
         Xaw+4xWIORJ/fCyhHRHXaASLbpu/DSP7PSiVcqA0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210223083139epcas2p27eff981d92cf7612dcf7fab5a0d5d4c2~mU0tORoN52096620966epcas2p2O;
        Tue, 23 Feb 2021 08:31:39 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DlC2K2XGqz4x9QB; Tue, 23 Feb
        2021 08:31:37 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-e9-6034bd69b61a
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B9.B9.52511.96DB4306; Tue, 23 Feb 2021 17:31:37 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: RE: [PATCH v22 2/4] scsi: ufs: L2P map management for HPB
 read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210223080043epcms2p83f813841174ade50ef97481b3f4cdef7@epcms2p8>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223083136epcms2p89ada047f0da1fb700ace8b4e3e396697@epcms2p8>
Date:   Tue, 23 Feb 2021 17:31:36 +0900
X-CMS-MailID: 20210223083136epcms2p89ada047f0da1fb700ace8b4e3e396697
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmqW7mXpMEgwfL+C0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBF5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIybje1cVSsF2i
        4vr0TpYGxqfiXYycHBICJhIrdm1hAbGFBHYwShxvB7I5OHgFBCX+7hAGCQsLBErsa/rECFGi
        JLH+4ix2iLiexK2Ha8DibAI6EtNP3AeKc3GICKxgkfgzvwHMYRb4xSRx4vEHRohlvBIz2p+y
        QNjSEtuXbwWLcwr4Sdz7v4YdIq4h8WNZLzOELSpxc/Vbdhj7/bH5UHNEJFrvnYWqEZR48HM3
        VFxS4tjuD0wQdr3E1ju/GEGOkBDoYZQ4vPMWK0RCX+Jax0awI3gFfCXu/d4KNohFQFVi4aYf
        UMtcJDo2LQKLMwtoSyxb+JoZFCrMApoS63fpg5gSAsoSR26xwLzVsPE3OzqbWYBPouPwX7j4
        jnlPoE5Tk1j3cz3TBEblWYignoVk1yyEXQsYmVcxiqUWFOempxYbFZggR+4mRnBq1/LYwTj7
        7Qe9Q4xMHIyHGCU4mJVEeNnuGiUI8aYkVlalFuXHF5XmpBYfYjQF+nIis5Rocj4wu+SVxBua
        GpmZGViaWpiaGVkoifMWGTyIFxJITyxJzU5NLUgtgulj4uCUamAy99l1Mb74cGlvQTtPk+D/
        YkOdD79nWsv+WrdN8OEtiY0VXHoT2XZV7ek2f8I0U8Oz5PjdtO0bpkTXscvqpmlOfSuzQszm
        /HLu1K2PZzoeZv011Sdm4edNB15tXC55NlDe6Y3sat+VaQvNme7dyNWPOin+OeDljZ3aX8UF
        s7rZVq80E/wRlybr/Pbfj53mB1fw7osIXuu8Ub/wc3tHInu0RoJUzpV8R953tXuTDCSXa//6
        KOnxO+TuZ8Ez37guCB8K9gtfpHHbVN27TXwrz8dX7LOY+O47fd87q1aZo7v+gVpSvWXZdBUv
        9++GbXmnVpsV1puEuy/c2XVo+pPMMzf5Nzst+5zhYFF+N2S24hclluKMREMt5qLiRABy7lS3
        dgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <20210223080043epcms2p83f813841174ade50ef97481b3f4cdef7@epcms2p8>
        <DM6PR04MB657508BC3F0D0240FDCBB043FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=C2=A0+/*=0D=0A>=C2=A0>=C2=A0+=C2=A0*=C2=A0This=C2=A0function=C2=A0will=C2=
=A0parse=C2=A0recommended=C2=A0active=C2=A0subregion=C2=A0information=C2=A0=
in=0D=0A>=C2=A0>=C2=A0sense=0D=0A>=C2=A0>=C2=A0+=C2=A0*=C2=A0data=C2=A0fiel=
d=C2=A0of=C2=A0response=C2=A0UPIU=C2=A0with=C2=A0SAM_STAT_GOOD=C2=A0state.=
=0D=0A>=C2=A0>=C2=A0+=C2=A0*/=0D=0A>=C2=A0>=C2=A0+void=C2=A0ufshpb_rsp_upiu=
(struct=C2=A0ufs_hba=C2=A0*hba,=C2=A0struct=C2=A0ufshcd_lrb=C2=A0*lrbp)=0D=
=0A>=C2=A0>=C2=A0+=7B=0D=0A>=C2=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0struct=C2=A0ufshpb_lu=C2=A0*hpb;=0D=0A>=C2=A0>=C2=A0+=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct=C2=A0scsi_device=C2=A0*sdev;=0D=0A>=C2=
=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct=C2=A0utp_hpb_rs=
p=C2=A0*rsp_field=C2=A0=3D=C2=A0&lrbp->ucd_rsp_ptr->hr;=0D=0A>=C2=A0>=C2=A0=
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int=C2=A0data_seg_len;=0D=0A>=C2=
=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool=C2=A0found=C2=A0=
=3D=C2=A0false;=0D=0A>=C2=A0>=C2=A0+=0D=0A>=C2=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0__shost_for_each_device(sdev,=C2=A0hba->host)=C2=A0=
=7B=0D=0A>=C2=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hpb=C2=A0=3D=C2=A0ufshpb_get_hpb_dat=
a(sdev);=0D=0A>=C2=A0>=C2=A0+=0D=0A>=C2=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if=C2=A0(=
=21hpb)=0D=0A>=C2=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0continue;=0D=0A>=C2=A0>=C2=A0+=0D=0A>=C2=A0>=C2=A0+=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0if=C2=A0(rsp_field->lun=C2=A0=3D=3D=C2=A0hpb->lun)=C2=A0=7B=0D=0A>=
=C2=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0found=C2=A0=3D=C2=A0true;=0D=0A>=C2=A0>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0break;=0D=0A>=C2=A0This=C2=A0piece=
=C2=A0of=C2=A0code=C2=A0looks=C2=A0awkward,=C2=A0although=C2=A0it=C2=A0is=
=C2=A0probably=C2=A0working.=0D=0A>=C2=A0Why=C2=A0not=C2=A0just=C2=A0having=
=C2=A0a=C2=A0reference=C2=A0to=C2=A0the=C2=A0hpb=C2=A0luns,=C2=A0e.g.=C2=A0=
something=C2=A0like:=0D=0A>=C2=A0struct=C2=A0ufshpb_lu=C2=A0*hpb_luns=5B8=
=5D=C2=A0in=C2=A0struct=C2=A0ufs_hba.=0D=0A>=C2=A0Less=C2=A0elegant=C2=A0-=
=C2=A0but=C2=A0much=C2=A0more=C2=A0effective=C2=A0than=C2=A0iterating=C2=A0=
the=C2=A0scsi=C2=A0host=C2=A0on=C2=A0every=C2=A0completion=C2=A0interrupt.=
=0D=0A=0D=0AHow=20about=20checking=20(cmd->lun=20=3D=3D=20rsp->lun)=20befor=
e=20the=20iteration?=0D=0AMajor=20case=20will=20be=20have=20same=20lun.=20A=
nd,=20it=20is=20hard=20to=20add=20struct=20ufshpb_lu=20*hpb_luns=5B128=5D=
=0D=0Ain=20struct=20ufs_hba,=20because=20LUN=20can=20be=20upto=20127.=0D=0A=
=0D=0AThanks,=0D=0ADaejun
