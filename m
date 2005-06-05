From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Sun, 05 Jun 2005 09:40:08 -0500
Message-ID: <1117982408.4990.12.camel@mulgrave>
References: <1117847972.23638.62.camel@mina>
	<1117901234.5005.9.camel@mulgrave>  <1117955727.4961.8.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1117955727.4961.8.camel@mina>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2005-06-05 at 00:15 -0700, Mike Christie wrote:
> +int scsi_execute_req(struct scsi_device *sdev, unsigned char *cmd,
> +                    int data_direction, void *buffer, unsigned
> bufflen,
> +                    unsigned char *sense, int timeout, int retries)


Actually, not quite; there are two problems with this

1. We may not be able to compute the command length for vendor specific
commands and the group 3 (variable length command 0x7f). 
2. some requests want to set other flags (REQ_FAILFAST mostly).

However, extra arguments should accommodate these.

This:

> +       if (!req)

Should be if (IS_ERR(req))

Also, you can't do this (use after free):

> +       blk_put_request(req);
> +       return req->errors;

Finally, there's coming up with a replacement API for scsi_do_req that
returns via the end_io callback ... since that doesn't do a wait/wake,
perhaps this should be the core API upon which the others are built?

James
