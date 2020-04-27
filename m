Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FC6C54FCB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85AC6206D9
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgD0OrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:47:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22288 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727768AbgD0OrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 10:47:02 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03REWxp8151150;
        Mon, 27 Apr 2020 10:46:57 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30metvahga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 10:46:57 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03REjCnB031771;
        Mon, 27 Apr 2020 14:46:56 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 30mcu6gwya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 14:46:56 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03REksLm28115344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:46:54 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 117E678060;
        Mon, 27 Apr 2020 14:46:55 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 775337805C;
        Mon, 27 Apr 2020 14:46:53 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.187.215])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 27 Apr 2020 14:46:53 +0000 (GMT)
Message-ID: <1587998812.4252.18.camel@linux.ibm.com>
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target reset
From:   James Bottomley <jejb@linux.ibm.com>
To:     Viacheslav Dubeyko <v.dubeiko@yadro.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Cc:     hmadhani@marvell.com, martin.petersen@oracle.com, linux@yadro.com,
        r.bolshakov@yadro.com
Date:   Mon, 27 Apr 2020 07:46:52 -0700
In-Reply-To: <b8648e0b817def5416d73215c1174589547e336d.camel@yadro.com>
References: <1d7b21bf9f7676643239eb3d60eaca7cfa505cf0.camel@yadro.com>
         <fcbbfdac-1a79-51ac-beae-ea4b38f21798@acm.org>
         <b8648e0b817def5416d73215c1174589547e336d.camel@yadro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_10:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=899
 priorityscore=1501 phishscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1011 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-04-27 at 12:18 +0300, Viacheslav Dubeyko wrote:
[...]
> I am using the Evolution for sending the patches. I am not completely
> sure that sendemail.thread = true in ~/.gitconfig can change the
> Evolution's behavior.

It can't.  That setting only works with git-send-email

>  Is it something wrong with the Evolution's settings?

Not the settings, with your sending process: if you send a manual email
you need to send the rest of the threaded patches as a reply to the
first one or the cover letter.

I do this in evolution by replying to the first email from my sent
folder.

James

