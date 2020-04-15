Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17ED7C2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 02:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE09320732
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 02:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pWHC5/B7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392859AbgDOCKt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 22:10:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392857AbgDOCKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 22:10:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F2AfBW123270;
        Wed, 15 Apr 2020 02:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=/o9xCxgZCh0gGnKFd0ytwjAncqwC3n/gIciqWKHLsqU=;
 b=pWHC5/B7xEUUJp3Nban6uPx+zY8P3gpv5yCUHLseKLHpJmeXmKPJSwfBL26TU8uosdiQ
 BzcagCumBvcJ+GOcCOnAs7nvXgN8fDvlg+q/qEWmoRKQmhHO+l8woNinwyOIP0gDvP4x
 2qc7MQfpDxxmzM+yQCa+qhabMNCrIsKEfqxtzVzqnbNNIUaGQwi7yeKfbdW4t3IoA2gk
 xrkt/BFFNPDfKv3f1BNr5bZGA5ZMGLmBvIzql6XiIdCmdUnO64B67vvbiIL640v4sFCK
 CCp5DZKH2SXtRdWkaNUUVBIOT5nfHCaj6r+qgtSQikoHFnnRTg/QiF+EXjWHsG73puwe NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30dn9cgpf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 02:10:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F27tAv097694;
        Wed, 15 Apr 2020 02:10:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30dn98j1sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 02:10:40 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03F2AcY5030241;
        Wed, 15 Apr 2020 02:10:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 19:10:38 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v4 09/14] scsi_debug: add zbc parameter
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
        <20200225062351.21267-10-dgilbert@interlog.com>
Date:   Tue, 14 Apr 2020 22:10:36 -0400
In-Reply-To: <20200225062351.21267-10-dgilbert@interlog.com> (Douglas
        Gilbert's message of "Tue, 25 Feb 2020 01:23:46 -0500")
Message-ID: <yq1lfmxpkgz.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

Forgot to comment on this:

> +MODULE_PARM_DESC(zbc, "'none' [0]; 'aware' [1]; 'managed' [2] (def=0). Can have 'host_' prefix");

[...]

> +static int sdeb_zbc_model_str(const char *cp)
> +{
> +	int res = -EINVAL;
> +
> +	if (isalpha(cp[0])) {
> +		if (strstr(cp, "none"))
> +			res = BLK_ZONED_NONE;
> +		else if (strstr(cp, "aware"))
> +			res = BLK_ZONED_HA;
> +		else if (strstr(cp, "managed"))
> +			res = BLK_ZONED_HM;
> +	} else {
> +		int n, ret;
> +
> +		ret = kstrtoint(cp, 0, &n);
> +		if (ret)
> +			return ret;
> +		if (n >= 0 || n <= 2)
> +			res = n;
> +	}
> +	return res;
> +}
> +
> +static ssize_t zbc_show(struct device_driver *ddp, char *buf)
> +{
> +	switch (sdeb_zbc_model) {
> +	case BLK_ZONED_NONE:	/* 0 */
> +		return scnprintf(buf, PAGE_SIZE, "none\n");
> +	case BLK_ZONED_HA:	/* 1, not yet supported */
> +		return scnprintf(buf, PAGE_SIZE, "host_aware\n");
> +	case BLK_ZONED_HM:	/* 2 */
> +		return scnprintf(buf, PAGE_SIZE, "host_managed\n");
> +	default:
> +		return scnprintf(buf, PAGE_SIZE, "unknown_zbc_model [0x%x]\n",
> +				 (unsigned int)sdeb_zbc_model);
> +	}
> +}

static const char *zbc_model[] = {
	[BLK_ZONED_NONE] = "none",
	[BLK_ZONED_HA]   = "host_aware",
	[BLK_ZONED_HM]   = "host_managed",
};

[...]

And then in parameter parsing you can do:

	sdeb_zbc_model = sysfs_match_string(zbc_model, buf);
	if (sdeb_zbc_model < 0)
		return -EINVAL;

zbc_show() can go away and you can do:

	pr_info(".... %s\n", zbc_model[sdeb_zbc_model]);

-- 
Martin K. Petersen	Oracle Linux Engineering
