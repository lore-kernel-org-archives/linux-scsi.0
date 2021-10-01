Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBAEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 15:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3E561ACD
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 15:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354173AbhJAP7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 11:59:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231768AbhJAP7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2021 11:59:36 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191FmC2e021023;
        Fri, 1 Oct 2021 11:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=6SuAMrM04un2y1zV0UhHi9U3qSP3NwAXN/aRMAvxK4E=;
 b=FYWHI7UNMQhy7KypAO0ErsOfje/WRk4aHujPSPZtwY21A+Gt8DB4b4tOF5Ut1j957s40
 L9tNLXMamarudRBBVeS1r23NbAfkZmaHE/JvoxsTi1p1NCiwncUdDKSvMkjCaqhRuj/o
 vTHdldJUVu0Y/EDIRHt3/WVKgNROSZoHQG7q9mhVUVe3lzpzQfkcmVZ8gCodxntG5MET
 ydtoHRrmImpnlQq1mdbEFb/qONnePuXFrZt8ack31KKP3E9h7NIP/XrNtyQvfoJc7LY+
 JVOO3ZBlLpTEsjfqHjlZ9M1BAgHM0I3+9TvCiJqqKsDivDuTdlf19w6MbpQH3SXjaZHB pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3be59j04ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Oct 2021 11:57:38 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 191FsbCl010262;
        Fri, 1 Oct 2021 11:57:37 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3be59j04tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Oct 2021 11:57:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 191Fqcvl021386;
        Fri, 1 Oct 2021 15:57:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3b9udar2xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Oct 2021 15:57:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 191FvVUi5767758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Oct 2021 15:57:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A62B42041;
        Fri,  1 Oct 2021 15:57:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 665A34203F;
        Fri,  1 Oct 2021 15:57:31 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.62.191])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  1 Oct 2021 15:57:31 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mWKug-001Aol-Qb; Fri, 01 Oct 2021 17:57:30 +0200
Date:   Fri, 1 Oct 2021 17:57:30 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 01/84] scsi: core: Use a member variable to track the
 SCSI command submitter
Message-ID: <YVcv6vRhSHoaLD+z@t480-pf1aa2c2.linux.ibm.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-2-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210929220600.3509089-2-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pjuyiMDdUY1zmQfuT__PdksjdIP0cBBn
X-Proofpoint-ORIG-GUID: qeJ8KrdqQxA6zHwgFDASBEfgmx-ck20q
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-01_03,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 clxscore=1015 bulkscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110010108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Bart,

On Wed, Sep 29, 2021 at 03:04:37PM -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Use a member variable
> to track the SCSI command submitter such that later patches can call
> scsi_done(scmd) instead of scmd->scsi_done(scmd).
> 
> The asymmetric behavior that scsi_send_eh_cmnd() sets the submission
> context to the SCSI error handler and that it does not restore the
> submission context to the SCSI core is retained.
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 18 +++++++-----------
>  drivers/scsi/scsi_lib.c   | 10 ++++++++++
>  drivers/scsi/scsi_priv.h  |  1 +
>  include/scsi/scsi_cmnd.h  |  7 +++++++
>  4 files changed, 25 insertions(+), 11 deletions(-)
> 

I think its good!

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
