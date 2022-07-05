Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06403CCA47B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 08:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiGEIDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 04:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGEIDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 04:03:23 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A31DDEE
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 01:03:21 -0700 (PDT)
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220705080319epoutp0399d3b1474ebc954812ad22e9eca3198c~_4C2dEXkr3207032070epoutp03Y
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 08:03:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220705080319epoutp0399d3b1474ebc954812ad22e9eca3198c~_4C2dEXkr3207032070epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657008199;
        bh=SB+WhI9riM/RcOYss5fma4o7B12j8Y5GUVJZu97RgHE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=kWsNkCsGq9hpQZSl1CTRy0rkh3JYvIvxzoR1jL/It69l2T7xrY2o8kWAD4HfPyUPX
         p4z/V5AohAJ5Ik56rfVh752B1VWnFF3niKPFiRLFizKFe6MBcumkIMXhvnnTxoBALU
         OPSLkOzB4YiTtOgHIUsc3DA6kbyKx9EWZvpqeR/U=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20220705080319epcas1p4f752c0edc44162473f0885c5ac78490c~_4C2M_3AG2788627886epcas1p4H;
        Tue,  5 Jul 2022 08:03:19 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.38.250]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LcZtG5rp5z4x9Pq; Tue,  5 Jul
        2022 08:03:18 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.F4.09657.640F3C26; Tue,  5 Jul 2022 17:03:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220705080318epcas1p18896b13b2f7ad16509d7047584f1fe86~_4C1j7Q0j0036700367epcas1p1A;
        Tue,  5 Jul 2022 08:03:18 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220705080318epsmtrp17938a5a3f70600d51e8d8b1789e1787d~_4C1jA6B80844708447epsmtrp1e;
        Tue,  5 Jul 2022 08:03:18 +0000 (GMT)
X-AuditID: b6c32a35-71dff700000025b9-28-62c3f0466722
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.D0.08802.640F3C26; Tue,  5 Jul 2022 17:03:18 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.71]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220705080318epsmtip11441c8caa1af0f7c71f67ade5e54fd6e~_4C1Zj_bi0645206452epsmtip1K;
        Tue,  5 Jul 2022 08:03:18 +0000 (GMT)
From:   Seunghui Lee <sh043.lee@samsung.com>
To:     linux-scsi@vger.kernel.org, avri.altman@wdc.com
Cc:     Seunghui Lee <sh043.lee@samsung.com>,
        Junwoo Lee <junwoo80.lee@samsung.com>
Subject: [PATCH v2] scsi: ufs: skip last hci reset to get valid register
 values
Date:   Tue,  5 Jul 2022 17:35:38 +0900
Message-Id: <20220705083538.15143-1-sh043.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7bCmrq7bh8NJBpPm6Vq8/HmVzWLX32Ym
        i+7rO9gsmv7sY3Fg8ejbsorR4/MmOY/2A91MAcxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7x
        pmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QNuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZK
        qQUpOQVmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZH7bXFSwVqlj/X6CB8QtfFyMnh4SAiUTT
        m1bWLkYuDiGBHYwS3V//M0M4nxglLp1rZINwPjNK/J1wgwWmZcLbT+wQiV2MEq+W3EGo2v/k
        HBNIFZuAlsT0TVuAbA4OEQFjiQ1d2iBhZoFAia3/TrCC2MJA9s/L89hAbBYBVYnWPzeZQWxe
        ASuJWW2zWCGWyUv8ud8DFReUODnzCQvEHHmJ5q2zwU6VEFjFLvGh/TwzRIOLxO/zR6FsYYlX
        x7ewQ9hSEi/726DsYom2f/+gaiokDvZ9gbKNJT59/swIcjOzgKbE+l36EGFFiZ2/5zJC7OWT
        ePe1hxWkREKAV6KjTQiiRFni5aNlTBC2pMSS9ltQEz0kJvbcAtsqJBAr8evYVMYJjPKzkHwz
        C8k3sxAWL2BkXsUollpQnJueWmxYYAiP0uT83E2M4OSmZbqDceLbD3qHGJk4GA8xSnAwK4nw
        rpp0MEmINyWxsiq1KD++qDQntfgQoykwfCcyS4km5wPTa15JvKGJpYGJmZGJhbGlsZmSOO+q
        aacThQTSE0tSs1NTC1KLYPqYODilGpiaiwJ3irOynPfwkZyT91hwrsnN8CWfnq44ePLoUmst
        j81yYXeXf/VZYv/L7dqyO8ckXfjfn2rr3pjYe99wXUGC33bl/JhvktsOH7rv7eh/8+P1s4de
        9FzzXi5dwWzMFTOpqKincnp907adHJKW50KmvVJZ5/rRTbTPV/azwDLnj8/ucWq3nnM5/720
        8ufl0DOP1F6VHb8WsdJCz/D6wZuL9Gq2PvzHcz7QoDzKo1/hb8GPRF+R+qa3AYo5+/J57tRM
        vVlbYf7/m+n/NreA+CajKqZzEq5Hfhv6HS2qC3+tuq9Ezb+wOvXflO96+ibeBbl/d0zv5bZb
        6+3B6SX6xdhNentr4nKGtoKckF/zriixFGckGmoxFxUnAgCsC0xM9wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsWy7bCSnK7bh8NJBvObxS1e/rzKZrHrbzOT
        Rff1HWwWTX/2sTiwePRtWcXo8XmTnEf7gW6mAOYoLpuU1JzMstQifbsErowP2+sKlgpVrP8v
        0MD4ha+LkZNDQsBEYsLbT+xdjFwcQgI7GCU27f/JApGQlFj86CFbFyMHkC0scfhwMUTNR0aJ
        78u7GEFq2AS0JKZv2sIEYosImErc/7ScHcRmFgiUmNrcAFYjLOAvMWPdSrAaFgFVidY/N5lB
        bF4BK4lZbbNYIXbJS/y53wMVF5Q4OfMJC8QceYnmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56
        brFhgVFearlecWJucWleul5yfu4mRnC4aWntYNyz6oPeIUYmDsZDjBIczEoivKsmHUwS4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1Oqgcni65aCZjvtP3mT
        2jpuHZy7TG6OaqtPBIdY64+lvz/5zjqsuVHy2uvrEx8G2L5zCT669/Dq0K7OBRuXXwzbuTpv
        2YHm7iv+KS2q0t8qNhf0Rk5ryvp6cm689eITm0RfuxQVnGB2+Bx+oqt9W5jSnZkfjoQIr5J7
        a/Vr/yX/X8qLverLvBQkF5/Tq147d+PUlVeT9X92ft83YdGsYoN+x5qQOHUPo+uqOt2hF09F
        iLBp+C8q3byktDjr3PQ/QhnTb/UuTzCpmLCHqX3+z9931pU1WK7NrLnLKhb/11bicNffdA+X
        xl9H2pr7V8vWdJYVWzw4u20ft8auHyqJ7z6fmzu9ZEr8l+9no/l0UqoClksqsRRnJBpqMRcV
        JwIAoTHIoqYCAAA=
