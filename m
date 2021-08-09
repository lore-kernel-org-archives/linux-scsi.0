Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E57C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 07:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FA8161055
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 07:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhHIHcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:32:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23907 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbhHIHcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 03:32:17 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210809073156epoutp02eb50ad9f493d35537ffa03e14fbaeca6~ZkvPJwTNO0666706667epoutp02B
        for <linux-scsi@vger.kernel.org>; Mon,  9 Aug 2021 07:31:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210809073156epoutp02eb50ad9f493d35537ffa03e14fbaeca6~ZkvPJwTNO0666706667epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628494316;
        bh=Ni+vbYmYtsLjALT/dARSA0tEqs6RJHXkVr/cpyYw+uI=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=XR4xC/4fsVn4bc+60T7h9OnXwLtuuDwDT5tE7LiL+Tr1yrm9jMQi9TFOF42ZNMi4M
         +O0bDkXiz4ysvqvt16NTwdsD6zINwIUYj2d4IVkDDqR2ZT/UE6/+kA8MKfFL6k7J1J
         nfXHtuDgQw22t93goGhFeSgJZ9MGUUd2ryCqnB6c=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210809073155epcas2p4f63c2921fee1b062da0d82f473c6f919~ZkvOOJvLi2661526615epcas2p4z;
        Mon,  9 Aug 2021 07:31:55 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GjnpJ1VXYz4x9Q3; Mon,  9 Aug
        2021 07:31:52 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        87.09.09571.8E9D0116; Mon,  9 Aug 2021 16:31:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210809073151epcas2p350bf7f9495d0eda078d8c10d4325f974~ZkvK8RvXx2005620056epcas2p3l;
        Mon,  9 Aug 2021 07:31:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210809073151epsmtrp183744a39c26d9e8acb931a6724f72bd7~ZkvK7bh4l3083630836epsmtrp1Z;
        Mon,  9 Aug 2021 07:31:51 +0000 (GMT)
X-AuditID: b6c32a48-1f5ff70000002563-e4-6110d9e862b9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.7E.32548.7E9D0116; Mon,  9 Aug 2021 16:31:51 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210809073151epsmtip291014da2bb6b9675097758ecc12dc846~ZkvKt2m1P2001120011epsmtip2M;
        Mon,  9 Aug 2021 07:31:51 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
In-Reply-To: <597a96f4-9cd4-c1bb-5c8d-dd5d00f0948d@acm.org>
Subject: RE: [RFC PATCH v1 2/2] scsi: ufs: ufs-exynos: implement exynos isr
Date:   Mon, 9 Aug 2021 16:31:50 +0900
Message-ID: <000001d78cf0$9eb0de30$dc129a90$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQK++sB58EgqqX1myvhKfEGyIJx4UQGqY/R1AYfJCd0DJFp0aalpLYyQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmqe6LmwKJBq13WSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zVYvXiBywWi25sY7K4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCMyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk3Fr3SeWgn6JilV/57I1MB4Q6mLk5JAQMJFY9PQKSxcjF4eQwA5GiYcbPzFCOJ8Y
        JSb+3cgE4XxmlHg/ZwZbFyMHWMvDS7kQ8V2MEhe3nIZqf8EosffnGRaQuWwC2hLTHu5mBUmI
        CLQwS1zZ+4kJJMEpYC3R+WwmK4gtLOAt8fnXdzCbRUBFom3VUkYQm1fAUuL67LOsELagxMmZ
        T8CGMgMNXbbwNTPE4QoSP58uA6sREXCT2LBnPhNEjYjE7M42ZpDFEgJXOCSm9Exjg2hwkXjd
        vJIVwhaWeHV8CzuELSXxsr8Nyq6X2De1gRWiuYdR4um+f4wQCWOJWc/aGUH+ZxbQlFi/Sx8S
        FMoSR25B3cYn0XH4LztEmFeiow0avsoSvyZNhhoiKTHz5h2oEg+JY7e9JjAqzkLy5CwkT85C
        8swshLULGFlWMYqlFhTnpqcWGxWYIEf2JkZwwtby2ME4++0HvUOMTByMhxglOJiVRHjXz+BL
        FOJNSaysSi3Kjy8qzUktPsRoCgz2icxSosn5wJyRVxJvaGpkZmZgaWphamZkoSTOqxH3NUFI
        ID2xJDU7NbUgtQimj4mDU6qBaZ/ouRMPtjW5dUb67PFeo6EhWb9s8avPpnJvnnf7CX66I9Zi
        e/Dp6jM1AZoJTpdcGaylX4iczntgk2S8eJffsXyWC7ubf+yYK8OrrvRp4nLj4oLErIMTvrnk
        ek3JEnjHqXBqU9SZaNGJL8Ui5y/lLs+VMrvsp7X07uwDlybmLz2lvEl9wf7b6hvsD85K7jdK
        zL7ROI/zs1tu85+2J4+eTTTnssg+F8Zrs22a9AyxRb/+HXPhrNL1vmH8bOvUBzdZgn6ahs+X
        mn3g4dy1C0z9P6/7PXn55jUfFEL9f73O2yVapxT3M/S7rWCA3iWRawb91/XmCforSx0z4gt+
        VxUWuzKu7lGa+1bWg2zVD5cFZyuxFGckGmoxFxUnAgC9NzjeYQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvO7zmwKJBh3LxC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zVYvXiBywWi25sY7K4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mp4NruNreCPeMWb53vYGhgXC3UxcnBICJhIPLyU28XIxSEk
        sINR4uDuz2xdjJxAcUmJEzufM0LYwhL3W46wQhQ9Y5RY9/8+WIJNQFti2sPdYAkRgSnMEneu
        HWWDqOpkktg1ezdYFaeAtUTns5msILawgLfE51/fwWwWARWJtlVLwWp4BSwlrs8+ywphC0qc
        nPmEBcRmBtrw9OZTOHvZwtfMECcpSPx8ugysXkTATWLDnvlMEDUiErM725gnMArNQjJqFpJR
        s5CMmoWkZQEjyypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOAo1dLawbhn1Qe9Q4xM
        HIyHGCU4mJVEeNfP4EsU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoR
        TJaJg1OqgenCREW3/dutnFsq3i5i5d7oOMM1YN355VZ84d+dsvo5QuXcFd+sUmrhT40TXXSr
        zk02zNV2mesHK6E/da8F1muuX/c01UHP9F7Vnbt26wouM7fvYo58NLXBifsm/4VzJ0MFFrvW
        zT5XmNVS8rxXcc737FSH9LaAEy49L0091yR0Ht8sOlf5Q3TTlbVxtXc/qd+cKNOptefmz52C
        55Otpt+OshHhz7fcu3HXJuWDMim5bkt9UxaZvJu8ZKtP1BkVwytplzizy2I8brQXMrXs012q
        dnAhz8RHEXdWenvUM8Uw3/ua/qnt8Q8vti9zHHkZWdXtZ4RtfbOj4caVElaf7S9ne8oFckau
        3vO8ZeKZR0osxRmJhlrMRcWJAPOfkQlBAwAA
