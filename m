Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199CAC7618A
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Mar 2023 12:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjCTM5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 08:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCTM5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 08:57:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8603CC672;
        Mon, 20 Mar 2023 05:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5hAf/YTOCf6A7zvzClwDETx6u+L/NYn62UIl9V3FUMY=; b=bLbbcxj9I8pem38a7g8bD92bMq
        SPNSdWMRUq+lzx4gk7y9F1J8zMv2ut+gi5Ia4qSUueILxOE0CoA+8Qsn5AwsWJ4aZMjX/IJVQs69g
        rBxKnCbIG3pBOxVzRYvyCqRxmqwEnFZ/CcFoW2AIdjQr2EdLUlge2j/CXutT0WijvZoBNHxdoNzdM
        X1N+Zw7FFdPDy//Kq4ZUA1lr6jHa9rOWOkcnXja2lTAKzrZSa6bd+MinUy06KKi9kZnmlGiKyLrNS
        msOVOgSk44dtfG7MHsNC4oKyZDxs7X7RWtCM3wnMX3a5oi3n461L2KebkmxhANLL0EvErkRd0Cw02
        M+kXux3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1peF3N-0091Tf-1t;
        Mon, 20 Mar 2023 12:55:57 +0000
Date:   Mon, 20 Mar 2023 05:55:57 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: support IO traces for zoned block device
Message-ID: <ZBhX3YfHGtY8kom8@infradead.org>
References: <20230215190448.1687786-1-jaegeuk@kernel.org>
 <Y+3GzX6yMOKUFTh3@infradead.org>
 <Y/05p0jYrg2wfXw6@google.com>
 <DM6PR04MB65751899638206110D3D8FC2FCAC9@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB65751899638206110D3D8FC2FCAC9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 28, 2023 at 07:28:35AM +0000, Avri Altman wrote:
> > doorbell status along with the attached scsi command, in addition to the
> > accurate latency measurements.
> For us as well.
> Moreover, we are mainly using upiu tracing which is not available at scsi ML.

So let's rework the tracepoints to work at the UPIU level and stop the
gracious poking into SCSI CDBs.
