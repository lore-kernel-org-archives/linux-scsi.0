Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9CBC77B75
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 10:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbjEHKwv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 06:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbjEHKwf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 06:52:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E94B2CFD9
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 03:52:03 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348AIVvm002220;
        Mon, 8 May 2023 10:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8mqdClI0JBIrM8nxnERhQaHUiKxZ9CpWG4heyAYbhFA=;
 b=nWxoQMKmAv5Fngd5FD4AUNOQt/NBRKX79gf9VIPCJOJPRf6WAzKcy48A/PZSLxkNyQ0R
 K6RlW+InKWgKPxg23FiDShuwYmzFnD4wvDyY+1KsFV02/oFS7LZl/vyst1xRczC8+Yfu
 4xYLryVQukTEBZuJFTV4FcTGLahNAYiIectwrEkyHw/NqI7leXIXFjNwCb+3bVEAxT2B
 jYZwCQq+OiHf7/7voAsTBlVY9hcbsiyfBD/IFjMNSUmujZ/Hw0Vw5y2XpQc1EtrqjCJx
 bUqTh7WLArXRwlmpcTbhMY1NQK+j5jNLYvW3xK2dSC/NoH1eO/hNIIL+f3E/A1KKTl9S dw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qey760vbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 10:51:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3481YxbC021745;
        Mon, 8 May 2023 10:51:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qde5fh2mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 10:51:11 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348Ap7Zt36897406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 10:51:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C84812004D;
        Mon,  8 May 2023 10:51:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAC9C2004B;
        Mon,  8 May 2023 10:51:07 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.41.150])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  8 May 2023 10:51:07 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pvySQ-000Wcm-2a;
        Mon, 08 May 2023 12:51:06 +0200
Date:   Mon, 8 May 2023 10:51:06 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 1/5] scsi: core: Use min() instead of open-coding it
Message-ID: <20230508105106.GB9720@t480-pf1aa2c2.fritz.box>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-2-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230503230654.2441121-2-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0E3jClIMgFC_uPX7-E4HcNUK3JRZcaCr
X-Proofpoint-GUID: 0E3jClIMgFC_uPX7-E4HcNUK3JRZcaCr
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_07,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 impostorscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080071
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 03, 2023 at 04:06:50PM -0700, Bart Van Assche wrote:
> Use min() instead of open-coding it in scsi_normalize_sense().
> 
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index 6e50e81a8216..24dec80a6253 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -176,8 +176,7 @@ bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
>  		if (sb_len > 2)
>  			sshdr->sense_key = (sense_buffer[2] & 0xf);
>  		if (sb_len > 7) {
> -			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
> -					 sb_len : (sense_buffer[7] + 8);
> +			sb_len = min(sb_len, sense_buffer[7] + 8);
>  			if (sb_len > 12)
>  				sshdr->asc = sense_buffer[12];
>  			if (sb_len > 13)

Looks good to me.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
