Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BEFC7EE22
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 10:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbjEHKJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 06:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbjEHKJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 06:09:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9925A35128
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 03:09:38 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3489PxtS003954;
        Mon, 8 May 2023 10:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cRxdf/g/6R+VEnVdgZaHveV1giBUrq7pxJxyCAbhLk0=;
 b=PwN0vQo5bC2J3loju6Hg5wTUAviZEzy1g94E2Xc++rfqqpayqyzVe/Phv4m0SmOoodPU
 RjB5Lg5HwatLWOYIJIJVAjIvfacIMtB0msR23oi/p7aMbPEZUYn/BCeqBuxgWUvQddz0
 ae114HZY8vMDggBIJ5jBHKNpDa9GXqTCMvZtsOyUuq+jafW3HltQ1mWVJO1wVyia33x+
 M5fhiPCNIkDfy7APrtnrwMnqeXIN26Q4VIoYgGkcv7AWNRVoGqUGaMQIBKezlVZBwk2k
 vurSsN/oI/Xt4lvTxYk7Cigoy9IFiFYvjscwolFqj4vB7EVoOpL6Udq3q7NLKYbKf+1O gQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qexeshfsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 10:09:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3484kpB0023761;
        Mon, 8 May 2023 10:09:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qdeh6h1k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 10:09:33 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348A9VIb3670578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 10:09:31 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9B0420043;
        Mon,  8 May 2023 10:09:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8349720040;
        Mon,  8 May 2023 10:09:31 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.41.150])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  8 May 2023 10:09:31 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pvxoA-000Vdg-1U;
        Mon, 08 May 2023 12:09:30 +0200
Date:   Mon, 8 May 2023 10:09:30 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org,
        Seamus Connor <sconnor@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] scsi: sd: Avoid sending an INQUIRY if the page is not
 supported
Message-ID: <20230508100930.GA9720@t480-pf1aa2c2.fritz.box>
References: <20230505204950.21645-1-brian@purestorage.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230505204950.21645-1-brian@purestorage.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hJRFMK0jFqvqHLRbr62lMi0s5w9DBjSs
X-Proofpoint-GUID: hJRFMK0jFqvqHLRbr62lMi0s5w9DBjSs
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_05,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 clxscore=1011
 priorityscore=1501 bulkscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2305080068
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 05, 2023 at 01:49:50PM -0700, Brian Bunker wrote:
> When SCSI devices are discovered the function sd_read_cpr gets called.
> This call results in an INQUIRY to page 0xb9. This VPD page is called
> regardless of whether the target has advertised this page as supported.
> 
> Instead of just sending this INQUIRY page, first check to see if that
> page is in the supported pages. This will avoid sending requests to
> targets which do not support the page. The error is unexpected on the
> target and leads to questions. I am not sure what percentage of SCSI
> devices support this page, but this will eliminate at least one
> request to the target in the discovery phase for all that do not. The
> function added could also have potential users besides this specific
> one.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Reviewed-by: Seamus Connor <sconnor@purestorage.com>
> Reviewed-by: Krishna Kant <krishna.kant@purestorage.com>
> ---
>  drivers/scsi/scsi.c        | 40 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/sd.c          |  4 +++-
>  include/scsi/scsi_device.h |  1 +
>  3 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 09ef0b31dfc0..9265b3d6a18f 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -356,6 +356,46 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
>  	return result;
>  }
>  
> +/**
> + * scsi_vpd_page_supported - Check if a VPD page is supported on a SCSI device
> + * @sdev: The device to ask
> + * @page: Check existence of this Vital Product Data page
> + *
> + * Functions which explicitly request a given VPD page
> + * should first check whether that page is among the
> + * supported VPD pages. This will avoid targets returning
> + * unnecessary errors which can cause confusion. -EINVAL is
> + * returned if the page is not supported and 0 if it is.
> + */
> +int scsi_vpd_page_supported(struct scsi_device *sdev, u8 page)
> +{
> +	const struct scsi_vpd *vpd;
> +	uint16_t page_len;

Probably rather `u16` as per kernel-style.

> +	int ret = -EINVAL;

Been wondering, whether it would make sense to have two different error
levels here. One for the case where the page is not found in the loop
that searches within page 0, and one for when page 0 is not present when
we try to dereference the RCU protected pointer.

That way we could have a safe fallback. If the page is there, we use its
data, if it is not, we blindly send the INQUIRY like we do today.

Not sure whether this is a bit too paranoid.. VPD page 0 is mandatory
after all.

> +	int pos = 0;
> +
> +	rcu_read_lock();
> +	vpd = rcu_dereference(sdev->vpd_pg0);
> +	if (!vpd)
> +		goto out;
> +
> +	page_len = get_unaligned_be16(&vpd->data[2]);
> +
> +	/*
> +	 * The first supported page starts at byte 4 in the buffer.
> +	 * Read from that byte to the last dictated by page_len above.
> +	 */
> +	for (pos = 4; pos < page_len + 4; ++pos) {
> +		if (vpd->data[pos] == page)
> +			ret = 0;
> +	}
> +
> +out:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(scsi_vpd_page_supported);
> +
>  /**
>   * scsi_get_vpd_page - Get Vital Product Data from a SCSI device
>   * @sdev: The device to ask
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1624d528aa1f..0304b7d60747 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3127,7 +3127,9 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
>  	 */
>  	buf_len = 64 + 256*32;
>  	buffer = kmalloc(buf_len, GFP_KERNEL);
> -	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
> +	if (!buffer ||
> +	    scsi_vpd_page_supported(sdkp->device, 0xb9) ||

Wouldn't it make sense to do this before the allocation? If it really
turns out to be unsupported, that seems like a waste.

> +	    scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
>  		goto out;
>  
>  	/* We must have at least a 64B header and one 32B range descriptor */
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f10a008e5bfa..359cd8b94312 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -431,6 +431,7 @@ extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
>  			    struct scsi_sense_hdr *);
>  extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
>  				int retries, struct scsi_sense_hdr *sshdr);
> +extern int scsi_vpd_page_supported(struct scsi_device *sdev, u8 page);
>  extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
>  			     int buf_len);
>  extern int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
