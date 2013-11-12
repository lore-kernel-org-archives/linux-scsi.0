From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: CmdSN greather than MaxCmdSN protocol error in LIO Iser
Date: Tue, 12 Nov 2013 09:27:28 +0200
Message-ID: <5281D860.9010605@mellanox.com>
References: <697D97E420EE024FB7451B574CD4991BCA064554@NTXBOIMBX05.micron.com>	 <1384204653.12281.7.camel@haakon3.risingtidesystems.com>	 <1384216960.12281.24.camel@haakon3.risingtidesystems.com>	 <1384217317.12281.26.camel@haakon3.risingtidesystems.com>	 <1384219874.12281.42.camel@haakon3.risingtidesystems.com>	 <B9FFC16A-0592-498D-A7C3-7ABB3EFA61FD@cs.wisc.edu>	 <541331AC-770C-4AB8-ACB0-4964F76F9F1E@cs.wisc.edu> <1384230893.12281.72.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384230893.12281.72.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Michael Christie <michaelc@cs.wisc.edu>
Cc: "Moussa Ba (moussaba)" <moussaba@micron.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/11/2013 06:34, Nicholas A. Bellinger wrote:
> Once iscsi_conn_queue_work() is invoked here to start process context
> execution of iscsi_xmitworker() -> iscsi_data_xmit() code, AFAICT there
> is no logic in place within iscsi_data_xmit() to honor the last received
> MaxCmdSN.
>
> Or to put it another way: what is preventing iscsi_data_xmit() from
> completely draining both conn->cmdqueue + conn->requeue, even when the
> CmdSN window has potentially been closed again..?

Guys,

Note that the iser initiator transport uses the pass-through command 
submission mode of libiscsi, that is
iscsi_conn_queue_work isn't called from queuecommand at all.

This is b/c we call iscsi_host_allocwith xmit_can_sleep = 0. Hence no 
workqueue is used for the command processing/submission over the wire, 
just a call toiscsi_prep_scsi_cmd_pdu and following that to iser's 
xmit_task callbackwhich isiscsi_iser_task_xmit that calls 
iser_send_command, etc.

Mike, Nic is not using the new locking framework patches for libiscsi, 
as you know they are not upstream
yet...

Or.
