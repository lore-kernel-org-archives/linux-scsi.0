Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA78C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 01:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbiEJCCK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 May 2022 22:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiEJCCK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2022 22:02:10 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE82721330F
        for <linux-scsi@vger.kernel.org>; Mon,  9 May 2022 18:58:09 -0700 (PDT)
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220510015803epoutp0295ed36b362e80a8f31172394cba3a234~tm788dLZj3273632736epoutp02R
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 01:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220510015803epoutp0295ed36b362e80a8f31172394cba3a234~tm788dLZj3273632736epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652147884;
        bh=BLA8xn4IElcO3LAMo06B8+heYNNfifdUw16XRT/rcmc=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=UpSfHuf5ZNEO03uoeaRtz3N8ygdqu7/uzq+GsaYCdPrVGPsIS5BQCeZ0cFXrO8ltX
         EqxrX+8VRse/lAP+G3+bKD8nYIoKsTfsbjYVqgyhUUZHHNq0ON4IrcqWJpSRSx1PPW
         3Z6wUNKPso18Ue5LVFp5NWL/jTIW9YTE+pRJs0Ro=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20220510015803epcas3p1237a4112ed387a6af4ac0dffe51b9028~tm78XAo8U1834718347epcas3p1p;
        Tue, 10 May 2022 01:58:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4Ky1Qg29SRz4x9Q2; Tue, 10 May 2022 01:58:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v4 5/6] scsi: ufshpb: Add handing of device reset HPB
 regions Infos in HPB device mode
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
Message-ID: <1889248251.21652147883293.JavaMail.epsvc@epcpadp4>
Date:   Tue, 10 May 2022 10:02:55 +0900
X-CMS-MailID: 20220510010255epcms2p3f347f4b1a597c27248bacfa9dddf3139
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220505134735epcas2p457a16df1b023585b188cc6fc15f37932
References: <CGME20220505134735epcas2p457a16df1b023585b188cc6fc15f37932@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi=C2=A0Bean=C2=A0Huo,
=C2=A0
>In=C2=A0UFS=C2=A0HPB=C2=A0Spec=C2=A0JESD220-3A,
>=C2=A0
>"5.8.=C2=A0Active=C2=A0and=C2=A0inactive=C2=A0information=C2=A0upon=C2=A0p=
ower=C2=A0cycle
>...
>When=C2=A0the=C2=A0device=C2=A0is=C2=A0powered=C2=A0off=C2=A0by=C2=A0the=
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
>Therefore,=C2=A0for=C2=A0HPB=C2=A0device=C2=A0control=C2=A0mode,=C2=A0if=
=C2=A0the=C2=A0UFS=C2=A0device=C2=A0is=C2=A0reset=C2=A0via=C2=A0the=C2=A0RS=
T_N
>pin,=C2=A0the=C2=A0active=C2=A0region=C2=A0information=C2=A0in=C2=A0the=C2=
=A0device=C2=A0will=C2=A0be=C2=A0reset.=C2=A0If=C2=A0the=C2=A0host=C2=A0sid=
e
>receives=C2=A0this=C2=A0notification=C2=A0from=C2=A0the=C2=A0device=C2=A0s=
ide,=C2=A0it=C2=A0is=C2=A0recommended=C2=A0to=C2=A0inactivate
>all=C2=A0active=C2=A0regions=C2=A0in=C2=A0the=C2=A0host's=C2=A0HPB=C2=A0ca=
che.
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
