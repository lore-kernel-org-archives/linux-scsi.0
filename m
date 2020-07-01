Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38BDC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 01:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873CF20771
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 01:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lxxAHOGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgGAByl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 21:54:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23882 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgGAByk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 21:54:40 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200701015438epoutp01f9849bee88dd14030f0943ea341dc541~dfhaFtqGg0968609686epoutp01F
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2020 01:54:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200701015438epoutp01f9849bee88dd14030f0943ea341dc541~dfhaFtqGg0968609686epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593568478;
        bh=HSFXc5NsTiYx/x2TJi2WwJAEYqQ03H5gseKaIrQqutY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=lxxAHOGmDzE+8vHFXsVARzVqUvdHrgBD+uzbwNAf3AD0kW6VaRxCJRzyL4Qcvfc9m
         U/+kRrGcod4FJsU7iDHest+1wpUJAB0YuZF5qRQevPzkxvRmXx0oEBYa/G1u/PLW9C
         cM+rgI0p7UcIfzSisqqZARPCG7dYk0id8S9Lv3Qo=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200701015437epcas5p2e18b6a25d047ba4b9540f43c6b02b72f~dfhZV_Kdh0504905049epcas5p2C;
        Wed,  1 Jul 2020 01:54:37 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.19.09475.DDCEBFE5; Wed,  1 Jul 2020 10:54:37 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200701015436epcas5p12bd2e29f2dfe5d1d58cb55b0b296310b~dfhYPOgMQ2877228772epcas5p1S;
        Wed,  1 Jul 2020 01:54:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200701015436epsmtrp1d965abf22a8f6982696c0f07ee34ca72~dfhYOM3KY1047110471epsmtrp1T;
        Wed,  1 Jul 2020 01:54:36 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-e8-5efbecdd2be3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.5E.08382.CDCEBFE5; Wed,  1 Jul 2020 10:54:36 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200701015432epsmtip1142596cc40216e07f49eac33aa2685ea~dfhUQFAsX0279002790epsmtip1g;
        Wed,  1 Jul 2020 01:54:31 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <daejun7.park@samsung.com>,
        "'Bean Huo'" <huobean@gmail.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <asutoshd@codeaurora.org>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Sang-yoon Oh'" <sangyoon.oh@samsung.com>,
        "'Sung-Jun Park'" <sungjun07.park@samsung.com>,
        "'yongmyung lee'" <ymhungry.lee@samsung.com>,
        "'Jinyoung CHOI'" <j-young.choi@samsung.com>,
        "'Adel Choi'" <adel.choi@samsung.com>,
        "'BoRam Shin'" <boram.shin@samsung.com>
