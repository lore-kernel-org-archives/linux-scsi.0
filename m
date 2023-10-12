Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F959CDB46E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 14:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347130AbjJLOAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 10:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347196AbjJLOAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 10:00:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF5CB7
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 07:00:30 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39CDqnjG007709;
        Thu, 12 Oct 2023 14:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=AlA62pAact3Oo/tRJ5EzwqRdP/iIewh6pnDcMOsUuvQ=;
 b=kwPNStneEpLohBZY8U8ZVC4L1tsn07vA79/D5ySmc8yFanpIwqvL3my0hTHYYYCcGE55
 N60jMD6v/vvZVdzqPO8t3hW7/QD/jyBKaGu+qvxyT36CpAiMoYZPwv7GBaJ0G4lNbEqs
 y9lo8j7lAhqFX8gENfLuy0qcZYIqafsYRsJtgANy/swbkGQa10DS5aVpmQkELcOM71xX
 pfmNL5IkMg9EPVlzr6yzhDVr2U3kPS0sKXmbEuF5VpcezvWkzDkmPKpP4aOVdWzwL7C1
 Rqbx2zB/lFPpxbEJ0UYaNBagUu+C1tXj8pgQTT1i4V8hhfqRya0uNoPNvfxZQ78w7EFZ 8g== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tpj2mrdab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 14:00:21 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39CC2L70028633;
        Thu, 12 Oct 2023 13:54:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkj1yg16k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 13:54:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39CDsrOu41025808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Oct 2023 13:54:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 585A82004B;
        Thu, 12 Oct 2023 13:54:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44CE520043;
        Thu, 12 Oct 2023 13:54:53 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.68])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 12 Oct 2023 13:54:53 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qqw9M-0040hc-35;
        Thu, 12 Oct 2023 15:54:52 +0200
Date:   Thu, 12 Oct 2023 15:54:52 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 01/15] zfcp: do not wait for rports to become unblocked
 after host reset
Message-ID: <20231012135452.GB31157@p1gen4-pw042f0m.fritz.box>
References: <20231002154927.68643-1-hare@suse.de>
 <20231002154927.68643-2-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231002154927.68643-2-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HVEzwZrTL_XYaZ7wDZt2CJT5pCX30rOb
X-Proofpoint-ORIG-GUID: HVEzwZrTL_XYaZ7wDZt2CJT5pCX30rOb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-12_05,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 bulkscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310120115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Hannes,

I've got a few questions re the rational for this change.

On Mon, Oct 02, 2023 at 05:49:13PM +0200, Hannes Reinecke wrote:
> zfcp_scsi_eh_host_reset_handler() would call fc_block_rport() to
> wait for all rports to become unblocked after host reset.
> But after host reset it might happen that the port is gone, hence
> fc_block_rport() might fail due to a missing port.
> But that's a perfectly legal operation; on FC remote ports might
> come and go.
> In the same vein FC HBAs are able to deal with ports being temporarily
> blocked, so really there is not point in waiting for all ports
> to become unblocked during host reset.

But in scsi_transport_fc.c we have this documented:

    * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
    * @cmnd: SCSI command that scsi_eh is trying to recover
    *
    * This routine can be called from a FC LLD scsi_eh callback. It
    * blocks the scsi_eh thread until the fc_rport leaves the
    * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires. This is
    * necessary to avoid the scsi_eh failing recovery actions for blocked
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    * rports which would lead to offlined SCSI devices.
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

So I don't understand what the real expectation by the SCSI EH call back for
host reset is then.

Is it that all objects (host/target ports/luns) are operational again once we
return to the EH thread, or is it ok that some parts are still being
recovered (as with our host reset handler, rports might still be blocked after
`zfcp_erp_wait()` finishes, because of how this is organized internally).

If it's the later, I'd think this change is fine. But then I'd wonder why this
function exists in the first place? Is it because in other EH steps it's more
important that rports are ready after the step (e.g. because a TUR is send
after, and if that fails, things get escalate unnecessarily)?

Oh.. speaking of that, we do send a TUR after host reset as well
(`scsi_eh_test_devices()`). So doesn't this break then if one or more rports
are sill blocked after host reset returns? 
    At least `zfcp_scsi_queuecommand()` will bail very early if the rport is
not ready (we call `fc_remote_port_chkready()` as more or less first thing),
and so `scsi_send_eh_cmnd()` that is used for the TUR will fail; then it might
be retried one time, but this is a tight loop without any delay, so I'd guess
this has a good chance to fail as well.
    And then we'd offline the whole host as further escalation, which would
*REALLY* suck (with no automatic recovery no less).

My impression from look at the code that follows `scsi_try_host_reset()` in
`scsi_error.c` really is, it rather expects things to be ready to be used
after, right there and then (admittedly, this is probably already today
problematic, as things might go back to not working concurrently because of
some fabric event.. but anyway, we can life with that off-chance it seems).

Or do I miss something?

> Hence remove the call to fc_block_rport() in host reset.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Steffen Maier <maier@linux.ibm.com
> Cc: Benjamin Block <bblock@linux.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_scsi.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index b2a8cd792266..14f929cca271 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -383,10 +383,6 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>  	}
>  	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>  	zfcp_erp_wait(adapter);
> -	fc_ret = fc_block_scsi_eh(scpnt);
> -	if (fc_ret)
> -		ret = fc_ret;
> -
>  	zfcp_dbf_scsi_eh("schrh_r", adapter, ~0, ret);
>  	return ret;
>  }
> -- 
> 2.35.3
> 

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
