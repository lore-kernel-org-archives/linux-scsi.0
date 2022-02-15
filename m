Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1970BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 01:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiBOBiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 20:38:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiBOBiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 20:38:14 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2603612F416
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 17:38:04 -0800 (PST)
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220215013802epoutp01aba0fa16ad1bc897a095f027f1eb69d5~T0efDLA4R2974029740epoutp01_
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 01:38:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220215013802epoutp01aba0fa16ad1bc897a095f027f1eb69d5~T0efDLA4R2974029740epoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1644889082;
        bh=yniUWdfJGZEl35uzkUUQAwHkGQZ3SGcv6n9cR6PnOiw=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=DDeDYUnkyh6DrciiiFjvUhQ0SVopRUMG4WRO2IyZCdwCu5cZV/jt8KpqzZIparcNx
         MjH4YPXc2mPXaTX3jb7QOan6lGfz6xUFSKvCWsA++K09Tjr+H4BYT5220EuCQQw/Px
         IotkawAkS7OloeNYYtxJExaZs10G+yL4tSbnx0TY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20220215013801epcas3p31522f78ba966b954c5015f09629140bb~T0een__3q1597415974epcas3p3o;
        Tue, 15 Feb 2022 01:38:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4JyNyK5Shzz4x9QK; Tue, 15 Feb 2022 01:38:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE:(2) [PATCH] scsi: ufs: Fix divide zero case in
 ufshcd_map_queues()
Reply-To: j-young.choi@samsung.com
Sender: Jinyoung CHOI <j-young.choi@samsung.com>
From:   Jinyoung CHOI <j-young.choi@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <7a324bb2-c748-4d48-8f55-13f35de5a35e@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01644889081701.JavaMail.epsvc@epcpadp4>
Date:   Tue, 15 Feb 2022 10:35:10 +0900
X-CMS-MailID: 20220215013510epcms2p579847dd4aa388312f9d1fc0be9cfbc35
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220214103352epcms2p79697c0fcaa2755dd89af9de887ff14cd
References: <7a324bb2-c748-4d48-8f55-13f35de5a35e@acm.org>
        <1891546521.01644873481638.JavaMail.epsvc@epcpadp4>
        <CGME20220214103352epcms2p79697c0fcaa2755dd89af9de887ff14cd@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On=C2=A02/14/22=C2=A002:33,=C2=A0Jinyoung=C2=A0CHOI=C2=A0wrote:
>>=C2=A0Before=C2=A0calling=C2=A0blk_mq_map_queues(),=C2=A0the=C2=A0mq_map=
=C2=A0and=C2=A0nr_queues=C2=A0belonging
>>=C2=A0to=C2=A0"struct=C2=A0blk_mq_queue_map"=C2=A0must=C2=A0be=C2=A0a=C2=
=A0vaild=C2=A0value.
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
^^=C2=A0=C2=A0=C2=A0^^^^^
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0have=C2=A0=
=C2=A0=C2=A0valid
>=C2=A0
>>=C2=A0If=C2=A0nr_queues=C2=A0is=C2=A0set=C2=A0to=C2=A00,=C2=A0the=C2=A0sy=
stem=C2=A0may=C2=A0encounter=C2=A0the=C2=A0"divide=C2=A0zero"
>>=C2=A0depending=C2=A0on=C2=A0the=C2=A0type=C2=A0of=C2=A0architecture.
>=C2=A0
>Anyway:
>
>Reviewed-by:=C2=A0Bart=C2=A0Van=C2=A0Assche=C2=A0<bvanassche@acm.org>

Hi, Bart.

Thanks for your review.
I will be careful of typo. :)

Best Regards,
Jinyoung Choi
