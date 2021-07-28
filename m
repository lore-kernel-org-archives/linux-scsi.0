Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413EDC4320A
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 01:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD7D60F9D
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 01:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbhG1Bjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 21:39:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64099 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbhG1Bjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 21:39:39 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210728013936epoutp0325e9b77798650fc309c524579407d0f4~V0MMNNNpL1639116391epoutp03C
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2021 01:39:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210728013936epoutp0325e9b77798650fc309c524579407d0f4~V0MMNNNpL1639116391epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627436376;
        bh=sAwkRwmL3WZzg47uaC9Kv1orORi3aiDnpRqA4R1kCkk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Zdik7sveSAwhuvroaHD5oHq5sWjelq7rJIqHW5f1mdr+BNVz1fm7D4MF69kYAb594
         O63K/ndLUev9jhwMWabuWu9csgY9KbQ6PzEjtNIGOzONC+68qwPNPoyMQLiPK5xctW
         i03ELKfuQNaZfna/5VgEWeNkIgp+RZoXFktWDGdM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210728013935epcas2p1d11dc975dcf2e38575e7147b3320b6be~V0MLptpiX1005410054epcas2p1g;
        Wed, 28 Jul 2021 01:39:35 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.184]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GZGYJ6hmCz4x9Pv; Wed, 28 Jul
        2021 01:39:32 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.78.09541.455B0016; Wed, 28 Jul 2021 10:39:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210728013931epcas2p3a09c382f461dd54036241dfd5d6fbb1e~V0MHzsDbc0070600706epcas2p3d;
        Wed, 28 Jul 2021 01:39:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210728013931epsmtrp211230ba6ddaa17183dc6cb3962252278~V0MHysZxS2394623946epsmtrp2d;
        Wed, 28 Jul 2021 01:39:31 +0000 (GMT)
X-AuditID: b6c32a46-0abff70000002545-25-6100b554972e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.47.08289.355B0016; Wed, 28 Jul 2021 10:39:31 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210728013931epsmtip2022d672bf0a952ade8d272992f4b2618~V0MHmqNwR2415724157epsmtip22;
        Wed, 28 Jul 2021 01:39:31 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <8af01dbdfbecf2aa2f35e8c3a5240b2bcf76d9b0.camel@gmail.com>
Subject: RE: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
Date:   Wed, 28 Jul 2021 10:39:31 +0900
Message-ID: <002e01d78351$6996d040$3cc470c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQJIF3zu3g+/Awptn47LJA2vs45sGwKSU/P/Ail7aZYBcufzmAMJoF0fATgHUhcCQpyeqAKzJthXqftAlxA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJsWRmVeSWpSXmKPExsWy7bCmmW7IVoZEg/65lhYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVouenc4WpycsYrKYc7aByeLJ+lnMFotubGOyWHnNwuL8+Q3sFje3
        HGWxmHF+H5NF9/UdbBbLj/9jchDwuHzF2+NyXy+Tx85Zd9k9Nq/Q8li85yWTx6ZVnWweExYd
        YPT4+PQWi0ffllWMHp83yXm0H+hmCuCOyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1
        tLQwV1LIS8xNtVVy8QnQdcvMAfpGSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNg
        aFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk/F7+h32gn/cFY+7LrI1MB7k7GLk5JAQMJG48fMV
        excjF4eQwA5GiReTt7OBJIQEPjFKnN9XBpH4zCjx/NpBFpiO138OMkIkdjFK7H25ngXCecEo
        8e3/GrAqNgF9iZcd21hBbBGQRP9iUZAiZoETzBILf01hBklwCrhL3FrzggnEFhaIk7i8fBsj
        iM0ioCoxbcJMsDivgKXE2xcrGSFsQYmTM5+ALWAW0JZYtvA1M8RJChI/ny5jhYiLSMzubGOG
        WJwk0TF5CxvIYgmB/xwSO/7uZ4RocJE439PFBGELS7w6voUdwpaS+PxuL1RDN6NE66P/UInV
        jBKdjT4Qtr3Er+lbgLZxAG3TlFi/Sx/ElBBQljhyC+o2PomOw3/ZIcK8Eh1tQhCN6hIHtk+H
        hqKsRPecz6wTGJVmIflsFpLPZiH5ZhbCrgWMLKsYxVILinPTU4uNCoyQY3sTIzipa7ntYJzy
        9oPeIUYmDsZDjBIczEoivK9//E8Q4k1JrKxKLcqPLyrNSS0+xGgKDOuJzFKiyfnAvJJXEm9o
        amRmZmBpamFqZmShJM6rEfc1QUggPbEkNTs1tSC1CKaPiYNTqoHp5K6/b41ru/bYCnUcWmFq
        Wvz6uLWZ5A6PaXIuZ7asur/g3arYFSLWzRm8pYI7/TomXpjJWciqMGH90x/xS+6E/ot8lC5e
        KKKT6+A7t0vivdC1fd9fPvxzhJFR1ldBVJulIY//PJ+ffJmNGuNeV9mFotvK+CNecTs9+2jH
        9Mpqg1Z9Na/O8VlGv5ZIuyfr/ZJk+7U0Zq3zTwNJi/la9utTPhQZ3bCKtWM9tuBKSKbmJF0Z
        944D02v6tFfPmTLl75dJ36bO2PR8Dz9Dg+DEBPeAJ2dOCczlUk9nrD4t5ODdentKfVXLtSCJ
        c9NLdrgJhh+L+ZRqdj1Nfp+6cf7vo3KPBfkTIg99Whs30Vw/rFGJpTgj0VCLuag4EQBHJxgv
        cwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSvG7wVoZEgwc3jS1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBY9O50tTk9YxGQx52wDk8WT9bOYLRbd2MZksfKahcX58xvYLW5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8flvl4mj52z7rJ7bF6h5bF4z0smj02rOtk8Jiw6
        wOjx8ektFo++LasYPT5vkvNoP9DNFMAdxWWTkpqTWZZapG+XwJXxYck51oKn3BVnb/1lamBc
        xNnFyMkhIWAi8frPQcYuRi4OIYEdjBKL715khEjISjx7t4MdwhaWuN9yhBWi6BmjxKtHV1hB
        EmwC+hIvO7aBJUQEXjFKnLjazgbiMAtcYJa4/v8nG0TLZWaJ1kW7wFo4Bdwlbq15wQRiCwvE
        SBzbsAFsH4uAqsS0CTPB4rwClhJvX6xkhLAFJU7OfMICYjMLaEv0PmxlhLGXLXzNDHGfgsTP
        p8tYIeIiErM728DiIgJJEh2Tt7BNYBSehWTULCSjZiEZNQtJ+wJGllWMkqkFxbnpucWGBUZ5
        qeV6xYm5xaV56XrJ+bmbGMExrqW1g3HPqg96hxiZOBgPMUpwMCuJ8L7+8T9BiDclsbIqtSg/
        vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqbzk2bfiXc99Vlr6ZrF/3Zs
        sIhvPCh3gPPL5PnvWdxZLbS8i6RWLn3Fsr/VW4PDXI3Hu/GJ2WahfUdqig0/ze+uyZT9urCG
        jztX9OakW7MXpfkrzchv6/awW+jYE2Xowf9mfbjfihvdG913VSys/9+cwFDWyvnJxr1/V/xD
        8y0xXz6l2ofoS1a7vvoRtS4lb6G98+Yu1j3Rkkp7vLXShCt2cJ+R5i+VqTuh1R9VYMT9zSuF
        U6Oo9qxg1tJ1bz1yGRVkVOz9drzq13VNFNx1TnrT70l9NwsZwn71Zj/2qv1hrPbHnz1/6vcI
        RlffHLllHy3bmLc5RnvU3/uwxv1zQ6XX2SqGQ/8uLP/in35eiaU4I9FQi7moOBEATOoCiWAD
        AAA=
