Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D93C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 23:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354103AbiBKX0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 18:26:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiBKX0L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 18:26:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA68CEC
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 15:26:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BL0nCj006473;
        Fri, 11 Feb 2022 23:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=owJ3tu1/F71FBoHhBQ75b01xOXRITKgmAvGRJsslMp4=;
 b=k8lLBD2OLCZ34ic9u3rf6UC4oa2q4S++L38joKgivvXSV2RrYuZ/xrp6h+I0toS3LdF6
 5Ir2w6Des/30WHl3VapBWnuIdhS0WoELkwfJE875516on7XbaoNYnV6jtjy+a9qRoE8F
 ZnfTFbSj8De+eX7MwDNoqzPIinIdJ3SdD675arPn0MvhyC2bTvrPsQutLjbrEzrBk7FP
 MIIKOtAoUeQOdb1whjoIvoqdJlRwTYI6sDe+KakQI9Z3NR22pankV03KnQuXgaIXRW5J
 bV8JbjmUk8hIsP8bTmi/dKF3f0UQpX3SkNHYqwlmrjW8vHHZWsbzjmfAJh+Wb4JKIQd0 rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5t7ks49j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 23:25:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BNG0Sn054981;
        Fri, 11 Feb 2022 23:25:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e1ec86pu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 23:25:52 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21BNPqED061329;
        Fri, 11 Feb 2022 23:25:52 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e1ec86ptw-1;
        Fri, 11 Feb 2022 23:25:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        baijiaju1990@gmail.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: Re: [PATCH 1/1] scsi: qedi: Fix ABBA deadlock in qedi_process_tmf_resp() and qedi_process_cmd_cleanup_resp()
Date:   Fri, 11 Feb 2022 18:25:50 -0500
Message-Id: <164462194053.7779.9294330933500010000.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220208185448.6206-1-michael.christie@oracle.com>
References: <20220208185448.6206-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: y_22jFqTu0l_hLK8dojgcxuIyJRvIng4
X-Proofpoint-ORIG-GUID: y_22jFqTu0l_hLK8dojgcxuIyJRvIng4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Feb 2022 12:54:48 -0600, Mike Christie wrote:

> This fixes a deadlock added with:
> commit b40f3894e39e ("scsi: qedi: Complete TMF works before disconnect")
> 
> Bug description from Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> qedi_process_tmf_resp()
>   spin_lock(&session->back_lock); --> Line 201 (Lock A)
>   spin_lock(&qedi_conn->tmf_work_lock); --> Line 230 (Lock B)
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] scsi: qedi: Fix ABBA deadlock in qedi_process_tmf_resp() and qedi_process_cmd_cleanup_resp()
      https://git.kernel.org/mkp/scsi/c/f10f582d2822

-- 
Martin K. Petersen	Oracle Linux Engineering
