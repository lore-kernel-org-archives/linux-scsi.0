From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Ensure the connector_name string is NUL-terminated
Date: Mon, 08 Aug 2016 21:10:20 -0400
Message-ID: <yq1invavjb7.fsf@sermon.lab.mkp.net>
References: <8b53a29b3ec90c9a7030e8fa3e1555ad5802dce9.1469680625.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38758 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcHIBKd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 21:10:33 -0400
In-Reply-To: <8b53a29b3ec90c9a7030e8fa3e1555ad5802dce9.1469680625.git.calvinowens@fb.com>
	(Calvin Owens's message of "Wed, 27 Jul 2016 21:45:51 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

>>>>> "Calvin" == Calvin Owens <calvinowens@fb.com> writes:

Calvin> We blindly trust the hardware to give us NUL-terminated strings,
Calvin> which is a bad idea because it doesn't always do that. For
Calvin> example:

Calvin>   [ 481.184784] mpt3sas_cm0: enclosure level(0x0000), connector
Calvin> name( \x3)

Calvin> In this case, connector_name is four spaces. We got lucky here
Calvin> because the 2nd byte beyond our character array happens to be a
Calvin> NUL. Fix this by explicitly writing '\0' to the end of the
Calvin> string to ensure we don't run off the edge of the world in
Calvin> printk().

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
