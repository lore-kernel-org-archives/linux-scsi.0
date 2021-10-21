Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BECEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 11:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BCAF611F2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 11:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhJULHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 07:07:02 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17606 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhJULHB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 07:07:01 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211021110442epoutp0152e4855d989f9da7b9468923e693613e~wBu2RCLrq0514505145epoutp01h
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 11:04:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211021110442epoutp0152e4855d989f9da7b9468923e693613e~wBu2RCLrq0514505145epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634814282;
        bh=OylDuFJYacN+0rDeUK+ui4oYqhJGAI0oFrOel9JwVQU=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=Dzs7D0qIAinMkTwto31e0UuWxYqAmJi3oCbfgE8lIlz9Iu6Ufl/7hURWlx39x6KrR
         Ia7G8JqcVVVGNLgPjHqqecXR9c7ryLKUqXWUlUngptQdQUxD+YJcbxmbBFrZopFrij
         uZd0vO4lBGh2wG3SNeQX6j3QxFegC3bGPoddTsvo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211021110440epcas2p16d184935a012927c1a8141824446070d~wBu1LgwVW1277612776epcas2p1g;
        Thu, 21 Oct 2021 11:04:40 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.91]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HZl452QZrz4x9Q3; Thu, 21 Oct
        2021 11:04:37 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.DD.10018.54941716; Thu, 21 Oct 2021 20:04:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211021110436epcas2p35864b1cca7205e91df56e3978961b63a~wBuxFMWMT2654126541epcas2p3I;
        Thu, 21 Oct 2021 11:04:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211021110436epsmtrp28a3ec5c3db535d070b92a93736376746~wBuxEisie1800418004epsmtrp2e;
        Thu, 21 Oct 2021 11:04:36 +0000 (GMT)
X-AuditID: b6c32a46-a25ff70000002722-61-617149453b74
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.DA.08738.44941716; Thu, 21 Oct 2021 20:04:36 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211021110436epsmtip13d282178989c9ee650bc40b89b0f249a~wBuw1rO7K2139521395epsmtip1a;
        Thu, 21 Oct 2021 11:04:36 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Adrian Hunter'" <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>, <vkumar.1997@samsung.com>
In-Reply-To: <2e35d23b-babb-a617-d93e-ce9b522dafb3@intel.com>
Subject: RE: [PATCH RESEND v2] scsi: ufs: clear doorbell for hibern8 errors
 when using ah8
