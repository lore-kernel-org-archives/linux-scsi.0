From: walter harms <wharms@bfs.de>
Subject: Re: [patch] target/iscsi: precedence bug in iscsit_set_dataout_sequence_values()
Date: Wed, 03 Oct 2012 10:00:55 +0200
Message-ID: <506BF0B7.9030807@bfs.de>
References: <20121002082248.GB12398@elgon.mountain> <1349209800.28145.66.camel@haakon2.linux-iscsi.org>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1349209800.28145.66.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Am 02.10.2012 22:30, schrieb Nicholas A. Bellinger:
> On Tue, 2012-10-02 at 11:22 +0300, Dan Carpenter wrote:
>> Clang warns about this bug:
>> drivers/target/iscsi/iscsi_target_erl0.c:52:45: warning: operator '?:'
>> 	has lower precedence than '+'; '+' will be evaluated first
>> 	[-Wparentheses]
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>> Please review this very carefully because I haven't tested it.  It could
>> be that the check should be:
>> (data_done + data_length > FirstBurstLength) ? FirstBurstLength : data_length);
>> Instead of what I have which is:
>> data_done + (data_length > FirstBurstLength ? FirstBurstLength : data_length);
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
>> index 1a02016..2067efd 100644
>> --- a/drivers/target/iscsi/iscsi_target_erl0.c
>> +++ b/drivers/target/iscsi/iscsi_target_erl0.c
>> @@ -48,9 +48,9 @@ void iscsit_set_dataout_sequence_values(
>>  	if (cmd->unsolicited_data) {
>>  		cmd->seq_start_offset = cmd->write_data_done;
>>  		cmd->seq_end_offset = (cmd->write_data_done +
>> -			(cmd->se_cmd.data_length >
>> -			 conn->sess->sess_ops->FirstBurstLength) ?
>> -			conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.data_length);
>> +			((cmd->se_cmd.data_length >
>> +			  conn->sess->sess_ops->FirstBurstLength) ?
>> +			 conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.data_length));
>>  		return;
>>  	}
>>  
>> --
> 
> This is indeed the original intention and your patch is correct, so
> applied to for-next.
> 
> Thank you!
> 
> --nab
> 

please consider rewriting this into an if ... else ... statement.
See my comments and Dan's reply on this.

re,
 wh
