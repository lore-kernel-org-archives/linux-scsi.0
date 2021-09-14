Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB05C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2E461151
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239423AbhINFOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 01:14:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17460 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239319AbhINFON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 01:14:13 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210914051255epoutp02804bdab33a91ebef41bd87c8cb1708c0~kmEI_F5Rh3224732247epoutp02M
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 05:12:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210914051255epoutp02804bdab33a91ebef41bd87c8cb1708c0~kmEI_F5Rh3224732247epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631596375;
        bh=JLuq6AO/ksQvXrLNL6IREO3MRAbg4xmAgIuiG+kBEVY=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=BHPPChJvWx/Ppd3HA63+vqg9oK9Orr/lsx5z6CIOHvfKupbzW3hYnVi19x/Vq1tj3
         0EWtNExEUFFmd0O52iv2YxuvkRrd/LxCvFlyXh05LWbkePcZwoCuXs0MzVySiVM8ed
         PYYs3Blq3JzfaKLOCQwJtbETQ+7pqAVX+7VVrepc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210914051248epcas2p35b4a42880a304db80e92f36b7997c675~kmECyqXyj2605426054epcas2p3x;
        Tue, 14 Sep 2021 05:12:48 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4H7s192tyhz4x9QX; Tue, 14 Sep
        2021 05:12:45 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.D1.09472.C4F20416; Tue, 14 Sep 2021 14:12:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210914051242epcas2p3f63bdaf828a4f376517111ef7af1a786~kmD9HR6Ao0381203812epcas2p3w;
        Tue, 14 Sep 2021 05:12:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210914051242epsmtrp1a411ce978d33a6b181ac2ce7591f404e~kmD9GaHxL1880618806epsmtrp1K;
        Tue, 14 Sep 2021 05:12:42 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-f1-61402f4c5c98
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.2D.08750.A4F20416; Tue, 14 Sep 2021 14:12:42 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210914051242epsmtip1fc4037ce5d4520028ae48515847e189b~kmD80cAu21693416934epsmtip1L;
        Tue, 14 Sep 2021 05:12:42 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
In-Reply-To: <baf17040-70e8-d850-30cd-74944e41285d@acm.org>
Subject: RE: [PATCH v2 3/3] scsi: ufs: ufs-exynos: implement exynos isr
Date:   Tue, 14 Sep 2021 14:12:41 +0900
Message-ID: <000001d7a927$252e77e0$6f8b67a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFyn/7MkbxYHt33UvraYb1f3WYrLgHrEvTlAh5z/LMCMoADnqw7Jm5w
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwTZxjfe3c9CqPu1uJ412VLd8RkuAEt2HKMj5CMwC3AZNmWZc6lHvQC
        zH6tVzacRsnAUkFAMLIJbmOA3bTEJsgYdloZoIiKLKITHWLdqJEiwiCmIELWW2vGf7/3eX8f
        z/N+CFHxFVwqLNabWZOe0ZJ4GNbdH62KyYlLZ+SjVjE1NNmBU+7vunFqauk6Tv12dx9GPTp6
        T0A1zi2h1LzDJqDsbW6Mah3rRqhR5xGcqr7Rg1M/Dq4iVNXtMUAdXZ3B0tfRo9ey6dHaGoRu
        Oz2F0AdaewHtc1hx+h/PLYyu7ToO6IXOV+jK3mokL3SLNqWIZTSsScbqCwyaYn1hKpn9nvot
        tVIlV8QokqhEUqZndGwqmZGTF5NZrPU3T8o+Z7Ql/lIew3FkXFqKyVBiZmVFBs6cSrJGjdao
        UBhjOUbHlegLYwsMujcVcnm80s/cpi1qaKzHjddh6cSNh6AMDEuqQKgQEpug93QlXgXChGKi
        B0B31SUssJgH8GLjSSSwWACw49xZwVPJk6sngywngO31NUH9fQAHV5ZDeBZOvA4b7/4q4Dci
        iAoUXjsz7/cSCkOJZHj+51ieIyGy4JH2RcBjjNgAfzpVhvBYRCTBBuuqIICfh0OHJzEeo35P
        2w/TaKALGVzy2AS8ZQSRCX1/aQKUCNi8z4LysZAYE8LznSshAX4GrKh2gACWQO9gV7AuhVN1
        liDeA12HygQB8X4APa7VoCABNt2rBHwYSkRDhzOOh5CIggO3gq2tg9Z+Poovi6DVIg4Io+Dj
        hoNBkxfh4ZvjwSQaOmpnwAHwatOaIZvWDNm0Zpqm/3NbAHYcvMAaOV0hy8UbN6297E7w38Pe
        SPeA5pm52D6ACEEfgEKUjBB1P0hlxCINs+NL1mRQm0q0LNcHlP5jr0el6wsM/p+hN6sVyniV
        Sp6kpJSqeIqMFI1MJzFiopAxs9tZ1sianuoQYai0DLmYKk0LG2FHdt4ZW9+SjMUtfkZMuLba
        vrLdyTXNvpErTtucnZN8bgeNS5N8D9rpBM+TLT1DCtc0smyzy+deXhw99uyG6Ga1/USU6DL6
        aevUn3JRv4CKDCnvzPs+Y78Aj7X/Xbcwxzpfm3Gpc1vyOzIqzvyRD+FHXyzVXLm9M+sxVVou
        GW9LIZYnfZLfL4wX7N6ju5CYf1k7Mcy660LD3ekxlXjmB+GWt+vvP5N4Yle2ipntGrBMYuw7
        dot978pmJOvqtynW8PcPPjo07RneVh45MXvpWNovK/mW50SnnGd3c19/uHXXS9/s9X7ycXmC
        96F1efuwt8VX7Sp9VwDI3psDJMYVMYqNqIlj/gUjYZRyYQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWy7bCSnK6XvkOiwdoOCYuTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1WL34AYvFohvbmCwu75rDZtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPBbvecnkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjijuGxSUnMyy1KL9O0SuDLWz1rNWnBZouLGoelMDYz7hbsYOTkkBEwk/lzazNLFyMUh
        JLCDUWLO36WsEAlJiRM7nzNC2MIS91uOsEIUPWOUOLj/MjtIgk1AW2Law91gCRGBKcwSd64d
        ZYOo6mSSaL/wBGguBwengLXEsa16IA3CAu4Sc5b8AJvKIqAqsWJnAxOIzStgKTGp4x8rhC0o
        cXImSCsnBzPQgqc3n8LZyxa+Zoa4SEHi59NlrCDjRQTcJL4/SoEoEZGY3dnGPIFRaBaSSbOQ
        TJqFZNIsJC0LGFlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEx6iW1g7GPas+6B1i
        ZOJgPMQowcGsJMK77Y1tohBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtS
        i2CyTBycUg1M/gu0uM8eSZrLnxS7Qmlu+QyfSTs2S1zddTDDxqvXOSoiZU329z9GCnXTdQP7
        GY8/f/nzY+l9biMJg3n7+WOmsuhxabGxri60j/meE/UrnqH8U87r/l9Ts05HCRSr8iUwPHr9
        cs/cjxf2XHjE/Ktm5VePJNbFEQLZ/2qX36ycytP06elhxiV7W3sOF4R+8Z1frV+dyb+9MeJ/
        YMUkYyftGr9Jpflx87ozN/0yzJt40YLzusNOhe2pG7h74xhf+upselrfM+Wj8+f6B8qR2x5X
        7Xhn8WzNa6F7Rx6wfI3k2xlh8FL/0WRhdZP0yPj3MV/iZNblreLLf6whvnnDJ/OW3K97DsTX
        t/9zk0tWj/JTYinOSDTUYi4qTgQA2kZgukADAAA=
