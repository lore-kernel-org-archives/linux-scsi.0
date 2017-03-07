From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 01/16] lpfc: Correct WQ creation for pagesize
Date: Tue, 7 Mar 2017 10:44:51 -0300
Message-ID: <7c6d6f3b-330c-ea6f-ad3f-65479354c94d@linux.vnet.ibm.com>
References: <58a0d919.08BhoypOnvRSLIqV%jsmart2021@gmail.com>
 <6a197069-2f10-6df1-4cf1-1a62808c8903@linux.vnet.ibm.com>
 <yq1tw75kbdn.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755038AbdCGPeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 10:34:31 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v27DhoB3093234
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 08:44:59 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 291we19wnr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2017 08:44:58 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 7 Mar 2017 10:44:57 -0300
In-Reply-To: <yq1tw75kbdn.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me

Hello stable kernel maintainers,

On 03/07/2017 12:35 AM, Martin K. Petersen wrote:
> Mauricio> Please flag this patch for stable.
>
> Mauricio> This patch resolves a serious problem on IBM Power systems at
> Mauricio> least.
>
> Both patches are already upstream so I can't tag them for stable. Either
> you or James should mail stable@vger.kernel.org and request for the
> patches to be queued up.

Can this commit be included on stable v4.4+ , please? (in Linus tree)

     8ea73db486cda442f0671f4bc9c03a76be398a28 "scsi: lpfc: Correct WQ 
creation for pagesize"

Thanks!


For documentation purposes, the resolved issue is described on [1].

Following is the rationale for the stable kernel version asked for, in
case Broadcom/others would like to discuss/contribute.

These are the 3 commits which introduced the lines changed by the 
desired fix commit

     0c651878ba3018bb4bbfa2ccd0a876bebb618768 "[SCSI] lpfc 8.3.41: Fixed 
support for 128 byte WQEs"
     5a6f133eea2d0b4f8f75367b803fef0f03acf268 "[SCSI] lpfc 8.3.22: Add 
new mailbox command and new BSG fix"
     c31098cef5e091e22a02ff255f911e0ad71cc393 "[SCSI] lpfc 8.3.23: Fixes 
related to new hardware"

So, checking the oldest release git tag which contains the most recent
commit (so the fix applies cleanly)

     $ git tag --contains 0c651878ba3018bb4bbfa2ccd0a876bebb618768 | 
grep -v rc | sort -V
     v3.12
     <...>
     v4.10

And it is cherry-picked/applies cleanly on v3.12:

     $ git checkout -b lpfc-v3.12 v3.12
     Switched to a new branch 'lpfc-v3.12'

     $ git cherry-pick 8ea73db486cda442f0671f4bc9c03a76be398a28
     [lpfc-v3.12 c2b0912e6135] scsi: lpfc: Correct WQ creation for pagesize
     Author: James Smart <jsmart2021@gmail.com>
     2 files changed, 7 insertions(+), 4 deletions(-)

However, v3.12 seems too old to go back, and it's unclear whether there
was any problem actually reported on these older kernel releases, or
whether the hardware/configuration that reproduces this problem is
supported on v3.12 at all.

On PowerPC (which is directly affected by the fix, as at least IBM
Power servers uses a 64k page size by default on most distros), this
fix is probably only required on v4.4+, so to cover a distro for which
Broadcom doesn't ship inbox drivers to (w/ fix included).

So, I'll ask it for stable v4.4+, and Broadcom/others can expand the
range if they see fit/required.

[1] http://www.spinics.net/lists/linux-scsi/msg105886.html

cheers,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
