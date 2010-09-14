From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI: fix unsafe operations related to sshdr in
 scsi_test_unit_ready()
Date: Tue, 14 Sep 2010 09:47:05 -0500
Message-ID: <1284475625.20409.21.camel@mulgrave.site>
References: <AANLkTinDmT5aVZ0PdozfGHE9tsqomaNfP0CGAcg6j=98@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39994 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab0INO5U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2010 10:57:20 -0400
In-Reply-To: <AANLkTinDmT5aVZ0PdozfGHE9tsqomaNfP0CGAcg6j=98@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, 2010-09-14 at 21:26 +0800, Hillf Danton wrote:
> The kzalloc for sshdr is replaced with sshdr struct on stack, then it
> looks safer.

This premise is completely wrong.  There are lots of times stack can be
wrong for driver code especially: DMA or aligment but for general code,
since we went to 4k stacks we have very little space; a lot of arrays
and structures got moved to kmalloc to reduce stack consumption.

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> 
> --- o/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c 2010-08-16
> 08:41:38.000000000 +0800
> +++ m/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c 2010-09-14
> 21:03:34.000000000 +0800
> @@ -1984,12 +1984,13 @@ scsi_test_unit_ready(struct scsi_device 
>   char cmd[] = {
>   TEST_UNIT_READY, 0, 0, 0, 0, 0,
>   };
> - struct scsi_sense_hdr *sshdr;
> + struct scsi_sense_hdr *sshdr, hdr;
>   int result;
>  
> - if (!sshdr_external)
> - sshdr = kzalloc(sizeof(*sshdr), GFP_KERNEL);
> - else
> + if (!sshdr_external) {
> + sshdr = &hdr;
> + memset(sshdr,0,sizeof(*sshdr));
> + } else

And the patch is unapplyable: it looks like your mailer has elided all
the tabs and broken some of the lines.  Please see
Documentation/email-clients.txt for suggestions how to fix this.

Finally, this didn't make it to linux-scsi because you sent it as an
html message, which the list drops without comment ... you have to send
text/plain only.

James



