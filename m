From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: CmdSN greather than MaxCmdSN protocol error in LIO Iser
Date: Tue, 12 Nov 2013 09:43:27 -0600
Message-ID: <52824C9F.4000500@cs.wisc.edu>
References: <697D97E420EE024FB7451B574CD4991BCA064554@NTXBOIMBX05.micron.com>  <1384204653.12281.7.camel@haakon3.risingtidesystems.com>  <1384216960.12281.24.camel@haakon3.risingtidesystems.com>  <1384217317.12281.26.camel@haakon3.risingtidesystems.com>  <1384219874.12281.42.camel@haakon3.risingtidesystems.com>  <B9FFC16A-0592-498D-A7C3-7ABB3EFA61FD@cs.wisc.edu>  <541331AC-770C-4AB8-ACB0-4964F76F9F1E@cs.wisc.edu> <1384230893.12281.72.camel@haakon3.risingtidesystems.com> <52824B3C.10203@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41616 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3KLPnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Nov 2013 10:43:41 -0500
In-Reply-To: <52824B3C.10203@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Moussa Ba (moussaba)" <moussaba@micron.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 11/12/13 9:37 AM, Mike Christie wrote:
>>
>>          if (max_cmdsn != session->max_cmdsn &&
>>              !iscsi_sna_lt(max_cmdsn, session->max_cmdsn)) {
>>                  session->max_cmdsn = max_cmdsn;
>>                  /*
>>                   * if the window closed with IO queued, then kick the
>>                   * xmit thread
>>                   */
>>                  if (!list_empty(&session->leadconn->cmdqueue) ||
>>                      !list_empty(&session->leadconn->mgmtqueue))
>>                          iscsi_conn_queue_work(session->leadconn);
>>          }
>> }
>>
>> Once iscsi_conn_queue_work() is invoked here to start process context
>> execution of iscsi_xmitworker() -> iscsi_data_xmit() code, AFAICT there
>> is no logic in place within iscsi_data_xmit() to honor the last received
>> MaxCmdSN.
>>
>> Or to put it another way: what is preventing iscsi_data_xmit() from
>> completely draining both conn->cmdqueue + conn->requeue, even when the
>> CmdSN window has potentially been closed again..?
>>
>
> If the window was not big enough we would have not accepted the cmd from
> scsi-ml in iscsi_queuecommand. We would have never put it on the list
> above then.

Oh yeah, if you are asking yourself why that code exists then, it is 
because we used to internally queue cmds when the window closed. In 
iscsi_data_xmit we then checked the window like in your patch. We 
switched to having the scsi layer queue for us, but that code above got 
left there.

Or sent a patch the other day to remove it:
http://marc.info/?l=linux-scsi&m=138288022619303&w=2
