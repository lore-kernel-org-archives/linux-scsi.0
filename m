Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF572C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 19:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA9760F91
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 19:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhI0T5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 15:57:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2710 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236171AbhI0T5j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 15:57:39 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RIndUR036247;
        Mon, 27 Sep 2021 15:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=53ya4otM9qkN9qZkwFR8H60BlG0301DfeZhufp3WRC8=;
 b=TD9/DdjfNyYaMpCwqjgh/JfsRqs2cvkB75bx08eVpP1KFn9ninwK6g5zzVv95MQEGO4x
 CvACCWb/r8TtWX7MzCcy9R2Oc4Hj6im1m3dZJfhzd6R4AIpxBl4NvE+QBEYbJ++qXbg7
 Y8s/n6tn8yx9TtAi1yZIL8vlaGD5du3X4+yl4PU0E09GaCbn973+0OHKwOd+AkCARTIC
 bMleXjqSNSehAcoSennVHtfD89CKrbjXVxfrmGQ3+ZyOlJwmuA5EsRQEzQm5utJn0mDs
 bGTve540pMGJeY0sjovtL5vtoGFaSsEaCOmSjCa2ELyj4NG9WwtmV0mBpn8wFjqzdD2C kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bah7yv3qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 15:55:53 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RJm4hP015014;
        Mon, 27 Sep 2021 15:55:53 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bah7yv3q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 15:55:53 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RJlxDA029581;
        Mon, 27 Sep 2021 19:55:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3b9ud96m7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 19:55:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18RJtlqh60293466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 19:55:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90B1C52063;
        Mon, 27 Sep 2021 19:55:47 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.83.160])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 876275205A;
        Mon, 27 Sep 2021 19:55:47 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mUwj5-0030b5-18; Mon, 27 Sep 2021 21:55:47 +0200
Date:   Mon, 27 Sep 2021 21:55:46 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 01/84] scsi: core: Use a member variable to track the
 SCSI command submitter
Message-ID: <YVIhwlZq5K3yQzVM@t480-pf1aa2c2.linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-2-bvanassche@acm.org>
 <YU2cN5H7CqVFOzTQ@t480-pf1aa2c2.linux.ibm.com>
 <4bc6bf9c-a6bd-13c7-988b-9756bb5dd480@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4bc6bf9c-a6bd-13c7-988b-9756bb5dd480@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uNSmFPGRJfjsyvm109-UliwDkdHdFKIk
X-Proofpoint-ORIG-GUID: Q-PKiEuv4SSH7IE3h7fDVPbbmgT1fHzP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_07,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 24, 2021 at 08:38:42PM -0700, Bart Van Assche wrote:
> On 9/24/21 02:36, Benjamin Block wrote:
> > On Fri, Sep 17, 2021 at 05:04:44PM -0700, Bart Van Assche wrote:
> > > Conditional statements are faster than indirect calls. Use a member variable
> > > to track the SCSI command submitter such that later patches can call
> > > scsi_done(scmd) instead of scmd->scsi_done(scmd).
> > > 
> > > The asymmetric behavior that scsi_send_eh_cmnd() sets the submission
> > > context to the SCSI error handler and that it does not restore the
> > > submission context to the SCSI core is retained.
> > > 
> > > Cc: Hannes Reinecke <hare@suse.com>
> > > Cc: Ming Lei <ming.lei@redhat.com>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > > ---
> > >   drivers/scsi/scsi_error.c | 18 +++++++-----------
> > >   drivers/scsi/scsi_lib.c   |  9 +++++++++
> > >   drivers/scsi/scsi_priv.h  |  1 +
> > >   include/scsi/scsi_cmnd.h  |  7 +++++++
> > >   4 files changed, 24 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 572673873ddf..ba6d748a0246 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -1577,6 +1577,15 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
> > >   static void scsi_mq_done(struct scsi_cmnd *cmd)
> > >   {
> > > +	switch (cmd->submitter) {
> > > +	case BLOCK_LAYER:
> > > +		break;
> > > +	case SCSI_ERROR_HANDLER:
> > > +		return scsi_eh_done(cmd);
> > > +	case SCSI_RESET_IOCTL:
> > > +		return;
> > > +	}
> > > +
> > 
> > Hmm, I'm confused, you replace one kind of branch with different one. Why
> > would that increase IOPS by 5%?
> > 
> > Maybe its because the new `submitter` field in `struct scsi_cmnd` is now
> > on a hot cache line, whereas `*scsi_done` is not?
> 
> Hi Benjamin,
> 
> To be honest, the 5% improvement is more than I had expected. This is what I
> know about indirect function calls vs. branches:
> - The target of an indirect branch is predicted by the indirect branch
>   predictor. For direct branches the Branch Target Buffer (BTB) is used.
> - The performance of indirect calls is negatively affected by security
>   mitigations (CONFIG_RETPOLINE) but not the performance of direct branches
>   My measurement was run with CONFIG_RETPOLINE off. I expect a larger
>   difference with CONFIG_RETPOLINE enabled.

Ah ok, yeah, that sounds reasonable. Thanks.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
