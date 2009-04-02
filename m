From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/9] exofs: Kbuild, Headers and osd utils
Date: Thu, 02 Apr 2009 10:24:20 +0300
Message-ID: <49D46824.6020909@panasas.com>
References: <49D374A1.5010303@panasas.com> <1238594963-9880-1-git-send-email-bharrosh@panasas.com> <49D4111C.3010905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49D4111C.3010905@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>, Evgeniy Polyakov <zbr@ioremap.net>, Marcin Slusarz <marcin.slusarz@gmail.com>, Pavel Machek <pavel@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>, Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/02/2009 04:13 AM, Jeff Garzik wrote:
> Boaz Harrosh wrote:
>> This patch includes osd infrastructure that will be used later by
>> the file system.
>>
>> Also the declarations of constants, on disk structures,
>> and prototypes.
>>
>> And the Kbuild+Kconfig files needed to build the exofs module.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  fs/exofs/Kbuild   |   16 +++++
>>  fs/exofs/Kconfig  |   13 ++++
>>  fs/exofs/common.h |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/exofs/exofs.h  |  127 ++++++++++++++++++++++++++++++++++++
>>  fs/exofs/osd.c    |  153 ++++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 493 insertions(+), 0 deletions(-)
>>  create mode 100644 fs/exofs/Kbuild
>>  create mode 100644 fs/exofs/Kconfig
>>  create mode 100644 fs/exofs/common.h
>>  create mode 100644 fs/exofs/exofs.h
>>  create mode 100644 fs/exofs/osd.c
> 
> After building "osdblk", a block driver using libosd, it is my opinion 
> that all functions inside fs/exofs/osd.c should be moved to libosd.
> 
> I find myself copying most of that file, to use in osdblk.
> 
> 	Jeff
> 

Yes I agree

I have such patches queued on my oo-devel branch that remove
half, and a plan to remove the second half in a more generic
manner.

The problem with those left is that they set policy like the
parameters in the call to osd_finalize_request, but it
might be better to just fold these into osd_execute_*

My long time plan was to implement at first the lowest level
only, then over time when repeated recipes arise add them.
I guess "later" as arrived.

Thanks
Boaz
