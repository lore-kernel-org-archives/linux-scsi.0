Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CE8C00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 18:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbjJXSBn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 14:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234671AbjJXSBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 14:01:40 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC83910D4
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 11:01:38 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OHmCAw004359;
        Tue, 24 Oct 2023 18:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=VcqQaivMjb1rkvQzvEvCGIdzwiXwgLTKQNcZX4K6tV4=;
 b=MRhclPZPGYAo9/GAHZhtP56xRh1pQrpzlDmri2s5jx8YWYYoIz9pIqHH+5qmbtx08m+/
 SMu2y3cUJIlsDTBmBPiubWlEeSsSQ8uMyeYRXjzpxFjQZGgbbywUJCpN1QC0QRDWjyn/
 Y45eF7ZNSpLhf0vaLaSIBDvbYsJ3Zv8DOiD3Tn/CcpXs8EsFf+hyOFh+T0sWv7suDQkB
 zgZ1dGtCsNJX+8XB3O3tXJ3WUBCzHYj2i8b55dTt7OQJqe+sloRwIIFUlzdjhg70tzlB
 bAmoyfcK4ItgSUw/kjucublKsjMJgGxFfmECxZq6xSMgSOmEd1JHBPJhcqlAx0c6up/j KA== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3txjhgresb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Oct 2023 18:01:28 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39OH9luY005004;
        Tue, 24 Oct 2023 17:57:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvtfkh1ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Oct 2023 17:57:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39OHvTNx25756310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 17:57:29 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7704C2004B;
        Tue, 24 Oct 2023 17:57:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F00220040;
        Tue, 24 Oct 2023 17:57:29 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.23.141])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 24 Oct 2023 17:57:29 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qvLei-00AFTC-2i;
        Tue, 24 Oct 2023 19:57:28 +0200
Date:   Tue, 24 Oct 2023 19:57:28 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCHv8 00/10] scsi: EH rework, main part
Message-ID: <20231024175728.GC1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231024173028.GB1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
 <a5a2dee0-4d85-4d45-a982-cdbd88addc45@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <a5a2dee0-4d85-4d45-a982-cdbd88addc45@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m57uSlPdhZKHny9GXDmdlJ8IHteKxfU0
X-Proofpoint-ORIG-GUID: m57uSlPdhZKHny9GXDmdlJ8IHteKxfU0
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_17,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 adultscore=0 mlxlogscore=843 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310240154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 24, 2023 at 07:40:15PM +0200, Hannes Reinecke wrote:
> On 10/24/23 19:30, Benjamin Block wrote:
> > On Mon, Oct 23, 2023 at 11:28:27AM +0200, Hannes Reinecke wrote:
> >> The entire patchset can be found at:
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> >> branch eh-rework.v8
> > 
> > This doesn't exist (yet?). I also tried to somehow get both part 2 of the
> > preparations and this series applied on some tree, but failed.
> > Preparations part 2 seems to be based on some form of Linus' master tree, and
> > this on Martin's staging tree?
> > Maybe I'm just unlucky :D
> > 
> Maybe you are.
> Pushed now, please try again.

That was v9, but I guess that works as well, thanks.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
