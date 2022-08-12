Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8AAC00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 11:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbiHLLes (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 07:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiHLLer (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 07:34:47 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D9CAE9F3;
        Fri, 12 Aug 2022 04:34:46 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 286654136E;
        Fri, 12 Aug 2022 11:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1660304084; x=1662118485; bh=3I9Qn96QkmBr
        3/pdnpvx9QQXahnOKJkxyQaaAcwun5U=; b=aMzkDEZC7Pe91UpDTjttgcoel9wG
        h75HgpAA6ZBKtZME6RMBhIAHddSQIlv8DFelmPzAQj5Urnmkgx2Zvn5fjcLtBQW2
        s4etPo7TDQ/a7+GhbhWR7TQwxN3OWY3FuntIJghd0FizLS55uE1XFpA0p2vOe8Fo
        JFzNsmM3lsyeiOQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id III3iyAElWcn; Fri, 12 Aug 2022 14:34:44 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0C57F412D6;
        Fri, 12 Aug 2022 14:34:43 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 12 Aug 2022 14:34:43 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 12 Aug
 2022 14:34:42 +0300
Date:   Fri, 12 Aug 2022 14:34:41 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 4/6] scsi: target: core: add emulate_rsoc attribute
Message-ID: <20220812113441.GB32459@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-5-d.bogdanov@yadro.com>
 <479fd36d-7084-f37b-a2ab-f82105278cad@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <479fd36d-7084-f37b-a2ab-f82105278cad@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2022 at 10:43:24PM -0500, Mike Christie wrote:
> «Внимание! Данное письмо от внешнего адресата!»
> 
> On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
> > Make support of RSOC turned off by emulate_rsoc attibute.
> >
> 
> What was the reason for this?
Looks like, it was by analogue to other emulate_* attibutes. But
actually RSOC itself is independent to a backstore device, so better to
drop this patch :)
