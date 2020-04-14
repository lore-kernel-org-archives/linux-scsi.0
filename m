Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D76C2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109A42072D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZrPuHshk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404082AbgDNCYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 22:24:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59552 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404081AbgDNCYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 22:24:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E2O3WB010318;
        Tue, 14 Apr 2020 02:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=t4eKfAwyfr4D6bNsOz0yIgRyfjLhl7oFAs6Wka9SRdY=;
 b=ZrPuHshkCPN1/thyewt0AlSqMW3vZwidB7LGiawivWzrg+H6ej3jtREpZgt8yu+LcccW
 COc/RCChoCdLJX707eV1AQOTXhrjAuRUVJPjgFbfdYe76GXMPeDX++4u9hQ3P2FBMOMp
 +tG/pIkk7ALKrUWdDRG7lNsvx8l1NwgZcpV9NdKSQ+EUx9tkBvWjeNAvC9PsqTOiSVFl
 yB0IjlpRkHnZRmSc9Lb4NuiLglsFqzV+ES1LiDUjeYiMk7R6Ss7ySIguIf2I0bdiG9fS
 E2b1J0esQ/xKotAdrvEgxdQ4kJEF6GoG4scrLN/fhjm84mu7W2ZMfYd3/5jwdYDaydhL 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30b5um1rt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 02:24:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E2LsTZ186065;
        Tue, 14 Apr 2020 02:24:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30bqpeccfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 02:24:42 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03E2OeX8028120;
        Tue, 14 Apr 2020 02:24:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 19:24:39 -0700
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to FCP_PRIO_CFG_SIZE
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200405231339.29612-1-bvanassche@acm.org>
        <20200413153049.GA8042@SPB-NB-133.local>
Date:   Mon, 13 Apr 2020 22:24:37 -0400
In-Reply-To: <20200413153049.GA8042@SPB-NB-133.local> (Roman Bolshakov's
        message of "Mon, 13 Apr 2020 18:30:49 +0300")
Message-ID: <yq11roqu7mi.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Roman,

>> -	struct qla_fcp_prio_entry entry[1];     /* fcp priority entries  */
>> +	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
>>  #define FCP_PRIO_CFG_ENTRY_SIZE 0x20
>> +	uint8_t  reserved2[16];
>>  };
>>  
>>  #define FCP_PRIO_CFG_SIZE       (32*1024) /* fcp prio data per port*/
>
> A new constant may be introduced to define size of qla_fcp_prio_entry.
> That would let to drop the magic 32 number here and allow to add one
> more BUILD_BUG_ON for sizeof(struct qla_fcp_prio_entry).

I agree that additional sanity testing here would be nice.

I wonder what the firmware interface says about the runt entry?

-- 
Martin K. Petersen	Oracle Linux Engineering
