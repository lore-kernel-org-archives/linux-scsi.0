Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5685AC4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 18:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35F6560EFF
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 18:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhHPSOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 14:14:41 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39588 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229481AbhHPSOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 14:14:39 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8522B4AB7F;
        Mon, 16 Aug 2021 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1629137641;
         x=1630952042; bh=jjOlrOal2xp49reqXeUtwQnhcJUmZfCoWXdHsH5GYQg=; b=
        aJ4MHXG2/iLxl6a9bX1nT55Z19GP0k71DfJuNsRsxvOzgIEFYrZEoCtX/H7Fl0iW
        1P+cai+gozGpXZHbifjoWw5DCsMiPj5V4LqlhhkNav/xniAIudLtW1b90ZbegZfM
        QK57MOe2L1qXeQn2mcBtp5tYArsOw+rVkkeu6v752ng=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8uSiNkITcgMP; Mon, 16 Aug 2021 21:14:01 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 25D574AAFF;
        Mon, 16 Aug 2021 21:14:01 +0300 (MSK)
Received: from localhost (172.22.1.233) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 16
 Aug 2021 21:14:00 +0300
Date:   Mon, 16 Aug 2021 21:13:59 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     David Disseldorp <ddiss@suse.de>
CC:     Sergey Samoylenko <s.samoylenko@yadro.com>,
        <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <bvanassche@acm.org>, <target-devel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>
Subject: Re: [PATCH 1/1] scsi: target: core: Add 8Fh VPD page
Message-ID: <YRqq50h81kYFFHki@SPB-NB-133.local>
References: <20210729201943.40222-1-s.samoylenko@yadro.com>
 <20210729201943.40222-2-s.samoylenko@yadro.com>
 <20210813165255.650257ce@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210813165255.650257ce@suse.de>
X-Originating-IP: [172.22.1.233]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 13, 2021 at 04:52:55PM +0200, David Disseldorp wrote:
> Hi Sergey,
> 
> On Thu, 29 Jul 2021 23:19:43 +0300, Sergey Samoylenko wrote:
> 
> > The 8Fh VPD page announces the capabilities supported by
> > the TCM XCOPY manager. It helps to expand the coverage of
> > the third-party copy manager with SCSI testing utilities.
> 
> Please list which initiators use this VPD page, if you know of any.
> Also, is there any test coverage for this? I don't see anything in
> libiscsi...
> 

Hi David,

ESXi is one of the hosts that inspects Third Party Copy VPD Page.
Windows detects ODX support using the page [1][2].

The page is also used by libiscsi to detect presence and features of
copy manager as was agreed with Bart in the PR [3]:

"Implementing REPORT SUPPORTED OPERATION CODES in LIO would require more
work than implementing the third-party copy VPD page.

I'm fine with relying on the third-party copy VPD page, or in other
words, to skip the copy offloading tests if that page is not supported.

There are plans to implement XCOPY support in the Linux kernel sd
driver. If nobody else volunteers I plan to work on this myself. I'm
considering to only support SCSI targets that support the third-party
copy VPD page. Or in other words, we will need support for that VPD page
anyway."

1. https://www.slideshare.net/CalvinChen5/a-joint-effort-of-the-storage-industry
2. http://sg.danny.cz/sg/ddpt_xcopy_odx.html
3. https://github.com/sahlberg/libiscsi/pull/353

> > Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> > Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> > Reviewed-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> > Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
> > ---
> >  drivers/target/target_core_spc.c | 230 ++++++++++++++++++++++++++++++-
> >  1 file changed, 226 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> > index 22703a0dbd07..169341712b10 100644
> > --- a/drivers/target/target_core_spc.c
> > +++ b/drivers/target/target_core_spc.c
> ...
> > +/* Third-party Copy VPD page */
> > +static sense_reason_t
> > +spc_emulate_evpd_8f(struct se_cmd *cmd, unsigned char *buf)
> > +{
> > +	struct se_device *dev = cmd->se_dev;
> > +	int off;
> > +	u16 page_len;
> > +
> > +	if (!dev->dev_attrib.emulate_3pc)
> > +		return TCM_INVALID_CDB_FIELD;
> > +
> > +	/*
> > +	 * Since the Third-party copy manager in TCM is quite simple
> > +	 * and supports only two commands, the function sets
> > +	 * many descriptor parameters as constants.
> > +	 *
> > +	 * As the Copy manager supports the EXTENDED COPY(LID1) command,
> > +	 * the Third-party Copy VPD page should include five mandatory
> > +	 * Third-party copy descriptors. Its are:
> > +	 *   0001h - Supported Commands
> > +	 *   0004h - Parameter Data
> > +	 *   0008h - Supported Descriptors
> > +	 *   000Ch - Supported CSCD Descriptor IDs
> > +	 *   8001h - General Copy Operations
> > +	 *
> > +	 * See spc4 section 7.8.17
> > +	 */
> > +
> > +	off = 4;
> > +
> > +	/* fill descriptors */
> > +	off += spc_evpd_8f_encode_supp_cmds(&buf[off]);
> > +	off += spc_evpd_8f_encode_param_data(&buf[off]);
> > +	off += spc_evpd_8f_encode_supp_descrs(&buf[off]);
> > +	off += spc_evpd_8f_encode_supp_cscd_descr_id(&buf[off]);
> > +	off += spc_evpd_8f_encode_general_copy_ops(&buf[off]);
> 
> This looks risky in terms of buf overrun. I think it'd be good to pass
> a @remaining or @buf_end param to these helper functions.
> 

It's doable but would require to change the signature of all existing
VPD handlers. SE_INQUIRY_BUF is hardcoded to 1kb but it's also capped by
EDTL to avoid buffer overruns:

  memcpy(rbuf, buf, min_t(u32, SE_INQUIRY_BUF, cmd->data_length));

Regards,
Roman
