From: Doug Ledford <dledford@redhat.com>
Subject: Re: building SCSI CDB over FC
Date: Fri, 8 Nov 2002 18:12:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108231244.GI26518@redhat.com>
References: <F10FGcbNZOBPr0ebmeG00001ecf@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F10FGcbNZOBPr0ebmeG00001ecf@hotmail.com>
List-Id: linux-scsi@vger.kernel.org
To: shankar krishna <kshan01@hotmail.com>
Cc: aksumit@india.hp.com, linux-scsi@vger.kernel.org

On Fri, Nov 08, 2002 at 02:03:16PM -0700, shankar krishna wrote:
> Sumit:
> You are correct. I sent the
> following command to send the
> CDB. It did send correctly.
> 
> if (ioctl(sd_fd,SCSI_IOCTL_SEND_COMMAND,&cdb_buf))
> {
> /* ERROR */
> }
> 
> where cdb_buf is of type Scsi_Ioctl_Command.
> 
> DGilbert:
> "
> Notes:
> The SCSI command length is determined by examining the 1st byte of the 
> given command [1] . There is no way to override this.
> "
> 
> The above claim that 1st octet should be the length
> of CDB is not true...In the analyser I could see
> that "if I sent the length of CDB it is sending
> it as OPCODE" which essentially is the first byte.
> 
> You may want to correct it in the
> document(www.torque.net/sg) that you
> told me. It was very useful.

I believe you are mis-interpreting the documentation.  The first byte of 
the command is the opcode, and with scsi_ioctl_send_command the code reads 
the opcode and looks it up in a table to determine the length of the scsi 
command, and that length is the length that can't be over-ridden.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
