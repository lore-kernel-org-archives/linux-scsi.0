From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (3/4)
Date: 11 Feb 2003 16:38:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1045003141.4253.22.camel@mulgrave>
References: <20030211081351.GA1368@beaverton.ibm.com>
	<20030211081536.GB1368@beaverton.ibm.com>
	<20030211081744.GC1368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA18405
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 14:39:04 -0800
In-Reply-To: <20030211081744.GC1368@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-02-11 at 02:17, Mike Anderson wrote:
> This patch series is against scsi-misc-2.5.
> 
> 02_serror-hndlr-1.diff:
> 	- Change to using eh_cmd_list.
> 	- Change scsi_unjam_host to get sense, abort cmds, ready
> 	  devices, and disposition cmds for retry or finish.
> 	- Moved retries outside of eh.
> 
> -andmike

I have some qualms about the locking: you protect the eh_cmd_list with
the host_lock when adding, but not when traversing in the eh_thread.  I
know this is because the eh_thread has quiesced the host before
beginning, thus there should theoretically be no returning commmands to
tamper with the list while the eh_thread is using it.  However, I think
it might be worthwhile pointing this out in a comment over the
list_for_each_entry().

James

