Return-Path: <SRS0=6ycn=BL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C12EC433E1
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Aug 2020 08:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26A6F2067D
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Aug 2020 08:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgHAIKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Aug 2020 04:10:32 -0400
Received: from smtprelay0163.hostedemail.com ([216.40.44.163]:39208 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725283AbgHAIKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2020 04:10:32 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 314001800F08E;
        Sat,  1 Aug 2020 08:10:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: bears44_4f154d426f8a
X-Filterd-Recvd-Size: 2765
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sat,  1 Aug 2020 08:10:29 +0000 (UTC)
Message-ID: <0c1803c6aaca42579b7933fd219e4e208ab7524f.camel@perches.com>
Subject: Re: [PATCH] scsi: libcxgbi: use kvzalloc instead of opencoded
 kzalloc/vzalloc
From:   Joe Perches <joe@perches.com>
To:     Denis Efremov <efremov@linux.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 01 Aug 2020 01:10:28 -0700
In-Reply-To: <c5a18804-3236-9688-2a3c-68184f0dd9e8@linux.com>
References: <20200731215524.14295-1-efremov@linux.com>
         <33d943d2b83f17371df09b5962c856ea2d894954.camel@perches.com>
         <70fb8220-2102-adb5-bbe6-9c2ea74a0623@linux.com>
         <8638183f559c0f8f8d377bd0a6c91903b2c588df.camel@perches.com>
         <c5a18804-3236-9688-2a3c-68184f0dd9e8@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-08-01 at 10:51 +0300, Denis Efremov wrote:
> On 8/1/20 1:24 AM, Joe Perches wrote:
> > On Sat, 2020-08-01 at 01:10 +0300, Denis Efremov wrote:
> > > On 8/1/20 12:58 AM, Joe Perches wrote:
> > > > On Sat, 2020-08-01 at 00:55 +0300, Denis Efremov wrote:
> > > > > Remove cxgbi_alloc_big_mem(), cxgbi_free_big_mem() functions
> > > > > and use kvzalloc/kvfree instead.
> > > > 
> > > > Sensible, thanks.
> > > > 
> > > > > diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> > > > []
> > > > > @@ -77,9 +77,9 @@ int cxgbi_device_portmap_create(struct cxgbi_device *cdev, unsigned int base,
> > > > >  {
> > > > >  	struct cxgbi_ports_map *pmap = &cdev->pmap;
> > > > >  
> > > > > -	pmap->port_csk = cxgbi_alloc_big_mem(max_conn *
> > > > > -					     sizeof(struct cxgbi_sock *),
> > > > > -					     GFP_KERNEL);
> > > > > +	pmap->port_csk = kvzalloc(array_size(max_conn,
> > > > > +					     sizeof(struct cxgbi_sock *)),
> > > > > +				  GFP_KERNEL);
> > > > 
> > > > missing __GFP_NOWARN
> > > > 
> > > 
> > > kvmalloc_node adds __GFP_NOWARN internally to kmalloc call
> > > https://elixir.bootlin.com/linux/v5.8-rc4/source/mm/util.c#L568
> > 
> > Only when there's a fallback, and the fallback does not.
> Sorry, Joe, I don't understand why do we need to add __GFP_NOWARN here.

Hi.

The reason to add __GFP_NOWARN is so you don't get a
dump_stack() as there's an existing error message
output below this when OOM.

You should either remove the error message as it just
effectively duplicates the dump_stack or add __GFP_NOWARN.

Your choice.

cheers, Joe

