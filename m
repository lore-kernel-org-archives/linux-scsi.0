Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816B6CA9EA0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 12:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59E2E2184C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 12:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388525AbfJVMVW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 08:21:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387946AbfJVMVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Oct 2019 08:21:21 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9MCHSxI096833
        for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2019 08:21:20 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vt0rtaax9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2019 08:21:19 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 22 Oct 2019 13:21:17 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 22 Oct 2019 13:21:13 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9MCLD4v51052554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 12:21:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17D994C04A;
        Tue, 22 Oct 2019 12:21:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAA7C4C04E;
        Tue, 22 Oct 2019 12:21:12 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.97.37])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Oct 2019 12:21:12 +0000 (GMT)
Subject: Re: [PATCH 12/24] scsi: introduce scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-13-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Tue, 22 Oct 2019 14:21:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021095322.137969-13-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19102212-0020-0000-0000-0000037C7C96
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102212-0021-0000-0000-000021D2B8DC
Message-Id: <4097c14b-4b28-f7ee-595c-cb338b878d27@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-22_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910220112
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/19 11:53 AM, Hannes Reinecke wrote:
> Introduce scsi_build_sense() as a wrapper around
> scsi_build_sense_buffer() to format the buffer and set
> the correct SCSI status.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

>   drivers/s390/scsi/zfcp_scsi.c         |  5 +--

>   16 files changed, 60 insertions(+), 128 deletions(-)

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index e9ded2befa0d..da52d7649f4d 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -834,10 +834,7 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
>    */
>   void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
>   {
> -	scsi_build_sense_buffer(1, scmd->sense_buffer,
> -				ILLEGAL_REQUEST, 0x10, ascq);
> -	set_driver_byte(scmd, DRIVER_SENSE);
> -	scmd->result |= SAM_STAT_CHECK_CONDITION;
> +	scsi_build_sense(scmd, 1, ILLEGAL_REQUEST, 0x10, ascq);
>   	set_host_byte(scmd, DID_SOFT_ERROR);
>   }
> 

looks like a non-functional change for zfcp, so for this part:

Acked-by: Steffen Maier <maier@linux.ibm.com> # for zfcp

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a0db8d8766a8..2babf6df8066 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3117,3 +3117,21 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
>   	return group_id;
>   }
>   EXPORT_SYMBOL(scsi_vpd_tpg_id);
> +
> +/**
> + * scsi_build_sense - build sense data for a command

minor: I suppose kdoc&sphnix parse and render it correctly? Because 
Documentation/doc-guide/kernel-doc.rst says the format for function kdoc has 
"()" as function name suffix:
+ * scsi_build_sense() - build sense data for a command

> + * @scmd:	scsi command for which the sense should be formatted
> + * @desc:	Sense format (non-zero == descriptor format,
> + *              0 == fixed format)

Looks like this has already been like that. Not sure if this patch set touches 
every user of scsi_build_sense{_buffer}(). It would be nice to have meaningful 
identifiers for values passed to @desc, e.g. something like the following 
instead of "magic" zero and non-zero:

enum scsi_sense_format {
	SCSI_SENSE_FIXED = 0,
	SCSI_SENSE_DESCRIPTOR
};

> + * @key:	Sense key
> + * @asc:	Additional sense code
> + * @ascq:	Additional sense code qualifier
> + *
> + **/

minor:

+ */

[no double star at kdoc end?]

> +void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, u8 ascq)
> +{
> +	scsi_build_sense_buffer(desc, scmd->sense_buffer, key, asc, ascq);
> +	scmd->result = (DRIVER_SENSE << 24) | (DID_OK << 16) |
> +		SAM_STAT_CHECK_CONDITION;

While this is scsi_lib and thus "internal" helper code, I wonder if this should 
nonetheless use the helper functions to access and build scmd->result in order 
to have the error-prone bit shifts in only one central place?:

	scmd->result = SAM_STAT_CHECK_CONDITION;
	set_driver_byte(scmd, DRIVER_SENSE);
	set_host_byte(scmd, DID_OK);
	

> +}
> +EXPORT_SYMBOL_GPL(scsi_build_sense);

> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 6932d91472d5..9b9ca629097d 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -338,4 +338,7 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
>   	return xfer_len;
>   }
> 
> +extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
> +			     u8 key, u8 asc, u8 ascq);
> +
>   #endif /* _SCSI_SCSI_CMND_H */
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

