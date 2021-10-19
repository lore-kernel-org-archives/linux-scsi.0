Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B712C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 238236134F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhJSDqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 23:46:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20124 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhJSDqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 23:46:00 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J35s9u015253;
        Tue, 19 Oct 2021 03:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Ym0DfS2vstttOqURbtihOgx37e/bdCDgBgJQsbAIPe4=;
 b=KzOl2ntW60Htu1vwtzscongcySuM5wi/2IE4/E//fX+ClzJ04RvCEhxYBoUyR96ucR4Z
 WFP/GvoKqMHZyoPpK0e04w+t1AFA0VJb3tBRuY/S7I/PT7O1xFQ7V6WSoJFHo5kRUsXS
 PM0rHX/zuM8tMROEPTz5dRGPz53RVlfgNlNcFTjuaCZNhDAnLrquWwQoJ6q0JJjjT/Mk
 34Hdr1e11AYJcWhnxCvF/ODOm6lEh1VQsUXBD3N+j+9j14Hg2yj87QNpsMyTA9PKlg2u
 RzZMWj3Qv6ivV0bklNdS4psH7OuERm4yq8pZJS0gzA4x9j2rSFjNC9uWNBtxBw5S6Ynp +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brnfhqskg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J3ZTWF076978;
        Tue, 19 Oct 2021 03:43:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3br8grmmsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:44 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19J3hhHb101685;
        Tue, 19 Oct 2021 03:43:44 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3br8grmmrp-2;
        Tue, 19 Oct 2021 03:43:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux@yadro.com, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: qla2xxx: fix unmap already freed sgl
Date:   Mon, 18 Oct 2021 23:43:38 -0400
Message-Id: <163461411522.13664.14338939098003090041.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018122650.11846-1-d.bogdanov@yadro.com>
References: <20211018122650.11846-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: vIsEl5_Ad23SS1ZLGkEx7U1gKZUGDlND
X-Proofpoint-GUID: vIsEl5_Ad23SS1ZLGkEx7U1gKZUGDlND
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 15:26:50 +0300, Dmitry Bogdanov wrote:

> sgl is freed in the target stack in target_release_cmd_kref before
> calling qlt_free_cmd, but there is an unmap of sgl in qlt_free_cmd that
> causes such a panic if sgl is not yet DMA unmapped:
> 
> NIP dma_direct_unmap_sg+0xdc/0x180
> LR  dma_direct_unmap_sg+0xc8/0x180
> Call Trace:
>  ql_dbg_prefix+0x68/0xc0 [qla2xxx] (unreliable)
>  dma_unmap_sg_attrs+0x54/0xf0
>  qlt_unmap_sg.part.19+0x54/0x1c0 [qla2xxx]
>  qlt_free_cmd+0x124/0x1d0 [qla2xxx]
>  tcm_qla2xxx_release_cmd+0x4c/0xa0 [tcm_qla2xxx]
>  target_put_sess_cmd+0x198/0x370 [target_core_mod]
>  transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
>  tcm_qla2xxx_complete_free+0x6c/0x90 [tcm_qla2xxx]
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: fix unmap already freed sgl
      https://git.kernel.org/mkp/scsi/c/4a8f71014b4d

-- 
Martin K. Petersen	Oracle Linux Engineering
