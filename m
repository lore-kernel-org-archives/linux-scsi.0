Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D46FCA9EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 07:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7209521872
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 07:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571901640;
	bh=r05zpQk+sGKJ+mNeJX+ppyOhDDxn3H2zrZFPWNX+S/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=EaRF5J4NQFVaZkepZUM8CE/+HlMqCBJXfvV98cRHyuqBIAzL5EDsPWAIeDcTG2nGO
	 9ABL129cGjMYQPDK3fTS84oGRzJJBQb8yyGuiu9nDYiH7DUnJUmRN0xSinKXhbaw83
	 eymCCEYic8zTNuAiJnc7eBD3k49FO05hWqtBLcxE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406801AbfJXHUj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404514AbfJXHUj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 03:20:39 -0400
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF5C420684;
        Thu, 24 Oct 2019 07:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571901638;
        bh=r05zpQk+sGKJ+mNeJX+ppyOhDDxn3H2zrZFPWNX+S/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ViesRoFXjszl5pcUhVwBax8DbhS4gg+iLmh0cAKv3FVs94l0sMp1nYQYv+5wX/PW7
         3nspD6qaQLjyvQZN2rXYLuoO3TK0fBYZ5ej3RfeICt41FAbHdpOUfLs/mkf3KhYMNP
         8SL9za3N04Tsn+iKTMI8yXD7xoS5GAJX5YPNwAVg=
Date:   Thu, 24 Oct 2019 16:20:31 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/4] block: Enhance blk_revalidate_disk_zones()
Message-ID: <20191024072031.GA29028@redsun51.ssa.fujisawa.hgst.com>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
 <20191024065006.8684-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024065006.8684-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 24, 2019 at 03:50:03PM +0900, Damien Le Moal wrote:
> -	/* Do a report zone to get max_lba and the same field */
> -	ret = sd_zbc_do_report_zones(sdkp, buf, bufsize, 0, false);
> +	/* Do a report zone to get max_lba and the size of the first zone */
> +	ret = sd_zbc_do_report_zones(sdkp, buf, SD_BUF_SIZE, 0, false);

This is no longer reading all the zones here, so you could set the
'partial' field to true. And then since this was the only caller that
had set partial to false, you can also remove that parameter.
