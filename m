Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB591C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 11:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbiEDLNP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 07:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348585AbiEDLNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 07:13:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB54C2611C
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 04:09:34 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244AsuT0021586;
        Wed, 4 May 2022 11:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yB2U10D/67xtnRet7cyIvfpRXkJfltPLqiTCcDe8gII=;
 b=mmTyfeCLmvu/SN64bqKB4VoPn0Kcfq1UwkBi1sEqFe6selyhJIlQYiLT7/ZN2i7Q7Zc/
 Otpe1rfOnD4HgpePxwOP6NqdNtfHMfPbXouC7n1FSyeyHLiAROdirmGsb6fQwr7SqQ1s
 1Ye2yR2z+26HXvkAkZJSQ9dYqKFsCUMBtoNVOwBnZMsRCvUo0jlXZctDCRV3CIiGiupx
 IHBqgKmhWP84A4MEFZHD2Uxyg2xQiHuq7xnXEM0lHmOg7eLTrQdHKZLJ3CmJrh3tRFEK
 JuyWa44YtoCNRW6RWV5pAXt1BUHh8bB3BPA7O9bYIPVQRbDcpXJb82HXCBvVUGr9zQrf lg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fur5f0af0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:09:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 244B92fH030026;
        Wed, 4 May 2022 11:09:25 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3frvcj5h29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:09:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 244B9MLS44564824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 11:09:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7061A405F;
        Wed,  4 May 2022 11:09:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93397A405C;
        Wed,  4 May 2022 11:09:22 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.86.219])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  4 May 2022 11:09:22 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1nmCsk-000wBG-33; Wed, 04 May 2022 13:09:22 +0200
Date:   Wed, 4 May 2022 11:09:22 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
Message-ID: <YnJe4vdwxIRUXKdS@t480-pf1aa2c2>
References: <20220503200704.88003-1-hare@suse.de>
 <20220503200704.88003-4-hare@suse.de>
 <YnJdEio0ifb9/McS@t480-pf1aa2c2>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnJdEio0ifb9/McS@t480-pf1aa2c2>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HopX-nSUTBk8IAGYdN7OFYzvziM0nYW_
X-Proofpoint-GUID: HopX-nSUTBk8IAGYdN7OFYzvziM0nYW_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_03,2022-05-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 04, 2022 at 11:01:38AM +0000, Benjamin Block wrote:
> On Tue, May 03, 2022 at 10:06:43PM +0200, Hannes Reinecke wrote:
> > @@ -373,9 +373,11 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)

...

Ah sorry, Steffen was already looking at this. You can ignore my
comments, he covered them all already 😅

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
