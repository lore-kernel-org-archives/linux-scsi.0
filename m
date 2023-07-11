Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2865FEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 05:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjGKFJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 01:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGKFJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 01:09:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2180FFE
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 22:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7WTLsmvVN0w90UyytXcDu+G0r4YWlA6ad0Cb2mFsFDQ=; b=TGqzEq8AWuQ61ZwbQMJ6JLtzG0
        HfjBqI4wisylnDYBkEtRf/4aH3HmNxFc3Id2yR8WIqjNGmB2PEsYBUUXrsSmefNd9US5Dm3cT0dfF
        oIuoglfeQ2ZjOAFiWKUcgIe4CEUouD0V0Wk0kHacsBdOTRiesAxXkz0Spbr975MqLi/bfftkAUgN9
        k+symAbloOoU8WWNtFMQ+dWHUkuUKVOdBIGrfcjdP8xSYSZZAY8Etcf/IOaVg060e5BOZPoGWHtNv
        8wXyCsj8GyIsheThKypVYEzpN4H2QVMBwIzVQT3nVMcgXfGg79lxodBJwZGevHIaryF/I8XMnX0zV
        BpwFJrIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qJ5d2-00DifZ-2K;
        Tue, 11 Jul 2023 05:09:36 +0000
Date:   Mon, 10 Jul 2023 22:09:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: Include major and minor number in UFS command
 tracing output
Message-ID: <ZKzkEMIvrICQ3dWK@infradead.org>
References: <20230706215124.4113546-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230706215124.4113546-1-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 06, 2023 at 02:51:04PM -0700, Bart Van Assche wrote:
>  	TP_fast_assign(
> -		__assign_str(dev_name, dev_name);
> +		__entry->dev = disk_devt(sdev->request_queue->disk);

sdev->request_queue->disk can be NULL and no LLDD has any business
looking at it, as it is owned by the ULD (if one is actually bound).

