Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59955C77B7F
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 14:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbjEHOJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 10:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbjEHOJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 10:09:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C314C17
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 07:09:20 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348E5Zea024863;
        Mon, 8 May 2023 14:08:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8UHUO5FqrWvui7+aTjjkgUEEJkrXICVtYTUQb4DyEro=;
 b=mvCnfCzEyCsxg0yBNLbdXNXf68YVAcEnSzIuO1fEnfg0fRIMC/oBoY6I0YRKTbUqbVtR
 1dFv2X8FGb6owgGafbhNbmts2Ox2oOpp7s78NpnNB/oz60B142LrIAVzaoYNgGw0whM7
 oJp3TQQqZukfi0JXt10wk2CUSGS0ai5Wep9xY0UhZhnAZ49+e3A/a/9zXoKP/UOOfWau
 X6jCishm/ToUn9WtsWK+u4XhaKAheIY7fKJzZ/NTjVgBoJwqXc+CfYWA8fNiW3kGBnXC
 OVnVP46qDfhW/cwYjidpOdABENN7YdauJO59jvML9qUEkx3c9Uxqzx7Ig6LL3t5t/xz3 VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf1yr19at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 14:08:38 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 348E664p028311;
        Mon, 8 May 2023 14:08:32 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf1yr14vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 14:08:32 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 348BXPnE007850;
        Mon, 8 May 2023 14:05:57 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qdeh6gxpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 14:05:56 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348E5sob17433088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 14:05:54 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8759F2004B;
        Mon,  8 May 2023 14:05:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62CF320040;
        Mon,  8 May 2023 14:05:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.41.150])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  8 May 2023 14:05:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pw1Uv-000aUz-1S;
        Mon, 08 May 2023 16:05:53 +0200
Date:   Mon, 8 May 2023 14:05:53 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Changyuan Lyu <changyuanl@google.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>
Subject: Re: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
Message-ID: <20230508140553.GD9720@t480-pf1aa2c2.fritz.box>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-4-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230503230654.2441121-4-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qP8E7qMVrYHgC5RZ9IoV_M8HnOhVbceh
X-Proofpoint-ORIG-GUID: o1ymxom0dGOgps-KV_SNvMiGCYWGdhbq
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_10,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 spamscore=0 mlxlogscore=999 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 03, 2023 at 04:06:52PM -0700, Bart Van Assche wrote:
> If a command fails, SCSI sense data is essential to determine why it
> failed. Hence make the sense key, ASC and ASCQ codes available in the
> ftrace output.
> 
> Cc: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/trace/events/scsi.h | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index a2c7befd451a..6c4be1ebe268 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -269,9 +269,14 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__field( unsigned int,	prot_sglen )
>  		__field( unsigned char,	prot_op )
>  		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
> +		__field( u8, sense_key )
> +		__field( u8, asc )
> +		__field( u8, ascq )
>  	),
>  
>  	TP_fast_assign(
> +		struct scsi_sense_hdr sshdr;
> +
>  		__entry->host_no	= cmd->device->host->host_no;
>  		__entry->channel	= cmd->device->channel;
>  		__entry->id		= cmd->device->id;
> @@ -285,11 +290,22 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
>  		__entry->prot_op	= scsi_get_prot_op(cmd);
>  		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> +		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&

Can't hurt to have these explicitly here, but these checks are also
done by `scsi_command_normalize_sense()` AFAICT.

> +		    scsi_command_normalize_sense(cmd, &sshdr)) {
> +			__entry->sense_key = sshdr.sense_key;
> +			__entry->asc = sshdr.asc;
> +			__entry->ascq = sshdr.ascq;
> +		} else {
> +			__entry->sense_key = 0;
> +			__entry->asc = 0;
> +			__entry->ascq = 0;
> +		}
>  	),
>  
>  	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
>  		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
> -		  "result=(driver=%s host=%s message=%s status=%s)",
> +		  "result=(driver=%s host=%s message=%s status=%s "
> +		  "sense_key=%u asc=%#x ascq=%#x))",

In SPC, these are all in base 16, and some existing functions in
`scsi_logging.c` format Sense Key as base 16. We probably should keep
this consistent and also format Sense Key with `%#x`.

>  		  __entry->host_no, __entry->channel, __entry->id,
>  		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>  		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
> @@ -299,7 +315,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		  "DRIVER_OK",
>  		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
>  		  "COMMAND_COMPLETE",
> -		  show_statusbyte_name(__entry->result & 0xff))
> +		  show_statusbyte_name(__entry->result & 0xff),
> +		  __entry->sense_key, __entry->asc, __entry->ascq)
>  );
>  
>  DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
