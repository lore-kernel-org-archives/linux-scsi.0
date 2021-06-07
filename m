Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B4BC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0093A60FDA
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhFGLDT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:03:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54750 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhFGLDT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 07:03:19 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210607110126epoutp01db4411a8700d7b78b9f75fa5fc346b2b~GR9LGAY1Z2483724837epoutp01q
        for <linux-scsi@vger.kernel.org>; Mon,  7 Jun 2021 11:01:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210607110126epoutp01db4411a8700d7b78b9f75fa5fc346b2b~GR9LGAY1Z2483724837epoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623063686;
        bh=AVOhpAfM7Gqoiqsr+s5cR3shUV/6+9dn/S7Zad+fUTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbcAoBxjXdb+ELGj4YSrPL5WCDHW7oe9KufqyaVdyG9WORN4nRMCLklcZoAb2CP1v
         MLVkv8UhtrSflvQfjbwyvEA/CEyaEt8PC++GA43E0+R5CIlO5As75gWbEShMWmX+iH
         EMmnHp5AlPaFMKfxMWf4MsNUhKWGCr7tP4rI6wK8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210607110125epcas1p320529af5cfd885aea527f64a4fddf74e~GR9J_YbEe2589325893epcas1p3T;
        Mon,  7 Jun 2021 11:01:25 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.159]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Fz9R757Kmz4x9Pv; Mon,  7 Jun
        2021 11:01:23 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.4A.10258.38CFDB06; Mon,  7 Jun 2021 20:01:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210607110122epcas1p4557bcbc7abac791f2557cc0d317214fd~GR9Hvvv0x2088020880epcas1p4Z;
        Mon,  7 Jun 2021 11:01:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210607110122epsmtrp16e2f431b0d99e066731e189dc28c3b99~GR9HuZjtn3235632356epsmtrp1V;
        Mon,  7 Jun 2021 11:01:22 +0000 (GMT)
X-AuditID: b6c32a38-42fff70000002812-f2-60bdfc831fd2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.E8.08163.28CFDB06; Mon,  7 Jun 2021 20:01:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210607110122epsmtip2b92bf6c4921eac392a0d40221db4c9ee~GR9HWrwTd0048400484epsmtip2l;
        Mon,  7 Jun 2021 11:01:22 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     hch@infradead.org
Cc:     Johannes.Thumshirn@wdc.com, alex_y_xu@yahoo.ca,
        alim.akhtar@samsung.com, asml.silence@gmail.com,
        avri.altman@wdc.com, axboe@kernel.dk, bgoncalv@redhat.com,
        bvanassche@acm.org, cang@codeaurora.org, damien.lemoal@wdc.com,
        gregkh@linuxfoundation.org, jaegeuk@kernel.org, jejb@linux.ibm.com,
        jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ming.lei@redhat.com, mj0123.lee@samsung.com,
        nanich.lee@samsung.com, osandov@fb.com, patchwork-bot@kernel.org,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        tj@kernel.org, tom.leiming@gmail.com, woosung2.lee@samsung.com,
        yi.zhang@redhat.com, yt0928.kim@samsung.com
