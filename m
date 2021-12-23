Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C380BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 05:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhLWFJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Dec 2021 00:09:27 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64612 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhLWFJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Dec 2021 00:09:27 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0jxEP026367;
        Thu, 23 Dec 2021 05:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=mvp7dTM7haJwAmjT7x8arZjV4YjXa8G/LyOv8Cpc4U0=;
 b=0WiTJw85XXYz0+xNJlzc7BgvrY2N457OhIy6H0URygiE1ksyH+aGQ+sWCoXbYabPbqzX
 Ur+ii+erCkjbE8kpkt1HjQj0yQxhMf6Ax6hQOh3tTW35xdlTGE/fMWOrmO5uNAZ08RNm
 r7MXYTcuyzrUyzayhHwF1cvQsfvxdG6xZo59azum6QX7D2VgQH7vZxje54ybdxD6Gg0n
 VAv8lL4QXNc77sPTV0RD6rc7GPYdkqWlCL50afFD7OAsP/2/dKbjzLI317al3Qigr17c
 8n5IS2DuNzuLYpAgITLqRVlvb6hBdaaf7WZKVBTp152Lj61VA5s9Bw4oXDdHo4XEb2j7 jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d4103a1f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:09:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN511gr070356;
        Thu, 23 Dec 2021 05:09:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3d15pfm5u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:09:01 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BN58xaE091703;
        Thu, 23 Dec 2021 05:09:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3d15pfm5se-3;
        Thu, 23 Dec 2021 05:09:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, linux-scsi@vger.kernel.org,
        lixiaokeng <lixiaokeng@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linfeilong <linfeilong@huawei.com>
Subject: Re: [PATCH] libiscsi: fix UAF when iscsi_conn_get_param and iscsi_conn_teardown concurrent
Date:   Thu, 23 Dec 2021 00:08:57 -0500
Message-Id: <164023593111.32381.6375909663927929473.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <046ec8a0-ce95-d3fc-3235-666a7c65b224@huawei.com>
References: <046ec8a0-ce95-d3fc-3235-666a7c65b224@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: rVXMDvESL1RN5PQiVcrLcxM9Srp_9UDq
X-Proofpoint-GUID: rVXMDvESL1RN5PQiVcrLcxM9Srp_9UDq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Dec 2021 19:39:06 +0800, lixiaokeng wrote:

> |- iscsi_if_destroy_conn            |-dev_attr_show
>  |-iscsi_conn_teardown
>   |-spin_lock_bh                     |-iscsi_sw_tcp_conn_get_param
> 
>   |-kfree(conn->persistent_address)   |-iscsi_conn_get_param
>   |-kfree(conn->local_ipaddr)
>                                        ==>|-read persistent_address
>                                        ==>|-read local_ipaddr
>   |-spin_unlock_bh
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] libiscsi: fix UAF when iscsi_conn_get_param and iscsi_conn_teardown concurrent
      https://git.kernel.org/mkp/scsi/c/1b8d0300a3e9

-- 
Martin K. Petersen	Oracle Linux Engineering
