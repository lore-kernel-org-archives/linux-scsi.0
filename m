Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F377C2BBC7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 11:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F302072D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 11:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="Ja3LeO0E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439571AbgDNLph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 07:45:37 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:60946 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439564AbgDNLpc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 07:45:32 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1FBC441C91;
        Tue, 14 Apr 2020 11:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1586864727;
         x=1588679128; bh=gMSbTiOn7oBNiuMO/r37iGexIgXsrmQetWpIDSx3Z/0=; b=
        Ja3LeO0Edkvdk91jLWW0oCyuNLnaJbh7rx6NfuHWVh14fzhMOCVM+RF7znX+9Q0t
        nRkRMwLfFYjRla11gjpviVXYI/tuWeRN6iJbsvPp8PJpa0W7wOFlyAc1xa8NqJsb
        2MNVLey1ZmQrwSAXVY7Yw6F+5f6pAEBvyicDRCK8lz4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MsgjPlazNe_G; Tue, 14 Apr 2020 14:45:27 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D6D3541C79;
        Tue, 14 Apr 2020 14:45:25 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 14
 Apr 2020 14:45:26 +0300
Date:   Tue, 14 Apr 2020 14:45:28 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to
 FCP_PRIO_CFG_SIZE
Message-ID: <20200414114528.GC8042@SPB-NB-133.local>
References: <20200405231339.29612-1-bvanassche@acm.org>
 <20200413153049.GA8042@SPB-NB-133.local>
 <6672ed7a-e6d5-b7f4-0ed1-b74e43542ba2@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6672ed7a-e6d5-b7f4-0ed1-b74e43542ba2@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 13, 2020 at 08:56:18PM -0700, Bart Van Assche wrote:
> On 2020-04-13 08:30, Roman Bolshakov wrote:
> > On Sun, Apr 05, 2020 at 04:13:39PM -0700, Bart Van Assche wrote:
> >> This patch fixes the following Coverity complaint without changing any
> >> functionality:
> >>
> >> CID 337793 (#1 of 1): Wrong size argument (SIZEOF_MISMATCH)
> >> suspicious_sizeof: Passing argument ha->fcp_prio_cfg of type
> >> struct qla_fcp_prio_cfg * and argument 32768UL to function memset is
> >> suspicious because a multiple of sizeof (struct qla_fcp_prio_cfg) /*48*/
> >> is expected.
> >>
> >> memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);
> >>
> >> ---
> >>  drivers/scsi/qla2xxx/qla_fw.h | 3 ++-
> >>  drivers/scsi/qla2xxx/qla_os.c | 1 +
> >>  2 files changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> >> index f9bad5bd7198..647e67c6ba5e 100644
> >> --- a/drivers/scsi/qla2xxx/qla_fw.h
> >> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> >> @@ -2217,8 +2217,9 @@ struct qla_fcp_prio_cfg {
> >>  #define FCP_PRIO_ATTR_PERSIST   0x2
> >>  	uint8_t  reserved;      /* Reserved for future use          */
> >>  #define FCP_PRIO_CFG_HDR_SIZE   0x10
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
> The constant FCP_PRIO_CFG_ENTRY_SIZE is only used once, namely in the
> following code:
> 
> 	len = ha->fcp_prio_cfg->num_entries * FCP_PRIO_CFG_ENTRY_SIZE;
> 
> How about removing the definition of FCP_PRIO_CFG_ENTRY_SIZE and
> changing FCP_PRIO_CFG_ENTRY_SIZE in the above calculation into
> sizeof(struct qla_fcp_prio_entry)?
> 

Hi Bart,

I overlooked the FCP_PRIO_CFG_ENTRY_SIZE definition in the hunk :)
Since it's already there, we can just replace 32 with it and add
BUILD_BUG_ON using the definition.

What you propose is also reasonable if used with BUILD_BUG_ON that has
numeric literal for FCP_PRIO_CFG_ENTRY_SIZE.

Thanks,
Roman
