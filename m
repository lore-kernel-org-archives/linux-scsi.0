Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE59C2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 22:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62C420678
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 22:25:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X31Gymat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389546AbgDMWZK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 18:25:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389528AbgDMWZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 18:25:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMEunV161790;
        Mon, 13 Apr 2020 22:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=pIzxtccyHGiv/0TvfJz1ycnKa6Tn8QCOgk6XDCy6uSE=;
 b=X31GymatIqPdVbvQCKtX6sAb/xn/oOLS5NLaGrm7dZb6dR3rEGDoJX13cv3hoBOjwe5M
 csTZ5/4HbLbS7g2JU9IkjjrTG4ZRt0WBrZD/O2X0LLUx8D0TVf1qytlnWUYUMBFwWCcm
 2BaAmXsY2wgr88yfRbbl8pGKZQPAn3n1ATEkl56QMD+C0KCd3GBIMPkDpuZxDXylV+2E
 IZYwHuxcDCpbLWDFeJdnnCULhLbsEXF6hSH0JQIkqbtCZ308eoSnB3gTcRqQwowK0Jij
 mRhJd6nFALsaSnB4O++3yuCKFXacSvI1JT5prNktsl8U0OD/FMTlvG/XbseotWv3XnQA fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30b5um177p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:25:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMD31j114651;
        Mon, 13 Apr 2020 22:25:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30cta88ee5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:25:00 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DMOwOH008034;
        Mon, 13 Apr 2020 22:24:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 15:24:58 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v4 01/14] scsi_debug: randomize command completion time
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
        <20200225062351.21267-2-dgilbert@interlog.com>
Date:   Mon, 13 Apr 2020 18:24:56 -0400
In-Reply-To: <20200225062351.21267-2-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Tue, 25 Feb 2020 01:23:38 -0500")
Message-ID: <yq1y2qzvxaf.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130163
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> +static bool sdebug_random = DEF_RANDOM;

[...]

> +static ssize_t random_show(struct device_driver *ddp, char *buf)
> +{
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)sdebug_random);
> +}

Minor nit: I prefer %u for booleans.

> +static ssize_t random_store(struct device_driver *ddp, const char *buf,
> +			    size_t count)
> +{
> +	int n;
> +
> +	if (count > 0 && kstrtoint(buf, 10, &n) == 0 && n >= 0) {
> +		sdebug_random = (n > 0);
> +		return count;
> +	}
> +	return -EINVAL;
> +}

kstrtobool()?

Also, you don't need to check for count > 0. This function won't be
called if count = 0.

-- 
Martin K. Petersen	Oracle Linux Engineering