X-CMS-MailID: 20220705080318epcas1p18896b13b2f7ad16509d7047584f1fe86
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220705080318epcas1p18896b13b2f7ad16509d7047584f1fe86
References: <CGME20220705080318epcas1p18896b13b2f7ad16509d7047584f1fe86@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Once the host fails to link startup 3 times, all host registers are reset value
except ufshcd_hba_enable after linkstartup failure.

The ufs host controller is disabled and enabled in the ufshcd_hba_enable().
That's why we need to skip last hci reset to get valid host register values.

e.g.
[    1.898026] [2:  kworker/u16:2:  211] ufs: link startup failed 1
[    1.898133] [2:  kworker/u16:2:  211] host_regs: 00000000: 1383ff1f 00000000 00000300 00000000
[    1.898141] [2:  kworker/u16:2:  211] host_regs: 00000010: 00000106 000001ce 00000000 00000000
[    1.898148] [2:  kworker/u16:2:  211] host_regs: 00000020: 00000000 00000470 00000000 00000000
[    1.898155] [2:  kworker/u16:2:  211] host_regs: 00000030: 00000008 00000003 00000000 00000000
[    1.898163] [2:  kworker/u16:2:  211] host_regs: 00000040: 00000000 00000000 00000000 00000000
[    1.898171] [2:  kworker/u16:2:  211] host_regs: 00000050: 00000000 00000000 00000000 00000000
[    1.898177] [2:  kworker/u16:2:  211] host_regs: 00000060: 00000000 00000000 00000000 00000000
[    1.898186] [2:  kworker/u16:2:  211] host_regs: 00000070: 00000000 00000000 00000000 00000000
[    1.898194] [2:  kworker/u16:2:  211] host_regs: 00000080: 00000000 00000000 00000000 00000000
[    1.898201] [2:  kworker/u16:2:  211] host_regs: 00000090: 00000000 00000000 00000000 00000000
All host registers(standard special function register) are reset value except
ufshcd_hba_enable after linkstartup failure.

Signed-off-by: Junwoo Lee <junwoo80.lee@samsung.com>
Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>

---
v1->v2:
* modify the commit log and add problematic log
---
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7c1d7bb9c579..2cdc14675443 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4753,7 +4753,7 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 		 * but we can't be sure if the link is up until link startup
 		 * succeeds. So reset the local Uni-Pro and try again.
 		 */
-		if (ret && ufshcd_hba_enable(hba)) {
+		if (ret && retries && ufshcd_hba_enable(hba)) {
 			ufshcd_update_evt_hist(hba,
 					       UFS_EVT_LINK_STARTUP_FAIL,
 					       (u32)ret);
-- 
2.29.0

