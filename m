Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632FAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 12:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E03D61359
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 12:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhJTMQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 08:16:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38590 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230092AbhJTMQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 08:16:14 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KAQL0E019057;
        Wed, 20 Oct 2021 08:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=X7GrgeqNNOzBt33xC3JU3iGJnstVXS4qySkKNNmttsc=;
 b=B/uj4088cPwIIVr0CE2viJVLAOByAYy/gJj3sXXhkLMO90zaBCTojdgFHpEAXYs61RGF
 grtUjHeG5US/3w5YnSPofo8dYdpB5vty0MKteHlzFZAv1P6F0k/1viwMFzXMggxOFZQX
 dbcF5Q+GrHsMdGcz15kymqyTVcXLG1foWBxq4o9UAXngvK4XcYCBWs9BVlUfvBRg+w6J
 R3zUuxMhAO1vhwBI5+Bx2FLRg9tFaNET6jZsRUzxkIDpyHkZ4Xfc6qTC/v7Ax3urNQ2f
 Lu+Ntyfjo/PNG/6mzquCATLY6ed9uwXVksXrFzJryhrvqPOzBLGOmkDtDC1nnktJn9UW aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btcaa0sgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 08:13:55 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19KC6tff019771;
        Wed, 20 Oct 2021 08:13:54 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btcaa0sg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 08:13:54 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19KCCAgd029781;
        Wed, 20 Oct 2021 12:13:53 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 3bqpccnkag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 12:13:53 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19KCDqAc36700454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 12:13:52 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9367978066;
        Wed, 20 Oct 2021 12:13:52 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 325197805F;
        Wed, 20 Oct 2021 12:13:51 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.92.132])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 20 Oct 2021 12:13:50 +0000 (GMT)
Message-ID: <670213ce9e6c3b625e9f8ed66b9fad8ea2843322.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: megaraid_mbox: return -ENOMEM on
 megaraid_init_mbox() allocation failure
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 20 Oct 2021 08:13:49 -0400
In-Reply-To: <c1a6e7f3-d62f-5c5e-b3ef-2320339e142a@linux-m68k.org>
References: <1634640800-22502-1-git-send-email-jiapeng.chong@linux.alibaba.com>
         <2482854e18365087266c2f0907c1bbfd42bd2731.camel@linux.ibm.com>
         <c1a6e7f3-d62f-5c5e-b3ef-2320339e142a@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RkC9NNyMJU9-R40_UDElbQ0kg1yV0Rxj
X-Proofpoint-ORIG-GUID: B_84UIX3AcfxVO6i3TLor7iJzqzR2Wlw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-20_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 adultscore=0 clxscore=1011 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200070
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-10-20 at 13:56 +1100, Finn Thain wrote:
> On Tue, 19 Oct 2021, James Bottomley wrote:
> 
> > On Tue, 2021-10-19 at 18:53 +0800, Jiapeng Chong wrote:
> > > From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> > > 
> > > Fixes the following smatch warning:
> > > 
> > > drivers/scsi/megaraid/megaraid_mbox.c:715 megaraid_init_mbox()
> > > warn:
> > > returning -1 instead of -ENOMEM is sloppy.
> > 
> > Why is this a problem?  megaraid_init_mbox() is called using this
> > pattern:
> > 
> > 	// Start the mailbox based controller
> > 	if (megaraid_init_mbox(adapter) != 0) {
> > 		con_log(CL_ANN, (KERN_WARNING
> > 			"megaraid: mailbox adapter did not
> > initialize\n"));
> > 
> > 		goto out_free_adapter;
> > 	}
> > 
> > So the only meaningful returns are 0 on success and anything else
> > (although megaraid uses -1 for this) on failure. 
> 
> I think you're arguing for a bool (?)

I'm not arguing for anything ... I'm just explaining how the current
code works that makes this change pointless.  Megaraid is an older
driver, so even if the current return is two state, changing it to bool
would be unnecessary churn.

> Smatch apparently did not think of that -- probably needs a holiday.
> 
> > Since -1 is the conventional failure return, why alter that to
> > something different that still won't be printed or acted on?  And
> > worse still, if we make this change, it will likely excite other
> > static checkers to complain we're losing error information ...
> > 
> 
> ... and arguably they would be correct.

Well, yes ... that's why I don't want one "fix" that generates a
cascading sequence of further "fixes".

James



