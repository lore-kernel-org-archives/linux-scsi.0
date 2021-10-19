Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D62C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 11:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 051AE61360
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 11:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhJSLqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 07:46:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230097AbhJSLqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 07:46:31 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JALNpp031874;
        Tue, 19 Oct 2021 07:44:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=13eh0d8iyhPRVBSdniiQNSJ570kWDdMu7sqd7IfWCXM=;
 b=UXViKJZ3+6ydZTcj7i5s9v5CNjlnahVN929WjSmI9K56Ac38w90OrTcve9Nm7D78/vGB
 SLPSYksuU3MBOaKqEC79J6F/mpNnyVHuMT/oKNrIHXEdIrqRYs0Qqta9eCWne6vrD+br
 kZMdJUKJl0GDrtcvBOpEmIz1FvBfCB3C7MBxqZ8v4UJwB8KnhGYvZJGGE6+y8/gnAAhP
 lt+1FdaHpMkxiQOwn0nLXjEp+mA7GN9AZBg73d9hIhfnK+Yr95iNxaxTy8vNSbG4Agpt
 IXXXekV9JFbGBu3gSXIvBUSCCGR3K07woittnTn5dqpeqmKeWuQkpx95sKG5/cbV51ps hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bsupgsxqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 07:44:13 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19JBiDI6021732;
        Tue, 19 Oct 2021 07:44:13 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bsupgsxqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 07:44:13 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JBhRTU019391;
        Tue, 19 Oct 2021 11:44:12 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3bqpcbqqv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 11:44:12 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JBiBlm26935794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 11:44:11 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08A9B78067;
        Tue, 19 Oct 2021 11:44:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA9767805F;
        Tue, 19 Oct 2021 11:44:09 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.92.132])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 11:44:09 +0000 (GMT)
Message-ID: <2482854e18365087266c2f0907c1bbfd42bd2731.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: megaraid_mbox: return -ENOMEM on
 megaraid_init_mbox() allocation failure
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        kashyap.desai@broadcom.com
Cc:     sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 19 Oct 2021 07:44:08 -0400
In-Reply-To: <1634640800-22502-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1634640800-22502-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ccfVMvsJQkqStX70w5kZlKzQUrrBKeiN
X-Proofpoint-ORIG-GUID: ubei3YpkeUEF2_SOHBD_goBtajz7gL4y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_01,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190070
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-10-19 at 18:53 +0800, Jiapeng Chong wrote:
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> Fixes the following smatch warning:
> 
> drivers/scsi/megaraid/megaraid_mbox.c:715 megaraid_init_mbox() warn:
> returning -1 instead of -ENOMEM is sloppy.

Why is this a problem?  megaraid_init_mbox() is called using this
pattern:

	// Start the mailbox based controller
	if (megaraid_init_mbox(adapter) != 0) {
		con_log(CL_ANN, (KERN_WARNING
			"megaraid: mailbox adapter did not initialize\n"));

		goto out_free_adapter;
	}

So the only meaningful returns are 0 on success and anything else
(although megaraid uses -1 for this) on failure.   Since -1 is the
conventional failure return, why alter that to something different that
still won't be printed or acted on?  And worse still, if we make this
change, it will likely excite other static checkers to complain we're
losing error information ...

James


