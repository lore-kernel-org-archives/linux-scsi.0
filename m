Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E008DC41513
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 08:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjHKIfB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 04:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjHKIfA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 04:35:00 -0400
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F084A2D61;
        Fri, 11 Aug 2023 01:34:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id CDC58635D298;
        Fri, 11 Aug 2023 10:34:53 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id gWYbKucqjmIx; Fri, 11 Aug 2023 10:34:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 61490622F58E;
        Fri, 11 Aug 2023 10:34:53 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1iVyzkI06y4o; Fri, 11 Aug 2023 10:34:53 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 26A06622F562;
        Fri, 11 Aug 2023 10:34:53 +0200 (CEST)
Date:   Fri, 11 Aug 2023 10:34:52 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-mtd <linux-mtd@lists.infradead.org>,
        Stephan Wurm <stephan.wurm@a-eberle.de>,
        stable <stable@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        James Bottomley <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Message-ID: <156807159.5281174.1691742892935.JavaMail.zimbra@nod.at>
In-Reply-To: <ZNXtdpUbhj7mVu11@infradead.org>
References: <20230810160019.16977-1-richard@nod.at> <20230810160019.16977-2-richard@nod.at> <ZNUK8nWnUYB6B4Kg@infradead.org> <298860961.5257332.1691684136772.JavaMail.zimbra@nod.at> <ZNUOjQVivR/5pFKE@infradead.org> <164102534.5258032.1691697286622.JavaMail.zimbra@nod.at> <ZNXtdpUbhj7mVu11@infradead.org>
Subject: Re: [PATCH 1/7] ubi: block: Refactor sg list processing for highmem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: block: Refactor sg list processing for highmem
Thread-Index: 3zEdItUFC1BXLJjJLxUA1x/tImNOyg==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Christoph Hellwig" <hch@infradead.org>
> On Thu, Aug 10, 2023 at 09:54:46PM +0200, Richard Weinberger wrote:
>> > But why add the bounce buffering first if you can avoid it from the
>> > very beginning by just using kmap_local instead of adding a new
>> > caller for the deprecate kmap_atomic?
>> 
>> Because I want this fix also in all stable trees. kmap_local() is rather
>> new. When back porting patch 1/7, bounce buffers and kmap_atomic()
>> are needed anyway.
>> By doing this in patch 1/7 I avoid backport troubles and keep the
>> delta between upstream and stable trees minimal.
> 
> Just use plain kmap for the historic backports.

Hm, yes. For UBIblock kmap should be too expensive.

Thanks,
//richard
