From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 0/2] Prevent infinite retries due to DID_RESET return status
Date: Wed, 31 Jan 2007 12:54:06 -0600
Message-ID: <45C0E5CE.7040203@sgi.com>
References: <457DD0CA.9010509@sgi.com> <20070102121514.GA31621@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:45832 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932978AbXAaSyS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jan 2007 13:54:18 -0500
In-Reply-To: <20070102121514.GA31621@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>

I have implemented Christoph's suggestions and comments in his reply
to my RFC.
--------------------------------------------------------------------

Due to a firmware mismatch between a host and target (names withheld to
protect the innocent?), the LLDD was returning DID_RESET for every
i/o command.  This patch modifies the scsi layer to take into account
when the command which received DID_RESET was issued and eventually
give up on it instead of unconditionally reissuing it forever.
With this patch, on my test system, the command receiving the solid
DID_RESET times out after about 360 seconds.

The premise for this patch is that no command should have an infinite
lifetime.  The impetus for this patch was a system which would not
reach a command prompt without disconnecting the storage from the
host.

The significant change in this patch is to call scsi_queue_insert()
instead of scsi_requeue_command() if the command which receives a
DID_RESET did not complete any i/o (good_bytes==0).  scsi_queue_insert()
does not release the command and regenerate it like scsi_requeue_command()
does, hence jiffies_at_alloc reflects when the command was first issued.

Per Christoph's suggestion, I have broken this into two patches.  The
first implements the moving of the scsi_release_buffer() calls so that
it can be more easily reviewed.  The second patch implements the
lifetime timer for commands receiving DID_RESET.

These patches differ from the first posting in that scsi_queue_insert()
is called directly instead of calling the since removed scsi_retry_command();
comments have been cleaned up; and a comment has been added to indicate
that the code is supposed to fall through to call scsi_end_request()
if the command which received DID_RESET has expired.

These patches were tested by modifying a LLDD to return DID_RESET for
every command received.

Patches apply to 2.6.20-rc6-git1.

Signed-off-by: Michael Reed <mdr@sgi.com>

Christoph Hellwig wrote:
> On Mon, Dec 11, 2006 at 03:42:34PM -0600, Michael Reed wrote:
>> Due to a firmware mismatch between a host and target (names withheld to
>> protect the innocent?), the LLDD was returning DID_RESET for every
>> i/o command.  This patch modifies the scsi layer to take into account
>> when the command which received DID_RESET was issued and eventually
>> give up on it instead of unconditionally reissuing it forever
>> when it receives a DID_RESET.  With this patch, on my test system,
>> the command receiving the constant DID_RESET times out after about
>> 360 seconds.
>>
>> The premise for this patch is that no command should have an infinite
>> lifetime.  The impetus for this patch was a system which would not
>> reach a command prompt without disconnecting the storage from the
>> host.
>>
>> The significant change in this patch is to call scsi_retry_command()
>> instead of scsi_requeue_command() if the command which receives a
>> DID_RESET did not complete any i/o (good_bytes==0).  scsi_retry_command()
>> does not release the command and regenerate it like scsi_requeue_command()
>> does, hence jiffies_at_alloc reflects when the command was first issued.
> 
> Generally this patch looks good to me.  Some comments:
> 
> 
>> -extern int scsi_retry_command(struct scsi_cmnd *cmd);
>> +extern int scsi_retry_command(struct scsi_cmnd *cmd, int reason);
> 
> 	I've just sent a patch to kill scsi_retry_command.  Use
> 	scsi_queue_insert directly instead.
> 
>> +	scsi_release_buffers(cmd);
> 
> 	Can you please separate out the moving of the scsi_release_buffer
> 	calls into a separate patch so it can be audited better?
> 
>> @@ -961,9 +992,20 @@ void scsi_io_completion(struct scsi_cmnd
>>  		/* Third party bus reset or reset for error recovery
>>  		 * reasons.  Just retry the request and see what
>>  		 * happens.
>> +		 * If no data was transferred, just reissue this
>> +		 * command.  If data was transferred, regenerate
>> +		 * the command to transfer only untransferred data.
>>  		 */
> 
> The whole comment should look more like:
> 
> 		/*
> 		 * Third party bus reset or reset for error recovery reasons.
> 		 * If no data was transferred, just reissue this command.
> 		 * If data was transferred, regenerate the command to transfer
> 		 * only untransferred data.
> 		 */
> 
>> -		scsi_requeue_command(q, cmd);
>> -		return;
>> +		if (!good_bytes) {
>> +			if (!(scsi_command_expired(cmd))) {
>> +				scsi_retry_command(cmd, SCSI_MLQUEUE_DID_RESET);
>> +				return;
>> +			}
>> +		}
>> +		else {
>> +			scsi_requeue_command(q, cmd);
>> +			return;
>> +		}
> 
> 	With this code we now fallthrough if we don't have any good bytes
> 	and the command has expired.  Is this the expected behaviour? If
> 	yes we need a good comment describing it.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
