From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 20/20] target: change alloc_task call to take *cdb, not
 *cmd
Date: Sun, 10 Jul 2011 15:41:51 -0700
Message-ID: <4E1A2AAF.6080705@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com> <1310174329-22228-21-git-send-email-agrover@redhat.com> <20110709101105.GA26456@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744Ab1GJWmA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2011 18:42:00 -0400
In-Reply-To: <20110709101105.GA26456@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/09/2011 03:11 AM, Christoph Hellwig wrote:
> On Fri, Jul 08, 2011 at 06:18:49PM -0700, Andy Grover wrote:
>> The transports really don't need the entire struct se_cmd to allocate
>> the memory for the se_task. If it wasn't for pscsi, they wouldn't even
>> need the *cdb.
>>
>> Modify pscsi to allocate space for cdb at the end of pscsi_plugin_task,
>> instead of a separate allocation.
> 
> Nice one!  Note that except for pscsi we really don't need se_tasks
> to start with.  I'm not sure how easy it is to move the whole task
> logic into it, but just allowing the other transports to allocate a
> single se_task + se_cmd + private data in one go should avoid one
> more memory allocation.

We can assume each se_cmd only needs 1 se_task???

I couldn't see where the max sectors per se_cmd was limited, therefore
we needed to support cmds being broken up into
se_sub_dev.max_sectors-size chunks, and therefore being >1 se_task per
se_cmd, for all backstores not just pscsi?

Regards -- Andy
