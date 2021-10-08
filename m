Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB59C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 09:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22B260F5E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 09:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbhJHJZW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 05:25:22 -0400
Received: from email.ramaxel.com ([221.4.138.186]:64727 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237674AbhJHJZU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 05:25:20 -0400
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 1989MUhf087972
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 8 Oct 2021 17:22:30 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.54) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 8
 Oct 2021 17:22:30 +0800
Date:   Fri, 8 Oct 2021 09:22:30 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        <songyl@ramaxel.com>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211008092033.4e180505@songyl>
In-Reply-To: <YVaLU+1oD7mlYRWJ@infradead.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
 <YVaLU+1oD7mlYRWJ@infradead.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.54]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 1989MUhf087972
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

Thanks for your comments. Sorry for replying late since I was in
vacation.


On Fri, 1 Oct 2021 12:15:15 +0800
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 30, 2021 at 11:47:52AM +0800, Yanling Song wrote:
> > This initial commit contains Ramaxel's spraid module.  
> 
> This is not a SCSI driver as it doesn't speak the SCSI protocol.  In
> fact it looks a lot like NVMe with weird enhancements.
> 
> The driver also seems to have a lot of copy and paste from the NVMe
> code without any attribution.

Actually it is a SCSI driver, and it does register a scsi_host_template
and host does send SCSI commands to our raid controller just like other
raid controllers. 
You are right "it looks a lot like NVMe" since we believe the
communication mechanism of NVME between host and the end device is good
and it was leveraged when we designed the raid controller. That's why
it looks like there are some code from NVME because the mechanism is
the same.

