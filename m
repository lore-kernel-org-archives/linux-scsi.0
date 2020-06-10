Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A72C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 12:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 968BC20734
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 12:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="PqPggvVL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgFJMLz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 08:11:55 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:50604 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728558AbgFJMLz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 08:11:55 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 23AE44C851;
        Wed, 10 Jun 2020 12:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1591791112;
         x=1593605513; bh=/xrRxF6yPkRcQvIN8mg7N0FFKkh5RG2CqQyGCAnmOg0=; b=
        PqPggvVLmUvkV9851i2eZA6vq0cHZ3yKTtx8sLwUzfW3h00IE+a1GM+Cf5B77Y0a
        DTFb3lV1tbroK9vObZPEzj5iiACt6t/CLS8gQPq04D8b33JFGVO3e1dJ8BKeFBe/
        1MHRcQLgxXAktvj+bRh5ZNZAalH1irkZ0efbDg+xfyI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AkFkGNDQXLqE; Wed, 10 Jun 2020 15:11:52 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B40D44AC44;
        Wed, 10 Jun 2020 15:11:51 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 10
 Jun 2020 15:11:51 +0300
Date:   Wed, 10 Jun 2020 15:11:51 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] qla2xxx: Fix the ARM build
Message-ID: <20200610121151.GA15652@SPB-NB-133.local>
References: <20200610024215.27997-1-bvanassche@acm.org>
 <20200610112745.qh7ahl7nff2xwzhm@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200610112745.qh7ahl7nff2xwzhm@beryllium.lan>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 10, 2020 at 01:27:45PM +0200, Daniel Wagner wrote:
> Hi Bart,
> 
> > diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> > index 42dbf90d4651..de9c1604c575 100644
> > --- a/drivers/scsi/qla2xxx/qla_def.h
> > +++ b/drivers/scsi/qla2xxx/qla_def.h
> > @@ -46,7 +46,7 @@ typedef struct {
> >  	uint8_t al_pa;
> >  	uint8_t area;
> >  	uint8_t domain;
> > -} le_id_t;
> > +} __packed le_id_t;
> 
> Now I am totally confused. le_id_t (and why does be_id_t not need it?) are
> not used inside either of the reported data structure (cmd_entry_t,
> ms_iocb_entry_t, request_t, struct ctio_crc2_to_fw, struct ctio7_to_24xx,
> struct ctio_to_2xxx) which the bot reports. I must oversee something.
> 

I also had the thought that both fields should be packed for sake of
consistency because there is fcp_hdr with be_id_t sid/did and
fcp_hdr_le with le_id_t sid/did. You also seem to be correct, about your
concerns. I overlooked that only ctio_crc2_to_fw and ctio7_to_24xx have
le_id_t initiator_id field.

Roman
