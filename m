Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2BDC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 15:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJSPyX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 11:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiJSPxn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 11:53:43 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB83181DA8;
        Wed, 19 Oct 2022 08:51:05 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E050740888;
        Wed, 19 Oct 2022 15:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1666192435; x=1668006836; bh=uNOo/kk/SsKTkanTPFHAjZEOy+cun2oyd4a
        ZKP4SW9g=; b=vOItfum8jygLqX0h3JCuKVZiE0xp2Ry37a303ZLRawmDa/0DuMy
        ODSzWTO+OywkILmsCWzj5XquqViu91j3o9E/C6JNqDNChAwlc3uV4FgUqO51JAZK
        SaGE9m9wa5HKroiO2JZpZG5+Gu01lL5iLhj5YcI2azfbpu/y5rliJNrU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rtGtIAmQCXzh; Wed, 19 Oct 2022 18:13:55 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 25D70411F9;
        Wed, 19 Oct 2022 18:13:49 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 19 Oct 2022 18:13:48 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 19 Oct
 2022 18:13:48 +0300
Date:   Wed, 19 Oct 2022 18:13:47 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 4/5] scsi: target: core: Add common port attributes
Message-ID: <20221019151347.GG10901@yadro.com>
References: <20221006105057.30184-1-d.bogdanov@yadro.com>
 <20221006105057.30184-5-d.bogdanov@yadro.com>
 <Y00HWKHL3gj/An8E@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y00HWKHL3gj/An8E@infradead.org>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 17, 2022 at 12:42:16AM -0700, Christoph Hellwig wrote:
> 
> On Thu, Oct 06, 2022 at 01:50:56PM +0300, Dmitry Bogdanov wrote:
> > From: Roman Bolshakov <r.bolshakov@yadro.com>
> >
> > All SCSI target port attributes (tpgN/attribs/attrname) are defined and
> > implemented in fabric modules in existing implementation.
> >
> > The change introduces a way to have common tpg attribs in configfs for
> > all fabrics without code duplication.
> 
> But does it really buy you much?  There is quite a lot of boilerplate
> code vs just adding an attribute to an array in the drivers, which could
> be further simplified by having a macro for all common ones.

Yes, of course. Mostly it is not about deduplication, but for just a
logical place of the attribute. Without this patch the 5th patch would
be cloned for every fabric driver. Moreover it would look strange to
have a some private core logic (check enableness) in fabric driver.

BR,
 Dmitry
