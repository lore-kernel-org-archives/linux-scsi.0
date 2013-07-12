From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Fri, 12 Jul 2013 13:54:45 +0800
Message-ID: <51DF9A25.5030502@cn.fujitsu.com>
References: <1372661455-122384-1-git-send-email-hare@suse.de> <1373488528.7420.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25169 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3GLFuv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 01:50:51 -0400
In-Reply-To: <1373488528.7420.55.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

Hi, Ewan:

On 07/11/2013 04:35 AM, Ewan Milne wrote:
> On Mon, 2013-07-01 at 08:50 +0200, Hannes Reinecke wrote:
>> This patchset implements a new 'eh_deadline' attribute to the
>> SCSI host. It will limit the overall SCSI EH runtime by a given
>> timeout. If the timeout is reached all intermediate EH steps
>> will be skipped and host reset will be scheduled immediately.
>>
>> For this patch I've re-used the existing 'last_reset' field
>> of the SCSI host to store the initial time SCSI EH started.
>> Also the field 'resetting' has been removed as it never has
>> been used as intended.
>>
>> As 'last_reset' might be in use by transport-specific EH
>> implementation I've disallowed eh_deadline setting there.
>>
>> Changes from the initial version:
>> - Add list_splice_init() calls to avoid stale commands
>> - Rename function to scsi_host_eh_past_deadline
>>
>> Hannes Reinecke (7):
>>    dpt_i2o: Remove DPTI_STATE_IOCTL
>>    dpt_i2o: return SCSI_MLQUEUE_HOST_BUSY when in reset
>>    advansys: Remove 'last_reset' references
>>    tmscsim: Move 'last_reset' into host structure
>>    dc395: Move 'last_reset' into internal host structure
>>    scsi: remove check for 'resetting'
>>    scsi: Add 'eh_deadline' to limit SCSI EH runtime
>>
>>   drivers/scsi/advansys.c   |   8 +--
>>   drivers/scsi/dc395x.c     |  24 +++++----
>>   drivers/scsi/dpt_i2o.c    |  35 +++++--------
>>   drivers/scsi/dpti.h       |   1 -
>>   drivers/scsi/hosts.c      |   7 +++
>>   drivers/scsi/scsi.c       |  28 ----------
>>   drivers/scsi/scsi_error.c | 130 +++++++++++++++++++++++++++++++++++++++++++---
>>   drivers/scsi/scsi_sysfs.c |  37 +++++++++++++
>>   drivers/scsi/tmscsim.c    |  14 ++---
>>   drivers/scsi/tmscsim.h    |   1 +
>>   include/scsi/scsi_host.h  |   4 +-
>>   11 files changed, 208 insertions(+), 81 deletions(-)
>>
> Looks good.  We have been testing this extensively.

I'm wondering how do you test, with a special hardware or self-made
module?Would you mind pasting your test method() and result?

Thanks,
Ren

>
> Acked-by: Ewan D. Milne<emilne@redhat.com>

