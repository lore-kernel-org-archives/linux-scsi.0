From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Tue, 15 Nov 2016 15:31:27 +0100
Message-ID: <8647eacd-a029-dff0-4f78-dafef89a5ad9@linux.vnet.ibm.com>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <bbc682928173d64848ab0cbff689b1ad3d715fb7.1476369687.git.jthumshirn@suse.de>
 <ebc46cfa-0bee-aa71-ba0b-d7c86628df0c@linux.vnet.ibm.com>
 <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
 <20161025074313.4ma4czgdj46imaei@linux-x5ow.site>
 <20161115115622.j4ker3atejcodqrc@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38013 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752731AbcKOObe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 09:31:34 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFEOA6R146842
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 09:31:34 -0500
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26r2qrvp53-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 09:31:34 -0500
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 14:31:32 -0000
In-Reply-To: <20161115115622.j4ker3atejcodqrc@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>s

Hi Johannes,

On 11/15/2016 12:56 PM, Johannes Thumshirn wrote:
> On Tue, Oct 25, 2016 at 09:43:14AM +0200, Johannes Thumshirn wrote:
>> On Fri, Oct 14, 2016 at 09:38:21AM +0200, Johannes Thumshirn wrote:
>>> On Thu, Oct 13, 2016 at 05:55:11PM +0200, Steffen Maier wrote:
>>>> Hm, still behaves for me like I reported for v2:
>>>> http://marc.info/?l=linux-scsi&m=147637177902937&w=2
>
> [...]
>
>>>
>>> The rational behind this is, in fc_req_to_bsgjob() we're assigning
>>> job->request as req->cmd and job->request_len = req->cmd_len. But without
>>> checkinf job->request_len we don't know whether we're save to touch
>>> job->request (a.k.a. bsg_request).
>>
>> Hi Steffen,
>> Did you have any chance testing this? I hacked fcping to work with non-FCoE
>> and rports as well and tested with FCoE and lpfc. No problems seen from my
>> side. I've also pused the series (With this change folded in) to my git
>> tree at [1] if this helps you in any way.
>>
>> [1] https://git.kernel.org/cgit/linux/kernel/git/jth/linux.git/log/?h=scsi-bsg-rewrite-v4
>>
>
> So I finally have a test system up and running. I have good and bad news. The
> good news is, I can't get the system crashing with my patches, the bad news is
> I can't get zfcp_ping and zfcp_show to output something but HBA_STATUS_ERROR
> with my patches and without.

Assuming you run the latest package version on s390x:

Do steps 2 and 3 of the procedure in
http://www.ibm.com/support/knowledgecenter/linuxonibm/com.ibm.linux.z.lhdd/lhdd_t_fcp_api_runappl.html
help?

The only other thing I can think of from the top of my head is that BSG 
ioctls are sensitive regarding ABI and I once had the kernel ioctl 
return EINVAL due to unmatching kernel-headers and libzfcphbaapi maps 
this EINVAL to HBA_STATUS_ERROR because there is no more specifically 
suitable HBA constant [old SUSE bugs 834498 and 834500].

> And btw, I renamed the branch to fc-bsg-rewrite-v4 in case you want to clone
> from it (it has patch 2/16 changed to the v3 submission).
>
> Can you please have a look with your setup?

I'm going to re-test hopefully within the next few days.

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

