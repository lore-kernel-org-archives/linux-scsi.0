Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8632DC00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 04:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiG2Eu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 00:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiG2Euz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 00:50:55 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3411EEC4
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 21:50:52 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220729045046epoutp02449bb9d98d1d2f025e78a5e171fe2b25~GM5lyuP1Q0218002180epoutp02X
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 04:50:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220729045046epoutp02449bb9d98d1d2f025e78a5e171fe2b25~GM5lyuP1Q0218002180epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659070246;
        bh=vyeZZJfOSClnlIwgoX4qFgtMQTpokyQF/v6Q12nU+og=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=KVto/YgJO8AarOHbBj8NKWQYH+6Q4CZkpZqcChAIDPYWuoa0cynPvV+kphhdCKrec
         J6i8jpl2c2X041K+13mzOMCGc7kVukxqZNtgWt/sveX17SBF4EXeuexPj5RtrAGflY
         wFtELjxzOtGVpoz8lqUZS2e28/bjTNmT36oxeG3s=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20220729045046epcas2p39387f886e27581049b616438043d788d~GM5lbVWnu0418904189epcas2p3d;
        Fri, 29 Jul 2022 04:50:46 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.92]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LvFT213Jfz4x9QP; Fri, 29 Jul
        2022 04:50:46 +0000 (GMT)
X-AuditID: b6c32a48-9e1ff700000025be-10-62e36725a0a3
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.30.09662.52763E26; Fri, 29 Jul 2022 13:50:46 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v5 0/6] scsi: ufs: wb: Add sysfs attribute and cleanup
Reply-To: j-young.choi@samsung.com
Sender: Jinyoung CHOI <j-young.choi@samsung.com>
From:   Jinyoung CHOI <j-young.choi@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220729045045epcms2p8caf00317889ed4da8531b7466ec6e368@epcms2p8>
Date:   Fri, 29 Jul 2022 13:50:45 +0900
X-CMS-MailID: 20220729045045epcms2p8caf00317889ed4da8531b7466ec6e368
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmha5a+uMkg+9/GC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZouXhzQtFt3YxmRxedccNovu6zvYLJYf/8fkwOVx+Yq3x+I9L5k8
        Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEdUtk1GamJKapFCal5yfkpmXrqtkndw
        vHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0IlKCmWJOaVAoYDE4mIlfTubovzSklSFjPzi
        Elul1IKUnALzAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMyZtOsBW0cVXs+r6BpYHxGnsXIyeH
        hICJxJLPG5m7GLk4hAR2MEos/dTA2MXIwcErICjxd4cwSI2wgJvEr7NrWEBsIQEliXNrZoGV
        CAsYSNzqNQcJswnoSfxcMoMNZIyIwFlmiYUPpzBBzOeVmNH+lAXClpbYvnwrI4StIfFjWS8z
        hC0qcXP1W3YY+/2x+VA1IhKt985C1QhKPPi5GyouKXHo0Fc2kBskBPIlNhwIhAjXSLxdfgCq
        RF/iWsdGsLW8Ar4S2z9cA4uzCKhK9L9cxApR4yKxoQ/iLWYBeYntb+cwg4xkFtCUWL9LH2K6
        ssSRWywwjzRs/M2OzmYW4JPoOPwXLr5j3hMmiFY1iUVNRhBhGYmvh+ezQ4Q9JE79NJvAqDgL
        EcizkFwwC+GCBYzMqxjFUguKc9NTi40KTODxmpyfu4kRnFC1PHYwzn77Qe8QIxMH4yFGCQ5m
        JRFegYDHSUK8KYmVValF+fFFpTmpxYcYTYF+n8gsJZqcD0zpeSXxhiaWBiZmZobmRqYG5kri
        vF4pGxKFBNITS1KzU1MLUotg+pg4OKUamEpvuHkmJH87O9lJ9oUk95onjsxy+XObo65aanO+
        7apoe5xyknOxpKLlR/8aLvbrof9Ccp5pvp/nvOzqskvzL1tHlNkreE6Y1C3QOr/EWepCjN0t
        50eccyq3L7EI+6z74PyWm6LPfi9tWbCnwLStw01DtSafZccMXam6Cp+bbybs1fk62TLHKElG
        43qTUbJWtpRIY57qwqzjy9KCzObXuJ8UuSZhsvyubvWkgKXM5oVCs/i6loVX7bPbevzrPfbD
        Qeu6Am0Ulv5c9bMvd+IpOSGb+hnb1vkUeH3fuiZ247Ld+qHpqfmf9iVnmDKdXZKmopi2+Kvw
        tiD9XwydW2d3yG7f3LNV2HHd95mfSl1ilViKMxINtZiLihMBYoq8xzEEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220729045045epcms2p8caf00317889ed4da8531b7466ec6e368
References: <CGME20220729045045epcms2p8caf00317889ed4da8531b7466ec6e368@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series is to clean up UFS's Write Booster code and
adds sysfs attribute which can control the specific feature of it.

V2:
	- modify commit message
	- move & modify err messages
	- remove unnesscessary debug messages
V3:
	- split patch (functional, non-functional)
V4:
	- split patch (The number of patches from 2 to 7)
	- modify dev messages
	- modify commit message
V5:
	- drop (scsi: ufs: wb: Move ufshcd_is_wb_allowed() to callee)
	- fix condition check
	- add Document for sysfs attribute
	- move ufshcd_is_wb_buf_flush_allowed() to ufs-priv.h

Jinyoung Choi (6):
  scsi: ufs: wb: Change wb_enabled condition test
  scsi: ufs: wb: Change functions name and modify parameter name
  scsi: ufs: wb: Add explicit flush sysfs attribute
  scsi: ufs: wb: Add ufshcd_is_wb_buf_flush_allowed()
  scsi: ufs: wb: Modify messages
  scsi: ufs: wb: Move the comment to the right position

 Documentation/ABI/testing/sysfs-driver-ufs | 10 ++++
 drivers/ufs/core/ufs-sysfs.c               | 46 +++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h             |  6 ++
 drivers/ufs/core/ufshcd.c                  | 64 ++++++++++++----------
 include/ufs/ufshcd.h                       |  1 +
 5 files changed, 96 insertions(+), 31 deletions(-)

-- 
2.25.1
