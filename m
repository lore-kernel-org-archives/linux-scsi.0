From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] iscsi_tcp: Enable any size command
Date: Mon, 12 May 2008 10:47:04 -0500
Message-ID: <1210607224.3078.10.camel@localhost.localdomain>
References: <48182A1B.2060102@panasas.com>  <48182E1C.6020905@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60001 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbYELRfH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2008 13:35:07 -0400
In-Reply-To: <48182E1C.6020905@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Wed, 2008-04-30 at 11:30 +0300, Boaz Harrosh wrote:
> Let through upto the largest command of 260 defined by the scsi standard.
> iscsi core supports this already. Now that the scsi-ml supports it we can
> start using large commands.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/iscsi_tcp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 72b9b2a..826c97c 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1978,7 +1978,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
>  	.host_template		= &iscsi_sht,
>  	.conndata_size		= sizeof(struct iscsi_conn),
>  	.max_conn		= 1,
> -	.max_cmd_len		= 16,
> +	.max_cmd_len		= SCSI_MAX_VARLEN_CDB_SIZE,
>  	/* session management */
>  	.create_session		= iscsi_tcp_session_create,
>  	.destroy_session	= iscsi_tcp_session_destroy,

OK, this isn't quite right.  The escb definition in iscsi.h is:
struct iscsi_ecdb_ahdr {
	__be16 ahslength;	/* CDB length - 15, including reserved byte */
	uint8_t ahstype;
	uint8_t reserved;
	/* 4-byte aligned extended CDB spillover */
	uint8_t ecdb[260 - ISCSI_CDB_SIZE];
};

Either that 260 needs to become SCSI_MAX_VARLEN_CDB_SIZE or we need to
hard code 260 in the max_cmd_len.

Since SCSI_MAX_VARLEN_CDB_SIZE is really a useless constant (nothing
depends on it), and internal packets in iscsi depend on this, it
probably makes the most sense for this to be an iscsi local constant.

The value (260) also looks a bit bogus, isn't 262 the maximum possible
size for a 0x7f variable length command?  The iSCSI maxiumum is far
higher than this (but no protocol sends anything above the 0x7f maximum
currently).

James


James


