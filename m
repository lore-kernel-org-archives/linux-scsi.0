Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59AAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB31761B54
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhKSET5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:19:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12952 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233654AbhKSET4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:19:56 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2rQj4000706;
        Fri, 19 Nov 2021 04:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=v3RwqUrLN5bpz9hv7DxnsbhHvuFydcUtEIQk1vN9GJ8=;
 b=PWwWRKqoZ5Q7U1I7rlT5m7RT5W2Gf2Zo1r6Tc7RXdsY/E3mdO/SIaYihw/qGBRTLWJsm
 myY97QHyDfrWy/732kOdUFNS2DGVd2251Vd1ozQClvp9Jaww3mQ+LG286AO8DXc/tX06
 CfglKGt94zH2GRmU4BOz4oQmCx0P/uHE/KUg3MSTkqjoS4pvJwEAgnOgTgEQ+FcUYbsY
 s7zh+kRCdPcb4s99CYDJfLCDwYPc3XD+59DrtWQVBnkdY5IR43p8N7M8mvOPoZz/ix1A
 UhMCTQbMmwdJAjW+rbqNWMfNKgitcsWWWQmvXbRaDY0KB9qp8dPBakFLT+ZA5njuJ2/k QA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd205mjpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FAl5020296;
        Fri, 19 Nov 2021 04:16:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:50 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwS024731;
        Fri, 19 Nov 2021 04:16:50 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-7;
        Fri, 19 Nov 2021 04:16:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     gregkh@linuxfoundation.org, dgilbert@interlog.com,
        jejb@linux.ibm.com, George Kennedy <george.kennedy@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 linux-next] scsi: scsi_debug: fix type in min_t to avoid stack OOB
Date:   Thu, 18 Nov 2021 23:16:36 -0500
Message-Id: <163729506337.21244.16949206676665346595.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1636484247-21254-1-git-send-email-george.kennedy@oracle.com>
References: <1636484247-21254-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: t4LzSNzY8_eqn8CNVZozU1Tl8joDLHOY
X-Proofpoint-GUID: t4LzSNzY8_eqn8CNVZozU1Tl8joDLHOY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Nov 2021 13:57:27 -0500, George Kennedy wrote:

> Change min_t() to use type "u32" instead of type "int" to
> avoid stack out of bounds. With min_t() type "int" the values get
> sign extended and the larger value gets used causing stack out of bounds.
> 
> BUG: KASAN: stack-out-of-bounds in memcpy include/linux/fortify-string.h:191 [inline]
> BUG: KASAN: stack-out-of-bounds in sg_copy_buffer+0x1de/0x240 lib/scatterlist.c:976
> Read of size 127 at addr ffff888072607128 by task syz-executor.7/18707
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: fix type in min_t to avoid stack OOB
      https://git.kernel.org/mkp/scsi/c/36e07d7ede88

-- 
Martin K. Petersen	Oracle Linux Engineering
