From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/1] aacraid: prevent ZERO_SIZE_PTR dereference
Date: Thu, 31 Oct 2013 12:44:58 +0300
Message-ID: <20131031094458.GL20521@mwanda>
References: <1383208262-3203-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48985 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3JaJpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2013 05:45:55 -0400
Content-Disposition: inline
In-Reply-To: <1383208262-3203-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, aacraid@adaptec.com, aacraid@pmc-sierra.com, Achim.Leubner@pmcs.com, Tony.Ruiz@pmcs.com

On Thu, Oct 31, 2013 at 02:01:02PM +0530, Mahesh Rajashekhara wrote:
> It appears that driver runs into a problem here if fibsize is too small because we allocate user_srbcmd with fibsize size only but later we access it until user_srbcmd->sg.count to copy it over to srbcmd. Seems to be not correct to test (fibsize < sizeof(*user_srbcmd)) because this structure already includes one sg element and this is not needed for commands without data. So, we would recommend to add the following (instead of test for fibsize == 0).
> 

Don't forget the reported by tags.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>

regards,
dan carpenter

