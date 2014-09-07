From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/20] scsi: use local buffer for printing CDB
Date: Sun, 7 Sep 2014 09:10:26 -0700
Message-ID: <20140907161026.GA16238@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52143 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaIGQKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:10:37 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:06:09PM +0200, Hannes Reinecke wrote:
> The CDB needs to be printed in one line (ie with one printk
> statement) to avoid the individual bytes to be broken up
> under high load.
> As using individual printk() statements here would lead to
> unnecessary complicated code and needs the stack space to
> hold the format string we should be using a local buffer
> here. If the CDB is longer than the provided buffer
> it will be printed in several lines.

Some general comments:

 - as pointed out by YUNOMAE-san we need a constant for the buffer.  And
   I'd also like to see a comment why exactly you're chosing 80 for it.
 - I'd really like to see some worst case stack usage analysis of the
   old vs the new case.

> @@ -189,6 +189,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
>  {
>  	int errno, retries = 0, timeout, result;
>  	struct scsi_sense_hdr sshdr;
> +	char buf[80];
>  
>  	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
>  		? timeout_init : timeout_move;
> @@ -196,8 +197,8 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
>   retry:
>  	errno = 0;
>  	if (debug) {
> -		DPRINTK("command: ");
> -		__scsi_print_command(cmd);
> +		__scsi_print_command(cmd, buf, 80);
> +		DPRINTK("command: %s", buf);

The buffer variable should be inside the "if (debug)" here.

> +/* attempt to guess cdb length if cdb_len==0 */

cdb_len == 0 is only passed in from __scsi_print_command.  But as far
as I can tell all of it's caller have it easily available, so we should
just pass it in and get rid of this special case.

> +static int print_opcode_name(unsigned char * cdbp, int cdb_len,
> +			     char *buf, int buf_len)

This doesn't print anything now, but just formats the CDB, so it
should be called format_opcode_name.   Also as a convention pass
buf and buf_len as the first two arguments similar to s*printf,
and fix up the formatting for the cdbp argument.  Can you please
just run your next series through checkpatch?

> -void __scsi_print_command(unsigned char *cdb)
> +void __scsi_print_command(unsigned char *cdb, char *buf, int buf_len)

Rename this to scsi_format_command, pass buf and buf_len as first two
argument, and as mention earlier pass in the cdb length as well.

>  {
> +	int len, off;
>  
> +	off = print_opcode_name(cdb, 0, buf, buf_len);
>  	len = scsi_command_size(cdb);
> +	/* Variable length CDBs are not supported */

Why?