X-CMS-MailID: 20210914051242epcas2p3f63bdaf828a4f376517111ef7af1a786
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210913081152epcas2p2eac4a8dbef33164a150dccf2e282dcce
References: <cover.1631519695.git.kwmad.kim@samsung.com>
        <CGME20210913081152epcas2p2eac4a8dbef33164a150dccf2e282dcce@epcas2p2.samsung.com>
        <746e059782953fca6c21945297151d2bb73d3370.1631519695.git.kwmad.kim@samsung.com>
        <baf17040-70e8-d850-30cd-74944e41285d@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 9/13/21 12:55 AM, Kiwoong Kim wrote:
> > This patch is to raise recovery in some abnormal conditions using an
> > vendor specific interrupt for some cases, such as a situation that
> > some contexts of a pending request in the host isn't the same with
> > those of its corresponding UPIUs if they should have been the same
> > exactly.
> >
> > The representative case is shown like below.
> > In the case, a broken UTRD entry, for internal coherent problem or
> > whatever, that had smaller value of PRDT length than expected was
> > transferred to the host.
> > So, the host raised an interrupt of transfer complete even if device
> > didn't finish its data transfer because the host sees a fetched
> > version of UTRD to determine if data tranfer is over or not. Then the
> > application level seemed to recogize this as a sort of corruption and
> > this symptom led to boot failure.
>=20
> How can a UTRD entry be broken? Does that perhaps indicate memory
> corruption at the host side? Working around host-side memory corruption i=
n
> a driver seems wrong to me. I think the root cause of the memory
> corruption should be fixed.

For SoC internal problems, yes, of course, they should be fixed.
But I don't think the causes always come from inside the system.
They could be outside the system or a device, such as sending DATA IN
with a tag that a host has ever submitted a command with because of
some bugs of the device. You might think putting this sort of code doesn't
make sense but there could be various events that can't be understood in th=
e
point of view of the spec. And chips that is already fab-outed can't be fix=
ed.
That's why I put the details into Exynos. I'm not talking about the spec.
I think Exynos isn't required to contain only things related with the spec
and it can have realistic part.

>=20
> > +static irqreturn_t exynos_ufs_isr(struct ufs_hba *hba) =7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	u32 status;
> > +	unsigned long flags;
> > +
> > +	if (=21hba->priv) return IRQ_HANDLED;
>=20
> Please verify patches with checkpatch before posting these on the linux-
> scsi mailing list. The above if-statement does not follow the Linux kerne=
l
> coding style.
>=20
> > +	if (status & RX_UPIU_HIT_ERROR) =7B
> > +		pr_err(=22%s: status: 0x%08x=5Cn=22, __func__, status);
> > +		hba->force_reset =3D true;
> > +		hba->force_requeue =3D true;
> > +		scsi_schedule_eh(hba->host);
> > +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +		return IRQ_HANDLED;
> > +	=7D
> > +	return IRQ_NONE;
> > +=7D
>=20
> So the above code unlocks the host_lock depending on whether or not statu=
s
> & RX_UPIU_HIT_ERROR is true? Yikes ...
>=20
> Additionally, in the above code I found the following pattern:
>=20
> 	unsigned long flags;
> 	=5B ... =5D
> 	spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
> Such code is ALWAYS wrong. The value of the 'flags' argument passed to
> spin_unlock_irqrestore() must come from spin_lock_irqsave().
>=20
> Bart.

I missed for two things. Thanks, I'll look more carefully.