In-Reply-To: <SN6PR04MB46409E7CE538F158387615A6FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Date:   Wed, 1 Jul 2020 07:24:30 +0530
Message-ID: <003b01d64f4a$92817460$b7845d20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIDTAvkgzSw0VCcpiFA1doNNzUbzAGL0gCDAZ3Zu2wBd19psQGQGcjWAYu7ZjYBbUIaOKhOqkRw
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxjGc+69bW+blV0qiS81A+2cBlREGcs1bHMz/nGjcXHJNpgbuAJ3
        SPiQtMKqIUunjK/SFpcorulmKWtZKljnwNVqtYVNVubHEihssgKBEixfVjGsrNMs7cWM/573
        nN9znvdJDolLZnlSsrj8GKsol5fK+CLiSm/K5m3+uUheumtGSv/gn+HRrtpfBXRw2cene0cW
        BPTZ0DJOP7ZbebRtPJs23lFjtFbfzafNf1zB6AGnkU9rhh18ur3vGUY3B78jaEv3n4huaOkg
        6FDT57S59RrxloQZGNzPDOi0GHPV4BcwbdeDGNNsdiOmxnuTYB5N3ScYXZcNMYuXk5g6twY7
        KDoker2QLS2uYhXb3/xEdGTsaj+/wr5epR18Q43ciY1ISAL1KjTPm/iNSERKqGsIXK42nBse
        I5h/6MCjlIRaQmAIK547JvzXBRzkQuBp+BnjhjkEC2d8RJTiU9vA0VYbezeBMmMQud0ZG3Dq
        dwxG/x7hNSKSFFK5MDgaFzWsod4Fjd6LopqgNsLS955YtJjaBdbR4IqOB+/XgVgATm0Ba+ss
        zq20HpanrLyoTqAOQehC9wqzFn5Zbor1AapOCO4Hdj5n2Au64ZsEp9fATF+XgNNSCOprBdHd
        gCqBJmcGd1wNlm9vreC7wT1oJKIITqWA3bmdi4oDbSSAcU4x1NdKOPoVOLXgW3Gug9MaDY/T
        DAxFPLxmtMGwqphhVTHDqgKG/8NMiLChRLZCWVbEKjMrMsrZz9KU8jJlZXlRWsHRssso9h9T
        9zvQxHgorQdhJOpBQOKyBPFv6f/kScSF8uMnWMXRw4rKUlbZg9aRhGytWBa+nSehiuTH2BKW
        rWAVz28xUihVYwfu507rZj/9YM5+6cKPMof8Zdm9J19ZnefHLt4iSuczaurTPwx+mb+vXfDa
        S/1oU+V7iyTer18KPdv102Z0wtUJI3R8U4H4IdGw82nrk/w9J7NEmdM+8tSOwvP+4zcsw8nj
        OrLFrpRWb5UEtH36qblH5Kh3j7/knunMX/KcSa8JmT0t1TMjtshTi3rfAnm6IBDGU0He8fGL
        iW//ezizb3Ly3JI6J+eFoXdUW943WmAxHBewnbubP3HJc5CCXNVHxVt3+pqrjNaNwm+Sd3d0
        fSHrnY6cVHWmPKirCY/trc+2V92FpA1nh6ZU7ePZm7KcNRdNSbkTzI0scfyBO3iyjFAeke9I
        xRVK+X8SEvXS/gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWy7bCSnO6dN7/jDA6v4bbYePcVq8XethPs
        Fi9/XmWzOHz7HbvFtA8/mS0+rV/GarHqQbjFnLMNTBa9/VvZLBbd2MZkcXnXHDaL7us72CyW
        H//HZDHh5RIWi6VbbzJadE5fw2LxoafOYtHC3SwOQh6Xr3h7XO7rZfLYOesuu8fiPS+ZPCYs
        OsDo0XJyP4vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfG1YmrmQqmKVS8
        bDzJ1sA4U7KLkZNDQsBE4tHdPexdjFwcQgK7GSVmbO1kgkhIS1zfOIEdwhaWWPnvOVTRK0aJ
        vR+72EASbAK6EjsWt7GBJEQE1jBJzJ3zlxHEYRa4xiTx5+NnNoiWjcwSn+ZvB8pwcHAKxEpc
        uccH0i0s4C/xd8YdZhCbRUBF4tuKg2A2r4ClxLJ7L6FsQYmTM5+wgNjMAtoST28+hbOXLXzN
        DHGegsTPp8tYQWwRgSiJD6u3QtWISxz92cM8gVF4FpJRs5CMmoVk1CwkLQsYWVYxSqYWFOem
        5xYbFhjmpZbrFSfmFpfmpesl5+duYgRHu5bmDsbtqz7oHWJk4mA8xCjBwawkwnva4FecEG9K
        YmVValF+fFFpTmrxIUZpDhYlcd4bhQvjhATSE0tSs1NTC1KLYLJMHJxSDUzaHGWHVrLduXdl
        3dECc3+jV7pLFFSsf+Q8nFz79a+Vtslfx7iuj2dXxCdYsAVaL1WSvvidf70in7vAJw35pwyB
        7F8+HilcdWHlwupZE+dyqrJv8ldbtG8DvxDLlXkVX65oOAbztBofZvBpmfy5dfuWJKMdO+OV
        v4s+fBf7LVRfb1P9gdgV3t5/y+5lVC5juz2jxeF/x6YT1+NDjYXcWSV4WC9JFV6O1gvlF8t5
        dP/3852PHJv28nGUrCsvzvQIuV36Z1OVfCO3UI1EZBorw/vnYsm/2rbv++q3NHstU3yK5hS+
        wl1vNfy+hR5i++t+eXtzsqbf3GOZJVZLW35Hr1sbzl/6pTHkqk97o8qOr0osxRmJhlrMRcWJ
        AP/TotdlAwAA
X-CMS-MailID: 20200701015436epcas5p12bd2e29f2dfe5d1d58cb55b0b296310b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200623010201epcms2p11aebdf1fbc719b409968cba997507114
References: <60647cf00d9db6818488a714b48b9b6e2a1eb728.camel@gmail.com>
        <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
        <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
        <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
        <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
        <231786897.01593479281798.JavaMail.epsvc@epcpadp2>
        <SN6PR04MB46409E7CE538F158387615A6FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 30 June 2020 12:09
