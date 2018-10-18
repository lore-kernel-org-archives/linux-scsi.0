From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: ips: fix missing break in switch
Date: Thu, 18 Oct 2018 13:37:24 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810181319590.8@nippy.intranet>
References: <20181016091223.GA19765@embeddedor.com> <yq1ftx5sgw1.fsf@oracle.com> <alpine.LNX.2.21.1810170922480.130@nippy.intranet> <yq1r2gppdyf.fsf@oracle.com> <alpine.LNX.2.21.1810171327290.8@nippy.intranet> <yq1tvlkkr02.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1tvlkkr02.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 17 Oct 2018, Martin K. Petersen wrote:

> 
> >> See the case statements above for another fast exit scenario.
> >> 
> >
> > But that's an error path.
> 
> Look further down. Several other SCSI commands are completed as NOPs the 
> same way.
> 

That's true, but it doesn't indicate a bug to me.

On the contrary, the entire switch (scb->scsi_cmd->cmnd[0]) statement in 
ips_send_cmd() appears to be carefully constructed, just like the matching 
statement in ips_chkstatus().

But none of these indications can decide the question. We just don't have 
enough information. (I'm sure that someone somewhere does have the 
relevant technical information...)

If this really is undecidable, then I think the right patch is the more 
prudent one. That is, add a "fall through" comment, not a "break" 
statement.

Or perhaps a "fall through (TODO: check this)" comment.

> Also, I don't see how the case statement for TUR/INQUIRY would do 
> anything meaningful in terms of preparing a START STOP UNIT for the 
> firmware.
> 

If SSU case doesn't do anything meaningful, then neither does the 
TUR/INQUIRY case, and then you can just delete all of that code:

                        } else {
                                scb->cmd.logical_info.op_code = IPS_CMD_GET_LD_INFO;
                                scb->cmd.logical_info.command_id = IPS_COMMAND_ID(ha, scb);
                                scb->cmd.logical_info.reserved = 0;
                                scb->cmd.logical_info.reserved2 = 0;
                                scb->data_len = sizeof (IPS_LD_INFO);
                                scb->data_busaddr = ha->logical_drive_info_dma_addr;
                                scb->flags = 0;
                                scb->cmd.logical_info.buffer_addr = scb->data_busaddr;
                                ret = IPS_SUCCESS;
                        }

FWIW, I think this line of reasoning is mistaken.

-- 
