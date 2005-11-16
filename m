From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata error handling fixes (ATAPI)
Date: Wed, 16 Nov 2005 08:31:53 -0500
Message-ID: <437B34C9.8050105@pobox.com>
References: <20051114195717.GA24373@havoc.gtf.org> <20051115074148.GA17459@htj.dyndns.org> <4379AA5B.1060900@pobox.com> <4379B28E.9070708@gmail.com> <4379C062.3010302@pobox.com> <20051115120016.GD7787@suse.de> <437A2814.1060308@cs.wisc.edu> <20051115184131.GJ7787@suse.de> <20051116124035.GX7787@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051116124035.GX7787@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> I updated that patch, and converted IDE and SCSI to use it. See the
> results here:
> 
> http://brick.kernel.dk/git/?p=linux-2.6-block.git;a=shortlog;h=blk-softirq
> 
> The main change from the version posted last october is killing the
> 'slightly' overdesigned completion queue hashing.

Oh yeah:  you shouldn't need to make scsi_retry_command() exported. 
It's private to scsi, to just publish it in scsi_priv.h.

Tangent:  As part of my libata work, I'm thinking about un-exporting 
scsi_finish_command(), and instead exporting scsi_eh_flush_done_q() and 
scsi_eh_finish_cmd().

	Jeff


