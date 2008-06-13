From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Fri, 13 Jun 2008 18:57:29 +0200
Message-ID: <8db1092f0806130957r22bf02a4pd5138f67f4ac56dd@mail.gmail.com>
References: <48328E81.2080504@panasas.com>
	 <Pine.LNX.4.44L0.0806031047380.2363-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:37851 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYFMQ5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2008 12:57:31 -0400
Received: by wf-out-1314.google.com with SMTP id 27so4195872wfd.4
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2008 09:57:30 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0806031047380.2363-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

2008/6/3 Alan Stern <stern@rowland.harvard.edu>:
[...]
>
> What do you think of a patch like this?
>
> Index: usb-2.6/include/linux/blkdev.h
> ===================================================================
> --- usb-2.6.orig/include/linux/blkdev.h
> +++ usb-2.6/include/linux/blkdev.h
> @@ -221,6 +221,7 @@ struct request {
>
>        unsigned int data_len;
>        unsigned int extra_len; /* length of alignment and padding */
> +       unsigned int min_data_len;
>        unsigned int sense_len;
>        void *data;
>        void *sense;
> Index: usb-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> +++ usb-2.6/drivers/scsi/scsi_lib.c
> @@ -1125,6 +1125,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
>                ret = scsi_init_io(cmd, GFP_ATOMIC);
>                if (unlikely(ret))
>                        return ret;
> +               cmd->underflow = req->min_data_len;
>        } else {
>                BUG_ON(req->data_len);
>                BUG_ON(req->data);
>
> Combined with an extra minimum-data-length argument to scsi_execute()
> and scsi_execute_req(), this ought to solve the problem.
>
> (To refresh your memory: The problem is that a weird device responds to
> MODE SENSE with Residue equal to the data length -- so none of the
> returned data is valid -- and Okay status.)
>
> Alan Stern
>
> P.S.: Maybe a safer approach would be to add a new flag bit in struct
> request.  Normally the flag would be clear, indicating that for
> BLOCK_PC requests, scmd->underflow should be set to 0.  But when the
> flag is set, scmd->underflow would be set to req->data_len.
>
>

It does'n help. I still have "write protect is on" message. Also I see
"usb-storage: queuecommand called" message.

Log (2.6.26-rc2):
http://www.unixy.pl/maciek/download/kernel/2.6.26-rc2/20080613/syslog

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
