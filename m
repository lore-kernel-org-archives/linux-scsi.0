Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77C5C352B6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 11:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C30F2072D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 11:49:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="Gsj2hoB0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439627AbgDNLtg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 07:49:36 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:33012 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729470AbgDNLte (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 07:49:34 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9A99541CAE;
        Tue, 14 Apr 2020 11:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1586864971;
         x=1588679372; bh=RufcnC/F6UrFgovDoXOPCdXCOCQhS6YsTp5PoS427w0=; b=
        Gsj2hoB0lbRBFUI2QwOwwLRm0olt22aCW2tyxwM/cqXEcRz0o/rU7MX8Jc7h52Zf
        IyhgUucPODqzP4wAvqjwjTAGQUysJHAA/RzqZyaBh1RXJWRor7LAgGDmTCndOy9Z
        d0XR4J2udQ97RWGsqP4i0uGV51o0cMqctkphyKHiR6I=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qTae4Oa06ovu; Tue, 14 Apr 2020 14:49:31 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B9DAC41C91;
        Tue, 14 Apr 2020 14:49:30 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 14
 Apr 2020 14:49:31 +0300
Date:   Tue, 14 Apr 2020 14:49:33 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to
 FCP_PRIO_CFG_SIZE
Message-ID: <20200414114933.GD8042@SPB-NB-133.local>
References: <20200405231339.29612-1-bvanassche@acm.org>
 <20200413153049.GA8042@SPB-NB-133.local>
 <yq11roqu7mi.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <yq11roqu7mi.fsf@oracle.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 13, 2020 at 10:24:37PM -0400, Martin K. Petersen wrote:
> 
> Roman,
> 
> >> -	struct qla_fcp_prio_entry entry[1];     /* fcp priority entries  */
> >> +	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
> >>  #define FCP_PRIO_CFG_ENTRY_SIZE 0x20
> >> +	uint8_t  reserved2[16];
> >>  };
> >>  
> >>  #define FCP_PRIO_CFG_SIZE       (32*1024) /* fcp prio data per port*/
> >
> > A new constant may be introduced to define size of qla_fcp_prio_entry.
> > That would let to drop the magic 32 number here and allow to add one
> > more BUILD_BUG_ON for sizeof(struct qla_fcp_prio_entry).
> 
> I wonder what the firmware interface says about the runt entry?
> 

Hi Martin,

NVRAM and Option ROM contents/layout doesn't seem to be a part of the FW spec.

Roman