X-CMS-MailID: 20210728013931epcas2p3a09c382f461dd54036241dfd5d6fbb1e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
        <20210714071131.101204-15-chanho61.park@samsung.com>
        <2b4f4e6d76cdc517843fe8880312541c754d5352.camel@gmail.com>
        <000601d7820a$9aa11210$cfe33630$@samsung.com>
        <602ee8bc56891f0f0429afe274d7174ec325172e.camel@gmail.com>
        <004601d782d0$2f43cd20$8dcb6760$@samsung.com>
        <8af01dbdfbecf2aa2f35e8c3a5240b2bcf76d9b0.camel@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > so you split the =22Task Tag=22 filed byte3 in the UPIU header to two
> > > parts, bit7=7Ebit5 is for the VHs ID, and bit4=7Ebit0 is for the task
> > > ID.
> > > but this is not defined in the Spec 2.1. correct?
> >
> >
> > You're right.
> >
> > For PH, TASK_TAG=5B7:5=5D will be set to =220=22 but a VHID will be use=
d in
> > case of VH.
> >
> >
> >
> > Best Regards,
> >
> > Chanho Park
>=20
> Hi Chanho Park,
> Thansk for yoru reply.
>=20
> I didn't see your changes about task_tag and IID. Having a look at
> ufshcd_prepare_utp_scsi_cmd_upiu(), the task tag in the UPIU header is
> still only task tag. and IID is always 0x00.
>=20
> If you didn't add these changes, your patch is un-readable, and also the
> driver doesn't have a real usage case.

I already replied regarding this in another mail thread and please refer be=
low comments. The controller will handle the tag translation.
https://lore.kernel.org/linux-scsi/002901d782c6=24937ac0f0=24ba7042d0=24=40=
samsung.com/

> Also, you mentioned there is no support/change needed from the UFS device
> side. But, IMO, if you changed the UPIU header, there are changes needed
> on the UFS device side in order to use your driver.

Please see the figure=5B1=5D. Once IID_IN_TASKTAG bit is set, the function =
arbiter will translate the value of UPIU header before delivering it to the=
 device.

=5B1=5D: https://lore.kernel.org/linux-scsi/20210714071131.101204-1-chanho6=
1.park=40samsung.com/

Best Regards,
Chanho Park

