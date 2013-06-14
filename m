From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v2 0/2] scsi: Port buslogic driver to 64 bits
Date: Fri, 14 Jun 2013 09:07:07 -0600
Message-ID: <1371222427.8771.1.camel@concerto>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36920 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3FNPHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jun 2013 11:07:11 -0400
In-Reply-To: <cover.1368754556.git.khalid.aziz@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 19:44 -0600, Khalid Aziz wrote:
> This patchset ports buslogic driver to 64-bit.
> 
> Current buslogic driver is composed of two components - SCCB manager
> which communicates with adapter to execute SCSI commands (contained in
> FlashPoint.c), and Linux driver part that interfaces with rest of the
> kernel (contained in BusLogic.c). SCCB manager code came from the
> Mylex SDK. SCCB manager code is used by flashpoint adapters only.
> Multimaster adapters do not need SCCB manager since the SCSI state
> machine is implemented in firmware on these adapters. If the filenames
> alone did not give it away already, buslogic driver code is full of
> CamelCase, besides being full of very ling lines, and is just very
> difficult to read and understand. So the first step was to clean up
> the existing code. First patch in the set does just that. Second patch
> includes necessary code modifications to allow the driver to build and
> run on 64-bit kernel. Since SCCB manager code came from Mylex SDK, I
> have tried to touch it only when necessary which includes not fixing
> all CamelCase issues in FlashPoint.c. Many lines over 80 characters
> remain in BusLogic.c. These fall into two categories generally -
> (1) it prints a message and I didn't want to touch driver messages
> in case there are scripts out there that parse driver messages,
> (2) code is indented deeply and is hard to keep it under 80 characters.
> Such code could use refactoring at some point.
> 
> I have tested this patch with a flashpoint adapter on 64-bit and 
> 32-bit kernels with fio running random read/write test while verifying
> data. I also measured performance for current buslogic driver and 
> buslogic driver with these patches with 32-bit and 64-bit kernel and
> ensured there was no degradation in performance.
> 
> Changelog:
> v2:
> 	- Updated to apply on top of current Linus' tree as of May 16, 2013. 
> 	  No functional changes.
> 
> Khalid Aziz (2):
>   Fix CamelCase and extra long lines in the buslogic driver.
>   Port buslogic driver to 64-bit.
> 
>  drivers/scsi/BusLogic.c   | 4452 ++++++++++++++++++++++++---------------------
>  drivers/scsi/BusLogic.h   | 1487 ++++++++-------
>  drivers/scsi/FlashPoint.c |  626 +++----
>  drivers/scsi/Kconfig      |    2 +-
>  4 files changed, 3377 insertions(+), 3190 deletions(-)
> 

Hello James,

Any feedback on this set of patches?

Thanks,
Khalid


