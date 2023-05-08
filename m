Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CB6C77B7F
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 11:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbjEHL0x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 07:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbjEHL0o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 07:26:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D423A5F1
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 04:26:19 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348BMFpu014395;
        Mon, 8 May 2023 11:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3WHp7+dnWpDDBm2CFKCtMv5zJR391LGxU2HN+7PUk+E=;
 b=UE3PjhRo5SI8RM5JuDpRD2XK4Qs9dZpRhSkOnmGvWS0WJ1Gc6xx9LE6hL3AQt7iM3omL
 QLiz9VDQy5IXLV8ttMZJXF/MZpjom/ymRWMQAH9Y+xcOX8MGAg+i0O03LID7m8SuI1Pb
 qV1zhswrX72YRV/x6SQPSteeUMLekal9LDBkjOV6JfM/9bti42jEIuF8oEHLN3rTGeb9
 N5dm0S2kCpUVTCZLR4qB6ts7MLlDCvdpfgBksRAqHMJaX9bysn6b55QG6kxqeXo3MWcc
 Qpv9kkCbei9iGEtOQL5rpCbWo3ol+WRJKtW0LnE6L3Bn2fpuUH+MQXUpVD3yLJAyRb63 vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf054g1kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 11:25:57 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 348BNCsR016357;
        Mon, 8 May 2023 11:25:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf054g1k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 11:25:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3484kpD5023761;
        Mon, 8 May 2023 11:25:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qdeh6h2pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 11:25:54 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348BPprZ9175644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 11:25:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DD192004B;
        Mon,  8 May 2023 11:25:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F25FC20040;
        Mon,  8 May 2023 11:25:50 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.41.150])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  8 May 2023 11:25:50 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pvz02-000XXt-0C;
        Mon, 08 May 2023 13:25:50 +0200
Date:   Mon, 8 May 2023 11:25:50 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 2/5] scsi: core: Update a source code comment
Message-ID: <20230508112550.GC9720@t480-pf1aa2c2.fritz.box>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-3-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230503230654.2441121-3-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LNiTymcZQO33NM1HdByc22UQMBvC3RqZ
X-Proofpoint-ORIG-GUID: JURq2z6rh7p113Yjk_wo8an87ltk2095
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1011 spamscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2305080075
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 03, 2023 at 04:06:51PM -0700, Bart Van Assche wrote:
> The proc_name SCSI host template attribute is used for:
> - The name of the /proc directory if CONFIG_SCSI_PROC_FS=y.

But now you remove that case completely? It seems kinda strange to
bother touching the comment, but then only switching from one incomplete
form to an other?

> - The contents of the proc_name SCSI host sysfs attribute.
> 
> The current comment in include/scsi/scsi_host.h is not correct if
> CONFIG_SCSI_PROC_FS=n. Hence, change that comment.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/scsi/scsi_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 0f29799efa02..18632adca17e 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -365,7 +365,7 @@ struct scsi_host_template {
>  
>  
>  	/*
> -	 * Name of proc directory
> +	 * Name reported via the proc_name SCSI host sysfs attribute.
>  	 */
>  	const char *proc_name;
>  

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
