Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7328EC43217
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 18:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392566AbiEFSYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 14:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391450AbiEFSXd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 14:23:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D617557B08
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 11:19:49 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246HAKcw002046;
        Fri, 6 May 2022 18:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=wBNCbYgRNGwj1joaPv1Xpb86+vMG9GjcnXlHdPTfu+0=;
 b=mGUdAF1dtMh3Mzt3AaKPG62E/NMLvGrsu3Q5OTwIPJFN1VJNRyJe1+K2kVL69+ovNebF
 NRnTAL8SmLk6vvVKcnrh34jj6Zq1ZamgTd5RKVQQ0jptcIkjs3OsvAMx4Zo35w7OKpuM
 +LriXyrBAPz9i2MYQMuYH5zsWPTRfYZpxCXt+7KfBhWTYqmAMh39St0ztfH5GPUDsF8j
 pXh2OtnR8OR6L7VQvcBChpsIKufVNbA87YXsgF7ZXKEGl0iP9iz8zuX/vtbhCcr73Bt7
 O2Tp5MVNHCLxrZm3htNdPizFx5as3jIysBbNvRyUGLcv9zNzElEYtgBdzCM4xx5hs1vx Qg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw6rsjdy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 18:19:47 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246ICG5l029801;
        Fri, 6 May 2022 18:19:46 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3frvra256u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 18:19:46 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246IJjoh19530174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 18:19:45 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9026A78066;
        Fri,  6 May 2022 18:19:45 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0F697805F;
        Fri,  6 May 2022 18:19:44 +0000 (GMT)
Received: from lingrow.rcx-us.ibmmobiledemo.com (unknown [9.211.120.242])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 18:19:44 +0000 (GMT)
Message-ID: <ce95ca87344df10a477f16232815e8590118188e.camel@linux.ibm.com>
Subject: Re: calling context of scsi_end_request() always hard IRQ or
 sometimes different?
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Date:   Fri, 06 May 2022 14:19:43 -0400
In-Reply-To: <YnVTf+vkcLl2wZZE@zx2c4.com>
References: <YnVTf+vkcLl2wZZE@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yPaIPu8Qk7-DHSUcqrjGPZ6AtYKuwGH6
X-Proofpoint-ORIG-GUID: yPaIPu8Qk7-DHSUcqrjGPZ6AtYKuwGH6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_07,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=784 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-05-06 at 18:57 +0200, Jason A. Donenfeld wrote:
> Hey James, Martin,
> 
> I'm in the process of fixing a few issues with the RNG and one thing
> that surprised me is that scsi_end_request() appears to be called
> from hard IRQ context rather than some worker or soft IRQ as I
> assumed it would be. That's fine, and I can deal with it, but what I
> haven't yet been able to figure out is whether it's _always_ called
> from hard IRQ, or whether it's sometimes from hard IRQ and sometimes
> not, and so I should handle both cases in the thing I'm working on?
> 
> And if the answer turns out to be, "I don't know; that's really
> complicated and..." just say so, and I'll just try to work out the
> whole function graph.

Are you sure you mean scsi_end_request()?  It's static to scsi_lib.c so
its call graph is tiny  it basically goes from the blk-mq complete
function (softirq) through scsi_complete->scsi_finish_command-
>scsi_io_completion->scsi_end_request

However, I didn't think it was ever called from hard IRQ context,
that's usually scsi_done() (which can also be called from other
contexts).

James


