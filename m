Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC623C001B0
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 09:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbjHPJ7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 05:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243658AbjHPJ6i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 05:58:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13285138;
        Wed, 16 Aug 2023 02:58:36 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37G9uoO7021340;
        Wed, 16 Aug 2023 09:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=2OpW7RqPwqtTzHPRZqMZJnRmO56JfOvmAF24/QRai0o=;
 b=aYGa4JKycbVT3DXiP9kBR+QDd1Ogl1MfBPRmSAcMGUmMAA2ijDaPs8TmDwts2UURR3x1
 AuD6D07JIjfV16WNCqRvcP8ZgYyOyn6c8554oT39lv+WAidha7J2PIg/1jdtKLSMJAsl
 m/rkp835kqRAjW5aaVgGPPOLOAYDmafutHtrt1NnwqZUkINKfTy7/1KJrlsQv9eiWRAp
 +G15sjt/VaHxtaM0cxdimfH7one+av8BJW+9cgQ61LSwU7rwhqBMrJ9abshZxsQIaITc
 FCUZTD1wP11GQLV0rK5JCfC2nMorJXshrCvAxtF/zXUtvzItJ2xy9ehiMm3/nDU0WKjA bA== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgv96g12r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 09:58:20 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37G8sVe0002418;
        Wed, 16 Aug 2023 09:58:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sendnbdkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 09:58:20 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37G9wHDJ21234344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 09:58:17 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06A6C2004B;
        Wed, 16 Aug 2023 09:58:17 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0ABE20043;
        Wed, 16 Aug 2023 09:58:16 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.26.170])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 16 Aug 2023 09:58:16 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qWDI8-0007AK-1K;
        Wed, 16 Aug 2023 11:58:16 +0200
Date:   Wed, 16 Aug 2023 11:58:16 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Steffen Maier <maier@linux.ibm.com>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 1/3] scsi: core: Fix the scsi_set_resid() documentation
Message-ID: <20230816095816.GA9823@p1gen4-pw042f0m.fritz.box>
References: <20230721160154.874010-1-bvanassche@acm.org>
 <20230721160154.874010-2-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230721160154.874010-2-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DkFW5fGLnhsqbvzMoJPfal25Rwo5_ZDU
X-Proofpoint-ORIG-GUID: DkFW5fGLnhsqbvzMoJPfal25Rwo5_ZDU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-16_07,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1011 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308160085
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 21, 2023 at 09:01:32AM -0700, Bart Van Assche wrote:
> Because scsi_finish_command() subtracts the residual from the buffer
> length, residual overflows must not be reported. Reflect this in the
> SCSI documentation. See also commit 9237f04e12cc ("scsi: core: Fix
> scsi_get/set_resid() interface")
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  Documentation/scsi/scsi_mid_low_api.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 6fa3a6279501..022198c51350 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -1190,11 +1190,11 @@ Members of interest:
>  		 - pointer to scsi_device object that this command is
>                     associated with.
>      resid
> -		 - an LLD should set this signed integer to the requested
> +		 - an LLD should set this unsigned integer to the requested
>                     transfer length (i.e. 'request_bufflen') less the number
>                     of bytes that are actually transferred. 'resid' is
>                     preset to 0 so an LLD can ignore it if it cannot detect
> -                   underruns (overruns should be rare). If possible an LLD
> +                   underruns (overruns should not be reported). An LLD

I'm very late to party, sorry. But we have certainly seen at least one
overrun reported some years ago on a FC SAN. We've changed some handling
in zFCP due to that (
a099b7b1fc1f ("scsi: zfcp: add handling for FCP_RESID_OVER to the fcp ingress path")
). The theory back than was, that it was cause by either a faulty ISL in
the fabric, or some other "bit-errors" on the wire that caused some FC
frames being dropped during transmit.

I added that we mark such commands with `DID_ERROR`, so they are
retried, if that is permissible.

>                     should set 'resid' prior to invoking 'done'. The most
>                     interesting case is data transfers from a SCSI target
>                     device (e.g. READs) that underrun.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
