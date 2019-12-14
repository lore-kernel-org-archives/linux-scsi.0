Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A1EC43603
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 12:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18C220706
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 12:30:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="iuabivlG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLNMav (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 07:30:51 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:36640 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbfLNMav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Dec 2019 07:30:51 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id AC68041200;
        Sat, 14 Dec 2019 12:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1576326648;
         x=1578141049; bh=2xtoCtgEth26EZLIX2i2bh11gIgslk8w4hLrr7bNHSk=; b=
        iuabivlGFN/qgHzuoAE0JfTpRrXNsq2x2DnhAv4soTscC31H/xZQd7bAW1lRdyBN
        IK0C/dIItTba3h5gEAhsOoRrdx3q7aEPzzn1w9O0SeeMnw517r/gubbWO3RiRNgV
        1RcJud25y3qcrs4gZpui77UPKgzIXiCz57XkvS1u7jg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id w-1jixI1YVBI; Sat, 14 Dec 2019 15:30:48 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7B9AE411F8;
        Sat, 14 Dec 2019 15:30:47 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 14
 Dec 2019 15:30:46 +0300
Date:   Sat, 14 Dec 2019 15:30:46 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Martin Wilck <mwilck@suse.de>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        <linux-scsi@vger.kernel.org>, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 4/4] qla2xxx: Micro-optimize
 qla2x00_configure_local_loop()
Message-ID: <20191214123046.uzlp3dbdirmcyery@SPB-NB-133.local>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-5-bvanassche@acm.org>
 <5ff7962a50719d79a3262bcb290bc93b3a8e3058.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5ff7962a50719d79a3262bcb290bc93b3a8e3058.camel@suse.de>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 10, 2019 at 11:46:17AM +0100, Martin Wilck wrote:
> Hello Bart,
> 
> On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
> > Instead of changing endianness in-place and copying the data in two
> > steps,
> > do this in one step. This patch makes is a preparation step for
> > fixing the
> > endianness warnings reported by 'sparse' for the qla2xxx driver.
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> > index 6c28f38f8021..ddd8bf7997a8 100644
> > --- a/drivers/scsi/qla2xxx/qla_init.c
> > +++ b/drivers/scsi/qla2xxx/qla_init.c
> > @@ -5047,13 +5047,12 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
> >  			rval = qla24xx_get_port_login_templ(vha,
> >  			    ha->init_cb_dma, (void *)ha->init_cb, sz);
> >  			if (rval == QLA_SUCCESS) {
> > +				__be32 *q = &ha->plogi_els_payld.data[0];
> > +
> >  				bp = (uint32_t *)ha->init_cb;
> > -				for (i = 0; i < sz/4 ; i++, bp++)
> > -					*bp = cpu_to_be32(*bp);
> > +				for (i = 0; i < sz/4 ; i++, bp++, q++)
> > +					*q = cpu_to_be32(*bp);
> >  
> > -				memcpy(&ha->plogi_els_payld.data,
> > -				    (void *)ha->init_cb,
> > -				    sizeof(ha->plogi_els_payld.data));
> >  				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> >  			} else {
> >  				ql_dbg(ql_dbg_init, vha, 0x00d1,
> 
> A side effect of this patch would be that after return from
> qla2x00_configure_local_loop(), the byte ordering in ha->init_cb
> remains in CPU byte ordering, whereas before your patch, it would have
> been converted to be32. I'm uncertain if that would matter later on.
> 
> The following is not a problems with your patch, but what's really
> weird is that in qla24xx_get_port_login_templ() (which is only called
> from here), the buffer is converted from le32 to CPU endianness, and
> then here, in a second step, from CPU to be32. I'm wondering which byte
> order this buffer is supposed to have, and whether that's different
> depending on which mode the controller is operating in (the be32
> conversion seems to be applied in N2N mode only). Moreover, looking at
> the definition of init_cb_t in qla_def.h, this data structure actually
> has mixed endianness, making me doubt that changing the endianness of
> the whole buffer makes sense at all. Or is ha->init_cb simply being
> abused in this part of the code?
> 
> I guess only Himanshu or Quinn can tell.
> 

PLOGI payload is returned from FW in little-endian 32-bit words, but ELS
IOCB should have big-endian payload. That's why the conversion happens.
init_cb is only temporary container to get the results from FW.
The big-endian ELS payload is copied from plogi_els_payld.data to
elsio->u.els_plogi.els_plogi_pyld->data in qla24xx_els_dcmd2_iocb()
before being sent to FW/ASIC.

Thanks,
Roman
