Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA9CC00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 17:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbjJXRar (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 13:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbjJXRan (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 13:30:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4660A10EA
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 10:30:41 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OHPBpV002839;
        Tue, 24 Oct 2023 17:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hMnNhI1IA1AHE9K6RccvGVN785pWuKntPWDyiU3x8Xw=;
 b=B+YkljmSqUL4C64aGCCy8rHKbw4s8MtK1puPH3tp2ri0U1ULsZCH+eiR1DFMxxWvej1a
 CP2gnpTW/7YVd5jTZ9gNuX3w8Eln9YPP4CvY1tfN7+wfFyfqBgJk87puLLPAN+JysIld
 NdNA3TpCUyJ+VcCvY9m1lMEBLTzR8IkljyFmaWYEasJhMhIjQc8y5aAxuHSLBjpVCbH5
 7qbnQUr2fMb6wQ+22CvXLNvh57tKFcpwLyz+17XOcz9+GtNofQQrnGtO30VZwk2jMj/d
 RKpgzIgr62TfdTl2Uh2ShTe1se8JObhxlxe72yeLBysRGVQEz8JoB6zm4i94TDdpfWSn PA== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3txjaag381-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Oct 2023 17:30:32 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39OG1UgD010218;
        Tue, 24 Oct 2023 17:30:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsbyh96q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Oct 2023 17:30:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39OHUTps26280410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 17:30:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B7A42004B;
        Tue, 24 Oct 2023 17:30:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61EA720040;
        Tue, 24 Oct 2023 17:30:29 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.23.141])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 24 Oct 2023 17:30:29 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qvLEa-00ADwh-2g;
        Tue, 24 Oct 2023 19:30:28 +0200
Date:   Tue, 24 Oct 2023 19:30:28 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCHv8 00/10] scsi: EH rework, main part
Message-ID: <20231024173028.GB1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-1-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NfW1RzuGqKh3RRGBZZsZdkohUlXL7umV
X-Proofpoint-GUID: NfW1RzuGqKh3RRGBZZsZdkohUlXL7umV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_16,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310240148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Hannes,

On Mon, Oct 23, 2023 at 11:28:27AM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> (taking up an old thread:)
> here's now the main part of my EH rework.
> It modifies the reset callbacks for SCSI EH such that
> each callback (eh_host_reset_handler, eh_bus_reset_handler,
> eh_target_reset_handler, eh_device_reset_handler) only
> references the actual entity it needs to work on
> (ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
> and the 'struct scsi_cmnd' is dropped from the argument list.
> This simplifies the handler themselves as they don't need to
> exclude some 'magic' command, and we don't need to allocate
> a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.
> 
> The entire patchset can be found at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> branch eh-rework.v8

This doesn't exist (yet?). I also tried to somehow get both part 2 of the
preparations and this series applied on some tree, but failed.
Preparations part 2 seems to be based on some form of Linus' master tree, and
this on Martin's staging tree?
Maybe I'm just unlucky :D

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
