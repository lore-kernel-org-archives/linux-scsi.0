Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AFDC4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 01:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCD712080A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 01:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IkYyqx9C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503672AbgJ0A77 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:59:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49640 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441348AbgJ0A75 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 20:59:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R0sSJB112355;
        Tue, 27 Oct 2020 00:59:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=S1enjL1lvdDpS2+/rvF1O1D4hoQQPJpifLn5wEVQK/U=;
 b=IkYyqx9Ca7mjKo6xgMPmN0d3D3Vbgfeqd1vNy2ITfY7+vD31PCmk5sBSSiqyqA0KAGk3
 uJkgUlxjZ9Eb3donFNIRzhWuSkt8qGaHnb30N+s9dNc6sxj7u2osbkO5+mQSnl/Ow7QQ
 rL2OQuKM1u/EQKuanXY1mUa2+H2IFWB+BNZxMWAJei5OG7Xvwu5mmRV6opbpp6ujM9uJ
 IEjdTYuTDliQe2XfmxN4fpHpBDVzG0UOP0Rdl/OMjzpd4ol3P9bgLpwoZU28AVzEVVIa
 C6f4XjTzgwGbML0oASvfppy2ZM7HA2TPf5LXm42ush5SDTFjBDM8ZD1AfVwIZNDEzwCQ jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm3w020-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 00:59:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R0tjTe125724;
        Tue, 27 Oct 2020 00:57:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx6vbndf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 00:57:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09R0vnEf010921;
        Tue, 27 Oct 2020 00:57:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 17:57:49 -0700
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/4] bfa: Remove legacy printk() usage
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1pk5wb8.fsf@ca-mkp.ca.oracle.com>
References: <20201019121756.74644-1-hare@suse.de>
        <20201019121756.74644-2-hare@suse.de>
Date:   Mon, 26 Oct 2020 20:57:47 -0400
In-Reply-To: <20201019121756.74644-2-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 19 Oct 2020 14:17:53 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Hannes,

> Replace the remaining callsites to use dev_printk() and friends.
> @@ -336,9 +328,7 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
>  	/* offset and len sanity check */
>  	rc = bfad_reg_offset_check(bfa, addr, 1);
>  	if (rc) {
> -		printk(KERN_INFO
> -			"bfad[%d]: Failed reg offset check\n",
> -			bfad->inst_no);
> +		BFA_MSG(KERN_INFO, bfad, "Failed reg offset check\n");
>  		return -EINVAL;
>  	}
>  
> diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
> index eaee7c8bc2d2..619a7e47553b 100644
> --- a/drivers/scsi/bfa/bfad_drv.h
> +++ b/drivers/scsi/bfa/bfad_drv.h
> @@ -286,6 +286,9 @@ do {									\
>  		dev_printk(level, &((bfad)->pcidev)->dev, fmt, ##arg);	\
>  } while (0)
>  
> +#define BFA_MSG(level, bfad, fmt, arg...)			\
> +	dev_warn(&((bfad)->pcidev)->dev, "bfad%d: " fmt, (bfad)->inst_no, ##arg);
> +

Looks like all the KERN_{INFO,ALERT,ERR} messages get turned into
KERN_WARNING with this change. 'level' doesn't appear to be used
anywhere. Am I missing something?

-- 
Martin K. Petersen	Oracle Linux Engineering
