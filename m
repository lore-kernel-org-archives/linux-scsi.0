Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5BEC25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 13:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjJZNTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 09:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjJZNTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 09:19:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AF8AB
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 06:19:33 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QClTxZ009061;
        Thu, 26 Oct 2023 13:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=fkXpBJKbmQjvW7qcNl3xxFs9REKkbWsl6YsUuK4/WGc=;
 b=ftIjif1u6SqfbVeEF4sMtEsOJW8Dx5LJ+5A5IpcgOBW8kq+/E8P1mCcsfCn+GrhK0fJN
 Jb4iewNzmzsH/lc0Oh8NeBGGUvrnfWaAeIWKyPFN1IcCpthQgILDY/OszrycyKnKRyeL
 CsfwudywW+6tgcf4qm/WM2G51GKkZuu52FBgp2ltCKUz+9CVE+B8GxjI+Gg+Xkqgx1jd
 gAR+wvb9TyFi7sSglFYKCLiCgE0sk+9BGJbFhreoFCZy3O+K+4NehUT19Tz9IOkauNSM
 j1YqP26qY+ts+j4VFfDfmr+bPi4kmErf3L3NgQ1S9NnpLlhjQCZotyaCMBLCrucL9wRW Eg== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyre2h4ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 13:19:26 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QCHYXE026878;
        Thu, 26 Oct 2023 13:19:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsyp67qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 13:19:25 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QDJND747317426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 13:19:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B8752004B;
        Thu, 26 Oct 2023 13:19:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C08920040;
        Thu, 26 Oct 2023 13:19:23 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 26 Oct 2023 13:19:23 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qw0Gg-00AonB-2x;
        Thu, 26 Oct 2023 15:19:22 +0200
Date:   Thu, 26 Oct 2023 15:19:22 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 06/10] scsi_error: iterate over list of failed commands
 in scsi_eh_bus_reset()
Message-ID: <20231026131922.GL1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-7-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-7-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AcIXXJ10WwGICcKrheCj9ky4i9CMMKfC
X-Proofpoint-GUID: AcIXXJ10WwGICcKrheCj9ky4i9CMMKfC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_11,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 11:28:33AM +0200, Hannes Reinecke wrote:
> Iterating over all possible bus number in scsi_eh_bus_reset() is
> inefficient as not all busses may be affected during SCSI EH.
> So rewrite the loop in scsi_eh_bus_reset() to match the loop
> in scsi_eh_target_reset() and only loop over failed commands.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_error.c | 62 ++++++++++++++++-----------------------
>  1 file changed, 25 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 42e12756d6f4..7c9c376affda 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1716,43 +1715,32 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
> +		rtn = scsi_try_bus_reset(scmd);
> +		if (rtn != SUCCESS && rtn != FAST_IO_FAIL) {
>  			SCSI_LOG_ERROR_RECOVERY(3,
>  				shost_printk(KERN_INFO, shost,
>  					     "%s: BRST failed chan: %d\n",
>  					     current->comm, channel));
>  		}
> +		list_for_each_entry_safe(scmd, next, work_q, eh_entry) {

You probably want to iterate over the `tmp_list`, not the `work_q`.

> +			if (scmd_channel(scmd) != channel)
> +				continue;
> +

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
