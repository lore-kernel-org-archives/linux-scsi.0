Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D292C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 20:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiGGU6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 16:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbiGGU55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 16:57:57 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9D22F675;
        Thu,  7 Jul 2022 13:57:55 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 86905412E1;
        Thu,  7 Jul 2022 20:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657227473; x=1659041874; bh=GYL2hJDfC/WB1cYjU08qRowh0R60ZuFQzbV
        3xP6Rnuo=; b=apUs1mvMftuNEGdRAL5huaOq+JZGASVL2NS1zpCLfofxgQCljgq
        dxl8eXuQLBBibmxiNh3lETWsf7BLzsX4qbRS88iyr7HvwG+T+oJE+zeWHIg3jHtn
        i2Yvp+WL95VYUgiBmRp3OZvjGcKOeUTxcvVWV6RI0L8vNrxJNoesvwo0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KFPpm4JL8n4K; Thu,  7 Jul 2022 23:57:53 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DF5F8412C5;
        Thu,  7 Jul 2022 23:57:52 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 23:57:52 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 23:57:52 +0300
Date:   Thu, 7 Jul 2022 23:57:51 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        Mike Christie <michael.christie@oracle.com>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: target: Fix WRITE_SAME No Data Buffer crash
Message-ID: <20220707205751.GA3509@yadro.com>
References: <20220628022325.14627-1-michael.christie@oracle.com>
 <20220628022325.14627-2-michael.christie@oracle.com>
 <YrqJhyzhjaEkTJL/@infradead.org>
 <yq1mtdk7j59.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <yq1mtdk7j59.fsf@ca-mkp.ca.oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Thu, Jul 07, 2022 at 04:42:36PM -0400, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > (and I wonder if we have similar problems with other commands, the
> > target code could use same targeted fuzzing..)
> 
> Yeah.
> 
> The USB gadget series implements initial support for RSOC. It might be
> worth entertaining to augment that code with CDB masks for all the
> commands we actually support. And then leverage these masks for command
> validation.

I have a patchset with complete RSOC support with CDB mask. Even dynamic
mask due to device configuration. It passes all RSOC related libiscsi
tests.
If the community want it I may send it.
