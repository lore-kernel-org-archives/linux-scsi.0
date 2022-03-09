Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3945CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 04:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiCIEPZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 23:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiCIEPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 23:15:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FE93B3FA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 20:14:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M8nXh016933;
        Wed, 9 Mar 2022 04:14:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=/6Ysi2CebJ1XvD8o8lhDRVlspr6eQ2oll8TKMDmSKZ4=;
 b=BUjxicALfYrEbcfUnQ++QUq8Znz4J+ClalcysR7HzkO2nZpDQxoEU2UYke5YssiYh8Hi
 pCger71aODwA/MtMNN1d9un45IY3gXewtchvlXwAm5r21/w3No3eAhScGvkxBnSr0CZ3
 YoZDQdkWre2u6/EeO5gOwoanyw1gJ70jxPPkcyd5A7V2vBftV4/k+bufZ6En7HS+GM+K
 927oFJNV4+4xZUL7ScpLrKjHRdRxKztHLkZCX26YfvKTtxGrlKej4t3NHGm3sDRU1obq
 7wgM037fSDqLmmW5GYAk9xyGe/YJAhLbfhF2upADwWFHm7zGUaFBn6ok26/iKYmHDLzc YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cgq0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22947fYf167672;
        Wed, 9 Mar 2022 04:14:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qddy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:11 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2294EAeH174884;
        Wed, 9 Mar 2022 04:14:10 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qddd-2;
        Wed, 09 Mar 2022 04:14:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] lpfc: fixes for EH rework
Date:   Tue,  8 Mar 2022 23:14:06 -0500
Message-Id: <164679903743.29335.4023128510996822326.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220301143718.40913-1-hare@suse.de>
References: <20220301143718.40913-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: FW39Ke2s6H7tjwcqmM0fxWjLssi8HM5u
X-Proofpoint-GUID: FW39Ke2s6H7tjwcqmM0fxWjLssi8HM5u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 1 Mar 2022 15:37:13 +0100, Hannes Reinecke wrote:

> in preparation to the SCSI EH rework here's a bunch of patches to
> the lpfc driver to make the conversion easier.
> 
> As usual, comments and reviews are welcome.
> 
> Hannes Reinecke (5):
>   lpfc: kill lpfc_bus_reset_handler
>   lpfc: drop lpfc_no_handler()
>   lpfc: use fc_block_rport()
>   lpfc: use rport as argument for lpfc_send_taskmgmt()
>   lpfc: use rport as argument for lpfc_chk_tgt_mapped()
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/5] lpfc: kill lpfc_bus_reset_handler
      https://git.kernel.org/mkp/scsi/c/bf180cc1a5da
[2/5] lpfc: drop lpfc_no_handler()
      https://git.kernel.org/mkp/scsi/c/45c59287ff01
[3/5] lpfc: use fc_block_rport()
      https://git.kernel.org/mkp/scsi/c/bb21fc9911ee
[4/5] lpfc: use rport as argument for lpfc_send_taskmgmt()
      https://git.kernel.org/mkp/scsi/c/123a3af35d08
[5/5] lpfc: use rport as argument for lpfc_chk_tgt_mapped()
      https://git.kernel.org/mkp/scsi/c/e81ce97f5716

-- 
Martin K. Petersen	Oracle Linux Engineering
