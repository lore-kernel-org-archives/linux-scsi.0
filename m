From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 28/43] hpsa: don't return abort request until target
 is complete
Date: Fri, 17 Apr 2015 15:43:09 +0200
Message-ID: <55310DED.1020006@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134915.30238.86273.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbbDQNng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:43:36 -0400
In-Reply-To: <20150416134915.30238.86273.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>
> Don't return from the abort request until the target command is complete.
> Mark outstanding commands which have a pending abort, and do not send them
> to the host if we can avoid it.
>
> If the current command has been aborted, do not call the SCSI command
> completion routine from the I/O path: when the abort returns successfully,
> the SCSI mid-layer will handle the completion implicitly.
>
> The following race was possible in theory.
>
> 1. LLD is requested to abort a scsi command
> 2. scsi command completes
> 3. The struct CommandList associated with 2 is made available.
> 4. new io request to LLD to another LUN re-uses struct CommandList
> 5. abort handler follows scsi_cmnd->host_scribble and
>    finds struct CommandList and tries to aborts it.
>
> Now we have aborted the wrong command.
>
> Fix by resetting the scsi_cmd field of struct CommandList
> upon completion and making the abort handler check that
> the scsi_cmd pointer in the CommadList struct matches the
> scsi_cmnd that it has been asked to abort.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


