Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2C0C4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 03:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60631613D4
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 03:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhE0DN5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 23:13:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29256 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhE0DN4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 23:13:56 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210527031222epoutp04e5c2831b9fbfb5a71190c4d05676441b~Czde36AL90906709067epoutp045
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 03:12:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210527031222epoutp04e5c2831b9fbfb5a71190c4d05676441b~Czde36AL90906709067epoutp045
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622085142;
        bh=f37EYTIi3mXSrhIWvEOJvyWGH29au5/mg/qphK5+clw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=kIdwI50VoWQfBYrIzH3o6hochu7wHO+c+V32GMBRPm0pVNSvOaOi26y176CaGkHVe
         QPmhNzEAOTbnk0OGeIYPNK8X1JaSzB8cL4YeadtDt+aqCUKIWnOakhxeSt2ZJQAe2Z
         vpE3dMHsqikv8Ui9NT8iccmJd7rNtFHLCr7xTS9w=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210527031221epcas2p29a6a54129cb58a2244f099bf6066cea6~CzdeM8AYv2760027600epcas2p2O;
        Thu, 27 May 2021 03:12:21 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FrCXz47B4z4x9Q3; Thu, 27 May
        2021 03:12:19 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.CC.09604.11E0FA06; Thu, 27 May 2021 12:12:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210527031217epcas2p44b9d999edcc55b345dfd0749acefeaec~CzdajC8Xk0835408354epcas2p40;
        Thu, 27 May 2021 03:12:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210527031217epsmtrp1152503d270cc1830080b6c7179960e3a~CzdaiBbl70371003710epsmtrp1Q;
        Thu, 27 May 2021 03:12:17 +0000 (GMT)
X-AuditID: b6c32a45-dc9ff70000002584-cd-60af0e11cee9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.B2.08163.11E0FA06; Thu, 27 May 2021 12:12:17 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.60]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210527031217epsmtip22a13cd0e5dd19317ca6ce8846d49991d~CzdaWk3PN2849528495epsmtip2t;
        Thu, 27 May 2021 03:12:17 +0000 (GMT)
From:   jongmin jeong <jjmin.jeong@samsung.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, cang@codeaurora.org,
        beanhuo@micron.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jjmin.jeong@samsung.com
Subject: [PATCH 0/3] Add quirk to support exynos ufshci
Date:   Thu, 27 May 2021 12:08:58 +0900
Message-Id: <20210527030901.88403-1-jjmin.jeong@samsung.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmha4g3/oEg3NNlhYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4tH4Zq8WiG9uYLFZes7C4vGsOm0X39R1sFsuP/2Ny4PK43NfL5LF4z0sm
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
        uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ2PajWdsBUfEKl6v+MLSwDhJsIuR
        k0NCwERi1ZHLrF2MXBxCAjsYJV5e/wjlfGKU+DnjPZTzmVFi0sqTjDAtB67NY4RI7GKU2Nl0
        hg3C+cgo0XVpNTNIFZuArsSZzS+BbA4OEQEjiWurPEFqmAVOMkr0nn0BViMsYC6x/80uVhCb
        RUBV4tfTPjCbV8BG4szFK+wQ2+QlTp+4xggRF5Q4OfMJC4jNDBRv3jqbGWSohMBfdok7+x+x
        QDS4SDR+2csEYQtLvDq+BWqQlMTL/jYou15id8MeqOYJjBLdnVehmu0lfk3fwgpyNbOApsT6
        XfogpoSAssSRW1B7+SQ6Dv9lhwjzSnS0CUE0qkpsWbwRGkDSEkvXHoca6CFxeMdesHeFBGIl
        /j16wTaBUX4Wkm9mIflmFsLeBYzMqxjFUguKc9NTi40KDJFjdRMjOKFque5gnPz2g94hRiYO
        xkOMEhzMSiK8B5vXJgjxpiRWVqUW5ccXleakFh9iNAWG70RmKdHkfGBKzyuJNzQ1MjMzsDS1
        MDUzslAS5/2ZWpcgJJCeWJKanZpakFoE08fEwSnVwFS0/1TcfsPqBN1dMjxrlMMSQu96Sxxi
        FDqkvdwv7oErl1ew2UWNTbEMk5flup4w1dfavM5h+U4Gr/roy2wMH1h7+1VsZ3/U5jnsXOov
        93zC9S8vsr6ffsMj9OvN+6Z54duaQwqPr5tQGP/+4Eyzcp4Zl1lC7exblP/nfT9dq/1+Wvir
        kBlH45ufxRnZRXdf6P9n3x4n2LKCV3tTteaNlTp1/NNXH+l/8badZaHux8B9yffMVDeI7pxp
        r/3jjnPdHj+2+RMO1HcWWU7a5/PovOqaR+bzmi/M2+P1LpD91ertkpEXjk1wftvYbdN+eq6k
        NPv3nkmVV9fXic4QFjjSdFR5+w9ji2dMbTKqhd90OJRYijMSDbWYi4oTAQFhUnMxBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSvK4g3/oEg1ut0hYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4tH4Zq8WiG9uYLFZes7C4vGsOm0X39R1sFsuP/2Ny4PK43NfL5LF4z0sm
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJUx7cYztoIj
        YhWvV3xhaWCcJNjFyMkhIWAiceDaPMYuRi4OIYEdjBK9rb3MXYwcQAlpiTV7pCFqhCXutxxh
        hah5zyjR3LOXCSTBJqArcWbzS2YQWwRo0Ixb71hBbGaBy4wS089Fg9jCAuYS+9/sAouzCKhK
        /HraB2bzCthInLl4hR1igbzE6RPXGCHighInZz5hgZgjL9G8dTbzBEa+WUhSs5CkFjAyrWKU
        TC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECA5vLa0djHtWfdA7xMjEwXiIUYKDWUmE92Dz
        2gQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamPg5V5+6
        bCFwJMTA7jwDd3OnxvYmnTn+p0zu7K8rZX9lyVUaVGc8rVLK3njTLf4nG9RLH924OenYpZ8L
        zheWrStc8ePzd/Zmwe8NVo9ulT+K/CPxWeN2lPfZoLRD++PaIiyWau48uN55Oke3hZe0gF7q
        LNvC5JqjT69a/ld9Fj3NYOqsxkWnQnWCn1UHL/A/dunFc4nJh88oikq1q4fxND7YU7P/rdjH
        Y7vOMS3b4+U0KXBzxzUxe+bwwjt8k5gsbvX2n6iOlir69mHxnqJ226jf5mK2s/5LC5w7dejO
        0/0Xnkh+5P++ibmx+/oN61k7F53WEb2yYPVLu4XtzR+KJp9fkXhBd90H1l8RMXPSfycrsRRn
        JBpqMRcVJwIAwxcaq94CAAA=
