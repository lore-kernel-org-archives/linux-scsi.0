From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH 4/6] st: call scsi_set_medium_removal directly
Date: Sun, 9 Nov 2014 21:18:49 +0200
Message-ID: <2F731E1F-FA60-499E-B074-5D2C018AF969@kolumbus.fi>
References: <1414661229-15199-1-git-send-email-hch@lst.de> <1414661229-15199-5-git-send-email-hch@lst.de> <94D0CD8314A33A4D9D801C0FE68B402959378554@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:57696 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKITS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 14:18:57 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402959378554@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>


> On 7.11.2014, at 1.54, Elliott, Robert (Server Storage) <Elliott@hp.com> wrote:
> 
...
> 3. Reviewing the callers, st_release has an initialized
> result variable but does nothing else with it but return it:
> 	int result = 0;
> 	...
> 	return result;
> 
> It ignores the do_door_lock -> scsi_set_medium_removal
> result (like many others).
> 
The return code for automatic door locking/unlocking has been ignored on purpose. It is returned to caller for explicit door locking/unlocking. One can, of course, revise this decision.

The return value of release() is ignored by VFS. The proper fix would probably be to define release() void.

Thanks,
Kai

