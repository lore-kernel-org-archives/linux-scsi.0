Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E92C7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 05:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjFAFX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 01:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjFAFX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 01:23:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAB712C
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 22:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GxAZ/2ep9J9KVatAx7A08uKleXaeqo3EQFW7PaUgnxk=; b=ci54wLFdXuZ/BySnIgu0tCsedf
        eX24h+t490XVEP2Tl2fRfU9ShUDCU0VXx44IaxZVPZ4P8I12AqNne9o3/ttNDuX4kcX7UGcn9ENrk
        9ZathlR8Uo68ZHDLqYxOX/Q1DKQKT8DclhlCIxWwYq8cG1OOXENigHugeQljD6TC3deU5rNz+2Tf+
        7FHlkJeDtx05VICfhjIa0x3KAOBxipuHERMxhlu/yA05ir2AQ3XdV0zI7Aw6vuhB/uiaQ3omWY+/C
        bjvcFr2Nk1eTvmhwRFYRAjUuCquh3vGxJY9otWlKwLF7BLNKNFJKeeN55es/BPiQoj4Bj7fG7qh+0
        I+KKqe/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q4amo-0021AB-0d;
        Thu, 01 Jun 2023 05:23:46 +0000
Date:   Wed, 31 May 2023 22:23:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: Re: [PATCH] scsi: ufs: Include major and minor number in command
 tracing output
Message-ID: <ZHgrYgDmvhs7Iw/d@infradead.org>
References: <20230531223924.25341-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531223924.25341-1-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 31, 2023 at 03:39:20PM -0700, Bart Van Assche wrote:
> UFS devices are typically configured with multiple logical units.
> The device name, e.g. 13200000.ufs, does not include logical unit
> information. Hence this patch that replaces the device name with
> the disk major and minor number in the tracing output, e.g. 8,0,
> just like the block layer tracing information.

Please also drop the never used group_id value while you're at it.

