Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695D8C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 08:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbjAQIOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 03:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbjAQINt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 03:13:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C88017CD9;
        Tue, 17 Jan 2023 00:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ykl8YxqWM2XDabzHVU//SDIUFqN9ZU1L8lRmUeXmMSQ=; b=vfQznUMOl0Yzo8gz9iad5y4uEf
        YDV7o/KBtcDfKzSbhAyqhEASfUqIFGbdBC6UzNXEAFgP4RsCeFhaHeDzHDnWqmkW4knmSHjK6gSiK
        ajp4mCIwy3QAxc4PuqTtN/5RLFR0Wz4+W5M9XKN9U/i2liPloW/q+pZRZdZg5VWek/y5MPX9yRAKZ
        c9mdrgvYcrOqEzE0WWzavn3dvqRYo0c3UjHZdoYYvm5UqVR1o06M5D0/7/Ku6C8AEw0PYO+t7Ygr3
        kUgc758TJp82x7tf1gFe9kG4DAXOiioOF45iHVnoCwFGD1ErA7OQvIlwT4hgkHDlZZrM8d/R8nMtD
        nl6HzurA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHh6G-00DHoj-76; Tue, 17 Jan 2023 08:13:44 +0000
Date:   Tue, 17 Jan 2023 00:13:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v2 07/18] block: introduce duration-limits priority class
Message-ID: <Y8ZYuIlxC3Ui0LMP@infradead.org>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-8-niklas.cassel@wdc.com>
 <Y8ZNftvsEIuPqMFP@infradead.org>
 <2bd49412-de68-91d3-e710-0b24fed625d2@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bd49412-de68-91d3-e710-0b24fed625d2@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 17, 2023 at 05:06:52PM +0900, Damien Le Moal wrote:
> They can, by using a large limit for "low priority" IOs. But then, these
> would still have a limit while any IO issued simultaneously without a CDL
> index specified would have no limit at all. So strictly speaking, the no
> limit IOs should be considered as even lower priority that CDL IOs with
> large limits.
> 
> The other aspect here is that on ATA drives, CDL and NCQ priority cannot
> be used together. A mix of CDL and high priority commands cannot be sent
> to a device. Combining this with the above thinking, it made sense to me
> to have the CDL priority class handled the same as the RT class (as that
> is the one that maps to ATA NCQ high prio commands).

Ok.  Maybe document this a bit better in the commit log.
