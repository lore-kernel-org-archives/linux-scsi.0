From: Matt_Domsch@Dell.com
Subject: RE: megaraid 2.00rc5 -> kernel 2.5.41 diff
Date: Tue, 8 Oct 2002 12:59:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20BF5713E14D5B48AA289F72BD372D68C1E94A@AUSXMPC122.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com
Cc: linux-scsi@vger.kernel.org

> I do not have the megaraid 2.00rc5 source so I cannot see the
> context around this change, but the above looks incorrect as you
> do take into account that the page may have an offset.

Excellent point, and I'm not too familiar with what's happening here, hence
my fearful comment. :-)
The code is inside mega_cmd_done():

		if(cmd->cmnd[0] == INQUIRY) {
			int islogical = adapter->logdrv_chan[cmd->channel];

			if(!islogical) {
				if( cmd->use_sg ) {
					sgl = (struct scatterlist *)
						cmd->request_buffer;
					/* MLD - is this right??  */
					c = *(u8
*)page_address(sgl[0].page);
				}
				else {
					c = *(u8 *)cmd->request_buffer;
				}

				if(IS_RAID_CH(adapter, cmd->channel) &&
						((c & 0x1F ) == TYPE_DISK))
{
					status = 0xF0;
				}
			}
		}

It's reading the first byte of cmd->request_buffer, or if that's an SGL,
should probably be (page_address(sgl[0].page) + sgl[0].offset).

http://domsch.com/linux/megaraid/megaraid-v2.00rc5.tar.gz has the source,
there named megaraid.[ch], not megaraid2.[ch].

Thanks for the comments!

Thanks,
Matt


--
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

