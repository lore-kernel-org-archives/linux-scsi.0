From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/10] aacraid: Fix RRQ overload
Date: Fri, 4 Dec 2015 15:11:50 +0100
Message-ID: <56619F26.70708@redhat.com>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1448973589-9216-3-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbbLDOLx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2015 09:11:53 -0500
In-Reply-To: <1448973589-9216-3-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

On 1.12.2015 13:39, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>
> The driver utilizes an array of atomic variables to keep track of
> IO submissions to each vector. To submit an IO multiple threads
> iterate through the array to find a vector which has empty slots
> to send an IO. The reading and updating of the variable is not atomic,
> causing race conditions when a thread uses a full vector to
> submit an IO.
>
> Fixed by mapping each FIB to a vector, the submission path then uses
> said vector to submit IO thereby removing the possibly of a race
> condition.The vector assignment is started from 1 since vector 0 is
> reserved for the use of AIF management FIBS.If the number of MSIx
> vectors is 1 (MSI or INTx mode) then all the fibs are allocated to
> vector 0.
>
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

