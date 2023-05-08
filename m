Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA98C77B75
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 14:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbjEHOVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 10:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEHOVx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 10:21:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C4919B9
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 07:21:52 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348EDaKt013179;
        Mon, 8 May 2023 14:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cvgU9HpY9u0oSyJar9GiK5O+k2rHFGBT7Mu1Fs/hjfs=;
 b=nVrsUwFe5B1b2JX0lwTJinarvANOH6yzbnp5YX+UtOxn6MQNUzQYB8UJWcFxlSBk5ZSd
 J0KxeHGReGcu8zRePc156IjUlp9tR98SePllJvPvvuAKFGIZoGeMuM0U4Boujn2MzXSp
 jS3fCgsa5l7WnRuZLTDoZQ9kLlQAHi31DLll9PXvORGg/IIJXNrHueQI/8q1702iBTPB
 tIqBeies6oYbV1ke0hY0gp+WqnsmtSw4cqAay9LuSzDb5wsZHCpC7T36x8xhAXj2QjYF
 5Ylia5/XPpmG/rQisuD/yrkzG5NtKCmcAlI4dQa8hz3Oh/JY+sR0YFIMwtACiZVeYPFS vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf2c00rxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 14:21:26 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 348EHXub026959;
        Mon, 8 May 2023 14:21:25 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf2c00rss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 14:21:25 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 348CFmJp000483;
        Mon, 8 May 2023 14:21:19 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qdeh6gy5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 14:21:18 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348ELGs255640522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 14:21:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 831F920043;
        Mon,  8 May 2023 14:21:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6105C20040;
        Mon,  8 May 2023 14:21:16 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.41.150])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  8 May 2023 14:21:16 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pw1jn-000b5V-1G;
        Mon, 08 May 2023 16:21:15 +0200
Date:   Mon, 8 May 2023 14:21:15 +0000
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
Message-ID: <20230508142115.GE9720@t480-pf1aa2c2.fritz.box>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-4-bvanassche@acm.org>
 <20230508140553.GD9720@t480-pf1aa2c2.fritz.box>
 <51b8899b-473e-5a3b-2c84-f97e7f12943d@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <51b8899b-473e-5a3b-2c84-f97e7f12943d@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q0XxqZPiGRLW6YbtFsL-lMG6G99vgFmT
X-Proofpoint-GUID: yn2wyVIujg7CJX0lSypfCjeMF8Vx6ndh
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_10,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305080095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 08, 2023 at 07:10:31AM -0700, Bart Van Assche wrote:
> On 5/8/23 07:05, Benjamin Block wrote:
> > On Wed, May 03, 2023 at 04:06:52PM -0700, Bart Van Assche wrote:
> >> @@ -285,11 +290,22 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
> >>   		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
> >>   		__entry->prot_op	= scsi_get_prot_op(cmd);
> >>   		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> >> +		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> > 
> > Can't hurt to have these explicitly here, but these checks are also
> > done by `scsi_command_normalize_sense()` AFAICT.
> 
> Niklas requested these checks as a performance optimization.

Oh okay, didn't remember that. Fair enough.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
