From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bidirectional, long commands + OSD
Date: 30 Jan 2004 09:25:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075472734.1999.25.camel@mulgrave>
References: <OF04DCDB82.2269D90E-ON42256E2B.003249AE-42256E2B.003A8576@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:10402 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261270AbUA3OZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 09:25:37 -0500
In-Reply-To: <OF04DCDB82.2269D90E-ON42256E2B.003249AE-42256E2B.003A8576@il.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Liran Schour <LIRANS@il.ibm.com>
Cc: dougg@torque.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On Fri, 2004-01-30 at 05:39, Liran Schour wrote:
> Most of the HBAs today can't support execution of OSD SCSI commands due to
> the
> extended CDB's length and the bidirectional data movement. But when OSD
> technology
> will catch a momentum we will see more and more vendors that will support
> this features.
> My point is that maybe we can keep the current interface while expanding it
> to support
> the needed features by the SCSI OSD commands.

Actually, I'm sure they can.  Most HBA's operate using a scripted
firmware interface (like the LSI scripts or the Adaptec sequencer).  As
long as the scripts are updated, it's no trouble to support multiple
data pointers and large CDBs (even the 53c700, a 1990s era chip can do
this).  I also know seagate is working on an actual single disc that
supports OSD, so I expect even the closed firmware chip sets will
eventually be updated.

> I have used only ISCSI and TCP/IP (non SCSI) OSD devices. In the devices
> that
> I have used the transitions of data where isolated - first DATA OUT then
> DATA IN.
> But an OSD device can do the following data transitions: DATA IN (user
> data) ; DATA OUT
> (set attributes data and get attributes list) ;  DATA IN (retrieved
> attributes data).

Yes, that's what I feared.  The spec implies this as well.  Behaviour
like that requires two data pointers.

James


