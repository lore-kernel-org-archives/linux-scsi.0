Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDFEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 01:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbiEJCCK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 May 2022 22:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiEJCCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2022 22:02:08 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE996213339
        for <linux-scsi@vger.kernel.org>; Mon,  9 May 2022 18:58:09 -0700 (PDT)
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220510015804epoutp01e1572949e883180e83f50864ddc29cc6~tm79MUxo91553615536epoutp01i
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 01:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220510015804epoutp01e1572949e883180e83f50864ddc29cc6~tm79MUxo91553615536epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652147884;
        bh=FzQStU6k7eJOrZgUYQW4e7Jyi6Q5Qxh7TIHqNxb/uns=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=HchkM/5UrV+H2SdnpEC5s5DkKEdxCWdbUiQW6+MRRxuNXZL3vQEo5KKZYX4HQ+/Ox
         8sIpsUTSKFpm1nwjiHgei6gxxHj2S+E1tumr0a+dnqgN1+YuI0r5t8j0EN/hVN1Z4f
         +tVy9nw+v13Blzq75dbNkoCQ+dRnyQCSzpQysJiM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20220510015803epcas3p298966c5609bc26e85d353af373616066~tm78sbatV1055010550epcas3p2X;
        Tue, 10 May 2022 01:58:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4Ky1Qg4jfhz4x9Q2; Tue, 10 May 2022 01:58:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v4 3/6] scsi: ufshpb: Cleanup the handler when device
 reset HPB information
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        cpgsproxy3 <cpgsproxy3@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1295226194.41652147883654.JavaMail.epsvc@epcpadp4>
Date:   Tue, 10 May 2022 10:03:21 +0900
X-CMS-MailID: 20220510010321epcms2p2e88db0f37b976804f44760f5ac2e081c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220505134730epcas2p1423c1274105c2611825a692ca7375f6e
References: <CGME20220505134730epcas2p1423c1274105c2611825a692ca7375f6e@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi=C2=A0Bean=C2=A0Huo,
=C2=A0
>From:=C2=A0Bean=C2=A0Huo=C2=A0<beanhuo@micron.com>
>=C2=A0
>"When=C2=A0the=C2=A0device=C2=A0is=C2=A0powered=C2=A0off=C2=A0by=C2=A0the=
=C2=A0host,=C2=A0the=C2=A0device=C2=A0may=C2=A0restore=C2=A0L2P=C2=A0map=C2=
=A0data
>upon=C2=A0power=C2=A0up=C2=A0or=C2=A0build=C2=A0from=C2=A0the=C2=A0host=E2=
=80=99s=C2=A0HPB=C2=A0READ=C2=A0command.=C2=A0In=C2=A0case=C2=A0device=C2=
=A0powered
>up=C2=A0and=C2=A0lost=C2=A0HPB=C2=A0information,=C2=A0device=C2=A0can=C2=
=A0signal=C2=A0to=C2=A0the=C2=A0host=C2=A0through=C2=A0HPB=C2=A0Sense=C2=A0=
data,
>by=C2=A0setting=C2=A0HPB=C2=A0Operation=C2=A0as=C2=A0=E2=80=982=E2=80=99=
=C2=A0which=C2=A0will=C2=A0inform=C2=A0the=C2=A0host=C2=A0that=C2=A0device=
=C2=A0reset=C2=A0HPB
>information."
>=C2=A0
>This=C2=A0patch=C2=A0is=C2=A0to=C2=A0clean=C2=A0up=C2=A0the=C2=A0handler=
=C2=A0and=C2=A0make=C2=A0the=C2=A0intent=C2=A0of=C2=A0this=C2=A0handler=C2=
=A0more
>readable,=C2=A0no=C2=A0functional=C2=A0change.
>=C2=A0
>Signed-off-by:=C2=A0Bean=C2=A0Huo=C2=A0<beanhuo@micron.com>
>Reviewed-by:=C2=A0Keoseong=C2=A0Park=C2=A0<keosung.park@samsung.com>
=C2=A0
Here=C2=A0is=C2=A0my=C2=A0reviewed-by=C2=A0tag.
Reviewed-by:=C2=A0Daejun=C2=A0Park=C2=A0<daejun7.park@samsung.com>
=C2=A0
Thanks,
Daejun
=C2=A0
