From: Liran Schour <LIRANS@il.ibm.com>
Subject: Re: bidirectional, long commands + OSD
Date: Fri, 30 Jan 2004 12:39:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF04DCDB82.2269D90E-ON42256E2B.003249AE-42256E2B.003A8576@il.ibm.com>
References: <1075396141.2381.65.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:44457 "EHLO
	mtagate7.uk.ibm.com") by vger.kernel.org with ESMTP id S262078AbUA3Kj4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 05:39:56 -0500
In-Reply-To: <1075396141.2381.65.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org






James Bottomley wrote in thread:
   bidirectional, long commands + OSD:

>On Thu, 2004-01-29 at 11:08, Liran Schour wrote:
>> A single buffer for both data in and data out will force the user to
>> re-copy the buffer.
>> We can solve it by using a scatter-gather list. Each buffer will have
its
>> own data
>> direction flag.

>This is not necessarily true.  Just because it's a single buffer doesn't
>mean that the read and write areas cannot be separated inside it.  The
>actual implementation in most drivers uses a single data pointer, so if
>the device starts with DATA IN and transitions to DATA OUT, you should
>get the output data beginning directly after the input data.

>I know the spec implies that you keep two data pointers (because the
>device is allowed to do the DATA IN<->DATA OUT transition many times),
>so possibly we can't get away with something simple as above, but
>implementing separate data pointers would require modifying every
>driver.

Most of the HBAs today can't support execution of OSD SCSI commands due to
the
extended CDB's length and the bidirectional data movement. But when OSD
technology
will catch a momentum we will see more and more vendors that will support
this features.
My point is that maybe we can keep the current interface while expanding it
to support
the needed features by the SCSI OSD commands.

>which OSD devices have you used?  Just ISCSI one's, I assume; what do
>they do with the data in/out transitions?

I have used only ISCSI and TCP/IP (non SCSI) OSD devices. In the devices
that
I have used the transitions of data where isolated - first DATA OUT then
DATA IN.
But an OSD device can do the following data transitions: DATA IN (user
data) ; DATA OUT
(set attributes data and get attributes list) ;  DATA IN (retrieved
attributes data).

- Liran

