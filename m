From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] target/iscsi: precedence bug in
 iscsit_set_dataout_sequence_values()
Date: Tue, 2 Oct 2012 15:27:00 +0300
Message-ID: <20121002122700.GF13767@mwanda>
References: <20121002082248.GB12398@elgon.mountain>
 <506AD4A9.2050702@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:45185 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2JBM1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 08:27:19 -0400
Content-Disposition: inline
In-Reply-To: <506AD4A9.2050702@bfs.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, Oct 02, 2012 at 01:48:57PM +0200, walter harms wrote:
> 
> 
> Am 02.10.2012 10:22, schrieb Dan Carpenter:
> > Clang warns about this bug:
> > drivers/target/iscsi/iscsi_target_erl0.c:52:45: warning: operator '?:'
> > 	has lower precedence than '+'; '+' will be evaluated first
> > 	[-Wparentheses]
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Please review this very carefully because I haven't tested it.  It could
> > be that the check should be:
> > (data_done + data_length > FirstBurstLength) ? FirstBurstLength : data_length);
> > Instead of what I have which is:
> > data_done + (data_length > FirstBurstLength ? FirstBurstLength : data_length);
> > 
> > diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
> > index 1a02016..2067efd 100644
> > --- a/drivers/target/iscsi/iscsi_target_erl0.c
> > +++ b/drivers/target/iscsi/iscsi_target_erl0.c
> > @@ -48,9 +48,9 @@ void iscsit_set_dataout_sequence_values(
> >  	if (cmd->unsolicited_data) {
> >  		cmd->seq_start_offset = cmd->write_data_done;
> >  		cmd->seq_end_offset = (cmd->write_data_done +
> > -			(cmd->se_cmd.data_length >
> > -			 conn->sess->sess_ops->FirstBurstLength) ?
> > -			conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.data_length);
> > +			((cmd->se_cmd.data_length >
> > +			  conn->sess->sess_ops->FirstBurstLength) ?
> > +			 conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.data_length));
> >  		return;
> >  	}
> >  
> 
> the ?: operator is nice but at a certain length is starts to become unreadable,
> the end is normally calculated by end= start+len; Therefor i suggest:
> 
> if ( cmd->se_cmd.data_length > conn->sess->sess_ops->FirstBurstLength )
>    cmd->seq_end_offset = cmd->seq_start_offset + conn->sess->sess_ops->FirstBurstLength;
> else
>    cmd->seq_end_offset = cmd->seq_start_offset + cmd->se_cmd.data_length;
> 

Yeah.  It's not beautiful.

Doing a "struct iscsi_sess_ops *ops = conn->sess->sess_ops;" at the
start of the function would help as well.

regards,
dan carpenter

