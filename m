Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4B9C7C88A
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4F622071C
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VOmc3LHo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgDZRm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 13:42:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33754 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgDZRmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 13:42:11 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200426174208epoutp039c9d8d0b15679e7543dbc86006341bd0~Jb32P2x8N1070010700epoutp03C
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:42:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200426174208epoutp039c9d8d0b15679e7543dbc86006341bd0~Jb32P2x8N1070010700epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587922928;
        bh=aZlGHc5xTiWwAyuHWOUJ6KyldBblFcw6DUpelUfBEa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOmc3LHoAnPsiadpW7uP+lCjMtCYSBCCBDPIIkpvsm9fEIDaxUtj6QNC46v370J3E
         rZAXdEADaNTjmFRL0OsB9uCG/gjBWQeiRu64QFY5a1K+YXn8qbHQi6U0Hsv24rfStB
         Rw0fYq+QlSdhA52J/6emYgEJyra3Jet+kNePj2dY=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200426174207epcas5p10a309a64b0f5750ce88bb96dc0bdf155~Jb31MDWiv1407714077epcas5p1d;
        Sun, 26 Apr 2020 17:42:07 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.42.04782.FE7C5AE5; Mon, 27 Apr 2020 02:42:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200426174206epcas5p3a948de27f9eaa9256e4c3de5294ce234~Jb30pQwcz0554805548epcas5p3H;
        Sun, 26 Apr 2020 17:42:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200426174206epsmtrp23798bc6229183f6ec1745eedcd4a91c9~Jb30oe4qx1150211502epsmtrp2V;
        Sun, 26 Apr 2020 17:42:06 +0000 (GMT)
X-AuditID: b6c32a49-89bff700000012ae-4e-5ea5c7ef35ad
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.DC.25866.EE7C5AE5; Mon, 27 Apr 2020 02:42:06 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200426174204epsmtip1d26c5ef798b311816760ad027e3ccd9c~Jb3yxOH9D2626126261epsmtip1h;
        Sun, 26 Apr 2020 17:42:04 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v7 02/10] scsi: ufs: add quirk to disallow reset of
 interrupt aggregation
Date:   Sun, 26 Apr 2020 23:00:16 +0530
Message-Id: <20200426173024.63069-3-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426173024.63069-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSa0hTYRjHec/OOR6Hi9Mm9KSZtVBTyUslnQ9eCiSOIGHfwrw09KCmm7JN
        zQqUFG/LWxc0G1OkmZqXNZfJtDQzZwkamFcQrBmSlaKD0CyteRZ9+z3v8/+//+d5eSmBuIpw
        o9IUak6pkGVISSHe89rX58SaRZ8Q1Fl7iFnU9ZDMl60pktnoaiaYhuFxgpmYMDgxc6Y3OGO0
        ThPMpFlLMnUTLzFGM9NLMo8tOxiz29/rxOifzaGzInaysgJjjW1lJNv9KJ8tejuAs+uf53G2
        0tSGWJvxMFsyqMFiqFhhaDKXkZbDKQPDrwhTe/pWyax5l2vVlnlBAZoUliOKAvo0mMbwciSk
        xHQfAnNzFcEXGwiWxsyOjg3B6NLvv4XznmO26CPJN8wIlkcGEF8UYfB08C5mV5G0PyzUmvbY
        lZbA8I9iZGcBPYvBYmuknSX0ZdiemibsjNNeYF3swO0ziehQsBo8+DBPeGIYFNjZmQ6Dd3Vm
        zJ4FdBkFMw+NJC+KBN2rUcd0ElixmJx4dgPb6guS3zMdbptP8cc3Qa8bccgjYPCDdi9WQPtC
        lzmQn3IfVGwvYbxTBKXFYl7tBYWrUw6nO9RoNATPLKx+1TiepBpBvUXjVI086v/f2ohQGzrI
        ZankKZwqJCtYweUGqGRyVbYiJSApU25Ee9/EL6oX1Y9HDyGaQlIXEfVcnyAmZDmqPPkQAkog
        dRXFqZsSxKJkWd51TpmZqMzO4FRDyJ3CpQdEd4ipODGdIlNz6RyXxSn/dTHK2a0ADbC2tMIH
        2RC9aV1hdJ7T5/t/9kd4d8bfC23dbDkeHut9Q31rTTtZoDiH7dRs+SeuoyC3GTZkf5ouu2PZ
        p6NQnyQtMZRcCGtv1mqPtBzFLQvqi1GNzqnf4oeuxiS1H/sE72Pk+d0XS8+s9+klu7l0k+t3
        SYPi/klzAYRd+hUqxVWpsmA/gVIl+wMz2aM0IgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSnO6740vjDHp6zSwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxrbd79gKbvFUTDh+i7mB8TJXFyMnh4SAicSNlodsXYxcHEICOxgldt59xgyR
        kJa4vnECO4QtLLHy33N2iKImJonTK/qZQBJsAtoSd6dvAbNFgIqOfGtjBLGZBZ4xSZx6WApi
        CwtESkxefZAVxGYRUJV4/GAtSxcjBwevgI3E4w2yEPPlJVZvOAC2l1PAVuLUjF1MICVCQCXT
        1/tPYORbwMiwilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOJS1tHYw7ln1Qe8QIxMH
        4yFGCQ5mJRHemJJFcUK8KYmVValF+fFFpTmpxYcYpTlYlMR5v85aGCckkJ5YkpqdmlqQWgST
        ZeLglGpgEt13v9RrZVn3dm/LWiPR5Ws5K+ufzNXarml+oWbl5cm7f0zhWC4hsexXz5nt3f35
        Ih+uWy5uv1vNGrrVuu14xU6BZhYZ+93Xpj3ZGvxvCteUOs7PU+TPVh18NpXF1FU4gq1T/E/q
        pFl59c+XaTj/tL2pb3+UR8zrVtanGS37bnn+7Pi3x6hB4dHvgAXbpj+aVR6+3CZuh4V75LZt
        BQK12it/pT+S5fm97epWoXhBlQcqzKfOhBVVRGYEaomcO9Lpcihz58EU1bTqTw/YxGS+1lob
        zeALFzP/ek3trlqy7GqZZ++27Ap2jD2+ua/TI1HV0M78+NSi3e03N9tOepl05dezA7sWBPV0
        PZZt8eKepcRSnJFoqMVcVJwIAPgHnWrUAgAA
X-CMS-MailID: 20200426174206epcas5p3a948de27f9eaa9256e4c3de5294ce234
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174206epcas5p3a948de27f9eaa9256e4c3de5294ce234
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174206epcas5p3a948de27f9eaa9256e4c3de5294ce234@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some host controllers support interrupt aggregation but don't allow
resetting counter and timer in software.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3655b88fc862..0e9704da58bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4884,7 +4884,8 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if (ufshcd_is_intr_aggr_allowed(hba) &&
+	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 071f0edf3f64..53096642f9a8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -523,6 +523,12 @@ enum ufshcd_quirks {
 	 * Clear handling for transfer/task request list is just opposite.
 	 */
 	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
+
+	/*
+	 * This quirk needs to be enabled if host controller doesn't allow
+	 * that the interrupt aggregation timer and counter are reset by s/w.
+	 */
+	UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		= 1 << 7,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

