From: walter harms <wharms@bfs.de>
Subject: Re: [patch] target/iscsi: precedence bug in iscsit_set_dataout_sequence_values()
Date: Tue, 02 Oct 2012 13:48:57 +0200
Message-ID: <506AD4A9.2050702@bfs.de>
References: <20121002082248.GB12398@elgon.mountain>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20121002082248.GB12398@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Am 02.10.2012 10:22, schrieb Dan Carpenter:
> Clang warns about this bug:
> drivers/target/iscsi/iscsi_target_erl0.c:52:45: warning: operator '?:'
> 	has lower precedence than '+'; '+' will be evaluated first
> 	[-Wparentheses]
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Please review this very carefully because I haven't tested it.  It could
> be that the check should be:
> (data_done + data_length > FirstBurstLength) ? FirstBurstLength : data_length);
> Instead of what I have which is:
> data_done + (data_length > FirstBurstLength ? FirstBurstLength : data_length);
> 
> diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
> index 1a02016..2067efd 100644
> --- a/drivers/target/iscsi/iscsi_target_erl0.c
> +++ b/drivers/target/iscsi/iscsi_target_erl0.c
> @@ -48,9 +48,9 @@ void iscsit_set_dataout_sequence_values(
>  	if (cmd->unsolicited_data) {
>  		cmd->seq_start_offset = cmd->write_data_done;
>  		cmd->seq_end_offset = (cmd->write_data_done +
> -			(cmd->se_cmd.data_length >
> -			 conn->sess->sess_ops->FirstBurstLength) ?
> -			conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.data_length);
> +			((cmd->se_cmd.data_length >
> +			  conn->sess->sess_ops->FirstBurstLength) ?
> +			 conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.data_length));
>  		return;
>  	}
>  

the ?: operator is nice but at a certain length is starts to become unreadable,
the end is normally calculated by end= start+len; Therefor i suggest:

if ( cmd->se_cmd.data_length > conn->sess->sess_ops->FirstBurstLength )
   cmd->seq_end_offset = cmd->seq_start_offset + conn->sess->sess_ops->FirstBurstLength;
else
   cmd->seq_end_offset = cmd->seq_start_offset + cmd->se_cmd.data_length;

just my 2 cents,
re,
 wh