X-CMS-MailID: 20210809073151epcas2p350bf7f9495d0eda078d8c10d4325f974
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210806064925epcas2p2ba7e711758614384c17648d4924d025c
References: <cover.1628231581.git.kwmad.kim@samsung.com>
        <CGME20210806064925epcas2p2ba7e711758614384c17648d4924d025c@epcas2p2.samsung.com>
        <7d2030d91425a01f964f7a9309c1aa3a0ce6a2d6.1628231581.git.kwmad.kim@samsung.com>
        <597a96f4-9cd4-c1bb-5c8d-dd5d00f0948d@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 8/5/21 11:34 PM, Kiwoong Kim wrote:
> > Based on some events in the real world
>=20
> Which events? Please clarify.
>=20
> > I implement
> > this to block the host's working in some abnormal conditions using an
> > vendor specific interrupt for cases that some contexts of a pending
> > request in the host isn't the same with those of its corresponding
> > UPIUs if they should have been the same exactly.
>=20
> The entire patch description sounds very vague to me. Please make the
> description more clear.

I'll describe a bit clearer in the next version.

>=20
> > +enum exynos_ufs_vs_interrupt =7B
> > +	/*
> > +	 * This occurs when information of a pending request isn't
> > +	 * the same with incoming UPIU for the request. For example,
> > +	 * if UFS driver rings with task tag =231, subsequential UPIUs
> > +	 * for this must have one as the value of task tag. But if
> > +	 * it's corrutped until the host receives it or incoming UPIUs
> > +	 * has an unexpected value for task tag, this raises.
> > +	 */
> > +	RX_UPIU_HIT_ERROR	=3D 1 << 19,
> > +=7D;
>=20
> The above description needs to be improved. If a request is submitted wit=
h
> task tag one, only one UPIU can have that task tag instead of all
> subsequent UPIUs.

Thank you for your opinion. In an ideal situation where there is no negativ=
e impact
from outside the host, yes, you're right, but in the real world, it could b=
e not.
Let me give you one representative example.
There has been some events that a host has one as tag number of a pending r=
equest
that should have been originally two, or a device sends a UPIU with two of =
tag number even
when a host has one as tag number of its corresponding request.
I remember that the first case occurred because of integrity problems
from such as lack of voltage margin of a specific power domain or whatever
and the second case did because of malfunctions of the device.
If those events are temporary, it might not raise some errors.
That means delivering wrong data to file system could be also possible
even if they're rare, and its consequences would be unpredictable, I think.

Speaking the point of view of UFS specifications, yes, those events should
not happen. Now I'm just trying to make the driver fit with the real situat=
ions,
especially for cases with abnormal conditions.
In this case, my choice is to block the host's operations and
these situations could be architecture-specific.

>=20
> >   	hci_writel(ufs, UFS_SW_RST_MASK, HCI_SW_RST);
> > -
> >   	do =7B
> >   		if (=21(hci_readl(ufs, HCI_SW_RST) & UFS_SW_RST_MASK))
> > -			goto out;
> > +			return 0;
> >   	=7D while (time_before(jiffies, timeout));
>=20
> Since the above loop is a busy-waiting loop, please insert an msleep() or
> cpu_relax() call.
>=20
> > +	 * some unexpected events could happen, such as tranferring
>                                                          =5E=5E=5E=5E=5E=
=5E=5E=5E=5E=5E=5E Please fix the
> spelling of this word.

Got it.
>=20
> Thanks,
>=20
> Bart.

