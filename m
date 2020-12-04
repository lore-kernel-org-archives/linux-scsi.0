Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A487EC4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 14:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AFC022B2D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 14:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388325AbgLDOQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:16:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50308 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388319AbgLDOQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 09:16:55 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4E4glR147948;
        Fri, 4 Dec 2020 09:16:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=YFZkaqyi8em0jleGAIh2MTEd6mXuQsd9toBltZcSYno=;
 b=mqzwHVKvjAeTz7cmvU0c8IhdBb28qKZY77K3H4nSludFjaKyN2x4h00xcOtNNzou+b83
 sh5sPbpqModaRsKfrhv7pq57iYT6ROII7qN4bE0m74kfMRzrSTVsLRJNHv8ugfeiiV5G
 npylCS+lt4fq/LdZjhudUv1XY7jd8L0Kv7QIfJtr0R3ww9fwkjeo6p1S8qd0AaLhVgDw
 hpVV6iaqWzoKh5l4HkKK8KKQcgpEHGJcgWukf7lLB7uHiF8r8ut9vQIZS+lOX7lmJQf1
 roFxOx1noM4NyCVx97whghxUvPGMFlAWLNoYi64axrwhM7CSbXvvRWhZnFlb8GdnH9Y8 CQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35774360nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 09:16:06 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4E8AqF032096;
        Fri, 4 Dec 2020 14:16:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 353e68babx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:16:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4EG20e25231866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 14:16:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A61811C05B;
        Fri,  4 Dec 2020 14:16:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D509911C04C;
        Fri,  4 Dec 2020 14:16:01 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.180.48])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  4 Dec 2020 14:16:01 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1klBsO-000QV6-I5; Fri, 04 Dec 2020 15:16:00 +0100
Date:   Fri, 4 Dec 2020 15:16:00 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 27/37] scsi: add 'set_status_byte()' accessor
Message-ID: <20201204141600.GB7858@t480-pf1aa2c2>
References: <20201204100140.140863-1-hare@suse.de>
 <20201204100140.140863-28-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201204100140.140863-28-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_04:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040077
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 04, 2020 at 11:01:30AM +0100, Hannes Reinecke wrote:
> Add the missing 'set_status_byte()' accessor function.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  include/scsi/scsi_cmnd.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 69ade4fb71aa..ace15b5dc956 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -308,6 +308,11 @@ static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
>  #define scsi_for_each_prot_sg(cmd, sg, nseg, __i)		\
>  	for_each_sg(scsi_prot_sglist(cmd), sg, nseg, __i)
>  
> +static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
> +{
> +	cmd->result = (cmd->result & 0xffffff00) | status;
> +}
> +
>  static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
>  {
>  	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
> -- 
> 2.16.4
> 

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
