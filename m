Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764E4C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 14:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C94E6054E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 14:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbhHQO4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 10:56:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63486 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232705AbhHQO4k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 10:56:40 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HEiC0M090609;
        Tue, 17 Aug 2021 10:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KlDhjTlXDG2wys5BYoFlpJza6TZlKxDU7N3QUG1sXv0=;
 b=UTGs85hJQbFZI3DmDxbuW7Zs6XGMUuAPZ83zZNxmKj9M1FeLeo9GMKO1RK+wr0io7aN2
 guI0cZYYEJy+6oqRMuu9se3E4Evfzntxsw3GR7T1fXJQzai1uT4VXJI2kThT60FctzPj
 CJ02mG4V3GI3ABB/0WswRB0S2lLdh78yeRDzDKnaa8c0cJLKk9/ejYCTAGW/I5Bm8Qhd
 i09FBT3WCV5GX6JNscgJ/32IeqVIxhGOL2qb01qLHBvqsioJdzZSw/E1TlTcKao00XRW
 q+4CwkLdR6fycJuDNdCE7JKDCXQJ/4BZPTWR4O1Adul1SUGIBoW3OYLroPbkSR0xTmKN TA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcsq5h8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 10:55:55 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HEtq95025180;
        Tue, 17 Aug 2021 14:55:53 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8d2mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 14:55:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HEqPMj57803176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 14:52:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DC90AE063;
        Tue, 17 Aug 2021 14:55:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4459AE051;
        Tue, 17 Aug 2021 14:55:49 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.145.34.10])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Aug 2021 14:55:49 +0000 (GMT)
Subject: Re: [PATCH 10/51] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-11-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <a1694063-bf66-42e0-d892-ee5a8bc1b67c@linux.ibm.com>
Date:   Tue, 17 Aug 2021 16:55:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210817091456.73342-11-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rFNkgKf8l-PAoZGakoHa_0ojOrqdlrBf
X-Proofpoint-GUID: rFNkgKf8l-PAoZGakoHa_0ojOrqdlrBf
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_04:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108170089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 11:14 AM, Hannes Reinecke wrote:
> Issuing a host reset should not rely on any commands.
> So use Scsi_Host as argument for eh_host_reset_handler.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Steffen Maier <maier@linux.ibm.com> # for zfcp and common code

Acked-by: Steffen Maier <maier@linux.ibm.com> # for zfcp

> ---
>   Documentation/scsi/scsi_eh.rst                |  2 +-
>   Documentation/scsi/scsi_mid_low_api.rst       |  4 +-

>   drivers/s390/scsi/zfcp_scsi.c                 |  3 +-

>   drivers/scsi/scsi_error.c                     |  2 +-

>   include/scsi/scsi_host.h                      |  2 +-
>   78 files changed, 271 insertions(+), 334 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
> index 7d78c2475615..1ca451ad57df 100644
> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -216,7 +216,7 @@ considered to fail always.
>       int (* eh_abort_handler)(struct scsi_cmnd *);
>       int (* eh_device_reset_handler)(struct scsi_cmnd *);
>       int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> -    int (* eh_host_reset_handler)(struct scsi_cmnd *);
> +    int (* eh_host_reset_handler)(struct Scsi_Host *);
> 
>   Higher-severity actions are taken only when lower-severity actions
>   cannot recover some of failed scmds.  Also, note that failure of the
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 63ddea2b9640..784587ea7eee 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -777,7 +777,7 @@ Details::
> 
>       /**
>       *      eh_host_reset_handler - reset host (host bus adapter)
> -    *      @scp: SCSI host that contains this device should be reset
> +    *      @shp: SCSI host that contains this device should be reset
>       *
>       *      Returns SUCCESS if command aborted else FAILED
>       *
> @@ -794,7 +794,7 @@ Details::
>       *
>       *      Optionally defined in: LLD
>       **/
> -	int eh_host_reset_handler(struct scsi_cmnd * scp)
> +	int eh_host_reset_handler(struct Scsi_Host * shp)
> 
> 
>       /**


> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 9393f1587e8a..8bfa8ffd9ff6 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -371,9 +371,8 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>   	return ret;
>   }
> 
> -static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
> +static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
>   {
> -	struct Scsi_Host *host = scpnt->device->host;
>   	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
>   	int ret = SUCCESS;
>   	unsigned long flags;

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 58a252c38992..8218e2976482 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -811,7 +811,7 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
>   	if (!hostt->eh_host_reset_handler)
>   		return FAILED;
> 
> -	rtn = hostt->eh_host_reset_handler(scmd);
> +	rtn = hostt->eh_host_reset_handler(host);
> 
>   	if (rtn == SUCCESS) {
>   		if (!hostt->skip_settle_delay)


> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 75363707b73f..3b1acf91f4d0 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -142,7 +142,7 @@ struct scsi_host_template {
>   	int (* eh_device_reset_handler)(struct scsi_cmnd *);
>   	int (* eh_target_reset_handler)(struct scsi_cmnd *);
>   	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> -	int (* eh_host_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_host_reset_handler)(struct Scsi_Host *);
> 
>   	/*
>   	 * Before the mid layer attempts to scan for a new device where none
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
