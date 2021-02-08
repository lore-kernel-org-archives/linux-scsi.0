Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67D9C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70CD464E7B
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBHIBn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 03:01:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40505 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbhBHIBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 03:01:37 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210208080054epoutp047221be11136fe1d09e7f8e89e24a4b02~htulKj8Kx2025320253epoutp04F
        for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2021 08:00:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210208080054epoutp047221be11136fe1d09e7f8e89e24a4b02~htulKj8Kx2025320253epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612771254;
        bh=x5fXNlNdEgT1If7XXO3RW7241IJFHZFp7BYgtJ7D/as=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Du9zoHP1YS2cCI3JBD1XT6z3cuhe1KBr81u+U3M0Uld02gN1EQEDeH77iv1r78Ldn
         j3zZcyYBFukBV15UD3vdn3wY9EgRZKzrPUakUMIJIHSl7Ph6Ae5MQLMaHOnddqWIlH
         rt0fRxbuqfgk3Pfoq7acNVkDkBfcWlR8Q7fkFuJg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210208080051epcas2p2b988ad1f28d0dbc7ed21c8809034cc83~htuiVQOEs2072820728epcas2p2q;
        Mon,  8 Feb 2021 08:00:51 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DYz3k26W7z4x9QC; Mon,  8 Feb
        2021 08:00:50 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-0f-6020efaea13f
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.87.10621.EAFE0206; Mon,  8 Feb 2021 17:00:46 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>, Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <527b4233f6118cf7e9d90eb726394d85fe1bb26d.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210208080044epcms2p227fafb59822b9430dae32dd2499b0d30@epcms2p2>
Date:   Mon, 08 Feb 2021 17:00:44 +0900
X-CMS-MailID: 20210208080044epcms2p227fafb59822b9430dae32dd2499b0d30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA52TfUxTVxjGd+7tF2QllwJ6wOiaiyMiUtpLi4cJBjNhNyGburkskRnalZsW
        gba5txCqxlXAKTCgukyQ8bGhyECUiXxUiYO0BN0HMRM2Z0EGA5LhKFSXMWBhGV1hmv25/355
        zvOe533PhwiXtAvDRJkGM8MaNNmkwJ/X5YxURV+bl6rlNtc2NF7XJUC3P7grRDNL3wuQc2RO
        iM57lnD0tO0yH804IlHL+Duo8GKbANUMWjFUVtEpQA0/dmFo6FaNAJU+sAtQ052/MDTS4Y8a
        Ox8CVFzZykMNn/XwkoLooeFUeqi8DKNvVj8S0raGPkD31rYK6aKvenn0k2kXjy7vaAH0b+1b
        6NN9pdh+/0NWkKBhtfrMPEbKGLTGjEyDLpF8+2BKNCKleiNnTiTTFIiSKeJVMmW8jNp5+BWF
        XE6pSKlBk8MkkvnRa9WklNWaVt1mhjOzjJZZldgkzqzRMTJOk8PlGnQyrTGHlOZpsnNX68iY
        3Ql6RpPBsFL1FNDbCjzAdP7F/JErywIraPYrAX4iSCjh4lwhvwT4iySEHcAvFyqFJUAkEhOB
        cMUe5PUEEalwubQA87KEIGHbd9VCny6DrolW4GUBsQNW3v1J6N0nmPDg8OtFN9+7gBP3MbhS
        v8cXJoZVp6d5Pt4Eu5s6gTfLj3gNnvwlzydvg4uXy3Afh8CHV9zCdZ4fqAc+DoanxgbXPIFw
        fKlnTQ+FAz0ezMfvw87RZeDtBxIfAui86eL7FmLgD2eu83wzvg5nnGavzCNehnOzjQKfZS8c
        tjZhvvZfgt3uGtxrx4lI2HYrxouQCIf9Lt76UNbrfwr/yzgRAM84V/7V7XVTa51FwGtLbZgN
        hFc/O+fq57Kqn2V9CvAWsIExcTk6hqNMiuevuR388+63J9vBR26PzAEwEXAAKMLJYPGB4i1q
        iThDYznKsMZ0Njeb4Rzg6OqUZ/GwEK1x9eMYzOmKODkVp4pVxsaqlKr/LauouDh5vAqp4ihE
        bhRz8vF0CaHTmJkshjEx7Ho4JvILs2K1oTc2FvWPUQWTfUp98ufTE4rRqFzxC1Jucm//7JOo
        swkdvdMk1XAvBdOBqsKJMVQ2Z9k0rv72wfDVrK6ti/kriQW6e8e7d3Syew4E7+x+i0/ZD14K
        o/0GHfHSCu0FTF1lOpJiCVk4fqyJDJh5fPv31CRRj4cqYzbXJBdeSrcMT4VThDuN3vXehiye
        7XCm0va47mqHW3Ly3P39TyO0H3Oj7ZPzmfhKeeQXkhMlf+xTU/x9gbULQ8oj9mNhI1tdjoxD
        AzeiTykrit74piV3bFdTQGnd5t2fvJvmHPA8ai68Y+nxSJqjphrPXZi1BYS3AEtyaPGbEfXD
        RurnExclr/5K8ji9RrEdZznN3zPvJynFBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5
References: <527b4233f6118cf7e9d90eb726394d85fe1bb26d.camel@gmail.com>
        <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
        <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
        <218be362c71a9cdb8312f6d8156a0935985aae04.camel@gmail.com>
        <DM6PR04MB65759D6418E8FCD4B0BD6236FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
        <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > >"If the requested field of the HPB Region or HPB Sub-Region is out
> > > of
> > > range, then the device shall terminate the command by sending
> > > RESPONSE
> > > UPIU with CHECK CONDITION status, with the SENSE KEY set to ILLEGAL
> > > REQUEST, and the additional sense code set to INVALID FIELD IN CDB"
> > 
> > You don't need to worry about setting invalid ppn to HPB-READ command
> > - 
> > you'll never get a read request for those LBAs.
> > 
> > Say all subregions are 16MB and the last subregion of the last region
> > is 10MB.
> > Keep all sizes the same - 16MB, and the ppn of the last subregion
> > contain some invalid data.
> > But you'll never get a read request for those LBAs anyway - they
> > don't exist,
> > so you'll never get to use those invalid ppns.
> > 
> > Thanks,
> > Avri
>  
> Hi Avri
> ah, I don't know if your above comments are inline with Spec.
>  
> Spec:
> "A HPB Region is divided into HPB Sub-Regions. HPB Sub-Region size is
> specified by the bHPBSubRegionSize parameter of Geometry Descriptor.
> HPB Sub-Regions are equally sized except for the last one which is
> smaller if the last HPB Region is not an interger multiple of
> bHPBSubRegionSize."
>  
> It is not invalidate ppn concern, it is illegal request issue in sense
> key.
>  
> Kind regards,
> Bean

That's a good point.
If the size of the last sub-region is not specified correctly, the map data
cannot be properly fetched. I will support the non-full sized last
sub-region in a new patch.

Thanks,
Daejun
