From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 04 Mar 2007 10:51:36 -0600
Message-ID: <1173027096.3372.62.camel@mulgrave.il.steeleye.com>
References: <A67893E24596534CB03DD02157A7FBF7018D1691@NAMAIL2.ad.lsil.com>
	 <1173018667.3372.36.camel@mulgrave.il.steeleye.com>
	 <45EAE91F.5070206@cs.wisc.edu>
	 <1173023824.3372.53.camel@mulgrave.il.steeleye.com>
	 <45EAF1F7.9040102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52856 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbXCDQvx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 11:51:53 -0500
In-Reply-To: <45EAF1F7.9040102@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Sun, 2007-03-04 at 10:21 -0600, Mike Christie wrote:
> I think they get around this and other request settings that need
> resetting by using scsi_execute_async. They will take the command, data
> direction and buffer fields from the original scsi_cmnd, then pass those
> on to scsi_ececute_async which would allocate a new request and then as
> you know that new request gets sent to the scsi layer and looks like a
> brand new request. So I misspoke above. It might be better to say they
> are using it for routing what the other multipath layers would call
> cloned commands.

But actually, that's what I don't think they want to do.
scsi_execute_async() will try to map the sg list.  What they probably
get is a fully set up SCSI command which needs to be cloned to a new
device, so the request sg setup has already been done.  So what you need
to do is something like get a request for the new device, clone the
relevant parameters, set the flags to REQ_DONTPREP and inject it into
the correct queue.  You probably also need to clone the scsi_cmnd as
well.  Finally you need to chain the completions of the old and new
commands.  This should avoid having to setup and re tear down the
requests, while not using some kludgy mechanism like special commands.

However, obviously, this is speculation about the operation of an unseen
driver, which is not incredibly profitable ...

James