> To: daejun7.park=40samsung.com; Bean Huo <huobean=40gmail.com>;
> jejb=40linux.ibm.com; martin.petersen=40oracle.com; asutoshd=40codeaurora=
.org;
> stanley.chu=40mediatek.com; cang=40codeaurora.org; bvanassche=40acm.org;
> tomas.winkler=40intel.com; ALIM AKHTAR <alim.akhtar=40samsung.com>
> Cc: linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org; Sang-yo=
on Oh
> <sangyoon.oh=40samsung.com>; Sung-Jun Park
> <sungjun07.park=40samsung.com>; yongmyung lee
> <ymhungry.lee=40samsung.com>; Jinyoung CHOI <j-young.choi=40samsung.com>;
> Adel Choi <adel.choi=40samsung.com>; BoRam Shin
> <boram.shin=40samsung.com>
> Subject: RE: =5BRFC PATCH v3 0/5=5D scsi: ufs: Add Host Performance Boost=
er
> Support
>=20
> Hi,
>=20
> >
> > Hi Bean,
> > > On Mon, 2020-06-29 at 15:15 +0900, Daejun Park wrote:
> > > > > Seems you intentionally ignored to give you comments on my
> > > > > suggestion.
> > > > > let me provide the reason.
> > > >
> > > > Sorry=21 I replied to your comment (
> > > > https://protect2.fireeye.com/url?k=3Dbe575021-e3854728-be56db6e-
> > 0cc47a31cdf8-
> >
> 6c7d0e1e42762b92&q=3D1&u=3Dhttps%3A%2F%2Flkml.org%2Flkml%2F2020%2F6%
> > 2F15%2F1492),
> > > > but you didn't reply on that. I thought you agreed because you
> > > > didn't send any more comments.
> > > >
> > > >
> > > > > Before submitting your next version patch, please check your L2P
> > > > > mapping HPB reqeust submission logical algorithem. I have did
> > > >
> > > > We are also reviewing the code that you submitted before.
> > > > It seems to be a performance improvement as it sends a map request
> > > > directly.
> > > >
> > > > > performance comparison testing on 4KB, there are about 13%
> > > > > performance drop. Also the hit count is lower. I don't know if
> > > > > this is related to
> > > >
> > > > It is interesting that there is actually a performance improvement.
> > > > Could you share the test environment, please? However, I think
> > > > stability is important to HPB driver. We have tested our method
> > > > with the real products and the HPB 1.0 driver is based on that.
> > >
> > > I just run fio benchmark tool with --rw=3Drandread, --bs=3D4kb, --
> > > size=3D8G/10G/64G/100G. and see what performance diff with the direct
> > > submission approach.
> >
> > Thanks=21
> >
> > > > After this patch, your approach can be done as an incremental patch=
?
> > > > I would
> > > > like to test the patch that you submitted and verify it.
> > > >
> > > > > your current work queue scheduling, since you didn't add the
> > > > > timer for each HPB request.
> > > >
> > >
> > > Taking into consideration of the HPB 2.0, can we submit the HPB
> > > write request to the SCSI layer? if not, it will be a direct submissi=
on way.
> > > why not directly use direct way? or maybe you have a more advisable
> > > approach to work around this. would you please share with us.
> > > appreciate.
> >
> > I am considering a direct submission way for the next version.
> > We will implement the write buffer command of HPB 2.0, after patching
> > HPB 1.0.
> >
> > As for the direct submission of HPB releated command including HPB
> > write buffer, I think we'd better discuss the right approach in depth
> > before moving on to the next step.
> I vote to stay with the current implementation because:
> 1) Bean is probably right about 2.0, but it's out of scope for now -
>     there is a long way to go before we'll need to worry about it
> 2) For now, we should focus on the functional flows.
>     Performance issues, should such issues indeed exists, can be dealt wi=
th  later.
> And,
> 3) The current code base is running in production for more than 3 years n=
ow.
>      I am not so eager to dump a robust, well debugged code unless it abs=
olutely
> necessary.
>=20
Avri and Bean,
I think this is good approach to take, and let us add incremental patches t=
o add future specification enhancements.
=20
> Thanks,
> Avri
>=20


