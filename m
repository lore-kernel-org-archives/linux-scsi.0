From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI reserve / release support for SG
Date: Fri, 14 Nov 2003 22:19:40 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB4C85C.9020907@torque.net>
References: <3FB4BC92.D43703BE@in.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:9999 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262432AbTKNMUA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 07:20:00 -0500
In-Reply-To: <3FB4BC92.D43703BE@in.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-scsi@vger.kernel.org

Sachin Sant wrote:
> Does Current sg driver offer SCSI reserve/release command in its 
> open/close function. 

No.

> I am trying to run on a SAN or Cluster environment
> which requires support for this reserve/release command.

BTW www.t10.org traffic suggests more sophisticated reserve/
release mechanisms are in the pipeline. IOWs a solution to
your problem now could be an impediment a few years down the
track.

> If not then are there any plans to support reserve/release SCSI command
> so that sg driver can provide these options for its users in its
> open/close function  It will make all I/O operation with sg driver more
> reliable especially in data storage area.

I'm getting this request from several angles. As someone
wryly pointed out ... as if we haven't got enough trouble
at the moment with the scsi subsystem implicitly issuing
scsi commands :-)

Seriously, I don't think issuing reserve/release SCSI commands
on the open and close of a pass-through interface is a good
idea. At a stretch it could be a non-default parameter on the
sg driver [lk 2.4 via /proc/scsi/sg; in lk 2.6 ...]


Just thinking about the implementation: currently sg will hold
its data structures alive if an unexpected close (e.g. user
control-C) occurs while a SCSI command is in flight. I guess
the point of what you are suggesting is to issue another scsi
command (i.e. release) in such a situation (and wait for
it (potentially as well as a command in progress)).

Doug Gilbert



