Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F0FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 06:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C548320708
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 06:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fT/BFVVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgGIG3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 02:29:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59620 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgGIG3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 02:29:32 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200709062928epoutp013a109485f66ba10e09487ace71450e87~gAbp5h2Yl1681416814epoutp01S
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 06:29:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200709062928epoutp013a109485f66ba10e09487ace71450e87~gAbp5h2Yl1681416814epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594276168;
        bh=sx1LS5HeXatlBJpXSTM9PrX5rpdQN2lvWxpV0N4/ogY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fT/BFVVKrJY3HBI48crUV8km004XwowjgpuN3lM8HiWFhETR7oXqefOCxxsbBxGJW
         zgiY//q7cavaBzrtpSV1I+0dEwqK2bzro7HS8pa4SzJnMXaZRb5nwgU8d9Ef//+xlt
         lur7J1L8WPuRM5iG5iqslAknMNHq7wKun8LdFghE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200709062927epcas2p3382c881f582cd984373515e85242f53d~gAbpaU1EW3074630746epcas2p3X;
        Thu,  9 Jul 2020 06:29:27 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B2R925M4BzMqYkv; Thu,  9 Jul
        2020 06:29:26 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.B3.27441.649B60F5; Thu,  9 Jul 2020 15:29:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200709062926epcas2p1ecedcc07c6fd502a4335007418e982c2~gAbn0hmye2725027250epcas2p1W;
        Thu,  9 Jul 2020 06:29:26 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200709062926epsmtrp165c41ab3367053472b0338e0cfd7f3fe~gAbnzxnJ42275322753epsmtrp1G;
        Thu,  9 Jul 2020 06:29:26 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-ab-5f06b94624ba
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.DC.08303.649B60F5; Thu,  9 Jul 2020 15:29:26 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200709062925epsmtip12d8201984af49e8184a4e4afdcbb5004~gAbnjC7100782307823epsmtip1O;
        Thu,  9 Jul 2020 06:29:25 +0000 (GMT)
From:   Lee Sang Hyun <sh425.lee@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        kwmad.kim@samsung.com
Cc:     Lee Sang Hyun <sh425.lee@samsung.com>
Subject: [RFC PATCH v1] scsi: ufs: set STATE_ERROR when ufshcd_probe_hba()
 failed
Date:   Thu,  9 Jul 2020 15:21:30 +0900
Message-Id: <1594275690-19896-1-git-send-email-sh425.lee@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTQtdtJ1u8Qc8nFYsH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        KscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+huJYWy
        xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVC
        TkbfxGWMBQ/YKibsOcjUwPiYtYuRk0NCwERi8fX/bF2MXBxCAjsYJf6dP8MO4XxilJjdNxGs
        SkjgM6PE3740mI6my53MEEW7GCU+P57FAuH8YJS4/n8hWAebgLbE3WuzwEaJCGxmklgzZylY
        gllAU2LKrwPMILawQLDEx+NbwWwWAVWJuXMmMIHYvAKuEid6+1gg1slJ3DwHsU5C4Ce7xOOu
        n+wQCReJP+fuM0PYwhKvjm+BiktJvOxvg7LLJXb3XWWDaG5hlHi/dhNUg7HErGftjF2MHGAX
        rd+lD2JKCChLHLnFAnEnn0TH4b/sEGFeiY42IYhGZYkz79ZCTZeUeNi6iQnC9pCYN+c2CyS0
        YiX+PL/JOoFRdhbC/AWMjKsYxVILinPTU4uNCoyRY2kTIzgxarnvYJzx9oPeIUYmDsZDjBIc
        zEoivAaKrPFCvCmJlVWpRfnxRaU5qcWHGE2B4TWRWUo0OR+YmvNK4g1NjczMDCxNLUzNjCyU
        xHmLrS7ECQmkJ5akZqemFqQWwfQxcXBKNTBNutn1XeTdNKNWp/mvHB/mvq63bf3OqhXzf6dB
        2WLXKzf6eZMe/Nn12VL4mrN51OdlsjaJ0jm8TVHftwqI2Pax/C+LPLb2nXGCfIzv9D18V/rX
        5j5s1BTTev6c/c70xeUVT6cZHRW6+Gd166eTe8/s9v8oFmPZKFaryszoes1nrg6vh12RjY22
        f3Gtc7qMj53EhD9LFh1e+v235dnzx55kJZuLKjt3bdwmkyK6KbtYbPnho+yVR+4cii8zCXn4
        uC7i6ASv9RHt1yzufFZeurJddMuZhU5HQq+wPeh+qpp5LTP2qEWEv4nDrrQ7wud/7T3Rs6+5
        bcaUvt1ai083/7/N8uDGb4klgTd8+ifo7L2gxFKckWioxVxUnAgA6KixJxUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnK7bTrZ4g+P/OC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MvonLGAsesFVM2HOQqYHxMWsXIyeHhICJRNPlTuYuRi4OIYEdjBI7
        z7YyQyQkJSZeamKEsIUl7rccAWsQEvjGKPF8XxqIzSagLXH32ix2kGYRgcNMEou77rCDJJgF
        NCWm/DoANkhYIFBi3Zp9YINYBFQl5s6ZwARi8wq4Spzo7WOBWCAncfNcJ/MERp4FjAyrGCVT
        C4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCA1VLawfjnlUf9A4xMnEwHmKU4GBWEuE1UGSN
        F+JNSaysSi3Kjy8qzUktPsQozcGiJM77ddbCOCGB9MSS1OzU1ILUIpgsEwenVANTdMCcSYyH
        /JsNOCOObTcJ7Ng2Ny5ZRG2mQ49E4sIeD0OfhRsuz3+zLum0qJLNfr68j7tmyRdFf/r6e2/Z
        scsh7VorQtgZbieen7xin8GMvY0ct3ksY33cVnbIrlxVcKj4Ymy14//5AS/PHXB+0WO05nzL
        hOZJcR/y0u0jV2gFML+UmZrxzLCzfYfgh6bLn9eWdW26cVzW/RezAPud2S4bBG/deVWTmdV7
        yv3/7X0uRlohHnPD7b81rpSW9uPlcbx27qhO5LGjn78v2ls73XyB1YJMgUNX9Cp3m+mYb/t7
        cWfmjgXzftw7k1/+o/m+VPv3BQ5Rr2weuogd7A2dJqv+UktCiz1F/0Pz2xnnn889osRSnJFo
        qMVcVJwIAKRqEYTDAgAA
X-CMS-MailID: 20200709062926epcas2p1ecedcc07c6fd502a4335007418e982c2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200709062926epcas2p1ecedcc07c6fd502a4335007418e982c2
References: <CGME20200709062926epcas2p1ecedcc07c6fd502a4335007418e982c2@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

set STATE_ERR like below to prevent a lockup(IO stuck)
when ufshcd_probe_hba() returns error.

Change-Id: I6c85ff290503cc9414d7f5fdd934295497b854ff
Signed-off-by: Lee Sang Hyun <sh425.lee@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ad4fc82..9780a5a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7439,6 +7439,11 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	ufshcd_auto_hibern8_enable(hba);
 
 out:
+	if (ret) {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 
 	trace_ufshcd_init(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
-- 
2.7.4

