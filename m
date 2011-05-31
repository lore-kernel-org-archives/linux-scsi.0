From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Tue, 31 May 2011 12:22:00 +0200
Message-ID: <20110531102200.GA31697@lst.de>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com> <1306523240-15543-40-git-send-email-agrover@redhat.com> <1306834367.8193.169.camel@haakon2.linux-iscsi.org> <20110531094800.GA31240@lst.de> <1306836641.8193.185.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44704 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab1EaKWA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 06:22:00 -0400
Content-Disposition: inline
In-Reply-To: <1306836641.8193.185.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1118,7 +1118,7 @@ attach_cmd:
>          * the underlying transport plugin has allocated the buffer to
>          * receive the Immediate Write Data into.
>          */
> -       transport_generic_handle_cdb(SE_CMD(cmd));
> +       transport_generic_new_cmd(SE_CMD(cmd));

This is still missing the error handling, as well as the other callers
in the iscsi code.  When adding the proper error handling please do it
by checking the transport_generic_new_cmd return value instead of
through transport_new_cmd_failure.  With a bit more work this should
also allow killing off the SCF_SE_CMD_FAILED flag.

