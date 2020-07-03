Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D609C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B8820771
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ArHGonVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGCFiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:38:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26973 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCFiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:38:00 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200703053757epoutp03cf4eeac591ae6d90d0db1893fc261fd1~eJ29vlh3Y2270522705epoutp03C
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 05:37:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200703053757epoutp03cf4eeac591ae6d90d0db1893fc261fd1~eJ29vlh3Y2270522705epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593754677;
        bh=azxMVNyl7wcCSanLekYTVjBHM/S2RAbxbRQO5hkpxm0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ArHGonVK+piQrkRaqJaUyRFMVopcbhYZzKUXdrcocU57+JY9QpkoJDUA4FgtpVkfD
         8FQ/nVyGObKSa9ADhrzPXHPk9rx8ESu7TIV0vfMSjkBj6Xsd2acyPEeNKGlbaUIGr1
         MGNpGHeavkfvhNjeIins3CcMQ87i9Wu3nbB0lLGU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200703053757epcas2p17e1c691cf9e462c420cc463d148f70a2~eJ29RogtP2825928259epcas2p1K;
        Fri,  3 Jul 2020 05:37:57 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.184]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49ykJN1cqszMqYlx; Fri,  3 Jul
        2020 05:37:56 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.F8.19322.334CEFE5; Fri,  3 Jul 2020 14:37:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200703053755epcas2p23adbc614d9a72cf3335ed1e6223709f3~eJ27XBxRP2742027420epcas2p2p;
        Fri,  3 Jul 2020 05:37:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200703053755epsmtrp12d0a66a6b00ef069351bd950b20f82bc~eJ27WIz6N0400704007epsmtrp1p;
        Fri,  3 Jul 2020 05:37:55 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-4c-5efec4334fa9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.6E.08303.234CEFE5; Fri,  3 Jul 2020 14:37:55 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053754epsmtip15b8b05e3fa1fac68b075a327c9677ae8~eJ27GCA9n2756827568epsmtip1D;
        Fri,  3 Jul 2020 05:37:54 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v3 0/2] ufs: support various values per device
Date:   Fri,  3 Jul 2020 14:30:00 +0900
Message-Id: <cover.1593753896.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTQtf4yL84g+ed0hYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIzdf58yFSxnqZj5cg57A+NW5i5GTg4JAROJ7zt+MXYxcnEICexglPgy8y4ThPOJUeLDpGfM
        EM5nRolNNxYAlXGAtfx5zQoR38UoMWF3O1THD0aJju3bGUHmsgloSjy9ORUsISKwmUni1YL7
        YAuZBdQldk04wQRiCws4SexccBbMZhFQlXjbd4wVxOYVsJBYPGM5O8SBchI3z3WCnSEh8JNd
        4kvrHzaIhIvEh7bdjBC2sMSr41ugGqQkXva3Qdn1EvumNrBCNPcwSjzd9w+qwVhi1rN2sH+Y
        gU5dv0sf4jVliSO3WCDu5JPoOPyXHSLMK9HRJgTRqCzxa9JkqCGSEjNv3oHa5CGxfeFpMFtI
        IFZiyrsdbBMYZWchzF/AyLiKUSy1oDg3PbXYqMAQOZY2MYITo5brDsbJbz/oHWJk4mA8xCjB
        wawkwpug+i9OiDclsbIqtSg/vqg0J7X4EKMpMLwmMkuJJucDU3NeSbyhqZGZmYGlqYWpmZGF
        kjhvruKFOCGB9MSS1OzU1ILUIpg+Jg5OqQYm2b2Tz+2+Ztl98O8rzi9qyu4HxOoPJOyN1Tpw
        z+i/427vpjxvlSzLw2GmweoWDk4P1itnyJ/qd3y4uOk1zxXBD48S/7dr7Rdf/Spdd6lIUUW9
        6KKKP3Zd9V6PDDcrP35me/iejh7fh20Cr/eclBXKb2a7cpPx5IHNOb11D7MqpoTqTt5h1h2f
        tiQg1GpCXfPt24F/9z2bXimw+Tu/T+qLH1/PWm0Ne5utK7b+2aIvXG9SzrBaxh1J9sp6mCGx
        I3mdX9iuEJ1rDo2ZPz23RT2/GSkl9mjHbSeTvye8Gi//rgudv08yIOpoq/TTM0/XhBm/5lDi
        ucLvyiuhPfHf9LK5xdJXaotP3E3aXfK4fIavEktxRqKhFnNRcSIAUQ8o4hUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnK7xkX9xBp8WMVo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZu/8+ZSpYzlIx8+Uc9gbGrcxdjBwcEgImEn9es3YxcnEICexglPh5
        eSlLFyMnUFxS4sTO54wQtrDE/ZYjUEXfGCUerO9hBUmwCWhKPL05lQkkISJwmEni/9bn7CAJ
        ZgF1iV0TTjCB2MICThI7F5wFs1kEVCXe9h0Da+YVsJBYPGM5O8QGOYmb5zqZJzDyLGBkWMUo
        mVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERyoWlo7GPes+qB3iJGJg/EQowQHs5IIb4Lq
        vzgh3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1MFmf7UqY
        kBn4fU5jZyrLiVmilrcc3hpH+M43DKhkNb2Wkf5qYjjLnYKYnkTzO5L6+jZNr5vNP2wrDlR5
        dTXncF5+0p/EgJYXB12+xl5qLzXsbZxY9b97pnpI1PyFrsfuXZ649fIa78scKr8SH6cVyWXu
        inhl4rTz1KLtO4V3O28N4o1IS3Dy9Zhz8buuUICXwv4z1+t/Vd7UyCoRX/1bzel3OZ+FTMcP
        xif/TCrjhacsLZ0pbyM7x37XqphOmeYfm5s1Zobb39/rKXRETsrp4G4bl0qpOIOqNcY2K2KP
        dpj+KTrbvcsoW7b6xtS1vYsOxfh2KJfNfuQxhcPKMoiR+fZc5U+Lr9r5bZnWtLJKiaU4I9FQ
        i7moOBEAf6DvK8MCAAA=
X-CMS-MailID: 20200703053755epcas2p23adbc614d9a72cf3335ed1e6223709f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053755epcas2p23adbc614d9a72cf3335ed1e6223709f3
References: <CGME20200703053755epcas2p23adbc614d9a72cf3335ed1e6223709f3@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v3
set default fdeviceinit timeout to 1 second
set the interval among query requests to check if it's cleared 5ms

v1 -> v2
change ufs_dev_values to const
remove macros to enhance readability

Kiwoong Kim (2):
  ufs: support various values per device
  ufs: change the way to complete fDeviceInit

 drivers/scsi/ufs/ufs_quirks.h | 13 ++++++++
 drivers/scsi/ufs/ufshcd.c     | 75 ++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h     |  1 +
 3 files changed, 77 insertions(+), 12 deletions(-)

-- 
2.7.4

