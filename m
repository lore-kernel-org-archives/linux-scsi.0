Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9F5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 23:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354094AbiBKXZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 18:25:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242803AbiBKXZm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 18:25:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F366FC5F
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 15:25:40 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BIvUVo019082;
        Fri, 11 Feb 2022 23:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Z/V6mUdp00BEX/U/eGKc2RcBoIsNuvqqgnsUBswzFGI=;
 b=HdbraRaPszpN5bxYm9ELvtdVVWEcNW6aEoRlqAH8NFhWQSGANYzBzMuKQHG8jdDDrd1L
 Y94Ihx4thcLuqALSuxoGHrCxIgIBEqJnyDzs9ZxODIr4DV2BnI6mYfVUe/iv2/nkipf6
 7yiZA4g/gq4PD3QJ1O37dr8h99Re88Kl1CNsBmKhu9IsVvZ4n50C5j4OMsql9Gvb1yll
 PPOMUWMigjiHmxEedMCjVCrxA9+r1aPwzTj6zXDaRFu+Cq+X+ZxPlDSeixeJdhYd6Aro
 wRCXaN+7AyFomW3+7dn55jFxl6HSJGF9o+JfYBnr3ozxmXvRfXdu7qjrN8XrIyxWg1H3 +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5gt4ab70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 23:25:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BNG6sb020730;
        Fri, 11 Feb 2022 23:25:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3e1jpykk2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 23:25:33 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21BNPTtD094578;
        Fri, 11 Feb 2022 23:25:32 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3e1jpykk0v-3;
        Fri, 11 Feb 2022 23:25:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mwilck@suse.com, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: make "access_state" sysfs attribute always visible
Date:   Fri, 11 Feb 2022 18:25:26 -0500
Message-Id: <164462189849.7606.10611890158950662064.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220127141351.30706-1-mwilck@suse.com>
References: <20220127141351.30706-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: lvvlaOmdkmke8VQdwOKn5ppRNb3NTc57
X-Proofpoint-ORIG-GUID: lvvlaOmdkmke8VQdwOKn5ppRNb3NTc57
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Jan 2022 15:13:51 +0100, mwilck@suse.com wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> If a SCSI device handler module is loaded after some SCSI devices
> have already been probed (e.g. via request_module() by dm-multipath),
> the "access_state" and "preferred_path" sysfs attributes remain invisible for
> these devices, although the handler is attached and live. The reason is
> that the visibility is only checked when the sysfs attribute group is
> first created. This results in an inconsistent user experience depending
> on the load order of SCSI low-level drivers vs. device handler modules.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: make "access_state" sysfs attribute always visible
      https://git.kernel.org/mkp/scsi/c/7cddf7e8d1e8

-- 
Martin K. Petersen	Oracle Linux Engineering
