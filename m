Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FD7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 15:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59E656124D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 15:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhINPvy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 11:51:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234993AbhINPvd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 11:51:33 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EFVfE0025268;
        Tue, 14 Sep 2021 11:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=3JwiqFWHtWZoxIHBX6vudOvNml31w3OgI4edhvisHWg=;
 b=Mn31rWAh9Cpi0EM21ynYizbVjWv/nZC2ZMZ3cGFVALARKqpz8NeRtlbm53Xjz2tTIp5Q
 ADrWoYGEkizElUou7mNofe6x1uc/FDaAlaM0YvXYlSeECxMe+npeN3/hHplF7BkNUhuq
 seZn3Kozkkn/YVuW5q8BT6rxUDmg656ma6ECLoyPIbX9oBsVr5AH+Myg99KpleJ8oByv
 V/gFDAseyIt28t/cFoPmtJmzWKAHVBOPcxgo50WioFbj4V4HD2k8MFtJlqz88ge9hgda
 lENf/NNdrz7Tb1qVM3zAgwWYs4IMT4ikSQMGJYHChFi01DiPbGjVgFoB1VbRBTRrb3QE pA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2vpbkw5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 11:50:14 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EFlRXU012382;
        Tue, 14 Sep 2021 15:50:13 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3b0m3av7pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 15:50:13 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EFoBk440829424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 15:50:12 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD44F78060;
        Tue, 14 Sep 2021 15:50:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F52378063;
        Tue, 14 Sep 2021 15:50:11 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.54.195])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 15:50:11 +0000 (GMT)
Message-ID: <743e68034d12f839a6bfbc6eab27562afcb5cf70.camel@linux.ibm.com>
Subject: Re: [PATCH V2 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Wen Xiong <wenxiong@us.ibm.com>
Cc:     brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org,
        wenxiong@imap.linux.ibm.com, wenxiong@linux.vnet.ibm.com
Date:   Tue, 14 Sep 2021 08:50:10 -0700
In-Reply-To: <yq1wnnjxk0c.fsf@ca-mkp.ca.oracle.com>
References: <yq1v934yysg.fsf@ca-mkp.ca.oracle.com>
         <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
         <b73451e25a3f7881fb507500cb6bc0eae63f605b.camel@linux.ibm.com>
         <f754c31d348465f96ad4cd7541a86168@imap.linux.ibm.com>
         <OF31B21169.103CCF65-ON0025874F.00776468-0025874F.00778F79@ibm.com>
         <yq1wnnjxk0c.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ljsOmcaatGCxtE1DABCenErRl8Zwy5yf
X-Proofpoint-GUID: ljsOmcaatGCxtE1DABCenErRl8Zwy5yf
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-11_02,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140080
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-09-14 at 11:27 -0400, Martin K. Petersen wrote:
> Wendy,
> 
> > Below is error with enabling scsi_log_level;
> >  
> > [108017.427791] ses 0:0:9:0: tag#641 Sense Key : Unit Attention
> > [current]
> > [108017.427793] ses 0:0:9:0: tag#641 Add. Sense: Bus device reset
> > function occurred
> 
> OK. I propose you refine your check to retry on NOT_READY as well as
> UNIT_ATTENTION with ASC 0x29. I think that would be a good start. Do
> the same for ses_send_diag().

Something is wrong with the outbound email: the list isn't getting
copies of this:

https://lore.kernel.org/all/yq1v934yysg.fsf@ca-mkp.ca.oracle.com/

because you're sending HTML email ... please don't.

I still think setting expecting_cc_ua is the best thing to do because
it's designed for exactly the problem you're seeing, but open coding it
in the loop would be fine as well.

James


