Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFFDC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 12:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCIMNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 07:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCIMNq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 07:13:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1258E34B4
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 04:13:44 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329B1URP029527;
        Thu, 9 Mar 2023 12:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=u4hdTlW6uoeMWitNP7MAg2BPzYS3BXtjumqJOt7g4Fc=;
 b=bvhAw4shmW84DjO865jG7HC4XLiZClvslIAZESc9OXzBzXhmJIZje5iLWDxXs6wHZr7G
 5ygOJkorKrdeHOYMJgTZaEV2Auv8uHxLN2IjsJol576QGdaraXT2s5WLZKbPpcWPhLRU
 hcUsp+phNph2MKmDtWwp66wkOUkV5MDMt6KdPhWRxGxVsbEYx5YDShYScufQCGqSgrq3
 tEQUsCcU+0KEcBY+mgUKGKecxu8k/DTitSW+Zie0QacjPBk/Ic9xsgOQ3P51G/CUX5id
 fU0n/9/zqH9kmRtJqJ/Sw+tAiEImyhMVR47VkI1xSUL2kTfVfiCo6hILJubkikfst4Lv SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6t3br3r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 12:13:35 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 329Bq2Ar011420;
        Thu, 9 Mar 2023 12:13:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6t3br3q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 12:13:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32941B5Z020006;
        Thu, 9 Mar 2023 12:13:33 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3p6ftvjax6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 12:13:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 329CDTfY29360410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Mar 2023 12:13:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A311920049;
        Thu,  9 Mar 2023 12:13:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8818E20040;
        Thu,  9 Mar 2023 12:13:29 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.11.215])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  9 Mar 2023 12:13:29 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1paF9E-00374g-33;
        Thu, 09 Mar 2023 13:13:28 +0100
Date:   Thu, 9 Mar 2023 12:13:28 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Simplify the code for waking up the error
 handler
Message-ID: <20230309121328.GD620522@t480-pf1aa2c2.fritz.box>
References: <20230307215151.3705164-1-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230307215151.3705164-1-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qwNFzLzQV-Rqd4Y7lbSSms5uIvzqCT_a
X-Proofpoint-ORIG-GUID: kLL-oGKxldcGPcR33MHia-l1vVr4e_0A
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_06,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 07, 2023 at 01:51:51PM -0800, Bart Van Assche wrote:
> scsi_dec_host_busy() is called from the hot path and hence must not
> obtain the host lock if no commands have failed. scsi_dec_host_busy()
> tests three different variables of which at least two are set if a
> command failed. Commit 3bd6f43f5cb3 ("scsi: core: Ensure that the
> SCSI error handler gets woken up") introduced a call_rcu() call to
> ensure that all tasks observe the host state change before the
> host_failed change. Simplify the approach for guaranteeing that the host
> state and host_failed/host_eh_scheduled changes are observed in order by using
> smp_store_release() to update host_failed or host_eh_scheduled after
> having update the host state and smp_load_acquire() before reading the
> host state.

It's probably just me, but "simplify" is a bit of a misnomer when you
replace RCU by plain memory barriers. And I'm kind of wondering what we
improve here? It seems to me that at least as far as the hot path is
concerned, nothing really changes? The situation for
`scsi_eh_scmd_add()` seems to improve, but that is already way off the
hot path.

> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 22 ++++------------------
>  drivers/scsi/scsi_lib.c   | 31 +++++++++----------------------
>  include/scsi/scsi_cmnd.h  |  2 --
>  3 files changed, 13 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 2aa2c2aee6e7..2a809145da06 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -87,7 +87,8 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
>  
>  	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
>  	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
> -		shost->host_eh_scheduled++;
> +		smp_store_release(&shost->host_eh_scheduled,
> +				  shost->host_eh_scheduled + 1);

Probably should be documented.

>  		scsi_eh_wakeup(shost);
>  	}
>  
> @@ -312,12 +301,9 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
>  
>  	scsi_eh_reset(scmd);
>  	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
> +	smp_store_release(&shost->host_failed, shost->host_failed + 1);

Same.

> +	scsi_eh_wakeup(shost);
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> -	/*
> -	 * Ensure that all tasks observe the host state change before the
> -	 * host_failed change.
> -	 */
> -	call_rcu_hurry(&scmd->rcu, scsi_eh_inc_host_failed);
>  }
>  
>  /**

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
