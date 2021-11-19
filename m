Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D0AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCE2A61B95
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhKSET6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:19:58 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14412 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233817AbhKSET5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:19:57 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2eTNS000713;
        Fri, 19 Nov 2021 04:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=9lOWH7dro7SD39ZLoBgnZ4Awgb9eK1eQbBtyDxRMCUY=;
 b=Pl4wfyHV67BJ2bHFiOKeeOo2N0Vow9dOKlb3/bsDMy01kxGPiUFZMOY5mbZFZLs5DjjQ
 Rq5IgKx6xWULpaTZdtWXM1o/srXdMaRKFaO027XEss7PplhpFD0z72OGK1cA4IHSMeGE
 OUsxABgvcJlQojvTHxUN6dj9hC45u3GvlBz0oZ3wuXaemyxKByqwgkwuXu7xVAg9hC/m
 4tpTFhiNoqbfmMDzEt7tnsHSgcppb/1GMB8Q55khOCTsGZOGCsTkKjXg0rXdfzz0q4+2
 4ztyCZVa8JJrAadk0YfdFZb54/yZy1dvjE1waVkoxw5UDev2b2p3waYCqW8uskQ5pfjE 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd205mjq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBQH020345;
        Fri, 19 Nov 2021 04:16:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:52 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwW024731;
        Fri, 19 Nov 2021 04:16:52 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-9;
        Fri, 19 Nov 2021 04:16:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] target: Use RCU helpers for INQUIRY t10_alua_tg_pt_gp use
Date:   Thu, 18 Nov 2021 23:16:38 -0500
Message-Id: <163729506338.21244.4965472814117566098.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117213928.8634-1-michael.christie@oracle.com>
References: <20211117213928.8634-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: KxamcgaLuuf5LFjSwIFdx6GdmgNosqvz
X-Proofpoint-GUID: KxamcgaLuuf5LFjSwIFdx6GdmgNosqvz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Nov 2021 15:39:28 -0600, Mike Christie wrote:

> This fixes the sparse warnings about t10_alua_tg_pt_gp accesses in
> target_core_spc.c from:
> 
> commit 7324f47d4293 ("scsi: target: Replace lun_tg_pt_gp_lock with rcu in
> I/O path")
> 
> That patch replaced the lun_tg_pt_gp_lock use in the IO path, but didn't
> update the INQUIRY code.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] target: Use RCU helpers for INQUIRY t10_alua_tg_pt_gp use
      https://git.kernel.org/mkp/scsi/c/e2a49a95b571

-- 
Martin K. Petersen	Oracle Linux Engineering
