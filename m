Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78820C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 01:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EDD620738
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 01:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FjgGCgVl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgGHBwt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 21:52:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33074 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgGHBwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 21:52:49 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200708015246epoutp02c48957f9bedd167cce3777beae6b29cb~fpAxbv0tp1986319863epoutp02c
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 01:52:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200708015246epoutp02c48957f9bedd167cce3777beae6b29cb~fpAxbv0tp1986319863epoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594173166;
        bh=Fp+45yKRkGlzwKBFTbX2mBOEbg5kcrLz5KH1ICKPcJ8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=FjgGCgVlN7h8XqG3hSS8g0lrUFSdfbpRKCqnTokIK9cHkWt3uSt0XCg5JvDR3zhp+
         iIviYx3G9hax+I3LLTqw8BJ7FuPT9Q/N/sdnfaKw8csE3wtjwG3CBbWUgmmTMh/nFW
         kue02blDv3pnZ4xkrZy7j5mPGY/fg1s/cuUP9o3E=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200708015245epcas2p256f7c9475515e266344324b1cd91eb53~fpAw8TqXT2553925539epcas2p2I;
        Wed,  8 Jul 2020 01:52:45 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B1j4D1ffWzMqYkx; Wed,  8 Jul
        2020 01:52:44 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.33.27441.9E6250F5; Wed,  8 Jul 2020 10:52:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200708015241epcas2p4c287d7df1b2d4fc10486820a3e83a94a~fpAsv6mLf1153411534epcas2p4T;
        Wed,  8 Jul 2020 01:52:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200708015241epsmtrp2844b59a7ce7c958087c3b9587624317b~fpAsu-IPF0240502405epsmtrp2d;
        Wed,  8 Jul 2020 01:52:41 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-70-5f0526e901e7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.B9.08382.8E6250F5; Wed,  8 Jul 2020 10:52:40 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200708015240epsmtip1bcaa1ffb05f5f3e5955cab368a18ed30~fpAsgseq92573425734epsmtip1n;
        Wed,  8 Jul 2020 01:52:40 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v4 0/3] ufs: exynos: introduce the way to get cmd info
Date:   Wed,  8 Jul 2020 10:44:45 +0900
Message-Id: <cover.1594097045.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTVPelGmu8QfcOI4sH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        KscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+huJYWy
        xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVC
        TsajDxEF/9krfh34z9jAuJSti5GTQ0LAROL6si/MXYxcHEICOxgldpx9xQbhfGKUmNU3G8r5
        xijxeOZtdpiWHwu6WCASexkllp2/wASSEBL4wShx+5koiM0moCnx9OZUJpAiEYHNTBKvFtxn
        BkkwC6hL7JpwAqxBWMBLYkXvYjCbRUBV4sLlblYQm1fAQuLno6VQ2+Qkbp7rBDtQQuAnu8SH
        J79ZIBIuEu1P7jFD2MISr45vgWqQkvj8bi/Ud/US+6Y2sEI09zBKPN33jxEiYSwx61k7kM0B
        dJGmxPpd+iCmhICyxJFbLBB38kl0HP7LDhHmlehoE4JoVJb4NWky1BBJiZk370Bt9ZDY/PEG
        GyQcYiVmvdrKPIFRdhbC/AWMjKsYxVILinPTU4uNCoyRI2kTIzgtarnvYJzx9oPeIUYmDsZD
        jBIczEoivAaKrPFCvCmJlVWpRfnxRaU5qcWHGE2B4TWRWUo0OR+YmPNK4g1NjczMDCxNLUzN
        jCyUxHmLrS7ECQmkJ5akZqemFqQWwfQxcXBKNTBJZIuUW+haTFdp8H/CL6WQlclwxqR29r6H
        B75x5pwS6Pj7s3ryp7a0kkMyF790ma088UbxXzC3dNDUxS+VozdPubUglNVgkyLjtGWnl4WJ
        /HkWeb2shKP/xJfTC2Sa/sUdTWw3XqBWHLlGf12O7dtm3tjK9c928Oe+eNsiwy45ra87+aXi
        bAvGqa/ehUpsFtQ4Y/FdPED88GOlJxaJP49uqVFcNr/M2Wun0X62quhEzamP5I3XbAk7nGjk
        0+wgaVmdJxydy23BVxd1tSL+HMPU3uVCfavLtaVXxrlU921f7lS0ZkrqvVVNC1mkl+wXf1yc
        UzDtqHxfxztXxrUOKxr72M/d4Rc9FLm+8HW1ghJLcUaioRZzUXEiADcHp3wUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnO4LNdZ4g4mrrS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MRx8iCv6zV/w68J+xgXEpWxcjJ4eEgInEjwVdLF2MXBxCArsZJRq/
        TWWHSEhKnNj5nBHCFpa433KEFaLoG6PEtBW3mUESbAKaEk9vTmUCSYgIHGaS+L/1OVg3s4C6
        xK4JJ5hAbGEBL4kVvYvBbBYBVYkLl7tZQWxeAQuJn4+WQm2Tk7h5rpN5AiPPAkaGVYySqQXF
        uem5xYYFhnmp5XrFibnFpXnpesn5uZsYwYGqpbmDcfuqD3qHGJk4GA8xSnAwK4nwGiiyxgvx
        piRWVqUW5ccXleakFh9ilOZgURLnvVG4ME5IID2xJDU7NbUgtQgmy8TBKdXAxGzkMbfK3cmb
        eb2ZVrT1u8U8D158bm0RCjA77uG81b5xgv71xys/VVnqeB1+PPX7vJwUo/v3Xl18c+HY4nUz
        L8/m8RNcsvK+9Lxf389cdp8eu/zonePNqpm//gjNeHih1/6l0Wf1Z+1PJRP6ln3h/NWtyzlv
        k/KK92FeIr9X+S7rv6O8a1tw2fkE/oIr/2rFjKbEiT86b/B5+WOLw9odx1VnXd1eXneDqcpw
        /56XwZmPzhyX5bzc9DNk7ryfakJbuPLub9dqvvcoi4PjQuyBeZsX/rIMZpt5+t8R5fQbYSuu
        3vUP9Pw1NVbvkG2bb2WWT9Dx69577OqftGQFWs86ueXxxBuNsfbLf6dWnJTZ+/6HEktxRqKh
        FnNRcSIAJjEXWcMCAAA=
X-CMS-MailID: 20200708015241epcas2p4c287d7df1b2d4fc10486820a3e83a94a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708015241epcas2p4c287d7df1b2d4fc10486820a3e83a94a
References: <CGME20200708015241epcas2p4c287d7df1b2d4fc10486820a3e83a94a@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v3 -> v4
seperate respective implementations of the callbacks
change the location of compl_xfer_req related stuffs
fix null pointer access

v2 -> v3
fix build errors

v1 -> v2
change callbacks
allocate memory for ufs_s_dbg_mgr dynamically, not static way

Kiwoong Kim (3):
  ufs: introduce a callback to get info of command completion
  ufs: exynos: introduce command history
  ufs: exynos: implement dbg_register_dump

 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 201 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  61 ++++++++++++
 drivers/scsi/ufs/ufs-exynos.h     |  12 +++
 drivers/scsi/ufs/ufshcd.c         |   2 +
 drivers/scsi/ufs/ufshcd.h         |   8 ++
 8 files changed, 316 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

-- 
2.7.4

