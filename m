From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 15/16] block: split scsi_request out of struct request
Date: Thu, 26 Jan 2017 11:12:51 -0800
Message-ID: <455a58ef-905c-abf9-ae59-ca98f003f31e@sandisk.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-16-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0051.outbound.protection.outlook.com ([104.47.32.51]:9280
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752674AbdAZTNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 14:13:12 -0500
In-Reply-To: <1485185361-29786-16-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 01/23/2017 07:29 AM, Christoph Hellwig wrote:
> +int scsi_cmd_buf_len(struct request *rq)
> +{
> +	return scsi_req(rq)->cmd_len * 3;
> +}
> +EXPORT_SYMBOL(scsi_cmd_buf_len);

Hello Christoph,

Where does the '* 3' come from? I think that deserves a comment.
Additionally, this patch introduces a new warning when building with W=1:

block/scsi_ioctl.c:761:5: warning: no previous prototype for
‘scsi_cmd_buf_len’ [-Wmissing-prototypes]

Please consider adding #include <linux/blktrace_api.h> to the source
file in which scsi_cmd_buf_len() is added.

Thanks,

Bart.
