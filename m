Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B965C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 22:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C74923A5C
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 22:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbhAVWXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 17:23:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730635AbhAVTyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 14:54:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611345182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iJNkgfAkLn3G0Jr90sYu9NowBX2HZx2PfUHAjq5hb7c=;
        b=XETM93Mmj6EDU6+TaYqDlyeD2bGAZFx44J/tZwe2Pp4wedP1v02bftwg+P2NIA5sFCTvz9
        fq13F3cjDEZWVccuvjWYuXftIRH6F1W7xH7uvM69/cDBDBJiJZot//lORgrpGMEJ49Njiz
        /c/PeIlaocFYijJ7a7eQMCeaOtH3gRA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-3kFJGJg0MOCp8XUUrlrJ8g-1; Fri, 22 Jan 2021 14:53:00 -0500
X-MC-Unique: 3kFJGJg0MOCp8XUUrlrJ8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D016E10054FF;
        Fri, 22 Jan 2021 19:52:58 +0000 (UTC)
Received: from ovpn-113-224.phx2.redhat.com (ovpn-113-224.phx2.redhat.com [10.3.113.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A735B71D4D;
        Fri, 22 Jan 2021 19:52:57 +0000 (UTC)
Message-ID: <c0c7b4cde76c9b15aad9fa213dcaeb75295763fd.camel@redhat.com>
Subject: Re: [PATCH] scsi_logging: print cdb into new line after opcode
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     dgilbert@interlog.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 22 Jan 2021 14:52:56 -0500
In-Reply-To: <20210122083918.901-1-martin.kepplinger@puri.sm>
References: <20210122083918.901-1-martin.kepplinger@puri.sm>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-01-22 at 09:39 +0100, Martin Kepplinger wrote:
> The current log message results in a line like the following where
> the first byte is duplicated, giving a wrong impression:
> 
> sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 00 60 40 00 00 01
> 00
> 
> Print the cdb into a new line in any case, not only when cmd_len is
> greater than 16. The above example error will then read:
> 
> sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28
> 28 00 01 c0 09 00 00 00 08 00
> 
> Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> ---
>  drivers/scsi/scsi_logging.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_logging.c
> b/drivers/scsi/scsi_logging.c
> index 8ea44c6595ef..0081d3936f83 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -200,10 +200,11 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  	if (off >= logbuf_len)
>  		goto out_printk;
>  
> +	/* Print opcode in one line and use separate lines for CDB */
> +	off += scnprintf(logbuf + off, logbuf_len - off, "\n");
> +
>  	/* print out all bytes in cdb */
>  	if (cmd->cmd_len > 16) {
> -		/* Print opcode in one line and use separate lines for
> CDB */
> -		off += scnprintf(logbuf + off, logbuf_len - off, "\n");
>  		dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s",
> logbuf);
>  		for (k = 0; k < cmd->cmd_len; k += 16) {
>  			size_t linelen = min(cmd->cmd_len - k, 16);
> @@ -224,7 +225,6 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  	if (!WARN_ON(off > logbuf_len - 49)) {
> -		off += scnprintf(logbuf + off, logbuf_len - off, " ");
>  		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
>  				   logbuf + off, logbuf_len - off,
>  				   false);

I'd rather we not change this.

-Ewan