Date:   Thu, 21 Oct 2021 20:04:35 +0900
Message-ID: <029e01d7c66b$6f6e7830$4e4b6890$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIPpLk+GfI6SjvCnzedxKlglX7R9QIy3PWBAkTuWMOrSctakA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJsWRmVeSWpSXmKPExsWy7bCmqa6rZ2Giwaad/BYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLy7vmsFl0X9/BZrH8+D8mi667Nxgt
        lv57y2Jx5/5HFgc+j8t9vUwei/e8ZPKYsOgAo8f39R1sHh+f3mLx6NuyitHj8yY5j/YD3UwB
        HFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAhysp
        lCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCswL9IoTc4tL89L18lJLrAwNDIxMgQoT
        sjMuv25gKnjOW9Fyfx9zA+Mr7i5GTg4JAROJm0/msXQxcnEICexglDiz5zQ7hPOJUeLm0/9Q
        mc+MEqeenWOEaXn0+SNU1S5GiX3f/rJBOC8YJe4tXs8CUsUmoC0x7eFuVpCEiEA7s8SVjWeB
        HA4OTgFbiTUzNEFqhAViJJb8aGUGsVkEVCUWn5oOZvMKWEqsvjsJyhaUODnzCdhMZqCZyxa+
        Zoa4QkHi59NlrCC2iICTxIRjT9ghakQkZne2MYPslRC4wiGx8NohqAYXiYlTlzJB2MISr45v
        YYewpSQ+v9vLBmHXS+yb2sAK0dzDKPF03z+on40lZj1rZwR5gFlAU2L9Ln0QU0JAWeLILajb
        +CQ6Dv9lhwjzSnS0CUE0Kkv8mjQZaoikxMybd6C2eki8+3iFcQKj4iwkX85C8uUsJN/MQti7
        gJFlFaNYakFxbnpqsVGBETy2k/NzNzGCE7WW2w7GKW8/6B1iZOJgPMQowcGsJMK7uyI/UYg3
        JbGyKrUoP76oNCe1+BCjKTDcJzJLiSbnA3NFXkm8oYmlgYmZmaG5kamBuZI4r6VodqKQQHpi
        SWp2ampBahFMHxMHp1QDU94rbWujrRw2W5dPfupxYiHXc0Odsu+LSk/Mv8V9a+GbDfVW/6v+
        R/CrrMhawl2xx9oj3zHt/RbBuGSPFZuiP5lGOfUtFlj494d2XdDy6Uvdzd+UhBh0J6yL1FmU
        zhw8247nYPsOrr3vDpeF1H2rO8/0rW2r27Q7op7VG/f4LLotx3F76QL5x4eahC2Ot67+vSNP
        +h8nR1iOwvvLsWFSno8kDF7w2k/nv2yzjEGv/Lf82aDX1bGyS3r3ZlamRp1OSZq3vLkw90VQ
        /CGV7ddzrM7PYC420jq7w7rxfvmJoNfRK9VX/XQ6HVK7aeu2uSkr87M0lVlvFSQf61pQyNYs
        /CaBUU+kauVrliW7Vk2pUWIpzkg01GIuKk4EADWHHINdBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSnK6LZ2GiQctSaYuTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1eLT+mWsFqsXP2CxWHRjG5PF5V1z2Cy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZbG4c/8jiwOfx+W+XiaPxXteMnlMWHSA0eP7+g42j49Pb7F49G1ZxejxeZOcR/uBbqYA
        jigum5TUnMyy1CJ9uwSujG3/FjIVrOWpWLLwKVMD4xPOLkZODgkBE4lHnz+ydzFycQgJ7GCU
        6N46lxUiISlxYudzRghbWOJ+yxFWiKJnjBK7Tt1iA0mwCWhLTHu4GywhIjCdWWLv3Y+MEFUn
        GSX2/tsGVMXBwSlgK7FmhiZIg7BAlMSKI61gU1kEVCUWn5rODGLzClhKrL47CcoWlDg58wkL
        iM0MtKD3IUQ9iL1s4WtmiIsUJH4+XQZ2qYiAk8SEY0/YIWpEJGZ3tjFPYBSahWTULCSjZiEZ
        NQtJywJGllWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHRqaW1g3HPqg96hxiZOBgP
        MUpwMCuJ8O6uyE8U4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJ
        g1Oqgckyt+v88xmTmXp+ushc2jV5/o8/zbqTNYNWtZ3K/tw09Tqn5rQz8mv+c9xRDf1xx2PH
        5RdhZ+1mXf60tWWKp1YHn8IBDg2Lt4rv/gmEGmj2RAWdOuwVoCLUNi3veLKA0Xq7t/MeXWo8
        +Ej+0YzfHz7oCPkpbS7xljDLdo0u9wnbpO2j6Hq8uu3/opfblwQdudYdVpcrMDWJOZM/+VO6
        YFakoUef2Z9L4lXpC3Z4tNoxzMo7L/fxnomKbsvH+9GBBut/CBQr+01fI7BjE0vsavfWL3qq
        ESd51lz41PRg44QFPGvqVl1tN32xSPZb9qY1G5jquratbD0a/YrJsP7U1HP7euoNl//6KvjS
        vXq5pIkSS3FGoqEWc1FxIgCDJRvIPQMAAA==
X-CMS-MailID: 20211021110436epcas2p35864b1cca7205e91df56e3978961b63a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83
References: <CGME20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83@epcas2p1.samsung.com>
        <1634619427-171880-1-git-send-email-kwmad.kim@samsung.com>
        <2e35d23b-babb-a617-d93e-ce9b522dafb3@intel.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 19/10/2021 07:57, Kiwoong Kim wrote:
> > Changes from v1:
> > * Change the time to requeue pended commands
> >
> > When an scsi command is dispatched right after host complete all the
> > pended requests and ufs driver tries to ring a doorbell, host might be
> > still during entering into hibern8.
> > If the hibern8 error occurrs during that period, the doorbell might
> > not be zero and clearing it should have done.
> > But, current ufshcd_err_handler goes directly to reset w/o clearing
> > the doorbell when the driver's link state is broken.
>=20
> So you mean HCE 1->0 does not clear the doorbell register?
>=20
> > This patch is to requeue pended commands after host reset.
>=20
> So you mean HCE 0->1 does clear the doorbell register?


I talked about this again and maybe he didn't seem to accept its descriptio=
n like that
Because he just focused on the term 'disable' in the description.
Instead, there is an vendor sfr to clear all the contexts.

Yes, the description contains like this, but I think he could think it's do=
ne when setting one.
--
When HCE is =E2=80=980=E2=80=99=20and=20software=20writes=20=E2=80=981=E2=
=80=99,=20the=20host=20=0D=0Acontroller=20hardware=20shall=20execute=20the=
=20step=202=20described=20in=207.1.1=20of=20this=20standard,=20=0D=0Ainclud=
ing=20>>>>>=20reset=20<<<<<=20of=20the=20host=20UTP=20and=20UIC=20layers.=
=0D=0A=0D=0AOf=20course,=20some=20statements,=20such=20as=208.2.2.=20UIC=20=
Error=20Handling,=20seems=20to=20show=20setting=20zero=20means=20clearing.=
=0D=0ABut=20speaking=20the=20description,=20it's=20not=20quite=20clear=20to=
=20me.=0D=0A=0D=0AAnyway,=20let=20me=20know=20how=20to=20deal=20with=20this=
.=0D=0A=0D=0AThanks.=0D=0AKiwoong=20Kim=0D=0A=0D=0A
