From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 04 Mar 2007 10:21:11 -0600
Message-ID: <45EAF1F7.9040102@cs.wisc.edu>
References: <A67893E24596534CB03DD02157A7FBF7018D1691@NAMAIL2.ad.lsil.com>	 <1173018667.3372.36.camel@mulgrave.il.steeleye.com>	 <45EAE91F.5070206@cs.wisc.edu> <1173023824.3372.53.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46701 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXCDQWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 11:22:01 -0500
In-Reply-To: <1173023824.3372.53.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2007-03-04 at 09:43 -0600, Mike Christie wrote:
>> There are trying to do a scsi level multipath driver for RDAC support.
>> And they are trying to do something similar to request based multipath
>> (route requests instead of bios but in their case they are routing
>> scsi_cmnds instead of requests).
> 
> I guessed it might be something like that ... 
> 
> The SCSI driver layer wasn't designed to stack like that ... hence the
> problems of setup and teardown of the sg list.  Wouldn't it just be
> easier to make request based multi-path work?  Unfortunately, you can't
> avoid the request system because what you want to do is resubmit an I/O
> without having the mid-layer execute the prepare function (which is
> where it's mapped) so you need the REQ_DONTPREP flag.
> 

I think they get around this and other request settings that need
resetting by using scsi_execute_async. They will take the command, data
direction and buffer fields from the original scsi_cmnd, then pass those
on to scsi_ececute_async which would allocate a new request and then as
you know that new request gets sent to the scsi layer and looks like a
brand new request. So I misspoke above. It might be better to say they
are using it for routing what the other multipath layers would call
cloned commands.
