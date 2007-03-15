From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/4] iscsi class, qla4xxx and libiscsi: export iscsi session
 state in sysfs
Date: Thu, 15 Mar 2007 09:20:26 -0500
Message-ID: <45F9562A.7030307@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <45F9430A.9010309@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43428 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422717AbXCOOUo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 10:20:44 -0400
In-Reply-To: <45F9430A.9010309@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> 
> 
> 
> 
>> @@ -1768,7 +1781,8 @@ static void iscsi_start_session_recovery
>>       * flush queues.
>>       */
>>      spin_lock_bh(&session->lock);
>> -    fail_all_commands(conn);
>> +    fail_all_commands(conn,
>> +            STOP_CONN_RECOVER ? DID_BUS_BUSY : DID_ERROR);
>>      flush_control_queues(session, conn);
>>      spin_unlock_bh(&session->lock);
>>  
> 
> I'm assuming you do not support error recovery level 2, right ?
> 

Yeah, we only do erl0 right now.

>> +int iscsi_session_chkready(struct iscsi_cls_session *session)
> ...
>> +EXPORT_SYMBOL_GPL(iscsi_session_chkready);
> 
> Any reason this isn't an inline ?
> 

No, will make it inline.
