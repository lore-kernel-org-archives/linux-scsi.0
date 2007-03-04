From: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Subject: RE: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 4 Mar 2007 11:00:39 -0700
Message-ID: <A67893E24596534CB03DD02157A7FBF7018D16BB@NAMAIL2.ad.lsil.com>
References: <45EAFCBF.9010406@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37249 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbXCDSBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 13:01:01 -0500
Content-class: urn:content-classes:message
In-Reply-To: <45EAFCBF.9010406@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

Do you think the following could work If I used blk layer functions
instead of "scsi_execute_async":

Blk_get_request()
Req->flags |= REQ_DONTPREP
Blk_rq_map_kern()
Blk_execute_req_nowait()
Blk_put_request() 

Regards,
Sudhir

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Sunday, March 04, 2007 11:07 AM
To: James Bottomley
Cc: Dachepalli, Sudhir; Benny Halevy; Jens Axboe; Boaz Harrosh;
linux-scsi@vger.kernel.org
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()

Mike Christie wrote:
> James Bottomley wrote:
>> On Sun, 2007-03-04 at 10:21 -0600, Mike Christie wrote:
>>> I think they get around this and other request settings that need 
>>> resetting by using scsi_execute_async. They will take the command, 
>>> data direction and buffer fields from the original scsi_cmnd, then 
>>> pass those on to scsi_ececute_async which would allocate a new 
>>> request and then as you know that new request gets sent to the scsi 
>>> layer and looks like a brand new request. So I misspoke above. It 
>>> might be better to say they are using it for routing what the other 
>>> multipath layers would call cloned commands.
>> But actually, that's what I don't think they want to do.
> 
> Yeah, you are right. Proper cloning is the better way to go.

I meant routing of commands and possibly cloning like you described, not
just cloning.
