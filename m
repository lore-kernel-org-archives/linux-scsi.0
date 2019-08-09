Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6909C31E40
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 23:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6CE820B7C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 23:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfHIXMr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Aug 2019 19:12:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32310 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726125AbfHIXMq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2019 19:12:46 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79NCDmp081237;
        Fri, 9 Aug 2019 19:12:36 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u9f46e586-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 19:12:36 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x79NA0wA030153;
        Fri, 9 Aug 2019 23:12:35 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 2u51w6681a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 23:12:35 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x79NCY8R62390778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Aug 2019 23:12:34 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E8756E04C;
        Fri,  9 Aug 2019 23:12:34 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 254666E054;
        Fri,  9 Aug 2019 23:12:33 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.173.245])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  9 Aug 2019 23:12:32 +0000 (GMT)
Message-ID: <1565392352.17449.15.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 13/20] sg: add sg v4 interface support
From:   James Bottomley <jejb@linux.vnet.ibm.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org
Date:   Fri, 09 Aug 2019 16:12:32 -0700
In-Reply-To: <20190807114252.2565-14-dgilbert@interlog.com>
References: <20190807114252.2565-1-dgilbert@interlog.com>
         <20190807114252.2565-14-dgilbert@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090227
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2019-08-07 at 13:42 +0200, Douglas Gilbert wrote:
> Add support for the sg v4 interface based on struct sg_io_v4 found
> in include/uapi/linux/bsg.h and only previously supported by the
> bsg driver. Add ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE) for
> async (non-blocking) usage of the sg v4 interface. Do not accept
> the v3 interface with these ioctls. Do not accept the v4
> interface with this driver's existing write() and read()
> system calls.
> 
> For sync (blocking) usage expand the existing ioctl(SG_IO)
> to additionally accept the sg v4 interface object.

First the meta comments:

Since this is effectively a new interface for sg, we're not constrained
by what happened before.  Specifically, we don't want to support the
read/write interface for v4, that should remain only for legacy v3.

We're already discussing what the correct async interface should look
like, I won't comment on the IOSUBMIT/IORECEIVE parts.

Given that we want to unify the v4 code paths, I think this:
 
> @@ -1293,15 +1528,25 @@ sg_ctl_sg_io(struct file *filp, struct
> sg_device *sdp, struct sg_fd *sfp,
>  		return res;
>  	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
>  		return -EFAULT;
> -	if (h3p->interface_id == 'S')
> -		res = sg_submit(filp, sfp, h3p, true, &srp);
> -	else
> +	if (h3p->interface_id == 'Q') {
> +		/* copy in rest of sg_io_v4 object */
> +		if (copy_from_user(hu8arr + SZ_SG_IO_HDR,
> +				   ((u8 __user *)p) + SZ_SG_IO_HDR,
> +				   SZ_SG_IO_V4 - SZ_SG_IO_HDR))
> +			return -EFAULT;
> +		res = sg_v4_submit(filp, sfp, p, h4p, true, &srp);

Can simply become

if (h3p->interface_id == 'Q')
	return bsg_sg_io(sdp->request_queue, filp->file_mode, p);

And all the duplicate code could then be eliminated.  Of course, we
have to export bsg_sg_io, but that should be a trivial addition.

James


