Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7251EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 11:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348481AbiEDLF2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 07:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348467AbiEDLF1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 07:05:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C312123BE7
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 04:01:51 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244At2iK023133;
        Wed, 4 May 2022 11:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cO0AHf7AOiPcihOuz2jRLY6u2FsBolHwYllmICjTgHU=;
 b=KGxqzQEqDbCtd3kKCPB36o+/MWGLH1KJL+GWpAQynRbIJq347brEw46nphOzeQzdjhHk
 cLxeu781Nf7M9ri/Kq2S7d1rRbIFoltSIQokUvrtgo+rZynSyY7QdCXX14XLc4PiaDCO
 Q4Yq688oVZBj8Xk5H4tjTpL0MfAXdLR61kVH/mMcHvaLqDlR/e/ygUPtAnVoyUvJNf7d
 lQfItPCM+Xt+2i2OCV4OcMhYuB8/aJIWtm8Ob05PDPbMH0C5OpI3Eu5kGHjZx77bMmU2
 aXEW656wAxsxPmB9B+gc25lHtlSJWqW+lCTSFuK8qNMo+pTFDe77t7HnsFyFq8/kQErI /A== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fur5f04g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:01:44 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 244B0DfF004536;
        Wed, 4 May 2022 11:01:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3frvr8ve4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:01:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 244B1d4144564888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 11:01:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AA0552052;
        Wed,  4 May 2022 11:01:39 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.86.219])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 48A8052050;
        Wed,  4 May 2022 11:01:39 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1nmClG-000w2F-OY; Wed, 04 May 2022 13:01:38 +0200
Date:   Wed, 4 May 2022 11:01:38 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
Message-ID: <YnJdEio0ifb9/McS@t480-pf1aa2c2>
References: <20220503200704.88003-1-hare@suse.de>
 <20220503200704.88003-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220503200704.88003-4-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lDjMv6hl7r0vb7tHQtunEzSZ748mWiyI
X-Proofpoint-GUID: lDjMv6hl7r0vb7tHQtunEzSZ748mWiyI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_03,2022-05-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=921 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040070
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 03, 2022 at 10:06:43PM +0200, Hannes Reinecke wrote:
> @@ -373,9 +373,11 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>  
>  static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>  {
> -	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
> -	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> -	int ret = SUCCESS, fc_ret;
> +	struct Scsi_Host *host = scpnt->device->host;
> +	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
> +	int ret = SUCCESS;
> +	unsigned long flags;
> +	struct zfcp_port *port;
>  
>  	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
>  		zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
> @@ -383,9 +385,16 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>  	}
>  	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>  	zfcp_erp_wait(adapter);
> -	fc_ret = fc_block_scsi_eh(scpnt);
> -	if (fc_ret)
> -		ret = fc_ret;
> +
> +	spin_lock_irqsave(&adapter->port_list_lock, flags);

That doesn't compile:

    || In file included from ./include/linux/kref.h:16,
    || drivers/s390/scsi/zfcp_scsi.c: In function ‘zfcp_scsi_eh_host_reset_handler’:
    drivers/s390/scsi/zfcp_scsi.c|389 col 27| error: passing argument 1 of ‘spinlock_check’ from incompatible pointer type [-Werror=incompatible-pointer-types]
    ||   389 |         spin_lock_irqsave(&adapter->port_list_lock, flags);
    ||       |                           ^~~~~~~~~~~~~~~~~~~~~~~~
    ||       |                           |
    ||       |                           rwlock_t *

You probably want `read_lock_irqsave()`.

The locking order looks fine, we already have places where we take the
`port_list_lock`, and then the `host_lock` (ffr:
`zfcp_erp_action_dismiss_adapter()`).

> +	list_for_each_entry(port, &adapter->port_list, list) {
> +		struct fc_rport *rport = port->rport;

Like Steffen said in the other review, this may be NULL here, since
`scpnt` can be from a different context, and there is no guarantees this
is always assigned, if you iterate over all port of an adapter.

So you want:

    if (!rport)
            continue;

Or some such, with a similar effect.

> +
> +		ret = fc_block_rport(rport);
> +		if (ret)
> +			break;
> +	}
> +	spin_unlock_irqrestore(&adapter->port_list_lock, flags);

Otherwise I like this better than having the code open-coded here, also
don't see any other obvious things missing than the two above.

>  
>  	zfcp_dbf_scsi_eh("schrh_r", adapter, ~0, ret);
>  	return ret;

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
