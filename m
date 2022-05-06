Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924A8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 20:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392635AbiEFUPs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 16:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbiEFUPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 16:15:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72105BD21
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 13:12:02 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246K0MKO028617;
        Fri, 6 May 2022 20:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=vJywnoJzGp4K4BcPpFZH1m83JIHkw23EQvEHjW7SxJk=;
 b=D7e/P/UIy9zaADBUtV3euIcSoY1lFe2DNgj4VarEribRGAe49IjvDcZswV/wzxl2Ww8k
 AfA/Pupt8HZj5e/lw01ftusorXtXRJM1ES5WaW89HmKjvcyAZfKV7iQqFxmJU+2/WN3w
 HQbVgUg9fYax5IhRvqhGIoO8VOyYlbQCICKGkFrKlrwJ7sha2lR4KvXrym5qDF07wB5o
 bvPKV1yLKnU1J3kClsfyoLozK4GS0TKrAZ2+gBOBMpKXPTB772fM+4GMIHEI0NZ7ULdI
 i616a53K2Yx0aHq1ABEGSAa6MLqyHA1wCWSCmP69zcFp1zbPdQMX8Dhjy8vwvxDjlq4w qw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fwab50655-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 20:12:00 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246K88Ib028366;
        Fri, 6 May 2022 20:12:00 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3frvran88e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 20:12:00 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246KBx8C23527786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 20:11:59 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AEBD7805E;
        Fri,  6 May 2022 20:11:59 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 860D37805C;
        Fri,  6 May 2022 20:11:58 +0000 (GMT)
Received: from lingrow.rcx-us.ibmmobiledemo.com (unknown [9.211.120.242])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 20:11:58 +0000 (GMT)
Message-ID: <32e8e33e79a1e8e2658cd07ad7d457662aef997f.camel@linux.ibm.com>
Subject: Re: calling context of scsi_end_request() always hard IRQ or
 sometimes different?
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Date:   Fri, 06 May 2022 16:11:57 -0400
In-Reply-To: <YnV1cK6jHVLoDBWj@zx2c4.com>
References: <YnVTf+vkcLl2wZZE@zx2c4.com>
         <ce95ca87344df10a477f16232815e8590118188e.camel@linux.ibm.com>
         <YnV1cK6jHVLoDBWj@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Uq632sgQ83TIdIfys08lTgoRIXJ08AtL
X-Proofpoint-GUID: Uq632sgQ83TIdIfys08lTgoRIXJ08AtL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_07,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 mlxlogscore=815 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060102
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-05-06 at 21:22 +0200, Jason A. Donenfeld wrote:
> Hi James,
> 
> On Fri, May 06, 2022 at 02:19:43PM -0400, James Bottomley wrote:
> > On Fri, 2022-05-06 at 18:57 +0200, Jason A. Donenfeld wrote:
> > > Hey James, Martin,
> > > 
> > > I'm in the process of fixing a few issues with the RNG and one
> > > thing
> > > that surprised me is that scsi_end_request() appears to be called
> > > from hard IRQ context rather than some worker or soft IRQ as I
> > > assumed it would be. That's fine, and I can deal with it, but
> > > what I
> > > haven't yet been able to figure out is whether it's _always_
> > > called
> > > from hard IRQ, or whether it's sometimes from hard IRQ and
> > > sometimes
> > > not, and so I should handle both cases in the thing I'm working
> > > on?
> > > 
> > > And if the answer turns out to be, "I don't know; that's really
> > > complicated and..." just say so, and I'll just try to work out
> > > the
> > > whole function graph.
> > 
> > Are you sure you mean scsi_end_request()?  It's static to
> > scsi_lib.c so
> > its call graph is tiny  it basically goes from the blk-mq complete
> > function (softirq) through scsi_complete->scsi_finish_command-
> > > scsi_io_completion->scsi_end_request
> > 
> > However, I didn't think it was ever called from hard IRQ context,
> > that's usually scsi_done() (which can also be called from other
> > contexts).
> 
> Really what I'm interested in is add_disk_randomness(), and the only
> caller of that is scsi_end_request(), so I think my question is the
> right one.
> 
> Interestingly, I _am_ seeing it from hardirq context (if
> `in_interrupt()` is to be believed):
> 
> [    2.108954]  add_timer_randomness.cold+0x5/0x3a
> [    2.110514]  scsi_end_request+0x136/0x1a0
> [    2.111903]  scsi_io_completion+0x2e/0x710

The call trace looks broken here.  After virtscsi_req_done it should
invoke scsi_done and blk_mq_complete_req, which usually goes via the
block softirq (but which may complete in the hardirq under some
circumstances), before it gets back into scsi_io_completion.

> [    2.113314]  virtscsi_req_done+0x59/0xa0
> [    2.114705]  vring_interrupt+0x46/0x70
> [    2.116002]  __handle_irq_event_percpu+0x32/0xb0
> [    2.117591]  handle_irq_event+0x2f/0x70
> [    2.118929]  handle_edge_irq+0x7c/0x210
> [    2.120249]  __common_interrupt+0x33/0x90
> [    2.121641]  common_interrupt+0x7b/0xa0
>  
> And it sounds like you're saying that this is really a softirq
> function. So is it correct for me to conclude that the right answer
> here is that it can be called from both/multiple contexts, and that's
> fine and normal?

Pretty much, yes.

James


