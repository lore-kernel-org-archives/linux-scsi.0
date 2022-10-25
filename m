Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF6AC38A2D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 12:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiJYMsT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 08:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiJYMrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 08:47:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BEC18F0DD
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 05:45:54 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PCaBMU005246;
        Tue, 25 Oct 2022 12:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=ODs5Orf6tGdhthmcVC0dFa3A32nI7fKrf3el/+NDzTs=;
 b=D9AS4rG65XQYfVMtE1DK3Y32qZQTWhJa3g+o76bptRlk1iBR7zjipqolwvtIgTMBUgKI
 hijEeAYBFaGw6h/44ckSW1ZEu0tAhTOqk0Ny9GRGgshpxbDaVI5wcx6Okw40oJkrYgVl
 wuRB+2pKZd9yjADjVya7x7eRt+np5QLbq0X2ciPBf2WUjY/9HLnHJROKoe3xO00ERv1J
 FEjk7oipYycRVTe6tiOWerPq4+XjjjHzvejhyBb9NZ/qvcF10atjt9l6m6WIZD7WVVZX
 K1EdJpKYrrs25veqWOTiJ73UnTLraxzxBSxGMlQcAA21TGd8P4/Tw9QeLgV6o5caG+DT NQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keft2gq9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 12:45:49 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PCZp8Q026291;
        Tue, 25 Oct 2022 12:45:48 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3kc85965su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 12:45:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PCjoLi13304080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 12:45:50 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DFFE7805E;
        Tue, 25 Oct 2022 13:29:16 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CE397805C;
        Tue, 25 Oct 2022 13:29:15 +0000 (GMT)
Received: from [IPv6:2601:5c4:4300:c551:a71:90ff:fec2:f05b] (unknown [9.163.14.162])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 13:29:14 +0000 (GMT)
Message-ID: <62d047fce5fb4f0850cf2b00e22e42a65f0d1df2.camel@linux.ibm.com>
Subject: Re: Inconsistency in torvalds/linux.git?
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Juergen Gross <jgross@suse.com>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date:   Tue, 25 Oct 2022 08:45:44 -0400
In-Reply-To: <CAHk-=whaEJYeY6tPGbPGuchjrCirxaJ1jfiWsFgW0rd9JQgrow@mail.gmail.com>
References: <4a450f81-b7e0-31e8-e8bb-03a1c87e829a@suse.com>
         <CAHk-=wjaK-TxrNaGtFDpL9qNHL1MVkWXO1TT6vObD5tXMSC4Zg@mail.gmail.com>
         <CAHk-=whaEJYeY6tPGbPGuchjrCirxaJ1jfiWsFgW0rd9JQgrow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j47eo9_J71MADmCcGnD4nby9zTm3zh8L
X-Proofpoint-ORIG-GUID: j47eo9_J71MADmCcGnD4nby9zTm3zh8L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_06,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 phishscore=0 suspectscore=0 mlxlogscore=899 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250069
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-10-25 at 01:04 -0700, Linus Torvalds wrote:
[...]
> And thanks again for noticing, this was all on me.

Perhaps not entirely.  I did notice this a month ago when I had to do a
manual merge of the fixes and misc branches into for-next of the SCSI
tree on 16 September.  I remember thinking at the time it could be an
issue and I should mention it in the pull request.  Unfortunately, once
you fix this in a merge, it never comes back since linux-next doesn't
notice and so ... erm ... I forgot about it by the time the merge
window opened.

Sorry about that,

James

 

