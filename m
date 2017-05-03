From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] ibmvscsis: Do not send aborted task response
Date: Wed, 3 May 2017 11:38:05 -0500
Message-ID: <5c2536d3-7ff1-1e17-91c0-0be6a8befbfa@linux.vnet.ibm.com>
References: <1493751261-81647-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1493783006.23202.87.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1493783006.23202.87.camel@haakon3.risingtidesystems.com>
Sender: stable-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart.VanAssche@sandisk.com, martin.petersen@oracle.com, turtle.in.the.kernel@gmail.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Nick,

On 5/2/17 10:43 PM, Nicholas A. Bellinger wrote:

> On Tue, 2017-05-02 at 13:54 -0500, Bryant G. Ly wrote:
>> The driver is sending a response to the actual scsi op that was
>> aborted by an abort task TM, while LIO is sending a response to
>> the abort task TM.
>>
>> ibmvscsis_tgt does not send the response to the client until
>> release_cmd time. The reason for this was because if we did it
>> at queue_status time, then the client would be free to reuse the
>> tag for that command, but we're still using the tag until the
>> command is released at release_cmd time, so we chose to delay
>> sending the response until then. That then caused this issue, because
>> release_cmd is always called, even if queue_status is not.
>>
>> SCSI spec says that the initiator that sends the abort task
>> TM NEVER gets a response to the aborted op and with the current
>> code it will send a response. Thus this fix will remove that response
>> if the TAS bit is set.
>>
>> Cc: <stable@vger.kernel.org> # v4.8+
>> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
>> Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
>> ---
>>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 66 ++++++++++++++++++++++----------
>>   1 file changed, 45 insertions(+), 21 deletions(-)
> Applied, with a small update to the last sentence of the commit log wrt
> to 'if ABORTED && !TAS bit is set'.
>
> Thanks Bryant + Tyrel.
>
So I have been running tests on this patch extensively and it seems like after running 2 hrs of consecutive aborts it fails again with the same problem of driver sending a response to the actual scsi op.

It looks like when LIO processes the abort and if (!__target_check_io_state(se_cmd, se_sess, 0)) then rsp gets set as TMR_TASK_DOES_NOT_EXIST.

With that response the CMD_T_ABORTED state is not set, so then the ibmvscsis driver still sends that duplicate response.

I think the best solution would be in driver when queue_tm_rsp gets called and when the driver builds the response to check for the TMR_TASK_DOES_NOT_EXIST and set our own flag.
Then we would also check for that flag, so it would be:

if ((cmd->se_cmd.transport_state & CMD_T_ABORTED && !(cmd->se_cmd.transport_state & CMD_T_TAS)) || cmd->flags & CMD_ABORTED) {

This will ensure in the CMD_T_ABORTED w/o CMD_T_TAS scenarios are handled and the ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST case.

-Bryant
