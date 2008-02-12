From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] block layer varlen-cdb
Date: Tue, 12 Feb 2008 19:54:39 +0200
Message-ID: <47B1DD5F.9050709@panasas.com>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc> <200802100006.11086.bzolnier@gmail.com> <20080210052621.GA22257@infradead.org> <200802101438.46698.bzolnier@gmail.com> <20080210144352.GA3537@infradead.org> <47AF1321.7000107@panasas.com> <47AF4974.9010200@panasas.com> <47AF4BF5.90807@panasas.com> <20080212174808.GB26316@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13336 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758305AbYBLR4N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 12:56:13 -0500
In-Reply-To: <20080212174808.GB26316@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Feb 12 2008 at 19:48 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Feb 10, 2008 at 09:09:41PM +0200, Boaz Harrosh wrote:
>> - add varlen_cdb and varlen_cdb_len to hold a large user cdb
>>   if needed. They start as empty. Allocation of buffer must
>>   be done by user and held until request execution is done.
>> - Since there can be either a fix_length command up to 16 bytes
>>   or a variable_length, larger then 16 bytes, commands but never
>>   both, we hold the two types in a union to save space. The
>>   presence of varlen_cdb_len and cmd_len==0 signals a varlen_cdb
>>   mode.
> 
> this one I'm a bit confused by, why can't we just set the length
> of the variable length command in cmd_len aswell, and if cmd_len >
> the length of the cmd array it's a variable length command?
> 
> Note that this is both to keep the logic simpler and not to grow
> struct request further.  Especially for the rather rare case
> of a bidi command.

Because this will be dangerous for the Legacy block devices.
Unlike scsi drivers block drivers do not have a .max_cmnd_len
and upper layer will not check to make sure that the device supports
the longer command. If such a command goes through, lets say bsg
the drivers do blindly memcpy(,,rq->cmd_len) and will crash.
Better safe then sorry, at no cost.

Boaz

