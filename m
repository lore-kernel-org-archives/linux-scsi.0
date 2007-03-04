From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 04 Mar 2007 11:07:11 -0600
Message-ID: <45EAFCBF.9010406@cs.wisc.edu>
References: <A67893E24596534CB03DD02157A7FBF7018D1691@NAMAIL2.ad.lsil.com>	 <1173018667.3372.36.camel@mulgrave.il.steeleye.com>	 <45EAE91F.5070206@cs.wisc.edu>	 <1173023824.3372.53.camel@mulgrave.il.steeleye.com>	 <45EAF1F7.9040102@cs.wisc.edu> <1173027096.3372.62.camel@mulgrave.il.steeleye.com> <45EAFC0D.3020701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46765 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbXCDRHb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 12:07:31 -0500
In-Reply-To: <45EAFC0D.3020701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> James Bottomley wrote:
>> On Sun, 2007-03-04 at 10:21 -0600, Mike Christie wrote:
>>> I think they get around this and other request settings that need
>>> resetting by using scsi_execute_async. They will take the command, data
>>> direction and buffer fields from the original scsi_cmnd, then pass those
>>> on to scsi_ececute_async which would allocate a new request and then as
>>> you know that new request gets sent to the scsi layer and looks like a
>>> brand new request. So I misspoke above. It might be better to say they
>>> are using it for routing what the other multipath layers would call
>>> cloned commands.
>> But actually, that's what I don't think they want to do.
> 
> Yeah, you are right. Proper cloning is the better way to go.

I meant routing of commands and possibly cloning like you described, not
just cloning.
