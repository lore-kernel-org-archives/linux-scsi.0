Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655E2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 17:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbiECRZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 13:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbiECRZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 13:25:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A703E2127E
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 10:21:39 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243H0Eom010557;
        Tue, 3 May 2022 17:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PxQiOQ+AmXMkct9JRS8sIrCiNsIYB6wh5XulWoHrp8o=;
 b=otgjYZiOvoBPCgZPq6c+bjeyictl9E2FU3gAYAPCtXWpKFN+3uShb2DXEGwr4Q1ad4a4
 IdU5I6UcdVZ8xKzwzC8hJfyIO1VlAr7LwlgqxNgqIaCbrxCByvRQgoGyK+c/pmb1Mu93
 HVjgGM3SWY7K0VHSGWDhr6I3n++bQwu6mjogizHX1N8+/7lBFhlOUstVCOiEgD8iy3JX
 s8MbbC/0oXyXKtoV/n2lnQu6EJXA4uz3sheKUx1Wjo+Ofv386YMoFFENJnjWPrT5IPwD
 kH8PZS5oIcI6sU3aai2srjeAtSHjT/ta+taWl75oqxS8UoN7U7NH7HP3P+cFG7ABv5pH RQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fu8dpgdq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 17:21:28 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 243HIHs5008360;
        Tue, 3 May 2022 17:21:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3frvr8kkfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 17:21:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 243HLN0p39125470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 May 2022 17:21:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ED2111C052;
        Tue,  3 May 2022 17:21:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF0B111C04C;
        Tue,  3 May 2022 17:21:22 +0000 (GMT)
Received: from [9.145.89.110] (unknown [9.145.89.110])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 May 2022 17:21:22 +0000 (GMT)
Message-ID: <6e2c56db-99bc-64d6-34e0-af0f21de9707@linux.ibm.com>
Date:   Tue, 3 May 2022 19:21:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-4-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20220502213820.3187-4-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kNqEwvRqmpZ7TDxwS1x3MKkXpIKKgXqF
X-Proofpoint-ORIG-GUID: kNqEwvRqmpZ7TDxwS1x3MKkXpIKKgXqF
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-03_07,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205030111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

On 5/2/22 23:37, Hannes Reinecke wrote:
> When issuing a host reset we should be waiting for all
> ports to become unblocked; just waiting for one might
> be resulting in host reset to return too early.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Cc: Steffen Maier <maier@linux.ibm.com>
> Cc: Benjamin Block <bblock@linux.ibm.com>
> ---
>   drivers/s390/scsi/zfcp_scsi.c | 29 +++++++++++++++++++++++------
>   1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 526ac240d9fe..fb2b73fca381 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -373,9 +373,11 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>   
>   static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>   {
> -	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
> -	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> -	int ret = SUCCESS, fc_ret;
> +	struct Scsi_Host *host = scpnt->device->host;
> +	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
> +	int ret = SUCCESS;
> +	unsigned long flags;
> +	struct zfcp_port *port;
>   
>   	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
>   		zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
> @@ -383,9 +385,24 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>   	}
>   	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>   	zfcp_erp_wait(adapter);
> -	fc_ret = fc_block_scsi_eh(scpnt);
> -	if (fc_ret)
> -		ret = fc_ret;
> +retry_rport_blocked:
> +	spin_lock_irqsave(host->host_lock, flags);
> +	list_for_each_entry(port, &adapter->port_list, list) {

Reading adapter->port_list needs to be protected by
	read_lock_irq(&adapter->port_list_lock);

Cf. Benjamin's last review 
https://lore.kernel.org/linux-scsi/YRujHScPbb1Aokrj@t480-pf1aa2c2.linux.ibm.com/

> +		struct fc_rport *rport = port->rport;

While an rport is blocked, port->rport == NULL [zfcp_scsi_rport_block() and 
zfcp_scsi_rport_register()], so below could be a NULL pointer deref.
Or is there evidence we would never have a blocked rport while iterating 
port_list here?

See also my previous review comments 
https://lore.kernel.org/linux-scsi/a7950ea7-380c-bb01-7f31-5c555217ad2d@linux.vnet.ibm.com/
It also alludes to lock ordering.

> +
> +		if (rport->port_state == FC_PORTSTATE_BLOCKED) {
> +			if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
> +				ret = FAST_IO_FAIL;
> +			else
> +				ret = NEEDS_RETRY;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(host->host_lock, flags);
> +	if (ret == NEEDS_RETRY) {
> +		msleep(1000);
> +		goto retry_rport_blocked;
> +	}
>   
>   	zfcp_dbf_scsi_eh("schrh_r", adapter, ~0, ret);
>   	return ret;


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