Subject: Re: [PATCH v12 1/3] bio: control bio max size
Date:   Mon,  7 Jun 2021 19:42:48 +0900
Message-Id: <20210607104248.17035-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <YL29gP0j1qmVuzyy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xTZxjOd045p3XpduS2L8S4UiGOewsUPgQWEpg5zpmQwNyCS6DCSSGU
        0rR087I5sjLuKxAISGmFIQFTmVVwDTBQxkXjBAnjzgbIgAkMkEHQgSgrLWT8ey/P8z7v8375
        2LhtE+nETpKlMQqZWMonDrFMnW4CL/V2W5ygMdcV3fqjnkRPr5kIpDOYAFrYHCLQzYkCArX0
        VwJUurqJozVjrQ36LusFhtTXjQR6XFiNoVmjFkfVoyYM5c9+a4Ne505iaGNaidrGPdBAi45A
        eSNNBKp7+AZDHcVqDJU16nA0PNVDos7JIRaarinC0ZNHazbo2kwY2qrrBuj5vyMk+rWpGEcj
        T0oJZGzbJMJ49MDgaXpA8z1GF6lXSLpZO0HSjTfc6YFeFd1gyCHowup2QN/X15P0P3PjLPr5
        vSGC1tw1AHq94Sid1Z6H0R0dtXjkOzHSkERGnMAoeIwsPjUhSSYJ5Z+Oig2PFQUIhF7CIBTI
        58nEKUwoP+LjSK+TSVLzvfi8L8RSlbkUKVYq+T4fhChSVWkMLzFVmRbKZ+QJUrlQIPdWilOU
        KpnEOz415YRQIPAVmZFx0sSlsTZMfpt1wdBbiqeDdjwXcNiQ8oeaP/vIXHCIbUs1AViRvQSs
        yRqAG78bCGuyDmB35QNyn1JU0bCHagGwILMf221YUH/3CHdjgvKEmuVxYje2pxzgZNmghYBT
        KzZwILeFtduwowJgyYTeErMoVzjbOmcGsdlcKhh2r0mtYu/B7al8y64cygv2d+ktMZc6DB+V
        z1qouBmj/qkC350Pqb848I6ugWUlR8Cs1cY9o3Zw8eHdPQdOcKEgk7QS8gBUZ1YCa1IIYM2z
        WsyK8oNr6+uWjXDKDRpbfKxlZ9j8Sg+sym/DlY18m10IpLgwO9PWCnGBPRlT+L7Wsx+b9ybS
        sPp+P269XDqAW1VVZCHgaQ8Y0h4wpP1fuQrgBuDIyJUpEkYplPsffOMGYPlC7qgJ6JdXvTsA
        xgYdALJxvj33oyOtcbbcBPHFS4wiNVahkjLKDiAyX7sId3KITzX/QVlarFDk6+fnh/wDAgNE
        fvx3uZLwy3G2lEScxiQzjJxR7PMwNscpHQs6N9J2rjHRM0U0efnWkZWF6MUHPM6XcCfwaXOA
        do560c531MVsdy5297vsxEQrnKXi3zSqT1xfD+hKOkM4F02nPu29UHabdX2RHP1h6tKrN6bz
        wxHhUzHHr0QH14VraYmdUT1zSj7aNb/zzWC5h+fI2a/LeuelreUFyWPHtru0w2fuXHWbvTJz
        PLTvBr3gs/l5xlS740sRqMkx7ARu6ZayxhrxkqiaCu/pY/NONgthZ8s9StaDnHMqDjsMhajf
        evzZzFdnRuz7m6LY5LaLX8pNfWbxtuP7Is1JlT5Y97OWW31+01dQn5F9tPmXHP1scnbXibIP
        w18ajaPLg30CcG+yjM9SJoqF7rhCKf4PjG5+cMsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWy7bCSvG7Tn70JBpuny1usu7OG3eLBvG1s
        FnNWbWO0ePnzKpvF6rv9bBa7Ls5ntJj24Sezxaf1y1gtWtu/MVk0L17PZnF6wiImiyfrZzFb
        LLqxjcmi50kTq8XfrntMFl8fFlvsvaVtcXnXHDaL7us72CyWH//HZHFocjOTxfTNc5gtrt0/
        w25x+N5VFouHSyYyW5w7+YnVYt5jB4tfy48yWrz/cZ3d4tSOycwW189NY7NYv/cnm4OCx+Ur
        3h6X+3qZPCY2v2P32DnrLrvH5hVaHpfPlnpsWtXJ5jFh0QFGj/1z17B7fHx6i8Xj/b6rbB59
        W1YxenzeJOfRfqCbyePQoWXMAfxRXDYpqTmZZalF+nYJXBlvbu5lKtjAUrHq7DTmBsYDzF2M
        nBwSAiYSE2dvYuxi5OIQEtjBKLHh1zd2iISUxPETb1m7GDmAbGGJw4eLIWo+Mkrs+f6TFaSG
        TUBHou/tLTYQW0RAVOLe9Ctgg5gFprFJbHtzC2yDsICZxJS7c1lAbBYBVYkne54yggzlFbCW
        OPopB2KXvMSf+z1g5ZwCuhIXj8wFs4WA5rdtm88IYvMKCEqcnPkEbAwzUH3z1tnMExgFZiFJ
        zUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzhNaGntYNyz6oPeIUYmDsZD
        jBIczEoivF4yexKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi
        4JRqYKq7a8u6RLtkZfYE69yowMKcdunwgnSRnNBsidIH5ZXvaiwnJ/r9sj1pumNawrnFDUpf
        Cz7tivv5elatUMCdYpUpr5OXm5f/ruh5LK97sPW0jnSTLMtDZb8XE6uyzEPSnzx6qXTsZuTH
        3fNb/JIOX7rqaO7+TNYoZ97Rx9+kfHyjMqSF96X1/tiut0Vy33ZJu4TWfpX/M16diW5j8Xv8
        Nsip8U6f6eczPEvy9feY5qcKW6UwsURMWX+hM1Ogz08inCOa8VxmQcUbQ6sCuetv19wJuJwc
        w7NobfLKw2lFkal9C0RyJ634uPQIb2vJ9SRJr60busvZ2NT6pl45vF6dYxGrb4hYUdmesF4B
        ZwslluKMREMt5qLiRABLjTUTggMAAA==
X-CMS-MailID: 20210607110122epcas1p4557bcbc7abac791f2557cc0d317214fd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210607110122epcas1p4557bcbc7abac791f2557cc0d317214fd
References: <YL29gP0j1qmVuzyy@infradead.org>
        <CGME20210607110122epcas1p4557bcbc7abac791f2557cc0d317214fd@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> NAK.  As discussed countless time we already have an actual limit.
> And we can look it as advisory before building ever bigger bios,
> but the last thing we need is yet another confusing limit.

Thank you for your review and feedback. I has thought proper bio size control
with proper interface might be good, and can be helpful to the other module
beside issued performance problem. Providing of common interface to control
bio size in block layer might be good I think even though current patch is
not accepted.

Thanks for all,
Changheun Lee