X-CMS-MailID: 20210527031217epcas2p44b9d999edcc55b345dfd0749acefeaec
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210527031217epcas2p44b9d999edcc55b345dfd0749acefeaec
References: <CGME20210527031217epcas2p44b9d999edcc55b345dfd0749acefeaec@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ExynosAuto(variant of the Exynos for automotive), the UFS Storage needs
to be accessed from multi-OS.
To increase IO performance and reduce SW complexity, we implemented UFS-IOV
to support storage IO virtualization feature on UFS.

IO virtualization increases IO performance and reduce SW complexity
with small area cost. And IO virtualization supports virtual machine isolation
for Security and Safety which are requested by Multi-OS system such as
automotive application.

Below figure is the conception of UFS-IOV architeture.

    +------+          +------+
    | OS#1 |          | OS#2 |
    +------+          +------+
       |                 |
 +------------+     +------------+
 |  Physical  |     |   Virtual  |
 |    Host    |     |    Host    |
 +------------+     +------------+
   |      |              | <-- UTP_CMD_SAP, UTP_TM_SAP
   |   +-------------------------+
   |   |    Function Arbitor     |
   |   +-------------------------+
 +-------------------------------+
 |           UTP Layer           |
 +-------------------------------+
 +-------------------------------+
 |           UIC Layer           |
 +-------------------------------+

There are two types of host controllers on the UFS host controller
that we designed.
The UFS device has a Function Arbitor that arranges commands of each host.
When each host transmits a command to the Arbitor, the Arbitor transmits it
to the UTP layer.
Physical Host(PH) support all UFSHCI functions(all SAPs) same as conventional
UFSHCI.
Virtual Host(VH) support only data transfer function(UTP_CMD_SAP and UTP_TM_SAP).

In an environment where multiple OSs are used, the OS that has the leadership of
the system is called System OS. This system OS uses PH and controls error handling.

Since VH can only use less functions than PH, it is necessary to send a request
to PH for Detected Error Handling in VH. To interface among PH and VHs,
UFSHCI HW supports mailbox. PH can broadcast mail to other VH at the same time
with arguments and VH can mail to PH with arguments.
PH and VH generate interrupts when mails from PH or VH.

In this structure, the virtual host can't support some feature and need to skip
the some part of ufshcd code by using quirk.
This patchs add quirks so that the UIC command is ignored and the ufshcd init
process can be skipped for VH. Also, according to our UFS-IOV policy,
we added a quirk to the abort handler or device reset handler to call
the host reset handler.

jongmin jeong (3):
  scsi: ufs: add quirk to handle broken UIC command
  scsi: ufs: add quirk to enable host controller without interface
    configuration
  scsi: ufs: add quirk to support host reset only

 drivers/scsi/ufs/ufshcd.c | 13 +++++++++++++
 drivers/scsi/ufs/ufshcd.h | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+)

-- 
2.31.1

